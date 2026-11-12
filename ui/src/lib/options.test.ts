import { describe, expect, it } from 'vitest'
import { SETTINGS, settingsFrom } from './game/settings'
import { defaultOptions, loadOptions, OPTIONS_KEY, saveOptions } from './options'

function storage(raw?: string) {
  const items = new Map<string, string>(raw === undefined ? [] : [[OPTIONS_KEY, raw]])
  return {
    getItem: (key: string) => items.get(key) ?? null,
    setItem: (key: string, value: string) => void items.set(key, value),
  }
}

describe('options', () => {
  it('starts with Easy and 3 bots', () => {
    expect(loadOptions(storage())).toEqual({ botLevel: 'easy', botCount: 3 })
  })

  it('keeps what was saved', () => {
    const s = storage()
    saveOptions(s, { botLevel: 'hard', botCount: 5 })
    expect(loadOptions(s)).toEqual({ botLevel: 'hard', botCount: 5 })
  })

  it('falls back to the default for each bad value', () => {
    expect(loadOptions(storage('{"botLevel":"crazy","botCount":5}'))).toEqual({ botLevel: 'easy', botCount: 5 })
    expect(loadOptions(storage('{"botLevel":"medium","botCount":9}'))).toEqual({ botLevel: 'medium', botCount: 3 })
    expect(loadOptions(storage('not json'))).toEqual(defaultOptions())
    expect(loadOptions(storage('42'))).toEqual(defaultOptions())
  })

  it('match settings use the options, and the address wins over them', () => {
    const chosen = { botLevel: 'hard' as const, botCount: 5 }
    const s = settingsFrom('', SETTINGS, chosen)
    expect([s.botLevel, s.botCount]).toEqual(['hard', 5])
    const overridden = settingsFrom('?bots=1&level=medium', SETTINGS, chosen)
    expect([overridden.botLevel, overridden.botCount]).toEqual(['medium', 1])
  })
})
