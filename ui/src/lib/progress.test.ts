import { describe, expect, it } from 'vitest'
import {
  PROGRESS_KEY,
  TEMPORARY_HACK_SECONDS,
  defaultProgress,
  loadProgress,
  memoryStorage,
  parseProgress,
  resetProgress,
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
    const { createdFighters: _createdFighters, hackExpiries: _hackExpiries, ...rest } = {
      ...defaultProgress(),
      credits: 42,
    }
    const p = parseProgress({ ...rest, version: 3 })
    expect(p).toEqual({ ...defaultProgress(), credits: 42 })
  })

  it('migrates version 4 active hacks to 3-day expiries, except permanent POWER22', () => {
    const { hackExpiries: _hackExpiries, createdFighters: _createdFighters, ...progress } = defaultProgress()
    const legacy = { ...progress, version: 4, activeHacks: ['infinite_credits', 'power22'], createdFighter: null }
    const migrated = parseProgress(legacy, 1000)
    expect(migrated?.version).toBe(6)
    expect(migrated?.hackExpiries).toEqual({
      infinite_credits: 1000 + TEMPORARY_HACK_SECONDS * 1000,
      power22: null,
    })
    expect(migrated?.credits).toBe(progress.credits)
  })

  it('migrates version 5 created fighter to the collection without losing fighter progress', () => {
    const look = { name: 'Zap', type: 'tank' as const, main: '#ff0000', second: '#00ff00', head: 1, body: 2 }
    const { createdFighters: _createdFighters, ...v5Base } = defaultProgress()
    const v5 = {
      ...v5Base,
      version: 5,
      credits: 321,
      activeHacks: ['power22'],
      hackExpiries: { power22: null },
      selectedFighter: 'custom',
      trophies: { custom: 42 },
      powerLevels: { custom: 13 },
      selectedSkins: { custom: 'neon' },
      ownedSkins: { custom: ['neon'] },
      createdFighter: look,
    }
    const migrated = parseProgress(v5, 1000)
    expect(migrated).toMatchObject({
      version: 6,
      credits: 321,
      selectedFighter: 'custom',
      trophies: { custom: 42 },
      powerLevels: { custom: 13 },
      selectedSkins: { custom: 'neon' },
      ownedSkins: { custom: ['neon'] },
      createdFighters: [{ id: 'custom', look }],
    })
    expect(migrated?.hackExpiries).toEqual({ power22: null })
  })

  it('a new account starts with 500 credits, 0 trophies and the start fighters', () => {
    const p = startProgress()
    expect(p.credits).toBe(500)
    expect(totalTrophies(p)).toBe(0)
    expect(p.unlockedFighters).toContain('blaze')
    expect(p.createdFighters).toEqual([])
  })

  it('reset: 0 credits and trophies, start fighters, power 1, default skins; hacks and created fighter kept', () => {
    const look = { name: 'Zap', type: 'tank' as const, main: '#ff0000', second: '#00ff00', head: 1, body: 2 }
    const before = {
      ...defaultProgress(),
      credits: 900,
      trophies: { blaze: 2100, custom: 50 },
      unlockedFighters: ['blaze', 'rocko', 'turbo', 'luna'],
      powerLevels: { blaze: 9 },
      selectedFighter: 'luna',
      selectedSkins: { blaze: 'phoenix' },
      ownedSkins: { blaze: ['phoenix'] },
      activeHacks: ['power22'],
      createdFighters: [{ id: 'custom', look }],
    }
    const p = resetProgress(before)
    expect(p.credits).toBe(0)
    expect(totalTrophies(p)).toBe(0)
    expect(p.unlockedFighters).toEqual(startProgress().unlockedFighters)
    expect(p.powerLevels).toEqual({})
    expect(p.selectedSkins).toEqual({})
    expect(p.ownedSkins).toEqual({})
    expect(p.selectedFighter).toBe('blaze')
    expect(p.activeHacks).toEqual(['power22'])
    expect(p.createdFighters).toEqual([{ id: 'custom', look }])
  })

  it('refuses a created fighter with a bad look', () => {
    const look = { name: 'Zap', type: 'tank', main: '#ff0000', second: '#00ff00', head: 1, body: 2 }
    expect(parseProgress({ ...defaultProgress(), createdFighters: [{ id: 'custom', look }] })?.createdFighters[0].look).toEqual(look)
    expect(parseProgress({ ...defaultProgress(), createdFighters: [{ id: 'custom', look: { ...look, main: 'red' } }] })).toBeNull()
    expect(parseProgress({ ...defaultProgress(), createdFighters: [{ id: 'custom', look: { ...look, head: 3 } }] })).toBeNull()
  })
})
