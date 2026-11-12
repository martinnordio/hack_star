import { writable } from 'svelte/store'
import type { BotLevel } from './game/settings'

export const OPTIONS_KEY = 'hack-star.options'
export const BOT_COUNTS = [1, 2, 3, 4, 5] as const

/** What the player chose on the Settings screen. */
export interface Options {
  botLevel: BotLevel
  botCount: number
}

export function defaultOptions(): Options {
  return { botLevel: 'easy', botCount: 3 }
}

type KeyValueStorage = Pick<Storage, 'getItem' | 'setItem'>

const LEVELS: readonly string[] = ['easy', 'medium', 'hard']

/** Each bad or missing value falls back to its default. */
export function loadOptions(storage: KeyValueStorage): Options {
  const options = defaultOptions()
  try {
    const raw: unknown = JSON.parse(storage.getItem(OPTIONS_KEY) ?? 'null')
    if (typeof raw !== 'object' || raw === null) return options
    const o = raw as Record<string, unknown>
    if (typeof o.botLevel === 'string' && LEVELS.includes(o.botLevel)) options.botLevel = o.botLevel as BotLevel
    if ((BOT_COUNTS as readonly unknown[]).includes(o.botCount)) options.botCount = o.botCount as number
  } catch {
    // Unreadable: keep the defaults.
  }
  return options
}

export function saveOptions(storage: KeyValueStorage, options: Options): void {
  try {
    storage.setItem(OPTIONS_KEY, JSON.stringify(options))
  } catch {
    // Storage blocked: the choice lasts until the page is closed.
  }
}

function createOptionsStore(storage: KeyValueStorage) {
  const store = writable(loadOptions(storage))
  store.subscribe((options) => saveOptions(storage, options))
  return store
}

function memoryStorage(): KeyValueStorage {
  const items = new Map<string, string>()
  return {
    getItem: (key) => items.get(key) ?? null,
    setItem: (key, value) => void items.set(key, value),
  }
}

export const options = createOptionsStore(typeof window === 'undefined' ? memoryStorage() : window.localStorage)
