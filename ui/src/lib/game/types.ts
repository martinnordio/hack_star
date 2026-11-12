/** Fighter types: how a fighter moves, shoots and what its Super does (more fighters spec). */

export type FighterTypeId = 'tank' | 'sharpshooter' | 'speedy' | 'thrower' | 'spreader'
export type SuperKind = 'blast' | 'shockwave' | 'beam' | 'dash' | 'bomb'

export interface Attack {
  range: number
  /** Shot speed (units per second). */
  speed: number
  radius: number
  /** Shots per attack, spread in a fan `spread` radians apart. */
  count: number
  spread: number
  /** Share of the fighter's damage each shot does. */
  share: number
  /** Lobbed shots fly over walls and fighters and explode where they land. */
  lob: boolean
  /** Explosion radius of a lobbed shot. */
  blast: number
}

export interface FighterType {
  id: FighterTypeId | 'basic'
  name: string
  emoji: string
  /** One line for the fighter screen. */
  about: string
  /** Multipliers on the power level's health and damage, walking speed and time between attacks. */
  health: number
  damage: number
  speed: number
  reload: number
  attack: Attack
  super: SuperKind
  superName: string
  /** Bots use the Super on targets closer than this. */
  superReach: number
}

const shot = (attack: Partial<Attack>): Attack => ({
  range: 9,
  speed: 16,
  radius: 0.25,
  count: 1,
  spread: 0,
  share: 1,
  lob: false,
  blast: 0,
  ...attack,
})

/** No type: the numbers every fighter had before types (tests, unknown fighters). */
export const BASIC: FighterType = {
  id: 'basic',
  name: 'Basic',
  emoji: '⭐',
  about: 'All-rounder.',
  health: 1,
  damage: 1,
  speed: 1,
  reload: 1,
  attack: shot({}),
  super: 'blast',
  superName: 'Super blast',
  superReach: 9,
}

export const FIGHTER_TYPES: Record<FighterTypeId, FighterType> = {
  tank: {
    id: 'tank',
    name: 'Tank',
    emoji: '🛡️',
    about: 'Lots of health, short range. Get close!',
    health: 1.2,
    damage: 0.95,
    speed: 0.92,
    reload: 1.05,
    attack: shot({ range: 5.5, speed: 15, radius: 0.35 }),
    super: 'shockwave',
    superName: 'Shockwave',
    superReach: 4.5,
  },
  sharpshooter: {
    id: 'sharpshooter',
    name: 'Sharpshooter',
    emoji: '🎯',
    about: 'Very long range, less health. Keep your distance.',
    health: 0.75,
    damage: 1.05,
    speed: 1,
    reload: 1.4,
    attack: shot({ range: 12.5, speed: 22, radius: 0.2 }),
    super: 'beam',
    superName: 'Piercing beam',
    superReach: 12,
  },
  speedy: {
    id: 'speedy',
    name: 'Speedy',
    emoji: '⚡',
    about: 'Runs fast and shoots quickly.',
    health: 0.9,
    damage: 0.8,
    speed: 1.25,
    reload: 0.8,
    attack: shot({ range: 8, speed: 18, radius: 0.22 }),
    super: 'dash',
    superName: 'Dash',
    superReach: 6,
  },
  thrower: {
    id: 'thrower',
    name: 'Thrower',
    emoji: '💣',
    about: 'Throws over walls; hits explode where they land.',
    health: 0.75,
    damage: 1,
    speed: 0.95,
    reload: 1.5,
    attack: shot({ range: 9, speed: 11, radius: 0.3, lob: true, blast: 1.4 }),
    super: 'bomb',
    superName: 'Big bomb',
    superReach: 9,
  },
  spreader: {
    id: 'spreader',
    name: 'Spreader',
    emoji: '🔥',
    about: 'Three shots in a fan: deadly up close.',
    health: 1,
    damage: 1,
    speed: 1,
    reload: 1.1,
    attack: shot({ range: 7.5, count: 3, spread: 0.2, share: 0.46 }),
    super: 'blast',
    superName: 'Super blast',
    superReach: 8,
  },
}

export function fighterType(id: string | undefined): FighterType {
  return FIGHTER_TYPES[id as FighterTypeId] ?? BASIC
}
