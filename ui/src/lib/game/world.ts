import type { Arena, Circle, Rect } from './arena'
import { SETTINGS } from './settings'

export const PLAYER_RADIUS = 0.5
export const PLAYER_SPEED = 6
export const SHOT_RADIUS = 0.25
export const SHOT_SPEED = 16
export const SHOT_RANGE = 9
export const FIRE_COOLDOWN = 0.35
/** Damage at power level 1. */
export const SHOT_DAMAGE = SETTINGS.shotDamage
export const DUMMY_RADIUS = 0.6
export const DUMMY_HEALTH = 2400
export const RESPAWN_SECONDS = 5
/** Fighters closer than this see a fighter hiding in a bush. */
export const BUSH_SIGHT = 2.5

export interface Fighter {
  id: number
  x: number
  z: number
  facing: number
  health: number
  maxHealth: number
  damage: number
  out: boolean
  lastHurt: number
  lastFire: number
  /** Multipliers (bots are slower on easy). */
  speedFactor: number
  cooldownFactor: number
}

export interface Shot {
  id: number
  owner: number
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
  | { type: 'fire'; by: number; x: number; z: number; dx: number; dz: number }
  | { type: 'hit'; dummyId: number; x: number; z: number; damage: number }
  | { type: 'break'; dummyId: number; x: number; z: number }
  | { type: 'respawn'; dummyId: number }
  | { type: 'hurt'; fighterId: number; by: number; x: number; z: number; damage: number }
  | { type: 'knockout'; fighterId: number; by: number; x: number; z: number }
  | { type: 'blocked'; owner: number; x: number; z: number }

export interface WorldOptions {
  /** Number of fighters; fighter 0 is the player. Training has 1. */
  fighters?: number
  dummies?: boolean
  /** Health and damage per fighter (by id); missing ones use power level 1. */
  stats?: { health: number; damage: number }[]
}

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
  fighters: Fighter[]
  shots: Shot[] = []
  dummies: Dummy[]
  /** Things that happened since the last `drainEvents()`, for effects. */
  private events: WorldEvent[] = []
  private nextShotId = 1

  constructor(
    readonly arena: Arena,
    { fighters = 1, dummies = fighters === 1, stats = [] }: WorldOptions = {},
  ) {
    const spots = fighters === 1 ? [arena.start] : arena.spawns
    if (fighters > spots.length) throw new Error(`The arena has room for ${spots.length} fighters`)
    this.fighters = spots.slice(0, fighters).map((s, id) => {
      const { health, damage } = stats[id] ?? { health: SETTINGS.fighterHealth, damage: SETTINGS.shotDamage }
      return {
        id,
        x: s.x,
        z: s.z,
        // Face the middle of the arena (the player starts facing the camera in training).
        facing: fighters === 1 ? 0 : Math.atan2(-s.x, -s.z),
        health,
        maxHealth: health,
        damage,
        out: false,
        lastHurt: -Infinity,
        lastFire: -Infinity,
        speedFactor: 1,
        cooldownFactor: 1,
      }
    })
    this.dummies = dummies
      ? arena.dummies.map((d, id) => ({ id, x: d.x, z: d.z, health: DUMMY_HEALTH, brokenAt: null }))
      : []
  }

  get player(): Fighter {
    return this.fighters[0]
  }

  /** Move the player (see `moveFighter`). */
  move(dx: number, dz: number, dt: number) {
    this.moveFighter(this.player, dx, dz, dt)
  }

  /** Move by a direction (length ≤ 1 is a partial push, like a joystick) for `dt` seconds. */
  moveFighter(f: Fighter, dx: number, dz: number, dt: number) {
    const length = Math.hypot(dx, dz)
    if (length === 0 || f.out) return
    const scale = length > 1 ? 1 / length : 1
    f.x += dx * scale * PLAYER_SPEED * f.speedFactor * dt
    f.z += dz * scale * PLAYER_SPEED * f.speedFactor * dt
    f.facing = Math.atan2(dx, dz)
    this.resolve(f)
  }

