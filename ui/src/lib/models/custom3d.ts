import * as THREE from 'three'
import { parseLookSkin, type Look } from '../created'
import { addEyes, box, capsule, cone, cylinder, newRig, part, sphere, toon, type Rig } from './parts'

const SKIN = '#ffd2a8'
const DARK = '#2a1d1d'

const FALLBACK: Look = { type: 'spreader', main: '#2fb5ff', second: '#ffd23f', head: 0, body: 0, hands: 0, legs: 0 }

type Part = (rig: Rig, look: Look) => void

/** A body draws its torso; hands and legs 0 use the body's own arms and legs. */
interface Body {
  torso: Part
  arms: Part
  legs: Part
}

function kidLegsIn(rig: Rig, color: string) {
  const leg = toon(color)
  const shoe = toon(DARK)
  for (const side of [-1, 1]) {
    rig.root.add(part(capsule(0.13, 0.25), leg, [side * 0.17, 0.3, 0]))
    rig.root.add(part(sphere(0.15, 12), shoe, [side * 0.17, 0.1, 0.05], { scale: [1, 0.7, 1.35] }))
  }
}

const kidLegs: Part = (rig, look) => kidLegsIn(rig, look.second)
const darkLegs: Part = (rig) => kidLegsIn(rig, DARK)

const kidArms: Part = (rig, look) => {
  const top = toon(look.main)
  for (const side of [-1, 1]) {
    rig.body.add(part(capsule(0.1, 0.3), top, [side * 0.47, 0.92, 0], { rotation: [0, 0, side * 0.45] }))
    rig.body.add(part(sphere(0.12, 12), toon(SKIN), [side * 0.58, 0.7, 0.03]))
  }
}

const kidTorso: Part = (rig, look) => {
  rig.body.add(part(capsule(0.36, 0.3), toon(look.main), [0, 0.85, 0]))
  rig.body.add(part(cylinder(0.37, 0.37, 0.1), toon(look.second), [0, 0.68, 0], { outline: false }))
}

const robotLegs: Part = (rig, look) => {
  const trim = toon(look.second)
  for (const side of [-1, 1]) {
    rig.root.add(part(cylinder(0.12, 0.14, 0.45), trim, [side * 0.18, 0.28, 0]))
    rig.root.add(part(box(0.26, 0.12, 0.36), toon(DARK), [side * 0.18, 0.06, 0.04]))
  }
}

const robotArms: Part = (rig, look) => {
  const metal = toon(look.main)
  const trim = toon(look.second)
  for (const side of [-1, 1]) {
    rig.body.add(part(box(0.16, 0.5, 0.16), trim, [side * 0.52, 0.88, 0], { rotation: [0, 0, side * 0.25] }))
    rig.body.add(part(box(0.2, 0.18, 0.2), metal, [side * 0.6, 0.6, 0.02]))
  }
}

const robotTorso: Part = (rig, look) => {
  rig.body.add(part(box(0.78, 0.7, 0.5), toon(look.main), [0, 0.9, 0]))
  const light = part(sphere(0.11, 12), toon(look.second, look.second, 1.1), [0, 0.95, 0.26], { outline: false })
  rig.body.add(light)
  rig.flickers.push(light)
}

const armourArms: Part = (rig, look) => {
  const plate = toon(look.main)
  const trim = toon(look.second)
  for (const side of [-1, 1]) {
    rig.body.add(part(capsule(0.1, 0.25), plate, [side * 0.55, 0.82, 0], { rotation: [0, 0, side * 0.3] }))
    rig.body.add(part(sphere(0.12, 12), trim, [side * 0.62, 0.62, 0.03]))
  }
}

const armourTorso: Part = (rig, look) => {
  const trim = toon(look.second)
  rig.body.add(part(sphere(0.48), toon(look.main), [0, 0.85, 0], { scale: [1, 0.95, 0.85] }))
  for (const side of [-1, 1]) rig.body.add(part(sphere(0.2, 14), trim, [side * 0.48, 1.12, 0]))
  rig.body.add(part(new THREE.TorusGeometry(0.42, 0.05, 6, 24), trim, [0, 0.62, 0], { rotation: [Math.PI / 2, 0, 0], outline: false }))
}

const hoodieTorso: Part = (rig, look) => {
  const trim = toon(look.second)
  rig.body.add(part(capsule(0.37, 0.28), toon(look.main), [0, 0.86, 0]))
  rig.body.add(part(new THREE.TorusGeometry(0.3, 0.09, 8, 20), trim, [0, 1.18, -0.12], { rotation: [Math.PI / 2.4, 0, 0] }))
  rig.body.add(part(box(0.42, 0.16, 0.06), trim, [0, 0.72, 0.35]))
  for (const side of [-1, 1]) rig.body.add(part(cylinder(0.02, 0.02, 0.22), toon(DARK), [side * 0.1, 1.0, 0.34], { outline: false }))
}

const jetTorso: Part = (rig, look) => {
  const tank = toon(look.second)
  const flame = toon('#ff8a1a', '#ff8a1a', 1.2)
  rig.body.add(part(box(0.7, 0.66, 0.48), toon(look.main), [0, 0.9, 0]))
  for (const side of [-1, 1]) {
    rig.body.add(part(cylinder(0.12, 0.12, 0.5), tank, [side * 0.18, 0.98, -0.34]))
    const fire = part(cone(0.1, 0.26, 10), flame, [side * 0.18, 0.6, -0.34], { rotation: [Math.PI, 0, 0], outline: false })
    rig.body.add(fire)
    rig.flickers.push(fire)
  }
}

