import { CANYON, type Arena, type Circle, type Decoration, type Rect } from './arena'

export const WORLD_SIZES = ['small', 'medium', 'large'] as const
export type WorldSize = (typeof WORLD_SIZES)[number]

/** Small is today's arena; Medium has about 1.5 times its ground, Large about 2 times. */
export const WORLD_DIMENSIONS: Record<WorldSize, { width: number; depth: number }> = {
  small: { width: 30, depth: 24 },
  medium: { width: 36, depth: 30 },
  large: { width: 42, depth: 34 },
}

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

export type WorldTheme =
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
  theme: WorldTheme
  /** Fixes the generated layouts, so a world looks the same every time. */
  seed: number
}

export const WORLDS: readonly WorldInfo[] = [
  { id: 'canyon', free: true, theme: 'canyon', seed: 1 },
  { id: 'jungle-ruins', free: true, theme: 'ruins', seed: 2 },
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

/** Text keys of the names (names are never saved, only ids). */
export const worldNameKey = (id: WorldId) => `world.${id}.name` as const
export const worldSizeKey = (size: WorldSize) => `world.size.${size}` as const

/** Pairs of walls and of bushes per side; a bigger size has more cover. */
const COVER: Record<WorldSize, { walls: number; bushes: number; decorations: number }> = {
  small: { walls: 3, bushes: 3, decorations: 7 },
  medium: { walls: 5, bushes: 4, decorations: 10 },
  large: { walls: 7, bushes: 6, decorations: 13 },
}
/** Free space kept between walls, and between walls and the edge, wider than a fighter. */
const GAP = 1.4
const GRID = 3
const DECORATION_KINDS: Decoration['kind'][] = ['crate', 'skull', 'rock', 'barrel']

/** Small, fast, seeded random numbers in [0, 1) (mulberry32). */
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

const round = (n: number) => Math.round(n * 10) / 10

function rectDistance(x: number, z: number, r: Rect): number {
  const dx = Math.max(Math.abs(x - r.x) - r.w / 2, 0)
  const dz = Math.max(Math.abs(z - r.z) - r.d / 2, 0)
  return Math.hypot(dx, dz)
}

function rectsTooClose(a: Rect, b: Rect, gap: number): boolean {
  return Math.abs(a.x - b.x) < (a.w + b.w) / 2 + gap && Math.abs(a.z - b.z) < (a.d + b.d) / 2 + gap
}

const mirror = <T extends { x: number }>(p: T): T => ({ ...p, x: -p.x })

/** Spawns spread around the edge: the player at the front, the farthest bot at the back first. */
function spawnsFor(hw: number, hd: number): { x: number; z: number }[] {
  return [
    { x: 0, z: hd - 3 },
    { x: 0, z: -(hd - 2) },
    { x: -(hw - 3), z: -(hd - 3) },
    { x: hw - 3, z: -(hd - 3) },
    { x: -(hw - 2), z: hd - 4 },
    { x: hw - 2, z: hd - 4 },
    { x: -(hw - 2), z: 0 },
    { x: hw - 2, z: 0 },
    { x: round(hw * 0.45), z: hd - 2.5 },
    { x: round(-hw * 0.45), z: -(hd - 2.5) },
  ]
}

/** A seeded, mirror-symmetric layout (decision D3). */
function generate(info: WorldInfo, size: WorldSize): Arena {
  const { width, depth } = WORLD_DIMENSIONS[size]
  const hw = width / 2
  const hd = depth / 2
  const rnd = random(info.seed * 7919 + WORLD_SIZES.indexOf(size) * 104729)
  const spawns = spawnsFor(hw, hd)
  const start = { x: 0, z: hd - 4 }
  const dummies = CANYON.dummies.map((d) => ({ ...d }))
  const kept: Circle[] = [
    ...spawns.map((s) => ({ ...s, r: 2 })),
    { ...start, r: 2 },
    ...dummies.map((d) => ({ ...d, r: 1.8 })),
    { x: 0, z: 0, r: 3 },
  ]
  // Cover is mirrored, so the free places are kept on both sides.
  const reserved = [...kept, ...kept.map(mirror)]

  const spots: { x: number; z: number }[] = []
  for (let x = -(hw - 2.5); x <= -2; x += GRID) {
    for (let z = -(hd - 2.5); z <= hd - 2.5; z += GRID) spots.push({ x, z })
  }
  for (let i = spots.length - 1; i > 0; i--) {
    const j = Math.floor(rnd() * (i + 1))
    ;[spots[i], spots[j]] = [spots[j], spots[i]]
  }

  const cover = COVER[size]
  const walls: Rect[] = []
  const bushes: Circle[] = []
  const wallFits = (w: Rect) =>
    w.x + w.w / 2 < -GAP / 2 &&
    w.x - w.w / 2 > -hw + GAP &&
    Math.abs(w.z) + w.d / 2 < hd - GAP &&
    walls.every((o) => !rectsTooClose(w, o, GAP)) &&
    bushes.every((b) => rectDistance(b.x, b.z, w) > b.r + 0.3) &&
    reserved.every((c) => rectDistance(c.x, c.z, w) > c.r)
  const bushFits = (b: Circle) =>
    b.x + b.r < -0.3 &&
    b.x - b.r > -hw + 0.5 &&
    Math.abs(b.z) + b.r < hd - 0.5 &&
    walls.every((w) => rectDistance(b.x, b.z, w) > b.r + 0.3) &&
    bushes.every((o) => Math.hypot(b.x - o.x, b.z - o.z) > b.r + o.r + 0.5) &&
    reserved.every((c) => Math.hypot(b.x - c.x, b.z - c.z) > b.r + c.r - 0.5)

  for (let pass = 0; pass < 4; pass++) {
    for (const spot of spots) {
      const wantWall = walls.length < cover.walls
      const wantBush = bushes.length < cover.bushes
      if (!wantWall && !wantBush) break
      const x = round(spot.x + (rnd() - 0.5) * 1.4)
      const z = round(spot.z + (rnd() - 0.5) * 1.4)
      if (wantWall && (!wantBush || rnd() < 0.5)) {
        const long = round(3 + rnd() * 2.5)
        const thick = round(1.4 + rnd() * 0.3)
        const wall = rnd() < 0.5 ? { x, z, w: long, d: thick } : { x, z, w: thick, d: long }
        if (wallFits(wall)) walls.push(wall)
      } else {
        const bush = { x, z, r: round(1.3 + rnd() * 0.6) }
        if (bushFits(bush)) bushes.push(bush)
      }
    }
  }

  const allWalls = [...walls, ...walls.map(mirror)]
  const allBushes = [...bushes, ...bushes.map(mirror)]
  const decorations: Decoration[] = []
  for (let tries = 0; decorations.length < cover.decorations && tries < 500; tries++) {
    const x = round((rnd() * 2 - 1) * (hw - 1.5))
    const z = round((rnd() * 2 - 1) * (hd - 1.5))
    const free =
      allWalls.every((w) => rectDistance(x, z, w) > 0.8) &&
      allBushes.every((b) => Math.hypot(x - b.x, z - b.z) > b.r + 0.5) &&
      reserved.every((c) => Math.hypot(x - c.x, z - c.z) > c.r) &&
      decorations.every((d) => Math.hypot(x - d.x, z - d.z) > 2)
    if (free) {
      const kind = DECORATION_KINDS[Math.floor(rnd() * DECORATION_KINDS.length)]
      decorations.push({ kind, x, z, turn: round((rnd() * 2 - 1) * Math.PI) })
    }
  }

  return { width, depth, walls: allWalls, bushes: allBushes, decorations, dummies, start, spawns }
}

/** The layout of a world in a size; Canyon Small is today's arena. */
export function arenaFor(id: WorldId, size: WorldSize): Arena {
  if (id === 'canyon' && size === 'small') return CANYON
  return generate(worldInfo(id), size)
}
