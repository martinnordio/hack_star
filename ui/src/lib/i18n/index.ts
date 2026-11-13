import { derived } from 'svelte/store'
import { accounts, currentAccount, updateAccount } from '../accounts'
import { en, type TextKey } from './en'
import type { Language } from './languages'

export type { TextKey } from './en'
export type Params = Record<string, string | number>
export type Translate = (key: TextKey, params?: Params) => string

const DICTIONARIES: Record<Language, Partial<Record<TextKey, string>>> = {
  en,
  de: {},
  gsw: {},
  es: {},
  it: {},
}

/** The text in a language, English when missing; `{name}` is replaced by `params.name`. */
export function translate(language: Language, key: TextKey, params?: Params): string {
  const text = DICTIONARIES[language][key] ?? en[key] ?? key
  return params ? text.replace(/\{(\w+)\}/g, (all, name: string) => String(params[name] ?? all)) : text
}

/** For texts whose key is built from data (hack ids, fighter ids): the fallback when unknown. */
export function translateOr(language: Language, key: string, fallback: string): string {
  return key in en ? translate(language, key as TextKey) : fallback
}

export const language = derived(accounts, (state) => currentAccount(state).language)

/** `$t('home.play')` in components. */
export const t = derived(language, (l): Translate => (key, params) => translate(l, key, params))

/** `$tOr('hack.' + id + '.name', hack.name)` for keys built from data. */
export const tOr = derived(language, (l) => (key: string, fallback: string) => translateOr(l, key, fallback))

export function setLanguage(next: Language): void {
  accounts.update((state) => updateAccount(state, currentAccount(state).id, (a) => ({ ...a, language: next })))
}
