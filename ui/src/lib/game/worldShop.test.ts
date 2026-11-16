import { describe, expect, it } from 'vitest'
import { startProgress, type Progress } from '../progress'
import { SETTINGS } from './settings'
import { addWorldCoins, buyWorld, chooseWorld, earnWorldCoins, growWorld, isWorldUnlocked, worldCoinsFor } from './worldShop'

const rich = (coins: number, extra: Partial<Progress> = {}): Progress => ({ ...startProgress(), worldCoins: coins, ...extra })

describe('earning world coins', () => {
  it('pays 250 when the total passes the next multiple of 500', () => {
    expect(worldCoinsFor(509, 0)).toEqual({ steps: 1, coins: 250 })
    expect(worldCoinsFor(499, 0)).toEqual({ steps: 0, coins: 0 })
    expect(worldCoinsFor(1010, 1)).toEqual({ steps: 1, coins: 250 })
    expect(worldCoinsFor(2600, 1)).toEqual({ steps: 4, coins: 1000 })
  })

  it('pays a step once, even when the total goes down and up again', () => {
    const start = rich(0, { trophies: { blaze: 509 } })
    const paid = earnWorldCoins(start)
    expect(paid).toMatchObject({ coins: 250, progress: { worldCoins: 250, worldSteps: 1 } })
    const down = { ...paid.progress, trophies: { blaze: 490 } }
    expect(earnWorldCoins(down).coins).toBe(0)
    const up = { ...down, trophies: { blaze: 515 } }
    expect(earnWorldCoins(up)).toEqual({ progress: up, coins: 0 })
  })

  it('counts the trophies of all fighters together', () => {
    const p = rich(0, { trophies: { blaze: 400, rocko: 110 } })
    expect(earnWorldCoins(p).progress.worldCoins).toBe(250)
  })

  it('never goes below 0 when coins are taken away', () => {
    expect(addWorldCoins(rich(100), -500).worldCoins).toBe(0)
    expect(addWorldCoins(rich(100), 500).worldCoins).toBe(600)
  })
})

describe('buying worlds', () => {
  it.each([
    ['small', 500, 500],
    ['medium', 750, 250],
    ['large', 1000, 0],
  ] as const)('a new world up to %s costs %i world coins', (size, cost, left) => {
    const result = buyWorld(rich(1000), 'lava-forge', size)
    expect(result).toMatchObject({ ok: true, cost, progress: { worldCoins: left, worlds: { 'lava-forge': size } } })
  })

  it('says how many more world coins are needed and changes nothing', () => {
    const p = rich(300)
    expect(buyWorld(p, 'lava-forge', 'small')).toEqual({ ok: false, reason: 'world-coins', missing: 200 })
    expect(buyWorld(p, 'lava-forge', 'large')).toEqual({ ok: false, reason: 'world-coins', missing: 700 })
    expect(p.worlds['lava-forge']).toBeUndefined()
  })

  it('refuses a world that is already unlocked, free ones included', () => {
    expect(buyWorld(rich(5000), 'canyon', 'small')).toEqual({ ok: false, reason: 'already-unlocked' })
    const bought = buyWorld(rich(5000), 'moon-base', 'small')
    if (!bought.ok) throw new Error('not bought')
    expect(buyWorld(bought.progress, 'moon-base', 'medium')).toEqual({ ok: false, reason: 'already-unlocked' })
  })
})

describe('growing worlds', () => {
  it('costs 250 per size, Medium before Large, for free worlds and worlds bought smaller', () => {
    const medium = growWorld(rich(600), 'canyon')
    expect(medium).toMatchObject({ ok: true, cost: 250, progress: { worldCoins: 350, worlds: { canyon: 'medium' } } })
    if (!medium.ok) throw new Error('not grown')
    const large = growWorld(medium.progress, 'canyon')
    expect(large).toMatchObject({ ok: true, progress: { worldCoins: 100, worlds: { canyon: 'large' } } })
    if (!large.ok) throw new Error('not grown')
    expect(growWorld(large.progress, 'canyon')).toEqual({ ok: false, reason: 'max-size' })

    const bought = buyWorld(rich(1000), 'pirate-cove', 'small')
    if (!bought.ok) throw new Error('not bought')
    expect(growWorld(bought.progress, 'pirate-cove')).toMatchObject({ ok: true, progress: { worlds: { 'pirate-cove': 'medium' } } })
  })

  it('refuses a locked world and says how many more world coins are needed', () => {
    expect(growWorld(rich(5000), 'lava-forge')).toEqual({ ok: false, reason: 'locked' })
    expect(growWorld(rich(100), 'canyon')).toEqual({ ok: false, reason: 'world-coins', missing: 150 })
  })
})

describe('credits and hacks do not unlock worlds', () => {
  it('credits cannot buy a world and the hacks leave worlds as they are', () => {
    const p = {
      ...startProgress(),
      credits: 999999,
      activeHacks: ['infinite_credits', 'unlock_all'],
      hackExpiries: { infinite_credits: Date.now() + 60_000, unlock_all: Date.now() + 60_000 },
    }
    expect(buyWorld(p, 'lava-forge', 'small')).toMatchObject({ ok: false, reason: 'world-coins', missing: SETTINGS.worldPrices.small })
    expect(isWorldUnlocked(p, 'lava-forge')).toBe(false)
    expect(growWorld(p, 'canyon')).toMatchObject({ ok: false, reason: 'world-coins' })
  })
})

describe('choosing a world', () => {
  it('only unlocked worlds and sizes can be chosen', () => {
    expect(chooseWorld(startProgress(), 'jungle-ruins', 'small')?.selectedWorld).toEqual({ id: 'jungle-ruins', size: 'small' })
    expect(chooseWorld(startProgress(), 'jungle-ruins', 'medium')).toBeNull()
    expect(chooseWorld(startProgress(), 'lava-forge', 'small')).toBeNull()
    const grown = growWorld(rich(300), 'jungle-ruins')
    if (!grown.ok) throw new Error('not grown')
    expect(chooseWorld(grown.progress, 'jungle-ruins', 'small')).not.toBeNull()
    expect(chooseWorld(grown.progress, 'jungle-ruins', 'medium')).not.toBeNull()
  })
})
