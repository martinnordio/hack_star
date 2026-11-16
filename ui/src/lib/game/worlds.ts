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

export const THEME_IDS = [
  'canyon',
  'jungle',
  'neon',
  'lava',
  'sky',
  'crystal',
  'city',
  'kata',
  'candy',
  'robot',
  'pirate',
  'moon',
  'desert',
] as const
export type ThemeId = (typeof THEME_IDS)[number]

export interface WorldInfo {
  id: WorldId
  /** Free worlds are unlocked in Small for every account. */
  free: boolean
  theme: ThemeId
  /** Fixes the layout of the Medium and Large sizes (and Small, except Canyon). */
  seed: number
}

export const WORLDS: readonly WorldInfo[] = [
  { id: 'canyon', free: true, theme: 'canyon', seed: 11 },
  { id: 'jungle-ruins', free: true, theme: 'jungle', seed: 23 },
  { id: 'neon-docks', free: true, theme: 'neon', seed: 37 },
  { id: 'lava-forge', free: false, theme: 'lava', seed: 41 },
  { id: 'sky-islands', free: false, theme: 'sky', seed: 53 },
  { id: 'crystal-caves', free: false, theme: 'crystal', seed: 67 },
  { id: 'mini-city', free: false, theme: 'city', seed: 71 },
  { id: 'kata-jungle', free: false, theme: 'kata', seed: 83 },
  { id: 'candy-factory', free: false, theme: 'candy', seed: 97 },
  { id: 'robot-workshop', free: false, theme: 'robot', seed: 101 },
  { id: 'pirate-cove', free: false, theme: 'pirate', seed: 113 },
  { id: 'moon-base', free: false, theme: 'moon', seed: 127 },
  { id: 'desert-oasis', free: false, theme: 'desert', seed: 139 },
]

/** Ground sizes: Medium has about 1.5 times and Large about 2 times the ground of Small. */
export const WORLD_DIMENSIONS: Record<WorldSize, { width: number; depth: number }> = {
  small: { width: 30, depth: 24 },
  medium: { width: 36, depth: 30 },
  large: { width: 42, depth: 34 },
}

export const DEFAULT_WORLD: { id: WorldId; size: WorldSize } = { id: 'canyon', size: 'small' }

export const isWorldId = (value: unknown): value is WorldId => WORLD_IDS.includes(value as WorldId)
export const isWorldSize = (value: unknown): value is WorldSize => WORLD_SIZES.includes(value as WorldSize)

export function worldInfo(id: WorldId): WorldInfo {
  const info = WORLDS.find((w) => w.id === id)
  if (!info) throw new Error(`Unknown world: ${id}`)
  return info
}

/** Position of a size in WORLD_SIZES: 0 small, 1 medium, 2 large. */
export const sizeIndex = (size: WorldSize): number => WORLD_SIZES.indexOf(size)

function mulberry32(seed: number): () => number {
  let a = seed >>> 0
  return () => {
    a = (a + 0x6d2b79f5) >>> 0
    let t = a
    t = Math.imul(t ^ (t >>> 15), t | 1)
    t ^= t + Math.imul(t ^ (t >>> 7), t | 61)
    return ((t ^ (t >>> 14)) >>> 0) / 4294967296
  }
}

/** Where fighters start, as fractions of half the width and half the depth (Canyon's points). */
const SPAWN_FRACTIONS: [number, number][] = [
  [0, 0.75],
  [0, -0.83],
  [-0.8, -0.75],
  [0.8, -0.75],
  [-0.87, 0.67],
  [0.87, 0.67],
  [-0.53, 0.17],
  [0.53, -0.38],
  [0.4, 0.79],
]
const DUMMY_FRACTIONS: [number, number][] = [
  [-0.4, -0.5],
  [0, -0.25],
  [0.4, -0.5],
]
const DECORATION_KINDS: Decoration['kind'][] = ['crate', 'skull', 'rock', 'barrel']
/** Free space kept between cover and start points, and between pieces of cover. */
const KEEP_OUT = 1.8
const COVER_GAP = 1.8
const EDGE = 1.5

interface Box {
  x0: number
  x1: number
  z0: number
  z1: number
}

const boxOfRect = (r: Rect): Box => ({ x0: r.x - r.w / 2, x1: r.x + r.w / 2, z0: r.z - r.d / 2, z1: r.z + r.d / 2 })
const boxOfCircle = (c: Circle): Box => ({ x0: c.x - c.r, x1: c.x + c.r, z0: c.z - c.r, z1: c.z + c.r })

function distanceToBox(x: number, z: number, b: Box): number {
  return Math.hypot(x - Math.max(b.x0, Math.min(x, b.x1)), z - Math.max(b.z0, Math.min(z, b.z1)))
}

