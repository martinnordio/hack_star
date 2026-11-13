import { describe, expect, it } from 'vitest'
import { codeFromScan, credits, hackLink, isQrPassword, isUnlocked, maxPower, superHack, withHack } from './hacks'
import { defaultProgress } from './progress'

describe('QR password', () => {
  it.each([
    ['M6D2', true],
    ['m6d2', false],
    ['M6D2 ', false],
    ['', false],
    ['M6D3', false],
  ])('%j is %s', (text, ok) => {
    expect(isQrPassword(text)).toBe(ok)
  })
})

describe('hacks', () => {
  it('HYPERCHARGE makes the Super charge 3 times faster and always a Hypercharge, until reset', () => {
    const p = defaultProgress()
    expect(superHack(p)).toEqual({ superGain: 1, alwaysHyper: false })
    const hacked = withHack(p, 'hypercharge')
    expect(superHack(hacked)).toEqual({ superGain: 3, alwaysHyper: true })
    expect(superHack({ ...hacked, activeHacks: [] })).toEqual({ superGain: 1, alwaysHyper: false })
  })

  it('reads a plain code or a game link from a QR code', () => {
    expect(codeFromScan('POWER22')).toBe('POWER22')
    expect(codeFromScan('https://192.168.1.20:5180/?hack=OPENSESAME')).toBe('OPENSESAME')
    expect(codeFromScan(hackLink('http://localhost:5180', 'INFINITY'))).toBe('INFINITY')
    expect(codeFromScan('https://example.com/no-hack')).toBe('https://example.com/no-hack')
  })

  it('shows normal rules without hacks', () => {
    const p = defaultProgress()
    expect(credits(p)).toBe(500)
    expect(isUnlocked(p, 'blaze')).toBe(true)
    expect(isUnlocked(p, 'pixel')).toBe(false)
    expect(maxPower(p)).toBe(11)
  })

  it('applies each hack', () => {
    const p = withHack(withHack(withHack(defaultProgress(), 'infinite_credits'), 'unlock_all'), 'power22')
    expect(credits(p)).toBe(Infinity)
    expect(isUnlocked(p, 'pixel')).toBe(true)
    expect(maxPower(p)).toBe(22)
  })

  it('adds a hack only once and keeps saved progress unchanged', () => {
    const p = withHack(withHack(defaultProgress(), 'unlock_all'), 'unlock_all')
    expect(p.activeHacks).toEqual(['unlock_all'])
    expect(p.unlockedFighters).toEqual(['blaze', 'rocko', 'turbo'])
  })
})
