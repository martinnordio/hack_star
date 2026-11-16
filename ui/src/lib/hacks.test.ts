import { describe, expect, it } from 'vitest'
import { addAccount, currentAccount, loadAccounts, switchAccount, updateAccount } from './accounts'
import { activeHackIds, codeFromScan, credits, hackLink, hackTimeRemaining, isHackActive, isQrPassword, isUnlocked, isWorldCode, maxPower, superHack, useWorldCode, withHack, type Hack } from './hacks'
import { defaultProgress, memoryStorage, resetProgress, startProgress, TEMPORARY_HACK_SECONDS, type Progress } from './progress'

const DAY = 24 * 60 * 60 * 1000
const CODE = { id: 'world-coins-6', code: 'WC1-Q8L4Z', name: '1000 world coins', description: '', duration_seconds: null, world_coins: 1000, reuse_days: 30 }

function use(progress: Progress, now: number) {
  if (!isWorldCode(CODE)) throw new Error('not a world code')
  return useWorldCode(progress, CODE, now)
}

describe('world-coin codes', () => {
  it('only codes with coins and days are world-coin codes', () => {
    expect(isWorldCode(CODE)).toBe(true)
    const power: Hack = { id: 'power22', code: 'POWER22', name: '', description: '', duration_seconds: null, world_coins: null, reuse_days: null }
    expect(isWorldCode(power)).toBe(false)
  })

  it('adds the coins once, refuses with the date before 30 days, works again after', () => {
    const now = 1_000_000
    const first = use(startProgress(), now)
    expect(first).toMatchObject({ ok: true, coins: 1000, progress: { worldCoins: 1000, worldCodes: { 'world-coins-6': now + 30 * DAY } } })
    if (!first.ok) return
    expect(use(first.progress, now + 29 * DAY)).toEqual({ ok: false, until: now + 30 * DAY })
    const again = use(first.progress, now + 30 * DAY + 1)
    expect(again).toMatchObject({ ok: true, progress: { worldCoins: 2000 } })
  })

  it('another account on the device has its own 30 days', () => {
    let state = loadAccounts(memoryStorage(), 'en')
    const used = use(currentAccount(state).progress, 0)
    if (!used.ok) throw new Error('refused')
    state = updateAccount(state, state.current, (a) => ({ ...a, progress: used.progress }))
    const added = addAccount(state, 'Mia', 'en')
    if (!added.ok) throw new Error(added.reason)
    expect(use(currentAccount(added.state).progress, 1).ok).toBe(true)
    expect(use(currentAccount(switchAccount(added.state, 'a1')).progress, 1).ok).toBe(false)
  })

  it('a reset makes every world-coin code usable again at once', () => {
    const used = use(startProgress(), 0)
    if (!used.ok) throw new Error('refused')
    expect(use(resetProgress(used.progress), 1).ok).toBe(true)
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
