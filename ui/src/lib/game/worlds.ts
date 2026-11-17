import { CANYON, type Arena, type Circle, type Decoration, type Rect } from './arena'
import { PLAYER_RADIUS } from './world'

export const WORLD_SIZES = ['small', 'medium', 'large'] as const
export type WorldSize = (typeof WORLD_SIZES)[number]

export type WorldId =
  | 'canyon'
  | 'jungle-ruins'
  | 'neon-docks'
  | 'lava-forge'
  | 'sky-islands'
  | 'crystal-caves'
  | 'mini-city'
  | 'kata-jungle'
  | 'candy-factory'
  | 'robot-workshop'
  | 'pirate-cove'
  | 'moon-base'
  | 'desert-oasis'

export type WorldTheme =
  | 'canyon'
  | 'jungle'
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
  free: boolean
  theme: WorldTheme
  /** Seed of the layout generator: the same seed always gives the same layout. */
  seed: number
}

/** The first three worlds are free; the others are bought with world coins. */
export const WORLDS: readonly WorldInfo[] = [
  { id: 'canyon', free: true, theme: 'canyon', seed: 1 },
  { id: 'jungle-ruins', free: true, theme: 'jungle', seed: 2 },
  { id: 'neon-docks', free: true, theme: 'neon', seed: 3 },
  { id: 'lava-forge', free: false, theme: 'lava', seed: 4 },
  { id: 'sky-islands', free: false, theme: 'sky', seed: 5 },
  { id: 'crystal-caves', free: false, theme: 'crystal', seed: 6 },
  { id: 'mini-city', free: false, theme: 'city', seed: 7 },
  { id: 'kata-jungle', free: false, theme: 'kata', seed: 8 },
  { id: 'candy-factory', free: false, theme: 'candy', seed: 9 },
  { id: 'robot-workshop', free: false, theme: 'robot', seed: 10 },
  { id: 'pirate-cove', free: false, theme: 'pirate', seed: 11 },
  { id: 'moon-base', free: false, theme: 'moon', seed: 12 },
  { id: 'desert-oasis', free: false, theme: 'oasis', seed: 13 },
]

export const WORLD_IDS: readonly WorldId[] = WORLDS.map((w) => w.id)
/** The world every account starts with (Canyon, Small). */
export const DEFAULT_WORLD: WorldId = 'canyon'

export function isWorldId(value: unknown): value is WorldId {
  return typeof value === 'string' && (WORLD_IDS as readonly string[]).includes(value)
}

export function isWorldSize(value: unknown): value is WorldSize {
  return typeof value === 'string' && (WORLD_SIZES as readonly string[]).includes(value)
}

/** 0 for Small, 1 for Medium, 2 for Large. */
export function sizeIndex(size: WorldSize): number {
  return WORLD_SIZES.indexOf(size)
}

interface SizeLayout {
  width: number
  depth: number
  /** Placements; each one is drawn twice, mirrored left and right. */
  walls: number
  bushes: number
  spawns: number
  decorations: number
}

const LAYOUT: Record<WorldSize, SizeLayout> = {
  small: { width: 30, depth: 24, walls: 3, bushes: 3, spawns: 9, decorations: 5 },
  medium: { width: 36, depth: 30, walls: 5, bushes: 5, spawns: 10, decorations: 8 },
  large: { width: 42, depth: 34, walls: 7, bushes: 7, spawns: 12, decorations: 11 },
}

interface Point {
  x: number
  z: number
}

/** Walls keep this far from the start, dummies, spawns and centre. */
const POINT_CLEARANCE = 1.6
/** Walls keep this far from the straight line each spawn has to the centre. */
const LINE_CLEARANCE = PLAYER_RADIUS + 0.6

const round = (value: number) => Math.round(value * 100) / 100 + 0
const dist = (a: Point, b: Point) => Math.hypot(a.x - b.x, a.z - b.z)

/** Mulberry32: a small seeded random generator. */
function seeded(seed: number): () => number {
  let a = seed
  return () => {
    a = (a + 0x6d2b79f5) | 0
    let t = Math.imul(a ^ (a >>> 15), a | 1)
    t ^= t + Math.imul(t ^ (t >>> 7), t | 61)
    return ((t ^ (t >>> 14)) >>> 0) / 4294967296
  }
}

function distanceToRect(p: Point, rect: Rect): number {
  const dx = Math.max(Math.abs(p.x - rect.x) - rect.w / 2, 0)
  const dz = Math.max(Math.abs(p.z - rect.z) - rect.d / 2, 0)
  return Math.hypot(dx, dz)
}

