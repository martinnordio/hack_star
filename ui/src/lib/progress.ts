import type { FighterTypeId } from './game/types'
import { SETTINGS } from './game/settings'
import { WORLDS, isWorldSize, type WorldId, type WorldSize } from './game/worlds'

export const PROGRESS_KEY = 'hack-star.progress'
export const PROGRESS_VERSION = 8
export const TEMPORARY_HACK_SECONDS = 72 * 60 * 60
const PERMANENT_HACKS = new Set(['power22'])

/** The look of the fighter the player designs (create a fighter). */
export interface CreatedLook {
  name: string
  type: FighterTypeId
  main: string
  second: string
  head: number
  body: number
  /** 0 is the body's own hands. */
  hands: number
  /** 0 is the body's own legs. */
  legs: number
}

/** A skin the player made for a created fighter: its own colours and parts, same type and name. */
export interface CreatedSkin {
  id: string
  main: string
  second: string
  head: number
  body: number
  hands: number
  legs: number
}

export interface CreatedFighter {
  id: string
  look: CreatedLook
  skins: CreatedSkin[]
}

export const PART_COUNTS = { head: 5, body: 5, hands: 3, legs: 3 } as const
export const MAX_CREATED_SKINS = 5
const CREATED_SKIN_ID = /^s[1-5]$/

export interface Progress {
  version: typeof PROGRESS_VERSION
  credits: number
  /** Trophies per fighter id. */
  trophies: Record<string, number>
  powerLevels: Record<string, number>
  unlockedFighters: string[]
  activeHacks: string[]
  /** Expiry timestamp per active hack; null means permanent. */
  hackExpiries: Record<string, number | null>
  selectedFighter: string | null
  /** Chosen skin id per fighter id; missing means the default skin. */
  selectedSkins: Record<string, string>
  /** Bought skin ids per fighter id; the default skin is always owned. */
  ownedSkins: Record<string, string[]>
  createdFighters: CreatedFighter[]
  worldCoins: number
  /** 500-trophy steps already paid in world coins; each step pays only once. */
  worldSteps: number
  /** The biggest unlocked size per world id; a world that is not here is locked. */
  worlds: Record<string, WorldSize>
  selectedWorld: WorldChoice
  /** When each used world-coin code (by its id) works again, as a timestamp. */
  worldCodes: Record<string, number>
}

export interface WorldChoice {
  id: string
  size: WorldSize
}

/** Fighters every new account starts with (the server's `unlocked_at_start`). */
export const START_FIGHTERS = ['blaze', 'rocko', 'turbo', 'marina']
export const START_CREDITS = 500
/** The original created fighter keeps this id so existing selections and room links still work. */
export const CREATED_ID = 'custom'
export const START_WORLD: { id: WorldId; size: WorldSize } = { id: 'canyon', size: 'small' }

type WorldFields = Pick<Progress, 'worldCoins' | 'worldSteps' | 'worlds' | 'selectedWorld' | 'worldCodes'>

/**
 * The world part of a save from before worlds (and of a new account, with 0 trophies): the
 * free worlds in Small, Canyon Small chosen, and the world coins for every 500-step reached.
 */
function startWorlds(trophies = 0): WorldFields {
  const worldSteps = Math.floor(trophies / SETTINGS.trophiesPerWorldStep)
  return {
    worldCoins: worldSteps * SETTINGS.worldCoinsPerStep,
    worldSteps,
    worlds: Object.fromEntries(WORLDS.filter((w) => w.free).map((w) => [w.id, 'small'])),
    selectedWorld: { ...START_WORLD },
    worldCodes: {},
  }
}

export function isCreatedFighterId(id: string): boolean {
  return /^custom(?:-(?:[2-9]|1[0-5]))?$/.test(id)
}

/** The progress of a brand-new account. */
export function startProgress(): Progress {
  return {
    version: PROGRESS_VERSION,
    credits: START_CREDITS,
    trophies: {},
    powerLevels: {},
    unlockedFighters: [...START_FIGHTERS],
    activeHacks: [],
    hackExpiries: {},
    selectedFighter: START_FIGHTERS[0],
    selectedSkins: {},
    ownedSkins: {},
    createdFighters: [],
    ...startWorlds(),
  }
}

/**
 * Settings reset: back to the start with 0 credits, no world coins, only the free worlds and
 * no used world-coin codes; hack codes and the created fighter stay.
 */
