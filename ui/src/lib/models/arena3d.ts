import * as THREE from 'three'
import type { Arena, Decoration, Rect } from '../game/arena'
import type { ThemeId } from '../game/worlds'
import { box, capsule, cylinder, part, sphere, toon } from './parts'
import { THEMES, type BorderKind, type CapKind, type PlantKind, type Theme } from './themes'

const TILE = 1.5

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

  // Floor under the tiles and outside the arena, up to the border.
  const sand = new THREE.Mesh(new THREE.PlaneGeometry(arena.width + 40, arena.depth + 40), toon(theme.floor))
  sand.rotation.x = -Math.PI / 2
  sand.position.y = -0.11
  sand.receiveShadow = true
  group.add(sand)
  return group
}

/** How each kind of edge piece is drawn: shape, height above the ground and squash. */
const BORDER: Record<BorderKind, { shape: (size: number) => THREE.BufferGeometry; lift: number; squash: number }> = {
  rocks: { shape: (size) => new THREE.DodecahedronGeometry(size, 0), lift: 0, squash: 1 },
  pillars: { shape: (size) => new THREE.CylinderGeometry(size * 0.45, size * 0.55, size * 1.2, 12), lift: 0, squash: 1 },
  balls: { shape: (size) => new THREE.SphereGeometry(size * 0.8, 14, 10), lift: 0, squash: 1 },
  crystals: { shape: (size) => new THREE.OctahedronGeometry(size * 0.8, 0), lift: 0, squash: 1 },
  clouds: { shape: (size) => new THREE.SphereGeometry(size * 0.9, 14, 10), lift: 1.5, squash: 0.6 },
  dunes: { shape: (size) => new THREE.SphereGeometry(size * 1.2, 14, 8), lift: 0, squash: 0.4 },
}

/** Calls `place` for every spot around the arena edge; the spots come in the same order for every kind. */
function edgeSpots(arena: Arena, random: () => number, place: (x: number, z: number, low?: boolean) => void): void {
  const halfW = arena.width / 2
  const halfD = arena.depth / 2
  for (let x = -halfW - 2; x <= halfW + 2; x += 2.6) {
    place(x, -halfD - 2 - random())
  }
  // The camera looks from the +z side: pieces there stay low so they do not hide the arena.
  for (let x = -halfW - 1; x <= halfW + 1; x += 1.4) {
    place(x, halfD + 1 + random() * 0.5, true)
  }
  for (let z = -halfD; z <= halfD; z += 2.6) {
    place(-halfW - 2 - random(), z)
    place(halfW + 2 + random(), z)
  }
}

/** The edge of the arena: big pieces around it (rocks in the canyon). */
function border(arena: Arena, theme: Theme): THREE.Object3D {
  const group = new THREE.Group()
  const materials = theme.border.colors.map((color) => toon(color))
  const { shape, lift, squash } = BORDER[theme.border.kind]
  let seed = 7
  const random = () => ((seed = (seed * 16807) % 2147483647) / 2147483647)
  edgeSpots(arena, random, (x, z, low = false) => {
    const size = low ? 0.7 + random() * 0.5 : 1.6 + random() * 1.6
    const material = materials[Math.floor(random() * materials.length)]
    const rotation: [number, number, number] = [random() * 3, random() * 3, random() * 3]
    const stretch = low ? 0.6 : 1.2 + random() * 0.8
    const piece = part(shape(size), material, [x, size * 0.55 + lift, z], { rotation, scale: [1, stretch * squash, 1] })
    piece.receiveShadow = true
    group.add(piece)
  })
  return group
}

/** Decorations on top of a wall; the top of the wall is at height 1.725. */
function addCap(group: THREE.Group, w: Rect, cap: CapKind, material: THREE.Material): void {
  const top = 1.725
  if (cap === 'spikes') {
    const along = w.w >= w.d
    const length = along ? w.w : w.d
    const count = Math.max(2, Math.round(length / 0.9))
    for (let i = 0; i < count; i++) {
      const offset = -length / 2 + (length * (i + 0.5)) / count
      group.add(part(cone(0.18, 0.55), material, [along ? w.x + offset : w.x, top + 0.275, along ? w.z : w.z + offset]))
    }
  } else if (cap === 'dome') {
    const m = Math.min(w.w, w.d)
    group.add(part(sphere(m * 0.46, 12), material, [w.x, top, w.z], { scale: [(w.w * 0.92) / m, 0.6, (w.d * 0.92) / m] }))
  }
}

