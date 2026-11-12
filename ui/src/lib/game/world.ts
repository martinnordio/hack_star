import type { Arena, Circle, Rect } from './arena'

export const PLAYER_RADIUS = 0.5
export const PLAYER_SPEED = 6
export const SHOT_RADIUS = 0.25
export const SHOT_SPEED = 16
export const SHOT_RANGE = 9
export const FIRE_COOLDOWN = 0.35
export const SHOT_DAMAGE = 480
export const DUMMY_RADIUS = 0.6
export const DUMMY_HEALTH = 2400
export const RESPAWN_SECONDS = 5

export interface Shot {
  id: number
  x: number
  z: number
  dx: number
  dz: number
  travelled: number
}

export interface Dummy {
  id: number
  x: number
  z: number
  health: number
  brokenAt: number | null
}

export type WorldEvent =
  | { type: 'fire'; x: number; z: number; dx: number; dz: number }
  | { type: 'hit'; dummyId: number; x: number; z: number; damage: number }
  | { type: 'break'; dummyId: number; x: number; z: number }
  | { type: 'respawn'; dummyId: number }
  | { type: 'blocked'; x: number; z: number }

/** Push a circle out of a rectangle; returns true if it overlapped. */
function pushOutOfRect(p: { x: number; z: number }, r: number, rect: Rect): boolean {
  const left = rect.x - rect.w / 2
  const right = rect.x + rect.w / 2
  const top = rect.z - rect.d / 2
  const bottom = rect.z + rect.d / 2
  const cx = Math.max(left, Math.min(p.x, right))
  const cz = Math.max(top, Math.min(p.z, bottom))
  const dx = p.x - cx
  const dz = p.z - cz
  const dist = Math.hypot(dx, dz)
  if (dist >= r) return false
  if (dist > 0) {
    p.x = cx + (dx / dist) * r
    p.z = cz + (dz / dist) * r
    return true
  }
  // Centre inside the rectangle: leave by the nearest side.
  const exits = [p.x - left + r, right - p.x + r, p.z - top + r, bottom - p.z + r]
  const i = exits.indexOf(Math.min(...exits))
  if (i === 0) p.x = left - r
  else if (i === 1) p.x = right + r
  else if (i === 2) p.z = top - r
  else p.z = bottom + r
  return true
}

function overlapsRect(x: number, z: number, r: number, rect: Rect): boolean {
  const cx = Math.max(rect.x - rect.w / 2, Math.min(x, rect.x + rect.w / 2))
  const cz = Math.max(rect.z - rect.d / 2, Math.min(z, rect.z + rect.d / 2))
  return Math.hypot(x - cx, z - cz) < r
}

const inside = (x: number, z: number, c: Circle) => Math.hypot(x - c.x, z - c.z) < c.r

export class World {
  time = 0
  player: { x: number; z: number; facing: number }
  shots: Shot[] = []
  dummies: Dummy[]
  /** Things that happened since the last `drainEvents()`, for effects. */
  private events: WorldEvent[] = []
  private lastFire = -Infinity
  private nextShotId = 1

  constructor(readonly arena: Arena) {
    this.player = { x: arena.start.x, z: arena.start.z, facing: 0 }
    this.dummies = arena.dummies.map((d, id) => ({ id, x: d.x, z: d.z, health: DUMMY_HEALTH, brokenAt: null }))
  }

  /** Move by a direction (length ≤ 1 is a partial push, like a joystick) for `dt` seconds. */
  move(dx: number, dz: number, dt: number) {
    const length = Math.hypot(dx, dz)
    if (length === 0) return
    const scale = length > 1 ? 1 / length : 1
    const p = this.player
    p.x += dx * scale * PLAYER_SPEED * dt
    p.z += dz * scale * PLAYER_SPEED * dt
    p.facing = Math.atan2(dx, dz)
    this.resolvePlayer()
  }

