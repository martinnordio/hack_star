import * as THREE from 'three'
import type { Arena, Decoration } from '../game/arena'
import type { ThemeId } from '../game/worlds'
import { box, capsule, cylinder, part, sphere, toon } from './parts'
import { ARENA_THEMES, type ArenaTheme } from './themes'

const TILE = 1.5

function ground(arena: Arena, theme: ArenaTheme): THREE.Object3D {
  const group = new THREE.Group()
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

  // The floor under the tiles and outside the arena, up to the border.
  const floor = new THREE.Mesh(new THREE.PlaneGeometry(arena.width + 40, arena.depth + 40), toon(theme.floor))
  floor.rotation.x = -Math.PI / 2
  floor.position.y = -0.11
  floor.receiveShadow = true
  group.add(floor)
  return group
}

/** The border around the arena: rocks, pillars, crystals, clouds, sweets or dunes. */
function border(arena: Arena, theme: ArenaTheme): THREE.Object3D {
  const group = new THREE.Group()
  const materials = theme.borderColors.map((c) => (theme.glow && theme.border === 'crystals' ? toon(c, c, 0.5) : toon(c)))
  const halfW = arena.width / 2
  const halfD = arena.depth / 2
  let seed = 7
  const random = () => ((seed = (seed * 16807) % 2147483647) / 2147483647)
  const pick = () => materials[Math.floor(random() * materials.length)]
  const place = (x: number, z: number, low = false) => {
    let piece: THREE.Mesh
    if (theme.border === 'pillars') {
      const w = 0.9 + random() * 0.8
      const h = low ? 0.8 + random() * 0.6 : 2 + random() * 2.5
      piece = part(box(w, h, w), pick(), [x, h / 2, z], { rotation: [0, random() * 1.5, 0] })
    } else if (theme.border === 'crystals') {
      const h = low ? 0.8 + random() * 0.8 : 2 + random() * 2.4
      piece = part(new THREE.ConeGeometry(0.5 + random() * 0.5, h, 5), pick(), [x, h / 2, z], { rotation: [0, random() * 3, (random() - 0.5) * 0.3] })
    } else if (theme.border === 'clouds') {
      const r = low ? 0.7 + random() * 0.4 : 1.2 + random() * 0.9
      piece = part(sphere(r, 14), pick(), [x, r * 0.6, z], { scale: [1.5, 0.8, 1.2] })
    } else if (theme.border === 'balls') {
      const r = low ? 0.5 + random() * 0.4 : 0.9 + random() * 0.9
      piece = part(sphere(r, 14), pick(), [x, r, z])
    } else if (theme.border === 'dunes') {
      const r = low ? 0.9 + random() * 0.5 : 1.8 + random() * 1.4
      piece = part(sphere(r, 14), pick(), [x, 0, z], { scale: [2, low ? 0.3 : 0.5, 1.4] })
    } else {
      const size = low ? 0.7 + random() * 0.5 : 1.6 + random() * 1.6
      piece = part(new THREE.DodecahedronGeometry(size, 0), pick(), [x, size * 0.55, z], {
        rotation: [random() * 3, random() * 3, random() * 3],
        scale: [1, low ? 0.6 : 1.2 + random() * 0.8, 1],
      })
    }
    piece.receiveShadow = true
    group.add(piece)
  }
  // The camera looks from the +z side: pieces there stay low so they do not hide the arena.
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

function walls(arena: Arena, theme: ArenaTheme): THREE.Object3D {
  const group = new THREE.Group()
  group.name = 'walls'
  const side = toon(theme.wallSide)
  const top = toon(theme.wallTop, theme.glow, 0.6)
  for (const w of arena.walls) {
    group.add(part(box(w.w, 1.5, w.d), side, [w.x, 0.75, w.z]))
    group.add(part(box(w.w * 0.92, 0.25, w.d * 0.92), top, [w.x, 1.6, w.z]))
    if (theme.wallCap === 'spikes') {
      const along = w.w >= w.d
      const count = Math.max(1, Math.floor(Math.max(w.w, w.d) / 1.3))
      for (let i = 0; i < count; i++) {
        const offset = (i - (count - 1) / 2) * 1.3
        group.add(part(new THREE.ConeGeometry(0.25, 0.8, 5), top, [w.x + (along ? offset : 0), 2.1, w.z + (along ? 0 : offset)]))
      }
    } else if (theme.wallCap === 'dome') {
      group.add(part(sphere(0.5, 12), top, [w.x, 1.85, w.z], { scale: [Math.max(1, w.w * 0.3), 0.7, Math.max(1, w.d * 0.3)] }))
    }
    // A few loose stones at the foot of the wall.
    group.add(part(new THREE.DodecahedronGeometry(0.3), side, [w.x - w.w / 2 + 0.2, 0.2, w.z + w.d / 2 + 0.15]))
    group.add(part(new THREE.DodecahedronGeometry(0.22), top, [w.x + w.w / 2 - 0.1, 0.15, w.z - w.d / 2 - 0.1]))
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

function fern(height: number, material: THREE.Material): THREE.Object3D {
  const g = new THREE.Group()
  for (let k = 0; k < 5; k++) {
    const a = (k / 5) * Math.PI * 2
    g.add(part(new THREE.ConeGeometry(0.14, height * 1.1, 6), material, [Math.cos(a) * 0.18, height * 0.5, Math.sin(a) * 0.18], {
      rotation: [Math.sin(a) * 0.5, 0, -Math.cos(a) * 0.5],
    }))
  }
  return g
}

function post(height: number, material: THREE.Material): THREE.Object3D {
  const g = new THREE.Group()
  g.add(part(cylinder(0.09, 0.12, height * 1.5), material, [0, height * 0.75, 0]))
  g.add(part(sphere(0.2, 10), material, [0, height * 1.55, 0]))
  return g
}

function crystal(height: number, material: THREE.Material): THREE.Object3D {
  const g = new THREE.Group()
  g.add(part(new THREE.ConeGeometry(0.26, height * 1.3, 5), material, [0, height * 0.65, 0]))
  g.add(part(new THREE.ConeGeometry(0.16, height * 0.8, 5), material, [0.3, height * 0.4, 0.1], { rotation: [0, 0, -0.3] }))
  return g
}

function palm(height: number, material: THREE.Material): THREE.Object3D {
  const g = new THREE.Group()
  g.add(part(cylinder(0.1, 0.16, height * 1.5), toon('#8a5a2c'), [0, height * 0.75, 0]))
  for (let k = 0; k < 4; k++) {
    const a = (k / 4) * Math.PI * 2
    g.add(part(new THREE.ConeGeometry(0.16, 0.9, 5), material, [Math.cos(a) * 0.4, height * 1.5, Math.sin(a) * 0.4], {
      rotation: [Math.sin(a) * 1.2, 0, -Math.cos(a) * 1.2],
    }))
  }
  g.add(part(sphere(0.2, 8), material, [0, height * 1.55, 0]))
  return g
}

function candy(height: number, material: THREE.Material): THREE.Object3D {
  const g = new THREE.Group()
  g.add(part(cylinder(0.05, 0.05, height), toon('#ffffff'), [0, height / 2, 0]))
  g.add(part(sphere(0.34, 12), material, [0, height + 0.2, 0]))
  return g
}

function tuft(height: number, material: THREE.Material): THREE.Object3D {
  const g = new THREE.Group()
  for (let k = 0; k < 3; k++) {
    g.add(part(new THREE.ConeGeometry(0.16, height * 0.9, 5), material, [(k - 1) * 0.2, height * 0.45, (k % 2) * 0.12], { rotation: [0, 0, (k - 1) * 0.25] }))
  }
  return g
}

const PLANTS: Record<ArenaTheme['plant'], (height: number, material: THREE.Material) => THREE.Object3D> = {
  cactus,
  fern,
  post,
  crystal,
  palm,
  ball: candy,
  tuft,
}

/** Plant patches: the "bushes" where fighters hide (cacti, ferns, neon posts, palms, ...). */
function bushes(arena: Arena, theme: ArenaTheme): THREE.Object3D {
  const group = new THREE.Group()
  group.name = 'bushes'
  const glows = theme.plant === 'post' || (theme.plant === 'crystal' && theme.glow)
  const greens = theme.plantColors.map((c) => (glows ? toon(c, c, 0.7) : toon(c)))
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
      const c = PLANTS[theme.plant](0.9 + (i % 3) * 0.3, greens[i % greens.length])
      c.position.set(b.x + Math.cos(a) * d, 0, b.z + Math.sin(a) * d)
      c.rotation.y = a
      group.add(c)
    }
  }
  return group
}

function decoration(d: Decoration, theme: ArenaTheme): THREE.Object3D {
  const g = new THREE.Group()
  if (d.kind === 'crate') {
    g.add(part(box(0.9, 0.9, 0.9), toon(theme.crate), [0, 0.45, 0]))
    g.add(part(box(0.95, 0.12, 0.95), toon('#7a4f22'), [0, 0.9, 0], { outline: false }))
    g.add(part(box(0.12, 0.95, 0.95), toon('#7a4f22'), [0, 0.45, 0], { outline: false }))
  } else if (d.kind === 'barrel') {
    g.add(part(cylinder(0.4, 0.4, 0.95), toon(theme.barrel), [0, 0.48, 0]))
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
    g.add(part(new THREE.DodecahedronGeometry(0.55), toon(theme.rock), [0, 0.35, 0], { scale: [1.3, 0.7, 1] }))
  }
  g.position.set(d.x, 0, d.z)
  g.rotation.y = d.turn
  g.traverse((o) => {
    if (o instanceof THREE.Mesh) o.castShadow = true
  })
  return g
}

const cone = (r: number, h: number) => new THREE.ConeGeometry(r, h, 10)

/** The ground, border, walls, plants and props of an arena in the look of a theme. */
export function buildArena(arena: Arena, themeId: ThemeId = 'canyon'): THREE.Group {
  const theme = ARENA_THEMES[themeId]
  const root = new THREE.Group()
  root.add(ground(arena, theme), border(arena, theme), walls(arena, theme), bushes(arena, theme))
  for (const d of arena.decorations) root.add(decoration(d, theme))
  return root
}
