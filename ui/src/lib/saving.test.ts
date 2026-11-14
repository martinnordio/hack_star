import { get } from 'svelte/store'
import { beforeEach, describe, expect, it } from 'vitest'
import { createAccountsStore, loadAccounts, saveAccounts } from './accounts'
import { defaultOptions, loadOptions, saveOptions } from './options'
import { memoryStorage } from './progress'
import { dismissSaveNotice, reportSave, saveNotice } from './saving'

const blocked = {
  getItem: () => null,
  setItem: () => {
    throw new Error('QuotaExceededError')
  },
}

describe('saving', () => {
  beforeEach(() => saveNotice.set('none'))

  it('saves report whether they worked', () => {
    const accounts = loadAccounts(memoryStorage(), 'en')
    expect(saveAccounts(memoryStorage(), accounts)).toBe(true)
    expect(saveAccounts(blocked, accounts)).toBe(false)
    expect(saveOptions(memoryStorage(), defaultOptions())).toBe(true)
    expect(saveOptions(blocked, defaultOptions())).toBe(false)
  })

  it('shows the notice once per visit', () => {
    reportSave(true)
    expect(get(saveNotice)).toBe('none')
    reportSave(false)
    reportSave(false)
    expect(get(saveNotice)).toBe('shown')
    dismissSaveNotice()
    reportSave(false)
    expect(get(saveNotice)).toBe('dismissed')
  })

  it('a store on blocked storage keeps working and shows the notice', () => {
    const store = createAccountsStore(blocked, 'en')
    store.update((s) => ({ ...s, accounts: s.accounts.map((a) => ({ ...a, name: 'Noah' })) }))
    expect(get(store).accounts[0].name).toBe('Noah')
    expect(get(saveNotice)).toBe('shown')
    store.destroy()
  })

  it('every change is saved at once', () => {
    const storage = memoryStorage()
    const store = createAccountsStore(storage, 'en')
    store.update((s) => ({ ...s, accounts: s.accounts.map((a) => ({ ...a, name: 'Noah' })) }))
    expect(loadAccounts(storage, 'en').accounts[0].name).toBe('Noah')
    saveOptions(storage, { ...defaultOptions(), botCount: 5 })
    expect(loadOptions(storage).botCount).toBe(5)
    expect(get(saveNotice)).toBe('none')
    store.destroy()
  })
})