function walls(arena: Arena, theme: Theme): THREE.Object3D {
  const group = new THREE.Group()
  group.name = 'walls'
  const side = toon(theme.wall.side)
  const top = toon(theme.wall.top)
  for (const w of arena.walls) {
    group.add(part(box(w.w, 1.5, w.d), side, [w.x, 0.75, w.z]))
    group.add(part(box(w.w * 0.92, 0.25, w.d * 0.92), top, [w.x, 1.6, w.z]))
    addCap(group, w, theme.wall.cap, top)
    // A few loose stones at the foot of the wall.
    group.add(part(new THREE.DodecahedronGeometry(0.3), side, [w.x - w.w / 2 + 0.2, 0.2, w.z + w.d / 2 + 0.15]))
    group.add(part(new THREE.DodecahedronGeometry(0.22), top, [w.x + w.w / 2 - 0.1, 0.15, w.z - w.d / 2 - 0.1]))
  }
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

function fern(x: number, z: number, height: number, main: THREE.Material, accent: THREE.Material): THREE.Object3D {
  const g = new THREE.Group()
  for (let k = 0; k < 6; k++) {
    const a = (k / 6) * Math.PI * 2
    g.add(part(cone(0.22, height), k % 2 ? accent : main, [Math.cos(a) * 0.2, height * 0.5, Math.sin(a) * 0.2], { rotation: [Math.sin(a) * 0.55, 0, -Math.cos(a) * 0.55] }))
  }
  g.position.set(x, 0, z)
  return g
}

function neonPost(x: number, z: number, height: number, post: THREE.Material, light: THREE.Material): THREE.Object3D {
  const g = new THREE.Group()
  g.add(part(cylinder(0.08, 0.1, height), post, [0, height / 2, 0]))
  g.add(part(sphere(0.22, 10), light, [0, height + 0.12, 0]))
  g.position.set(x, 0, z)
  return g
}

function crystal(x: number, z: number, height: number, main: THREE.Material, accent: THREE.Material): THREE.Object3D {
  const g = new THREE.Group()
  g.add(part(new THREE.OctahedronGeometry(0.42), main, [0, 0.42 * height, 0], { scale: [0.8, height, 0.8] }))
  g.add(part(new THREE.OctahedronGeometry(0.25), accent, [0.35, 0.35, 0.1], { rotation: [0, 0, 0.35], scale: [0.8, 1.4, 0.8] }))
  g.add(part(new THREE.OctahedronGeometry(0.22), accent, [-0.3, 0.3, -0.2], { rotation: [0, 0, -0.3], scale: [0.8, 1.3, 0.8] }))
  g.position.set(x, 0, z)
  return g
}

function palm(x: number, z: number, height: number, leaves: THREE.Material, trunk: THREE.Material): THREE.Object3D {
  const g = new THREE.Group()
  g.add(part(cylinder(0.12, 0.18, height), trunk, [0, height / 2, 0]))
  for (let k = 0; k < 5; k++) {
    const a = (k / 5) * Math.PI * 2
    g.add(part(cone(0.2, 1.3), leaves, [Math.cos(a) * 0.5, height, Math.sin(a) * 0.5], { rotation: [Math.sin(a) * 1.2, 0, -Math.cos(a) * 1.2] }))
  }
  g.position.set(x, 0, z)
  return g
}

function lollipop(x: number, z: number, height: number, candy: THREE.Material, stick: THREE.Material): THREE.Object3D {
  const g = new THREE.Group()
  g.add(part(cylinder(0.07, 0.07, height), stick, [0, height / 2, 0]))
  g.add(part(sphere(0.42, 12), candy, [0, height + 0.35, 0]))
  g.position.set(x, 0, z)
  return g
}

/** Blade offsets and heights (relative to the plant height) of a grass tuft. */
const TUFTS: [number, number, number][] = [
  [0, 0, 1],
  [0.25, 0.1, 0.8],
  [-0.2, 0.2, 0.9],
  [0.1, -0.25, 0.7],
  [-0.22, -0.12, 1.1],
]

function grass(x: number, z: number, height: number, main: THREE.Material, accent: THREE.Material): THREE.Object3D {
  const g = new THREE.Group()
  TUFTS.forEach(([dx, dz, scale], k) => {
    const blade = height * scale
    g.add(part(cone(0.12, blade), k % 2 ? accent : main, [dx, blade / 2, dz]))
  })
  g.position.set(x, 0, z)
  return g
}

/** Builds one plant; `variant` is the index of the plant, so colours can alternate. */
type PlantBuilder = (x: number, z: number, height: number, variant: number, mats: THREE.Material[]) => THREE.Object3D

const PLANTS: Record<PlantKind, PlantBuilder> = {
  cactus: (x, z, height, variant, mats) => cactus(x, z, height, mats[variant % 2]),
  fern: (x, z, height, variant, mats) => fern(x, z, height, mats[variant % 2], mats[(variant + 1) % 2]),
  neonPost: (x, z, height, _variant, mats) => neonPost(x, z, height, mats[1], mats[0]),
  crystal: (x, z, height, _variant, mats) => crystal(x, z, height, mats[0], mats[1]),
  palm: (x, z, height, _variant, mats) => palm(x, z, height, mats[0], mats[1]),
  lollipop: (x, z, height, _variant, mats) => lollipop(x, z, height, mats[0], mats[1]),
  grass: (x, z, height, variant, mats) => grass(x, z, height, mats[variant % 2], mats[(variant + 1) % 2]),
}

/** Cover: the plants of the world, in patches. */
function plants(arena: Arena, theme: Theme): THREE.Object3D {
  const group = new THREE.Group()
  group.name = 'bushes'
  const mats = theme.plant.colors.map((color) => toon(color, theme.glow))
  const grow = PLANTS[theme.plant.kind]
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
      const c = grow(b.x + Math.cos(a) * d, b.z + Math.sin(a) * d, 0.9 + (i % 3) * 0.3, i, mats)
      c.rotation.y = a
      group.add(c)
    }
  }
  return group
}

