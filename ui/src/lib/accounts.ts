import { derived, writable, type Readable } from 'svelte/store'
import { browserLanguage, isLanguage, type Language } from './i18n/languages'
import { PROGRESS_KEY, parseProgress, startProgress, type Progress } from './progress'

export const ACCOUNTS_KEY = 'hack-star.accounts'
export const MAX_ACCOUNTS = 5
export const MAX_NAME = 16
export const FIRST_NAME = 'Player 1'

export interface Account {
  id: string
  name: string
  language: Language
  progress: Progress
}

export interface Accounts {
  version: 1
  current: string
  accounts: Account[]
}

export type NameProblem = 'empty' | 'long' | 'taken' | 'full'
export type AccountsChange = { ok: true; state: Accounts } | { ok: false; reason: NameProblem }

type KeyValueStorage = Pick<Storage, 'getItem' | 'setItem'>

function newId(state: Accounts): string {
  let n = state.accounts.length + 1
  while (state.accounts.some((a) => a.id === `a${n}`)) n++
  return `a${n}`
}

export function currentAccount(state: Accounts): Account {
  return state.accounts.find((a) => a.id === state.current) ?? state.accounts[0]
}

/** Why a name cannot be used, or `null`; `exceptId` is the account being renamed. */
export function nameProblem(state: Accounts, name: string, exceptId?: string): NameProblem | null {
  const trimmed = name.trim()
  if (!trimmed) return 'empty'
  if (trimmed.length > MAX_NAME) return 'long'
  const lower = trimmed.toLowerCase()
  if (state.accounts.some((a) => a.id !== exceptId && a.name.toLowerCase() === lower)) return 'taken'
  return null
}

/** Adds an account and makes it the current one. */
export function addAccount(state: Accounts, name: string, language: Language): AccountsChange {
  if (state.accounts.length >= MAX_ACCOUNTS) return { ok: false, reason: 'full' }
  const problem = nameProblem(state, name)
  if (problem) return { ok: false, reason: problem }
  const account: Account = { id: newId(state), name: name.trim(), language, progress: startProgress() }
  return { ok: true, state: { ...state, current: account.id, accounts: [...state.accounts, account] } }
}

export function renameAccount(state: Accounts, id: string, name: string): AccountsChange {
  const problem = nameProblem(state, name, id)
  if (problem) return { ok: false, reason: problem }
  return { ok: true, state: updateAccount(state, id, (a) => ({ ...a, name: name.trim() })) }
}

export function switchAccount(state: Accounts, id: string): Accounts {
  return state.accounts.some((a) => a.id === id) ? { ...state, current: id } : state
}

export function updateAccount(state: Accounts, id: string, change: (account: Account) => Account): Accounts {
  return { ...state, accounts: state.accounts.map((a) => (a.id === id ? change(a) : a)) }
}

export function withProgress(state: Accounts, progress: Progress): Accounts {
  return updateAccount(state, currentAccount(state).id, (a) => ({ ...a, progress }))
}

function firstAccounts(progress: Progress, language: Language): Accounts {
  return { version: 1, current: 'a1', accounts: [{ id: 'a1', name: FIRST_NAME, language, progress }] }
}

function parseAccount(value: unknown): Account | null {
  if (typeof value !== 'object' || value === null) return null
  const a = value as Record<string, unknown>
  const progress = parseProgress(a.progress)
  if (typeof a.id !== 'string' || typeof a.name !== 'string' || !isLanguage(a.language) || !progress) return null
  return { id: a.id, name: a.name, language: a.language, progress }
}

function parseAccounts(value: unknown): Accounts | null {
  if (typeof value !== 'object' || value === null) return null
  const s = value as Record<string, unknown>
  if (s.version !== 1 || typeof s.current !== 'string' || !Array.isArray(s.accounts)) return null
  const accounts = s.accounts.map(parseAccount).filter((a): a is Account => a !== null).slice(0, MAX_ACCOUNTS)
  if (accounts.length === 0) return null
  const current = accounts.some((a) => a.id === s.current) ? s.current : accounts[0].id
  return { version: 1, current, accounts }
}

function readJson(storage: KeyValueStorage, key: string): unknown {
  try {
    return JSON.parse(storage.getItem(key) ?? 'null')
  } catch {
    return null
  }
}

/**
 * The saved accounts; the first time, the progress saved before accounts existed becomes
 * "Player 1" (its old key is left in place), otherwise a new player starts.
 */
export function loadAccounts(storage: KeyValueStorage, language: Language): Accounts {
  const saved = parseAccounts(readJson(storage, ACCOUNTS_KEY))
  if (saved) return saved
  const old = parseProgress(readJson(storage, PROGRESS_KEY))
  return firstAccounts(old ?? startProgress(), language)
}

export function saveAccounts(storage: KeyValueStorage, state: Accounts): void {
  try {
    storage.setItem(ACCOUNTS_KEY, JSON.stringify(state))
  } catch {
    // Storage full or blocked (private browsing): the game keeps working without saving.
  }
}

export function createAccountsStore(storage: KeyValueStorage, language: Language) {
  const store = writable(loadAccounts(storage, language))
  store.subscribe((state) => saveAccounts(storage, state))
  return store
}

type AccountsStore = ReturnType<typeof createAccountsStore>

/** The current account's progress, read and written like a normal store. */
export function progressStore(store: AccountsStore) {
  const current: Readable<Progress> = derived(store, (state) => currentAccount(state).progress)
  return {
    subscribe: current.subscribe,
    set: (progress: Progress) => store.update((state) => withProgress(state, progress)),
    update: (change: (progress: Progress) => Progress) =>
      store.update((state) => withProgress(state, change(currentAccount(state).progress))),
  }
}

function memoryStorage(): KeyValueStorage {
  const items = new Map<string, string>()
  return {
    getItem: (key) => items.get(key) ?? null,
    setItem: (key, value) => void items.set(key, value),
  }
}

const inBrowser = typeof window !== 'undefined'

export const accounts = createAccountsStore(
  inBrowser ? window.localStorage : memoryStorage(),
  browserLanguage(inBrowser ? navigator.languages : []),
)

export const progress = progressStore(accounts)
