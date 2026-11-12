import * as THREE from 'three'
import { box, capsule, cylinder, part, sphere, toon } from './parts'

export interface DummyRig {
  root: THREE.Group
  /** Everything that breaks apart and flashes when hit. */
  body: THREE.Group
  materials: THREE.MeshToonMaterial[]
  bar: THREE.Group
  fill: THREE.Mesh
}

const BAR_WIDTH = 1.4

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

  const bar = new THREE.Group()
  bar.position.y = 2.6
  const back = new THREE.Mesh(new THREE.PlaneGeometry(BAR_WIDTH + 0.1, 0.24), new THREE.MeshBasicMaterial({ color: '#160f33' }))
  const fillGeometry = new THREE.PlaneGeometry(BAR_WIDTH, 0.14)
  fillGeometry.translate(BAR_WIDTH / 2, 0, 0)
  const fill = new THREE.Mesh(fillGeometry, new THREE.MeshBasicMaterial({ color: '#4cd964' }))
  fill.position.set(-BAR_WIDTH / 2, 0, 0.01)
  bar.add(back, fill)
  root.add(bar)

  return { root, body, materials: [straw, wood, red, white], bar, fill }
}

export function setHealth(rig: DummyRig, fraction: number) {
  rig.fill.scale.x = Math.max(0.001, fraction)
  const color = fraction > 0.5 ? '#4cd964' : fraction > 0.25 ? '#ffd23f' : '#ff3b30'
  ;(rig.fill.material as THREE.MeshBasicMaterial).color.set(color)
}