function decoration(d: Decoration, theme: Theme): THREE.Object3D {
  const g = new THREE.Group()
  if (d.kind === 'crate') {
    g.add(part(box(0.9, 0.9, 0.9), toon(theme.props.crate), [0, 0.45, 0]))
    g.add(part(box(0.95, 0.12, 0.95), toon('#7a4f22'), [0, 0.9, 0], { outline: false }))
    g.add(part(box(0.12, 0.95, 0.95), toon('#7a4f22'), [0, 0.45, 0], { outline: false }))
  } else if (d.kind === 'barrel') {
    g.add(part(cylinder(0.4, 0.4, 0.95), toon(theme.props.barrel), [0, 0.48, 0]))
    g.add(part(cylinder(0.42, 0.42, 0.08), toon('#555b66'), [0, 0.75, 0], { outline: false }))
    g.add(part(cylinder(0.42, 0.42, 0.08), toon('#555b66'), [0, 0.22, 0], { outline: false }))
  } else if (d.kind === 'skull' && theme.skulls) {
    const bone = toon('#f4ead2')
    g.add(part(sphere(0.32, 14), bone, [0, 0.3, 0], { scale: [1, 0.9, 1.1] }))
    for (const side of [-1, 1]) {
      g.add(part(sphere(0.08, 8), toon('#2a1d1d'), [side * 0.12, 0.34, 0.27], { outline: false }))
      g.add(part(cone(0.07, 0.5), bone, [side * 0.45, 0.3, 0], { rotation: [0, 0, side * -1.4] }))
    }
  } else {
    g.add(part(new THREE.DodecahedronGeometry(0.55), toon(theme.props.rock), [0, 0.35, 0], { scale: [1.3, 0.7, 1] }))
  }
  g.position.set(d.x, 0, d.z)
  g.rotation.y = d.turn
  g.traverse((o) => {
    if (o instanceof THREE.Mesh) o.castShadow = true
  })
  return g
}

const cone = (r: number, h: number) => new THREE.ConeGeometry(r, h, 10)

/** Builds the scenery of an arena in the look of a world (canyon by default). */
export function buildArena(arena: Arena, themeId: ThemeId = 'canyon'): THREE.Group {
  const theme = THEMES[themeId]
  const root = new THREE.Group()
  root.add(ground(arena, theme), border(arena, theme), walls(arena, theme), plants(arena, theme))
  for (const d of arena.decorations) root.add(decoration(d, theme))
  return root
}
