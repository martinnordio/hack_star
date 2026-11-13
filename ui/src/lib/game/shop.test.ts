import { describe, expect, it } from 'vitest'
import type { Fighter } from '../fighters'
import { withHack } from '../hacks'
import { defaultProgress, loadProgress, memoryStorage, PROGRESS_KEY, type Progress } from '../progress'
import { buySkin, ownsSkin, skinOfTheDay, skinPrice } from './shop'

const skins = (...list: [string, Fighter['rarity']][]) => [
  { id: 'default', name: 'Default', rarity: 'Default' as const },
  ...list.map(([id, rarity]) => ({ id, name: id, rarity })),
]
const fighters: Fighter[] = [
  { id: 'blaze', name: 'Blaze', rarity: 'Rare', type: 'spreader', idea: '', skins: skins(['lava', 'Epic'], ['phoenix', 'Legendary']), unlocked_at_start: true },
  { id: 'rocko', name: 'Rocko', rarity: 'Rare', type: 'tank', idea: '', skins: skins(['crystal', 'Epic']), unlocked_at_start: true },
  { id: 'luna', name: 'Luna', rarity: 'Mythic', type: 'sharpshooter', idea: '', skins: skins(['galaxy', 'Mythic']), unlocked_at_start: false },
]
const [blaze, rocko, luna] = fighters
const skin = (f: Fighter, id: string) => f.skins.find((s) => s.id === id)!
const day = new Date(2026, 10, 12, 10)
const nextDay = new Date(2026, 10, 13, 10)

function ok(p: ReturnType<typeof buySkin>): Progress {
  if (!p.ok) throw new Error(`refused: ${p.reason}`)
  return p.progress
}

describe('skins shop', () => {
  it('owns every default skin, nothing else at the start', () => {
    const p = defaultProgress()
    expect(ownsSkin(p, 'blaze', 'default')).toBe(true)
    expect(ownsSkin(p, 'blaze', 'lava')).toBe(false)
  })

  it('prices skins by rarity, with 30% off the skin of the day', () => {
    const p = defaultProgress()
    const daily = skinOfTheDay(p, fighters, day)!
    for (const f of fighters) {
      for (const s of f.skins.filter((s) => s.id !== 'default')) {
        const full = { Epic: 300, Mythic: 600, Legendary: 1500 }[s.rarity as 'Epic']
        const isDaily = daily.fighter.id === f.id && daily.skin.id === s.id
        expect(skinPrice(p, fighters, f, s, day)).toBe(isDaily ? Math.round(full * 0.7) : full)
      }
    }
  })

  it('the skin of the day is the same all day, changes between days, and is never owned', () => {
    const p = defaultProgress()
    const morning = skinOfTheDay(p, fighters, new Date(2026, 10, 12, 0, 5))
    const evening = skinOfTheDay(p, fighters, new Date(2026, 10, 12, 23, 55))
    expect(morning).toEqual(evening)
    expect(skinOfTheDay(p, fighters, nextDay)).not.toEqual(morning)
    const owner = { ...p, ownedSkins: { [morning!.fighter.id]: [morning!.skin.id] } }
    expect(skinOfTheDay(owner, fighters, day)).not.toEqual(morning)
    expect(skinOfTheDay(withHack(p, 'unlock_all'), fighters, day)).toBeUndefined()
  })

  it('buys a skin: credits go down and the skin is owned', () => {
    const p = { ...defaultProgress(), credits: 1000 }
    const crystal = skin(rocko, 'crystal')
    const price = skinPrice(p, fighters, rocko, crystal, day)
    const after = ok(buySkin(p, fighters, rocko, crystal, day))
    expect(after.credits).toBe(1000 - price)
    expect(ownsSkin(after, 'rocko', 'crystal')).toBe(true)
    expect(buySkin(after, fighters, rocko, crystal, day)).toEqual({ ok: false, reason: 'owned' })
  })

  it('refuses without enough credits, saying how many are missing', () => {
    const p = { ...defaultProgress(), credits: 700 }
    const phoenix = skin(blaze, 'phoenix')
    const price = skinPrice(p, fighters, blaze, phoenix, day)
    expect(buySkin(p, fighters, blaze, phoenix, day)).toEqual({ ok: false, reason: 'credits', missing: price - 700 })
  })

  it('refuses skins of a locked fighter', () => {
    const p = { ...defaultProgress(), credits: 5000 }
    expect(buySkin(p, fighters, luna, skin(luna, 'galaxy'), day)).toEqual({ ok: false, reason: 'locked' })
  })

  it('hacks: unlock-everything owns all skins; unlimited credits keeps the saved credits', () => {
    expect(ownsSkin(withHack(defaultProgress(), 'unlock_all'), 'luna', 'galaxy')).toBe(true)
    const p = withHack(defaultProgress(), 'infinite_credits')
    const after = ok(buySkin(p, fighters, blaze, skin(blaze, 'phoenix'), day))
    expect(after.credits).toBe(500)
    expect(ownsSkin({ ...after, activeHacks: [] }, 'blaze', 'phoenix')).toBe(true)
  })

  it('migrates version 2 progress: data kept, selected skins become owned', () => {
    const storage = memoryStorage()
    const v2 = {
      version: 2,
      credits: 360,
      trophies: { blaze: 2005 },
      powerLevels: { blaze: 9 },
      unlockedFighters: ['blaze', 'frosty'],
      activeHacks: [],
      selectedFighter: 'blaze',
      selectedSkins: { blaze: 'phoenix', rocko: 'default' },
    }
    storage.setItem(PROGRESS_KEY, JSON.stringify(v2))
    const p = loadProgress(storage)
    expect(p).toMatchObject({ version: 4, credits: 360, trophies: { blaze: 2005 }, unlockedFighters: ['blaze', 'frosty'] })
    expect(p.ownedSkins).toEqual({ blaze: ['phoenix'] })
  })
})
