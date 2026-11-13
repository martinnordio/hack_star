import type { Fighter } from './fighters'
import { pay } from './game/economy'
import { SETTINGS } from './game/settings'
import { FIGHTER_TYPE_IDS, type FighterTypeId } from './game/types'
import { CREATED_ID, isCreatedLook, type CreatedLook, type Progress } from './progress'

export { CREATED_ID }
export const MAX_CREATED_NAME = 12

export const CREATED_COLORS = ['#e8322b', '#ff8a1a', '#ffd23f', '#39d353', '#2fb5ff', '#3a5bff', '#b64dff', '#ff5fa8'] as const
export const HEADS = [0, 1, 2] as const
export const BODIES = [0, 1, 2] as const

export type Look = Omit<CreatedLook, 'name'>

/**
 * The look travels as the fighter's skin id ("L" + type + head + body + two colours, 16
 * characters), so the 3D models, pictures and rooms work without knowing about it.
 */
export function lookSkin(look: Look): string {
  return `L${FIGHTER_TYPE_IDS.indexOf(look.type)}${look.head}${look.body}${look.main.slice(1)}${look.second.slice(1)}`
}

export function parseLookSkin(skin: string): Look | null {
  const m = /^L([0-4])([0-2])([0-2])([0-9a-f]{6})([0-9a-f]{6})$/i.exec(skin)
  if (!m) return null
  return { type: FIGHTER_TYPE_IDS[Number(m[1])], head: Number(m[2]), body: Number(m[3]), main: `#${m[4]}`, second: `#${m[5]}` }
}

export function createdFighter(look: CreatedLook): Fighter {
  return {
    id: CREATED_ID,
    name: look.name,
    rarity: 'Epic',
    type: look.type,
    idea: '',
    skins: [{ id: 'default', name: 'Default', rarity: 'Default' }],
    unlocked_at_start: false,
  }
}

/** The catalogue plus the account's created fighter, if it has one. */
export function withCreated(fighters: Fighter[], progress: Progress): Fighter[] {
  return progress.createdFighter ? [...fighters, createdFighter(progress.createdFighter)] : fighters
}

export function defaultLook(type: FighterTypeId = 'spreader'): CreatedLook {
  return { name: '', type, main: CREATED_COLORS[4], second: CREATED_COLORS[2], head: 0, body: 0 }
}

export type CreateResult =
  | { ok: true; progress: Progress; cost: number }
  | { ok: false; reason: 'name' }
  | { ok: false; reason: 'credits'; missing: number }

/** The price of saving `look`: free the first time, `recreateCost` for every change after. */
export function createCost(progress: Progress, settings = SETTINGS): number {
  return progress.createdFighter ? settings.recreateCost : 0
}

/** Creates or changes the created fighter; it keeps its trophies, power level and lock. */
export function saveCreated(progress: Progress, look: CreatedLook, settings = SETTINGS): CreateResult {
  const clean = { ...look, name: look.name.trim() }
  if (!isCreatedLook(clean)) return { ok: false, reason: 'name' }
  const cost = createCost(progress, settings)
  const paid = pay(progress, cost)
  if ('ok' in paid) return paid as CreateResult
  return { ok: true, cost, progress: { ...paid, createdFighter: clean } }
}
