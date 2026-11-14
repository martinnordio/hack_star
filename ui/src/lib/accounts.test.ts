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
import { saveCreated } from './created'
import { browserLanguage } from './i18n/languages'
import { MAX_CREATED_FIGHTERS } from './created'
import { PROGRESS_KEY, defaultProgress, memoryStorage, startProgress } from './progress'

function added(state: Accounts, name: string): Accounts {
  const result = addAccount(state, name, 'en')
  if (!result.ok) throw new Error(result.reason)
  return result.state
}

function syncTarget() {
  const storageListeners = new Set<(event: Event) => void>()
  const visibilityListeners = new Set<() => void>()
  let visibilityState: DocumentVisibilityState = 'visible'
  const target = {
    addEventListener: (_type: 'storage', listener: (event: Event) => void) => storageListeners.add(listener),
    removeEventListener: (_type: 'storage', listener: (event: Event) => void) => storageListeners.delete(listener),
    document: {
      get visibilityState() { return visibilityState },
      addEventListener: (_type: 'visibilitychange', listener: () => void) => visibilityListeners.add(listener),
      removeEventListener: (_type: 'visibilitychange', listener: () => void) => visibilityListeners.delete(listener),
    },
  } as unknown as Window
  return {
    target,
    storageChanged() {
      for (const listener of storageListeners) listener({ key: ACCOUNTS_KEY } as StorageEvent as Event)
    },
    hide() {
      visibilityState = 'hidden'
      for (const listener of visibilityListeners) listener()
    },
    show() {
      visibilityState = 'visible'
      for (const listener of visibilityListeners) listener()
    },
  }
}

