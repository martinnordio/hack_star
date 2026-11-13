import * as THREE from 'three'
import {
  addEyes,
  addLegendaryGlow,
  box,
  capsule,
  cone,
  cylinder,
  glowing,
  human,
  move,
  newRig,
  part,
  shiny,
  sphere,
  toon,
  type Rig,
} from './parts'

// The five newer fighters: more parts, shiny and glowing materials, and several moving parts each.

type Palette = Record<string, string>

function palette(skin: string, looks: Record<string, Palette>): Palette {
  return looks[skin] ?? looks.default
}

/** Small parts without an outline: details that would only look noisy outlined. */
const detail = (geometry: THREE.BufferGeometry, material: THREE.Material, position: [number, number, number], rotation?: [number, number, number], scale?: [number, number, number]) =>
  part(geometry, material, position, { outline: false, rotation, scale })

function ring(rig: Rig, count: number, radius: number, y: number, make: (i: number) => THREE.Object3D, speed: number) {
  const group = new THREE.Group()
  group.position.y = y
  for (let i = 0; i < count; i++) {
    const a = (i / count) * Math.PI * 2
    const o = make(i)
    o.position.set(Math.cos(a) * radius, o.position.y, Math.sin(a) * radius)
    group.add(o)
  }
  rig.root.add(group)
  move(rig, group, 'spin', 0, speed)
  return group
}

export function marina(skin: string): Rig {
  const c = palette(skin, {
    default: { suit: '#1fb5a8', legs: '#16325c', hair: '#ffcc66', water: '#3ad7ff', board: '#ff6b3d', stripe: '#ffffff' },
  })
  const rig = newRig()
  human(rig, { skin: '#e8b08a', top: c.suit, legs: c.legs, shoes: '#ffd23f' })

  // Long wavy hair: a cap and locks that sway.
  const hair = toon(c.hair)
  rig.head.add(part(sphere(0.54), hair, [0, 1.75, -0.12], { scale: [1.04, 0.92, 0.95] }))
  for (let i = 0; i < 6; i++) {
    const side = i < 3 ? -1 : 1
    const lock = part(capsule(0.1, 0.45), hair, [side * (0.32 + (i % 3) * 0.08), 1.38 - (i % 3) * 0.05, -0.28 + (i % 3) * 0.08], { rotation: [0.2, 0, side * 0.15] })
    rig.head.add(lock)
    move(rig, lock, 'swingZ', 0.08, 2.4, i)
  }
  // Sunglasses pushed up on the head, shiny.
  const lens = shiny('#160f33', 0.9, 0.15)
  for (const side of [-1, 1]) rig.head.add(detail(cylinder(0.1, 0.1, 0.03), lens, [side * 0.14, 2.12, 0.2], [0.6, 0, 0]))
  rig.head.add(detail(box(0.1, 0.025, 0.025), shiny('#ffd23f', 0.9, 0.2), [0, 2.13, 0.23]))
  // Shell necklace.
  const pearl = shiny('#fff4e6', 0.2, 0.15)
  for (let i = 0; i < 7; i++) {
    const a = -0.9 + (i / 6) * 1.8
    rig.body.add(detail(sphere(0.045, 8), pearl, [Math.sin(a) * 0.3, 1.18 - Math.cos(a) * 0.08, 0.27 + Math.cos(a) * 0.04]))
  }
  rig.body.add(detail(cone(0.08, 0.1, 6), shiny('#ff8ac2', 0.2, 0.2), [0, 1.06, 0.33], [1.6, 0, 0]))
  // Wetsuit stripes.
  const stripe = toon(c.stripe)
  for (const side of [-1, 1]) rig.body.add(detail(box(0.05, 0.5, 0.02), stripe, [side * 0.2, 0.86, 0.35]))
  // Surfboard on the back with a stripe and a fin.
  const board = new THREE.Group()
  board.position.set(0, 1.0, -0.42)
  board.rotation.set(0.12, 0, 0.25)
  board.add(part(capsule(0.22, 1.2), shiny(c.board, 0.1, 0.25), [0, 0, 0], { scale: [1, 1, 0.25] }))
  board.add(detail(box(0.08, 1.5, 0.12), shiny(c.stripe, 0.1, 0.25), [0, 0, 0]))
  board.add(detail(cone(0.1, 0.25, 3), shiny('#160f33', 0.4, 0.3), [0, -0.65, -0.08], [Math.PI / 2, 0, 0]))
  rig.body.add(board)
  // A ball of water in the hand.
  const ball = detail(sphere(0.2, 16), glowing(c.water, 0.7), [0.62, 0.8, 0.25])
  ball.add(detail(sphere(0.11, 10), glowing('#ffffff', 0.6), [0.04, 0.05, 0.05]))
  rig.body.add(ball)
  move(rig, ball, 'bob', 0.06, 3)
  // Her own wave: a swirl of water around the feet, with droplets.
  const wave = new THREE.Group()
  for (let i = 0; i < 3; i++) {
    const arc = detail(new THREE.TorusGeometry(0.7 + i * 0.12, 0.05, 6, 30, Math.PI * 1.2), glowing(c.water, 0.55 - i * 0.12), [0, 0.08 + i * 0.07, 0], [Math.PI / 2, 0, i * 2])
    wave.add(arc)
  }
  rig.root.add(wave)
  move(rig, wave, 'spin', 0, 1.6)
  ring(rig, 6, 0.85, 0.9, (i) => detail(sphere(0.06, 8), glowing('#bff4ff', 0.9), [0, Math.sin(i * 2) * 0.3, 0]), -1.2)
  return rig
}

