import { CREATED_ID, type Progress } from './progress'
import { SETTINGS } from './game/settings'

export type HackId = 'infinite_credits' | 'unlock_all' | 'power22' | 'hypercharge' | 'creator'

export interface Hack {
  id: HackId
  code: string
  name: string
  description: string
}

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

export function withHack(progress: Progress, id: HackId): Progress {
  if (progress.activeHacks.includes(id)) return progress
  return { ...progress, activeHacks: [...progress.activeHacks, id] }
}

const has = (progress: Progress, id: HackId) => progress.activeHacks.includes(id)

/** Credits to show; `Infinity` with the unlimited-credits hack. */
export function credits(progress: Progress): number {
  return has(progress, 'infinite_credits') ? Infinity : progress.credits
}

export function isUnlocked(progress: Progress, fighterId: string): boolean {
  // Only the CREATOR code unlocks the created fighter (not credits, not OPENSESAME).
  if (fighterId === CREATED_ID) return has(progress, 'creator') && progress.createdFighter !== null
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
