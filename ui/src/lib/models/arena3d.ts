import * as THREE from 'three'
import type { Arena, Decoration } from '../game/arena'
import { box, capsule, cylinder, part, sphere, toon } from './parts'

const TILE = 1.5

function ground(arena: Arena): THREE.Object3D {
  const group = new THREE.Group()
  const cols = Math.ceil(arena.width / TILE)
  const rows = Math.ceil(arena.depth / TILE)
  const tiles = new THREE.InstancedMesh(new THREE.BoxGeometry(TILE * 0.96, 0.1, TILE * 0.96), toon('#ffffff'), cols * rows)
  const matrix = new THREE.Matrix4()
  const light = new THREE.Color('#f5cf8e')
  const dark = new THREE.Color('#ebbd76')
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

  // Sand under the tiles and outside the arena, up to the cliffs.
  const sand = new THREE.Mesh(new THREE.PlaneGeometry(arena.width + 40, arena.depth + 40), toon('#d9a35f'))
  sand.rotation.x = -Math.PI / 2
  sand.position.y = -0.11
  sand.receiveShadow = true
  group.add(sand)
  return group
}

/** Canyon cliffs: big orange rocks around the edge of the arena. */
function cliffs(arena: Arena): THREE.Object3D {
  const group = new THREE.Group()
  const colors = [toon('#c96a35'), toon('#b35a2c'), toon('#d9824a')]
  const halfW = arena.width / 2
  const halfD = arena.depth / 2
  let seed = 7
  const random = () => ((seed = (seed * 16807) % 2147483647) / 2147483647)
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
  return group
}

function walls(arena: Arena): THREE.Object3D {
  const group = new THREE.Group()
  const side = toon('#b5653a')
  const top = toon('#e09a5c')
  for (const w of arena.walls) {
    group.add(part(box(w.w, 1.5, w.d), side, [w.x, 0.75, w.z]))
    group.add(part(box(w.w * 0.92, 0.25, w.d * 0.92), top, [w.x, 1.6, w.z]))
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

/** Cactus patches: the "bushes" of the canyon. */
function bushes(arena: Arena): THREE.Object3D {
  const group = new THREE.Group()
  const greens = [toon('#4cbf4f'), toon('#3aa34a')]
  const patch = toon('#7fbf4a')
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
      const c = cactus(b.x + Math.cos(a) * d, b.z + Math.sin(a) * d, 0.9 + (i % 3) * 0.3, greens[i % 2])
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

export function buildArena(arena: Arena): THREE.Group {
  const root = new THREE.Group()
  root.add(ground(arena), cliffs(arena), walls(arena), bushes(arena))
  for (const d of arena.decorations) root.add(decoration(d))
  return root
}
