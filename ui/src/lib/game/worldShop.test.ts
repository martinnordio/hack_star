import { describe, expect, it } from 'vitest'
import { TEMPORARY_HACK_SECONDS, startProgress, type Progress } from '../progress'
import { withHack } from '../hacks'
import { buyWorld, chooseWorld, chosenWorld, earnWorldCoins, growWorld, isWorldUnlocked, worldCoinsFor } from './worldShop'

const withCoins = (worldCoins: number, extra: Partial<Progress> = {}): Progress => ({ ...startProgress(), worldCoins, ...extra })

describe('world coins', () => {
  it.each([
    [499, 509, 0, 250, 1],
    [990, 1010, 1, 250, 2],
    [0, 1240, 0, 500, 2],
    [1010, 990, 2, 0, 2],
    [990, 1010, 2, 0, 2],
    [100, 400, 0, 0, 0],
  ])('%i → %i trophies with %i steps paid gives %i world coins (%i steps)', (before, after, steps, coins, nextSteps) => {
    expect(worldCoinsFor(before, after, steps)).toEqual({ coins, steps: nextSteps })
  })

  it('a step is never paid twice, even when the total goes down and up again', () => {
    let p = withCoins(0, { trophies: { blaze: 505 } })
    const first = earnWorldCoins(p, 495)
    expect(first.coins).toBe(250)
    p = { ...first.progress, trophies: { blaze: 495 } }
    p = earnWorldCoins(p, 505).progress
    const again = earnWorldCoins({ ...p, trophies: { blaze: 505 } }, 495)
    expect(again).toEqual({ progress: { ...p, trophies: { blaze: 505 } }, coins: 0 })
    expect(again.progress.worldCoins).toBe(250)
  })
})

describe('world shop', () => {
  it.each([
    ['small', 500],
    ['medium', 750],
    ['large', 1000],
  ] as const)('buys a locked world in %s for %i world coins, with every smaller size', (size, cost) => {
    const result = buyWorld(withCoins(1200), 'lava-forge', size)
    expect(result).toMatchObject({ ok: true, cost, progress: { worldCoins: 1200 - cost } })
    if (result.ok) {
      expect(isWorldUnlocked(result.progress, 'lava-forge', 'small')).toBe(true)
      expect(isWorldUnlocked(result.progress, 'lava-forge', size)).toBe(true)
    }
  })

  it('grows a free world one size for 250: Medium needs Small, Large needs Medium', () => {
    const medium = growWorld(withCoins(600), 'canyon')
    expect(medium).toMatchObject({ ok: true, cost: 250, progress: { worldCoins: 350, worlds: { canyon: 'medium' } } })
    if (!medium.ok) return
    const large = growWorld(medium.progress, 'canyon')
    expect(large).toMatchObject({ ok: true, cost: 250, progress: { worldCoins: 100, worlds: { canyon: 'large' } } })
    if (large.ok) expect(growWorld(large.progress, 'canyon')).toEqual({ ok: false, reason: 'owned' })
    expect(growWorld(withCoins(600), 'moon-base')).toEqual({ ok: false, reason: 'locked' })
  })

  it('refuses with the missing amount and changes nothing', () => {
    expect(buyWorld(withCoins(300), 'moon-base', 'medium')).toEqual({ ok: false, reason: 'world-coins', missing: 450 })
    expect(growWorld(withCoins(100), 'neon-docks')).toEqual({ ok: false, reason: 'world-coins', missing: 150 })
  })

  it('refuses what is already unlocked and unknown worlds', () => {
    expect(buyWorld(withCoins(5000), 'canyon', 'small')).toEqual({ ok: false, reason: 'owned' })
    expect(buyWorld(withCoins(5000, { worlds: { 'moon-base': 'small' } }), 'moon-base', 'large')).toEqual({ ok: false, reason: 'owned' })
    expect(buyWorld(withCoins(5000), 'atlantis', 'small')).toEqual({ ok: false, reason: 'unknown' })
  })

  it('credits and the infinite-credits and UNLOCK_ALL hacks do not buy worlds', () => {
    let p = withCoins(0, { credits: 100_000 })
    p = withHack(withHack(p, 'infinite_credits', TEMPORARY_HACK_SECONDS), 'unlock_all', TEMPORARY_HACK_SECONDS)
    expect(isWorldUnlocked(p, 'lava-forge', 'small')).toBe(false)
    expect(isWorldUnlocked(p, 'canyon', 'medium')).toBe(false)
    expect(buyWorld(p, 'lava-forge', 'small')).toEqual({ ok: false, reason: 'world-coins', missing: 500 })
  })

  it('keeps an unlocked choice and falls back to Canyon Small otherwise', () => {
    const p = withCoins(0, { worlds: { canyon: 'small', 'moon-base': 'medium' } })
    const chosen = chooseWorld(p, 'moon-base', 'medium')
    expect(chosenWorld(chosen)).toEqual({ id: 'moon-base', size: 'medium' })
    expect(chooseWorld(p, 'moon-base', 'large')).toBe(p)
    expect(chosenWorld({ ...p, selectedWorld: { id: 'lava-forge', size: 'small' } })).toEqual({ id: 'canyon', size: 'small' })
  })
})