const boxesTooClose = (a: Box, b: Box, gap: number) =>
  a.x0 - gap < b.x1 && a.x1 + gap > b.x0 && a.z0 - gap < b.z1 && a.z1 + gap > b.z0

function generate(world: WorldInfo, size: WorldSize): Arena {
  const { width, depth } = WORLD_DIMENSIONS[size]
  const hx = width / 2
  const hz = depth / 2
  const scale = (width * depth) / (WORLD_DIMENSIONS.small.width * WORLD_DIMENSIONS.small.depth)
  const rand = mulberry32(world.seed * 7919 + sizeIndex(size) * 104729)
  const between = (min: number, max: number) => min + rand() * (max - min)

  const half = (v: number, h: number) => Math.round(v * h * 2) / 2
  const spawns = SPAWN_FRACTIONS.map(([fx, fz]) => ({ x: half(fx, hx), z: half(fz, hz) }))
  const dummies = DUMMY_FRACTIONS.map(([fx, fz]) => ({ x: half(fx, hx), z: half(fz, hz) }))
  const start = { x: 0, z: hz - 4 }
  const keepOut = [...spawns, ...dummies, start]

  const boxes: Box[] = []
  const walls: Rect[] = []
  const bushes: Circle[] = []

  const free = (box: Box) =>
    box.x0 >= -hx + EDGE &&
    box.x1 <= hx - EDGE &&
    box.z0 >= -hz + EDGE &&
    box.z1 <= hz - EDGE &&
    keepOut.every((p) => distanceToBox(p.x, p.z, box) >= KEEP_OUT) &&
    boxes.every((other) => !boxesTooClose(box, other, COVER_GAP))

  /** Places a piece and its mirror image (or just the piece when it sits on the middle line). */
  function place(make: (x: number, z: number) => Rect | Circle, mirror: boolean): void {
    for (let attempt = 0; attempt < 300; attempt++) {
      const x = mirror ? between(2, hx - EDGE) : 0
      const z = between(-hz + EDGE, hz - EDGE)
      const piece = make(x, z)
      const box = 'r' in piece ? boxOfCircle(piece) : boxOfRect(piece)
      const copy = mirror ? { ...piece, x: -x } : null
      // The two halves must not touch each other across the middle.
      if (mirror && box.x0 < KEEP_OUT / 2) continue
      const copyBox = copy ? ('r' in copy ? boxOfCircle(copy) : boxOfRect(copy)) : null
      if (!free(box) || (copyBox && !free(copyBox))) continue
      for (const [item, b] of [[piece, box], [copy, copyBox]] as const) {
        if (!item || !b) continue
        boxes.push(b)
        if ('r' in item) bushes.push(item)
        else walls.push(item)
      }
      return
    }
  }

  const wallShape = (): Rect => {
    const long = between(3, 5)
    const thin = between(1.4, 1.7)
    return rand() < 0.5 ? { x: 0, z: 0, w: long, d: thin } : { x: 0, z: 0, w: thin, d: long }
  }

  // Bushes first: fighters hide in them, so every world must keep some.
  for (let i = 0; i < Math.round(2 * scale); i++) {
    const r = between(1.3, 1.9)
    place((x, z) => ({ x, z, r }), true)
  }
  for (let i = 0; i < Math.round(3 * scale); i++) {
    const shape = wallShape()
    place((x, z) => ({ ...shape, x, z }), true)
  }
  for (let i = 0; i < Math.round(scale); i++) {
    const shape = wallShape()
    place((x, z) => ({ ...shape, x, z }), false)
  }

  const decorations: Decoration[] = []
  for (let i = 0; i < Math.round(7 * scale); i++) {
    for (let attempt = 0; attempt < 100; attempt++) {
      const x = between(-hx + 2, hx - 2)
      const z = between(-hz + 2, hz - 2)
      if (boxes.some((b) => distanceToBox(x, z, b) < 0.8)) continue
      if (keepOut.some((p) => Math.hypot(p.x - x, p.z - z) < 1.2)) continue
      decorations.push({ kind: DECORATION_KINDS[i % DECORATION_KINDS.length], x, z, turn: between(-1, 2) })
      break
    }
  }

  return { width, depth, walls, bushes, decorations, dummies, start, spawns }
}

const cache = new Map<string, Arena>()

/** The arena of a world in a size; the same world and size always give the same layout. */
export function arenaFor(id: WorldId, size: WorldSize): Arena {
  if (id === 'canyon' && size === 'small') return CANYON
  const key = `${id}:${size}`
  let arena = cache.get(key)
  if (!arena) {
    arena = generate(worldInfo(id), size)
    cache.set(key, arena)
  }
  return arena
}