export function drako(skin: string): Rig {
  const c = palette(skin, {
    default: { scale: '#e8442b', belly: '#ffd27a', horn: '#ffd23f', wing: '#ff8a1a', fire: '#ffb000' },
  })
  const rig = newRig()
  const scales = shiny(c.scale, 0.35, 0.35)
  const belly = toon(c.belly)
  const horn = shiny(c.horn, 0.8, 0.2)
  // Chubby body with a striped belly.
  rig.body.add(part(sphere(0.55), scales, [0, 0.75, 0], { scale: [1, 1.05, 0.95] }))
  rig.body.add(part(sphere(0.42), belly, [0, 0.72, 0.3], { scale: [0.9, 1, 0.6] }))
  for (let i = 0; i < 4; i++) rig.body.add(detail(capsule(0.05, 0.36 - Math.abs(i - 1.5) * 0.1), toon('#e8a04a'), [0, 0.48 + i * 0.15, 0.56 - Math.abs(i - 1.5) * 0.05], [0, 0, Math.PI / 2], [1, 1, 0.5]))
  // Legs with claws, little arms.
  for (const side of [-1, 1]) {
    rig.root.add(part(sphere(0.2, 14), scales, [side * 0.28, 0.18, 0.05], { scale: [1, 0.9, 1.2] }))
    for (let k = -1; k <= 1; k++) rig.root.add(detail(cone(0.04, 0.1, 6), horn, [side * 0.28 + k * 0.08, 0.06, 0.28], [Math.PI / 2, 0, 0]))
    const arm = part(capsule(0.09, 0.22), scales, [side * 0.5, 0.85, 0.15], { rotation: [0.5, 0, side * 0.6] })
    rig.body.add(arm)
    move(rig, arm, 'swingX', 0.15, 2.5, side)
  }
  // Head with a snout, nostrils, horns and a crest.
  rig.head.add(part(sphere(0.48), scales, [0, 1.62, 0]))
  rig.head.add(part(sphere(0.3, 16), scales, [0, 1.5, 0.38], { scale: [1.1, 0.75, 1] }))
  for (const side of [-1, 1]) {
    rig.head.add(detail(sphere(0.04, 8), toon('#160f33'), [side * 0.1, 1.55, 0.66]))
    rig.head.add(part(cone(0.08, 0.4), horn, [side * 0.25, 2.05, -0.1], { rotation: [-0.5, 0, -side * 0.35] }))
  }
  addEyes(rig.head, 1.72, 0.46, '#160f33', 0.4)
  for (let i = 0; i < 4; i++) rig.head.add(detail(cone(0.07, 0.2, 4), horn, [0, 2.0 - i * 0.12, -0.3 - i * 0.1], [-0.9 - i * 0.2, 0, 0]))
  // Spikes down the back, a swinging tail with an arrow tip.
  for (let i = 0; i < 5; i++) rig.body.add(detail(cone(0.08, 0.2, 4), horn, [0, 1.15 - i * 0.17, -0.48 - Math.sin(i * 0.4) * 0.05], [-1.2, 0, 0]))
  const tail = new THREE.Group()
  tail.position.set(0, 0.45, -0.5)
  for (let i = 0; i < 5; i++) tail.add(part(sphere(0.16 - i * 0.025, 12), scales, [0, -i * 0.05, -i * 0.17]))
  tail.add(detail(cone(0.12, 0.22, 4), horn, [0, -0.25, -0.9], [-Math.PI / 2, 0, 0]))
  rig.body.add(tail)
  move(rig, tail, 'swingY', 0.35, 2.2)
  // Wings that flap: three bony fingers with a membrane between them, folded back.
  const membrane = shiny(c.wing, 0.2, 0.4, c.wing, 0.25)
  for (const side of [-1, 1]) {
    const wing = new THREE.Group()
    wing.position.set(side * 0.42, 1.15, -0.3)
    wing.rotation.y = side * 0.35
    wing.scale.setScalar(1.3)
    for (let f = 0; f < 3; f++) {
      const a = side * (0.5 + f * 0.45)
      wing.add(detail(cylinder(0.025, 0.02, 0.75 - f * 0.12), horn, [Math.sin(a) * 0.35, 0.2 + Math.cos(a) * 0.1, 0], [0, 0, -a]))
      wing.add(detail(cone(0.2, 0.7 - f * 0.1, 3), membrane, [Math.sin(a) * 0.3, 0.12 + Math.cos(a) * 0.05, 0], [0, 0, -a + side * 0.2], [1, 1, 0.12]))
    }
    rig.body.add(wing)
    move(rig, wing, 'swingY', 0.4 * side, 3.2)
  }
  // Fire flickering in the open mouth, and embers around.
  rig.head.add(detail(sphere(0.1, 10), toon('#5a1010'), [0, 1.36, 0.58], undefined, [1.2, 0.6, 0.5]))
  const flame = detail(cone(0.07, 0.2, 8), glowing(c.fire, 0.9), [0, 1.36, 0.66], [Math.PI / 2, 0, 0])
  rig.head.add(flame)
  rig.flickers.push(flame)
  ring(rig, 5, 0.75, 1.3, (i) => detail(sphere(0.05, 6), glowing(i % 2 ? '#ffd23f' : '#ff5a1a', 0.9), [0, Math.cos(i) * 0.3, 0]), 1.4)
  return rig
}

