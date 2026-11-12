import type { Arena, Circle, Rect } from './arena'
import { SETTINGS } from './settings'
import { BASIC, type FighterType } from './types'

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
export const SUPER_SHOT_RADIUS = 0.45
export const SUPER_RANGE = SHOT_RANGE * 1.3
/** Angle between two shots of a Super blast (radians). */
export const SUPER_SPREAD = 0.14
export const DASH_SPEED = 20

export interface Fighter {
  id: number
  x: number
  z: number
  facing: number
  health: number
  maxHealth: number
  damage: number
  type: FighterType
  out: boolean
  lastHurt: number
  lastFire: number
  /** Multipliers (bots are slower on easy). */
  speedFactor: number
  cooldownFactor: number
  /** Super and Hypercharge meters, 0..1. */
  superCharge: number
  hyperCharge: number
  /** Hypercharged until this world time. */
  hyperUntil: number
  /** Multiplier on Super charging (the HYPERCHARGE hack). */
  superGain: number
  /** Whether Supers can become Hypercharges at all (not for easy bots). */
  canHyper: boolean
  /** Every Super is a Hypercharge (the HYPERCHARGE hack). */
  alwaysHyper: boolean
  /** A Speedy's Super: rushing in a direction, hitting everyone on the way once. */
  dash: { dx: number; dz: number; until: number; damage: number; hits: number[] } | null
}

export interface Shot {
  id: number
  owner: number
  x: number
  z: number
  dx: number
  dz: number
  travelled: number
  range: number
  speed: number
  radius: number
  damage: number
  /** Super shots do not charge the Super. */
  superShot: boolean
  /** Flies through walls. */
  through: boolean
  /** Lobbed: flies over everything and explodes where it lands, `blast` wide. */
  lob: boolean
  blast: number
  /** Piercing shots go on after a hit; ids already hit. */
  hits: number[] | null
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
  | { type: 'coverGone' }
  | { type: 'super'; by: number; x: number; z: number; dx: number; dz: number; hyper: boolean }
  | { type: 'hypercharge'; fighterId: number }
  | { type: 'explode'; by: number; x: number; z: number; radius: number }

export interface WorldOptions {
  /** Number of fighters; fighter 0 is the player. Training has 1. */
  fighters?: number
  dummies?: boolean
  /** Health and damage per fighter (by id); missing ones use power level 1. */
  stats?: { health: number; damage: number }[]
  /** Type per fighter (by id); missing ones are Basic. */
  types?: FighterType[]
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

type ShotSpec = Pick<Shot, 'range' | 'speed' | 'radius' | 'damage' | 'superShot'> &
  Partial<Pick<Shot, 'through' | 'lob' | 'blast'>> & { pierce?: boolean }

export class World {
  time = 0
  fighters: Fighter[]
  shots: Shot[] = []
  dummies: Dummy[]
  /** Walls and bushes still standing (overtime removes them). */
  walls: Rect[]
  bushes: Circle[]
  /** Things that happened since the last `drainEvents()`, for effects. */
  private events: WorldEvent[] = []
  private nextShotId = 1

  constructor(
    readonly arena: Arena,
    { fighters = 1, dummies = fighters === 1, stats = [], types = [] }: WorldOptions = {},
  ) {
    const spots = fighters === 1 ? [arena.start] : arena.spawns
    this.walls = [...arena.walls]
    this.bushes = [...arena.bushes]
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
        type: types[id] ?? BASIC,
        out: false,
        lastHurt: -Infinity,
        lastFire: -Infinity,
        speedFactor: 1,
        cooldownFactor: 1,
        superCharge: 0,
        hyperCharge: 0,
        hyperUntil: -Infinity,
        superGain: 1,
        canHyper: true,
        alwaysHyper: false,
        dash: null,
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
    if (length === 0 || f.out || f.dash) return
    const scale = length > 1 ? 1 / length : 1
    const speed = PLAYER_SPEED * f.type.speed * f.speedFactor * this.boost(f) * dt
    f.x += dx * scale * speed
    f.z += dz * scale * speed
    f.facing = Math.atan2(dx, dz)
    this.resolve(f)
  }

  private resolve(f: Fighter) {
    for (const wall of this.walls) pushOutOfRect(f, PLAYER_RADIUS, wall)
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
    return !f.out && !f.dash && this.time - f.lastFire >= FIRE_COOLDOWN * f.type.reload * f.cooldownFactor
  }

  /** The player fires (see `fireFrom`). */
  fire(dx: number, dz: number): boolean {
    return this.fireFrom(this.player, dx, dz)
  }

