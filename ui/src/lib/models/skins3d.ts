import * as THREE from 'three'
import { OUTLINE, addLegendaryGlow, box, capsule, cone, cylinder, part, sphere, toon, type Rig } from './parts'

// The skins added for every fighter (accounts, fighters and languages spec, S14): the
// fighter's default look recoloured, plus one extra part, so each looks clearly different.

type Accessory = 'crown' | 'scarf' | 'halo' | 'horns' | 'backpack' | 'shades' | 'cape'

interface Variant {
  /** Hue, saturation and lightness shift for every colour of the fighter. */
  hsl: [number, number, number]
  accessory: Accessory
  accent: string
  legendary?: boolean
}

const v = (h: number, s: number, l: number, accessory: Accessory, accent: string, legendary = false): Variant => ({
  hsl: [h, s, l],
  accessory,
  accent,
  legendary,
})

export const VARIANTS: Record<string, Record<string, Variant>> = {
  blaze: { frost: v(0.55, 0, 0, 'crown', '#bff4ff'), shadow: v(0, -0.4, -0.25, 'scarf', '#6a4bff'), candy: v(0.85, 0, 0.1, 'halo', '#ff8ac2') },
  rocko: { emerald: v(0.33, 0.4, 0, 'crown', '#39ff88'), magma: v(-0.05, 0.6, 0, 'horns', '#ff5a1a'), snowman: v(0, -1, 0.35, 'scarf', '#e8322b') },
  turbo: { golden: v(0.12, 0.3, 0.05, 'crown', '#ffd23f', true), jungle: v(0.3, 0, -0.05, 'backpack', '#7a5230'), midnight: v(0.65, 0, -0.2, 'shades', '#39d3ff') },
  frosty: { lava_yeti: v(0.5, 0.3, 0, 'horns', '#ff5a1a'), candy_floss: v(0.35, 0, 0.1, 'halo', '#ff8ac2'), abominable: v(0, 0, -0.3, 'shades', '#39d3ff') },
  luna: { solar: v(0.5, 0, 0, 'crown', '#ffb000'), neon_cat: v(0.3, 0.5, 0, 'shades', '#39ff88'), shadow_cat: v(0, 0, -0.3, 'cape', '#6a4bff') },
  pixel: { retro: v(0.1, 0, 0, 'backpack', '#ff8a1a'), gold_bot: v(0.15, 0.3, 0.05, 'crown', '#ffd23f', true), virus: v(0.6, 0.2, 0, 'horns', '#b64dff') },
  coco: { astro: v(0.55, 0, 0, 'backpack', '#e8edf5'), king: v(0.05, 0.2, 0, 'crown', '#ffd23f', true), banana: v(0.15, 0.3, 0.1, 'halo', '#ffe45c') },
  sparky: { ice_dog: v(0.5, 0, 0.05, 'scarf', '#bff4ff'), hot_dog: v(-0.1, 0.2, 0, 'shades', '#ff3b5c'), cyber: v(0.75, 0.4, 0, 'horns', '#ff5fa8') },
  clank: { paladin: v(0, 0, 0.2, 'halo', '#fff3a0'), dark_knight: v(0, 0, -0.35, 'cape', '#b3122e'), royal: v(0.12, 0.3, 0, 'crown', '#ffd23f', true) },
  kira: { storm: v(0.6, 0, 0, 'scarf', '#39d3ff'), samurai: v(-0.05, 0.3, 0, 'horns', '#ffd23f'), ghost: v(0, -0.8, 0.25, 'cape', '#e8edf5') },
  marina: { lava_surf: v(0.5, 0, 0, 'shades', '#ff5a1a'), tropical: v(0.25, 0, 0, 'halo', '#ff8ac2'), mermaid: v(0.4, 0.2, 0, 'crown', '#ffd23f', true) },
  drako: { ice_dragon: v(0.55, 0, 0.05, 'crown', '#bff4ff'), gold_dragon: v(0.12, 0.2, 0.05, 'halo', '#ffd23f', true), shadow_dragon: v(0, -0.3, -0.3, 'cape', '#6a4bff') },
  spectra: { pumpkin: v(0.85, 0.3, 0, 'horns', '#ff8a1a'), snow_ghost: v(0, -0.8, 0.2, 'scarf', '#39d3ff'), rainbow: v(0.33, 0.3, 0, 'halo', '#ff5fa8', true) },
  mecha: { red_mech: v(0.4, 0, 0, 'shades', '#160f33'), camo: v(0.6, -0.4, -0.05, 'backpack', '#5a6b3a'), golden_mech: v(0.45, 0.2, 0.05, 'crown', '#ffd23f', true) },
  zeus: { poseidon: v(0.5, 0, 0, 'crown', '#39d3ff'), hades: v(0, 0, -0.35, 'cape', '#7a2bff'), sun_god: v(0.08, 0.2, 0, 'halo', '#ffb000', true) },
}

