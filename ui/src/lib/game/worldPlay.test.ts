import { describe, expect, it } from 'vitest'
import { Match } from './match'
import { SEEK_AFTER_SECONDS, Bots } from './bots'
import { BOT_LEVELS, SETTINGS } from './settings'
import { World } from './world'
import { arenaFor, WORLDS, WORLD_SIZES } from './worlds'

const tick = 1 / 30

/** A fixed random sequence, so every run is the same. */
function seeded(seed: number): () => number {
  let a = seed
  return () => {
    a = (a + 0x6d2b79f5) >>> 0
    let t = Math.imul(a ^ (a >>> 15), a | 1)
    t ^= t + Math.imul(t ^ (t >>> 7), t | 61)
    return ((t ^ (t >>> 14)) >>> 0) / 4294967296
  }
}

/** Every fighter is a bot, so the match plays itself. */
function botMatch(id: (typeof WORLDS)[number]['id'], size: (typeof WORLD_SIZES)[number], overrides = {}) {
  const settings = { ...SETTINGS, botCount: 3, botLevel: 'hard' as const, ...overrides }
  const match = new Match(arenaFor(id, size), settings, { random: seeded(5) })
  match.bots?.addBot(0)
  return match
}

describe('matches in every world', () => {
  it.each(WORLDS.map((w) => w.id))('%s Large: a match of bots ends with a winner before the time is up', (id) => {
    const match = botMatch(id, 'large')
    for (let t = 0; t < 400 && match.phase !== 'over'; t += tick) match.update(tick)
    expect(match.phase).toBe('over')
    expect(match.result?.kind).not.toBe('timeup')
  })

  it.each(WORLDS.map((w) => w.id))('%s Large: overtime removes every wall and bush', (id) => {
    const match = botMatch(id, 'large', { matchSeconds: 2, countdownSeconds: 0, overtimeSeconds: 30, botLevel: 'easy' })
    expect(match.world.walls.length).toBeGreaterThan(0)
    expect(match.world.bushes.length).toBeGreaterThan(0)
    for (let t = 0; t < 4 && !match.overtime; t += tick) match.update(tick)
    expect(match.overtime).toBe(true)
    expect(match.world.walls).toHaveLength(0)
    expect(match.world.bushes).toHaveLength(0)
  })

  it.each(WORLDS.flatMap((w) => WORLD_SIZES.map((size) => ({ id: w.id, size }))))(
    '$id $size: Training starts at the start point with every dummy standing',
    ({ id, size }) => {
      const arena = arenaFor(id, size)
      const world = new World(arena)
      expect(world.player).toMatchObject({ x: arena.start.x, z: arena.start.z })
      expect(world.dummies).toHaveLength(arena.dummies.length)
      world.step(tick)
      expect(world.player.x).toBeCloseTo(arena.start.x, 3)
    },
  )
})

describe('bots in a big world', () => {
  it('walk towards the nearest fighter after six seconds without seeing anyone', () => {
    const arena = { ...arenaFor('canyon', 'large'), walls: [], bushes: [] }
    const world = new World({ ...arena, spawns: [{ x: -20, z: 0 }, { x: 20, z: 0 }] }, { fighters: 2 })
    const bots = new Bots(world, BOT_LEVELS.easy, true, () => 0.5)
    const before = Math.hypot(world.fighters[1].x - world.player.x, world.fighters[1].z - world.player.z)
    for (let t = 0; t < SEEK_AFTER_SECONDS - 1; t += tick) {
      bots.think(tick)
      world.step(tick)
    }
    const early = world.fighters[1].x
    for (let t = 0; t < 12; t += tick) {
      bots.think(tick)
      world.step(tick)
    }
    // Before six seconds the bot only wanders; afterwards it closes in on the player.
    expect(Math.abs(early - 20)).toBeLessThan(before)
    expect(world.fighters[1].x).toBeLessThan(early - 3)
  })
})
