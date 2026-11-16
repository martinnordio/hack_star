import { describe, expect, it } from 'vitest'
import { withHack } from '../hacks'
import { startProgress, TEMPORARY_HACK_SECONDS, type Progress } from '../progress'
import { buyWorld, earnWorldCoins, growWorld, isWorldUnlocked, worldCoinsFor } from './worldShop'

const rich = (worldCoins: number): Progress => ({ ...startProgress(), worldCoins })

describe('earning world coins', () => {
  it('pays 250 for each new 500-step of total trophies', () => {
    expect(worldCoinsFor(509, 0)).toEqual({ coins: 250, steps: 1 })
    expect(worldCoinsFor(1010, 1)).toEqual({ coins: 250, steps: 2 })
    expect(worldCoinsFor(499, 0)).toEqual({ coins: 0, steps: 0 })
    expect(worldCoinsFor(1500, 0)).toEqual({ coins: 750, steps: 3 })
  })

  it('never pays a step twice, even when the total goes down and up again', () => {
    const p = { ...startProgress(), trophies: { blaze: 499 } }
    const first = earnWorldCoins({ ...p, trophies: { blaze: 509 } })
    expect(first.earned).toBe(250)
    expect(first.progress).toMatchObject({ worldCoins: 250, worldSteps: 1 })
    const down = earnWorldCoins({ ...first.progress, trophies: { blaze: 490 } })
    expect(down.earned).toBe(0)
    const up = earnWorldCoins({ ...down.progress, trophies: { blaze: 510 } })
    expect(up.earned).toBe(0)
    expect(up.progress.worldCoins).toBe(250)
  })

  it('counts the trophies of every fighter (990 → 1010)', () => {
    const p = { ...startProgress(), trophies: { blaze: 600, rocko: 410 }, worldSteps: 1 }
    expect(earnWorldCoins(p)).toMatchObject({ earned: 250, progress: { worldCoins: 250, worldSteps: 2 } })
  })
})

describe('buying worlds', () => {
  it.each([
    ['small', 500],
    ['medium', 750],
    ['large', 1000],
  ] as const)('buys a locked world up to %s for %i', (size, price) => {
    const bought = buyWorld(rich(1200), 'moon-base', size)
    expect(bought).toMatchObject({ ok: true, cost: price, progress: { worldCoins: 1200 - price } })
    if (!bought.ok) return
    expect(bought.progress.worlds['moon-base']).toBe(size)
    expect(isWorldUnlocked(bought.progress, 'moon-base', 'small')).toBe(true)
    expect(isWorldUnlocked(bought.progress, 'moon-base', size)).toBe(true)
  })

  it('refuses with the missing amount and changes nothing', () => {
    const p = rich(400)
    expect(buyWorld(p, 'lava-forge', 'small')).toEqual({ ok: false, reason: 'world-coins', missing: 100 })
    expect(p.worlds['lava-forge']).toBeUndefined()
  })

  it('refuses a world already unlocked', () => {
    expect(buyWorld(rich(1000), 'canyon', 'small')).toEqual({ ok: false, reason: 'owned' })
  })

  it('grows one size for 250: Medium needs Small, Large needs Medium', () => {
    const medium = growWorld(rich(600), 'jungle-ruins')
    expect(medium).toMatchObject({ ok: true, cost: 250, progress: { worldCoins: 350, worlds: { 'jungle-ruins': 'medium' } } })
    if (!medium.ok) return
    expect(isWorldUnlocked(medium.progress, 'jungle-ruins', 'large')).toBe(false)
    const large = growWorld(medium.progress, 'jungle-ruins')
    expect(large).toMatchObject({ ok: true, progress: { worldCoins: 100, worlds: { 'jungle-ruins': 'large' } } })
    if (!large.ok) return
    expect(growWorld(large.progress, 'jungle-ruins')).toEqual({ ok: false, reason: 'owned' })
    expect(growWorld(large.progress, 'pirate-cove')).toEqual({ ok: false, reason: 'locked' })
    expect(growWorld(rich(200), 'canyon')).toEqual({ ok: false, reason: 'world-coins', missing: 50 })
  })

  it('credits and the infinite-credits and UNLOCK_ALL hacks do not buy worlds', () => {
    let p: Progress = { ...startProgress(), credits: 99_999 }
    p = withHack(withHack(p, 'infinite_credits', TEMPORARY_HACK_SECONDS), 'unlock_all', TEMPORARY_HACK_SECONDS)
    expect(isWorldUnlocked(p, 'moon-base', 'small')).toBe(false)
    expect(isWorldUnlocked(p, 'canyon', 'medium')).toBe(false)
    expect(buyWorld(p, 'moon-base', 'small')).toEqual({ ok: false, reason: 'world-coins', missing: 500 })
    expect(growWorld(p, 'canyon')).toEqual({ ok: false, reason: 'world-coins', missing: 250 })
  })
})
