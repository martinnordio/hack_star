import { describe, expect, it } from 'vitest'
import { prestigeLevel } from './fighters'

describe('prestigeLevel', () => {
  it.each([
    [0, 0],
    [999, 0],
    [1000, 1],
    [1999, 1],
    [2500, 2],
    [-5, 0],
  ])('%i trophies → Prestige %i', (trophies, level) => {
    expect(prestigeLevel(trophies)).toBe(level)
  })
})
