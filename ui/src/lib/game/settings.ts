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
  fighterHealth: number
  /** Seconds without being hit or shooting before healing starts. */
  healDelay: number
  /** Share of full health healed per second. */
  healPerSecond: number
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
