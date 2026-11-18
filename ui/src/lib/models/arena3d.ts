import * as THREE from 'three'
import { mergeGeometries } from 'three/addons/utils/BufferGeometryUtils.js'
import type { Arena, Circle, Decoration, Rect } from '../game/arena'
import type { WorldTheme } from '../game/worlds'
import { box, capsule, cylinder, part, sphere, toon } from './parts'

const TILE = 1.5

type EdgeKind = 'cliffs' | 'trees' | 'water' | 'clouds' | 'buildings' | 'lollipops' | 'dunes'
type WallKind = 'rock' | 'ruin' | 'crates' | 'crystal' | 'house' | 'machine' | 'blocks' | 'logs'
type CoverKind = 'cactus' | 'fern' | 'post' | 'cloud' | 'crystal' | 'mushroom' | 'hedge' | 'lollipop' | 'palm'

/** How a world theme is drawn: colours and the kind of border, walls and cover (decision D4). */
export interface WorldLook {
  /** Checkerboard of the ground tiles: light, dark. */
  tiles: [string, string]
  /** Ground under the tiles and around the arena (sand, water, lava, sky…). */
  floor: string
  floorGlow?: string
  /** Background gradient behind the 3D scene: top, bottom. */
  sky: [string, string]
  edge: EdgeKind
  edgeColors: [string, string, string]
  edgeGlow?: string
  wall: WallKind
  /** Sides, top. */
  wallColors: [string, string]
  wallGlow?: string
  cover: CoverKind
  /** Patch on the ground, then two colours of the plants or objects. */
  coverColors: [string, string, string]
  coverGlow?: string
}

