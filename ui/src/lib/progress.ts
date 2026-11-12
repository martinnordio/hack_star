import { writable } from 'svelte/store'

export const PROGRESS_KEY = 'hack-star.progress'
export const PROGRESS_VERSION = 2

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
}

/** Sample start until matches give real trophies (basic UI spec S8). */
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

function isProgress(value: unknown): value is Progress {
  if (typeof value !== 'object' || value === null) return false
  const p = value as Record<string, unknown>
  return (
    p.version === PROGRESS_VERSION &&
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

/** Missing, unreadable or unknown-version data falls back to a fresh start. */
export function loadProgress(storage: KeyValueStorage): Progress {
  try {
    const raw = storage.getItem(PROGRESS_KEY)
    if (raw === null) return defaultProgress()
    const parsed: unknown = JSON.parse(raw)
    return isProgress(parsed) ? parsed : defaultProgress()
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

export function createProgressStore(storage: KeyValueStorage) {
  const store = writable(loadProgress(storage))
  store.subscribe((progress) => saveProgress(storage, progress))
  return store
}

export function memoryStorage(): KeyValueStorage {
  const items = new Map<string, string>()
  return {
    getItem: (key) => items.get(key) ?? null,
    setItem: (key, value) => void items.set(key, value),
  }
}

export const progress = createProgressStore(
  typeof window === 'undefined' ? memoryStorage() : window.localStorage,
)

export function totalTrophies(p: Progress): number {
  return Object.values(p.trophies).reduce((sum, n) => sum + n, 0)
}
