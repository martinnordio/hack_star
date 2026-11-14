import { derived, writable, type Readable } from 'svelte/store'
import { nextCreatedFighterId } from './created'
import { SETTINGS } from './game/settings'
import { isHackActive } from './hacks'
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

interface SyncTarget {
  addEventListener(type: 'storage', listener: (event: Event) => void): void
  removeEventListener(type: 'storage', listener: (event: Event) => void): void
  document: {
    visibilityState: DocumentVisibilityState
    addEventListener(type: 'visibilitychange', listener: () => void): void
    removeEventListener(type: 'visibilitychange', listener: () => void): void
  }
}

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

function same(a: unknown, b: unknown): boolean {
  return JSON.stringify(a) === JSON.stringify(b)
}

function mergeStringArray(base: string[], local: string[], remote: string[]): string[] {
  const removed = new Set(base.filter((value) => !local.includes(value)))
  const added = local.filter((value) => !base.includes(value))
  return [...remote.filter((value) => !removed.has(value)), ...added.filter((value) => !remote.includes(value))]
}

function mergeMap<T>(
  base: Record<string, T>,
  local: Record<string, T>,
  remote: Record<string, T>,
  mergeValue: (base: T, local: T, remote: T) => T = (_base, localValue) => localValue,
): Record<string, T> {
  const merged = { ...remote }
  for (const key of new Set([...Object.keys(base), ...Object.keys(local)])) {
    const hadBase = Object.hasOwn(base, key)
    const hasLocal = Object.hasOwn(local, key)
    if (hadBase === hasLocal && same(base[key], local[key])) continue
    if (!hasLocal) delete merged[key]
    else {
      merged[key] = hadBase && Object.hasOwn(remote, key)
        ? mergeValue(base[key], local[key], remote[key])
        : local[key]
    }
  }
  return merged
}

function mergeCreatedFighters(
  base: Progress['createdFighters'],
  local: Progress['createdFighters'],
  remote: Progress['createdFighters'],
  creatorActive: boolean,
  infiniteCredits: boolean,
  availableCredits: number,
) {
  const merged = [...remote]
  let acceptedLocalCost = 0
  let remainingCredits = availableCredits
  for (const original of base) {
    const localFighter = local.find((fighter) => fighter.id === original.id)
    const index = merged.findIndex((fighter) => fighter.id === original.id)
    if (!localFighter) {
      if (index >= 0) merged.splice(index, 1)
    } else if (!same(original, localFighter)) {
      const remoteFighter = index >= 0 ? merged[index] : original
      const fighter = same(localFighter.look, original.look)
        ? { ...remoteFighter, look: remoteFighter.look }
        : { ...remoteFighter, look: localFighter.look }
      if (index >= 0) merged[index] = fighter
      else merged.push(fighter)
    }
  }
  for (const fighter of local) {
    if (!base.some((original) => original.id === fighter.id)) {
      const index = merged.findIndex((existing) => existing.id === fighter.id)
      const needsCreator = merged.length > 0
      const cost = needsCreator && !infiniteCredits ? SETTINGS.recreateCost : 0
      const id = index >= 0 ? nextCreatedFighterId({ createdFighters: merged }) : fighter.id
      if (
        (needsCreator && !creatorActive) ||
        !id ||
        (cost > 0 && cost > remainingCredits)
      ) {
        continue
      }
      merged.push({ ...fighter, id })
      remainingCredits -= cost
      acceptedLocalCost += cost
    }
  }
  return { fighters: merged, acceptedLocalCost }
}

