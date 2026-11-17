import { describe, expect, it } from 'vitest'
import { CANYON, type Arena, type Rect } from './arena'
import { PLAYER_RADIUS } from './world'
import { WORLDS, WORLD_SIZES, arenaFor, type WorldId, type WorldSize } from './worlds'

const SIZES: Record<WorldSize, { width: number; depth: number; ratio: number }> = {
  small: { width: 30, depth: 24, ratio: 1 },
  medium: { width: 36, depth: 30, ratio: 1.5 },
  large: { width: 42, depth: 34, ratio: 2 },
}

const ALL = WORLDS.flatMap((world) => WORLD_SIZES.map((size) => ({ id: world.id, size, arena: arenaFor(world.id, size) })))

function distanceTo(p: { x: number; z: number }, rect: Rect): number {
  const dx = Math.max(Math.abs(p.x - rect.x) - rect.w / 2, 0)
  const dz = Math.max(Math.abs(p.z - rect.z) - rect.d / 2, 0)
  return Math.hypot(dx, dz)
}

const STEP = 0.25

/** Grid cells (as "i,j") a fighter can walk to from the centre. */
function reachableFromCentre(arena: Arena): Set<string> {
  const key = (i: number, j: number) => `${i},${j}`
  const limitX = Math.floor((arena.width / 2 - PLAYER_RADIUS) / STEP)
  const limitZ = Math.floor((arena.depth / 2 - PLAYER_RADIUS) / STEP)
  const free = (i: number, j: number) =>
    Math.abs(i) <= limitX &&
    Math.abs(j) <= limitZ &&
    arena.walls.every((w) => distanceTo({ x: i * STEP, z: j * STEP }, w) >= PLAYER_RADIUS)

  const seen = new Set([key(0, 0)])
  const queue: [number, number][] = [[0, 0]]
  for (let n = 0; n < queue.length; n++) {
    const [i, j] = queue[n]
    for (const [di, dj] of [
      [1, 0],
      [-1, 0],
      [0, 1],
      [0, -1],
    ]) {
      if (!seen.has(key(i + di, j + dj)) && free(i + di, j + dj)) {
        seen.add(key(i + di, j + dj))
        queue.push([i + di, j + dj])
      }
    }
  }
  return seen
}

function cellOf(p: { x: number; z: number }): string {
  return `${Math.round(p.x / STEP)},${Math.round(p.z / STEP)}`
}

describe('worlds', () => {
  it('has 13 unique worlds, the first three free', () => {
    expect(WORLDS).toHaveLength(13)
    expect(new Set(WORLDS.map((w) => w.id)).size).toBe(13)
    expect(WORLDS.filter((w) => w.free).map((w) => w.id)).toEqual(['canyon', 'jungle-ruins', 'neon-docks'])
  })

  it('Canyon Small is the original canyon arena', () => {
    expect(arenaFor('canyon', 'small')).toEqual(CANYON)
  })

  it('every world and size has its dimensions and ground ratio', () => {
    const smallGround = SIZES.small.width * SIZES.small.depth
    for (const { id, size, arena } of ALL) {
      const expected = SIZES[size]
      expect(arena.width, `${id} ${size}`).toBe(expected.width)
      expect(arena.depth, `${id} ${size}`).toBe(expected.depth)
      expect((arena.width * arena.depth) / smallGround, `${id} ${size}`).toBeCloseTo(expected.ratio, 1)
    }
  })

  it('every size has at least 9 spawns and a few walls and bushes', () => {
    for (const { id, size, arena } of ALL) {
      expect(arena.spawns.length, `${id} ${size} spawns`).toBeGreaterThanOrEqual(9)
      expect(arena.walls.length, `${id} ${size} walls`).toBeGreaterThanOrEqual(2)
      expect(arena.bushes.length, `${id} ${size} bushes`).toBeGreaterThanOrEqual(2)
    }
  })

  it('no spawn, start or dummy is inside a wall', () => {
    for (const { id, size, arena } of ALL) {
      const points = [arena.start, ...arena.dummies, ...arena.spawns]
      for (const p of points) {
        for (const wall of arena.walls) {
          expect(distanceTo(p, wall), `${id} ${size} point (${p.x}, ${p.z})`).toBeGreaterThanOrEqual(
            PLAYER_RADIUS - 1e-9,
          )
        }
      }
    }
  })

  it('every spawn, the start and every dummy can walk to the centre', () => {
    for (const { id, size, arena } of ALL) {
      const reached = reachableFromCentre(arena)
      expect(reached.has('0,0'), `${id} ${size} centre`).toBe(true)
      for (const p of [arena.start, ...arena.dummies, ...arena.spawns]) {
        expect(reached.has(cellOf(p)), `${id} ${size} point (${p.x}, ${p.z})`).toBe(true)
      }
    }
  })

  it('generated worlds have a clear straight line from every spawn to the centre', () => {
    for (const { id, size, arena } of ALL) {
      // Canyon Small is kept as it is; its spawn at (0, -10) sits behind a wall.
      if (id === 'canyon' && size === 'small') continue
      for (const spawn of arena.spawns) {
        for (let t = 0; t <= 1; t += 0.01) {
          const p = { x: spawn.x * (1 - t), z: spawn.z * (1 - t) }
          for (const wall of arena.walls) {
            expect(distanceTo(p, wall), `${id} ${size} spawn (${spawn.x}, ${spawn.z})`).toBeGreaterThanOrEqual(
              PLAYER_RADIUS,
            )
          }
        }
      }
    }
  })

  it('cover grows with the size', () => {
    const cover = (id: WorldId, size: WorldSize) => {
      const arena = arenaFor(id, size)
      return arena.walls.length + arena.bushes.length
    }
    for (const world of WORLDS) {
      const small = cover(world.id, 'small')
      const medium = cover(world.id, 'medium')
      const large = cover(world.id, 'large')
      expect(medium, `${world.id} medium`).toBeGreaterThan(small)
      expect(large, `${world.id} large`).toBeGreaterThan(medium)
    }
  })

  it('the same world and size always give the same layout', () => {
    for (const world of WORLDS) {
      for (const size of WORLD_SIZES) {
        expect(arenaFor(world.id, size), `${world.id} ${size}`).toEqual(arenaFor(world.id, size))
      }
    }
  })
})
