import type { ThemeId } from '../game/worlds'

export type BorderKind = 'rocks' | 'pillars' | 'balls' | 'crystals' | 'clouds' | 'dunes'
export type CapKind = 'flat' | 'spikes' | 'dome'
export type PlantKind = 'cactus' | 'fern' | 'neonPost' | 'crystal' | 'palm' | 'lollipop' | 'grass'

/** The look of a world: colours and simple shapes only (no image or model files). */
export interface Theme {
  /** The two colours of the ground tiles, checkerboard. */
  tiles: [string, string]
  /** Ground around the tiles, up to the border. */
  floor: string
  /** Edge of the arena, outside the walls. */
  border: { kind: BorderKind; colors: string[] }
  wall: { side: string; top: string; cap: CapKind }
  /** Cover: main colour and accent colour of each plant. */
  plant: { kind: PlantKind; colors: [string, string] }
  /** Ground under the plants. */
  patch: string
  props: { crate: string; barrel: string; rock: string }
  /** Skull decorations; without them they are drawn as rocks. */
  skulls: boolean
  /** Makes the plants glow (neon, lava, crystals). */
  glow?: string
  /** Sky gradient (top, bottom), shown in the world gallery. */
  sky: [string, string]
}

/** One look per world. Canyon is today's arena. */
export const THEMES: Record<ThemeId, Theme> = {
  canyon: {
    tiles: ['#f5cf8e', '#ebbd76'],
    floor: '#d9a35f',
    border: { kind: 'rocks', colors: ['#c96a35', '#b35a2c', '#d9824a'] },
    wall: { side: '#b5653a', top: '#e09a5c', cap: 'flat' },
    plant: { kind: 'cactus', colors: ['#4cbf4f', '#3aa34a'] },
    patch: '#7fbf4a',
    props: { crate: '#b07a3c', barrel: '#c0392b', rock: '#a85a30' },
    skulls: true,
    sky: ['#7ec8ff', '#fff1d0'],
  },
  jungle: {
    tiles: ['#9fd47a', '#8cc46a'],
    floor: '#5f7d3c',
    border: { kind: 'pillars', colors: ['#8f9a80', '#7a866c', '#a7b192'] },
    wall: { side: '#7d8a6a', top: '#a9b58a', cap: 'flat' },
    plant: { kind: 'fern', colors: ['#2f9e55', '#1f7a48'] },
    patch: '#4f8f3a',
    props: { crate: '#8a6a3c', barrel: '#6e5a3a', rock: '#7a8068' },
    skulls: false,
    sky: ['#8fd3ff', '#e6f7d0'],
  },
  neon: {
    tiles: ['#2a3550', '#222b44'],
    floor: '#161c2e',
    border: { kind: 'balls', colors: ['#ff4f5e', '#ffffff', '#ffd23f'] },
    wall: { side: '#3a4358', top: '#ff4fd8', cap: 'flat' },
    plant: { kind: 'neonPost', colors: ['#39e6ff', '#ff4fd8'] },
    patch: '#1f2a40',
    props: { crate: '#4a5570', barrel: '#ff9f1c', rock: '#505a70' },
    skulls: false,
    glow: '#39e6ff',
    sky: ['#0b0f24', '#2a1a4a'],
  },
  lava: {
    tiles: ['#4a2a22', '#3a2019'],
    floor: '#2a1510',
    border: { kind: 'rocks', colors: ['#3b2a2a', '#4a3030', '#5a3a33'] },
    wall: { side: '#3b2a2a', top: '#ff6a1a', cap: 'spikes' },
    plant: { kind: 'crystal', colors: ['#ff6a1a', '#ffb000'] },
    patch: '#5a1f12',
    props: { crate: '#6b4a3a', barrel: '#8a2a1a', rock: '#4a3a36' },
    skulls: true,
    glow: '#ff6a1a',
    sky: ['#2a0d08', '#ff7a2a'],
  },
  sky: {
    tiles: ['#ffffff', '#e6f4ff'],
    floor: '#8fd0ff',
    border: { kind: 'clouds', colors: ['#ffffff', '#f1f8ff'] },
    wall: { side: '#f2f6ff', top: '#ffd98a', cap: 'dome' },
    plant: { kind: 'palm', colors: ['#3fbf6a', '#8a5a2b'] },
    patch: '#b6f0a0',
    props: { crate: '#d9b98a', barrel: '#f2a7b8', rock: '#c8d6e6' },
    skulls: false,
    sky: ['#5ab8ff', '#e8f8ff'],
  },
  crystal: {
    tiles: ['#3b3170', '#2e2760'],
    floor: '#221c48',
    border: { kind: 'crystals', colors: ['#8be9ff', '#c58bff', '#6fd3f0'] },
    wall: { side: '#5a3d8a', top: '#c58bff', cap: 'spikes' },
    plant: { kind: 'crystal', colors: ['#8be9ff', '#c58bff'] },
    patch: '#3a2f5c',
    props: { crate: '#7a5cb0', barrel: '#4fa6c9', rock: '#6b5a9a' },
    skulls: false,
    glow: '#8be9ff',
    sky: ['#120c2e', '#5a3d8a'],
  },
  city: {
    tiles: ['#c9ced8', '#b5bcc8'],
    floor: '#6f7a88',
    border: { kind: 'pillars', colors: ['#8e9bb0', '#7b889c', '#a6b0c2'] },
    wall: { side: '#8e9bb0', top: '#d7dee9', cap: 'flat' },
    plant: { kind: 'grass', colors: ['#7fd16a', '#5aa84a'] },
    patch: '#6cb85a',
    props: { crate: '#c49a6c', barrel: '#4d6fa8', rock: '#7b7f88' },
    skulls: false,
    sky: ['#7ab7e8', '#dfeeff'],
  },
  kata: {
    tiles: ['#5f9e4a', '#55903f'],
    floor: '#3f6b33',
    border: { kind: 'balls', colors: ['#2f7a3a', '#3c8f47', '#25633a'] },
    wall: { side: '#2f7a3a', top: '#5ccf6a', cap: 'dome' },
    plant: { kind: 'palm', colors: ['#2fae5b', '#8a5a2b'] },
    patch: '#2f6f3a',
    props: { crate: '#a88a4e', barrel: '#7a5a2e', rock: '#4f6b3f' },
    skulls: false,
    sky: ['#7fd6a0', '#e9fff0'],
  },
  candy: {
    tiles: ['#ffd1ea', '#ffe6f4'],
    floor: '#ffb3d9',
    border: { kind: 'balls', colors: ['#ff8fc7', '#8fe3ff', '#fff3a0'] },
    wall: { side: '#ff8fc7', top: '#fff3a0', cap: 'dome' },
    plant: { kind: 'lollipop', colors: ['#ff4f9a', '#ffe14f'] },
    patch: '#ffe0f0',
    props: { crate: '#ffd27a', barrel: '#8fe3ff', rock: '#e6b8ff' },
    skulls: false,
    sky: ['#ffd6f0', '#e6f7ff'],
  },
  robot: {
    tiles: ['#8a94a6', '#7a8497'],
    floor: '#4f5868',
    border: { kind: 'pillars', colors: ['#55606e', '#6b7686', '#44505e'] },
    wall: { side: '#4a5566', top: '#ffb000', cap: 'spikes' },
    plant: { kind: 'neonPost', colors: ['#ffd23f', '#55606e'] },
    patch: '#3e4755',
    props: { crate: '#c9a14a', barrel: '#d9482b', rock: '#606a7a' },
    skulls: false,
    glow: '#ffd23f',
    sky: ['#2a3140', '#8a94a6'],
  },
  pirate: {
    tiles: ['#f2d9a6', '#e6c88f'],
    floor: '#d9b06a',
    border: { kind: 'rocks', colors: ['#6e6a66', '#55524f', '#837c74'] },
    wall: { side: '#7a5230', top: '#c9a06b', cap: 'flat' },
    plant: { kind: 'palm', colors: ['#3fbf6a', '#8a5a2b'] },
    patch: '#e8c48a',
    props: { crate: '#8a5a2e', barrel: '#6b3b1f', rock: '#6e6a66' },
    skulls: true,
    sky: ['#3aa0e0', '#bfe9ff'],
  },
  moon: {
    tiles: ['#c8ccd6', '#b4b9c6'],
    floor: '#7d8290',
    border: { kind: 'rocks', colors: ['#8c8f99', '#7a7e88', '#9da1ab'] },
    wall: { side: '#8c8f99', top: '#d4d7e0', cap: 'dome' },
    plant: { kind: 'crystal', colors: ['#e8f0ff', '#9ad4ff'] },
    patch: '#4a4f5c',
    props: { crate: '#9aa3b5', barrel: '#4f6d9a', rock: '#7a7e88' },
    skulls: false,
    sky: ['#050714', '#1a2140'],
  },
  oasis: {
    tiles: ['#f0d49a', '#e4c388'],
    floor: '#cfa76a',
    border: { kind: 'dunes', colors: ['#e8c48a', '#d9b07a', '#f0d49a'] },
    wall: { side: '#c79a5a', top: '#e8c48a', cap: 'flat' },
    plant: { kind: 'cactus', colors: ['#6fcf7a', '#4fb35f'] },
    patch: '#d9b36a',
    props: { crate: '#b5813f', barrel: '#8a5a2b', rock: '#c79a5a' },
    skulls: true,
    sky: ['#ffb35a', '#fff1d0'],
  },
}