function mergeProgress(base: Progress, local: Progress, remote: Progress): Progress {
  const merged: Progress = { ...remote }
  let rejectedCreationRefund = 0
  if (local.selectedFighter !== base.selectedFighter) merged.selectedFighter = local.selectedFighter
  if (!same(base.trophies, local.trophies)) merged.trophies = mergeMap(base.trophies, local.trophies, remote.trophies)
  if (!same(base.powerLevels, local.powerLevels)) merged.powerLevels = mergeMap(base.powerLevels, local.powerLevels, remote.powerLevels)
  if (!same(base.hackExpiries, local.hackExpiries)) merged.hackExpiries = mergeMap(base.hackExpiries, local.hackExpiries, remote.hackExpiries)
  if (!same(base.selectedSkins, local.selectedSkins)) merged.selectedSkins = mergeMap(base.selectedSkins, local.selectedSkins, remote.selectedSkins)
  if (!same(base.ownedSkins, local.ownedSkins)) {
    merged.ownedSkins = mergeMap(base.ownedSkins, local.ownedSkins, remote.ownedSkins, mergeStringArray)
  }
  if (!same(base.unlockedFighters, local.unlockedFighters)) {
    merged.unlockedFighters = mergeStringArray(base.unlockedFighters, local.unlockedFighters, remote.unlockedFighters)
  }
  if (!same(base.activeHacks, local.activeHacks)) {
    merged.activeHacks = mergeStringArray(base.activeHacks, local.activeHacks, remote.activeHacks)
  }
  if (!same(base.createdFighters, local.createdFighters)) {
    const localAdds = local.createdFighters.filter((fighter) => !base.createdFighters.some((original) => original.id === fighter.id))
    const localCreationCost = isHackActive(local, 'infinite_credits')
      ? 0
      : Math.max(0, localAdds.length - Number(base.createdFighters.length === 0)) * SETTINGS.recreateCost
    const availableCredits = remote.credits + local.credits - base.credits + localCreationCost
    const created = mergeCreatedFighters(
      base.createdFighters,
      local.createdFighters,
      remote.createdFighters,
      isHackActive(merged, 'creator'),
      isHackActive(merged, 'infinite_credits'),
      availableCredits,
    )
    merged.createdFighters = created.fighters
    rejectedCreationRefund = localCreationCost - created.acceptedLocalCost
  }
  if (local.credits !== base.credits || rejectedCreationRefund !== 0) {
    merged.credits = Math.max(0, remote.credits + local.credits - base.credits + rejectedCreationRefund)
  }
  return merged
}

function mergeAccount(base: Account, local: Account, remote: Account): Account {
  return {
    ...remote,
    name: local.name === base.name ? remote.name : local.name,
    language: local.language === base.language ? remote.language : local.language,
    progress: mergeProgress(base.progress, local.progress, remote.progress),
  }
}

function mergeAccounts(base: Accounts, local: Accounts, remote: Accounts): Accounts {
  const merged = [...remote.accounts]
  for (const original of base.accounts) {
    const localAccount = local.accounts.find((account) => account.id === original.id)
    const index = merged.findIndex((account) => account.id === original.id)
    if (!localAccount) {
      if (index >= 0) merged.splice(index, 1)
    } else if (!same(original, localAccount)) {
      const account = mergeAccount(original, localAccount, index >= 0 ? merged[index] : original)
      if (index >= 0) merged[index] = account
      else merged.push(account)
    }
  }
  for (const account of local.accounts) {
    if (!base.accounts.some((original) => original.id === account.id)) {
      const index = merged.findIndex((existing) => existing.id === account.id)
      if (index >= 0) merged[index] = account
      else merged.push(account)
    }
  }
  return {
    version: 1,
    current: local.current === base.current ? remote.current : local.current,
    accounts: merged.slice(0, MAX_ACCOUNTS),
  }
}

export function createAccountsStore(storage: KeyValueStorage, language: Language, target?: SyncTarget) {
  const initial = loadAccounts(storage, language)
  saveAccounts(storage, initial)
  const store = writable(initial)
  let base = initial
  let syncedState: Accounts | null = null
  const unsubscribe = store.subscribe((state) => {
    if (syncedState && same(state, syncedState)) {
      syncedState = null
      return
    }
    const latest = loadAccounts(storage, language)
    const merged = mergeAccounts(base, state, latest)
    if (!same(merged, latest)) saveAccounts(storage, merged)
    base = merged
    if (!same(state, merged)) {
      syncedState = merged
      store.set(merged)
    }
  })

  function refresh(): void {
    const latest = loadAccounts(storage, language)
    if (same(latest, base)) return
    base = latest
    store.set(latest)
  }

  const onStorage = (event: Event) => {
    if ((event as StorageEvent).key === ACCOUNTS_KEY) refresh()
  }
  const onVisibilityChange = () => {
    if (target?.document.visibilityState === 'visible') refresh()
  }
  target?.addEventListener('storage', onStorage)
  target?.document.addEventListener('visibilitychange', onVisibilityChange)

  return {
    subscribe: store.subscribe,
    set: store.set,
    update: store.update,
    refresh,
    destroy() {
      unsubscribe()
      target?.removeEventListener('storage', onStorage)
      target?.document.removeEventListener('visibilitychange', onVisibilityChange)
    },
  }
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
  inBrowser ? window : undefined,
)

export const progress = progressStore(accounts)
