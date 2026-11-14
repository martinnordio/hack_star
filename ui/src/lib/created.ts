import type { Fighter } from './fighters'
import { pay } from './game/economy'
import { SETTINGS } from './game/settings'
import { FIGHTER_TYPE_IDS, type FighterTypeId } from './game/types'
import { isHackActive, isUnlocked } from './hacks'
import { CREATED_ID, isCreatedFighterId, isCreatedLook, type CreatedLook, type Progress } from './progress'

export { CREATED_ID }
export const MAX_CREATED_NAME = 12
export const MAX_CREATED_FIGHTERS = 15

export const CREATED_COLORS = ['#e8322b', '#ff8a1a', '#ffd23f', '#39d353', '#2fb5ff', '#3a5bff', '#b64dff', '#ff5fa8'] as const
export const HEADS = [0, 1, 2] as const
export const BODIES = [0, 1, 2] as const

export type Look = Omit<CreatedLook, 'name'>

/**
 * The look travels as the fighter's skin id, so the 3D models, pictures and rooms work without
 * knowing about it: "L" + type + head + body (+ hands + legs) + two colours. Looks that older
 * versions can draw keep the 16-character form; others use 18 characters.
 */
export function lookSkin(look: Look): string {
  const type = FIGHTER_TYPE_IDS.indexOf(look.type)
  const colours = `${look.main.slice(1)}${look.second.slice(1)}`
  const short = look.hands === 0 && look.legs === 0 && look.head <= 2 && look.body <= 2
  return short
    ? `L${type}${look.head}${look.body}${colours}`
    : `L${type}${look.head}${look.body}${look.hands}${look.legs}${colours}`
}

export function parseLookSkin(skin: string): Look | null {
  const m =
    skin.length === 16
      ? /^L([0-4])([0-2])([0-2])()()([0-9a-f]{6})([0-9a-f]{6})$/i.exec(skin)
      : /^L([0-4])([0-4])([0-4])([0-2])([0-2])([0-9a-f]{6})([0-9a-f]{6})$/i.exec(skin)
  if (!m) return null
  return {
    type: FIGHTER_TYPE_IDS[Number(m[1])],
    head: Number(m[2]),
    body: Number(m[3]),
    hands: Number(m[4] || 0),
    legs: Number(m[5] || 0),
    main: `#${m[6]}`,
    second: `#${m[7]}`,
  }
}

export function createdFighter(look: CreatedLook, id = CREATED_ID): Fighter {
  return {
    id,
    name: look.name,
    rarity: 'Epic',
    type: look.type,
    idea: '',
    skins: [{ id: 'default', name: 'Default', rarity: 'Default' }],
    unlocked_at_start: false,
  }
}

export function createdLookFor(progress: Progress, fighterId: string): CreatedLook | undefined {
  return progress.createdFighters.find((fighter) => fighter.id === fighterId)?.look
}

export function canAddCreatedFighter(progress: Progress): boolean {
  return (
    progress.createdFighters.length < MAX_CREATED_FIGHTERS &&
    (progress.createdFighters.length === 0 || isHackActive(progress, 'creator'))
  )
}

export function nextCreatedFighterId(progress: Pick<Progress, 'createdFighters'>): string | undefined {
  const used = new Set(progress.createdFighters.map((fighter) => fighter.id))
  for (let number = 2; number <= MAX_CREATED_FIGHTERS; number++) {
    const id = `custom-${number}`
    if (!used.has(id)) return id
  }
  return undefined
}

/** The catalogue, with created fighters between unlocked and locked catalogue fighters. */
export function withCreated(fighters: Fighter[], progress: Progress): Fighter[] {
  const unlocked = fighters.filter((fighter) => isUnlocked(progress, fighter.id))
  const locked = fighters.filter((fighter) => !isUnlocked(progress, fighter.id))
  const created = progress.createdFighters.map(({ id, look }) => createdFighter(look, id))
  return [...unlocked, ...created, ...locked]
}

export function defaultLook(type: FighterTypeId = 'spreader'): CreatedLook {
  return { name: '', type, main: CREATED_COLORS[4], second: CREATED_COLORS[2], head: 0, body: 0, hands: 0, legs: 0 }
}

export type CreateResult =
  | { ok: true; progress: Progress; cost: number; fighterId: string }
  | { ok: false; reason: 'name' }
  | { ok: false; reason: 'creator' | 'inactive' | 'limit' | 'missing' }
  | { ok: false; reason: 'credits'; missing: number }

/** The price of creating the first fighter or changing/adding another one. */
export function createCost(progress: Progress, fighterId?: string, settings = SETTINGS): number {
  return fighterId || progress.createdFighters.length ? settings.recreateCost : 0
}

/** Creates or changes one fighter while preserving every other fighter's progress. */
export function saveCreated(progress: Progress, look: CreatedLook, fighterId?: string, settings = SETTINGS): CreateResult {
  const clean = { ...look, name: look.name.trim() }
  if (!isCreatedLook(clean)) return { ok: false, reason: 'name' }
  const editingIndex = fighterId ? progress.createdFighters.findIndex((fighter) => fighter.id === fighterId) : -1
  if (fighterId && editingIndex < 0) return { ok: false, reason: 'missing' }
  if (editingIndex > 0 && !isHackActive(progress, 'creator')) return { ok: false, reason: 'inactive' }

  if (!fighterId && !canAddCreatedFighter(progress)) {
    return progress.createdFighters.length >= MAX_CREATED_FIGHTERS
      ? { ok: false, reason: 'limit' }
      : { ok: false, reason: 'creator' }
  }

  const cost = createCost(progress, fighterId, settings)
  const paid = pay(progress, cost)
  if ('ok' in paid) return paid as CreateResult
  const id = fighterId ?? (paid.createdFighters.length ? nextCreatedFighterId(paid) : CREATED_ID)
  if (!id) return { ok: false, reason: 'limit' }
  const createdFighters = editingIndex >= 0
    ? paid.createdFighters.map((fighter, index) => index === editingIndex ? { ...fighter, look: clean } : fighter)
    : [...paid.createdFighters, { id, look: clean, skins: [] }]
  return { ok: true, cost, progress: { ...paid, createdFighters }, fighterId: id }
}