export function spectra(skin: string): Rig {
  const c = palette(skin, {
    default: { sheet: '#c9b3ff', glow: '#9b6bff', hat: '#241a46', band: '#ff4f9a', card: '#ffd23f' },
  })
  const rig = newRig()
  // A floating ghost sheet with a wavy hem.
  const sheet = new THREE.MeshStandardMaterial({ color: c.sheet, emissive: c.glow, emissiveIntensity: 0.35, roughness: 0.4, transparent: true, opacity: 0.88 })
  const points = [0, 0.28, 0.42, 0.5, 0.52, 0.5, 0.42, 0.25, 0].map((r, i) => new THREE.Vector2(r + 0.02, 0.35 + i * 0.18))
  rig.body.add(part(new THREE.LatheGeometry(points, 24), sheet, [0, 0, 0]))
  for (let i = 0; i < 8; i++) {
    const a = (i / 8) * Math.PI * 2
    const fold = detail(sphere(0.13, 10), sheet, [Math.cos(a) * 0.48, 0.32, Math.sin(a) * 0.48])
    rig.body.add(fold)
    move(rig, fold, 'bob', 0.04, 4, i)
  }
  move(rig, rig.body, 'bob', 0.12, 1.6)
  // Glowing eyes and a smile.
  for (const side of [-1, 1]) rig.head.add(detail(sphere(0.08, 10), glowing('#ffffff', 1), [side * 0.16, 1.5, 0.43], undefined, [1, 1.4, 0.6]))
  rig.head.add(detail(new THREE.TorusGeometry(0.1, 0.02, 4, 12, Math.PI), toon('#160f33'), [0, 1.36, 0.46], [0, 0, Math.PI]))
  // Top hat with a band, bow tie.
  const hat = shiny(c.hat, 0.3, 0.25)
  rig.head.add(part(cylinder(0.42, 0.42, 0.05), hat, [0, 1.95, 0]))
  rig.head.add(part(cylinder(0.27, 0.29, 0.5), hat, [0, 2.2, 0]))
  rig.head.add(detail(cylinder(0.3, 0.3, 0.09), shiny(c.band, 0.3, 0.3), [0, 2.02, 0]))
  rig.head.add(detail(new THREE.OctahedronGeometry(0.06), shiny('#ffffff', 0.9, 0.1, '#ffffff', 0.5), [0.2, 2.03, 0.22]))
  for (const side of [-1, 1]) rig.body.add(detail(cone(0.09, 0.16, 4), shiny(c.band, 0.3, 0.3), [side * 0.08, 1.18, 0.42], [0, 0, side * Math.PI / 2]))
  // Floating white gloves, one holding a wand with a star.
  const glove = toon('#ffffff')
  for (const side of [-1, 1]) {
    const hand = new THREE.Group()
    hand.position.set(side * 0.72, 0.95, 0.15)
    hand.add(part(sphere(0.13, 12), glove, [0, 0, 0]))
    hand.add(part(cylinder(0.08, 0.1, 0.12), glove, [0, -0.13, 0]))
    rig.body.add(hand)
    move(rig, hand, 'bob', 0.08, 2.2, side * 1.5)
    if (side === 1) {
      hand.add(detail(cylinder(0.025, 0.025, 0.6), shiny('#160f33', 0.5, 0.3), [0, 0.3, 0]))
      const star = detail(new THREE.OctahedronGeometry(0.1), glowing(c.card, 1), [0, 0.62, 0])
      hand.add(star)
      rig.flickers.push(star)
    }
  }
  // Glowing cards circling around, and sparkles along the hem.
  const colours = [c.card, c.band, '#39d3ff', '#ffffff', c.card]
  ring(rig, 10, 0.95, 0.95, (i) => detail(box(0.16, 0.24, 0.01), glowing(colours[i % colours.length], 0.95), [0, Math.sin(i * 1.7) * 0.25, 0], [0, i, 0.2]), 1.1)
  ring(rig, 8, 0.62, 0.25, (i) => detail(new THREE.OctahedronGeometry(0.04), glowing(i % 2 ? '#ffffff' : c.glow, 1), [0, Math.sin(i) * 0.08, 0]), -0.8)
  return rig
}

