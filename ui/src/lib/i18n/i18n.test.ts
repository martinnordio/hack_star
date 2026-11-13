import { get } from 'svelte/store'
import { describe, expect, it } from 'vitest'
import { accounts, addAccount, switchAccount } from '../accounts'
import { language, setLanguage, t, translate, translateOr } from '.'
import { de } from './de'
import { en, type TextKey } from './en'
import { es } from './es'
import { gsw } from './gsw'
import { it as italian } from './it'

const placeholders = (text: string) => [...text.matchAll(/\{(\w+)\}/g)].map((m) => m[1]).sort()

describe('dictionaries', () => {
  it.each([
    ['de', de],
    ['gsw', gsw],
    ['es', es],
    ['it', italian],
  ])('%s has every text, none empty, with the same placeholders as English', (_, dictionary) => {
    for (const key of Object.keys(en) as TextKey[]) {
      expect(dictionary[key]?.trim(), key).toBeTruthy()
      expect(placeholders(dictionary[key]), key).toEqual(placeholders(en[key]))
      expect(dictionary[key], key).not.toContain('\uFFFD')
    }
    expect(Object.keys(dictionary)).toHaveLength(Object.keys(en).length)
  })
})

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
