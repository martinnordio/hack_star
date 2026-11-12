import { describe, expect, it } from 'vitest'
import { defaultProgress } from '../progress'
import { SETTINGS } from './settings'
import { applyReward, nextPrestigeAt, rewardFor } from './trophies'

const victory = { kind: 'victory' } as const
const defeat = { kind: 'defeat', place: 3 } as const
const timeup = { kind: 'timeup' } as const

describe('trophies', () => {
  it('a win gives +10, a defeat or time up nothing (defaults)', () => {
    expect(rewardFor(1240, victory, SETTINGS)).toMatchObject({ before: 1240, after: 1250, change: 10 })
    expect(rewardFor(1240, defeat, SETTINGS)).toMatchObject({ after: 1240, change: 0 })
    expect(rewardFor(1240, timeup, SETTINGS)).toMatchObject({ after: 1240, change: 0 })
  })

  it('reaching 1000 or 2000 raises the Prestige', () => {
    expect(rewardFor(990, victory, SETTINGS)).toMatchObject({ prestigeBefore: 0, prestigeAfter: 1 })
    expect(rewardFor(1995, victory, SETTINGS)).toMatchObject({ after: 2005, prestigeBefore: 1, prestigeAfter: 2 })
    expect(rewardFor(1240, victory, SETTINGS)).toMatchObject({ prestigeBefore: 1, prestigeAfter: 1 })
  })

  it('a defeat never takes a fighter below its last Prestige, nor below 0', () => {
    const losing = { ...SETTINGS, trophiesPerDefeat: -20 }
    expect(rewardFor(1005, defeat, losing)).toMatchObject({ after: 1000, change: -5 })
    expect(rewardFor(1500, defeat, losing)).toMatchObject({ after: 1480, change: -20 })
    expect(rewardFor(15, defeat, losing)).toMatchObject({ after: 0, change: -15 })
  })

  it('saves the new count for that fighter only', () => {
    const p = defaultProgress()
    const next = applyReward(p, 'rocko', rewardFor(p.trophies.rocko, victory, SETTINGS))
    expect(next.trophies).toEqual({ ...p.trophies, rocko: 430 })
    expect(p.trophies.rocko).toBe(420)
  })

  it('knows the next Prestige', () => {
    expect([nextPrestigeAt(0), nextPrestigeAt(999), nextPrestigeAt(1000), nextPrestigeAt(2500)]).toEqual([
      1000, 1000, 2000, 3000,
    ])
  })
})
