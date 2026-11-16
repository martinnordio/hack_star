import * as THREE from 'three'
import type { Arena, Decoration } from '../game/arena'
import type { ThemeId } from '../game/worlds'
import { box, capsule, cylinder, part, sphere, toon } from './parts'

const TILE = 1.5

type EdgeShape = 'rock' | 'block' | 'crystal' | 'cloud' | 'dune'
type WallShape = 'stone' | 'pillar' | 'crate' | 'house' | 'machine'
type CoverShape = 'cactus' | 'fern' | 'post' | 'crystal' | 'puff' | 'candy' | 'palm'

/** The look of a world: colours and the shapes of its edge, walls and bushes. */
export interface Theme {
  /** Light and dark ground tiles. */
  tiles: [string, string]
  /** The ground under the tiles and outside the arena. */
  floor: string
  edge: EdgeShape
  edgeColors: [string, string, string]
  wall: WallShape
  wallSide: string
  wallTop: string
  cover: CoverShape
  coverColors: [string, string]
  /** The patch of ground under each bush. */
  patch: string
}

export const THEMES: Record<ThemeId, Theme> = {
  canyon: {
    tiles: ['#f5cf8e', '#ebbd76'], floor: '#d9a35f',
    edge: 'rock', edgeColors: ['#c96a35', '#b35a2c', '#d9824a'],
    wall: 'stone', wallSide: '#b5653a', wallTop: '#e09a5c',
    cover: 'cactus', coverColors: ['#4cbf4f', '#3aa34a'], patch: '#7fbf4a',
  },
  ruins: {
    tiles: ['#9cc778', '#8bb968'], floor: '#4d8a3c',
    edge: 'rock', edgeColors: ['#6f7d6a', '#5d6b58', '#82917c'],
    wall: 'pillar', wallSide: '#8c8f80', wallTop: '#a9ad99',
    cover: 'fern', coverColors: ['#2e9e44', '#3cb853'], patch: '#3f7d33',
  },
  neon: {
    tiles: ['#3a3f5c', '#30344d'], floor: '#1f2236',
    edge: 'block', edgeColors: ['#2b2f45', '#ff3fa4', '#39c6ff'],
    wall: 'crate', wallSide: '#2f6f8f', wallTop: '#39ffd8',
    cover: 'post', coverColors: ['#ff3fa4', '#39c6ff'], patch: '#26294a',
  },
  lava: {
    tiles: ['#5a4640', '#4a3a36'], floor: '#ff5a1a',
    edge: 'rock', edgeColors: ['#3a2a26', '#4a3530', '#2e2220'],
    wall: 'stone', wallSide: '#5a3d33', wallTop: '#ff7a1a',
    cover: 'crystal', coverColors: ['#ff7a1a', '#ffb000'], patch: '#3a2a26',
  },
  sky: {
    tiles: ['#d6ecff', '#c3e0fa'], floor: '#8fd0ff',
    edge: 'cloud', edgeColors: ['#ffffff', '#eef6ff', '#dfefff'],
    wall: 'pillar', wallSide: '#f2f2f2', wallTop: '#ffd23f',
    cover: 'puff', coverColors: ['#ffffff', '#e6f2ff'], patch: '#bfe0ff',
  },
  crystal: {
    tiles: ['#5b4a8a', '#4f3f7a'], floor: '#3a2d5e',
    edge: 'crystal', edgeColors: ['#8f6bff', '#b48cff', '#6fd3ff'],
    wall: 'stone', wallSide: '#4a3d6e', wallTop: '#8f6bff',
    cover: 'crystal', coverColors: ['#6fd3ff', '#c58bff'], patch: '#4a3d6e',
  },
  city: {
    tiles: ['#c9ccd3', '#b9bcc4'], floor: '#6b6f78',
    edge: 'block', edgeColors: ['#8e96a3', '#c0392b', '#3a7bd5'],
    wall: 'house', wallSide: '#e8d2a8', wallTop: '#c0392b',
    cover: 'puff', coverColors: ['#4cbf4f', '#3aa34a'], patch: '#6aa84f',
  },
  kata: {
    tiles: ['#7fbf5a', '#6fae4f'], floor: '#3c7a2f',
    edge: 'cloud', edgeColors: ['#2e7d32', '#388e3c', '#1b5e20'],
    wall: 'pillar', wallSide: '#7a4f22', wallTop: '#a0703a',
    cover: 'palm', coverColors: ['#2e9e44', '#8a5a2b'], patch: '#4f8f3a',
  },
  candy: {
    tiles: ['#ffd1e8', '#ffc0de'], floor: '#ff9ec8',
    edge: 'cloud', edgeColors: ['#fff0f6', '#ffd23f', '#8fe3ff'],
    wall: 'crate', wallSide: '#ff6fa8', wallTop: '#ffffff',
    cover: 'candy', coverColors: ['#ff4f9a', '#39d3ff'], patch: '#ffb0d4',
  },
  robot: {
    tiles: ['#9aa3ad', '#8b949e'], floor: '#5c636b',
    edge: 'block', edgeColors: ['#6b737c', '#ffb000', '#4a5058'],
    wall: 'machine', wallSide: '#6b737c', wallTop: '#ffb000',
    cover: 'post', coverColors: ['#ffb000', '#39c6ff'], patch: '#707880',
  },
  pirate: {
    tiles: ['#e8d5a8', '#dcc795'], floor: '#2f9fd9',
    edge: 'rock', edgeColors: ['#8a7a62', '#9c8b70', '#6f6250'],
    wall: 'crate', wallSide: '#8a5a2b', wallTop: '#5a3a1b',
    cover: 'palm', coverColors: ['#3aa34a', '#8a5a2b'], patch: '#e0c890',
  },
  moon: {
    tiles: ['#b8bcc6', '#a9adb8'], floor: '#2a2d3a',
    edge: 'rock', edgeColors: ['#8e929c', '#a3a7b0', '#7a7e88'],
    wall: 'machine', wallSide: '#d8dce4', wallTop: '#4aa8ff',
    cover: 'crystal', coverColors: ['#9fe4ff', '#ffffff'], patch: '#9ea2ac',
  },
  oasis: {
    tiles: ['#f7dca0', '#eccf8e'], floor: '#e8c27a',
    edge: 'dune', edgeColors: ['#e8c27a', '#dcb46a', '#f2cf8a'],
    wall: 'stone', wallSide: '#c9955a', wallTop: '#e8b878',
    cover: 'palm', coverColors: ['#3aa34a', '#a0703a'], patch: '#3fb6d9',
  },
}