describe('accounts', () => {
  it('a new device starts with one new player called Player 1', () => {
    const state = loadAccounts(memoryStorage(), 'it')
    expect(state.accounts).toHaveLength(1)
    expect(currentAccount(state)).toMatchObject({ name: 'Player 1', language: 'it', progress: startProgress() })
  })

  it('the progress saved before accounts becomes Player 1, nothing lost', () => {
    const storage = memoryStorage()
    const { createdFighters: _createdFighters, hackExpiries: _hackExpiries, ...v3 } = {
      ...defaultProgress(),
      credits: 1234,
      version: 3,
    }
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

  it('a rename or switch reaches every listener at once and is saved', () => {
    const storage = memoryStorage()
    const store = createAccountsStore(storage, 'en')
    const shown: string[] = []
    const stop = store.subscribe((s) => shown.push(currentAccount(s).name))
    store.update((s) => added(s, 'Mattia'))
    expect(shown.at(-1)).toBe('Mattia')
    store.update((s) => {
      const result = renameAccount(s, 'a2', 'Noah')
      return result.ok ? result.state : s
    })
    expect(shown.at(-1)).toBe('Noah')
    store.update((s) => switchAccount(s, 'a1'))
    expect(shown.at(-1)).toBe('Player 1')
    expect(loadAccounts(storage, 'en').accounts.map((a) => a.name)).toEqual(['Player 1', 'Noah'])
    stop()
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

  it('merges stale tab writes and refreshes the right account on storage and visibility changes', () => {
    const storage = memoryStorage()
    const firstEvents = syncTarget()
    const secondEvents = syncTarget()
    const first = createAccountsStore(storage, 'en', firstEvents.target)
    const second = createAccountsStore(storage, 'en', secondEvents.target)
    const firstProgress = progressStore(first)
    const secondProgress = progressStore(second)
    const look = { name: 'Nova', type: 'tank' as const, main: '#ff0000', second: '#00ff00', head: 1, body: 2 }

    firstProgress.update((p) => ({
      ...p,
      credits: p.credits + 100,
      activeHacks: ['creator'],
      hackExpiries: { creator: Date.now() + 60_000 },
      createdFighters: [{ id: 'custom', look }],
    }))

    secondProgress.update((p) => ({ ...p, credits: p.credits + 50 }))
    firstEvents.storageChanged()

    expect(get(firstProgress)).toMatchObject({ activeHacks: ['creator'], credits: 650, createdFighters: [{ id: 'custom', look }] })
    expect(get(secondProgress)).toMatchObject({ activeHacks: ['creator'], credits: 650, createdFighters: [{ id: 'custom', look }] })

    first.update((state) => added(state, 'Mattia'))
    secondEvents.storageChanged()
    expect(currentAccount(get(first)).id).toBe('a2')
    expect(currentAccount(get(second)).id).toBe('a2')
    expect(get(secondProgress)).toMatchObject({ activeHacks: [], credits: 500, createdFighters: [] })

    firstProgress.update((p) => ({ ...p, credits: p.credits + 125, activeHacks: ['infinite_credits'] }))
    secondEvents.hide()
    expect(get(secondProgress)).toMatchObject({ activeHacks: [], credits: 500 })
    secondEvents.show()
    expect(get(secondProgress)).toMatchObject({ activeHacks: ['infinite_credits'], credits: 625 })

    first.destroy()
    second.destroy()
  })

  it('keeps both fighters when stale tabs create the same next fighter ID', () => {
    const values = new Map<string, string>()
    const storage = {
      getItem: (key: string) => values.get(key) ?? null,
      setItem: (key: string, value: string) => void values.set(key, value),
    }
    const seed = createAccountsStore(storage, 'en')
    progressStore(seed).update((progress) => ({
      ...progress,
      credits: 5000,
      activeHacks: ['creator'],
      hackExpiries: { creator: Date.now() + 60_000 },
      createdFighters: [{
        id: 'custom',
        look: { name: 'Original', type: 'tank', main: '#ff0000', second: '#00ff00', head: 0, body: 0 },
      }],
    }))
    seed.destroy()

    const first = createAccountsStore(storage, 'en')
    const second = createAccountsStore(storage, 'en')
    const firstProgress = progressStore(first)
    const secondProgress = progressStore(second)
    const alpha = { name: 'Alpha', type: 'tank' as const, main: '#ff0000', second: '#00ff00', head: 0, body: 0 }
    const beta = { ...alpha, name: 'Beta', main: '#0000ff' }

    firstProgress.update((progress) => {
      const result = saveCreated(progress, alpha)
      if (!result.ok) throw new Error(result.reason)
      return result.progress
    })
    secondProgress.update((progress) => {
      const result = saveCreated(progress, beta)
      if (!result.ok) throw new Error(result.reason)
      return result.progress
    })
    first.refresh()

    const saved = currentAccount(get(first)).progress
    expect(saved.createdFighters.map(({ id, look }) => ({ id, name: look.name }))).toEqual([
      { id: 'custom', name: 'Original' },
      { id: 'custom-2', name: 'Alpha' },
      { id: 'custom-3', name: 'Beta' },
    ])
    expect(saved.credits).toBe(4000)
    expect(get(secondProgress).createdFighters.map(({ id, look }) => ({ id, name: look.name }))).toEqual(
      saved.createdFighters.map(({ id, look }) => ({ id, name: look.name })),
    )

    first.destroy()
    second.destroy()
  })

  it('does not turn simultaneous first creations into an extra fighter without CREATOR', () => {
    const values = new Map<string, string>()
    const storage = {
      getItem: (key: string) => values.get(key) ?? null,
      setItem: (key: string, value: string) => void values.set(key, value),
    }
    const first = createAccountsStore(storage, 'en')
    const second = createAccountsStore(storage, 'en')
    const firstProgress = progressStore(first)
    const secondProgress = progressStore(second)
    const alpha = { name: 'Alpha', type: 'tank' as const, main: '#ff0000', second: '#00ff00', head: 0, body: 0 }
    const beta = { ...alpha, name: 'Beta', main: '#0000ff' }

    firstProgress.update((progress) => {
      const result = saveCreated(progress, alpha)
      if (!result.ok) throw new Error(result.reason)
      return result.progress
    })
    secondProgress.update((progress) => {
      const result = saveCreated(progress, beta)
      if (!result.ok) throw new Error(result.reason)
      return result.progress
    })
    first.refresh()

    const saved = currentAccount(get(first)).progress
    expect(saved.createdFighters.map(({ id, look }) => ({ id, name: look.name }))).toEqual([
      { id: 'custom', name: 'Alpha' },
    ])
    expect(saved.credits).toBe(500)

    first.destroy()
    second.destroy()
  })

  it('rejects and refunds a stale creation when the last fighter slot is taken', () => {
    const values = new Map<string, string>()
    const storage = {
      getItem: (key: string) => values.get(key) ?? null,
      setItem: (key: string, value: string) => void values.set(key, value),
    }
    const existing = Array.from({ length: MAX_CREATED_FIGHTERS - 1 }, (_, index) => ({
      id: index === 0 ? 'custom' : `custom-${index + 1}`,
      look: {
        name: `Existing ${index + 1}`,
        type: 'tank' as const,
        main: '#ff0000',
        second: '#00ff00',
        head: 0,
        body: 0,
      },
    }))
    const seed = createAccountsStore(storage, 'en')
    progressStore(seed).update((progress) => ({
      ...progress,
      credits: 5000,
      activeHacks: ['creator'],
      hackExpiries: { creator: Date.now() + 60_000 },
      createdFighters: existing,
    }))
    seed.destroy()

    const first = createAccountsStore(storage, 'en')
    const second = createAccountsStore(storage, 'en')
    const firstProgress = progressStore(first)
    const secondProgress = progressStore(second)
    const alpha = { name: 'Alpha', type: 'tank' as const, main: '#ff0000', second: '#00ff00', head: 0, body: 0 }
    const beta = { ...alpha, name: 'Beta', main: '#0000ff' }

    firstProgress.update((progress) => {
      const result = saveCreated(progress, alpha)
      if (!result.ok) throw new Error(result.reason)
      return result.progress
    })
    secondProgress.update((progress) => {
      const result = saveCreated(progress, beta)
      if (!result.ok) throw new Error(result.reason)
      return result.progress
    })
    first.refresh()

    const saved = currentAccount(get(first)).progress
    expect(saved.createdFighters).toHaveLength(MAX_CREATED_FIGHTERS)
    expect(saved.createdFighters.at(-1)).toMatchObject({ id: 'custom-15', look: alpha })
    expect(saved.createdFighters.some(({ look }) => look.name === 'Beta')).toBe(false)
    expect(saved.credits).toBe(4500)
    expect(get(secondProgress).credits).toBe(4500)

    first.destroy()
    second.destroy()
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
