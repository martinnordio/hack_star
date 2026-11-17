import { describe, expect, it } from 'vitest'
import { activeHackIds, codeFromScan, credits, hackLink, hackTimeRemaining, isHackActive, isQrPassword, isUnlocked, isWorldCoinHack, maskCode, maxPower, superHack, useWorldCode, withHack, type Hack, type WorldCodeResult, type WorldCoinHack } from './hacks'
import { defaultProgress, resetProgress, startProgress, TEMPORARY_HACK_SECONDS, type Progress } from './progress'

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
    const hacked = withHack(p, 'hypercharge', TEMPORARY_HACK_SECONDS)
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
    const p = withHack(
      withHack(withHack(defaultProgress(), 'infinite_credits', TEMPORARY_HACK_SECONDS), 'unlock_all', TEMPORARY_HACK_SECONDS),
      'power22',
      null,
    )
    expect(credits(p)).toBe(Infinity)
    expect(isUnlocked(p, 'pixel')).toBe(true)
    expect(maxPower(p)).toBe(22)
  })

  it('adds a hack only once and keeps saved progress unchanged', () => {
    const p = withHack(withHack(defaultProgress(), 'unlock_all', TEMPORARY_HACK_SECONDS), 'unlock_all', TEMPORARY_HACK_SECONDS)
    expect(p.activeHacks).toEqual(['unlock_all'])
    expect(p.unlockedFighters).toEqual(['blaze', 'rocko', 'turbo'])
  })

  it('expires timed hacks at the boundary, refreshes them on re-entry and keeps permanent hacks', () => {
    const now = Date.now()
    const first = withHack(defaultProgress(), 'infinite_credits', TEMPORARY_HACK_SECONDS, now)
    expect(isHackActive(first, 'infinite_credits', now + TEMPORARY_HACK_SECONDS * 1000 - 1)).toBe(true)
    expect(credits(first)).toBe(Infinity)
    expect(isHackActive(first, 'infinite_credits', now + TEMPORARY_HACK_SECONDS * 1000)).toBe(false)
    expect(credits({ ...first, hackExpiries: { ...first.hackExpiries, infinite_credits: now } })).toBe(500)

    const refreshed = withHack(first, 'infinite_credits', TEMPORARY_HACK_SECONDS, now + 5000)
    expect(refreshed.hackExpiries.infinite_credits).toBe(now + 5000 + TEMPORARY_HACK_SECONDS * 1000)
    const permanent = withHack(defaultProgress(), 'power22', null, now)
    expect(isHackActive(permanent, 'power22', now + 100_000_000_000)).toBe(true)
    expect(activeHackIds(permanent, now + 100_000_000_000)).toEqual(['power22'])
  })

  it('reports timed days and hours, permanent status, and no status after expiry', () => {
    const now = 1_000_000
    const timed = withHack(defaultProgress(), 'infinite_credits', 72 * 60 * 60, now)
    const permanent = withHack(defaultProgress(), 'power22', null, now)

    expect(hackTimeRemaining(timed, 'infinite_credits', now)).toEqual({ kind: 'timed', days: 3, hours: 0 })
    expect(hackTimeRemaining(timed, 'infinite_credits', now + 47 * 60 * 60 * 1000)).toEqual({ kind: 'timed', days: 1, hours: 1 })
    expect(hackTimeRemaining(timed, 'infinite_credits', now + 72 * 60 * 60 * 1000)).toBeNull()
    expect(hackTimeRemaining(permanent, 'power22', now + 100_000_000_000)).toEqual({ kind: 'permanent' })
  })
})

describe('world-coin codes', () => {
  const DAY = 24 * 60 * 60 * 1000
  const coins500: WorldCoinHack = { id: 'wc500-1', code: 'WC-7K2QX', name: '500 world coins', description: '', duration_seconds: null, world_coins: 500, reuse_days: 30 }
  const coins1000: WorldCoinHack = { id: 'wc1000-1', code: 'WC-D8GWJ', name: '1000 world coins', description: '', duration_seconds: null, world_coins: 1000, reuse_days: 30 }
  const plain: Hack = { id: 'power22', code: 'POWER22', name: 'Power 22', description: '', duration_seconds: null }

  function progressOf(result: WorldCodeResult): Progress {
    if (!result.ok) throw new Error('code was refused')
    return result.progress
  }

  it('tells world-coin codes from normal hacks', () => {
    expect(isWorldCoinHack(coins500)).toBe(true)
    expect(isWorldCoinHack(plain)).toBe(false)
  })

  it('adds its coins and stores the date it works again', () => {
    const now = 1_000_000
    const p = progressOf(useWorldCode(defaultProgress(), coins500, now))
    expect(p.worldCoins).toBe(750 + 500)
    expect(p.worldCodes).toEqual({ 'wc500-1': now + 30 * DAY })
  })

  it('refuses a second use before 30 days and says when it works again', () => {
    const now = 1_000_000
    const first = progressOf(useWorldCode(defaultProgress(), coins500, now))
    expect(useWorldCode(first, coins500, now + 30 * DAY - 60_000)).toEqual({ ok: false, availableAt: now + 30 * DAY })
  })

  it('accepts the code again exactly 30 days later and adds the coins once more', () => {
    const now = 1_000_000
    const first = progressOf(useWorldCode(defaultProgress(), coins500, now))
    const again = progressOf(useWorldCode(first, coins500, now + 30 * DAY))
    expect(again.worldCoins).toBe(750 + 500 + 500)
  })

  it('keeps the dates of different codes apart', () => {
    const now = 1_000_000
    const first = progressOf(useWorldCode(defaultProgress(), coins500, now))
    const other = progressOf(useWorldCode(first, coins1000, now))
    expect(other.worldCoins).toBe(750 + 500 + 1000)
    expect(other.worldCodes).toEqual({ 'wc500-1': now + 30 * DAY, 'wc1000-1': now + 30 * DAY })
  })

  it('is independent per account', () => {
    const now = 1_000_000
    const used = progressOf(useWorldCode(defaultProgress(), coins500, now))
    expect(used.worldCodes).toHaveProperty('wc500-1')
    const fresh = progressOf(useWorldCode(startProgress(), coins500, now))
    expect(fresh.worldCoins).toBe(500)
  })

  it('makes every code usable again after a reset', () => {
    const now = 1_000_000
    const used = progressOf(useWorldCode(defaultProgress(), coins500, now))
    const reset = resetProgress(used)
    expect(reset.worldCodes).toEqual({})
    expect(useWorldCode(reset, coins500, now).ok).toBe(true)
  })

  it('masks the middle of a code', () => {
    expect(maskCode('WC-7K2QX')).toBe('WC-7••••X')
  })
})