/** Points every 0.2 along the straight line from `a` to `b`. */
function sampleLine(a: Point, b: Point): Point[] {
  const steps = Math.ceil(dist(a, b) / 0.2)
  return Array.from({ length: steps + 1 }, (_, i) => ({
    x: a.x + ((b.x - a.x) * i) / steps,
    z: a.z + ((b.z - a.z) * i) / steps,
  }))
}

function generate(world: WorldInfo, size: WorldSize): Arena {
  const layout = LAYOUT[size]
  const { width, depth } = layout
  const random = seeded(world.seed * 3 + WORLD_SIZES.indexOf(size))
  const between = (lo: number, hi: number) => lo + random() * (hi - lo)

  // Player spawn at the bottom centre, the others on a ring around the arena.
  const player = { x: 0, z: round(depth / 2 - 2.5) }
  const ring = Array.from({ length: layout.spawns - 1 }, (_, i) => {
    const angle = Math.PI / 2 + ((i + 1) * 2 * Math.PI) / layout.spawns
    return { x: round(Math.cos(angle) * (width / 2 - 2.5)), z: round(Math.sin(angle) * (depth / 2 - 2.5)) }
  }).sort((a, b) => dist(b, player) - dist(a, player))
  const spawns = [player, ...ring]

  const start = { x: 0, z: round(depth / 2 - 4) }
  const dummies = [
    { x: round(-width * 0.2), z: round(-depth * 0.25) },
    { x: 0, z: round(-depth * 0.125) },
    { x: round(width * 0.2), z: round(-depth * 0.25) },
  ]

  const origin = { x: 0, z: 0 }
  const points = [origin, start, ...dummies, ...spawns]
  const lines = spawns.flatMap((spawn) => sampleLine(spawn, origin))
  const wallFits = (rect: Rect) =>
    points.every((p) => distanceToRect(p, rect) >= POINT_CLEARANCE) &&
    lines.every((p) => distanceToRect(p, rect) >= LINE_CLEARANCE)

  const walls: Rect[] = []
  for (let i = 0; i < layout.walls; i++) {
    for (let attempt = 0; attempt < 300; attempt++) {
      const horizontal = random() < 0.5
      const long = between(3, 5)
      const rect = {
        x: round(between(3.5, width / 2 - 5)),
        z: round(between(-(depth / 2 - 5), depth / 2 - 5)),
        w: round(horizontal ? long : 1.6),
        d: round(horizontal ? 1.6 : long),
      }
      const pair = [rect, { ...rect, x: -rect.x }]
      if (pair.every(wallFits)) {
        walls.push(...pair)
        break
      }
    }
  }

  const bushes: Circle[] = []
  for (let i = 0; i < layout.bushes; i++) {
    for (let attempt = 0; attempt < 300; attempt++) {
      const bush = {
        x: round(between(3.5, width / 2 - 4)),
        z: round(between(-(depth / 2 - 4), depth / 2 - 4)),
        r: round(between(1.4, 1.9)),
      }
      const pair = [bush, { ...bush, x: -bush.x }]
      if (pair.every((b) => points.every((p) => dist(p, b) >= b.r + 1.2))) {
        bushes.push(...pair)
        break
      }
    }
  }

  const kinds: Decoration['kind'][] = ['crate', 'skull', 'rock', 'barrel']
  const decorations: Decoration[] = []
  for (let i = 0; i < layout.decorations; i++) {
    for (let attempt = 0; attempt < 100; attempt++) {
      const x = round(between(-(width / 2 - 2), width / 2 - 2))
      const z = round(between(-(depth / 2 - 2), depth / 2 - 2))
      const p = { x, z }
      if (points.every((q) => dist(p, q) >= 1.5) && walls.every((w) => distanceToRect(p, w) >= 0.8)) {
        decorations.push({ kind: kinds[Math.floor(random() * kinds.length)], x, z, turn: round(random() * Math.PI * 2) })
        break
      }
    }
  }

  return { width, depth, walls, bushes, decorations, dummies, start, spawns }
}

/** The arena of a world at a size; Canyon Small is the original `CANYON`. */
export function arenaFor(worldId: WorldId, size: WorldSize): Arena {
  if (worldId === 'canyon' && size === 'small') return CANYON
  const world = WORLDS.find((w) => w.id === worldId)
  if (!world) throw new Error(`Unknown world: ${worldId}`)
  return generate(world, size)
}
