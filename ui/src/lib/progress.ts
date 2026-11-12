import { writable } from 'svelte/store'

export const PROGRESS_KEY = 'hack-star.progress'
export const PROGRESS_VERSION = 1

export interface Progress {
  version: typeof PROGRESS_VERSION
  /** Trophies per fighter id. */
  trophies: Record<string, number>
  unlockedFighters: string[]
  activeHacks: string[]
  selectedFighter: string | null
}

export function defaultProgress(): Progress {
  return {
    version: PROGRESS_VERSION,
    trophies: {},
    unlockedFighters: [],
    activeHacks: [],
    selectedFighter: null,
  }
}

type KeyValueStorage = Pick<Storage, 'getItem' | 'setItem'>

function isStringArray(value: unknown): value is string[] {
  return Array.isArray(value) && value.every((item) => typeof item === 'string')
}

function isProgress(value: unknown): value is Progress {
  if (typeof value !== 'object' || value === null) return false
  const p = value as Record<string, unknown>
  return (
    p.version === PROGRESS_VERSION &&
    typeof p.trophies === 'object' &&
    p.trophies !== null &&
    Object.values(p.trophies).every((n) => Number.isInteger(n) && (n as number) >= 0) &&
    isStringArray(p.unlockedFighters) &&
    isStringArray(p.activeHacks) &&
    (p.selectedFighter === null || typeof p.selectedFighter === 'string')
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
