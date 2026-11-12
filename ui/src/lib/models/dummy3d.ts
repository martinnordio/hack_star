import * as THREE from 'three'
import { buildHealthBar, setBarHealth, type HealthBar } from './healthBar'
import { box, capsule, cylinder, part, sphere, toon } from './parts'

export interface DummyRig {
  root: THREE.Group
  /** Everything that breaks apart and flashes when hit. */
  body: THREE.Group
  materials: THREE.MeshToonMaterial[]
  bar: HealthBar
}

/** A straw training dummy on a post, with a target painted on its chest. */
export function buildDummy(): DummyRig {
  const root = new THREE.Group()
  const body = new THREE.Group()
  root.add(body)
  const straw = toon('#e8c26a')
  const wood = toon('#8a5a2b')
  const red = toon('#e8322b')
  const white = toon('#ffffff')
  body.add(part(cylinder(0.08, 0.1, 1.1), wood, [0, 0.55, 0]))
  body.add(part(cylinder(0.45, 0.5, 0.12), wood, [0, 0.06, 0]))
  body.add(part(capsule(0.42, 0.45), straw, [0, 1.15, 0]))
  body.add(part(sphere(0.3, 14), straw, [0, 1.85, 0]))
  body.add(part(box(1.3, 0.14, 0.14), wood, [0, 1.3, -0.05]))
  for (const [r, m, z] of [[0.3, red, 0.4], [0.2, white, 0.41], [0.1, red, 0.42]] as const) {
    const ring = new THREE.Mesh(new THREE.CircleGeometry(r, 20), m)
    ring.position.set(0, 1.18, z)
    body.add(ring)
  }
  body.traverse((o) => {
    if (o instanceof THREE.Mesh) o.castShadow = true
  })

  const bar = buildHealthBar(2.6)
  root.add(bar.group)

  return { root, body, materials: [straw, wood, red, white], bar }
}

export function setHealth(rig: DummyRig, fraction: number) {
  setBarHealth(rig.bar, fraction)
}
