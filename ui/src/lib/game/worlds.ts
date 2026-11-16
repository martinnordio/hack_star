import { CANYON, type Arena, type Circle, type Decoration, type Rect } from './arena'

export const WORLD_IDS = [
  'canyon',
  'jungle-ruins',
  'neon-docks',
  'lava-forge',
  'sky-islands',
  'crystal-caves',
  'mini-city',
  'kata-jungle',
  'candy-factory',
  'robot-workshop',
  'pirate-cove',
  'moon-base',
  'desert-oasis',
] as const
export type WorldId = (typeof WORLD_IDS)[number]

export const WORLD_SIZES = ['small', 'medium', 'large'] as const
export type WorldSize = (typeof WORLD_SIZES)[number]

export type ThemeId =
  | 'canyon'
  | 'ruins'
  | 'neon'
  | 'lava'
  | 'sky'
  | 'crystal'
  | 'city'
  | 'kata'
  | 'candy'
  | 'robot'
  | 'pirate'
  | 'moon'
  | 'oasis'

export interface WorldInfo {
  id: WorldId
  /** Unlocked in Small for every account. */
  free: boolean
  theme: ThemeId
  /** Fixes the generated layout; changing it changes the world's map. */
  seed: number
}

export const WORLDS: readonly WorldInfo[] = [
  { id: 'canyon', free: true, theme: 'canyon', seed: 1 },
  { id: 'jungle-ruins', free: true, theme: 'ruins', seed: 1201 },
  { id: 'neon-docks', free: true, theme: 'neon', seed: 2333 },
  { id: 'lava-forge', free: false, theme: 'lava', seed: 3407 },
  { id: 'sky-islands', free: false, theme: 'sky', seed: 4519 },
  { id: 'crystal-caves', free: false, theme: 'crystal', seed: 5623 },
  { id: 'mini-city', free: false, theme: 'city', seed: 6737 },
  { id: 'kata-jungle', free: false, theme: 'kata', seed: 7841 },
  { id: 'candy-factory', free: false, theme: 'candy', seed: 8951 },
  { id: 'robot-workshop', free: false, theme: 'robot', seed: 9067 },
  { id: 'pirate-cove', free: false, theme: 'pirate', seed: 10177 },
  { id: 'moon-base', free: false, theme: 'moon', seed: 11287 },
  { id: 'desert-oasis', free: false, theme: 'oasis', seed: 12391 },
]

/** Ground per size: Medium about 1.5×, Large about 2× the Small ground. */
export const SIZE_DIMENSIONS: Record<WorldSize, { width: number; depth: number }> = {
  small: { width: 30, depth: 24 },
  medium: { width: 36, depth: 30 },
  large: { width: 42, depth: 34 },
}

export function isWorldId(value: unknown): value is WorldId {
  return typeof value === 'string' && (WORLD_IDS as readonly string[]).includes(value)
}

export function isWorldSize(value: unknown): value is WorldSize {
  return typeof value === 'string' && (WORLD_SIZES as readonly string[]).includes(value)
}

export function worldInfo(id: WorldId): WorldInfo {
  const info = WORLDS.find((w) => w.id === id)
  if (!info) throw new Error(`Unknown world ${id}`)
  return info
}

/** Fighters keep this distance from walls; the same radius as the player. */
const CLEARANCE = 0.5
const STEP = 0.5

function overlapsRect(x: number, z: number, r: number, rect: Rect): boolean {
  const cx = Math.max(rect.x - rect.w / 2, Math.min(x, rect.x + rect.w / 2))
  const cz = Math.max(rect.z - rect.d / 2, Math.min(z, rect.z + rect.d / 2))
  return Math.hypot(x - cx, z - cz) < r
}

export function insideWall(arena: Arena, p: { x: number; z: number }, r = CLEARANCE): boolean {
  return arena.walls.some((w) => overlapsRect(p.x, p.z, r, w))
}

/** Whether a fighter can walk from `from` to `to` around the walls (grid search). */
export function reachable(arena: Arena, from: { x: number; z: number }, to: { x: number; z: number }): boolean {
  const halfW = arena.width / 2 - CLEARANCE
  const halfD = arena.depth / 2 - CLEARANCE
  const cols = Math.floor((halfW * 2) / STEP) + 1
  const rows = Math.floor((halfD * 2) / STEP) + 1
  const cell = (p: { x: number; z: number }) => [
    Math.max(0, Math.min(cols - 1, Math.round((p.x + halfW) / STEP))),
    Math.max(0, Math.min(rows - 1, Math.round((p.z + halfD) / STEP))),
  ]
  const free = (c: number, r: number) => !insideWall(arena, { x: -halfW + c * STEP, z: -halfD + r * STEP })
  const [sc, sr] = cell(from)
  const [tc, tr] = cell(to)
  if (!free(sc, sr) || !free(tc, tr)) return false
  const seen = new Uint8Array(cols * rows)
  const queue = [sc + sr * cols]
  seen[queue[0]] = 1
  for (let i = 0; i < queue.length; i++) {
    const c = queue[i] % cols
    const r = Math.floor(queue[i] / cols)
    if (c === tc && r === tr) return true
    for (const [nc, nr] of [
      [c + 1, r],
      [c - 1, r],
      [c, r + 1],
      [c, r - 1],
    ]) {
      if (nc < 0 || nr < 0 || nc >= cols || nr >= rows) continue
      const k = nc + nr * cols
      if (seen[k] || !free(nc, nr)) continue
      seen[k] = 1
      queue.push(k)
    }
  }
  return false
}