export const WORLD_LOOKS: Record<WorldTheme, WorldLook> = {
  canyon: {
    tiles: ['#f5cf8e', '#ebbd76'],
    floor: '#d9a35f',
    sky: ['#7fd0ff', '#ffe6b0'],
    edge: 'cliffs',
    edgeColors: ['#c96a35', '#b35a2c', '#d9824a'],
    wall: 'rock',
    wallColors: ['#b5653a', '#e09a5c'],
    cover: 'cactus',
    coverColors: ['#7fbf4a', '#4cbf4f', '#3aa34a'],
  },
  ruins: {
    tiles: ['#a9c98a', '#98ba78'],
    floor: '#5f8f3a',
    sky: ['#8fdcb0', '#eaf7c8'],
    edge: 'trees',
    edgeColors: ['#2f8f3a', '#1f6f2f', '#6b4a2b'],
    wall: 'ruin',
    wallColors: ['#9a9a84', '#5fae3f'],
    cover: 'fern',
    coverColors: ['#4f8f2f', '#2fae4f', '#1f8f3f'],
  },
  neon: {
    tiles: ['#454a6e', '#3a3f60'],
    floor: '#1d2a6a',
    floorGlow: '#0a1a5a',
    sky: ['#1b1446', '#ff7ac8'],
    edge: 'water',
    edgeColors: ['#3a3f60', '#39e6ff', '#2a2f48'],
    edgeGlow: '#39e6ff',
    wall: 'crates',
    wallColors: ['#2f6bff', '#e8327a'],
    wallGlow: '#39ff88',
    cover: 'post',
    coverColors: ['#2a2f48', '#ff4f9a', '#39e6ff'],
    coverGlow: '#ff4f9a',
  },
  lava: {
    tiles: ['#6a5656', '#5a4747'],
    floor: '#8a1a00',
    floorGlow: '#ff4a00',
    sky: ['#3a1010', '#ff8a3a'],
    edge: 'cliffs',
    edgeColors: ['#3a2a2a', '#2a1f1f', '#4a3434'],
    wall: 'rock',
    wallColors: ['#3f3232', '#ff7a1a'],
    wallGlow: '#ff5a00',
    cover: 'crystal',
    coverColors: ['#2a1f1f', '#ff7a1a', '#ffb000'],
    coverGlow: '#ff5a00',
  },
  sky: {
    tiles: ['#a8e88a', '#96da78'],
    floor: '#8fd0ff',
    sky: ['#6fc4ff', '#ffffff'],
    edge: 'clouds',
    edgeColors: ['#ffffff', '#e6f2ff', '#cfe4ff'],
    wall: 'blocks',
    wallColors: ['#d8cdb8', '#6fcf4f'],
    cover: 'cloud',
    coverColors: ['#bfe8a8', '#ffffff', '#e6f2ff'],
  },
  crystal: {
    tiles: ['#4f4486', '#443a78'],
    floor: '#241a4a',
    sky: ['#0f0a2a', '#4b36c9'],
    edge: 'cliffs',
    edgeColors: ['#5a4a9a', '#4a3c86', '#6a5aae'],
    wall: 'crystal',
    wallColors: ['#3a2f6a', '#7fe0ff'],
    wallGlow: '#3ab0ff',
    cover: 'mushroom',
    coverColors: ['#3a2f6a', '#ff8ad8', '#e8d8ff'],
    coverGlow: '#c03aa0',
  },
  city: {
    tiles: ['#9aa0aa', '#8d939d'],
    floor: '#6a6f78',
    sky: ['#7fd0ff', '#e6f4ff'],
    edge: 'buildings',
    edgeColors: ['#ffb15c', '#4aa8ff', '#ff8ac2'],
    wall: 'house',
    wallColors: ['#ffd23f', '#e8322b'],
    cover: 'hedge',
    coverColors: ['#6fbf4a', '#3aa34a', '#2f8f3a'],
  },
  kata: {
    tiles: ['#cfe08a', '#bfd47a'],
    floor: '#4f8f2a',
    sky: ['#9fe8c8', '#fff3c8'],
    edge: 'trees',
    edgeColors: ['#3ac04a', '#2a9a3a', '#8a5a2b'],
    wall: 'logs',
    wallColors: ['#9a6a3a', '#4cbf4f'],
    cover: 'fern',
    coverColors: ['#6fbf3a', '#3ad06a', '#ff8a3a'],
  },
  candy: {
    tiles: ['#ffb8d8', '#ffa6cc'],
    floor: '#e8609e',
    sky: ['#ffd6f0', '#fff3c8'],
    edge: 'lollipops',
    edgeColors: ['#ff4f9a', '#39c6ff', '#ffd23f'],
    wall: 'blocks',
    wallColors: ['#6a3a1a', '#ff6fae'],
    cover: 'lollipop',
    coverColors: ['#ffffff', '#e8327a', '#7f5fff'],
  },
  robot: {
    tiles: ['#a3abbd', '#949caf'],
    floor: '#5a6275',
    sky: ['#3a4a6a', '#b0c0e0'],
    edge: 'buildings',
    edgeColors: ['#6a7285', '#555b66', '#7f889c'],
    edgeGlow: '#ffb000',
    wall: 'machine',
    wallColors: ['#555b66', '#9aa3b5'],
    wallGlow: '#39c6ff',
    cover: 'post',
    coverColors: ['#4a5060', '#ffb000', '#ffe45c'],
    coverGlow: '#ffb000',
  },
  pirate: {
    tiles: ['#f5e0a8', '#ead296'],
    floor: '#2fa8d8',
    sky: ['#7fd0ff', '#fff1c2'],
    edge: 'water',
    edgeColors: ['#8a5a2b', '#c0392b', '#9a9a9a'],
    wall: 'crates',
    wallColors: ['#b07a3c', '#9a6a30'],
    cover: 'palm',
    coverColors: ['#e8d290', '#3aa34a', '#8a5a2b'],
  },
  moon: {
    tiles: ['#c8ccd6', '#bbbfca'],
    floor: '#8a8f9a',
    sky: ['#05051a', '#2a2a6a'],
    edge: 'cliffs',
    edgeColors: ['#9a9faa', '#7f8590', '#b0b5c0'],
    wall: 'machine',
    wallColors: ['#e8edf5', '#b0b8c8'],
    wallGlow: '#39ff88',
    cover: 'crystal',
    coverColors: ['#7f8590', '#39ff88', '#9fffc8'],
    coverGlow: '#1fbf5a',
  },
  oasis: {
    tiles: ['#f2d48a', '#e8c67a'],
    floor: '#e0b060',
    sky: ['#9fd8ff', '#ffe6b0'],
    edge: 'dunes',
    edgeColors: ['#f0c070', '#e0a858', '#f5d090'],
    wall: 'ruin',
    wallColors: ['#d9a35f', '#f2d48a'],
    cover: 'palm',
    coverColors: ['#3fb8d8', '#3aa34a', '#9a6a3a'],
  },
}

