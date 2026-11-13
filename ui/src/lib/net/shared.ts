/** A match shared between devices: the host runs it, friends mirror it (play with friends spec). */
import type { Arena } from '../game/arena'
import { Bots } from '../game/bots'
import { stats } from '../game/economy'
import { Match, teamArena, type MatchLike, type MatchPhase, type MatchResult } from '../game/match'
import { SETTINGS, type BotLevel, type Settings } from '../game/settings'
import { fighterType } from '../game/types'
import { World, type Shot, type WorldEvent } from '../game/world'
import type { RoomConnection, RoomMessage, Seat } from './room'
import { CREATED_ID, parseLookSkin } from '../created'

/** Seconds between two snapshots from the host, and between two positions from a friend. */
export const SEND_EVERY = 0.05
/** After a dash the host's position counts for a moment, so the friend's old one does not pull it back. */
const AFTER_DASH = 0.3

export interface SharedFighter {
  fighter: string
  type: string
  skin: string
  power: number
  hyper: boolean
  /** The room slot of a person; missing for bots. */
  slot?: number
}

export interface StartInfo {
  type: 'start'
  settings: Pick<Settings, 'matchSeconds' | 'overtimeSeconds' | 'botCount' | 'countdownSeconds'> & { botLevel: BotLevel }
  /** People first (fighter ids 0..), then bots. */
  fighters: SharedFighter[]
}

/** The start message the host sends: people in slot order, then bots with random fighters. */
export function startInfo(
  settings: Settings,
  members: Seat[],
  catalogue: { id: string; type: string }[],
  random = Math.random,
): StartInfo {
  const people = [...members].sort((a, b) => a.slot - b.slot)
  const count = Math.max(settings.botCount + 1, people.length + 1)
  // A created fighter's type is in its look (skin id); every device has its own.
  const typeOf = (id: string, skin = 'default') =>
    (id === CREATED_ID ? parseLookSkin(skin)?.type : undefined) ?? catalogue.find((f) => f.id === id)?.type ?? 'basic'
  const fighterIds = catalogue.map((f) => f.id).filter((id) => id !== CREATED_ID)
  const others = fighterIds.filter((id) => !people.some((p) => p.fighter === id))
  const pool = (others.length ? others : fighterIds).slice().sort(() => random() - 0.5)
  const bots = Array.from({ length: count - people.length }, (_, i) => ({
    fighter: pool[i % pool.length],
    type: typeOf(pool[i % pool.length]),
    skin: 'default',
    power: settings.botPower,
    hyper: false,
  }))
  return {
    type: 'start',
    settings: {
      matchSeconds: settings.matchSeconds,
      overtimeSeconds: settings.overtimeSeconds,
      botCount: settings.botCount,
      countdownSeconds: settings.countdownSeconds,
      botLevel: settings.botLevel,
    },
    fighters: [
      ...people.map((p) => ({ fighter: p.fighter, type: typeOf(p.fighter, p.skin), skin: p.skin, power: p.power, hyper: p.hyper, slot: p.slot })),
      ...bots,
    ],
  }
}

export function sharedSettings(start: StartInfo): Settings {
  return { ...SETTINGS, ...start.settings }
}

const humansOf = (start: StartInfo) => start.fighters.filter((f) => f.slot !== undefined).length
const hackOf = (f: SharedFighter) => (f.hyper ? { superGain: SETTINGS.hackSuperGain, alwaysHyper: true } : {})

type FighterRow = [x: number, z: number, facing: number, health: number, out: number, superCharge: number, hyper: number, dash: number]
type ShotRow = [x: number, z: number, dx: number, dz: number, speed: number, radius: number, lob: number, travelled: number, range: number, owner: number, superShot: number]

export interface Snapshot {
  type: 'state'
  phase: MatchPhase
  countdown: number
  timeLeft: number
  overtime: boolean
  result: MatchResult | null
  cover: boolean
  f: FighterRow[]
  s: ShotRow[]
  e: WorldEvent[]
}

const r2 = (n: number) => Math.round(n * 100) / 100

/** The host's side: runs the real match, takes friends' input, sends snapshots. */
export class HostMatch implements MatchLike {
  readonly match: Match
  private pending: WorldEvent[] = []
  private sinceSent = 0
  private positions = new Map<number, { x: number; z: number; facing: number }>()
  private ignoreUntil = new Map<number, number>()
  private unsubscribe: () => void

