import { describe, expect, it, vi } from 'vitest'
import { en } from '../i18n/en'
import { CANYON } from './arena'
import { World } from './world'
import { arenaFor, insideWall, reachable, SIZE_DIMENSIONS, WORLD_SIZES, WORLDS } from './worlds'

const every = WORLDS.flatMap((w) => WORLD_SIZES.map((size) => [w.id, size] as const))
const cover = (id: (typeof WORLDS)[number]['id'], size: (typeof WORLD_SIZES)[number]) => {
  const a = arenaFor(id, size)
  return a.walls.length + a.bushes.length
}

describe('world catalogue', () => {
  it('has 13 worlds with unique ids, the first three free', () => {
    expect(WORLDS).toHaveLength(13)
    expect(new Set(WORLDS.map((w) => w.id)).size).toBe(13)
    expect(WORLDS.filter((w) => w.free).map((w) => w.id)).toEqual(['canyon', 'jungle-ruins', 'neon-docks'])
  })

  it('names every world and size', () => {
    for (const w of WORLDS) expect(en).toHaveProperty(`world.${w.id}`)
    for (const s of WORLD_SIZES) expect(en).toHaveProperty(`worldSize.${s}`)
  })

  it('Canyon Small is today’s arena', () => {
    expect(arenaFor('canyon', 'small')).toEqual(CANYON)
  })

  it('Medium has about 1.5 times and Large about 2 times the Small ground', () => {
    const area = (s: keyof typeof SIZE_DIMENSIONS) => SIZE_DIMENSIONS[s].width * SIZE_DIMENSIONS[s].depth
    expect(area('small')).toBe(30 * 24)
    expect(area('medium') / area('small')).toBeCloseTo(1.5, 1)
    expect(area('large') / area('small')).toBeGreaterThan(1.9)
    expect(area('large') / area('small')).toBeLessThan(2.1)
  })
})

describe.each(every)('%s %s', (id, size) => {
  const arena = arenaFor(id, size)
  const centre = { x: 0, z: 0 }

  it('has its size and at least 9 spawns', () => {
    expect(arena.width).toBe(SIZE_DIMENSIONS[size].width)
    expect(arena.depth).toBe(SIZE_DIMENSIONS[size].depth)
    expect(arena.spawns.length).toBeGreaterThanOrEqual(9)
  })

  it('keeps spawns, start and dummies out of walls, with a path to the centre', () => {
    for (const p of [...arena.spawns, arena.start, ...arena.dummies]) {
      expect(insideWall(arena, p), JSON.stringify(p)).toBe(false)
      expect(reachable(arena, p, centre), JSON.stringify(p)).toBe(true)
      expect(Math.abs(p.x)).toBeLessThan(arena.width / 2)
      expect(Math.abs(p.z)).toBeLessThan(arena.depth / 2)
    }
  })

  it('has walls and bushes and fits a full match', () => {
    expect(arena.walls.length).toBeGreaterThan(0)
    expect(arena.bushes.length).toBeGreaterThan(0)
    expect(new World(arena, { fighters: 9 }).fighters).toHaveLength(9)
    expect(new World(arena).dummies).toHaveLength(3)
  })
})

describe('layouts', () => {
  it('a bigger size has more cover', () => {
    for (const w of WORLDS) {
      expect(cover(w.id, 'medium'), w.id).toBeGreaterThan(cover(w.id, 'small'))
      expect(cover(w.id, 'large'), w.id).toBeGreaterThan(cover(w.id, 'medium'))
    }
  })

  it('every world has its own map', () => {
    const maps = new Set(WORLDS.map((w) => JSON.stringify(arenaFor(w.id, 'small').walls)))
    expect(maps.size).toBe(13)
  })

  it('the same world and size gives the same map every time', async () => {
    const before = JSON.stringify(every.map(([id, size]) => arenaFor(id, size)))
    vi.resetModules()
    const fresh = await import('./worlds')
    expect(JSON.stringify(every.map(([id, size]) => fresh.arenaFor(id, size)))).toBe(before)
  })
})