  /**
   * Attack towards a direction; returns false while reloading. For lobbed shots the length of
   * the direction sets how far they fly: up to 1 is a share of the range (joystick), more is a
   * distance (mouse, bots).
   */
  fireFrom(f: Fighter, dx: number, dz: number): boolean {
    const length = Math.hypot(dx, dz)
    if (length === 0 || !this.canFire(f)) return false
    const attack = f.type.attack
    f.lastFire = this.time
    f.facing = Math.atan2(dx, dz)
    const range = attack.lob ? this.throwDistance(length, attack.range) : attack.range
    const damage = f.damage * attack.share * this.boost(f)
    this.spray(f, f.facing, attack.count, attack.spread, {
      range,
      speed: attack.speed,
      radius: attack.radius,
      damage,
      superShot: false,
      lob: attack.lob,
      blast: attack.blast,
    })
    this.events.push({ type: 'fire', by: f.id, x: f.x + (dx / length) * 0.7, z: f.z + (dz / length) * 0.7, dx: dx / length, dz: dz / length })
    return true
  }

  private throwDistance(length: number, range: number): number {
    return Math.max(1.5, Math.min(range, length <= 1 ? length * range : length))
  }

  /** `count` shots in a fan around `angle`, `spread` radians apart. */
  private spray(f: Fighter, angle: number, count: number, spread: number, spec: ShotSpec) {
    for (let i = 0; i < count; i++) {
      const a = angle + (i - (count - 1) / 2) * spread
      const dx = Math.sin(a)
      const dz = Math.cos(a)
      this.shots.push({
        id: this.nextShotId++,
        owner: f.id,
        x: f.x + dx * (PLAYER_RADIUS + 0.2),
        z: f.z + dz * (PLAYER_RADIUS + 0.2),
        dx,
        dz,
        travelled: 0,
        range: spec.range,
        speed: spec.speed,
        radius: spec.radius,
        damage: spec.damage,
        superShot: spec.superShot,
        through: spec.through ?? false,
        lob: spec.lob ?? false,
        blast: spec.blast ?? 0,
        hits: spec.pierce ? [] : null,
      })
    }
  }

  isHyper(f: Fighter): boolean {
    return this.time < f.hyperUntil
  }

  /** Speed and damage multiplier: more while hypercharged. */
  private boost(f: Fighter): number {
    return this.isHyper(f) ? 1 + SETTINGS.hyperchargeBoost : 1
  }

  /** Whether the next Super will be a Hypercharge. */
  hyperReady(f: Fighter): boolean {
    return f.canHyper && (f.alwaysHyper || f.hyperCharge >= 1)
  }

  /** The fighter's Super towards a direction (see `fireFrom` for its length); needs a full meter. */
  useSuper(f: Fighter, dx: number, dz: number): boolean {
    const length = Math.hypot(dx, dz)
    if (length === 0 || f.out || f.dash || f.superCharge < 1) return false
    const hyper = this.hyperReady(f)
    f.superCharge = 0
    if (hyper) {
      f.hyperCharge = 0
      f.hyperUntil = this.time + SETTINGS.hyperchargeSeconds
      this.events.push({ type: 'hypercharge', fighterId: f.id })
    } else if (f.canHyper) {
      f.hyperCharge = Math.min(1, f.hyperCharge + 1 / SETTINGS.supersPerHypercharge)
    }
    const angle = Math.atan2(dx, dz)
    const damage = f.damage * this.boost(f)
    f.facing = angle
    f.lastFire = this.time
    const big = { superShot: true, through: true }
    switch (f.type.super) {
      case 'blast': {
        const count = hyper ? SETTINGS.hyperSuperShots : SETTINGS.superShots
        this.spray(f, angle, count, SUPER_SPREAD, { ...big, range: SUPER_RANGE, speed: SHOT_SPEED, radius: SUPER_SHOT_RADIUS, damage: damage * SETTINGS.superDamage })
        break
      }
      case 'shockwave': {
        const count = hyper ? 24 : 16
        this.spray(f, angle, count, (Math.PI * 2) / count, { ...big, range: hyper ? 7 : 5.5, speed: 14, radius: SUPER_SHOT_RADIUS, damage: damage * 1.6 })
        break
      }
      case 'beam':
        this.spray(f, angle, 1, 0, { ...big, pierce: true, range: 15, speed: 30, radius: hyper ? 0.9 : 0.6, damage: damage * 2.4 })
        break
      case 'bomb':
        this.spray(f, angle, 1, 0, { ...big, lob: true, blast: hyper ? 4 : 3, range: this.throwDistance(length, 10), speed: 12, radius: 0.5, damage: damage * 2.2 })
        break
      case 'dash':
        f.dash = { dx: dx / length, dz: dz / length, until: this.time + (hyper ? 0.45 : 0.3), damage: damage * 2.2, hits: [] }
        break
    }
    this.events.push({ type: 'super', by: f.id, x: f.x, z: f.z, dx: dx / length, dz: dz / length, hyper })
    return true
  }

  /** Normal hits fill the Super: one full-damage hit is 1 / `superHits` of it. */
  private charge(f: Fighter | undefined, damage: number) {
    if (!f || f.out) return
    const amount = (damage / (f.damage * SETTINGS.superHits)) * f.superGain
    f.superCharge = Math.min(1, Math.round((f.superCharge + amount) * 1000) / 1000)
  }