// One material per colour, so the merged scenery needs only a few draw calls.
const materials = new Map<string, THREE.MeshToonMaterial>()
function paint(color: string, glow?: string): THREE.MeshToonMaterial {
  const key = `${color}/${glow ?? ''}`
  let material = materials.get(key)
  if (!material) {
    material = toon(color, glow)
    materials.set(key, material)
  }
  return material
}

function seeded(seed: number): () => number {
  let s = seed
  return () => (s = (s * 16807) % 2147483647) / 2147483647
}

const cone = (r: number, h: number, sides = 10) => new THREE.ConeGeometry(r, h, sides)
const blob = (r: number, detail = 0) => new THREE.IcosahedronGeometry(r, detail)

function ground(arena: Arena, look: WorldLook): THREE.Object3D {
  const group = new THREE.Group()
  group.name = 'ground'
  const cols = Math.ceil(arena.width / TILE)
  const rows = Math.ceil(arena.depth / TILE)
  const tiles = new THREE.InstancedMesh(new THREE.BoxGeometry(TILE * 0.96, 0.1, TILE * 0.96), toon('#ffffff'), cols * rows)
  const matrix = new THREE.Matrix4()
  const light = new THREE.Color(look.tiles[0])
  const dark = new THREE.Color(look.tiles[1])
  let i = 0
  for (let c = 0; c < cols; c++) {
    for (let r = 0; r < rows; r++) {
      matrix.setPosition(-arena.width / 2 + TILE * (c + 0.5), -0.05, -arena.depth / 2 + TILE * (r + 0.5))
      tiles.setMatrixAt(i, matrix)
      tiles.setColorAt(i, (c + r) % 2 ? light : dark)
      i++
    }
  }
  tiles.receiveShadow = true
  group.add(tiles)

  // Under the tiles and outside the arena, up to the border.
  const floor = new THREE.Mesh(new THREE.PlaneGeometry(arena.width + 40, arena.depth + 40), paint(look.floor, look.floorGlow))
  floor.rotation.x = -Math.PI / 2
  floor.position.y = -0.11
  floor.receiveShadow = true
  group.add(floor)
  return group
}

/** Big rocks around the edge of the arena (the canyon's cliffs). */
function cliffs(arena: Arena, look: WorldLook, group: THREE.Group) {
  const colors = look.edgeColors.map((c) => paint(c))
  const halfW = arena.width / 2
  const halfD = arena.depth / 2
  const random = seeded(7)
  const place = (x: number, z: number, low = false) => {
    const size = low ? 0.7 + random() * 0.5 : 1.6 + random() * 1.6
    const rock = part(new THREE.DodecahedronGeometry(size, 0), colors[Math.floor(random() * 3)], [x, size * 0.55, z], {
      rotation: [random() * 3, random() * 3, random() * 3],
      scale: [1, low ? 0.6 : 1.2 + random() * 0.8, 1],
    })
    rock.receiveShadow = true
    group.add(rock)
  }
  // The camera looks from the +z side: rocks there stay low so they do not hide the arena.
  for (let x = -halfW - 2; x <= halfW + 2; x += 2.6) {
    place(x, -halfD - 2 - random())
  }
  for (let x = -halfW - 1; x <= halfW + 1; x += 1.4) {
    place(x, halfD + 1 + random() * 0.5, true)
  }
  for (let z = -halfD; z <= halfD; z += 2.6) {
    place(-halfW - 2 - random(), z)
    place(halfW + 2 + random(), z)
  }
}

/** Border pieces like the cliffs: tall at the back and the sides, low at the front (the camera's side). */
function ring(arena: Arena, spacing: number, put: (x: number, z: number, low: boolean, random: () => number) => void) {
  const halfW = arena.width / 2
  const halfD = arena.depth / 2
  const random = seeded(11)
  for (let x = -halfW - 2; x <= halfW + 2; x += spacing) put(x, -halfD - 2 - random(), false, random)
  for (let x = -halfW - 1; x <= halfW + 1; x += spacing * 0.6) put(x, halfD + 1 + random() * 0.5, true, random)
  for (let z = -halfD; z <= halfD; z += spacing) {
    put(-halfW - 2 - random(), z, false, random)
    put(halfW + 2 + random(), z, false, random)
  }
}

