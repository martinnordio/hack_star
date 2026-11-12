import type { Arena } from './arena'
import { Bots } from './bots'
import { stats } from './economy'
import { BOT_LEVELS, SETTINGS, type Settings } from './settings'
import type { FighterType } from './types'
import { World } from './world'

export type MatchPhase = 'countdown' | 'fight' | 'over'

export type MatchResult = { kind: 'victory' } | { kind: 'defeat'; place: number } | { kind: 'timeup' }

export interface MatchOptions {
  /** Tests switch the bot brains off to control every move. */
  bots?: boolean
  random?: () => number
  /** The player's power level (bots use `settings.botPower`). */
  playerPower?: number
  /** Type of each fighter, by id (0 is the player); missing ones are Basic. */
  types?: FighterType[]
  /** Fighters 0..humans-1 are people on one team (friends); the rest are bots. */
  humans?: number
  /** Power level per fighter, by id; overrides `playerPower` and the bots' power. */
  powers?: number[]
}

/** What the arena needs from a match: a local one, or a shared one (host or friend). */
export interface MatchLike {
  readonly world: World
  readonly settings: Settings
  readonly phase: MatchPhase
  readonly countdown: number
  readonly timeLeft: number
  readonly overtime: boolean
  readonly result: MatchResult | null
  readonly canAct: boolean
  update(dt: number): void
}

/** A "last fighter standing" match: countdown, timer and result around a `World`. */
export class Match implements MatchLike {
  readonly world: World
  readonly bots: Bots | null
  phase: MatchPhase = 'countdown'
  countdown: number
  timeLeft: number
  /** True once the extra time has started. */
  overtime = false
  result: MatchResult | null = null

  constructor(
    arena: Arena,
    readonly settings: Settings = SETTINGS,
    { bots = true, random = Math.random, playerPower = 1, types = [], humans = 1, powers = [] }: MatchOptions = {},
  ) {
    // Friends take the place of bots, but there is always at least one bot.
    const fighters = Math.max(settings.botCount + 1, humans + 1)
    const fighterStats = Array.from({ length: fighters }, (_, id) =>
      stats(powers[id] ?? (id === 0 ? playerPower : settings.botPower), settings, types[id]),
    )
    const teams = Array.from({ length: fighters }, (_, id) => (id < humans ? 0 : id))
    this.world = new World(arena, { fighters, stats: fighterStats, types, teams })
    const humanIds = Array.from({ length: humans }, (_, id) => id)
    this.bots = bots
      ? new Bots(this.world, BOT_LEVELS[settings.botLevel], settings.botsFightEachOther, random, humanIds)
      : null
    this.countdown = settings.countdownSeconds
    this.timeLeft = settings.matchSeconds
  }

  get canAct(): boolean {
    return this.phase === 'fight'
  }

  movePlayer(dx: number, dz: number, dt: number) {
    if (this.canAct) this.world.move(dx, dz, dt)
  }

  firePlayer(dx: number, dz: number): boolean {
    return this.canAct && this.world.fire(dx, dz)
  }

  update(dt: number) {
    if (this.phase === 'countdown') {
      this.countdown -= dt
      if (this.countdown <= 0) {
        this.countdown = 0
        this.phase = 'fight'
      }
      return
    }
    if (this.phase === 'fight') {
      this.bots?.think(dt)
      this.timeLeft = Math.max(0, this.timeLeft - dt)
    }
    // After the end the world keeps moving so shots and effects can finish.
    this.world.step(dt)
    if (this.phase === 'fight') this.checkEnd()
  }

  /** Results are for the player's team: it wins when only it is left, loses when all of it is out. */
  private checkEnd() {
    const team = this.world.player.team
    const fighters = this.world.fighters
    const teamIn = fighters.some((f) => f.team === team && !f.out)
    const othersIn = new Set(fighters.filter((f) => f.team !== team && !f.out).map((f) => f.team)).size
    if (!teamIn) this.end({ kind: 'defeat', place: othersIn + 1 })
    else if (othersIn === 0) this.end({ kind: 'victory' })
    else if (this.timeLeft <= 0 && !this.overtime && this.settings.overtimeSeconds > 0) this.startOvertime()
    else if (this.timeLeft <= 0)
      this.end(this.settings.timeUpResult === 'draw' ? { kind: 'timeup' } : { kind: 'defeat', place: othersIn + 1 })
  }

  private startOvertime() {
    this.overtime = true
    this.timeLeft = this.settings.overtimeSeconds
    if (this.settings.overtimeRemovesCover) this.world.removeCover()
  }

  private end(result: MatchResult) {
    this.result = result
    this.phase = 'over'
  }
}
