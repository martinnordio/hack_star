import type { Fighter, World } from './world'
import type { BotSkill } from './settings'

export interface BotState {
  id: number
  targetId: number | null
  /** When the current target was first seen; the bot reacts after `skill.reaction`. */
  seenAt: number
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
    this.states.push({ id, targetId: null, seenAt: 0, wander: null, wanderUntil: 0 })
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
      const otherBot = this.states.some((s) => s.id === o.id)
      if (o === bot || o.team === bot.team || (!this.fightEachOther && otherBot)) continue
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