function ground(arena: Arena, theme: Theme): THREE.Object3D {
  const group = new THREE.Group()
  group.name = 'ground'
  const cols = Math.ceil(arena.width / TILE)
  const rows = Math.ceil(arena.depth / TILE)
  const tiles = new THREE.InstancedMesh(new THREE.BoxGeometry(TILE * 0.96, 0.1, TILE * 0.96), toon('#ffffff'), cols * rows)
  const matrix = new THREE.Matrix4()
  const light = new THREE.Color(theme.tiles[0])
  const dark = new THREE.Color(theme.tiles[1])
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

  // Floor under the tiles and outside the arena, up to the edge.
  const sand = new THREE.Mesh(new THREE.PlaneGeometry(arena.width + 40, arena.depth + 40), toon(theme.floor))
  sand.rotation.x = -Math.PI / 2
  sand.position.y = -0.11
  sand.receiveShadow = true
  group.add(sand)
  return group
}

function edgePiece(shape: EdgeShape, size: number, material: THREE.Material, random: () => number, low: boolean): THREE.Mesh {
  if (shape === 'block') return part(box(size * 1.3, size * (low ? 0.6 : 1.4), size * 1.3), material, [0, size * (low ? 0.3 : 0.7), 0])
  if (shape === 'crystal') {
    return part(new THREE.OctahedronGeometry(size * 0.8, 0), material, [0, size * (low ? 0.4 : 1), 0], {
      scale: [0.6, low ? 0.6 : 1.6, 0.6],
      rotation: [0, random() * 3, random() * 0.4],
    })
  }
  if (shape === 'cloud') return part(sphere(size * 0.9, 10), material, [0, size * 0.4, 0], { scale: [1.2, low ? 0.5 : 0.8, 1] })
  if (shape === 'dune') return part(sphere(size * 1.1, 10), material, [0, 0, 0], { scale: [1.6, low ? 0.35 : 0.6, 1.2] })
  return part(new THREE.DodecahedronGeometry(size, 0), material, [0, size * 0.55, 0], {
    rotation: [random() * 3, random() * 3, random() * 3],
    scale: [1, low ? 0.6 : 1.2 + random() * 0.8, 1],
  })
}

