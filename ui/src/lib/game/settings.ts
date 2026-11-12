/** Match settings. Answers from Mattia (see "Questions to Mattia" in .specs/overall_req.md) go here. */

export type BotLevel = 'easy' | 'medium' | 'hard'

export interface Settings {
  matchSeconds: number
  botCount: number
  botLevel: BotLevel
  /** What the player gets when time runs out with bots still in. */
  timeUpResult: 'draw' | 'defeat'
  botsFightEachOther: boolean
  countdownSeconds: number
  /** Seconds without being hit or shooting before healing starts. */
  healDelay: number
  /** Share of full health healed per second. */
  healPerSecond: number
  /** Trophies the fighter gets for a victory. */
  trophiesPerWin: number
  /** Trophies for a defeat: 0 or negative (never below the last Prestige). */
  trophiesPerDefeat: number
  /** Trophies when time runs out (only used when `timeUpResult` is 'draw'). */
  timeUpTrophies: number
  /** Health and damage at power level 1. */
  fighterHealth: number
  shotDamage: number
  /** Extra health and damage per power level above 1 (0.1 = +10%). */
  powerBonusPerLevel: number
  /** Power level of the bots. */
  botPower: number
  creditsPerWin: number
  creditsPerDefeat: number
  timeUpCredits: number
  /** Upgrading from level n costs n × this. */
  upgradeCostPerLevel: number
  unlockPrices: Record<'Default' | 'Rare' | 'Super Rare' | 'Epic' | 'Mythic' | 'Legendary', number>
  skinPrices: Record<'Default' | 'Rare' | 'Super Rare' | 'Epic' | 'Mythic' | 'Legendary', number>
  /** Discount on the skin of the day (0.3 = 30% off). */
  skinOfTheDayDiscount: number
}

export const SETTINGS: Settings = {
  matchSeconds: 120,
  botCount: 3,
  botLevel: 'easy',
  timeUpResult: 'draw',
  botsFightEachOther: true,
  countdownSeconds: 3,
  fighterHealth: 3200,
  healDelay: 3,
  healPerSecond: 0.13,
  trophiesPerWin: 10,
  trophiesPerDefeat: 0,
  timeUpTrophies: 0,
  shotDamage: 480,
  powerBonusPerLevel: 0.1,
  botPower: 5,
  creditsPerWin: 100,
  creditsPerDefeat: 20,
  timeUpCredits: 20,
  upgradeCostPerLevel: 20,
  // As in Brawl Stars.
  unlockPrices: { Default: 0, Rare: 160, 'Super Rare': 430, Epic: 925, Mythic: 1900, Legendary: 3800 },
  skinPrices: { Default: 0, Rare: 100, 'Super Rare': 200, Epic: 300, Mythic: 600, Legendary: 1500 },
  skinOfTheDayDiscount: 0.3,
}

export interface BotSkill {
  /** Seconds before a bot reacts to a new target. */
  reaction: number
  /** Random aim error, in radians either side. */
  aimError: number
  /** Multiplier on the shot cool-down (bigger is slower). */
  cooldown: number
  /** Multiplier on walking speed. */
  speed: number
  /** How far a bot sees (units). */
  sight: number
}

export const BOT_LEVELS: Record<BotLevel, BotSkill> = {
  easy: { reaction: 0.6, aimError: 0.35, cooldown: 2.4, speed: 0.75, sight: 8 },
  medium: { reaction: 0.35, aimError: 0.2, cooldown: 1.6, speed: 0.9, sight: 10 },
  hard: { reaction: 0.15, aimError: 0.08, cooldown: 1.15, speed: 1, sight: 12 },
}

/** Settings with overrides from the address (`?seconds=30&bots=5&level=hard`), for trying values quickly. */
export function settingsFrom(search: string, base: Settings = SETTINGS): Settings {
  const params = new URLSearchParams(search)
  const number = (name: string, min: number, max: number) => {
    const value = Number(params.get(name))
    return params.has(name) && Number.isFinite(value) ? Math.min(max, Math.max(min, Math.round(value))) : undefined
  }
  const level = params.get('level')
  return {
    ...base,
    matchSeconds: number('seconds', 5, 600) ?? base.matchSeconds,
    botCount: number('bots', 1, 8) ?? base.botCount,
    botLevel: level === 'easy' || level === 'medium' || level === 'hard' ? level : base.botLevel,
  }
}