  constructor(
    arena: Arena,
    readonly start: StartInfo,
    private connection: RoomConnection,
  ) {
    const settings = sharedSettings(start)
    this.match = new Match(arena, settings, {
      humans: humansOf(start),
      types: start.fighters.map((f) => fighterType(f.type)),
      powers: start.fighters.map((f) => f.power),
    })
    start.fighters.forEach((f, id) => Object.assign(this.match.world.fighters[id], hackOf(f)))
    this.unsubscribe = connection.on((m) => this.receive(m))
  }

  get world() { return this.match.world }
  get settings() { return this.match.settings }
  get phase() { return this.match.phase }
  get countdown() { return this.match.countdown }
  get timeLeft() { return this.match.timeLeft }
  get overtime() { return this.match.overtime }
  get result() { return this.match.result }
  get canAct() { return this.match.canAct }

  private idOf(slot: unknown): number {
    return this.start.fighters.findIndex((f) => f.slot === slot)
  }

  private receive(m: RoomMessage) {
    if (m.type === 'left') return this.takeOver(this.idOf(m.slot))
    if (m.type !== 'input') return
    const id = this.idOf(m.slot)
    const f = this.world.fighters[id]
    if (!f || f.out) return
    if (m.quit) return this.takeOver(id)
    if (typeof m.x === 'number' && typeof m.z === 'number' && typeof m.facing === 'number') {
      this.positions.set(id, { x: m.x, z: m.z, facing: m.facing })
    }
    const fire = vector(m.fire)
    if (fire && this.canAct) this.world.fireFrom(f, fire.x, fire.z)
    const power = vector(m.super)
    if (power && this.canAct) this.world.useSuper(f, power.x, power.z)
  }

  /** A bot plays for a friend who left. */
  private takeOver(id: number) {
    if (id < 0) return
    this.positions.delete(id)
    this.start.fighters[id] = { ...this.start.fighters[id], slot: undefined }
    this.bots.addBot(id)
  }

  private get bots(): Bots {
    return this.match.bots!
  }

  update(dt: number) {
    for (const [id, p] of this.positions) {
      const f = this.world.fighters[id]
      if (f.dash) this.ignoreUntil.set(id, this.world.time + AFTER_DASH)
      if (f.out || f.dash || this.world.time < (this.ignoreUntil.get(id) ?? 0)) continue
      f.x = p.x
      f.z = p.z
      f.facing = p.facing
    }
    this.match.update(dt)
    const events = this.world.drainEvents()
    this.world.pushEvents(events)
    this.pending.push(...events)
    this.sinceSent += dt
    if (this.sinceSent >= SEND_EVERY || this.phase === 'over') {
      this.sinceSent = 0
      this.connection.send(this.snapshot())
      this.pending = []
    }
  }

  snapshot(): Snapshot {
    const w = this.world
    return {
      type: 'state',
      phase: this.phase,
      countdown: r2(this.countdown),
      timeLeft: r2(this.timeLeft),
      overtime: this.overtime,
      result: this.result,
      cover: w.walls.length > 0,
      f: w.fighters.map((f) => [r2(f.x), r2(f.z), r2(f.facing), Math.round(f.health), f.out ? 1 : 0, r2(f.superCharge), w.isHyper(f) ? 1 : 0, f.dash ? 1 : 0]),
      s: w.shots.map((s) => [r2(s.x), r2(s.z), r2(s.dx), r2(s.dz), s.speed, s.radius, s.lob ? 1 : 0, r2(s.travelled), r2(s.range), s.owner, s.superShot ? 1 : 0]),
      e: this.pending,
    }
  }

  /** The host left the match early: friends get a draw. */
  stop() {
    if (this.phase !== 'over') this.connection.send({ ...this.snapshot(), phase: 'over', result: { kind: 'timeup' } })
    this.unsubscribe()
  }
}

/** A friend's side: shows the host's match and sends this player's moves. */
export class GuestMatch implements MatchLike {
  readonly world: World
  readonly settings: Settings
  phase: MatchPhase = 'countdown'
  countdown: number
  timeLeft: number
  overtime = false
  result: MatchResult | null = null
  private targets: { x: number; z: number; facing: number }[] = []
  private sinceSent = 0
  private followHostUntil = 0
  private unsubscribe: () => void

