import { describe, expect, it } from 'vitest'
import { CANYON } from './arena'
import { Bots } from './bots'
import { Match } from './match'
import { BOT_LEVELS, SETTINGS } from './settings'
import { World } from './world'
import { WORLDS, WORLD_SIZES, arenaFor } from './worlds'

const tick = 1 / 60

function run(seconds: number, each: (dt: number) => void) {
  for (let t = 0; t < seconds; t += tick) each(tick)
}

/** A repeatable random number generator, so a match plays the same way every run. */
function seeded(seed: number): () => number {
  let s = seed
  return () => {
    s = (s * 1664525 + 1013904223) % 4294967296
    return s / 4294967296
  }
}

const WORLD_IDS = WORLDS.map((w) => w.id)
const CASES = WORLDS.flatMap((w) => WORLD_SIZES.map((size) => ({ id: w.id, size })))

describe('bots-only large matches', () => {
  it.each(WORLD_IDS)('%s ends without running out of time', (id) => {
    const settings = { ...SETTINGS, botCount: 3, botLevel: 'hard' as const }
    const match = new Match(arenaFor(id, 'large'), settings, { random: seeded(7) })
    match.bots?.addBot(0)
    for (let t = 0; match.phase !== 'over' && t < 400; t += 1 / 30) match.update(1 / 30)
    expect(match.phase).toBe('over')
    expect(match.result?.kind).not.toBe('timeup')
  })
})

describe('overtime on large worlds', () => {
  it.each(WORLD_IDS)('%s loses its walls and bushes', (id) => {
    const settings = { ...SETTINGS, matchSeconds: 1, overtimeSeconds: 5, overtimeRemovesCover: true }
    const match = new Match(arenaFor(id, 'large'), settings, { bots: false })
    expect(match.world.walls.length + match.world.bushes.length).toBeGreaterThan(0)
    for (let t = 0; !match.overtime && t < 20; t += tick) match.update(tick)
    expect(match.overtime).toBe(true)
    expect(match.world.walls).toEqual([])
    expect(match.world.bushes).toEqual([])
  })
})

describe('training', () => {
  it.each(CASES)('$id $size starts at the start with every dummy', ({ id, size }) => {
    const arena = arenaFor(id, size)
    const world = new World(arena)
    expect(world.fighters).toHaveLength(1)
    expect(world.fighters[0]).toMatchObject({ x: arena.start.x, z: arena.start.z })
    expect(world.dummies).toHaveLength(arena.dummies.length)
  })
})

describe('bot seeking', () => {
  it('a bot that has not seen anyone for 6 seconds walks to the nearest opponent', () => {
    const world = new World({ ...CANYON, walls: [], bushes: [] }, { fighters: 2 })
    const bots = new Bots(world, BOT_LEVELS.easy, true, () => 0.5, [0])
    const [player, bot] = world.fighters
    bot.x = 0
    bot.z = 0
    player.x = -12
    player.z = -9
    const distance = () => Math.hypot(player.x - bot.x, player.z - bot.z)

    // Out of sight (8) and before the wait is over: the bot stays put.
    const before = distance()
    run(5.5, (dt) => {
      world.step(dt)
      bots.think(dt)
    })
    expect(Math.hypot(bot.x, bot.z)).toBeLessThan(0.01)

    run(2.5, (dt) => {
      world.step(dt)
      bots.think(dt)
    })
    expect(before - distance()).toBeGreaterThan(3)
  })
})
