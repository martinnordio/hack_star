import { prestigeLevel } from '../fighters'
import type { Progress } from '../progress'
import type { MatchResult } from './match'
import type { Settings } from './settings'

export interface Reward {
  before: number
  after: number
  change: number
  prestigeBefore: number
  prestigeAfter: number
}

/** Trophies after a match; a fighter never drops below the last Prestige it reached. */
export function rewardFor(trophies: number, result: MatchResult, settings: Settings): Reward {
  const change =
    result.kind === 'victory'
      ? settings.trophiesPerWin
      : result.kind === 'defeat'
        ? settings.trophiesPerDefeat
        : settings.timeUpTrophies
  const prestigeBefore = prestigeLevel(trophies)
  const floor = prestigeBefore * 1000
  const after = Math.max(floor, trophies + change)
  return { before: trophies, after, change: after - trophies, prestigeBefore, prestigeAfter: prestigeLevel(after) }
}

export function applyReward(progress: Progress, fighterId: string, reward: Reward): Progress {
  return { ...progress, trophies: { ...progress.trophies, [fighterId]: reward.after } }
}

/** Trophies needed for the next Prestige (1000, 2000, …). */
export function nextPrestigeAt(trophies: number): number {
  return (prestigeLevel(trophies) + 1) * 1000
}
