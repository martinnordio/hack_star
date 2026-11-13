import * as THREE from 'three'
import { buildCreated } from './custom3d'
import {
  addEyes,
  addLegendaryGlow,
  box,
  capsule,
  cone,
  cylinder,
  human,
  newRig,
  OUTLINE,
  part,
  sphere,
  toon,
  type Rig,
} from './parts'

type Builder = (skinId: string) => Rig

function blaze(skin: string): Rig {
  const rig = newRig()
  const look = {
    default: { top: '#e8322b', legs: '#3b2a5c', hair: '#ff7a1a', tip: '#ffd23f', skin: '#ffd2a8' },
    lava: { top: '#3a2626', legs: '#1f1414', hair: '#ff4500', tip: '#ffb000', skin: '#c98a6a' },
    phoenix: { top: '#ffb300', legs: '#b3261e', hair: '#ff3d00', tip: '#fff3a0', skin: '#ffd9b5' },
  }[skin] ?? { top: '#e8322b', legs: '#3b2a5c', hair: '#ff7a1a', tip: '#ffd23f', skin: '#ffd2a8' }

  human(rig, { skin: look.skin, top: look.top, legs: look.legs, shoes: '#2a1d1d', topGlow: skin === 'lava' ? '#ff3300' : undefined })

  // Flame hair: a crown of big cones on top, leaning back.
  const flame = toon(look.hair, look.hair, 0.6)
  const tip = toon(look.tip, look.tip, 0.9)
  for (let i = 0; i < 7; i++) {
    const a = -1.3 + (i / 6) * 2.6
    const f = part(cone(0.2, 0.75), flame, [Math.sin(a) * 0.36, 2.08, -0.05 - Math.cos(a) * 0.18], {
      rotation: [-0.35, 0, -a * 0.55],
    })
    rig.head.add(f)
    rig.flickers.push(f)
  }
  rig.head.add(part(cone(0.18, 0.6), tip, [0, 2.45, -0.1], { rotation: [-0.3, 0, 0] }))
  rig.head.add(part(sphere(0.52), flame, [0, 1.78, -0.08], { scale: [1.02, 0.85, 1] }))

  // Fireball in the right hand.
  const ball = part(sphere(0.2), toon('#ffcf33', '#ff7a00', 1.2), [0.62, 0.78, 0.25], { outline: false })
  rig.body.add(ball)
  rig.flickers.push(ball)

  if (skin === 'phoenix') {
    const wing = toon('#ff6a00', '#ff3d00', 0.7)
    for (const side of [-1, 1]) {
      rig.body.add(part(cone(0.35, 1.3, 4), wing, [side * 0.65, 1.15, -0.35], { rotation: [0.3, 0, side * 1.2], scale: [1, 1, 0.3] }))
    }
    addLegendaryGlow(rig, '#ff9a1a')
  }
  return rig
}

function rocko(skin: string): Rig {
  const rig = newRig()
  const crystal = skin === 'crystal'
  const rock = crystal ? toon('#7fd6ff', '#2a8cff', 0.45) : toon('#8d7f73')
  const dark = crystal ? toon('#4aa8ff', '#1f5fff', 0.5) : toon('#5f544b')
  const moss = crystal ? toon('#e0f7ff', '#bff0ff', 0.6) : toon('#5fae3c')

  for (const side of [-1, 1]) {
    rig.root.add(part(new THREE.DodecahedronGeometry(0.26), dark, [side * 0.3, 0.25, 0]))
    rig.body.add(part(new THREE.DodecahedronGeometry(0.3), rock, [side * 0.78, 0.95, 0.05], { rotation: [0.4, side, 0] }))
    rig.body.add(part(new THREE.DodecahedronGeometry(0.24), dark, [side * 0.85, 0.55, 0.2]))
  }
  rig.body.add(part(new THREE.DodecahedronGeometry(0.62), rock, [0, 1.0, 0], { scale: [1.1, 1, 0.9] }))
  rig.body.add(part(sphere(0.2, 10), moss, [0.25, 1.5, 0.2], { scale: [1.4, 0.5, 1] }))
  rig.head.add(part(new THREE.DodecahedronGeometry(0.38), rock, [0, 1.75, 0.05]))
  addEyes(rig.head, 1.72, 0.4, crystal ? '#0b2a66' : '#ffd23f', 0.36)
  if (crystal) {
    for (const [x, y, z, r] of [[-0.3, 1.55, -0.3, 0.4], [0.35, 1.45, -0.25, -0.5], [0, 2.1, -0.1, 0]] as const) {
      rig.body.add(part(new THREE.OctahedronGeometry(0.22), moss, [x, y, z], { rotation: [0, 0, r], scale: [0.6, 1.4, 0.6] }))
    }
  }
  return rig
}

