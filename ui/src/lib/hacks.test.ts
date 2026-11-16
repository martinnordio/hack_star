import { describe, expect, it } from 'vitest'
import { activeHackIds, codeFromScan, credits, hackLink, hackTimeRemaining, isHackActive, isQrPassword, isUnlocked, isWorldCoinHack, maxPower, superHack, useWorldCode, withHack, type Hack, type WorldCoinHack } from './hacks'
import { defaultProgress, resetProgress, startProgress, TEMPORARY_HACK_SECONDS } from './progress'

const code500: WorldCoinHack = { id: 'wc500-1', code: 'WC5-7K2QX', name: '500 world coins', description: '', duration_seconds: null, world_coins: 500, reuse_days: 30 }
const DAY = 24 * 60 * 60 * 1000

describe('world-coin codes', () => {
  it('are told apart from the other hacks', () => {
    const power22: Hack = { id: 'power22', code: 'POWER22', name: 'Power 22', description: '', duration_seconds: null, world_coins: null, reuse_days: null }
    expect(isWorldCoinHack(code500)).toBe(true)
    expect(isWorldCoinHack(power22)).toBe(false)
    expect(isWorldCoinHack({ ...power22, world_coins: undefined })).toBe(false)
  })

  it('give their coins and remember when the code works again', () => {
    const now = 1_000_000
    const used = useWorldCode(startProgress(), code500, now)
    expect(used).toMatchObject({ ok: true, coins: 500, progress: { worldCoins: 500, worldCodes: { 'wc500-1': now + 30 * DAY } } })
    // Credits and hacks stay as they were.
    if (used.ok) expect(used.progress).toMatchObject({ credits: 500, activeHacks: [] })
  })

  it('are refused before 30 days with the date, and accepted after', () => {
    const now = 1_000_000
    const first = useWorldCode(startProgress(), code500, now)
    if (!first.ok) throw new Error('refused')
    expect(useWorldCode(first.progress, code500, now + 30 * DAY - 1)).toEqual({ ok: false, reason: 'wait', availableAt: now + 30 * DAY })
    const again = useWorldCode(first.progress, code500, now + 30 * DAY)
    expect(again).toMatchObject({ ok: true, progress: { worldCoins: 1000, worldCodes: { 'wc500-1': now + 60 * DAY } } })
  })

  it('count per account and per code', () => {
    const now = 5_000
    const first = useWorldCode(startProgress(), code500, now)
    if (!first.ok) throw new Error('refused')
    // Another account on the device has its own 30 days.
    expect(useWorldCode(startProgress(), code500, now + 1).ok).toBe(true)
    // Another code works at once.
    expect(useWorldCode(first.progress, { ...code500, id: 'wc500-2', code: 'WC5-M3R9D' }, now + 1).ok).toBe(true)
    // The amount of a 1000 code.
    expect(useWorldCode(startProgress(), { ...code500, id: 'wc1000-1', world_coins: 1000 }, now)).toMatchObject({ ok: true, coins: 1000 })
  })

  it('work again at once after a reset of the account', () => {
    const now = 1_000
    const first = useWorldCode(startProgress(), code500, now)
    if (!first.ok) throw new Error('refused')
    expect(useWorldCode(first.progress, code500, now + 1).ok).toBe(false)
    const reset = resetProgress(first.progress)
    expect(reset).toMatchObject({ worldCoins: 0, worldCodes: {} })
    expect(useWorldCode(reset, code500, now + 2)).toMatchObject({ ok: true, progress: { worldCoins: 500 } })
  })
})

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