export function variantOf(fighterId: string, skinId: string): Variant | undefined {
  return VARIANTS[fighterId]?.[skinId]
}

function recolour(rig: Rig, [h, s, l]: Variant['hsl']) {
  rig.root.traverse((o) => {
    if (!(o instanceof THREE.Mesh) || o.material === OUTLINE) return
    const material = (o.material as THREE.Material).clone() as THREE.MeshStandardMaterial
    material.color?.offsetHSL(h, s, l)
    if (material.emissive && material.emissiveIntensity > 0) material.emissive.offsetHSL(h, s, l)
    o.material = material
  })
}

function addAccessory(rig: Rig, kind: Accessory, color: string) {
  const head = new THREE.Box3().setFromObject(rig.head)
  const top = head.isEmpty() ? 2.2 : head.max.y
  const centre = head.isEmpty() ? 1.65 : (head.min.y + head.max.y) / 2
  const front = head.isEmpty() ? 0.5 : head.max.z
  const half = head.isEmpty() ? 0.5 : Math.min(0.6, (head.max.x - head.min.x) / 2)
  const m = toon(color, color, 0.25)
  if (kind === 'crown') {
    rig.head.add(part(cylinder(0.3, 0.32, 0.16), m, [0, top + 0.02, 0]))
    for (let i = 0; i < 5; i++) {
      const a = (i / 5) * Math.PI * 2
      rig.head.add(part(cone(0.07, 0.2, 4), m, [Math.cos(a) * 0.26, top + 0.18, Math.sin(a) * 0.26]))
    }
  } else if (kind === 'halo') {
    const halo = part(new THREE.TorusGeometry(0.32, 0.04, 8, 28), toon(color, color, 1.1), [0, top + 0.25, 0], { rotation: [Math.PI / 2, 0, 0], outline: false })
    rig.head.add(halo)
    rig.flickers.push(halo)
  } else if (kind === 'horns') {
    for (const side of [-1, 1]) rig.head.add(part(cone(0.09, 0.4), m, [side * half * 0.7, top - 0.02, 0], { rotation: [0, 0, -side * 0.5] }))
  } else if (kind === 'shades') {
    for (const side of [-1, 1]) rig.head.add(part(box(0.24, 0.12, 0.05), toon('#160f33'), [side * 0.17, centre + 0.05, front + 0.02], { outline: false }))
    rig.head.add(part(box(0.5, 0.03, 0.04), toon(color), [0, centre + 0.1, front + 0.02], { outline: false }))
  } else if (kind === 'scarf') {
    rig.body.add(part(new THREE.TorusGeometry(0.33, 0.09, 8, 24), m, [0, 1.2, 0], { rotation: [Math.PI / 2, 0, 0] }))
    const tail = part(capsule(0.08, 0.35), m, [0.2, 0.95, 0.3], { rotation: [0.3, 0, 0.3] })
    rig.body.add(tail)
    rig.flickers.push(tail)
  } else if (kind === 'backpack') {
    rig.body.add(part(box(0.5, 0.55, 0.25), m, [0, 0.95, -0.42]))
    rig.body.add(part(sphere(0.1, 10), toon('#e8edf5'), [0, 1.25, -0.42]))
  } else {
    const cape = part(box(0.85, 1.0, 0.04), m, [0, 0.82, -0.42], { rotation: [0.15, 0, 0] })
    rig.body.add(cape)
    rig.flickers.push(cape)
  }
}

/** Turns a fighter built with its default look into one of the added skins. */
export function applyVariant(rig: Rig, variant: Variant): Rig {
  recolour(rig, variant.hsl)
  addAccessory(rig, variant.accessory, variant.accent)
  if (variant.legendary) addLegendaryGlow(rig, variant.accent)
  return rig
}
