import type { Fighter, World } from './world'
import type { BotSkill } from './settings'

/** Seconds without seeing an opponent before a bot goes looking for one. */
export const SEEK_AFTER_SECONDS = 6

export interface BotState {
  id: number
  targetId: number | null
  /** When the current target was first seen; the bot reacts after `skill.reaction`. */
  seenAt: number
  /** When the bot last saw an opponent; long enough without one and it goes looking. */
  lastSawAt: number
  wander: { x: number; z: number } | null
  wanderUntil: number
}

/** Brains for every fighter that is not a person (by default fighter 0 is the player). */
export class Bots {
  readonly states: BotState[]

  constructor(
    private world: World,
    private skill: BotSkill,
    private fightEachOther: boolean,
    private random: () => number = Math.random,
    humans: number[] = [0],
  ) {
    this.states = []
    for (const f of world.fighters) if (!humans.includes(f.id)) this.addBot(f.id)
  }

  /** A bot takes over fighter `id` (also when a friend leaves a shared match). */
  addBot(id: number) {
    if (this.states.some((s) => s.id === id)) return
    const f = this.world.fighters[id]
    f.speedFactor = this.skill.speed
    f.cooldownFactor = this.skill.cooldown
    f.canHyper = this.skill.hyper
    this.states.push({ id, targetId: null, seenAt: 0, lastSawAt: this.world.time, wander: null, wanderUntil: 0 })
  }

  think(dt: number) {
    for (const s of this.states) {
      const bot = this.world.fighters[s.id]
      if (!bot.out) this.thinkOne(s, bot, dt)
    }
  }

  /** Whether `bot` fights `o` (other bots only when they fight each other). */
  private isOpponent(bot: Fighter, o: Fighter): boolean {
    const otherBot = this.states.some((s) => s.id === o.id)
    return o !== bot && !o.out && o.team !== bot.team && (this.fightEachOther || !otherBot)
  }

  /** The closest opponent; with `sight`, only one the bot can see. */
  private nearestOpponent(bot: Fighter, sight?: number): Fighter | undefined {
    let best: Fighter | undefined
    let bestDist = Infinity
    for (const o of this.world.fighters) {
      if (!this.isOpponent(bot, o)) continue
      if (sight !== undefined && !this.world.canSee(bot, o, sight)) continue
      const d = Math.hypot(o.x - bot.x, o.z - bot.z)
      if (d < bestDist) {
        best = o
        bestDist = d
      }
    }
    return best
  }

  private thinkOne(s: BotState, bot: Fighter, dt: number) {
    const world = this.world
    const target = this.nearestOpponent(bot, this.skill.sight)
    if (target) s.lastSawAt = world.time
    if ((target?.id ?? null) !== s.targetId) {
      s.targetId = target?.id ?? null
      s.seenAt = world.time
    }

    if (target && world.time - s.seenAt < this.skill.reaction) {
      // Just noticed someone: stop and turn towards them.
      bot.facing = Math.atan2(target.x - bot.x, target.z - bot.z)
      return
    }

    if (target) {
      s.wander = null
      const dx = target.x - bot.x
      const dz = target.z - bot.z
      const dist = Math.hypot(dx, dz)
      const ux = dx / dist
      const uz = dz / dist
      // Close in when out of range, back off when too close, and circle a little in between.
      const range = bot.type.attack.range
      const forward = dist > range * 0.65 ? 1 : dist < Math.min(3, range * 0.4) ? -0.6 : 0
      const side = Math.sin(world.time * 0.9 + s.id * 2) * 0.6
      world.moveFighter(bot, ux * forward - uz * side, uz * forward + ux * side, dt)
      const angle = Math.atan2(ux, uz) + (this.random() * 2 - 1) * this.skill.aimError
      // Aim vectors as long as the distance, so lobbed shots land on the target.
      const aimX = Math.sin(angle) * dist
      const aimZ = Math.cos(angle) * dist
      if (dist <= bot.type.superReach && world.useSuper(bot, aimX, aimZ)) return
      if (dist <= range * 0.9) world.fireFrom(bot, aimX, aimZ)
      return
    }

    // Long without anyone in sight: head for the nearest opponent, drifting sideways so walls do not hold the bot.
    const seek = world.time - s.lastSawAt >= SEEK_AFTER_SECONDS ? this.nearestOpponent(bot) : undefined
    if (seek) {
      const dx = seek.x - bot.x
      const dz = seek.z - bot.z
      const dist = Math.hypot(dx, dz) || 1
      const ux = dx / dist
      const uz = dz / dist
      const side = Math.sin(world.time * 0.9 + s.id * 2) * 0.5
      world.moveFighter(bot, ux - uz * side, uz + ux * side, dt)
      return
    }

    // Nobody to fight: walk to random points, picking a new one now and then (or when stuck).
    if (!s.wander || world.time > s.wanderUntil || Math.hypot(s.wander.x - bot.x, s.wander.z - bot.z) < 0.5) {
      const w = world.arena.width / 2 - 2
      const d = world.arena.depth / 2 - 2
      s.wander = { x: (this.random() * 2 - 1) * w, z: (this.random() * 2 - 1) * d }
      s.wanderUntil = world.time + 3
    }
    world.moveFighter(bot, s.wander.x - bot.x, s.wander.z - bot.z, dt * 0.7)
  }
}
