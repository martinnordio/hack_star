import { get } from 'svelte/store'
import { describe, expect, it } from 'vitest'
import {
  PROGRESS_KEY,
  createProgressStore,
  defaultProgress,
  loadProgress,
  memoryStorage,
  saveProgress,
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

  it('saves every change made through the store', () => {
    const storage = memoryStorage()
    const store = createProgressStore(storage)
    store.update((p) => ({ ...p, selectedFighter: 'rocko' }))
    expect(loadProgress(storage).selectedFighter).toBe('rocko')
    expect(get(createProgressStore(storage)).selectedFighter).toBe('rocko')
  })
})