export function resetProgress(progress: Progress): Progress {
  return {
    ...startProgress(),
    credits: 0,
    activeHacks: [...progress.activeHacks],
    hackExpiries: { ...progress.hackExpiries },
    createdFighters: progress.createdFighters.map((fighter) => ({
      ...fighter,
      look: { ...fighter.look },
      skins: fighter.skins.map((skin) => ({ ...skin })),
    })),
  }
}

/** Sample progress of the first versions (basic UI spec S8); used by tests. */
export function defaultProgress(): Progress {
  return {
    version: PROGRESS_VERSION,
    credits: 500,
    trophies: { blaze: 1240, rocko: 420, turbo: 85 },
    powerLevels: { blaze: 7, rocko: 4, turbo: 2 },
    unlockedFighters: ['blaze', 'rocko', 'turbo'],
    activeHacks: [],
    hackExpiries: {},
    selectedFighter: 'blaze',
    selectedSkins: {},
    ownedSkins: {},
    createdFighters: [],
    ...startWorlds(1240 + 420 + 85),
  }
}

type KeyValueStorage = Pick<Storage, 'getItem' | 'setItem'>

function isStringArray(value: unknown): value is string[] {
  return Array.isArray(value) && value.every((item) => typeof item === 'string')
}

function isCountMap(value: unknown): value is Record<string, number> {
  return (
    typeof value === 'object' &&
    value !== null &&
    Object.values(value).every((n) => Number.isInteger(n) && n >= 0)
  )
}

function isStringMap(value: unknown): value is Record<string, string> {
  return (
    typeof value === 'object' &&
    value !== null &&
    Object.values(value).every((s) => typeof s === 'string')
  )
}

function isHackExpiryMap(value: unknown): value is Record<string, number | null> {
  return (
    typeof value === 'object' &&
    value !== null &&
    Object.values(value).every((expiry) => expiry === null || (Number.isSafeInteger(expiry) && expiry >= 0))
  )
}

function isCreatedFighters(value: unknown): value is CreatedFighter[] {
  return (
    Array.isArray(value) &&
    value.every(
      (fighter) =>
        typeof fighter === 'object' &&
        fighter !== null &&
        typeof fighter.id === 'string' &&
        isCreatedFighterId(fighter.id) &&
        isCreatedLook(fighter.look) &&
        isCreatedSkins(fighter.skins),
    ) &&
    hasUniqueFirstCreated(value)
  )
}

function hasUniqueFirstCreated(value: { id: string }[]): boolean {
  return new Set(value.map((fighter) => fighter.id)).size === value.length && (value.length === 0 || value[0].id === CREATED_ID)
}

function isCreatedSkins(value: unknown): value is CreatedSkin[] {
  return (
    Array.isArray(value) &&
    value.length <= MAX_CREATED_SKINS &&
    value.every((skin) => typeof skin === 'object' && skin !== null && typeof skin.id === 'string' && CREATED_SKIN_ID.test(skin.id) && isParts(skin)) &&
    new Set(value.map((skin) => skin.id)).size === value.length
  )
}

type CreatedFighterV6 = { id: string; look: Omit<CreatedLook, 'hands' | 'legs'> }

function isCreatedFightersV6(value: unknown): value is CreatedFighterV6[] {
  return (
    Array.isArray(value) &&
    value.every(
      (fighter) =>
        typeof fighter === 'object' &&
        fighter !== null &&
        typeof fighter.id === 'string' &&
        isCreatedFighterId(fighter.id) &&
        isCreatedLookV6(fighter.look),
    ) &&
    hasUniqueFirstCreated(value)
  )
}

function isProgressFields(p: Record<string, unknown>): boolean {
  return (
    Number.isInteger(p.credits) &&
    (p.credits as number) >= 0 &&
    isCountMap(p.trophies) &&
    isCountMap(p.powerLevels) &&
    isStringArray(p.unlockedFighters) &&
    isStringArray(p.activeHacks) &&
    (p.selectedFighter === null || typeof p.selectedFighter === 'string') &&
    isStringMap(p.selectedSkins)
  )
}

function isOwnedSkins(value: unknown): boolean {
  return typeof value === 'object' && value !== null && Object.values(value).every(isStringArray)
}

const TYPES: readonly string[] = ['tank', 'sharpshooter', 'speedy', 'thrower', 'spreader']
const COLOR = /^#[0-9a-f]{6}$/i

function isPart(value: unknown, count: number): boolean {
  return Number.isInteger(value) && (value as number) >= 0 && (value as number) < count
}