const BODIES: Body[] = [
  { torso: kidTorso, arms: kidArms, legs: kidLegs },
  { torso: robotTorso, arms: robotArms, legs: robotLegs },
  { torso: armourTorso, arms: armourArms, legs: darkLegs },
  { torso: hoodieTorso, arms: kidArms, legs: kidLegs },
  { torso: jetTorso, arms: robotArms, legs: robotLegs },
]

const clawHands: Part = (rig, look) => {
  const arm = toon(look.main)
  const claw = toon(look.second)
  for (const side of [-1, 1]) {
    rig.body.add(part(capsule(0.1, 0.3), arm, [side * 0.5, 0.9, 0], { rotation: [0, 0, side * 0.4] }))
    for (const spread of [-1, 0, 1]) {
      rig.body.add(part(cone(0.05, 0.2, 8), claw, [side * 0.62 + spread * 0.05, 0.58, 0.04], { rotation: [Math.PI, 0, spread * 0.3] }))
    }
  }
}

const gloveHands: Part = (rig, look) => {
  const arm = toon(look.main)
  const glove = toon(look.second)
  for (const side of [-1, 1]) {
    rig.body.add(part(capsule(0.09, 0.28), arm, [side * 0.5, 0.9, 0], { rotation: [0, 0, side * 0.4] }))
    rig.body.add(part(sphere(0.19, 14), glove, [side * 0.62, 0.64, 0.05]))
    rig.body.add(part(cylinder(0.14, 0.14, 0.08), arm, [side * 0.6, 0.77, 0.03], { outline: false }))
  }
}

const springLegs: Part = (rig, look) => {
  const coil = toon(look.second)
  const foot = toon(look.main)
  for (const side of [-1, 1]) {
    for (const y of [0.2, 0.31, 0.42]) {
      rig.root.add(part(new THREE.TorusGeometry(0.11, 0.035, 6, 16), coil, [side * 0.17, y, 0], { rotation: [Math.PI / 2, 0, 0], outline: false }))
    }
    rig.root.add(part(sphere(0.15, 12), foot, [side * 0.17, 0.08, 0.05], { scale: [1.1, 0.55, 1.4] }))
  }
}

const bootLegs: Part = (rig, look) => {
  const leg = toon(look.second)
  const boot = toon(look.main)
  for (const side of [-1, 1]) {
    rig.root.add(part(capsule(0.12, 0.18), leg, [side * 0.17, 0.38, 0]))
    rig.root.add(part(box(0.3, 0.24, 0.42), boot, [side * 0.17, 0.12, 0.05]))
  }
}

/** Hands and legs 1 and 2 (0 is the body's own). */
const HANDS: Part[] = [clawHands, gloveHands]
const LEGS: Part[] = [springLegs, bootLegs]

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

function dinoHead(rig: Rig, look: Look) {
  const scales = toon(look.main)
  rig.head.add(part(sphere(0.5), scales, [0, 1.66, 0], { scale: [1, 0.92, 1.02] }))
  rig.head.add(part(sphere(0.3, 16), scales, [0, 1.5, 0.36], { scale: [1.05, 0.62, 0.8] }))
  addEyes(rig.head, 1.74, 0.48)
  const spike = toon(look.second)
  for (let i = 0; i < 4; i++) {
    const z = 0.28 - i * 0.2
    rig.head.add(part(cone(0.09, 0.26, 6), spike, [0, 2.12 - Math.abs(z - 0.05) * 0.35, z - 0.05], { rotation: [-0.25 * (i - 1), 0, 0] }))
  }
}

function domeHead(rig: Rig, look: Look) {
  rig.head.add(part(cylinder(0.44, 0.48, 0.22), toon(look.main), [0, 1.36, 0]))
  rig.head.add(part(sphere(0.43), toon('#cfeeff'), [0, 1.66, 0]))
  addEyes(rig.head, 1.66, 0.43, '#160f33', 0.36)
  for (const side of [-1, 1]) {
    rig.head.add(part(cylinder(0.025, 0.025, 0.3), toon(DARK), [side * 0.3, 2.1, 0], { rotation: [0, 0, -side * 0.35] }))
    const tip = part(sphere(0.07, 10), toon(look.second, look.second, 1.2), [side * 0.36, 2.25, 0], { outline: false })
    rig.head.add(tip)
    rig.flickers.push(tip)
  }
}

const HEADS = [kidHead, robotHead, catHead, dinoHead, domeHead]

/** The created fighter; its look comes from the skin id (`lookSkin`). */
export function buildCreated(skinId: string): Rig {
  const look = parseLookSkin(skinId) ?? FALLBACK
  const rig = newRig()
  const body = BODIES[look.body] ?? BODIES[0]
  ;(HANDS[look.hands - 1] ?? body.arms)(rig, look)
  ;(LEGS[look.legs - 1] ?? body.legs)(rig, look)
  body.torso(rig, look)
  ;(HEADS[look.head] ?? HEADS[0])(rig, look)
  return rig
}
