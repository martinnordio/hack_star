export interface Vec2 {
  x: number
  z: number
}

/** Input shared between the HTML layer (keys, pointer, joysticks) and the 3D frame loop. */
export interface Controls {
  keys: Set<string>
  /** Left joystick, length 0..1 (x right, z down the screen). */
  moveStick: Vec2
  /** Right joystick while dragged, length 0..1. */
  aimStick: Vec2 | null
  /** Mouse position in normalized device coordinates (-1..1). */
  pointer: { x: number; y: number } | null
  mouseDown: boolean
  /** One shot in a direction (right joystick released). */
  fireDir: Vec2 | null
  /** One shot at the nearest target (quick tap on the right side). */
  tapFire: boolean
  /** Super towards the mouse or aim stick (E key, right click). */
  superAim: boolean
  /** Super at the nearest target (Super button). */
  superAuto: boolean
}

export function newControls(): Controls {
  return {
    keys: new Set(),
    moveStick: { x: 0, z: 0 },
    aimStick: null,
    pointer: null,
    mouseDown: false,
    fireDir: null,
    tapFire: false,
    superAim: false,
    superAuto: false,
  }
}

const LEFT = ['KeyA', 'ArrowLeft']
const RIGHT = ['KeyD', 'ArrowRight']
const UP = ['KeyW', 'ArrowUp']
const DOWN = ['KeyS', 'ArrowDown']

export function keyboardDirection(keys: Set<string>): Vec2 {
  const pressed = (codes: string[]) => (codes.some((c) => keys.has(c)) ? 1 : 0)
  return { x: pressed(RIGHT) - pressed(LEFT), z: pressed(DOWN) - pressed(UP) }
}

/** Joystick vector from a drag: length capped at 1, small drags (dead zone) are 0. */
export function stickVector(dx: number, dy: number, radius: number, deadZone = 0.15): Vec2 {
  const length = Math.hypot(dx, dy) / radius
  if (length < deadZone) return { x: 0, z: 0 }
  const scale = Math.min(1, length) / length / radius
  return { x: dx * scale, z: dy * scale }
}
