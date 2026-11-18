import { START_WORLD, totalTrophies, type Progress } from '../progress'
import { SETTINGS, type Settings } from './settings'
import { WORLD_SIZES, isWorldId, isWorldSize, type WorldId, type WorldSize } from './worlds'

/** Worlds are paid only with world coins: credits and the hacks never count here (S10). */
export type WorldPurchase =
  | { ok: true; progress: Progress; cost: number }
  | { ok: false; reason: 'unknown' | 'owned' | 'locked' }
  | { ok: false; reason: 'world-coins'; missing: number }

const rank = (size: WorldSize) => WORLD_SIZES.indexOf(size)

/** The biggest unlocked size of a world, or `null` while it is locked. */
export function unlockedSize(progress: Progress, id: string): WorldSize | null {
  const size = progress.worlds[id]
  return isWorldId(id) && isWorldSize(size) ? size : null
}

export function isWorldUnlocked(progress: Progress, id: string, size: WorldSize): boolean {
  const biggest = unlockedSize(progress, id)
  return biggest !== null && rank(size) <= rank(biggest)
}

/** World coins to go from `from` (`null`: locked) to `to`; 0 when nothing is added. */
export function worldCost(from: WorldSize | null, to: WorldSize | null, settings: Settings = SETTINGS): number {
  if (to === null || (from !== null && rank(to) <= rank(from))) return 0
  return from === null ? settings.worldPrices[to] : (rank(to) - rank(from)) * settings.worldSizeStep
}

/** World coins and paid steps after the total trophies went from `totalBefore` to `totalAfter`. */
export function worldCoinsFor(
  totalBefore: number,
  totalAfter: number,
  steps: number,
  settings: Settings = SETTINGS,
): { coins: number; steps: number } {
  const reached = Math.floor(totalAfter / settings.trophiesPerWorldStep)
  if (totalAfter <= totalBefore || reached <= steps) return { coins: 0, steps }
  return { coins: (reached - steps) * settings.worldCoinsPerStep, steps: reached }
}

/** Pays the world coins of every new 500-step the progress reached since `totalBefore`. */
export function earnWorldCoins(
  progress: Progress,
  totalBefore: number,
  settings: Settings = SETTINGS,
): { progress: Progress; coins: number } {
  const earned = worldCoinsFor(totalBefore, totalTrophies(progress), progress.worldSteps, settings)
  if (earned.coins === 0) return { progress, coins: 0 }
  return {
    progress: { ...progress, worldCoins: progress.worldCoins + earned.coins, worldSteps: earned.steps },
    coins: earned.coins,
  }
}

function payWorld(progress: Progress, id: WorldId, from: WorldSize | null, to: WorldSize, settings: Settings): WorldPurchase {
  const cost = worldCost(from, to, settings)
  if (progress.worldCoins < cost) return { ok: false, reason: 'world-coins', missing: cost - progress.worldCoins }
  return {
    ok: true,
    cost,
    progress: { ...progress, worldCoins: progress.worldCoins - cost, worlds: { ...progress.worlds, [id]: to } },
  }
}

/** Buys a locked world in Small, Small + Medium, or every size up to Large. */
export function buyWorld(progress: Progress, id: string, size: WorldSize, settings: Settings = SETTINGS): WorldPurchase {
  if (!isWorldId(id)) return { ok: false, reason: 'unknown' }
  if (unlockedSize(progress, id) !== null) return { ok: false, reason: 'owned' }
  return payWorld(progress, id, null, size, settings)
}

/** Unlocks the next size of an unlocked world. */
export function growWorld(progress: Progress, id: string, settings: Settings = SETTINGS): WorldPurchase {
  if (!isWorldId(id)) return { ok: false, reason: 'unknown' }
  const size = unlockedSize(progress, id)
  if (size === null) return { ok: false, reason: 'locked' }
  const next = WORLD_SIZES[rank(size) + 1]
  if (!next) return { ok: false, reason: 'owned' }
  return payWorld(progress, id, size, next, settings)
}

/** The saved choice when it is still unlocked, otherwise Canyon Small. */
export function chosenWorld(progress: Progress): { id: WorldId; size: WorldSize } {
  const { id, size } = progress.selectedWorld
  return isWorldId(id) && isWorldUnlocked(progress, id, size) ? { id, size } : { ...START_WORLD }
}

/** Keeps the choice for next time; a locked world or size is not chosen. */
export function chooseWorld(progress: Progress, id: string, size: WorldSize): Progress {
  return isWorldUnlocked(progress, id, size) ? { ...progress, selectedWorld: { id, size } } : progress
}

/** What a size button of the world screen does: play it, pay for it, or wait for a smaller size. */
export type SizeOffer =
  | { size: WorldSize; state: 'unlocked' }
  | { size: WorldSize; state: 'buy' | 'grow'; price: number; missing: number }
  | { size: WorldSize; state: 'locked' }

/**
 * The three sizes of a world as the world screen shows them: a locked world offers every size
 * with its price (500 / 750 / 1000); an unlocked one offers the next size for 250 and keeps the
 * ones after it locked until then.
 */
export function worldOffers(progress: Progress, id: string, settings: Settings = SETTINGS): SizeOffer[] {
  const biggest = unlockedSize(progress, id)
  return WORLD_SIZES.map((size): SizeOffer => {
    if (biggest !== null && rank(size) <= rank(biggest)) return { size, state: 'unlocked' }
    if (biggest !== null && rank(size) > rank(biggest) + 1) return { size, state: 'locked' }
    const price = worldCost(biggest, size, settings)
    return { size, state: biggest === null ? 'buy' : 'grow', price, missing: Math.max(0, price - progress.worldCoins) }
  })
}