/** Big pieces around the edge of the arena: cliffs, blocks, crystals, clouds or dunes. */
function cliffs(arena: Arena, theme: Theme): THREE.Object3D {
  const group = new THREE.Group()
  const colors = theme.edgeColors.map((c) => toon(c))
  const halfW = arena.width / 2
  const halfD = arena.depth / 2
  let seed = 7
  const random = () => ((seed = (seed * 16807) % 2147483647) / 2147483647)
  const place = (x: number, z: number, low = false) => {
    const size = low ? 0.7 + random() * 0.5 : 1.6 + random() * 1.6
    const piece = edgePiece(theme.edge, size, colors[Math.floor(random() * 3)], random, low)
    piece.position.x += x
    piece.position.z += z
    piece.receiveShadow = true
    group.add(piece)
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
  return group
}

function walls(arena: Arena, theme: Theme): THREE.Object3D {
  const group = new THREE.Group()
  group.name = 'walls'
  const side = toon(theme.wallSide)
  const top = toon(theme.wallTop)
  for (const w of arena.walls) {
    group.add(part(box(w.w, 1.5, w.d), side, [w.x, 0.75, w.z]))
    if (theme.wall === 'stone') {
      group.add(part(box(w.w * 0.92, 0.25, w.d * 0.92), top, [w.x, 1.6, w.z]))
      // A few loose stones at the foot of the wall.
      group.add(part(new THREE.DodecahedronGeometry(0.3), side, [w.x - w.w / 2 + 0.2, 0.2, w.z + w.d / 2 + 0.15]))
      group.add(part(new THREE.DodecahedronGeometry(0.22), top, [w.x + w.w / 2 - 0.1, 0.15, w.z - w.d / 2 - 0.1]))
    } else if (theme.wall === 'pillar') {
      // Columns standing at both ends of the wall.
      const long = w.w > w.d
      for (const s of [-1, 1]) {
        const x = long ? w.x + s * (w.w / 2 - 0.4) : w.x
        const z = long ? w.z : w.z + s * (w.d / 2 - 0.4)
        group.add(part(cylinder(0.45, 0.5, 2.3), top, [x, 1.15, z]))
      }
    } else if (theme.wall === 'crate') {
      group.add(part(box(w.w + 0.05, 0.18, w.d + 0.05), top, [w.x, 1.1, w.z], { outline: false }))
      group.add(part(box(w.w + 0.05, 0.18, w.d + 0.05), top, [w.x, 0.4, w.z], { outline: false }))
    } else if (theme.wall === 'house') {
      const span = Math.hypot(w.w, w.d)
      group.add(part(new THREE.ConeGeometry(span / 2, 1.1, 4), top, [w.x, 2.05, w.z], {
        rotation: [0, Math.PI / 4, 0],
        scale: [(w.w / span) * 1.4, 1, (w.d / span) * 1.4],
      }))
    } else {
      group.add(part(cylinder(0.35, 0.35, 0.9), top, [w.x, 1.95, w.z]))
      group.add(part(box(w.w * 0.6, 0.12, w.d * 0.6), toon(theme.wallTop, theme.wallTop, 0.6), [w.x, 1.56, w.z], { outline: false }))
    }
  }
  group.traverse((o) => {
    if (o instanceof THREE.Mesh) o.receiveShadow = true
  })
  return group
}

function cactus(height: number, material: THREE.Material): THREE.Object3D {
  const g = new THREE.Group()
  g.add(part(capsule(0.28, height), material, [0, height / 2 + 0.28, 0]))
  g.add(part(capsule(0.16, 0.45), material, [0.38, height * 0.55 + 0.35, 0]))
  g.add(part(capsule(0.16, 0.35), material, [-0.36, height * 0.4 + 0.3, 0]))
  g.add(part(capsule(0.12, 0.25), material, [0.25, height * 0.55, 0], { rotation: [0, 0, Math.PI / 2] }))
  g.add(part(capsule(0.12, 0.25), material, [-0.23, height * 0.4, 0], { rotation: [0, 0, Math.PI / 2] }))
  return g
}

/** One plant (or other cover piece) of a bush, standing at the origin. */
function coverPiece(shape: CoverShape, height: number, main: THREE.Material, second: THREE.Material): THREE.Object3D {
  if (shape === 'cactus') return cactus(height, main)
  const g = new THREE.Group()
  if (shape === 'fern') {
    for (let i = 0; i < 3; i++) {
      g.add(part(new THREE.ConeGeometry(0.22, height + 0.4, 6), main, [0, (height + 0.4) / 2, 0], { rotation: [0.5, (i * Math.PI * 2) / 3, 0] }))
    }
  } else if (shape === 'post') {
    g.add(part(cylinder(0.1, 0.12, height + 0.3), second, [0, (height + 0.3) / 2, 0]))
    g.add(part(sphere(0.25, 10), main, [0, height + 0.4, 0], { outline: false }))
  } else if (shape === 'crystal') {
    g.add(part(new THREE.OctahedronGeometry(0.35, 0), main, [0, height * 0.6, 0], { scale: [0.7, height * 1.6, 0.7] }))
  } else if (shape === 'puff') {
    g.add(part(sphere(0.55, 10), main, [0, 0.55, 0]))
    g.add(part(sphere(0.4, 10), second, [0.3, 0.95, 0.1]))
  } else if (shape === 'candy') {
    g.add(part(cylinder(0.05, 0.05, height), second, [0, height / 2, 0], { outline: false }))
    g.add(part(cylinder(0.35, 0.35, 0.12), main, [0, height + 0.2, 0], { rotation: [Math.PI / 2, 0, 0] }))
  } else {
    g.add(part(cylinder(0.1, 0.15, height + 0.6), second, [0, (height + 0.6) / 2, 0]))
    for (let i = 0; i < 4; i++) {
      g.add(part(box(0.9, 0.05, 0.3), main, [0, height + 0.6, 0], { rotation: [0, (i * Math.PI) / 2, -0.35], outline: false }))
    }
  }
  return g
}

/** Patches of plants (or crystals, posts, candy…): the "bushes" of a world. */
function bushes(arena: Arena, theme: Theme): THREE.Object3D {
  const group = new THREE.Group()
  group.name = 'bushes'
  const greens = theme.coverColors.map((c) => toon(c))
  const patch = toon(theme.patch)
  for (const b of arena.bushes) {
    const ground = new THREE.Mesh(new THREE.CircleGeometry(b.r, 24), patch)
    ground.rotation.x = -Math.PI / 2
    ground.position.set(b.x, 0.01, b.z)
    ground.receiveShadow = true
    group.add(ground)
    const count = Math.round(b.r * 3)
    for (let i = 0; i < count; i++) {
      const a = (i / count) * Math.PI * 2 + b.x
      const d = b.r * (i % 2 ? 0.35 : 0.7)
      const c = coverPiece(theme.cover, 0.9 + (i % 3) * 0.3, greens[i % 2], greens[(i + 1) % 2])
      c.position.set(b.x + Math.cos(a) * d, 0, b.z + Math.sin(a) * d)
      c.rotation.y = a
      group.add(c)
    }
  }
  return group
}

function decoration(d: Decoration): THREE.Object3D {
  const g = new THREE.Group()
  if (d.kind === 'crate') {
    g.add(part(box(0.9, 0.9, 0.9), toon('#b07a3c'), [0, 0.45, 0]))
    g.add(part(box(0.95, 0.12, 0.95), toon('#7a4f22'), [0, 0.9, 0], { outline: false }))
    g.add(part(box(0.12, 0.95, 0.95), toon('#7a4f22'), [0, 0.45, 0], { outline: false }))
  } else if (d.kind === 'barrel') {
    g.add(part(cylinder(0.4, 0.4, 0.95), toon('#c0392b'), [0, 0.48, 0]))
    g.add(part(cylinder(0.42, 0.42, 0.08), toon('#555b66'), [0, 0.75, 0], { outline: false }))
    g.add(part(cylinder(0.42, 0.42, 0.08), toon('#555b66'), [0, 0.22, 0], { outline: false }))
  } else if (d.kind === 'skull') {
    const bone = toon('#f4ead2')
    g.add(part(sphere(0.32, 14), bone, [0, 0.3, 0], { scale: [1, 0.9, 1.1] }))
    for (const side of [-1, 1]) {
      g.add(part(sphere(0.08, 8), toon('#2a1d1d'), [side * 0.12, 0.34, 0.27], { outline: false }))
      g.add(part(cone(0.07, 0.5), bone, [side * 0.45, 0.3, 0], { rotation: [0, 0, side * -1.4] }))
    }
  } else {
    g.add(part(new THREE.DodecahedronGeometry(0.55), toon('#a85a30'), [0, 0.35, 0], { scale: [1.3, 0.7, 1] }))
  }
  g.position.set(d.x, 0, d.z)
  g.rotation.y = d.turn
  g.traverse((o) => {
    if (o instanceof THREE.Mesh) o.castShadow = true
  })
  return g
}

const cone = (r: number, h: number) => new THREE.ConeGeometry(r, h, 10)

export function buildArena(arena: Arena, theme: ThemeId = 'canyon'): THREE.Group {
  const look = THEMES[theme]
  const root = new THREE.Group()
  root.add(ground(arena, look), cliffs(arena, look), walls(arena, look), bushes(arena, look))
  for (const d of arena.decorations) root.add(decoration(d))
  return root
}