function edge(arena: Arena, look: WorldLook): THREE.Group {
  const group = new THREE.Group()
  group.name = 'edge'
  const [a, b, c] = look.edgeColors.map((color) => paint(color))
  const pick = (random: () => number) => [a, b, c][Math.floor(random() * 3)]
  if (look.edge === 'cliffs') cliffs(arena, look, group)
  else if (look.edge === 'trees') {
    ring(arena, 2.4, (x, z, low, random) => {
      if (low) {
        group.add(part(blob(0.6 + random() * 0.3, 1), random() < 0.5 ? a : b, [x, 0.25, z], { scale: [1.4, 0.6, 1] }))
        return
      }
      const h = 1.2 + random() * 1.5
      group.add(part(new THREE.CylinderGeometry(0.28, 0.4, h, 6), c, [x, h / 2, z]))
      group.add(part(blob(1.5 + random() * 0.5, 1), a, [x, h + 0.9, z], { scale: [1, 0.8, 1] }))
      group.add(part(blob(1, 1), b, [x + 0.6, h + 1.8, z + 0.3]))
    })
  } else if (look.edge === 'water') {
    const top = paint(look.edgeColors[1], look.edgeGlow)
    ring(arena, 2.2, (x, z, low, random) => {
      if (low) {
        group.add(part(new THREE.DodecahedronGeometry(0.5 + random() * 0.3, 0), c, [x, 0, z], { scale: [1.3, 0.5, 1] }))
        return
      }
      const h = 1 + random() * 0.8
      group.add(part(new THREE.CylinderGeometry(0.25, 0.28, h + 0.6, 8), a, [x, h / 2 - 0.3, z]))
      group.add(part(sphere(0.3, 8), top, [x, h, z]))
    })
  } else if (look.edge === 'clouds') {
    ring(arena, 2.6, (x, z, low, random) => {
      const r = low ? 0.6 + random() * 0.4 : 1.3 + random()
      group.add(part(blob(r, 1), pick(random), [x, low ? -0.1 : r * 0.2, z], { scale: [1.5, 0.7, 1.1], outline: false }))
    })
  } else if (look.edge === 'buildings') {
    const band = paint(look.edgeGlow ?? '#d6f0ff', look.edgeGlow)
    ring(arena, 3, (x, z, low, random) => {
      const color = pick(random)
      if (low) {
        group.add(part(box(1.4, 0.5, 0.6), color, [x, 0.25, z]))
        return
      }
      const h = 2 + random() * 4
      const w = 2.2 + random() * 0.6
      group.add(part(box(w, h, w), color, [x, h / 2, z]))
      group.add(part(box(w * 1.02, 0.3, w * 1.02), band, [x, h * 0.7, z], { outline: false }))
      group.add(part(box(w * 0.5, 0.5, w * 0.5), color, [x, h + 0.25, z]))
    })
  } else if (look.edge === 'lollipops') {
    const stick = paint('#ffffff')
    ring(arena, 2.4, (x, z, low, random) => {
      const color = pick(random)
      if (low) {
        group.add(part(sphere(0.35, 10), color, [x, 0.3, z]))
        return
      }
      const h = 1.6 + random() * 1.4
      group.add(part(new THREE.CylinderGeometry(0.1, 0.1, h, 6), stick, [x, h / 2, z]))
      group.add(part(new THREE.CylinderGeometry(0.9, 0.9, 0.3, 16), color, [x, h + 0.6, z], { rotation: [Math.PI / 2, 0, 0] }))
    })
  } else {
    ring(arena, 3, (x, z, low, random) => {
      const r = low ? 1 : 2.2 + random() * 1.5
      group.add(part(sphere(r, 12), pick(random), [x, low ? 0 : -r * 0.3, z], { scale: [1.5, low ? 0.4 : 0.6, 1.2], outline: false }))
    })
  }
  group.traverse((o) => {
    if (o instanceof THREE.Mesh) o.receiveShadow = true
  })
  return group
}

/** Where a piece along a wall's long side goes, and the wall's size across it. */
function alongWall(w: Rect) {
  const alongX = w.w >= w.d
  const long = alongX ? w.w : w.d
  const thick = alongX ? w.d : w.w
  return {
    alongX,
    long,
    thick,
    at: (t: number): [number, number] => (alongX ? [w.x + t, w.z] : [w.x, w.z + t]),
    size: (l: number, across: number, h: number) => (alongX ? box(l, h, across) : box(across, h, l)),
  }
}

