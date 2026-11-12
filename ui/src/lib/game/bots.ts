import { SHOT_RANGE, type Fighter, type World } from './world'
import type { BotSkill } from './settings'

export interface BotState {
  id: number
  targetId: number | null
  /** When the current target was first seen; the bot reacts after `skill.reaction`. */
  seenAt: number
  wander: { x: number; z: number } | null
  wanderUntil: number
}

/** Brains for every fighter except the player (fighter 0). */
export class Bots {
  readonly states: BotState[]

  constructor(
    private world: World,
    private skill: BotSkill,
    private fightEachOther: boolean,
    private random: () => number = Math.random,
  ) {
    this.states = world.fighters.slice(1).map((f) => {
      f.speedFactor = skill.speed
      f.cooldownFactor = skill.cooldown
      return { id: f.id, targetId: null, seenAt: 0, wander: null, wanderUntil: 0 }
    })
  }

  think(dt: number) {
    for (const s of this.states) {
      const bot = this.world.fighters[s.id]
      if (!bot.out) this.thinkOne(s, bot, dt)
    }
  }

  private pickTarget(bot: Fighter): Fighter | undefined {
    let best: Fighter | undefined
    let bestDist = Infinity
    for (const o of this.world.fighters) {
      if (o === bot || (!this.fightEachOther && o.id !== 0)) continue
      if (!this.world.canSee(bot, o, this.skill.sight)) continue
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
    const target = this.pickTarget(bot)
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
      // Close in when far, back off when too close, and circle a little in between.
      const forward = dist > SHOT_RANGE * 0.65 ? 1 : dist < 3 ? -0.6 : 0
      const side = Math.sin(world.time * 0.9 + s.id * 2) * 0.6
      world.moveFighter(bot, ux * forward - uz * side, uz * forward + ux * side, dt)
      if (dist <= SHOT_RANGE * 0.9) {
        const angle = Math.atan2(ux, uz) + (this.random() * 2 - 1) * this.skill.aimError
        world.fireFrom(bot, Math.sin(angle), Math.cos(angle))
      }
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