/** Colours and parts, shared by a look and a created skin. */
function isParts(l: Record<string, unknown>): boolean {
  return (
    typeof l.main === 'string' &&
    COLOR.test(l.main) &&
    typeof l.second === 'string' &&
    COLOR.test(l.second) &&
    isPart(l.head, PART_COUNTS.head) &&
    isPart(l.body, PART_COUNTS.body) &&
    isPart(l.hands, PART_COUNTS.hands) &&
    isPart(l.legs, PART_COUNTS.legs)
  )
}

function isNamedType(l: Record<string, unknown>): boolean {
  return (
    typeof l.name === 'string' &&
    l.name.trim().length >= 1 &&
    l.name.length <= 12 &&
    typeof l.type === 'string' &&
    TYPES.includes(l.type)
  )
}

export function isCreatedLook(value: unknown): value is CreatedLook {
  if (typeof value !== 'object' || value === null) return false
  const l = value as Record<string, unknown>
  return isNamedType(l) && isParts(l)
}

/** A look saved before hands and legs existed (version 6 and older). */
function isCreatedLookV6(value: unknown): value is Omit<CreatedLook, 'hands' | 'legs'> {
  if (typeof value !== 'object' || value === null) return false
  const l = value as Record<string, unknown>
  return (
    isNamedType(l) &&
    typeof l.main === 'string' &&
    COLOR.test(l.main) &&
    typeof l.second === 'string' &&
    COLOR.test(l.second) &&
    [0, 1, 2].includes(l.head as number) &&
    [0, 1, 2].includes(l.body as number) &&
    l.hands === undefined &&
    l.legs === undefined
  )
}

function isProgress(value: unknown): value is Progress {
  if (typeof value !== 'object' || value === null) return false
  const p = value as Record<string, unknown>
  return (
    p.version === PROGRESS_VERSION &&
    isProgressFields(p) &&
    isOwnedSkins(p.ownedSkins) &&
    isHackExpiryMap(p.hackExpiries) &&
    p.createdFighter === undefined &&
    isCreatedFighters(p.createdFighters) &&
    isWorldFields(p)
  )
}

function isWorldFields(p: Record<string, unknown>): boolean {
  const selected = p.selectedWorld as Record<string, unknown> | null | undefined
  return (
    Number.isSafeInteger(p.worldCoins) &&
    (p.worldCoins as number) >= 0 &&
    Number.isSafeInteger(p.worldSteps) &&
    (p.worldSteps as number) >= 0 &&
    typeof p.worlds === 'object' &&
    p.worlds !== null &&
    Object.values(p.worlds).every(isWorldSize) &&
    typeof selected === 'object' &&
    selected !== null &&
    typeof selected.id === 'string' &&
    isWorldSize(selected.size) &&
    typeof p.worldCodes === 'object' &&
    p.worldCodes !== null &&
    Object.values(p.worldCodes).every((at) => Number.isSafeInteger(at) && at >= 0)
  )
}

type ProgressV7 = Omit<Progress, 'version' | keyof WorldFields> & { version: 7 }

function isProgressV7(value: unknown): value is ProgressV7 {
  if (typeof value !== 'object' || value === null) return false
  const p = value as Record<string, unknown>
  return (
    p.version === 7 &&
    isProgressFields(p) &&
    isOwnedSkins(p.ownedSkins) &&
    isHackExpiryMap(p.hackExpiries) &&
    p.createdFighter === undefined &&
    isCreatedFighters(p.createdFighters)
  )
}

type ProgressV6 = Omit<ProgressV7, 'version' | 'createdFighters'> & { version: 6; createdFighters: CreatedFighterV6[] }

function isProgressV6(value: unknown): value is ProgressV6 {
  if (typeof value !== 'object' || value === null) return false
  const p = value as Record<string, unknown>
  return (
    p.version === 6 &&
    isProgressFields(p) &&
    isOwnedSkins(p.ownedSkins) &&
    isHackExpiryMap(p.hackExpiries) &&
    p.createdFighter === undefined &&
    isCreatedFightersV6(p.createdFighters)
  )
}

type ProgressV5 = Omit<ProgressV7, 'version' | 'createdFighters'> & { version: 5; createdFighter: CreatedFighterV6['look'] | null }

function isProgressV5(value: unknown): value is ProgressV5 {
  if (typeof value !== 'object' || value === null) return false
  const p = value as Record<string, unknown>
  return (
    p.version === 5 &&
    isProgressFields(p) &&
    isOwnedSkins(p.ownedSkins) &&
    isHackExpiryMap(p.hackExpiries) &&
    (p.createdFighter === null || isCreatedLookV6(p.createdFighter))
  )
}

type ProgressV4 = Omit<ProgressV7, 'version' | 'hackExpiries' | 'createdFighters'> & { version: 4; createdFighter: CreatedFighterV6['look'] | null }