function turbo(skin: string): Rig {
  const rig = newRig()
  const neon = skin === 'neon'
  human(rig, {
    skin: '#e9b48a',
    top: neon ? '#141428' : '#2f7bff',
    legs: neon ? '#0d0d1a' : '#283048',
    shoes: neon ? '#39ff88' : '#ffffff',
    topGlow: neon ? '#3a0a5a' : undefined,
  })
  const helmet = toon(neon ? '#ff2bd6' : '#ffd23f', neon ? '#ff2bd6' : undefined, 0.5)
  const visor = toon(neon ? '#39ff88' : '#1b1446', neon ? '#39ff88' : '#2244aa', neon ? 1 : 0.3)
  rig.head.add(part(new THREE.SphereGeometry(0.55, 20, 14, 0, Math.PI * 2, 0, Math.PI * 0.55), helmet, [0, 1.68, 0]))
  rig.head.add(part(box(0.7, 0.18, 0.12), visor, [0, 1.9, 0.42], { rotation: [-0.35, 0, 0] }))
  // Racing stripe and scarf.
  rig.head.add(part(box(0.12, 0.05, 1.0), toon(neon ? '#39ff88' : '#e8322b'), [0, 2.2, 0], { rotation: [0.2, 0, 0], outline: false }))
  const scarf = toon(neon ? '#39ff88' : '#e8322b', neon ? '#39ff88' : undefined, 0.8)
  rig.body.add(part(new THREE.TorusGeometry(0.3, 0.09, 8, 20), scarf, [0, 1.2, 0], { rotation: [Math.PI / 2, 0, 0] }))
  const tail = part(box(0.16, 0.5, 0.06), scarf, [0.15, 1.05, -0.38], { rotation: [0.5, 0, 0.3] })
  rig.body.add(tail)
  rig.flickers.push(tail)
  return rig
}

function frosty(skin: string): Rig {
  const rig = newRig()
  const king = skin === 'snow_king'
  const fur = toon(king ? '#f4f8ff' : '#ffffff', king ? '#9fd8ff' : undefined, 0.2)
  const face = toon('#8fd3ff')
  const horn = toon('#bfe9ff', '#7fd0ff', 0.5)
  for (const side of [-1, 1]) {
    rig.root.add(part(sphere(0.24, 12), fur, [side * 0.3, 0.2, 0.05], { scale: [1, 0.8, 1.2] }))
    rig.body.add(part(capsule(0.17, 0.45), fur, [side * 0.7, 0.85, 0.05], { rotation: [0, 0, side * 0.3] }))
    rig.head.add(part(cone(0.1, 0.38), horn, [side * 0.42, 2.0, 0], { rotation: [0, 0, -side * 0.6] }))
  }
  rig.body.add(part(sphere(0.72), fur, [0, 0.95, 0], { scale: [1, 0.95, 0.9] }))
  rig.head.add(part(sphere(0.52), fur, [0, 1.72, 0]))
  rig.head.add(part(sphere(0.4), face, [0, 1.66, 0.22], { scale: [1, 0.85, 0.75], outline: false }))
  addEyes(rig.head, 1.72, 0.55)
  rig.head.add(part(sphere(0.08, 10), toon('#3a5a9a'), [0, 1.58, 0.53], { outline: false }))
  if (king) {
    const gold = toon('#ffd23f', '#ffb000', 0.5)
    rig.head.add(part(cylinder(0.32, 0.28, 0.18), gold, [0, 2.22, 0]))
    for (let i = 0; i < 5; i++) {
      const a = (i / 5) * Math.PI * 2
      rig.head.add(part(cone(0.07, 0.2, 4), gold, [Math.sin(a) * 0.28, 2.38, Math.cos(a) * 0.28]))
    }
    rig.head.add(part(new THREE.OctahedronGeometry(0.07), toon('#7fd6ff', '#2a8cff', 1), [0, 2.24, 0.33], { outline: false }))
    rig.body.add(part(new THREE.CylinderGeometry(0.55, 0.85, 1.1, 18, 1, true, Math.PI * 0.6, Math.PI * 0.8), toon('#2a4bd6'), [0, 0.9, -0.15]))
    addLegendaryGlow(rig, '#9fd8ff')
  }
  return rig
}

