import type { Arena } from './arena'
import { Bots } from './bots'
import { stats } from './economy'
import { BOT_LEVELS, SETTINGS, type Settings } from './settings'
import { World } from './world'

export type MatchPhase = 'countdown' | 'fight' | 'over'

export type MatchResult = { kind: 'victory' } | { kind: 'defeat'; place: number } | { kind: 'timeup' }

export interface MatchOptions {
  /** Tests switch the bot brains off to control every move. */
  bots?: boolean
  random?: () => number
  /** The player's power level (bots use `settings.botPower`). */
  playerPower?: number
}

/** A "last fighter standing" match: countdown, timer and result around a `World`. */
export class Match {
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
    { bots = true, random = Math.random, playerPower = 1 }: MatchOptions = {},
  ) {
    const fighters = settings.botCount + 1
    const fighterStats = Array.from({ length: fighters }, (_, id) =>
      stats(id === 0 ? playerPower : settings.botPower, settings),
    )
    this.world = new World(arena, { fighters, stats: fighterStats })
    this.bots = bots ? new Bots(this.world, BOT_LEVELS[settings.botLevel], settings.botsFightEachOther, random) : null
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

  private checkEnd() {
    const botsIn = this.world.fighters.slice(1).filter((f) => !f.out).length
    if (this.world.player.out) this.end({ kind: 'defeat', place: botsIn + 1 })
    else if (botsIn === 0) this.end({ kind: 'victory' })
    else if (this.timeLeft <= 0 && !this.overtime && this.settings.overtimeSeconds > 0) this.startOvertime()
    else if (this.timeLeft <= 0)
      this.end(this.settings.timeUpResult === 'draw' ? { kind: 'timeup' } : { kind: 'defeat', place: botsIn + 1 })
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