function wall(w: Rect, look: WorldLook, group: THREE.Group) {
  const side = paint(look.wallColors[0])
  const top = paint(look.wallColors[1])
  // Only molten rock and crystals glow on top; other walls have a glowing band.
  const glowingTop = paint(look.wallColors[1], look.wallGlow)
  const shape = alongWall(w)
  if (look.wall === 'rock') {
    group.add(part(box(w.w, 1.5, w.d), side, [w.x, 0.75, w.z]))
    group.add(part(box(w.w * 0.92, 0.25, w.d * 0.92), glowingTop, [w.x, 1.6, w.z]))
    // A few loose stones at the foot of the wall.
    group.add(part(new THREE.DodecahedronGeometry(0.3), side, [w.x - w.w / 2 + 0.2, 0.2, w.z + w.d / 2 + 0.15]))
    group.add(part(new THREE.DodecahedronGeometry(0.22), top, [w.x + w.w / 2 - 0.1, 0.15, w.z - w.d / 2 - 0.1]))
  } else if (look.wall === 'ruin') {
    group.add(part(box(w.w, 0.9, w.d), side, [w.x, 0.45, w.z]))
    const n = Math.max(2, Math.round(shape.long / 1.1))
    const step = shape.long / n
    for (let i = 0; i < n; i++) {
      const [x, z] = shape.at(-shape.long / 2 + step * (i + 0.5))
      const h = i % 2 ? 0.45 : 0.75
      group.add(part(shape.size(step * 0.9, shape.thick * 0.9, h), side, [x, 0.9 + h / 2, z]))
      if (i % 3 === 0) group.add(part(shape.size(step * 0.95, shape.thick * 0.95, 0.14), top, [x, 0.97 + h, z], { outline: false }))
    }
  } else if (look.wall === 'crates') {
    const band = paint(look.wallGlow ?? '#5a3a1a', look.wallGlow)
    const n = Math.max(2, Math.round(shape.long / 1.4))
    const step = shape.long / n
    for (let i = 0; i < n; i++) {
      const [x, z] = shape.at(-shape.long / 2 + step * (i + 0.5))
      group.add(part(shape.size(step * 0.94, shape.thick, 1.4), i % 2 ? side : top, [x, 0.7, z]))
      group.add(part(shape.size(step * 0.96, shape.thick * 1.04, 0.14), band, [x, 1.15, z], { outline: false }))
      if (i % 2 === 0) group.add(part(box(0.7, 0.7, 0.7), i % 4 ? side : top, [x, 1.75, z], { rotation: [0, 0.3, 0] }))
    }
  } else if (look.wall === 'crystal') {
    group.add(part(box(w.w, 0.4, w.d), side, [w.x, 0.2, w.z]))
    const n = Math.max(3, Math.round(shape.long / 0.8))
    for (let i = 0; i < n; i++) {
      const [x, z] = shape.at(-shape.long / 2 + (shape.long / n) * (i + 0.5))
      const h = 1.2 + ((i * 7) % 3) * 0.4
      group.add(part(cone(0.42, h, 5), glowingTop, [x, 0.4 + h / 2, z], { rotation: [(i % 3) * 0.12 - 0.12, i, (i % 2) * 0.2 - 0.1] }))
    }
  } else if (look.wall === 'house') {
    group.add(part(box(w.w, 1.3, w.d), side, [w.x, 0.65, w.z]))
    const roof = shape.thick * 0.75
    group.add(
      part(shape.size(shape.long * 1.02, roof, roof), top, [w.x, 1.3, w.z], {
        rotation: shape.alongX ? [Math.PI / 4, 0, 0] : [0, 0, Math.PI / 4],
      }),
    )
    const glass = paint('#d6f0ff')
    const n = Math.max(1, Math.floor(shape.long / 1.3))
    for (let i = 0; i < n; i++) {
      const [x, z] = shape.at(-shape.long / 2 + (shape.long / n) * (i + 0.5))
      group.add(part(shape.size(0.5, shape.thick * 1.04, 0.5), glass, [x, 0.75, z], { outline: false }))
    }
  } else if (look.wall === 'machine') {
    group.add(part(box(w.w, 1.2, w.d), side, [w.x, 0.6, w.z]))
    group.add(part(box(w.w * 0.9, 0.2, w.d * 0.9), top, [w.x, 1.3, w.z]))
    group.add(part(box(w.w * 1.02, 0.12, w.d * 1.02), paint(look.wallGlow ?? '#ffffff', look.wallGlow), [w.x, 0.85, w.z], { outline: false }))
    const pipe = new THREE.CylinderGeometry(0.16, 0.16, shape.long * 0.8, 8)
    const [x1, z1] = shape.at(0)
    group.add(part(pipe, side, [x1, 1.55, z1], { rotation: shape.alongX ? [0, 0, Math.PI / 2] : [Math.PI / 2, 0, 0] }))
  } else if (look.wall === 'blocks') {
    group.add(part(box(w.w, 1.2, w.d), side, [w.x, 0.6, w.z]))
    group.add(part(box(w.w + 0.2, 0.35, w.d + 0.2), top, [w.x, 1.35, w.z]))
    // Drips of icing (or tufts of grass) over the front side.
    const n = Math.max(2, Math.round(shape.long / 0.8))
    for (let i = 0; i < n; i++) {
      const [x, z] = shape.at(-shape.long / 2 + (shape.long / n) * (i + 0.5))
      const front: [number, number, number] = shape.alongX ? [x, 1.1, z + w.d / 2 + 0.06] : [x + w.w / 2 + 0.06, 1.1, z]
      group.add(part(sphere(0.16, 8), top, front, { scale: [1, 1.6, 1], outline: false }))
    }
  } else {
    const r = shape.thick * 0.26
    const rotation: [number, number, number] = shape.alongX ? [0, 0, Math.PI / 2] : [Math.PI / 2, 0, 0]
    const log = new THREE.CylinderGeometry(r, r, shape.long, 10)
    for (const offset of [-r, r]) {
      const position: [number, number, number] = shape.alongX ? [w.x, r, w.z + offset] : [w.x + offset, r, w.z]
      group.add(part(log, side, position, { rotation }))
    }
    group.add(part(log, side, [w.x, r * 2.7, w.z], { rotation }))
    for (const end of [-1, 1]) {
      const [x, z] = shape.at((end * shape.long) / 2.4)
      group.add(part(blob(0.5, 1), top, [x, r * 3.6, z], { scale: [1.2, 0.7, 1.2] }))
    }
  }
}

