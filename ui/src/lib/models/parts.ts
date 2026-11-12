import * as THREE from 'three'

// Cartoon look: 3-step toon shading plus a dark "inverted hull" outline on every part.

const gradientMap = (() => {
  const texture = new THREE.DataTexture(new Uint8Array([110, 190, 255]), 3, 1, THREE.RedFormat)
  texture.minFilter = THREE.NearestFilter
  texture.magFilter = THREE.NearestFilter
  texture.needsUpdate = true
  return texture
})()

const OUTLINE = new THREE.MeshBasicMaterial({ color: '#160f33', side: THREE.BackSide })

type Vec3 = [number, number, number]

interface PartOptions {
  rotation?: Vec3
  scale?: Vec3
  outline?: boolean
}

export function toon(color: string, glow?: string, glowStrength = 0.9): THREE.MeshToonMaterial {
  return new THREE.MeshToonMaterial({
    color,
    gradientMap,
    emissive: glow ?? '#000000',
    emissiveIntensity: glow ? glowStrength : 0,
  })
}

export function part(
  geometry: THREE.BufferGeometry,
  material: THREE.Material,
  position: Vec3,
  { rotation, scale, outline = true }: PartOptions = {},
): THREE.Mesh {
  const mesh = new THREE.Mesh(geometry, material)
  mesh.position.set(...position)
  if (rotation) mesh.rotation.set(...rotation)
  if (scale) mesh.scale.set(...scale)
  mesh.castShadow = true
  if (outline) {
    const hull = new THREE.Mesh(geometry, OUTLINE)
    hull.scale.setScalar(1.07)
    mesh.add(hull)
  }
  return mesh
}

export const sphere = (r: number, detail = 20) => new THREE.SphereGeometry(r, detail, detail * 0.75)
export const capsule = (r: number, length: number) => new THREE.CapsuleGeometry(r, length, 6, 14)
export const cone = (r: number, h: number, sides = 14) => new THREE.ConeGeometry(r, h, sides)
export const box = (w: number, h: number, d: number) => new THREE.BoxGeometry(w, h, d)
export const cylinder = (rt: number, rb: number, h: number) => new THREE.CylinderGeometry(rt, rb, h, 16)

export interface Rig {
  root: THREE.Group
  body: THREE.Object3D
  head: THREE.Object3D
  /** Parts that spin slowly (rings, sparkles). */
  spinners: THREE.Object3D[]
  /** Parts that flicker (flames, screens). */
  flickers: THREE.Object3D[]
}

export function newRig(): Rig {
  const root = new THREE.Group()
  const body = new THREE.Group()
  const head = new THREE.Group()
  root.add(body)
  body.add(head)
  return { root, body, head, spinners: [], flickers: [] }
}

/** Two big shiny cartoon eyes, placed on the front of a head of radius r centred at y. */
export function addEyes(head: THREE.Object3D, y: number, r: number, color = '#160f33', spread = 0.34) {
  const eye = toon(color)
  const shine = new THREE.MeshBasicMaterial({ color: '#ffffff' })
  for (const side of [-1, 1]) {
    const x = side * r * spread
    const z = Math.sqrt(Math.max(0, r * r - x * x)) * 0.92
    const e = part(sphere(r * 0.16, 12), eye, [x, y + r * 0.05, z], { scale: [1, 1.35, 0.6], outline: false })
    head.add(e)
    head.add(part(sphere(r * 0.055, 8), shine, [x + r * 0.05, y + r * 0.13, z + r * 0.08], { outline: false }))
  }
}

export interface HumanColors {
  skin: string
  top: string
  legs: string
  shoes: string
  topGlow?: string
}

/** Chibi kid body: big head, short legs. Feet at y = 0, head centre at y = 1.65. */
export function human(rig: Rig, c: HumanColors) {
  const top = toon(c.top, c.topGlow, 0.5)
  const legs = toon(c.legs)
  const shoes = toon(c.shoes)
  const skin = toon(c.skin)
  for (const side of [-1, 1]) {
    rig.root.add(part(capsule(0.13, 0.25), legs, [side * 0.17, 0.3, 0]))
    rig.root.add(part(sphere(0.15, 12), shoes, [side * 0.17, 0.1, 0.05], { scale: [1, 0.7, 1.35] }))
    rig.body.add(part(capsule(0.1, 0.3), top, [side * 0.47, 0.92, 0], { rotation: [0, 0, side * 0.45] }))
    rig.body.add(part(sphere(0.12, 12), skin, [side * 0.58, 0.7, 0.03]))
  }
  rig.body.add(part(capsule(0.36, 0.3), top, [0, 0.85, 0]))
  rig.head.add(part(sphere(0.5), skin, [0, 1.65, 0]))
  addEyes(rig.head, 1.65, 0.5)
}

/** Soft additive halo and an orbiting ring of sparkles for Legendary skins. */
export function addLegendaryGlow(rig: Rig, color: string) {
  const halo = new THREE.Mesh(
    sphere(1.25, 24),
    new THREE.MeshBasicMaterial({
      color,
      transparent: true,
      opacity: 0.22,
      blending: THREE.AdditiveBlending,
      depthWrite: false,
    }),
  )
  halo.position.y = 1.1
  halo.scale.set(1, 1.15, 1)
  rig.root.add(halo)
  rig.flickers.push(halo)

  const ring = new THREE.Group()
  ring.position.y = 1.1
  const sparkle = new THREE.MeshBasicMaterial({ color: '#fff6c8' })
  for (let i = 0; i < 10; i++) {
    const a = (i / 10) * Math.PI * 2
    const s = new THREE.Mesh(new THREE.OctahedronGeometry(0.06), sparkle)
    s.position.set(Math.cos(a) * 1.05, Math.sin(a * 3) * 0.35, Math.sin(a) * 1.05)
    ring.add(s)
  }
  rig.root.add(ring)
  rig.spinners.push(ring)
}