function luna(skin: string): Rig {
  const rig = newRig()
  const look = {
    default: { suit: '#7b4dff', fur: '#5a5a6e', accent: '#ffd23f', glow: undefined as string | undefined },
    galaxy: { suit: '#141a4a', fur: '#26205a', accent: '#7ff0ff', glow: '#3a2aff' },
    supernova: { suit: '#fff3c4', fur: '#ffd8a0', accent: '#ff7a1a', glow: '#ffb000' },
  }[skin] ?? { suit: '#7b4dff', fur: '#5a5a6e', accent: '#ffd23f', glow: undefined }

  human(rig, { skin: look.fur, top: look.suit, legs: look.suit, shoes: look.accent, topGlow: look.glow })
  const fur = toon(look.fur)
  const inner = toon('#ff9ac8')
  for (const side of [-1, 1]) {
    rig.head.add(part(cone(0.18, 0.38, 4), fur, [side * 0.3, 2.12, 0], { rotation: [0, Math.PI / 4, side * -0.3] }))
    rig.head.add(part(cone(0.1, 0.22, 4), inner, [side * 0.3, 2.1, 0.07], { rotation: [0, Math.PI / 4, side * -0.3], outline: false }))
    rig.head.add(part(box(0.25, 0.02, 0.02), toon('#ffffff'), [side * 0.42, 1.55, 0.4], { rotation: [0, 0, side * 0.15], outline: false }))
  }
  rig.head.add(part(sphere(0.06, 8), inner, [0, 1.6, 0.5], { outline: false }))
  // Curly tail.
  rig.body.add(part(new THREE.TorusGeometry(0.28, 0.07, 8, 20, Math.PI * 1.4), fur, [0, 0.7, -0.45], { rotation: [0, Math.PI / 2, 0.5] }))
  // Ray gun.
  const metal = toon('#c9d1e0')
  const beam = toon(look.accent, look.accent, 1.2)
  rig.body.add(part(cylinder(0.07, 0.09, 0.45), metal, [0.62, 0.72, 0.3], { rotation: [Math.PI / 2, 0, 0] }))
  const muzzle = part(sphere(0.1, 10), beam, [0.62, 0.72, 0.55], { outline: false })
  rig.body.add(muzzle)
  rig.flickers.push(muzzle)
  // Space helmet bubble.
  rig.head.add(
    new THREE.Mesh(
      sphere(0.68, 24),
      new THREE.MeshPhysicalMaterial({ color: '#bfe9ff', transparent: true, opacity: 0.18, roughness: 0, depthWrite: false }),
    ).translateY(1.68),
  )
  if (skin === 'galaxy') {
    const star = new THREE.MeshBasicMaterial({ color: '#ffffff' })
    for (let i = 0; i < 14; i++) {
      const s = new THREE.Mesh(new THREE.OctahedronGeometry(0.025), star)
      const a = i * 2.4
      s.position.set(Math.cos(a) * 0.38, 0.65 + (i % 5) * 0.12, Math.sin(a) * 0.38)
      rig.body.add(s)
    }
  }
  if (skin === 'supernova') addLegendaryGlow(rig, '#ffcf33')
  return rig
}

