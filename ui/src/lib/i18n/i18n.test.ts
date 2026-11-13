import { get } from 'svelte/store'
import { describe, expect, it } from 'vitest'
import { accounts, addAccount, switchAccount } from '../accounts'
import { language, setLanguage, t, translate, translateOr } from '.'

describe('i18n', () => {
  it('fills placeholders and keeps unknown ones', () => {
    expect(translate('en', 'common.bots.other', { count: 3 })).toBe('3 bots')
    expect(translate('en', 'common.bots.other')).toBe('{count} bots')
  })

  it('falls back to the given text for keys built from data', () => {
    expect(translateOr('en', 'hack.nope.name', 'Server text')).toBe('Server text')
    expect(translateOr('en', 'hack.power22.name', 'x')).toBe('Power 22')
  })

  it('the language belongs to the account and follows switching', () => {
    const start = get(accounts)
    const added = addAccount(start, 'Lingo', 'it')
    if (!added.ok) throw new Error(added.reason)
    accounts.set(added.state)
    expect(get(language)).toBe('it')
    setLanguage('de')
    expect(get(language)).toBe('de')
    accounts.update((s) => switchAccount(s, start.current))
    expect(get(language)).toBe(start.accounts[0].language)
    expect(typeof get(t)('home.play')).toBe('string')
  })
})
