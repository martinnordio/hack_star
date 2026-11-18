import { describe, expect, it } from 'vitest'
import {
  activeHackIds,
  codeFromScan,
  credits,
  formatCodeDate,
  hackLink,
  hackTimeRemaining,
  isHackActive,
  isQrPassword,
  isUnlocked,
  isWorldCode,
  maxPower,
  superHack,
  useWorldCode,
  usedWorldCodes,
  withHack,
  type Hack,
} from './hacks'
import { defaultProgress, resetProgress, TEMPORARY_HACK_SECONDS } from './progress'

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
  const day = 24 * 60 * 60 * 1000
  const code: Hack = {
    id: 'world_500_1',
    code: 'WC5-7K2QX',
    name: '500 world coins',
    description: '',
    duration_seconds: null,
    world_coins: 500,
    reuse_days: 30,
  }
  const big: Hack = { ...code, id: 'world_1000_1', code: 'WC1-K3W7P', world_coins: 1000 }
  if (!isWorldCode(code) || !isWorldCode(big)) throw new Error('test codes must be world codes')

  it('is a world code only with coins and days; normal hacks are not', () => {
    expect(isWorldCode(code)).toBe(true)
    expect(isWorldCode({ ...code, world_coins: null, reuse_days: null })).toBe(false)
    expect(isWorldCode({ id: 'power22', code: 'POWER22', name: '', description: '', duration_seconds: null })).toBe(false)
  })

  it('adds its coins and stores the day it works again', () => {
    const now = 5_000_000
    const result = useWorldCode(defaultProgress(), code, now)
    expect(result.kind).toBe('used')
    if (result.kind !== 'used') return
    expect(result.nextUseAt).toBe(now + 30 * day)
    expect(result.progress.worldCoins).toBe(defaultProgress().worldCoins + 500)
    expect(result.progress.worldCodes).toEqual({ world_500_1: now + 30 * day })
    expect(result.progress.activeHacks).toEqual([])
  })

  it('refuses before 30 days with the date and accepts after', () => {
    const now = 5_000_000
    const first = useWorldCode(defaultProgress(), code, now)
    if (first.kind !== 'used') throw new Error('first use must work')
    expect(useWorldCode(first.progress, code, now + 30 * day - 1)).toEqual({ kind: 'wait', nextUseAt: now + 30 * day })
    const again = useWorldCode(first.progress, code, now + 30 * day)
    expect(again.kind).toBe('used')
    if (again.kind === 'used') expect(again.progress.worldCoins).toBe(defaultProgress().worldCoins + 1000)
  })

  it('keeps every code and every account apart', () => {
    const now = 5_000_000
    const first = useWorldCode(defaultProgress(), code, now)
    if (first.kind !== 'used') throw new Error('first use must work')
    const other = useWorldCode(first.progress, big, now + 1)
    expect(other.kind).toBe('used')
    if (other.kind === 'used') expect(other.progress.worldCoins).toBe(defaultProgress().worldCoins + 1500)
    expect(useWorldCode(defaultProgress(), code, now + 1).kind).toBe('used')
  })

  it('lists the used codes with their dates, soonest first, and drops the ones that work again', () => {
    const now = 5_000_000
    const p = { ...defaultProgress(), worldCodes: { world_1000_1: now + 5 * day, world_500_1: now + 2 * day, gone: now + day } }
    expect(usedWorldCodes(p, [code, big], now).map((u) => [u.hack.id, u.nextUseAt])).toEqual([
      ['world_500_1', now + 2 * day],
      ['world_1000_1', now + 5 * day],
    ])
    expect(usedWorldCodes(p, [code, big], now + 3 * day).map((u) => u.hack.id)).toEqual(['world_1000_1'])
  })

  it('a reset gives every code back at once (S21)', () => {
    const now = Date.now()
    const used = useWorldCode(defaultProgress(), code, now)
    if (used.kind !== 'used') throw new Error('first use must work')
    const reset = resetProgress(used.progress)
    expect(reset.worldCodes).toEqual({})
    expect(useWorldCode(reset, code, now).kind).toBe('used')
  })

  it('writes the date in the language of the game', () => {
    const at = Date.UTC(2026, 11, 18, 12)
    expect(formatCodeDate(at, 'en')).toBe('December 18, 2026')
    expect(formatCodeDate(at, 'de')).toBe('18. Dezember 2026')
    expect(formatCodeDate(at, 'gsw')).toBe('18. Dezember 2026')
  })
})