export function mecha(skin: string): Rig {
  const c = palette(skin, {
    default: { metal: '#3a7bff', trim: '#ffd23f', dark: '#2a2f45', light: '#39ffcc', kid: '#ffd2a8', cap: '#e8322b' },
  })
  const rig = newRig()
  const metal = shiny(c.metal, 0.75, 0.3)
  const trim = shiny(c.trim, 0.8, 0.25)
  const dark = shiny(c.dark, 0.6, 0.45)
  // Legs: thighs, knee joints, big feet.
  for (const side of [-1, 1]) {
    rig.root.add(part(box(0.32, 0.18, 0.5), dark, [side * 0.3, 0.09, 0.05]))
    rig.root.add(part(cylinder(0.13, 0.15, 0.4), metal, [side * 0.3, 0.38, 0]))
    rig.root.add(detail(sphere(0.12, 12), trim, [side * 0.3, 0.6, 0.02]))
  }
  // Torso with panels, rivets and a glowing core.
  rig.body.add(part(box(1.0, 0.75, 0.7), metal, [0, 0.98, 0]))
  rig.body.add(detail(box(0.6, 0.25, 0.05), dark, [0, 0.82, 0.36]))
  for (let i = 0; i < 12; i++) rig.body.add(detail(sphere(0.03, 6), trim, [-0.42 + (i % 3) * 0.42, [1.3, 0.66, 1.0, 0.82][Math.floor(i / 3)], i < 6 ? 0.36 : -0.36]))
  for (const side of [-1, 1]) for (let k = 0; k < 3; k++) rig.body.add(detail(box(0.02, 0.06, 0.4), dark, [side * 0.51, 1.1 - k * 0.12, 0]))
  const core = detail(sphere(0.1, 12), glowing(c.light, 1), [0, 0.82, 0.4])
  rig.body.add(core)
  rig.flickers.push(core)
  // Shoulders and arms: a fist and an arm cannon.
  for (const side of [-1, 1]) {
    rig.body.add(part(sphere(0.25, 14), trim, [side * 0.62, 1.25, 0]))
    const arm = new THREE.Group()
    arm.position.set(side * 0.68, 1.1, 0)
    arm.add(part(cylinder(0.12, 0.12, 0.45), dark, [0, -0.25, 0]))
    if (side === -1) {
      arm.add(part(box(0.3, 0.3, 0.3), metal, [0, -0.6, 0.05]))
    } else {
      arm.add(part(cylinder(0.16, 0.16, 0.5), metal, [0, -0.55, 0.2], { rotation: [Math.PI / 2, 0, 0] }))
      arm.add(detail(cylinder(0.1, 0.1, 0.05), glowing(c.light, 1), [0, -0.55, 0.46], [Math.PI / 2, 0, 0]))
    }
    rig.body.add(arm)
    move(rig, arm, 'swingX', 0.12, 2, side)
  }
  // Glass cockpit with the kid inside, who bobs and looks around.
  rig.head.add(part(cylinder(0.42, 0.45, 0.12), dark, [0, 1.42, 0]))
  rig.head.add(detail(sphere(0.42, 20), new THREE.MeshStandardMaterial({ color: '#bfe8ff', transparent: true, opacity: 0.3, roughness: 0.05, metalness: 0.2 }), [0, 1.62, 0]))
  const kid = new THREE.Group()
  kid.add(part(sphere(0.24, 16), toon(c.kid), [0, 1.62, 0]))
  addEyes(kid, 1.62, 0.24)
  kid.add(part(sphere(0.25, 14), toon(c.cap), [0, 1.72, -0.02], { scale: [1, 0.6, 1] }))
  kid.add(detail(box(0.2, 0.03, 0.15), toon(c.cap), [0, 1.7, 0.2]))
  rig.head.add(kid)
  move(rig, kid, 'swingY', 0.4, 1.3)
  // Antennas with blinking lights, thrusters on the back.
  for (const side of [-1, 1]) {
    rig.body.add(detail(cylinder(0.02, 0.02, 0.4), dark, [side * 0.38, 1.55, -0.2]))
    const blink = detail(sphere(0.05, 8), glowing(side < 0 ? '#ff3b5c' : c.light, 1), [side * 0.38, 1.77, -0.2])
    rig.body.add(blink)
    rig.flickers.push(blink)
    rig.body.add(part(cylinder(0.12, 0.16, 0.35), dark, [side * 0.28, 0.95, -0.45], { rotation: [0.3, 0, 0] }))
    const jet = detail(cone(0.1, 0.35, 10), glowing('#ffb000', 0.85), [side * 0.28, 0.72, -0.52], [Math.PI + 0.3, 0, 0])
    rig.body.add(jet)
    rig.flickers.push(jet)
  }
  return rig
}

