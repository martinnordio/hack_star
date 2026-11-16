import { describe, expect, it } from 'vitest'
import { CANYON, type Arena, type Rect } from './arena'
import { en } from '../i18n/en'
import { arenaFor, isWorldId, sizeIndex, WORLD_DIMENSIONS, WORLD_IDS, WORLD_SIZES, WORLDS, worldInfo } from './worlds'
import { PLAYER_RADIUS } from './world'

const cases = WORLDS.flatMap((w) => WORLD_SIZES.map((size) => ({ id: w.id, size })))

const inWall = (p: { x: number; z: number }, walls: Rect[], margin = 0) =>
  walls.some((w) => Math.abs(p.x - w.x) < w.w / 2 + margin && Math.abs(p.z - w.z) < w.d / 2 + margin)

/** Every point can be reached from the first spawn on a grid the size of a fighter. */
function connected(arena: Arena, points: { x: number; z: number }[]): boolean {
  const cell = 0.5
  const cols = Math.ceil(arena.width / cell)
  const rows = Math.ceil(arena.depth / cell)
  const toCell = (p: { x: number; z: number }) => ({
    c: Math.floor((p.x + arena.width / 2) / cell),
    r: Math.floor((p.z + arena.depth / 2) / cell),
  })
  const startCells = new Set(points.map((p) => toCell(p)).map(({ c, r }) => r * cols + c))
  const open = (c: number, r: number) => {
    if (c < 0 || r < 0 || c >= cols || r >= rows) return false
    // A start point may touch a wall (Canyon's does), so its own cell counts as open.
    if (startCells.has(r * cols + c)) return true
    const p = { x: -arena.width / 2 + (c + 0.5) * cell, z: -arena.depth / 2 + (r + 0.5) * cell }
    return !inWall(p, arena.walls, PLAYER_RADIUS)
  }
  const first = toCell(points[0])
  const seen = new Set<number>([first.r * cols + first.c])
  const queue = [first]
  while (queue.length) {
    const { c, r } = queue.pop()!
    for (const [dc, dr] of [[1, 0], [-1, 0], [0, 1], [0, -1]]) {
      const next = { c: c + dc, r: r + dr }
      const key = next.r * cols + next.c
      if (seen.has(key) || !open(next.c, next.r)) continue
      seen.add(key)
      queue.push(next)
    }
  }
  return points.every((p) => {
    const { c, r } = toCell(p)
    return seen.has(r * cols + c)
  })
}

describe('worlds', () => {
  it('has 13 worlds with unique ids, three of them free', () => {
    expect(WORLDS).toHaveLength(13)
    expect(new Set(WORLDS.map((w) => w.id)).size).toBe(13)
    expect(WORLDS.filter((w) => w.free).map((w) => w.id)).toEqual(['canyon', 'jungle-ruins', 'neon-docks'])
    expect(WORLD_IDS.every(isWorldId)).toBe(true)
    expect(isWorldId('nowhere')).toBe(false)
    expect(() => worldInfo('nowhere' as never)).toThrow('Unknown world')
  })

  it('names every world and size in the texts', () => {
    for (const id of WORLD_IDS) expect(en[`world.${id}` as keyof typeof en], id).toBeTruthy()
    for (const size of WORLD_SIZES) expect(en[`worldSize.${size}` as keyof typeof en], size).toBeTruthy()
  })

  it('gives Canyon Small exactly today\'s arena', () => {
    expect(arenaFor('canyon', 'small')).toEqual(CANYON)
  })

  it.each(cases)('$id $size: size, ground ratio and a free start', ({ id, size }) => {
    const arena = arenaFor(id, size)
    expect(arena).toMatchObject(WORLD_DIMENSIONS[size])
    const ratio = (arena.width * arena.depth) / (CANYON.width * CANYON.depth)
    expect(ratio).toBeCloseTo([1, 1.5, 2][sizeIndex(size)], 0)
    expect(Math.abs(ratio - [1, 1.5, 2][sizeIndex(size)])).toBeLessThan(0.05)
    expect(arena.spawns.length).toBeGreaterThanOrEqual(9)
    expect(arena.dummies).toHaveLength(3)
    for (const p of [...arena.spawns, arena.start, ...arena.dummies]) {
      expect(inWall(p, arena.walls, PLAYER_RADIUS), `${p.x},${p.z}`).toBe(false)
      expect(Math.abs(p.x)).toBeLessThanOrEqual(arena.width / 2)
      expect(Math.abs(p.z)).toBeLessThanOrEqual(arena.depth / 2)
    }
  })

  it.each(cases)('$id $size: fighters and dummies can walk to each other', ({ id, size }) => {
    const arena = arenaFor(id, size)
    expect(connected(arena, [...arena.spawns, arena.start, ...arena.dummies])).toBe(true)
  })

  it.each(WORLDS.map((w) => w.id))('%s: more cover in bigger sizes', (id) => {
    const cover = WORLD_SIZES.map((size) => {
      const arena = arenaFor(id, size)
      return arena.walls.length + arena.bushes.length
    })
    expect(cover[1]).toBeGreaterThan(cover[0])
    expect(cover[2]).toBeGreaterThan(cover[1])
  })

  it('gives the same layout for the same world and size every time', () => {
    expect(arenaFor('lava-forge', 'large')).toEqual(arenaFor('lava-forge', 'large'))
    expect(arenaFor('moon-base', 'medium')).toBe(arenaFor('moon-base', 'medium'))
  })

  it('gives different worlds different layouts', () => {
    expect(arenaFor('jungle-ruins', 'small').walls).not.toEqual(arenaFor('neon-docks', 'small').walls)
  })
})
