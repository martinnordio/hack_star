import type { Arena } from './arena'
import { SETTINGS, type Settings } from './settings'
import { World } from './world'

export type MatchPhase = 'countdown' | 'fight' | 'over'

export type MatchResult = { kind: 'victory' } | { kind: 'defeat'; place: number } | { kind: 'timeup' }

/** A "last fighter standing" match: countdown, timer and result around a `World`. */
export class Match {
  readonly world: World
  phase: MatchPhase = 'countdown'
  countdown: number
  timeLeft: number
  result: MatchResult | null = null
  /** Called every fighting frame before the world moves on (the bot brains). */
  beforeStep?: (dt: number) => void

  constructor(
    arena: Arena,
    readonly settings: Settings = SETTINGS,
  ) {
    this.world = new World(arena, { fighters: settings.botCount + 1, fighterHealth: settings.fighterHealth })
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
      this.beforeStep?.(dt)
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
    else if (this.timeLeft <= 0)
      this.end(this.settings.timeUpResult === 'draw' ? { kind: 'timeup' } : { kind: 'defeat', place: botsIn + 1 })
  }

  private end(result: MatchResult) {
    this.result = result
    this.phase = 'over'
  }
}
