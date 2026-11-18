import { describe, expect, it } from 'vitest'
import { en, type TextKey } from '../i18n/en'
import { CANYON, type Arena } from './arena'
import { DUMMY_RADIUS, PLAYER_RADIUS } from './world'
import { WORLD_DIMENSIONS, WORLD_SIZES, WORLDS, arenaFor, worldNameKey, worldSizeKey } from './worlds'

const all = WORLDS.flatMap((w) => WORLD_SIZES.map((size) => ({ id: w.id, size, arena: arenaFor(w.id, size) })))

function inWall(arena: Arena, x: number, z: number, r: number): boolean {
  return arena.walls.some((w) => {
    const cx = Math.max(w.x - w.w / 2, Math.min(x, w.x + w.w / 2))
    const cz = Math.max(w.z - w.d / 2, Math.min(z, w.z + w.d / 2))
    return Math.hypot(x - cx, z - cz) < r
  })
}

function inside(arena: Arena, x: number, z: number, r: number): boolean {
  return Math.abs(x) <= arena.width / 2 - r && Math.abs(z) <= arena.depth / 2 - r
}

/** Cells a fighter can reach from the centre, walking between the walls. */
function reachable(arena: Arena, step = 0.25): (x: number, z: number) => boolean {
  const cols = Math.floor(arena.width / step) + 1
  const rows = Math.floor(arena.depth / step) + 1
  const cell = (x: number, z: number) => [Math.round((x + arena.width / 2) / step), Math.round((z + arena.depth / 2) / step)]
  const free = (c: number, r: number) => {
    const x = c * step - arena.width / 2
    const z = r * step - arena.depth / 2
    return inside(arena, x, z, PLAYER_RADIUS) && !inWall(arena, x, z, PLAYER_RADIUS)
  }
  const seen = new Uint8Array(cols * rows)
  const [c0, r0] = cell(0, 0)
  const queue = [[c0, r0]]
  seen[r0 * cols + c0] = 1
  while (queue.length) {
    const [c, r] = queue.pop()!
    for (const [nc, nr] of [[c + 1, r], [c - 1, r], [c, r + 1], [c, r - 1]]) {
      if (nc < 0 || nr < 0 || nc >= cols || nr >= rows || seen[nr * cols + nc] || !free(nc, nr)) continue
      seen[nr * cols + nc] = 1
      queue.push([nc, nr])
    }
  }
  return (x, z) => {
    const [c, r] = cell(x, z)
    return seen[r * cols + c] === 1
  }
}

const cover = (a: Arena) => a.walls.length + a.bushes.length

describe('world catalogue', () => {
  it('has 13 worlds with unique ids, the first three free', () => {
    expect(WORLDS).toHaveLength(13)
    expect(new Set(WORLDS.map((w) => w.id)).size).toBe(13)
    expect(new Set(WORLDS.map((w) => w.theme)).size).toBe(13)
    expect(WORLDS.filter((w) => w.free).map((w) => w.id)).toEqual(['canyon', 'jungle-ruins', 'neon-docks'])
  })

  it('names every world and size in the texts', () => {
    const keys: TextKey[] = [...WORLDS.map((w) => worldNameKey(w.id)), ...WORLD_SIZES.map(worldSizeKey)]
    for (const key of keys) expect(en[key], key).toBeTruthy()
  })

  it('Canyon Small is today\'s arena', () => {
    expect(arenaFor('canyon', 'small')).toEqual(CANYON)
  })

  it('Medium has about 1.5 times the ground of Small, Large about 2 times', () => {
    const ground = (s: keyof typeof WORLD_DIMENSIONS) => WORLD_DIMENSIONS[s].width * WORLD_DIMENSIONS[s].depth
    expect(ground('small')).toBe(CANYON.width * CANYON.depth)
    expect(ground('medium') / ground('small')).toBeCloseTo(1.5, 1)
    expect(ground('large') / ground('small')).toBeCloseTo(2, 1)
  })

  it.each(all)('$id $size: its size, free spawns, start and dummies, all reachable', ({ size, arena }) => {
    expect(arena.width).toBe(WORLD_DIMENSIONS[size].width)
    expect(arena.depth).toBe(WORLD_DIMENSIONS[size].depth)
    expect(arena.spawns.length).toBeGreaterThanOrEqual(9)
    const canReach = reachable(arena)
    for (const p of [...arena.spawns, arena.start]) {
      expect(inside(arena, p.x, p.z, PLAYER_RADIUS), `${p.x},${p.z}`).toBe(true)
      expect(inWall(arena, p.x, p.z, PLAYER_RADIUS), `${p.x},${p.z}`).toBe(false)
      expect(canReach(p.x, p.z), `${p.x},${p.z}`).toBe(true)
    }
    for (const d of arena.dummies) expect(inWall(arena, d.x, d.z, DUMMY_RADIUS)).toBe(false)
    expect(arena.dummies).toHaveLength(CANYON.dummies.length)
    for (const b of arena.bushes) expect(inside(arena, b.x, b.z, 0)).toBe(true)
  })

  it.each(WORLDS)('$id: a bigger size has more cover', ({ id }) => {
    const [small, medium, large] = WORLD_SIZES.map((s) => cover(arenaFor(id, s)))
    expect(small).toBeGreaterThanOrEqual(10)
    expect(medium).toBeGreaterThan(small)
    expect(large).toBeGreaterThan(medium)
  })

  it('gives the same layout for the same world and size every time, and each world its own', () => {
    for (const { id, size, arena } of all) expect(arenaFor(id, size)).toEqual(arena)
    const layouts = all.filter((a) => a.size === 'small').map((a) => JSON.stringify(a.arena.walls))
    expect(new Set(layouts).size).toBe(WORLDS.length)
  })
})
