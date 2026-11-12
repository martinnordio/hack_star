import type { Fighter, Skin } from '../fighters'
import { isUnlocked } from '../hacks'
import type { Progress } from '../progress'
import { pay, type Purchase } from './economy'
import { SETTINGS, type Settings } from './settings'

export interface ShopSkin {
  fighter: Fighter
  skin: Skin
}

export function ownsSkin(progress: Progress, fighterId: string, skinId: string): boolean {
  return (
    skinId === 'default' ||
    progress.activeHacks.includes('unlock_all') ||
    (progress.ownedSkins[fighterId] ?? []).includes(skinId)
  )
}

/** The skin a fighter wears: the chosen one if it is owned (it may not be after a hack reset). */
export function wornSkin(progress: Progress, fighterId: string): string {
  const chosen = progress.selectedSkins[fighterId] ?? 'default'
  return ownsSkin(progress, fighterId, chosen) ? chosen : 'default'
}

/** Whole days since 1970 in local time, so the skin of the day changes at midnight. */
function dayNumber(date: Date): number {
  return Math.floor((date.getTime() - date.getTimezoneOffset() * 60_000) / 86_400_000)
}

/** One skin the player does not own, the same all day; none when every skin is owned. */
export function skinOfTheDay(progress: Progress, fighters: Fighter[], date: Date): ShopSkin | undefined {
  const all = fighters.flatMap((fighter) =>
    fighter.skins.filter((s) => s.id !== 'default').map((skin) => ({ fighter, skin })),
  )
  const notOwned = all.filter((s) => !ownsSkin(progress, s.fighter.id, s.skin.id))
  return notOwned.length ? notOwned[dayNumber(date) % notOwned.length] : undefined
}

export function skinPrice(
  progress: Progress,
  fighters: Fighter[],
  fighter: Fighter,
  skin: Skin,
  date: Date,
  settings: Settings = SETTINGS,
): number {
  const price = settings.skinPrices[skin.rarity]
  const daily = skinOfTheDay(progress, fighters, date)
  const isDaily = daily?.fighter.id === fighter.id && daily.skin.id === skin.id
  return isDaily ? Math.round(price * (1 - settings.skinOfTheDayDiscount)) : price
}

export function buySkin(
  progress: Progress,
  fighters: Fighter[],
  fighter: Fighter,
  skin: Skin,
  date: Date,
  settings: Settings = SETTINGS,
): Purchase {
  if (ownsSkin(progress, fighter.id, skin.id)) return { ok: false, reason: 'owned' }
  if (!isUnlocked(progress, fighter.id)) return { ok: false, reason: 'locked' }
  const cost = skinPrice(progress, fighters, fighter, skin, date, settings)
  const paid = pay(progress, cost)
  if ('ok' in paid) return paid
  const owned = [...(paid.ownedSkins[fighter.id] ?? []), skin.id]
  return { ok: true, cost, progress: { ...paid, ownedSkins: { ...paid.ownedSkins, [fighter.id]: owned } } }
}