  private resolvePlayer() {
    const p = this.player
    for (const wall of this.arena.walls) pushOutOfRect(p, PLAYER_RADIUS, wall)
    for (const d of this.dummies) {
      if (d.brokenAt !== null) continue
      const dx = p.x - d.x
      const dz = p.z - d.z
      const dist = Math.hypot(dx, dz)
      const min = PLAYER_RADIUS + DUMMY_RADIUS
      if (dist < min && dist > 0) {
        p.x = d.x + (dx / dist) * min
        p.z = d.z + (dz / dist) * min
      }
    }
    const maxX = this.arena.width / 2 - PLAYER_RADIUS
    const maxZ = this.arena.depth / 2 - PLAYER_RADIUS
    p.x = Math.max(-maxX, Math.min(maxX, p.x))
    p.z = Math.max(-maxZ, Math.min(maxZ, p.z))
  }

  canFire(): boolean {
    return this.time - this.lastFire >= FIRE_COOLDOWN
  }

  /** Fire towards a direction; returns false while cooling down. */
  fire(dx: number, dz: number): boolean {
    const length = Math.hypot(dx, dz)
    if (length === 0 || !this.canFire()) return false
    dx /= length
    dz /= length
    this.lastFire = this.time
    const p = this.player
    p.facing = Math.atan2(dx, dz)
    const x = p.x + dx * (PLAYER_RADIUS + 0.2)
    const z = p.z + dz * (PLAYER_RADIUS + 0.2)
    this.shots.push({ id: this.nextShotId++, x, z, dx, dz, travelled: 0 })
    this.events.push({ type: 'fire', x, z, dx, dz })
    return true
  }

  step(dt: number) {
    this.time += dt
    const halfW = this.arena.width / 2
    const halfD = this.arena.depth / 2
    this.shots = this.shots.filter((s) => {
      const distance = SHOT_SPEED * dt
      s.x += s.dx * distance
      s.z += s.dz * distance
      s.travelled += distance
      const target = this.dummies.find(
        (d) => d.brokenAt === null && Math.hypot(s.x - d.x, s.z - d.z) < DUMMY_RADIUS + SHOT_RADIUS,
      )
      if (target) {
        this.hit(target)
        return false
      }
      const blocked =
        this.arena.walls.some((w) => overlapsRect(s.x, s.z, SHOT_RADIUS, w)) ||
        Math.abs(s.x) > halfW ||
        Math.abs(s.z) > halfD
      if (blocked || s.travelled >= SHOT_RANGE) {
        this.events.push({ type: 'blocked', x: s.x, z: s.z })
        return false
      }
      return true
    })
    for (const d of this.dummies) {
      if (d.brokenAt !== null && this.time - d.brokenAt >= RESPAWN_SECONDS) {
        d.brokenAt = null
        d.health = DUMMY_HEALTH
        this.events.push({ type: 'respawn', dummyId: d.id })
      }
    }
  }

  private hit(d: Dummy) {
    const damage = Math.min(SHOT_DAMAGE, d.health)
    d.health -= damage
    this.events.push({ type: 'hit', dummyId: d.id, x: d.x, z: d.z, damage: SHOT_DAMAGE })
    if (d.health <= 0) {
      d.brokenAt = this.time
      this.events.push({ type: 'break', dummyId: d.id, x: d.x, z: d.z })
    }
  }

  inBush(): boolean {
    return this.arena.bushes.some((b) => inside(this.player.x, this.player.z, b))
  }

  nearestDummy(): Dummy | undefined {
    const p = this.player
    let best: Dummy | undefined
    for (const d of this.dummies) {
      if (d.brokenAt !== null) continue
      if (!best || Math.hypot(d.x - p.x, d.z - p.z) < Math.hypot(best.x - p.x, best.z - p.z)) best = d
    }
    return best
  }

  drainEvents(): WorldEvent[] {
    const events = this.events
    this.events = []
    return events
  }
}
