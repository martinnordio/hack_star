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
  it('starts with Easy, 3 bots, developer mode off and music on', () => {
    expect(loadOptions(storage())).toEqual({ botLevel: 'easy', botCount: 3, developer: false, music: true, track: '' })
  })

  it('keeps what was saved', () => {
    const s = storage()
    saveOptions(s, { botLevel: 'hard', botCount: 5, developer: true, music: false, track: 'beat' })
    expect(loadOptions(s)).toEqual({ botLevel: 'hard', botCount: 5, developer: true, music: false, track: 'beat' })
  })

  it('falls back to the default for each bad value', () => {
    const d = defaultOptions()
    expect(loadOptions(storage('{"botLevel":"crazy","botCount":5}'))).toEqual({ ...d, botCount: 5 })
    expect(loadOptions(storage('{"botLevel":"medium","botCount":9}'))).toEqual({ ...d, botLevel: 'medium' })
    expect(loadOptions(storage('{"developer":"yes","music":0,"track":7}'))).toEqual(d)
    expect(loadOptions(storage('not json'))).toEqual(defaultOptions())
    expect(loadOptions(storage('42'))).toEqual(defaultOptions())
  })

  it('match settings use the options, and the address wins over them', () => {
    const chosen = { botLevel: 'hard' as const, botCount: 5, developer: false, music: true, track: '' }
    const s = settingsFrom('', SETTINGS, chosen)
    expect([s.botLevel, s.botCount]).toEqual(['hard', 5])
    const overridden = settingsFrom('?bots=1&level=medium', SETTINGS, chosen)
    expect([overridden.botLevel, overridden.botCount]).toEqual(['medium', 1])
  })
})
