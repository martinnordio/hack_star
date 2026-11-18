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
    expect(migrated?.version).toBe(8)
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
      version: 8,
      credits: 321,
      selectedFighter: 'custom',
      trophies: { custom: 42 },
      powerLevels: { custom: 13 },
      selectedSkins: { custom: 'neon' },
      ownedSkins: { custom: ['neon'] },
      createdFighters: [{ id: 'custom', look: { ...look, hands: 0, legs: 0 }, skins: [] }],
    })
    expect(migrated?.hackExpiries).toEqual({ power22: null })
  })

  it('migrates version 6: every look keeps its parts, gets hands and legs 0 and no skins', () => {
    const look = { name: 'Zap', type: 'tank' as const, main: '#ff0000', second: '#00ff00', head: 2, body: 1 }
    const v6 = {
      ...defaultProgress(),
      version: 6,
      trophies: { 'custom-2': 9 },
      createdFighters: [{ id: 'custom', look }, { id: 'custom-2', look: { ...look, name: 'Two' } }],
    }
    const migrated = parseProgress(v6)
    expect(migrated?.version).toBe(8)
    expect(migrated?.trophies).toEqual({ 'custom-2': 9 })
    expect(migrated?.createdFighters).toEqual([
      { id: 'custom', look: { ...look, hands: 0, legs: 0 }, skins: [] },
      { id: 'custom-2', look: { ...look, name: 'Two', hands: 0, legs: 0 }, skins: [] },
    ])
    expect(parseProgress({ ...v6, createdFighters: [{ id: 'custom', look: { ...look, head: 3 } }] })).toBeNull()
  })

  it('a new account starts with 500 credits, 0 trophies and the start fighters', () => {
    const p = startProgress()
    expect(p.credits).toBe(500)
    expect(totalTrophies(p)).toBe(0)
    expect(p.unlockedFighters).toContain('blaze')
    expect(p.createdFighters).toEqual([])
  })

  it('reset: 0 credits and trophies, start fighters, power 1, default skins; hacks and created fighter kept', () => {
    const look = { name: 'Zap', type: 'tank' as const, main: '#ff0000', second: '#00ff00', head: 1, body: 2, hands: 1, legs: 2 }
    const skins = [{ id: 's1', main: '#123456', second: '#654321', head: 4, body: 0, hands: 2, legs: 0 }]
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
      createdFighters: [{ id: 'custom', look, skins }],
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
    expect(p.createdFighters).toEqual([{ id: 'custom', look, skins }])
  })

  it('refuses a created fighter with a bad look or bad skins', () => {
    const look = { name: 'Zap', type: 'tank', main: '#ff0000', second: '#00ff00', head: 4, body: 2, hands: 2, legs: 1 }
    const skin = { id: 's1', main: '#123456', second: '#654321', head: 0, body: 0, hands: 0, legs: 0 }
    const withFighter = (fighter: object) => parseProgress({ ...defaultProgress(), createdFighters: [{ id: 'custom', look, skins: [], ...fighter }] })
    expect(withFighter({})?.createdFighters[0].look).toEqual(look)
    expect(withFighter({ look: { ...look, main: 'red' } })).toBeNull()
    expect(withFighter({ look: { ...look, head: 5 } })).toBeNull()
    expect(withFighter({ look: { ...look, hands: 3 } })).toBeNull()
    expect(withFighter({ skins: [skin] })?.createdFighters[0].skins).toEqual([skin])
    expect(withFighter({ skins: [skin, skin] })).toBeNull()
    expect(withFighter({ skins: [{ ...skin, id: 's6' }] })).toBeNull()
    expect(withFighter({ skins: [1, 2, 3, 4, 5, 6].map((n) => ({ ...skin, id: `s${n}` })) })).toBeNull()
    expect(withFighter({ skins: undefined })).toBeNull()
  })

  const FREE_SMALL = { canyon: 'small', 'jungle-ruins': 'small', 'neon-docks': 'small' } as const

  it('a new account has 0 world coins, the free worlds in Small and Canyon Small chosen', () => {
    expect(startProgress()).toMatchObject({
      worldCoins: 0,
      worldSteps: 0,
      worlds: FREE_SMALL,
      selectedWorld: { id: 'canyon', size: 'small' },
      worldCodes: {},
    })
  })

  it('migrates version 7: free worlds, Canyon Small, 250 world coins per 500-step reached (1240 → 500)', () => {
    const { worldCoins: _c, worldSteps: _s, worlds: _w, selectedWorld: _sel, worldCodes: _codes, ...v7 } = {
      ...defaultProgress(),
      version: 7,
      trophies: { blaze: 1000, rocko: 240 },
    }
    const migrated = parseProgress(v7)
    expect(migrated).toEqual({
      ...v7,
      version: 8,
      worldCoins: 500,
      worldSteps: 2,
      worlds: FREE_SMALL,
      selectedWorld: { id: 'canyon', size: 'small' },
      worldCodes: {},
    })
  })

  it.each([2, 3, 4, 5, 6, 7])('a version %i save loads with the world fields and coins for its trophies', (version) => {
    const { worldCoins: _c, worldSteps: _s, worlds: _w, selectedWorld: _sel, worldCodes: _codes, createdFighters, hackExpiries, ...rest } =
      defaultProgress()
    const old = {
      ...rest,
      version,
      ...(version >= 5 ? { hackExpiries } : {}),
      ...(version === 4 || version === 5 ? { createdFighter: null } : {}),
      ...(version >= 6 ? { createdFighters } : {}),
    }
    const migrated = parseProgress(old)
    expect(migrated).toMatchObject({ version: 8, worldCoins: 750, worldSteps: 3, worlds: FREE_SMALL, trophies: rest.trophies })
  })

  it('refuses broken world fields', () => {
    const p = defaultProgress()
    expect(parseProgress({ ...p, worldCoins: -1 })).toBeNull()
    expect(parseProgress({ ...p, worlds: { canyon: 'huge' } })).toBeNull()
    expect(parseProgress({ ...p, selectedWorld: { id: 'canyon' } })).toBeNull()
    expect(parseProgress({ ...p, worldCodes: { wc1: 'soon' } })).toBeNull()
    const kept = { ...p, worldCoins: 9, worlds: { ...p.worlds, 'lava-forge': 'large' as const }, worldCodes: { wc1: 5 } }
    expect(parseProgress(JSON.parse(JSON.stringify(kept)))).toEqual(kept)
  })

  it('reset: no world coins or steps, only the free worlds in Small, Canyon Small, every code usable again', () => {
    const p = resetProgress({
      ...defaultProgress(),
      worldCoins: 1250,
      worldSteps: 5,
      worlds: { ...FREE_SMALL, canyon: 'large', 'moon-base': 'medium' },
      selectedWorld: { id: 'moon-base', size: 'medium' },
      worldCodes: { wc1: Date.now() + 1000 },
    })
    expect(p).toMatchObject({ worldCoins: 0, worldSteps: 0, worlds: FREE_SMALL, selectedWorld: { id: 'canyon', size: 'small' }, worldCodes: {} })
  })
})
