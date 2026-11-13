import { get } from 'svelte/store'
import { describe, expect, it } from 'vitest'
import {
  ACCOUNTS_KEY,
  addAccount,
  createAccountsStore,
  currentAccount,
  loadAccounts,
  progressStore,
  renameAccount,
  switchAccount,
  type Accounts,
} from './accounts'
import { browserLanguage } from './i18n/languages'
import { PROGRESS_KEY, defaultProgress, memoryStorage, startProgress } from './progress'

function added(state: Accounts, name: string): Accounts {
  const result = addAccount(state, name, 'en')
  if (!result.ok) throw new Error(result.reason)
  return result.state
}

describe('accounts', () => {
  it('a new device starts with one new player called Player 1', () => {
    const state = loadAccounts(memoryStorage(), 'it')
    expect(state.accounts).toHaveLength(1)
    expect(currentAccount(state)).toMatchObject({ name: 'Player 1', language: 'it', progress: startProgress() })
  })

  it('the progress saved before accounts becomes Player 1, nothing lost', () => {
    const storage = memoryStorage()
    const { createdFighter: _, ...v3 } = { ...defaultProgress(), credits: 1234, version: 3 }
    storage.setItem(PROGRESS_KEY, JSON.stringify(v3))
    const account = currentAccount(loadAccounts(storage, 'en'))
    expect(account.name).toBe('Player 1')
    expect(account.progress).toEqual({ ...defaultProgress(), credits: 1234 })
    expect(storage.getItem(PROGRESS_KEY)).not.toBeNull()
  })

  it('adds accounts up to 5 and refuses a sixth', () => {
    let state = loadAccounts(memoryStorage(), 'en')
    for (const name of ['Mattia', 'Luca', 'Sofia', 'Noah']) state = added(state, name)
    expect(state.accounts).toHaveLength(5)
    expect(currentAccount(state).name).toBe('Noah')
    expect(addAccount(state, 'Mia', 'en')).toEqual({ ok: false, reason: 'full' })
  })

  it.each([
    ['', 'empty'],
    ['   ', 'empty'],
    ['A'.repeat(17), 'long'],
    ['player 1', 'taken'],
  ])('refuses the name %j (%s)', (name, reason) => {
    expect(addAccount(loadAccounts(memoryStorage(), 'en'), name, 'en')).toEqual({ ok: false, reason })
  })

  it('accepts names of 1 and 16 characters, trimmed', () => {
    let state = added(loadAccounts(memoryStorage(), 'en'), ' X ')
    state = added(state, 'B'.repeat(16))
    expect(state.accounts.map((a) => a.name)).toEqual(['Player 1', 'X', 'B'.repeat(16)])
  })

  it('new accounts start fresh; switching shows the other progress', () => {
    const storage = memoryStorage()
    storage.setItem(PROGRESS_KEY, JSON.stringify(defaultProgress()))
    let state = added(loadAccounts(storage, 'en'), 'Mattia')
    expect(currentAccount(state).progress).toEqual(startProgress())
    state = switchAccount(state, 'a1')
    expect(currentAccount(state).progress.trophies.blaze).toBe(1240)
    expect(switchAccount(state, 'nope')).toBe(state)
  })

  it('renames with the same rules, keeping its own name allowed', () => {
    let state = added(loadAccounts(memoryStorage(), 'en'), 'Mattia')
    expect(renameAccount(state, 'a2', 'player 1')).toEqual({ ok: false, reason: 'taken' })
    const result = renameAccount(state, 'a2', 'MATTIA')
    expect(result.ok).toBe(true)
    if (result.ok) state = result.state
    expect(state.accounts[1].name).toBe('MATTIA')
  })

  it('keeps accounts, progress and the current account after closing', () => {
    const storage = memoryStorage()
    const store = createAccountsStore(storage, 'en')
    store.update((s) => added(s, 'Mattia'))
    const progress = progressStore(store)
    progress.update((p) => ({ ...p, credits: 77 }))
    const again = loadAccounts(storage, 'de')
    expect(again.current).toBe('a2')
    expect(currentAccount(again).progress.credits).toBe(77)
    expect(get(progressStore(createAccountsStore(storage, 'en'))).credits).toBe(77)
  })

  it('falls back to the old progress when the accounts are broken', () => {
    const storage = memoryStorage()
    storage.setItem(ACCOUNTS_KEY, '{"version":1,"current":"a1","accounts":[]}')
    expect(currentAccount(loadAccounts(storage, 'en')).progress).toEqual(startProgress())
  })
})

describe('browser language', () => {
  it.each([
    [['de-CH', 'en'], 'gsw'],
    [['de-DE'], 'de'],
    [['fr-FR', 'it-IT'], 'it'],
    [['es'], 'es'],
    [['fr'], 'en'],
    [[], 'en'],
  ])('%j gives %s', (list, language) => {
    expect(browserLanguage(list)).toBe(language)
  })
})