  constructor(
    arena: Arena,
    readonly start: StartInfo,
    slot: number,
    private connection: RoomConnection,
  ) {
    this.settings = sharedSettings(start)
    const humans = humansOf(start)
    const types = start.fighters.map((f) => fighterType(f.type))
    this.world = new World(teamArena(arena, humans), {
      fighters: start.fighters.length,
      stats: start.fighters.map((f, id) => stats(f.power, this.settings, types[id])),
      types,
      teams: start.fighters.map((_, id) => (id < humans ? 0 : id)),
      playerId: Math.max(0, start.fighters.findIndex((f) => f.slot === slot)),
    })
    start.fighters.forEach((f, id) => Object.assign(this.world.fighters[id], hackOf(f)))
    this.countdown = this.settings.countdownSeconds
    this.timeLeft = this.settings.matchSeconds
    this.unsubscribe = connection.on((m) => this.receive(m))
  }

  get canAct() {
    return this.phase === 'fight'
  }

  private receive(m: RoomMessage) {
    if (m.type === 'state') this.apply(m as unknown as Snapshot)
    else if ((m.type === 'closed' || m.type === 'disconnected') && this.phase !== 'over') {
      this.phase = 'over'
      this.result = { kind: 'timeup' }
    }
  }

  private apply(snap: Snapshot) {
    const w = this.world
    this.phase = snap.phase
    this.countdown = snap.countdown
    this.timeLeft = snap.timeLeft
    this.overtime = snap.overtime
    this.result = snap.result
    if (!snap.cover && w.walls.length > 0) {
      // The host's `coverGone` event (in `e`) shows the walls breaking.
      w.walls = []
      w.bushes = []
    }
    snap.f.forEach(([x, z, facing, health, out, superCharge, hyper, dash], id) => {
      const f = w.fighters[id]
      if (!f) return
      f.health = health
      f.out = out === 1
      f.superCharge = superCharge
      f.hyperUntil = hyper ? w.time + 0.2 : -Infinity
      f.dash = dash ? { dx: 0, dz: 0, until: w.time, damage: 0, hits: [] } : null
      this.targets[id] = { x, z, facing }
      if (f === w.player && dash) this.followHostUntil = w.time + AFTER_DASH
    })
    w.shots = snap.s.map(
      ([x, z, dx, dz, speed, radius, lob, travelled, range, owner, superShot], i): Shot => ({
        id: i,
        owner,
        x,
        z,
        dx,
        dz,
        speed,
        radius,
        lob: lob === 1,
        travelled,
        range,
        superShot: superShot === 1,
        damage: 0,
        through: true,
        blast: 0,
        hits: null,
      }),
    )
    w.pushEvents(snap.e)
  }

  update(dt: number) {
    const w = this.world
    w.time += dt
    const glide = Math.min(1, dt * 15)
    w.fighters.forEach((f, id) => {
      const t = this.targets[id]
      if (!t) return
      const mine = f === w.player && w.time >= this.followHostUntil
      if (mine) return
      f.x += (t.x - f.x) * glide
      f.z += (t.z - f.z) * glide
      f.facing = t.facing
    })
    for (const s of w.shots) {
      s.x += s.dx * s.speed * dt
      s.z += s.dz * s.speed * dt
      s.travelled += s.speed * dt
    }
    w.shots = w.shots.filter((s) => s.travelled < s.range + 0.5)
    this.sinceSent += dt
    if (this.sinceSent >= SEND_EVERY && this.phase !== 'over') {
      this.sinceSent = 0
      const p = w.player
      this.connection.send({ type: 'input', x: r2(p.x), z: r2(p.z), facing: r2(p.facing) })
    }
  }

  fire(dx: number, dz: number) {
    const p = this.world.player
    if (!this.canAct || !this.world.canFire(p)) return
    p.lastFire = this.world.time
    this.connection.send({ type: 'input', fire: [r2(dx), r2(dz)] })
  }

  useSuper(dx: number, dz: number) {
    if (!this.canAct || this.world.player.out || this.world.player.superCharge < 1) return
    this.connection.send({ type: 'input', super: [r2(dx), r2(dz)] })
  }

  /** This friend left the match: a bot takes over on the host. */
  stop() {
    if (this.phase !== 'over') this.connection.send({ type: 'input', quit: true })
    this.unsubscribe()
  }
}

function vector(value: unknown): { x: number; z: number } | null {
  if (!Array.isArray(value) || value.length !== 2) return null
  const [x, z] = value
  return typeof x === 'number' && typeof z === 'number' && Number.isFinite(x) && Number.isFinite(z) ? { x, z } : null
}