export function zeus(skin: string): Rig {
  const c = palette(skin, {
    default: { toga: '#ffffff', trim: '#ffd23f', cape: '#2f6bff', hair: '#f4f6ff', bolt: '#fff35c', cloud: '#8c95b8' },
  })
  const rig = newRig()
  human(rig, { skin: '#ffd9b5', top: c.toga, legs: c.toga, shoes: '#c9952f' })
  const gold = shiny(c.trim, 0.9, 0.2)
  // Gold belt and shoulder pin on the toga, sandal straps.
  rig.body.add(detail(new THREE.TorusGeometry(0.36, 0.04, 6, 24), gold, [0, 0.72, 0], [Math.PI / 2, 0, 0]))
  rig.body.add(detail(sphere(0.07, 10), gold, [0.25, 1.15, 0.28]))
  for (const side of [-1, 1]) rig.root.add(detail(new THREE.TorusGeometry(0.15, 0.025, 4, 14), gold, [side * 0.17, 0.2, 0], [Math.PI / 2, 0, 0]))
  // Fluffy cloud hair and a laurel crown.
  const hair = toon(c.hair)
  for (let i = 0; i < 7; i++) {
    const a = (i / 7) * Math.PI * 2
    rig.head.add(part(sphere(0.19, 12), hair, [Math.cos(a) * 0.38, 1.95 + Math.sin(i * 1.3) * 0.05, Math.sin(a) * 0.3 - 0.08]))
  }
  rig.head.add(part(sphere(0.35, 14), hair, [0, 2.05, -0.08]))
  rig.head.add(detail(new THREE.TorusGeometry(0.47, 0.03, 6, 28), gold, [0, 1.98, 0], [Math.PI / 2, 0, 0]))
  for (let i = 0; i < 10; i++) {
    const a = (i / 10) * Math.PI * 2
    rig.head.add(detail(sphere(0.06, 6), shiny('#7fcf4a', 0.6, 0.3), [Math.cos(a) * 0.47, 2.02, Math.sin(a) * 0.47], undefined, [1, 0.5, 1.6]))
  }
  // A cape that waves behind him.
  const cape = part(box(0.8, 1.0, 0.04), shiny(c.cape, 0.3, 0.4), [0, 0.8, -0.38], { rotation: [0.15, 0, 0] })
  rig.body.add(cape)
  move(rig, cape, 'swingX', 0.1, 2.6)
  // Lightning bolt in the hand, made of three glowing zig-zag pieces.
  const bolt = new THREE.Group()
  bolt.position.set(0.66, 0.85, 0.25)
  const zap = glowing(c.bolt, 1)
  bolt.add(detail(box(0.08, 0.3, 0.05), zap, [0, 0.25, 0], [0, 0, 0.5]))
  bolt.add(detail(box(0.08, 0.3, 0.05), zap, [0.05, 0.02, 0], [0, 0, -0.5]))
  bolt.add(detail(cone(0.07, 0.25, 4), zap, [0, -0.22, 0], [Math.PI, 0, 0.4]))
  rig.body.add(bolt)
  rig.flickers.push(bolt)
  // His own little storm cloud above the head, with sparks.
  const storm = new THREE.Group()
  storm.position.y = 2.75
  for (let i = 0; i < 5; i++) storm.add(part(sphere(0.2 + (i % 2) * 0.06, 12), toon(c.cloud), [(i - 2) * 0.2, Math.abs(i - 2) * -0.04, (i % 2) * 0.08]))
  const spark = detail(box(0.04, 0.25, 0.04), zap, [0.1, -0.3, 0.05], [0, 0, 0.4])
  storm.add(spark)
  rig.flickers.push(spark)
  rig.root.add(storm)
  move(rig, storm, 'bob', 0.08, 1.8)
  ring(rig, 8, 0.9, 1.1, (i) => detail(new THREE.OctahedronGeometry(0.05), glowing(i % 2 ? c.bolt : '#ffffff', 1), [0, Math.sin(i * 2.1) * 0.35, 0]), 1.6)
  if (skin !== 'default') addLegendaryGlow(rig, c.bolt)
  return rig
}

export const HERO_BUILDERS = { marina, drako, spectra, mecha, zeus }