function pixel(skin: string): Rig {
  const rig = newRig()
  const glitch = skin === 'glitch'
  const shell = toon(glitch ? '#2a0f3a' : '#e8edf5', glitch ? '#ff2bd6' : undefined, 0.25)
  const trim = toon(glitch ? '#00e5ff' : '#2f7bff', glitch ? '#00e5ff' : undefined, 0.6)
  const screen = toon('#0b0d1a')
  const pixelOn = toon(glitch ? '#ff2bd6' : '#39ff88', glitch ? '#ff2bd6' : '#39ff88', 1.2)

  for (const side of [-1, 1]) {
    rig.root.add(part(box(0.22, 0.45, 0.28), trim, [side * 0.2, 0.23, 0]))
    rig.body.add(part(cylinder(0.08, 0.08, 0.45), shell, [side * 0.55, 0.9, 0], { rotation: [0, 0, side * 0.5] }))
    rig.body.add(part(box(0.2, 0.2, 0.2), trim, [side * 0.68, 0.68, 0.05]))
  }
  rig.body.add(part(box(0.8, 0.7, 0.55), shell, [0, 0.85, 0]))
  rig.body.add(part(box(0.3, 0.2, 0.05), trim, [0, 0.9, 0.29], { outline: false }))
  rig.head.add(part(box(1.0, 0.75, 0.75), shell, [0, 1.65, 0]))
  rig.head.add(part(box(0.82, 0.55, 0.05), screen, [0, 1.65, 0.38], { outline: false }))
  // Pixel eyes and smile on the screen.
  const face = new THREE.Group()
  for (const [x, y] of [[-0.2, 1.75], [0.2, 1.75], [-0.18, 1.5], [-0.06, 1.46], [0.06, 1.46], [0.18, 1.5]] as const) {
    face.add(part(box(0.1, 0.1, 0.03), pixelOn, [x, y, 0.42], { outline: false }))
  }
  rig.head.add(face)
  rig.flickers.push(face)
  rig.head.add(part(cylinder(0.03, 0.03, 0.35), trim, [0, 2.17, 0]))
  const bulb = part(sphere(0.09, 10), pixelOn, [0, 2.38, 0])
  rig.head.add(bulb)
  rig.flickers.push(bulb)
  if (glitch) {
    // Offset "glitch" copies of the head, flickering.
    for (const [dx, color] of [[-0.06, '#00e5ff'], [0.06, '#ff2bd6']] as const) {
      const ghost = new THREE.Mesh(
        box(1.0, 0.75, 0.75),
        new THREE.MeshBasicMaterial({ color, transparent: true, opacity: 0.25, blending: THREE.AdditiveBlending, depthWrite: false }),
      )
      ghost.position.set(dx, 1.65, 0)
      rig.head.add(ghost)
      rig.flickers.push(ghost)
    }
    addLegendaryGlow(rig, '#ff2bd6')
  }
  return rig
}

function coco(skin: string): Rig {
  const rig = newRig()
  const pirate = skin === 'pirate'
  const fur = toon('#8a5a34')
  const face = toon('#f0c99a')
  human(rig, { skin: '#8a5a34', top: pirate ? '#f4f0e6' : '#8a5a34', legs: pirate ? '#2a2f6b' : '#6e4426', shoes: '#4a2f1a' })
  // Light face and muzzle on the round monkey head.
  rig.head.add(part(sphere(0.32), face, [0, 1.48, 0.3], { scale: [1.15, 0.7, 0.7], outline: false }))
  rig.head.add(part(sphere(0.18, 12), face, [0, 1.42, 0.48], { scale: [1.3, 0.75, 0.8] }))
  for (const side of [-1, 1]) {
    rig.head.add(part(sphere(0.2, 12), fur, [side * 0.55, 1.72, 0], { scale: [0.6, 1, 1] }))
    rig.head.add(part(sphere(0.12, 10), face, [side * 0.6, 1.72, 0.04], { scale: [0.5, 1, 1], outline: false }))
  }
  // Curly tail and a coconut ready to throw.
  rig.body.add(part(new THREE.TorusGeometry(0.3, 0.07, 8, 20, Math.PI * 1.5), fur, [0, 0.55, -0.45], { rotation: [0, Math.PI / 2, 0.8] }))
  rig.body.add(part(sphere(0.2, 12), toon('#6b4423'), [0.62, 0.82, 0.25]))
  if (pirate) {
    rig.head.add(part(new THREE.SphereGeometry(0.53, 20, 10, 0, Math.PI * 2, 0, Math.PI * 0.45), toon('#d62828'), [0, 1.68, 0]))
    rig.head.add(part(cone(0.1, 0.35), toon('#d62828'), [-0.15, 1.95, -0.48], { rotation: [-1.2, 0, 0.3] }))
    rig.head.add(part(cylinder(0.11, 0.11, 0.04), toon('#111111'), [-0.17, 1.7, 0.46], { rotation: [Math.PI / 2, 0, 0], outline: false }))
    rig.head.add(part(new THREE.TorusGeometry(0.06, 0.02, 6, 12), toon('#ffd23f', '#ffb000', 0.5), [0.6, 1.55, 0.05], { outline: false }))
    rig.body.add(part(box(0.75, 0.08, 0.6), toon('#2a2f6b'), [0, 0.7, 0], { outline: false }))
  }
  return rig
}