  private damageFighter(f: Fighter, by: number, damage: number, superShot: boolean) {
    this.hurt(f, by, damage)
    if (!superShot) this.charge(this.fighters[by], damage)
  }

  private damageDummy(d: Dummy, by: number, damage: number, superShot: boolean) {
    this.hit(d, damage)
    if (!superShot) this.charge(this.fighters[by], damage)
  }

  private explode(s: Shot) {
    for (const f of this.fighters) {
      if (f.id !== s.owner && !f.out && Math.hypot(s.x - f.x, s.z - f.z) < s.blast + PLAYER_RADIUS) {
        this.damageFighter(f, s.owner, s.damage, s.superShot)
      }
    }
    for (const d of this.dummies) {
      if (d.brokenAt === null && Math.hypot(s.x - d.x, s.z - d.z) < s.blast + DUMMY_RADIUS) {
        this.damageDummy(d, s.owner, s.damage, s.superShot)
      }
    }
    this.events.push({ type: 'explode', by: s.owner, x: s.x, z: s.z, radius: s.blast })
  }

  private stepDash(f: Fighter, dt: number) {
    const dash = f.dash!
    f.x += dash.dx * DASH_SPEED * dt
    f.z += dash.dz * DASH_SPEED * dt
    this.resolve(f)
    for (const o of this.fighters) {
      if (o === f || o.out || dash.hits.includes(o.id)) continue
      if (Math.hypot(o.x - f.x, o.z - f.z) < PLAYER_RADIUS * 2 + 0.4) {
        dash.hits.push(o.id)
        this.hurt(o, f.id, dash.damage)
      }
    }
    for (const d of this.dummies) {
      if (d.brokenAt === null && !dash.hits.includes(-1 - d.id) && Math.hypot(d.x - f.x, d.z - f.z) < PLAYER_RADIUS + DUMMY_RADIUS + 0.4) {
        dash.hits.push(-1 - d.id)
        this.hit(d, dash.damage)
      }
    }
    if (this.time >= dash.until) f.dash = null
  }

  step(dt: number) {
    this.time += dt
    for (const f of this.fighters) if (f.dash && !f.out) this.stepDash(f, dt)
    const halfW = this.arena.width / 2
    const halfD = this.arena.depth / 2
    this.shots = this.shots.filter((s) => {
      const distance = s.speed * dt
      s.x += s.dx * distance
      s.z += s.dz * distance
      s.travelled += distance
      const outside = Math.abs(s.x) > halfW || Math.abs(s.z) > halfD
      if (s.lob) {
        if (s.travelled < s.range && !outside) return true
        this.explode(s)
        return false
      }
      const fighter = this.fighters.find(
        (f) =>
          f.id !== s.owner &&
          !f.out &&
          !s.hits?.includes(f.id) &&
          Math.hypot(s.x - f.x, s.z - f.z) < PLAYER_RADIUS + s.radius,
      )
      if (fighter) {
        this.damageFighter(fighter, s.owner, s.damage, s.superShot)
        if (!s.hits) return false
        s.hits.push(fighter.id)
      }
      const dummy = this.dummies.find(
        (d) =>
          d.brokenAt === null &&
          !s.hits?.includes(-1 - d.id) &&
          Math.hypot(s.x - d.x, s.z - d.z) < DUMMY_RADIUS + s.radius,
      )
      if (dummy) {
        this.damageDummy(dummy, s.owner, s.damage, s.superShot)
        if (!s.hits) return false
        s.hits.push(-1 - dummy.id)
      }
      const blocked = (!s.through && this.walls.some((w) => overlapsRect(s.x, s.z, SHOT_RADIUS, w))) || outside
      if (blocked || s.travelled >= s.range) {
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

  private hurt(f: Fighter, by: number, damage: number) {
    if (f.out) return
    damage = Math.round(damage)
    f.health = Math.max(0, f.health - damage)
    f.lastHurt = this.time
    this.events.push({ type: 'hurt', fighterId: f.id, by, x: f.x, z: f.z, damage })
    if (f.health <= 0) {
      f.out = true
      f.dash = null
      this.shots = this.shots.filter((s) => s.owner !== f.id)
      this.events.push({ type: 'knockout', fighterId: f.id, by, x: f.x, z: f.z })
    }
  }

  private hit(d: Dummy, damage: number) {
    if (d.brokenAt !== null) return
    damage = Math.round(damage)
    d.health = Math.max(0, d.health - damage)
    this.events.push({ type: 'hit', dummyId: d.id, x: d.x, z: d.z, damage })
    if (d.health <= 0) {
      d.brokenAt = this.time
      this.events.push({ type: 'break', dummyId: d.id, x: d.x, z: d.z })
    }
  }

  inBush(f: Fighter = this.player): boolean {
    return this.bushes.some((b) => inside(f.x, f.z, b))
  }

  /** Walls and bushes disappear for the rest of the world's life. */
  removeCover() {
    if (this.walls.length === 0 && this.bushes.length === 0) return
    this.walls = []
    this.bushes = []
    this.events.push({ type: 'coverGone' })
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
