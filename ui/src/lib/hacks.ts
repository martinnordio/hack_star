import { isCreatedFighterId, type Progress } from './progress'
import { SETTINGS } from './game/settings'

export type HackId = 'infinite_credits' | 'unlock_all' | 'power22' | 'hypercharge' | 'creator'

export interface Hack {
  id: string
  code: string
  name: string
  description: string
  duration_seconds: number | null
  /** Set on a world-coin code: the coins it gives. */
  world_coins?: number | null
  /** Set on a world-coin code: the days before the same account can use it again. */
  reuse_days?: number | null
}

export type WorldCodeHack = Hack & { world_coins: number; reuse_days: number }

export type WorldCodeResult = { kind: 'used'; progress: Progress; nextUseAt: number } | { kind: 'wait'; nextUseAt: number }

const DAY_MS = 24 * 60 * 60 * 1000

export type HackTimeRemaining = { kind: 'permanent' } | { kind: 'timed'; days: number; hours: number }

export const NORMAL_MAX_POWER = 11
export const HACKED_MAX_POWER = 22

/** Keeps kids from printing the codes; it is in the public source, so it is not security. */
export const QR_PASSWORD = 'M6D2'

export function isQrPassword(text: string): boolean {
  return text === QR_PASSWORD
}

export class UnknownCodeError extends Error {}

export async function redeem(code: string): Promise<Hack> {
  const response = await fetch('/api/hacks/redeem', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ code }),
  })
  if (response.status === 404 || response.status === 422) throw new UnknownCodeError('Unknown code')
  if (!response.ok) throw new Error(`Could not check the code (${response.status})`)
  return response.json()
}

export async function listHacks(): Promise<Hack[]> {
  const response = await fetch('/api/hacks')
  if (!response.ok) throw new Error(`Could not load hacks (${response.status})`)
  return response.json()
}

/** A QR code holds either a plain code or a game link with `?hack=<CODE>`. */
export function codeFromScan(text: string): string {
  try {
    const fromLink = new URL(text).searchParams.get('hack')
    if (fromLink) return fromLink
  } catch {
    // Not a link: the text is the code itself.
  }
  return text
}

export function hackLink(origin: string, code: string): string {
  return `${origin}/?hack=${encodeURIComponent(code)}`
}

export function isWorldCode(hack: Hack): hack is WorldCodeHack {
  return typeof hack.world_coins === 'number' && typeof hack.reuse_days === 'number'
}

/** A world-coin code gives its coins once per account until `reuse_days` have passed. */
export function useWorldCode(progress: Progress, hack: WorldCodeHack, now = Date.now()): WorldCodeResult {
  const waitUntil = progress.worldCodes[hack.id]
  if (waitUntil !== undefined && waitUntil > now) return { kind: 'wait', nextUseAt: waitUntil }
  const nextUseAt = now + hack.reuse_days * DAY_MS
  return {
    kind: 'used',
    nextUseAt,
    progress: {
      ...progress,
      worldCoins: progress.worldCoins + hack.world_coins,
      worldCodes: { ...progress.worldCodes, [hack.id]: nextUseAt },
    },
  }
}

/** The world-coin codes the account used that cannot be used again yet, soonest first. */
export function usedWorldCodes(progress: Progress, hacks: Hack[], now = Date.now()): { hack: WorldCodeHack; nextUseAt: number }[] {
  return hacks
    .filter(isWorldCode)
    .flatMap((hack) => {
      const nextUseAt = progress.worldCodes[hack.id]
      return nextUseAt !== undefined && nextUseAt > now ? [{ hack, nextUseAt }] : []
    })
    .sort((a, b) => a.nextUseAt - b.nextUseAt)
}

/** The day a code works again, in the language of the game (Swiss German uses the Swiss format). */
export function formatCodeDate(at: number, language: string): string {
  return new Date(at).toLocaleDateString(language === 'gsw' ? 'de-CH' : language, { day: 'numeric', month: 'long', year: 'numeric' })
}

export function withHack(progress: Progress, id: HackId, durationSeconds: number | null, now = Date.now()): Progress {
  const activeHacks = progress.activeHacks.includes(id) ? progress.activeHacks : [...progress.activeHacks, id]
  return {
    ...progress,
    activeHacks,
    hackExpiries: {
      ...progress.hackExpiries,
      [id]: durationSeconds === null ? null : now + durationSeconds * 1000,
    },
  }
}

export function isHackActive(progress: Progress, id: string, now = Date.now()): boolean {
  if (!progress.activeHacks.includes(id)) return false
  const expiry = progress.hackExpiries[id]
  return expiry === null || (expiry !== undefined && expiry > now)
}

export function hackTimeRemaining(progress: Progress, id: string, now = Date.now()): HackTimeRemaining | null {
  if (!progress.activeHacks.includes(id)) return null
  const expiry = progress.hackExpiries[id]
  if (expiry === null) return { kind: 'permanent' }
  if (expiry === undefined || expiry <= now) return null
  const hours = Math.ceil((expiry - now) / (60 * 60 * 1000))
  return { kind: 'timed', days: Math.floor(hours / 24), hours: hours % 24 }
}

export function activeHackIds(progress: Progress, now = Date.now()): string[] {
  return progress.activeHacks.filter((id) => isHackActive(progress, id, now))
}

const has = (progress: Progress, id: HackId) => isHackActive(progress, id)

/** Credits to show; `Infinity` with the unlimited-credits hack. */
export function credits(progress: Progress): number {
  return has(progress, 'infinite_credits') ? Infinity : progress.credits
}

export function isUnlocked(progress: Progress, fighterId: string): boolean {
  if (isCreatedFighterId(fighterId)) {
    const index = progress.createdFighters.findIndex((fighter) => fighter.id === fighterId)
    return index === 0 || (index > 0 && has(progress, 'creator'))
  }
  return has(progress, 'unlock_all') || progress.unlockedFighters.includes(fighterId)
}

export function maxPower(progress: Progress): number {
  return has(progress, 'power22') ? HACKED_MAX_POWER : NORMAL_MAX_POWER
}

/** The player's Super with the HYPERCHARGE hack: charges faster, every Super a Hypercharge. */
export function superHack(progress: Progress): { superGain: number; alwaysHyper: boolean } {
  return has(progress, 'hypercharge')
    ? { superGain: SETTINGS.hackSuperGain, alwaysHyper: true }
    : { superGain: 1, alwaysHyper: false }
}

/** The fighter to show and play; a fighter picked with "unlock all" can be locked again after a reset. */
export function currentFighter<F extends { id: string }>(progress: Progress, fighters: F[]): F {
  return (
    fighters.find((f) => f.id === progress.selectedFighter && isUnlocked(progress, f.id)) ??
    fighters.find((f) => isUnlocked(progress, f.id)) ??
    fighters[0]
  )
}
