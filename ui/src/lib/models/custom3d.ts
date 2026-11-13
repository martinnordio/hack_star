import * as THREE from 'three'
import { parseLookSkin, type Look } from '../created'
import { addEyes, box, capsule, cone, cylinder, newRig, part, sphere, toon, type Rig } from './parts'

const SKIN = '#ffd2a8'
const DARK = '#2a1d1d'

const FALLBACK: Look = { type: 'spreader', main: '#2fb5ff', second: '#ffd23f', head: 0, body: 0 }

function legs(rig: Rig, color: string) {
  const leg = toon(color)
  const shoe = toon(DARK)
  for (const side of [-1, 1]) {
    rig.root.add(part(capsule(0.13, 0.25), leg, [side * 0.17, 0.3, 0]))
    rig.root.add(part(sphere(0.15, 12), shoe, [side * 0.17, 0.1, 0.05], { scale: [1, 0.7, 1.35] }))
  }
}

function kidBody(rig: Rig, look: Look) {
  legs(rig, look.second)
  const top = toon(look.main)
  for (const side of [-1, 1]) {
    rig.body.add(part(capsule(0.1, 0.3), top, [side * 0.47, 0.92, 0], { rotation: [0, 0, side * 0.45] }))
    rig.body.add(part(sphere(0.12, 12), toon(SKIN), [side * 0.58, 0.7, 0.03]))
  }
  rig.body.add(part(capsule(0.36, 0.3), top, [0, 0.85, 0]))
  rig.body.add(part(cylinder(0.37, 0.37, 0.1), toon(look.second), [0, 0.68, 0], { outline: false }))
}

function robotBody(rig: Rig, look: Look) {
  const metal = toon(look.main)
  const trim = toon(look.second)
  for (const side of [-1, 1]) {
    rig.root.add(part(cylinder(0.12, 0.14, 0.45), trim, [side * 0.18, 0.28, 0]))
    rig.root.add(part(box(0.26, 0.12, 0.36), toon(DARK), [side * 0.18, 0.06, 0.04]))
    rig.body.add(part(box(0.16, 0.5, 0.16), trim, [side * 0.52, 0.88, 0], { rotation: [0, 0, side * 0.25] }))
    rig.body.add(part(box(0.2, 0.18, 0.2), metal, [side * 0.6, 0.6, 0.02]))
  }
  rig.body.add(part(box(0.78, 0.7, 0.5), metal, [0, 0.9, 0]))
  const light = part(sphere(0.11, 12), toon(look.second, look.second, 1.1), [0, 0.95, 0.26], { outline: false })
  rig.body.add(light)
  rig.flickers.push(light)
}

function armourBody(rig: Rig, look: Look) {
  legs(rig, DARK)
  const plate = toon(look.main)
  const trim = toon(look.second)
  rig.body.add(part(sphere(0.48), plate, [0, 0.85, 0], { scale: [1, 0.95, 0.85] }))
  for (const side of [-1, 1]) {
    rig.body.add(part(sphere(0.2, 14), trim, [side * 0.48, 1.12, 0]))
    rig.body.add(part(capsule(0.1, 0.25), plate, [side * 0.55, 0.82, 0], { rotation: [0, 0, side * 0.3] }))
    rig.body.add(part(sphere(0.12, 12), trim, [side * 0.62, 0.62, 0.03]))
  }
  rig.body.add(part(new THREE.TorusGeometry(0.42, 0.05, 6, 24), trim, [0, 0.62, 0], { rotation: [Math.PI / 2, 0, 0], outline: false }))
}

function kidHead(rig: Rig, look: Look) {
  rig.head.add(part(sphere(0.5), toon(SKIN), [0, 1.65, 0]))
  addEyes(rig.head, 1.65, 0.5)
  const hair = toon(look.second)
  rig.head.add(part(sphere(0.53), hair, [0, 1.78, -0.1], { scale: [1.02, 0.8, 0.95] }))
  for (let i = 0; i < 5; i++) {
    const a = -0.9 + (i / 4) * 1.8
    rig.head.add(part(cone(0.13, 0.4), hair, [Math.sin(a) * 0.3, 2.15, -0.1], { rotation: [-0.3, 0, -a * 0.6] }))
  }
}

function robotHead(rig: Rig, look: Look) {
  rig.head.add(part(box(0.86, 0.72, 0.72), toon(look.main), [0, 1.68, 0]))
  const visor = part(box(0.66, 0.24, 0.05), toon(look.second, look.second, 1.2), [0, 1.72, 0.37], { outline: false })
  rig.head.add(visor)
  rig.flickers.push(visor)
  rig.head.add(part(cylinder(0.03, 0.03, 0.35), toon(DARK), [0, 2.2, 0]))
  const tip = part(sphere(0.08, 10), toon(look.second, look.second, 1.2), [0, 2.4, 0], { outline: false })
  rig.head.add(tip)
  rig.flickers.push(tip)
}

function catHead(rig: Rig, look: Look) {
  const fur = toon(look.main)
  rig.head.add(part(sphere(0.52), fur, [0, 1.65, 0], { scale: [1.05, 0.95, 1] }))
  addEyes(rig.head, 1.68, 0.52, '#160f33', 0.36)
  const inner = toon(look.second)
  for (const side of [-1, 1]) {
    rig.head.add(part(cone(0.18, 0.36, 4), fur, [side * 0.3, 2.12, 0], { rotation: [0, 0, -side * 0.3] }))
    rig.head.add(part(cone(0.1, 0.22, 4), inner, [side * 0.3, 2.1, 0.06], { rotation: [0, 0, -side * 0.3], outline: false }))
  }
  rig.head.add(part(sphere(0.07, 10), inner, [0, 1.56, 0.5], { outline: false }))
  rig.body.add(part(capsule(0.06, 0.6), fur, [0, 0.55, -0.4], { rotation: [0.9, 0, 0] }))
}

const BODIES = [kidBody, robotBody, armourBody]
const HEADS = [kidHead, robotHead, catHead]

/** The created fighter; its look comes from the skin id (`lookSkin`). */
export function buildCreated(skinId: string): Rig {
  const look = parseLookSkin(skinId) ?? FALLBACK
  const rig = newRig()
  BODIES[look.body](rig, look)
  HEADS[look.head](rig, look)
  return rig
}