function isProgressV4(value: unknown): value is ProgressV4 {
  if (typeof value !== 'object' || value === null) return false
  const p = value as Record<string, unknown>
  return (
    p.version === 4 &&
    isProgressFields(p) &&
    isOwnedSkins(p.ownedSkins) &&
    (p.createdFighter === null || isCreatedLookV6(p.createdFighter))
  )
}

/** Version 7 to 8: the free worlds in Small, Canyon Small chosen, world coins for the 500-steps already reached. */
function migrateV7(progress: ProgressV7): Progress {
  const trophies = Object.values(progress.trophies).reduce((sum, n) => sum + n, 0)
  return { ...progress, version: PROGRESS_VERSION, ...startWorlds(trophies) }
}

/** Version 6 to 7: hands and legs 0 (the body's own, so every look stays the same) and no skins yet. */
function migrateV6(progress: ProgressV6): ProgressV7 {
  return {
    ...progress,
    version: 7,
    createdFighters: progress.createdFighters.map((fighter) => ({
      id: fighter.id,
      look: { ...fighter.look, hands: 0, legs: 0 },
      skins: [],
    })),
  }
}

function migrateV5(progress: ProgressV5): ProgressV6 {
  const { createdFighter, ...rest } = progress
  return {
    ...rest,
    version: 6,
    createdFighters: createdFighter ? [{ id: CREATED_ID, look: createdFighter }] : [],
  }
}

function migrateV4(progress: ProgressV4, now: number): ProgressV5 {
  return {
    ...progress,
    version: 5,
    hackExpiries: Object.fromEntries(
      progress.activeHacks.map((id) => [id, PERMANENT_HACKS.has(id) ? null : now + TEMPORARY_HACK_SECONDS * 1000]),
    ),
  }
}

/** Version 3 (before accounts): no created fighter yet. */
function migrateV3(value: unknown): ProgressV4 | null {
  if (typeof value !== 'object' || value === null) return null
  const p = value as Record<string, unknown>
  if (p.version !== 3 || !isProgressFields(p) || !isOwnedSkins(p.ownedSkins)) return null
  const { hackExpiries: _hackExpiries, ...legacy } = p
  return { ...(legacy as unknown as Omit<ProgressV4, 'version' | 'createdFighter'>), version: 4, createdFighter: null }
}

/** Version 2 (before the skins shop): every skin it had selected becomes owned. */
function migrateV2(value: unknown): ProgressV4 | null {
  if (typeof value !== 'object' || value === null) return null
  const p = value as Record<string, unknown>
  if (p.version !== 2 || !isProgressFields(p)) return null
  const selected = p.selectedSkins as Record<string, string>
  const ownedSkins = Object.fromEntries(
    Object.entries(selected)
      .filter(([, skin]) => skin !== 'default')
      .map(([fighter, skin]) => [fighter, [skin]]),
  )
  return migrateV3({ ...p, version: 3, ownedSkins })
}

/** A saved progress of any known version, or `null` when it is broken or unknown. */
export function parseProgress(value: unknown, now = Date.now()): Progress | null {
  if (isProgress(value)) return value
  if (isProgressV7(value)) return migrateV7(value)
  if (isProgressV6(value)) return migrateV7(migrateV6(value))
  if (isProgressV5(value)) return migrateV7(migrateV6(migrateV5(value)))
  const old = isProgressV4(value) ? value : (migrateV3(value) ?? migrateV2(value))
  return old ? migrateV7(migrateV6(migrateV5(migrateV4(old, now)))) : null
}

/** Older versions are migrated; missing, unreadable or unknown data falls back to a fresh start. */
export function loadProgress(storage: KeyValueStorage): Progress {
  try {
    const raw = storage.getItem(PROGRESS_KEY)
    if (raw === null) return defaultProgress()
    return parseProgress(JSON.parse(raw)) ?? defaultProgress()
  } catch {
    return defaultProgress()
  }
}

export function saveProgress(storage: KeyValueStorage, progress: Progress): void {
  try {
    storage.setItem(PROGRESS_KEY, JSON.stringify(progress))
  } catch {
    // Storage full or blocked (private browsing): the game keeps working without saving.
  }
}

export function memoryStorage(): KeyValueStorage {
  const items = new Map<string, string>()
  return {
    getItem: (key) => items.get(key) ?? null,
    setItem: (key, value) => void items.set(key, value),
  }
}

export function totalTrophies(p: Progress): number {
  return Object.values(p.trophies).reduce((sum, n) => sum + n, 0)
}
