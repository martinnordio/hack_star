import type { Fighter, Rarity } from '../fighters'
import { credits, isUnlocked, maxPower } from '../hacks'
import type { Progress } from '../progress'
import type { MatchResult } from './match'
import { SETTINGS, type Settings } from './settings'
import { BASIC, type FighterType } from './types'

export interface Stats {
  health: number
  damage: number
}

export type Purchase =
  | { ok: true; progress: Progress; cost: number }
  | { ok: false; reason: 'already-unlocked' | 'locked' | 'max-power' | 'owned' }
  | { ok: false; reason: 'credits'; missing: number }

export function unlockPrice(rarity: Rarity, settings: Settings = SETTINGS): number {
  return settings.unlockPrices[rarity]
}

/** Credits to go from `level` to `level + 1`. */
export function upgradeCost(level: number, settings: Settings = SETTINGS): number {
  return level * settings.upgradeCostPerLevel
}

/** Health and damage at a power level, for a fighter type (Basic when not given). */
export function stats(level: number, settings: Settings = SETTINGS, type: FighterType = BASIC): Stats {
  const factor = 1 + settings.powerBonusPerLevel * (level - 1)
  return {
    health: Math.round(settings.fighterHealth * factor * type.health),
    damage: Math.round(settings.shotDamage * factor * type.damage),
  }
}

export function creditsFor(result: MatchResult, settings: Settings = SETTINGS): number {
  if (result.kind === 'victory') return settings.creditsPerWin
  return result.kind === 'defeat' ? settings.creditsPerDefeat : settings.timeUpCredits
}

/** The power level that counts now: levels bought with power 22 count only while the hack is on. */
export function powerOf(progress: Progress, fighterId: string): number {
  return Math.min(progress.powerLevels[fighterId] ?? 1, maxPower(progress))
}

/** Pay `cost`; with unlimited credits the saved credits stay as they are. */
export function pay(progress: Progress, cost: number): Purchase | Progress {
  const available = credits(progress)
  if (available < cost) return { ok: false, reason: 'credits', missing: cost - available }
  return available === Infinity ? progress : { ...progress, credits: progress.credits - cost }
}

export function unlock(progress: Progress, fighter: Fighter, settings: Settings = SETTINGS): Purchase {
  if (progress.unlockedFighters.includes(fighter.id)) return { ok: false, reason: 'already-unlocked' }
  const cost = unlockPrice(fighter.rarity, settings)
  const paid = pay(progress, cost)
  if ('ok' in paid) return paid
  return { ok: true, cost, progress: { ...paid, unlockedFighters: [...paid.unlockedFighters, fighter.id] } }
}

export function upgrade(progress: Progress, fighterId: string, settings: Settings = SETTINGS): Purchase {
  if (!isUnlocked(progress, fighterId)) return { ok: false, reason: 'locked' }
  const level = powerOf(progress, fighterId)
  if (level >= maxPower(progress)) return { ok: false, reason: 'max-power' }
  const cost = upgradeCost(level, settings)
  const paid = pay(progress, cost)
  if ('ok' in paid) return paid
  return { ok: true, cost, progress: { ...paid, powerLevels: { ...paid.powerLevels, [fighterId]: level + 1 } } }
}

export function earn(progress: Progress, amount: number): Progress {
  return { ...progress, credits: Math.max(0, progress.credits + amount) }
}
