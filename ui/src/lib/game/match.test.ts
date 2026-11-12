import { describe, expect, it } from 'vitest'
import { CANYON, type Arena } from './arena'
import { Match } from './match'
import { SETTINGS } from './settings'
import { SHOT_DAMAGE, World } from './world'

const open: Arena = {
  ...CANYON,
  walls: [],
  bushes: [],
  spawns: [
    { x: 0, z: 0 },
    { x: 0, z: -4 },
    { x: 10, z: 10 },
    { x: -10, z: 10 },
  ],
}

const tick = 1 / 60

function run(seconds: number, each: (dt: number) => void) {
  for (let t = 0; t < seconds; t += tick) each(tick)
}

/** Fire at fighter `target` from fighter 0 until it is out or time is up. */
function shootUntilOut(world: World, target: number, seconds = 20) {
  const f = world.fighters[target]
  run(seconds, (dt) => {
    if (f.out) return
    world.fire(f.x - world.player.x, f.z - world.player.z)
    world.step(dt)
  })
}

describe('World with fighters', () => {
  it('a shot hurts another fighter but never its shooter', () => {
    const world = new World(open, { fighters: 2 })
    world.fire(0, -1)
    run(0.5, (dt) => world.step(dt))
    expect(world.fighters[1].health).toBe(world.fighters[1].maxHealth - SHOT_DAMAGE)
    expect(world.player.health).toBe(world.player.maxHealth)
    const hurt = world.drainEvents().find((e) => e.type === 'hurt')
    expect(hurt).toMatchObject({ fighterId: 1, by: 0 })
  })

  it('heals after 3 calm seconds, not before', () => {
    const world = new World(open, { fighters: 2 })
    world.fire(0, -1)
    run(0.5, (dt) => world.step(dt))
    const hurtHealth = world.fighters[1].health
    run(2, (dt) => world.step(dt))
    expect(world.fighters[1].health).toBe(hurtHealth)
    run(2, (dt) => world.step(dt))
    expect(world.fighters[1].health).toBeGreaterThan(hurtHealth)
  })

  it('knocks out a fighter at 0 health', () => {
    const world = new World(open, { fighters: 2 })
    shootUntilOut(world, 1)
    expect(world.fighters[1].out).toBe(true)
    expect(world.fighters[1].health).toBe(0)
    expect(world.drainEvents().some((e) => e.type === 'knockout' && e.fighterId === 1)).toBe(true)
    expect(world.alive()).toHaveLength(1)
  })

  it('bushes hide fighters unless the viewer is close', () => {
    const world = new World({ ...open, bushes: [{ x: 0, z: -4, r: 1 }] }, { fighters: 2 })
    expect(world.canSee(world.player, world.fighters[1], 10)).toBe(false)
    world.player.z = -2
    expect(world.canSee(world.player, world.fighters[1], 10)).toBe(true)
  })
})

describe('Match', () => {
  const settings = { ...SETTINGS, botCount: 1, countdownSeconds: 3, matchSeconds: 10 }
  const still = { bots: false }

  it('nobody moves or shoots during the countdown', () => {
    const match = new Match(open, settings, still)
    match.movePlayer(1, 0, 1)
    expect(match.firePlayer(0, -1)).toBe(false)
    expect(match.world.player.x).toBe(0)
    run(3.1, (dt) => match.update(dt))
    expect(match.phase).toBe('fight')
    match.movePlayer(1, 0, 0.5)
    expect(match.world.player.x).toBeGreaterThan(0)
  })

  it('the last one standing wins', () => {
    const match = new Match(open, settings, still)
    run(3.1, (dt) => match.update(dt))
    const bot = match.world.fighters[1]
    run(10, (dt) => {
      if (match.phase === 'fight') match.firePlayer(bot.x - match.world.player.x, bot.z - match.world.player.z)
      match.update(dt)
    })
    expect(match.result).toEqual({ kind: 'victory' })
  })

  it('a knocked-out player loses with a place', () => {
    const match = new Match(open, { ...settings, botCount: 3 }, still)
    run(3.1, (dt) => match.update(dt))
    match.world.player.health = 1
    const bot = match.world.fighters[1]
    match.world.fireFrom(bot, 0, 1)
    run(1, (dt) => match.update(dt))
    expect(match.result).toEqual({ kind: 'defeat', place: 4 })
  })

  it('time up with bots still in is a draw (or a defeat if set so)', () => {
    const draw = new Match(open, settings, still)
    run(13.2, (dt) => draw.update(dt))
    expect(draw.result).toEqual({ kind: 'timeup' })

    const defeat = new Match(open, { ...settings, timeUpResult: 'defeat' }, still)
    run(13.2, (dt) => defeat.update(dt))
    expect(defeat.result).toEqual({ kind: 'defeat', place: 2 })
  })

  it('uses the number of bots from the settings', () => {
    expect(new Match(CANYON, { ...SETTINGS, botCount: 5 }).world.fighters).toHaveLength(6)
    expect(new Match(CANYON).world.fighters).toHaveLength(SETTINGS.botCount + 1)
  })
})
