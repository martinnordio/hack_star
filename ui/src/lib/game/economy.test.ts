import { describe, expect, it } from 'vitest'
import type { Fighter } from '../fighters'
import { withHack } from '../hacks'
import { defaultProgress, type Progress } from '../progress'
import { creditsFor, earn, powerOf, stats, unlock, unlockPrice, upgrade, upgradeCost } from './economy'

const fighter = (id: string, rarity: Fighter['rarity']): Fighter => ({
  id,
  name: id,
  rarity,
  type: 'tank',
  idea: '',
  skins: [],
  unlocked_at_start: false,
})
const frosty = fighter('frosty', 'Epic')
const pixel = fighter('pixel', 'Legendary')

function ok(p: ReturnType<typeof unlock>): Progress {
  if (!p.ok) throw new Error(`refused: ${p.reason}`)
  return p.progress
}

describe('economy', () => {
  it('prices unlocks by rarity, as in Brawl Stars', () => {
    expect(['Rare', 'Super Rare', 'Epic', 'Mythic', 'Legendary'].map((r) => unlockPrice(r as Fighter['rarity']))).toEqual([
      160, 430, 925, 1900, 3800,
    ])
  })

  it('upgrades cost 20 \u00d7 the current level', () => {
    expect([upgradeCost(1), upgradeCost(7), upgradeCost(10)]).toEqual([20, 140, 200])
  })

  it('adds 10% health and damage per level', () => {
    expect(stats(1)).toEqual({ health: 3200, damage: 480 })
    expect(stats(11)).toEqual({ health: 6400, damage: 960 })
    expect(stats(22)).toEqual({ health: 9920, damage: 1488 })
  })

  it('gives credits for every result', () => {
    expect(creditsFor({ kind: 'victory' })).toBe(100)
    expect(creditsFor({ kind: 'defeat', place: 2 })).toBe(20)
    expect(creditsFor({ kind: 'timeup' })).toBe(20)
    expect(earn(defaultProgress(), 100).credits).toBe(600)
  })

  it('unlocks with enough credits and refuses without, saying how many are missing', () => {
    const rich = { ...defaultProgress(), credits: 1000 }
    const after = ok(unlock(rich, frosty))
    expect(after.credits).toBe(75)
    expect(after.unlockedFighters).toContain('frosty')
    expect(unlock(defaultProgress(), frosty)).toEqual({ ok: false, reason: 'credits', missing: 425 })
    expect(unlock(after, frosty)).toEqual({ ok: false, reason: 'already-unlocked' })
  })

  it('upgrades one level for its cost, up to 11', () => {
    const p = defaultProgress()
    const after = ok(upgrade(p, 'blaze'))
    expect(after.powerLevels.blaze).toBe(8)
    expect(after.credits).toBe(500 - 140)
    const maxed = { ...p, credits: 10_000, powerLevels: { ...p.powerLevels, blaze: 11 } }
    expect(upgrade(maxed, 'blaze')).toEqual({ ok: false, reason: 'max-power' })
    expect(upgrade(p, 'frosty')).toEqual({ ok: false, reason: 'locked' })
  })

  it('power 22 allows upgrades past 11, and those levels count only while the hack is on', () => {
    const p = { ...defaultProgress(), credits: 10_000, powerLevels: { blaze: 11 } }
    const hacked = withHack(p, 'power22')
    const after = ok(upgrade(hacked, 'blaze'))
    expect(after.powerLevels.blaze).toBe(12)
    expect(powerOf(after, 'blaze')).toBe(12)
    expect(powerOf({ ...after, activeHacks: [] }, 'blaze')).toBe(11)
  })

  it('with unlimited credits buying is free and the saved credits do not change', () => {
    const p = withHack(defaultProgress(), 'infinite_credits')
    const after = ok(unlock(p, pixel))
    expect(after.unlockedFighters).toContain('pixel')
    expect(after.credits).toBe(500)
    expect(ok(upgrade(after, 'pixel')).credits).toBe(500)
  })
})
