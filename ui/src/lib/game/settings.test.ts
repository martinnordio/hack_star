import { describe, expect, it } from 'vitest'
import { SETTINGS, settingsFrom } from './settings'

describe('settingsFrom', () => {
  it('keeps the defaults without overrides', () => {
    expect(settingsFrom('')).toEqual(SETTINGS)
  })

  it('reads seconds, bots and level, within limits', () => {
    const s = settingsFrom('?seconds=30&bots=5&level=hard')
    expect([s.matchSeconds, s.botCount, s.botLevel]).toEqual([30, 5, 'hard'])
    const clamped = settingsFrom('?seconds=1&bots=99&level=crazy')
    expect([clamped.matchSeconds, clamped.botCount, clamped.botLevel]).toEqual([5, 8, SETTINGS.botLevel])
    expect(settingsFrom('?bots=abc').botCount).toBe(SETTINGS.botCount)
  })
})
