import { describe, expect, it } from 'vitest'
import { keyboardDirection, stickVector } from './controls'

describe('controls', () => {
  it('maps WASD and arrows to directions (z grows towards the camera)', () => {
    expect(keyboardDirection(new Set(['KeyW']))).toEqual({ x: 0, z: -1 })
    expect(keyboardDirection(new Set(['ArrowDown', 'ArrowRight']))).toEqual({ x: 1, z: 1 })
    expect(keyboardDirection(new Set(['KeyA', 'KeyD']))).toEqual({ x: 0, z: 0 })
  })

  it('caps the joystick at length 1 and ignores tiny drags', () => {
    expect(stickVector(5, 0, 60)).toEqual({ x: 0, z: 0 })
    const half = stickVector(30, 0, 60)
    expect(half.x).toBeCloseTo(0.5)
    const far = stickVector(0, 300, 60)
    expect(far.z).toBeCloseTo(1)
  })
})
