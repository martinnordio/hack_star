import { describe, expect, it } from 'vitest'
import {
  PROGRESS_KEY,
  defaultProgress,
  loadProgress,
  memoryStorage,
  parseProgress,
  saveProgress,
  startProgress,
  totalTrophies,
} from './progress'

describe('progress', () => {
  it('starts with the sample progress when nothing is saved', () => {
    const p = loadProgress(memoryStorage())
    expect(p).toEqual(defaultProgress())
    expect(p.unlockedFighters).toEqual(['blaze', 'rocko', 'turbo'])
    expect(p.trophies.blaze).toBeGreaterThanOrEqual(1000)
    expect(totalTrophies(p)).toBe(1745)
  })

  it('round-trips through storage', () => {
    const storage = memoryStorage()
    const saved = {
      ...defaultProgress(),
      trophies: { blaze: 1020 },
      activeHacks: ['power22'],
      selectedSkins: { blaze: 'phoenix' },
    }
    saveProgress(storage, saved)
    expect(loadProgress(storage)).toEqual(saved)
  })

  it.each([
    'not json',
    '{"version": 99}',
    '{"version":1,"trophies":{},"unlockedFighters":[],"activeHacks":[],"selectedFighter":null}',
    '{"version":2,"credits":-1}',
    'null',
  ])(
    'falls back to a fresh start for broken data %s',
    (raw) => {
      const storage = memoryStorage()
      storage.setItem(PROGRESS_KEY, raw)
      expect(loadProgress(storage)).toEqual(defaultProgress())
    },
  )

  it('migrates version 3: everything kept, no created fighter', () => {
    const { createdFighter: _, ...rest } = { ...defaultProgress(), credits: 42 }
    const p = parseProgress({ ...rest, version: 3 })
    expect(p).toEqual({ ...defaultProgress(), credits: 42, createdFighter: null })
  })

  it('a new account starts with 500 credits, 0 trophies and the start fighters', () => {
    const p = startProgress()
    expect(p.credits).toBe(500)
    expect(totalTrophies(p)).toBe(0)
    expect(p.unlockedFighters).toContain('blaze')
    expect(p.createdFighter).toBeNull()
  })

  it('refuses a created fighter with a bad look', () => {
    const look = { name: 'Zap', type: 'tank', main: '#ff0000', second: '#00ff00', head: 1, body: 2 }
    expect(parseProgress({ ...defaultProgress(), createdFighter: look })?.createdFighter).toEqual(look)
    expect(parseProgress({ ...defaultProgress(), createdFighter: { ...look, main: 'red' } })).toBeNull()
    expect(parseProgress({ ...defaultProgress(), createdFighter: { ...look, head: 3 } })).toBeNull()
  })
})
