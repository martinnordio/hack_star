import { describe, expect, it } from 'vitest'
import { startProgress, type Progress } from '../progress'
import { SETTINGS } from './settings'
import {
  addWorldCoins,
  buyWorld,
  chooseWorld,
  earnWorldCoins,
  growWorld,
  isWorldUnlocked,
  worldCoinsFor,
  worldPrice,
} from './worldShop'

function withTrophies(total: number, extra: Partial<Progress> = {}): Progress {
  return { ...startProgress(), trophies: { blaze: total }, ...extra }
}

describe('world coins earned per trophy step', () => {
  it('pays 250 when the total first reaches 500', () => {
    expect(worldCoinsFor(499, 0)).toBe(0)
    expect(worldCoinsFor(509, 0)).toBe(250)
  })

  it('pays 250 when the total passes 1000 after 990', () => {
    expect(worldCoinsFor(1010, 1)).toBe(250)
  })

  it('pays each step only once, even when the total goes down and up again', () => {
    const first = earnWorldCoins(withTrophies(509))
    expect(first.earned).toBe(250)
    expect(first.progress.worldCoins).toBe(250)
    expect(first.progress.worldSteps).toBe(1)

    const dropped = earnWorldCoins({ ...first.progress, trophies: { blaze: 300 } })
    expect(dropped.earned).toBe(0)

    const again = earnWorldCoins({ ...dropped.progress, trophies: { blaze: 600 } })
    expect(again.earned).toBe(0)
    expect(again.progress.worldCoins).toBe(250)
  })

  it('pays only the steps not paid yet', () => {
    const { earned, progress } = earnWorldCoins(withTrophies(1240))
    expect(earned).toBe(500)
    expect(progress.worldSteps).toBe(2)
  })
})

describe('world prices and sizes', () => {
  it('prices a world by its size', () => {
    expect(worldPrice('small')).toBe(500)
    expect(worldPrice('medium')).toBe(750)
    expect(worldPrice('large')).toBe(1000)
    expect(SETTINGS.worldSizeStep).toBe(250)
  })

  it('buys a locked world in Small for 500 world coins', () => {
    const result = buyWorld(withTrophies(0, { worldCoins: 500 }), 'lava-forge')
    expect(result.ok).toBe(true)
    if (!result.ok) return
    expect(result.cost).toBe(500)
    expect(result.progress.worldCoins).toBe(0)
    expect(result.progress.worlds['lava-forge']).toBe('small')
    expect(isWorldUnlocked(result.progress, 'lava-forge')).toBe(true)
  })

  it('buys Small + Medium for 750 and all sizes for 1000', () => {
    const medium = buyWorld(withTrophies(0, { worldCoins: 750 }), 'lava-forge', 'medium')
    expect(medium.ok && medium.progress.worlds['lava-forge']).toBe('medium')
    const large = buyWorld(withTrophies(0, { worldCoins: 1000 }), 'lava-forge', 'large')
    expect(large.ok && large.progress.worlds['lava-forge']).toBe('large')
    expect(large.ok && large.progress.worldCoins).toBe(0)
  })

  it('refuses a purchase with too few world coins and gives the missing amount', () => {
    const result = buyWorld(withTrophies(0, { worldCoins: 499 }), 'lava-forge')
    expect(result).toEqual({ ok: false, reason: 'world-coins', missing: 1 })
  })

  it('does not pay for worlds with credits', () => {
    const result = buyWorld(withTrophies(0, { credits: 999999, worldCoins: 0 }), 'lava-forge')
    expect(result).toEqual({ ok: false, reason: 'world-coins', missing: 500 })
  })

  it('refuses to buy something already unlocked', () => {
    expect(buyWorld(withTrophies(0, { worldCoins: 1000 }), 'canyon')).toEqual({
      ok: false,
      reason: 'already-unlocked',
    })
  })

  it('grows an unlocked world one size for 250 world coins', () => {
    const medium = growWorld(withTrophies(0, { worldCoins: 250 }), 'canyon')
    expect(medium.ok && medium.progress.worlds.canyon).toBe('medium')
    expect(medium.ok && medium.progress.worldCoins).toBe(0)

    const large = growWorld(withTrophies(0, { worldCoins: 250, worlds: { canyon: 'medium' } }), 'canyon')
    expect(large.ok && large.progress.worlds.canyon).toBe('large')
  })

  it('refuses to grow a locked world or a world already at Large', () => {
    expect(growWorld(withTrophies(0, { worldCoins: 1000 }), 'lava-forge')).toEqual({ ok: false, reason: 'locked' })
    expect(growWorld(withTrophies(0, { worldCoins: 1000, worlds: { canyon: 'large' } }), 'canyon')).toEqual({
      ok: false,
      reason: 'max-size',
    })
  })

  it('reports the missing world coins when growing with too few', () => {
    expect(growWorld(withTrophies(0, { worldCoins: 100 }), 'canyon')).toEqual({
      ok: false,
      reason: 'world-coins',
      missing: 150,
    })
  })
})

describe('choosing a world', () => {
  it('chooses an unlocked world and size and keeps it', () => {
    const result = chooseWorld(startProgress(), 'canyon', 'small')
    expect(result.ok && result.progress.selectedWorld).toEqual({ id: 'canyon', size: 'small' })
  })

  it('refuses a locked world or a size not unlocked', () => {
    expect(chooseWorld(startProgress(), 'lava-forge', 'small')).toEqual({ ok: false, reason: 'locked' })
    expect(chooseWorld(startProgress(), 'canyon', 'medium')).toEqual({ ok: false, reason: 'locked' })
  })
})

describe('adding world coins', () => {
  it('adds world coins and never goes below 0', () => {
    expect(addWorldCoins(startProgress(), 500).worldCoins).toBe(500)
    expect(addWorldCoins(withTrophies(0, { worldCoins: 100 }), -300).worldCoins).toBe(0)
  })
})
