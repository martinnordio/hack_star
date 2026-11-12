import { get } from 'svelte/store'
import { describe, expect, it } from 'vitest'
import {
  PROGRESS_KEY,
  createProgressStore,
  defaultProgress,
  loadProgress,
  memoryStorage,
  saveProgress,
} from './progress'

describe('progress', () => {
  it('starts fresh when nothing is saved', () => {
    expect(loadProgress(memoryStorage())).toEqual(defaultProgress())
  })

  it('round-trips through storage', () => {
    const storage = memoryStorage()
    const saved = { ...defaultProgress(), trophies: { blaze: 1020 }, activeHacks: ['power22'] }
    saveProgress(storage, saved)
    expect(loadProgress(storage)).toEqual(saved)
  })

  it.each(['not json', '{"version": 99}', '{"version":1,"trophies":{"a":-5}}', 'null'])(
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
    store.update((p) => ({ ...p, selectedFighter: 'blaze' }))
    expect(loadProgress(storage).selectedFighter).toBe('blaze')
    expect(get(createProgressStore(storage)).selectedFighter).toBe('blaze')
  })
})