function walls(arena: Arena, look: WorldLook): THREE.Group {
  const group = new THREE.Group()
  group.name = 'walls'
  for (const w of arena.walls) wall(w, look, group)
  group.traverse((o) => {
    if (o instanceof THREE.Mesh) o.receiveShadow = true
  })
  return group
}

function cactus(x: number, z: number, height: number, material: THREE.Material): THREE.Object3D {
  const g = new THREE.Group()
  g.add(part(capsule(0.28, height), material, [0, height / 2 + 0.28, 0]))
  g.add(part(capsule(0.16, 0.45), material, [0.38, height * 0.55 + 0.35, 0]))
  g.add(part(capsule(0.16, 0.35), material, [-0.36, height * 0.4 + 0.3, 0]))
  g.add(part(capsule(0.12, 0.25), material, [0.25, height * 0.55, 0], { rotation: [0, 0, Math.PI / 2] }))
  g.add(part(capsule(0.12, 0.25), material, [-0.23, height * 0.4, 0], { rotation: [0, 0, Math.PI / 2] }))
  g.position.set(x, 0, z)
  return g
}

/** Leaves (or tubes, or crystals) leaning out from the middle of a plant. */
function fan(geometry: THREE.BufferGeometry, material: THREE.Material, count: number, base: number, lean: number, out: number) {
  const g = new THREE.Group()
  for (let k = 0; k < count; k++) {
    const pivot = new THREE.Group()
    pivot.rotation.y = (k / count) * Math.PI * 2
    pivot.add(part(geometry, material, [out, base, 0], { rotation: [0, 0, -lean] }))
    g.add(pivot)
  }
  return g
}

