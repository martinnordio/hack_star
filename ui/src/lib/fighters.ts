export type Rarity = 'Default' | 'Rare' | 'Super Rare' | 'Epic' | 'Mythic' | 'Legendary'
import type { FighterTypeId } from './game/types'
import type { TextKey } from './i18n/en'

export interface Skin {
  id: string
  name: string
  rarity: Rarity
}

export interface Fighter {
  id: string
  name: string
  rarity: Rarity
  type: FighterTypeId
  idea: string
  skins: Skin[]
  unlocked_at_start: boolean
}

export const RARITY_COLORS: Record<Rarity, string> = {
  Default: '#9aa5b1',
  Rare: '#5ad13a',
  'Super Rare': '#2f9bff',
  Epic: '#b64dff',
  Mythic: '#ff3b5c',
  Legendary: '#ffd23f',
}

export const RARITY_KEYS: Record<Rarity, TextKey> = {
  Default: 'rarity.Default',
  Rare: 'rarity.Rare',
  'Super Rare': 'rarity.Super Rare',
  Epic: 'rarity.Epic',
  Mythic: 'rarity.Mythic',
  Legendary: 'rarity.Legendary',
}

export async function loadFighters(): Promise<Fighter[]> {
  const response = await fetch('/api/fighters')
  if (!response.ok) throw new Error(`Could not load fighters (${response.status})`)
  return response.json()
}

/** Prestige 1 at 1000 trophies, 2 at 2000, … */
export function prestigeLevel(trophies: number): number {
  return Math.floor(Math.max(0, trophies) / 1000)
}
