/** Ground-plane shapes: x is left/right, z is towards the camera. */
export interface Rect {
  x: number
  z: number
  w: number
  d: number
}

export interface Circle {
  x: number
  z: number
  r: number
}

export type Decoration = { kind: 'crate' | 'skull' | 'rock' | 'barrel'; x: number; z: number; turn: number }

export interface Arena {
  width: number
  depth: number
  walls: Rect[]
  bushes: Circle[]
  decorations: Decoration[]
  dummies: { x: number; z: number }[]
  /** Training start point. */
  start: { x: number; z: number }
  /** Match start points: the player first, then the bots, farthest first. */
  spawns: { x: number; z: number }[]
}

/** The sunny canyon (graphics demo spec S11). */
export const CANYON: Arena = {
  width: 30,
  depth: 24,
  walls: [
    { x: -6, z: -2, w: 5, d: 1.6 },
    { x: 6, z: -2, w: 5, d: 1.6 },
    { x: 0, z: -7.5, w: 1.6, d: 4 },
    { x: -11, z: 5, w: 1.6, d: 5 },
    { x: 11, z: 5, w: 1.6, d: 5 },
    { x: -3, z: 6.5, w: 3, d: 1.4 },
  ],
  bushes: [
    { x: -9, z: -7, r: 1.8 },
    { x: 9, z: -7, r: 1.8 },
    { x: 4, z: 6, r: 1.6 },
    { x: -12, z: -1, r: 1.4 },
    { x: 12, z: -1, r: 1.4 },
  ],
  decorations: [
    { kind: 'crate', x: -2.5, z: 2.5, turn: 0.3 },
    { kind: 'barrel', x: 2.8, z: 2.2, turn: 0 },
    { kind: 'skull', x: 7, z: 9, turn: 0.6 },
    { kind: 'rock', x: -7, z: 9.5, turn: 1.2 },
    { kind: 'rock', x: 13, z: -10, turn: 2 },
    { kind: 'skull', x: -13, z: -10, turn: -0.4 },
    { kind: 'crate', x: 8.5, z: 1.5, turn: -0.2 },
  ],
  dummies: [
    { x: -6, z: -6 },
    { x: 0, z: -3 },
    { x: 6, z: -6 },
  ],
  start: { x: 0, z: 8 },
  spawns: [
    { x: 0, z: 9 },
    { x: 0, z: -10 },
    { x: -12, z: -9 },
    { x: 12, z: -9 },
    { x: -13, z: 8 },
    { x: 13, z: 8 },
    { x: -8, z: 2 },
    { x: 8, z: -4.5 },
    { x: 6, z: 9.5 },
  ],
}