function plant(kind: CoverKind, height: number, material: THREE.Material, extra: THREE.Material, i: number): THREE.Object3D {
  if (kind === 'fern') {
    const g = fan(cone(0.22, height, 4), material, 5, height * 0.4, 0.6, height * 0.25)
    if (i % 3 === 0) g.add(part(sphere(0.16, 8), extra, [0, height * 0.55, 0], { outline: false }))
    return g
  }
  if (kind === 'post') {
    const g = new THREE.Group()
    g.add(part(new THREE.CylinderGeometry(0.08, 0.08, height + 0.4, 6), material, [0, (height + 0.4) / 2, 0]))
    g.add(part(sphere(0.16, 8), extra, [0, height + 0.45, 0], { outline: false }))
    return g
  }
  if (kind === 'cloud') {
    const g = new THREE.Group()
    g.add(part(blob(0.45 + (i % 3) * 0.12, 1), i % 2 ? material : extra, [0, 0.4 + height * 0.3, 0], { scale: [1.3, 0.8, 1.1] }))
    return g
  }
  if (kind === 'crystal') return fan(cone(0.2, height, 5), i % 2 ? material : extra, 3, height * 0.45, 0.3, 0.12)
  if (kind === 'mushroom') {
    const g = new THREE.Group()
    g.add(part(new THREE.CylinderGeometry(0.1, 0.15, height * 0.8, 8), extra, [0, height * 0.4, 0]))
    g.add(part(new THREE.SphereGeometry(0.45, 10, 6, 0, Math.PI * 2, 0, Math.PI / 2), material, [0, height * 0.75, 0], { scale: [1, 0.8, 1] }))
    return g
  }
  if (kind === 'hedge') {
    const g = new THREE.Group()
    g.add(part(blob(0.5 + (i % 3) * 0.1, 1), i % 2 ? material : extra, [0, 0.5, 0]))
    return g
  }
  if (kind === 'lollipop') {
    const g = new THREE.Group()
    if (i % 2) {
      g.add(part(new THREE.SphereGeometry(0.35, 10, 6, 0, Math.PI * 2, 0, Math.PI / 2), extra, [0, 0, 0], { scale: [1, 1.2, 1] }))
    } else {
      g.add(part(new THREE.CylinderGeometry(0.06, 0.06, height, 6), paint('#ffffff'), [0, height / 2, 0]))
      g.add(part(new THREE.CylinderGeometry(0.4, 0.4, 0.16, 14), material, [0, height + 0.3, 0], { rotation: [Math.PI / 2, 0, 0] }))
    }
    return g
  }
  // A small palm: a short trunk with big drooping leaves.
  const g = fan(cone(0.24, 1.2, 4), material, 6, 0.75, 1.1, 0.45)
  g.add(part(new THREE.CylinderGeometry(0.1, 0.16, 0.8, 6), extra, [0, 0.4, 0]))
  return g
}

function bushes(arena: Arena, look: WorldLook): THREE.Group {
  const group = new THREE.Group()
  group.name = 'bushes'
  const [patchColor, first, second] = look.coverColors
  const glow = look.coverGlow
  const patch = paint(patchColor)
  const plants = [paint(first, glow), paint(second, look.cover === 'cactus' ? undefined : glow)]
  for (const b of arena.bushes) {
    const ground = new THREE.Mesh(new THREE.CircleGeometry(b.r, 24), patch)
    ground.rotation.x = -Math.PI / 2
    ground.position.set(b.x, 0.01, b.z)
    ground.receiveShadow = true
    group.add(ground)
    cover(b, look.cover, plants, group)
  }
  return group
}

function cover(b: Circle, kind: CoverKind, [first, second]: THREE.Material[], group: THREE.Group) {
  if (kind === 'cactus') {
    const count = Math.round(b.r * 3)
    for (let i = 0; i < count; i++) {
      const a = (i / count) * Math.PI * 2 + b.x
      const d = b.r * (i % 2 ? 0.35 : 0.7)
      const c = cactus(b.x + Math.cos(a) * d, b.z + Math.sin(a) * d, 0.9 + (i % 3) * 0.3, i % 2 ? second : first)
      c.rotation.y = a
      group.add(c)
    }
    return
  }
  const count = Math.round(b.r * (kind === 'palm' || kind === 'hedge' ? 2 : 3))
  for (let i = 0; i < count; i++) {
    const a = (i / count) * Math.PI * 2 + b.x
    const d = b.r * (i % 2 ? 0.3 : 0.65)
    const p = plant(kind, 0.9 + (i % 3) * 0.3, i % 2 && kind !== 'post' ? second : first, second, i)
    p.position.set(b.x + Math.cos(a) * d, 0, b.z + Math.sin(a) * d)
    p.rotation.y = a
    group.add(p)
  }
}