function sparky(skin: string): Rig {
  const rig = newRig()
  const gold = skin === 'gold'
  const shell = gold ? toon('#ffcf33', '#ffb000', 0.35) : toon('#5f6b7a')
  const trim = gold ? toon('#fff3a0', '#ffd23f', 0.5) : toon('#2f7bff')
  const bolt = toon('#7ff0ff', '#00e5ff', 1.2)
  // A dog on four short legs, body along z.
  for (const [x, z] of [[-0.3, 0.35], [0.3, 0.35], [-0.3, -0.35], [0.3, -0.35]] as const) {
    rig.root.add(part(cylinder(0.11, 0.09, 0.45), trim, [x, 0.22, z]))
  }
  rig.body.add(part(box(0.8, 0.55, 1.15), shell, [0, 0.7, 0]))
  rig.body.add(part(box(0.5, 0.06, 0.8), trim, [0, 1.0, 0], { outline: false }))
  const zap = part(new THREE.OctahedronGeometry(0.16), bolt, [0, 1.12, -0.1], { scale: [0.6, 1.4, 0.6], outline: false })
  rig.body.add(zap)
  rig.flickers.push(zap)
  const tail = part(cylinder(0.05, 0.05, 0.45), trim, [0, 0.95, -0.7], { rotation: [-0.8, 0, 0] })
  rig.body.add(tail)
  rig.flickers.push(tail)
  rig.head.add(part(box(0.75, 0.6, 0.65), shell, [0, 1.35, 0.5]))
  rig.head.add(part(box(0.4, 0.28, 0.3), trim, [0, 1.22, 0.9]))
  rig.head.add(part(sphere(0.07, 8), toon('#160f33'), [0, 1.3, 1.05], { outline: false }))
  for (const side of [-1, 1]) {
    rig.head.add(part(cone(0.13, 0.35, 4), shell, [side * 0.25, 1.78, 0.4], { rotation: [0, Math.PI / 4, side * -0.25] }))
  }
  addEyes(rig.head, 1.42, 0.45, gold ? '#7a3a00' : '#00e5ff', 0.4)
  // Move the eyes onto the front of the long robot head.
  for (const child of rig.head.children.slice(-4)) child.position.z += 0.42
  return rig
}

function clank(skin: string): Rig {
  const rig = newRig()
  const dragon = skin === 'dragon'
  const armour = dragon ? toon('#2f5d3a', '#1a7a3a', 0.3) : toon('#c9d1e0')
  const dark = dragon ? toon('#1b2a20') : toon('#7a8494')
  const plume = dragon ? toon('#ff3d00', '#ff3d00', 0.8) : toon('#e8322b')
  human(rig, { skin: '#ffd2a8', top: dragon ? '#2f5d3a' : '#c9d1e0', legs: dragon ? '#1b2a20' : '#7a8494', shoes: '#3a3a44' })
  // Bucket helmet with a visor slit, over the head.
  rig.head.add(part(cylinder(0.56, 0.6, 0.85), armour, [0, 1.68, 0]))
  rig.head.add(part(box(0.7, 0.08, 0.1), toon('#160f33'), [0, 1.72, 0.55], { outline: false }))
  rig.head.add(part(cone(0.12, 0.5), plume, [0, 2.3, -0.1], { rotation: [-0.4, 0, 0] }))
  // Shoulder plates, round shield and a short sword.
  for (const side of [-1, 1]) rig.body.add(part(sphere(0.22, 12), armour, [side * 0.5, 1.15, 0], { scale: [1, 0.6, 1] }))
  rig.body.add(part(cylinder(0.42, 0.42, 0.1), dark, [-0.66, 0.85, 0.2], { rotation: [0, 0, Math.PI / 2] }))
  rig.body.add(part(cylinder(0.2, 0.2, 0.12), armour, [-0.73, 0.85, 0.2], { rotation: [0, 0, Math.PI / 2], outline: false }))
  rig.body.add(part(box(0.08, 0.7, 0.05), toon('#e8edf5'), [0.6, 1.05, 0.3]))
  rig.body.add(part(box(0.3, 0.06, 0.08), dark, [0.6, 0.72, 0.3]))
  if (dragon) {
    const horn = toon('#f4ead2')
    for (const side of [-1, 1]) {
      rig.head.add(part(cone(0.09, 0.45), horn, [side * 0.42, 2.15, -0.05], { rotation: [-0.3, 0, -side * 0.5] }))
      rig.body.add(part(cone(0.35, 1.2, 4), toon('#1a7a3a', '#1a7a3a', 0.4), [side * 0.6, 1.2, -0.4], { rotation: [0.3, 0, side * 1.2], scale: [1, 1, 0.3] }))
    }
    addLegendaryGlow(rig, '#39ff88')
  }
  return rig
}