  private resolve(f: Fighter) {
    for (const wall of this.arena.walls) pushOutOfRect(f, PLAYER_RADIUS, wall)
    const others = [
      ...this.dummies.filter((d) => d.brokenAt === null).map((d) => ({ x: d.x, z: d.z, r: DUMMY_RADIUS })),
      ...this.fighters.filter((o) => o !== f && !o.out).map((o) => ({ x: o.x, z: o.z, r: PLAYER_RADIUS })),
    ]
    for (const o of others) {
      const dx = f.x - o.x
      const dz = f.z - o.z
      const dist = Math.hypot(dx, dz)
      const min = PLAYER_RADIUS + o.r
      if (dist < min && dist > 0) {
        f.x = o.x + (dx / dist) * min
        f.z = o.z + (dz / dist) * min
      }
    }
    const maxX = this.arena.width / 2 - PLAYER_RADIUS
    const maxZ = this.arena.depth / 2 - PLAYER_RADIUS
    f.x = Math.max(-maxX, Math.min(maxX, f.x))
    f.z = Math.max(-maxZ, Math.min(maxZ, f.z))
  }

  canFire(f: Fighter = this.player): boolean {
    return !f.out && this.time - f.lastFire >= FIRE_COOLDOWN * f.cooldownFactor
  }

  /** The player fires (see `fireFrom`). */
  fire(dx: number, dz: number): boolean {
    return this.fireFrom(this.player, dx, dz)
  }

  /** Fire towards a direction; returns false while cooling down. */
  fireFrom(f: Fighter, dx: number, dz: number): boolean {
    const length = Math.hypot(dx, dz)
    if (length === 0 || !this.canFire(f)) return false
    dx /= length
    dz /= length
    f.lastFire = this.time
    f.facing = Math.atan2(dx, dz)
    const x = f.x + dx * (PLAYER_RADIUS + 0.2)
    const z = f.z + dz * (PLAYER_RADIUS + 0.2)
    this.shots.push({ id: this.nextShotId++, owner: f.id, x, z, dx, dz, travelled: 0 })
    this.events.push({ type: 'fire', by: f.id, x, z, dx, dz })
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
      const fighter = this.fighters.find(
        (f) => f.id !== s.owner && !f.out && Math.hypot(s.x - f.x, s.z - f.z) < PLAYER_RADIUS + SHOT_RADIUS,
      )
      if (fighter) {
        this.hurt(fighter, s.owner)
        return false
      }
      const dummy = this.dummies.find(
        (d) => d.brokenAt === null && Math.hypot(s.x - d.x, s.z - d.z) < DUMMY_RADIUS + SHOT_RADIUS,
      )
      if (dummy) {
        this.hit(dummy, this.fighters[s.owner]?.damage ?? SHOT_DAMAGE)
        return false
      }
      const blocked =
        this.arena.walls.some((w) => overlapsRect(s.x, s.z, SHOT_RADIUS, w)) ||
        Math.abs(s.x) > halfW ||
        Math.abs(s.z) > halfD
      if (blocked || s.travelled >= SHOT_RANGE) {
        this.events.push({ type: 'blocked', owner: s.owner, x: s.x, z: s.z })
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
    for (const f of this.fighters) {
      const calm = this.time - Math.max(f.lastHurt, f.lastFire) >= SETTINGS.healDelay
      if (!f.out && calm && f.health < f.maxHealth) {
        f.health = Math.min(f.maxHealth, f.health + f.maxHealth * SETTINGS.healPerSecond * dt)
      }
    }
  }

  private hurt(f: Fighter, by: number) {
    const damage = this.fighters[by]?.damage ?? SHOT_DAMAGE
    f.health = Math.max(0, f.health - damage)
    f.lastHurt = this.time
    this.events.push({ type: 'hurt', fighterId: f.id, by, x: f.x, z: f.z, damage })
    if (f.health <= 0) {
      f.out = true
      this.shots = this.shots.filter((s) => s.owner !== f.id)
      this.events.push({ type: 'knockout', fighterId: f.id, by, x: f.x, z: f.z })
    }
  }

  private hit(d: Dummy, damage: number) {
    d.health = Math.max(0, d.health - damage)
    this.events.push({ type: 'hit', dummyId: d.id, x: d.x, z: d.z, damage })
    if (d.health <= 0) {
      d.brokenAt = this.time
      this.events.push({ type: 'break', dummyId: d.id, x: d.x, z: d.z })
    }
  }

  inBush(f: Fighter = this.player): boolean {
    return this.arena.bushes.some((b) => inside(f.x, f.z, b))
  }

  /** Whether `viewer` can see `target` within `range` (bushes hide unless close). */
  canSee(viewer: Fighter, target: Fighter, range: number): boolean {
    if (target.out) return false
    const dist = Math.hypot(target.x - viewer.x, target.z - viewer.z)
    if (dist > range) return false
    return !this.inBush(target) || dist <= BUSH_SIGHT
  }

  alive(): Fighter[] {
    return this.fighters.filter((f) => !f.out)
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