function decoration(d: Decoration): THREE.Object3D {
  const g = new THREE.Group()
  if (d.kind === 'crate') {
    g.add(part(box(0.9, 0.9, 0.9), paint('#b07a3c'), [0, 0.45, 0]))
    g.add(part(box(0.95, 0.12, 0.95), paint('#7a4f22'), [0, 0.9, 0], { outline: false }))
    g.add(part(box(0.12, 0.95, 0.95), paint('#7a4f22'), [0, 0.45, 0], { outline: false }))
  } else if (d.kind === 'barrel') {
    g.add(part(cylinder(0.4, 0.4, 0.95), paint('#c0392b'), [0, 0.48, 0]))
    g.add(part(cylinder(0.42, 0.42, 0.08), paint('#555b66'), [0, 0.75, 0], { outline: false }))
    g.add(part(cylinder(0.42, 0.42, 0.08), paint('#555b66'), [0, 0.22, 0], { outline: false }))
  } else if (d.kind === 'skull') {
    const bone = paint('#f4ead2')
    g.add(part(sphere(0.32, 14), bone, [0, 0.3, 0], { scale: [1, 0.9, 1.1] }))
    for (const side of [-1, 1]) {
      g.add(part(sphere(0.08, 8), paint('#2a1d1d'), [side * 0.12, 0.34, 0.27], { outline: false }))
      g.add(part(cone(0.07, 0.5), bone, [side * 0.45, 0.3, 0], { rotation: [0, 0, side * -1.4] }))
    }
  } else {
    g.add(part(new THREE.DodecahedronGeometry(0.55), paint('#a85a30'), [0, 0.35, 0], { scale: [1.3, 0.7, 1] }))
  }
  g.position.set(d.x, 0, d.z)
  g.rotation.y = d.turn
  g.traverse((o) => {
    if (o instanceof THREE.Mesh) o.castShadow = true
  })
  return g
}

/**
 * Joins the meshes of a group by material into one mesh each: the same picture with a few
 * draw calls instead of thousands, so Large worlds stay smooth on tablets (S23).
 */
function merged(group: THREE.Group): THREE.Group {
  group.updateMatrixWorld(true)
  const buckets = new Map<string, { mesh: THREE.Mesh; parts: THREE.BufferGeometry[] }>()
  group.traverse((o) => {
    if (!(o instanceof THREE.Mesh) || o instanceof THREE.InstancedMesh) return
    const material = o.material as THREE.Material
    const key = `${material.uuid}/${o.castShadow}/${o.receiveShadow}`
    let bucket = buckets.get(key)
    if (!bucket) {
      bucket = { mesh: o, parts: [] }
      buckets.set(key, bucket)
    }
    const geometry = (o.geometry as THREE.BufferGeometry).clone().applyMatrix4(o.matrixWorld)
    bucket.parts.push(geometry.index ? geometry.toNonIndexed() : geometry)
  })
  const result = new THREE.Group()
  result.name = group.name
  for (const { mesh, parts } of buckets.values()) {
    const geometry = mergeGeometries(parts)
    if (!geometry) throw new Error(`Cannot merge the ${group.name} of the arena`)
    const joined = new THREE.Mesh(geometry, mesh.material)
    joined.castShadow = mesh.castShadow
    joined.receiveShadow = mesh.receiveShadow
    result.add(joined)
  }
  return result
}

/** The arena of a world, drawn in its theme; Canyon by default. */
export function buildArena(arena: Arena, theme: WorldTheme = 'canyon'): THREE.Group {
  const look = WORLD_LOOKS[theme]
  const decorations = new THREE.Group()
  decorations.name = 'decorations'
  for (const d of arena.decorations) decorations.add(decoration(d))
  const root = new THREE.Group()
  root.add(ground(arena, look), merged(edge(arena, look)), merged(walls(arena, look)), merged(bushes(arena, look)), merged(decorations))
  return root
}

/** Frees the geometry of a built arena (materials are shared between arenas). */
export function disposeArena(root: THREE.Object3D): void {
  root.traverse((o) => {
    if (o instanceof THREE.Mesh) o.geometry.dispose()
  })
}

/** Half the size of the light's shadow area: the whole arena, also a Large one. */
export function shadowReach(arena: Arena): number {
  return Math.max(20, Math.ceil(Math.hypot(arena.width, arena.depth) / 2))
}