function kira(skin: string): Rig {
  const rig = newRig()
  const sakura = skin === 'sakura'
  const suit = sakura ? '#ff8ac2' : '#3a2a6b'
  const band = toon(sakura ? '#ffffff' : '#e8322b')
  human(rig, { skin: '#ffd9b5', top: suit, legs: sakura ? '#c2185b' : '#241a46', shoes: '#160f33' })
  // Hair bun, mask over the mouth and a headband with flying tails.
  const hair = toon(sakura ? '#5a2a3a' : '#160f33')
  rig.head.add(part(sphere(0.53), hair, [0, 1.76, -0.12], { scale: [1.04, 0.95, 0.85] }))
  rig.head.add(part(sphere(0.2, 12), hair, [0, 2.2, -0.2]))
  rig.head.add(part(sphere(0.42), toon(suit), [0, 1.45, 0.16], { scale: [1, 0.45, 0.85], outline: false }))
  rig.head.add(part(new THREE.TorusGeometry(0.52, 0.05, 6, 24), band, [0, 1.86, 0], { rotation: [Math.PI / 2, 0, 0], outline: false }))
  for (const side of [-1, 1]) {
    const tail = part(box(0.08, 0.4, 0.03), band, [side * 0.12, 1.75, -0.55], { rotation: [0.8, 0, side * 0.4], outline: false })
    rig.head.add(tail)
    rig.flickers.push(tail)
  }
  // Bow in the left hand, quiver on the back.
  rig.body.add(part(new THREE.TorusGeometry(0.5, 0.04, 6, 20, Math.PI), toon('#8a5a34'), [-0.62, 0.9, 0.2], { rotation: [0, Math.PI / 2, Math.PI / 2] }))
  rig.body.add(part(cylinder(0.12, 0.1, 0.6), toon('#6b4423'), [0.2, 1.05, -0.38], { rotation: [0.3, 0, -0.3] }))
  if (sakura) {
    const petal = toon('#ffc4e1', '#ff8ac2', 0.6)
    for (let i = 0; i < 8; i++) {
      const a = (i / 8) * Math.PI * 2
      const p = part(sphere(0.06, 6), petal, [Math.cos(a) * 0.9, 1 + (i % 3) * 0.35, Math.sin(a) * 0.9], { scale: [1, 0.3, 1], outline: false })
      rig.root.add(p)
      rig.flickers.push(p)
    }
    addLegendaryGlow(rig, '#ff8ac2')
  }
  return rig
}

const BUILDERS: Record<string, Builder> = { blaze, rocko, turbo, frosty, luna, pixel, coco, sparky, clank, kira, custom: buildCreated }

export function buildFighter(fighterId: string, skinId = 'default'): Rig {
  return (BUILDERS[fighterId] ?? blaze)(skinId)
}

/** Idle animation: breathing, gentle sway, flickering flames and spinning sparkles. */
export function animateFighter(rig: Rig, time: number) {
  rig.body.position.y = Math.sin(time * 2.2) * 0.04
  rig.head.rotation.z = Math.sin(time * 1.3) * 0.05
  rig.head.position.y = Math.sin(time * 2.2 + 0.6) * 0.02
  rig.flickers.forEach((o, i) => {
    const s = 1 + Math.sin(time * 9 + i * 1.7) * 0.07
    o.scale.setScalar(s)
  })
  rig.spinners.forEach((o) => (o.rotation.y = time * 0.8))
}

export function disposeRig(rig: Rig) {
  rig.root.traverse((o) => {
    if (o instanceof THREE.Mesh) o.geometry.dispose()
  })
}

/** See-through fighter (hiding in a bush): fade its own materials and hide the shared outlines. */
export function setRigOpacity(rig: Rig, opacity: number) {
  rig.root.traverse((o) => {
    if (!(o instanceof THREE.Mesh)) return
    if (o.material === OUTLINE) {
      o.visible = opacity >= 1
      return
    }
    const material = o.material as THREE.Material
    if (material.userData.baseOpacity === undefined) {
      material.userData.baseOpacity = material.opacity
      material.userData.baseTransparent = material.transparent
    }
    material.transparent = opacity < 1 || material.userData.baseTransparent
    material.opacity = material.userData.baseOpacity * opacity
    material.needsUpdate = true
  })
}