/** mulberry32: a small, fixed random sequence per seed. */
function random(seed: number): () => number {
  let a = seed >>> 0
  return () => {
    a = (a + 0x6d2b79f5) >>> 0
    let t = a
    t = Math.imul(t ^ (t >>> 15), t | 1)
    t ^= t + Math.imul(t ^ (t >>> 7), t | 61)
    return ((t ^ (t >>> 14)) >>> 0) / 4294967296
  }
}

const DECORATIONS: Decoration['kind'][] = ['crate', 'skull', 'rock', 'barrel']

function spawnsFor(width: number, depth: number): { x: number; z: number }[] {
  const hw = width / 2 - 2
  const hd = depth / 2 - 3
  // The player first, then the bots, farthest first (like the canyon).
  return [
    { x: 0, z: hd },
    { x: 0, z: -hd },
    { x: -hw, z: -hd },
    { x: hw, z: -hd },
    { x: -hw, z: hd },
    { x: hw, z: hd },
    { x: -hw, z: 0 },
    { x: hw, z: 0 },
    { x: hw / 2, z: hd },
    { x: -hw / 2, z: -hd },
  ]
}

function generate(seed: number, width: number, depth: number): Arena {
  const rand = random(seed)
  const between = (lo: number, hi: number) => lo + rand() * (hi - lo)
  const spawns = spawnsFor(width, depth)
  const start = { x: 0, z: depth / 2 - 4 }
  const dummies = CANYON.dummies.map((d) => ({ ...d }))
  const keepClear: Circle[] = [
    ...spawns.map((s) => ({ ...s, r: 2 })),
    { ...start, r: 2 },
    ...dummies.map((d) => ({ ...d, r: 1.8 })),
    { x: 0, z: 0, r: 2.5 },
  ]
  const walls: Rect[] = []
  const bushes: Circle[] = []
  const hits = (x: number, z: number, r: number) =>
    keepClear.some((c) => Math.hypot(x - c.x, z - c.z) < c.r + r) ||
    walls.some((w) => overlapsRect(x, z, r + 1.2, w)) ||
    bushes.some((b) => Math.hypot(x - b.x, z - b.z) < b.r + r + 1.2)

  // Cover pairs in the left half, mirrored to the right; more pairs on more ground.
  const halfW = width / 2
  const halfD = depth / 2
  const pairs = Math.round((width * depth) / 120)
  for (let tries = 0; walls.length / 2 + bushes.length / 2 < pairs && tries < 600; tries++) {
    const x = between(-halfW + 2.5, -1)
    const z = between(-halfD + 2.5, halfD - 2.5)
    if (walls.length <= bushes.length) {
      const long = between(3, 5)
      const thick = between(1.4, 1.6)
      const across = rand() < 0.5
      const wall = { x, z, w: across ? long : thick, d: across ? thick : long }
      const reach = Math.max(wall.w, wall.d) / 2
      if (x + wall.w / 2 > -0.8 || hits(x, z, reach)) continue
      walls.push(wall, { ...wall, x: -x })
    } else {
      const r = between(1.3, 1.9)
      if (x + r > -0.8 || hits(x, z, r)) continue
      bushes.push({ x, z, r }, { x: -x, z, r })
    }
  }

  const decorations: Decoration[] = []
  for (let tries = 0; decorations.length < 7 && tries < 200; tries++) {
    const x = between(-halfW + 1.5, halfW - 1.5)
    const z = between(-halfD + 1.5, halfD - 1.5)
    if (hits(x, z, 0.8) || decorations.some((d) => Math.hypot(x - d.x, z - d.z) < 2)) continue
    decorations.push({ kind: DECORATIONS[Math.floor(rand() * DECORATIONS.length)], x, z, turn: between(-Math.PI, Math.PI) })
  }

  return { width, depth, walls, bushes, decorations, dummies, start, spawns }
}

function playable(arena: Arena): boolean {
  const centre = { x: 0, z: 0 }
  return [...arena.spawns, arena.start, ...arena.dummies].every(
    (p) => !insideWall(arena, p) && reachable(arena, p, centre),
  )
}

const cache = new Map<string, Arena>()

/** The world's map in that size; Canyon Small is today's arena. */
export function arenaFor(id: WorldId, size: WorldSize): Arena {
  const key = `${id}/${size}`
  const known = cache.get(key)
  if (known) return known
  let arena = CANYON
  if (id !== 'canyon' || size !== 'small') {
    const { width, depth } = SIZE_DIMENSIONS[size]
    const seed = worldInfo(id).seed * 3 + WORLD_SIZES.indexOf(size)
    const cover = 2 * Math.round((width * depth) / 120)
    // A seed whose map shuts a fighter in or lacks cover is skipped; the result is still fixed per world and size.
    for (let attempt = 0; ; attempt++) {
      arena = generate(seed + attempt * 7919, width, depth)
      if (arena.walls.length + arena.bushes.length === cover && playable(arena)) break
    }
  }
  cache.set(key, arena)
  return arena
}
