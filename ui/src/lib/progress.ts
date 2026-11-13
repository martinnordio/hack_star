import type { FighterTypeId } from './game/types'

export const PROGRESS_KEY = 'hack-star.progress'
export const PROGRESS_VERSION = 4

/** The look of the fighter the player designs (create a fighter). */
export interface CreatedLook {
  name: string
  type: FighterTypeId
  main: string
  second: string
  head: number
  body: number
}

export interface Progress {
  version: typeof PROGRESS_VERSION
  credits: number
  /** Trophies per fighter id. */
  trophies: Record<string, number>
  powerLevels: Record<string, number>
  unlockedFighters: string[]
  activeHacks: string[]
  selectedFighter: string | null
  /** Chosen skin id per fighter id; missing means the default skin. */
  selectedSkins: Record<string, string>
  /** Bought skin ids per fighter id; the default skin is always owned. */
  ownedSkins: Record<string, string[]>
  createdFighter: CreatedLook | null
}

/** Fighters every new account starts with. */
export const START_FIGHTERS = ['blaze', 'rocko', 'turbo']
export const START_CREDITS = 500
/** The created fighter has this id in every account (one per account). */
export const CREATED_ID = 'custom'

/** The progress of a brand-new account. */
export function startProgress(): Progress {
  return {
    version: PROGRESS_VERSION,
    credits: START_CREDITS,
    trophies: {},
    powerLevels: {},
    unlockedFighters: [...START_FIGHTERS],
    activeHacks: [],
    selectedFighter: START_FIGHTERS[0],
    selectedSkins: {},
    ownedSkins: {},
    createdFighter: null,
  }
}

/** Settings reset: back to the start with 0 credits; hack codes and the created fighter stay. */
export function resetProgress(progress: Progress): Progress {
  return {
    ...startProgress(),
    credits: 0,
    activeHacks: [...progress.activeHacks],
    createdFighter: progress.createdFighter,
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
    selectedFighter: 'blaze',
    selectedSkins: {},
    ownedSkins: {},
    createdFighter: null,
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

export function isCreatedLook(value: unknown): value is CreatedLook {
  if (typeof value !== 'object' || value === null) return false
  const l = value as Record<string, unknown>
  return (
    typeof l.name === 'string' &&
    l.name.trim().length >= 1 &&
    l.name.length <= 12 &&
    typeof l.type === 'string' &&
    TYPES.includes(l.type) &&
    typeof l.main === 'string' &&
    COLOR.test(l.main) &&
    typeof l.second === 'string' &&
    COLOR.test(l.second) &&
    [0, 1, 2].includes(l.head as number) &&
    [0, 1, 2].includes(l.body as number)
  )
}

function isProgress(value: unknown): value is Progress {
  if (typeof value !== 'object' || value === null) return false
  const p = value as Record<string, unknown>
  return (
    p.version === PROGRESS_VERSION &&
    isProgressFields(p) &&
    isOwnedSkins(p.ownedSkins) &&
    (p.createdFighter === null || isCreatedLook(p.createdFighter))
  )
}

/** Version 3 (before accounts): no created fighter yet. */
function migrateV3(value: unknown): Progress | null {
  if (typeof value !== 'object' || value === null) return null
  const p = value as Record<string, unknown>
  if (p.version !== 3 || !isProgressFields(p) || !isOwnedSkins(p.ownedSkins)) return null
  return { ...(p as unknown as Omit<Progress, 'version' | 'createdFighter'>), version: PROGRESS_VERSION, createdFighter: null }
}

/** Version 2 (before the skins shop): every skin it had selected becomes owned. */
function migrateV2(value: unknown): Progress | null {
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
export function parseProgress(value: unknown): Progress | null {
  return isProgress(value) ? value : (migrateV3(value) ?? migrateV2(value))
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
