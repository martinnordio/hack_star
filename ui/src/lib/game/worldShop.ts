import { totalTrophies, type Progress } from '../progress'
import { SETTINGS, type Settings } from './settings'
import { WORLD_SIZES, type WorldId, type WorldSize } from './worlds'

export type WorldPurchase =
  | { ok: true; progress: Progress; cost: number }
  | { ok: false; reason: 'owned' | 'locked' }
  | { ok: false; reason: 'world-coins'; missing: number }

/** World coins for the 500-steps of `total` trophies not paid yet. */
export function worldCoinsFor(total: number, paidSteps: number, settings: Settings = SETTINGS): { coins: number; steps: number } {
  const steps = Math.max(paidSteps, Math.floor(total / settings.trophiesPerWorldStep))
  return { coins: (steps - paidSteps) * settings.worldCoinsPerStep, steps }
}

/** Pays the world coins for new trophy steps; `earned` is 0 when no new step was reached. */
export function earnWorldCoins(progress: Progress, settings: Settings = SETTINGS): { progress: Progress; earned: number } {
  const { coins, steps } = worldCoinsFor(totalTrophies(progress), progress.worldSteps, settings)
  if (coins === 0) return { progress, earned: 0 }
  return { progress: { ...progress, worldCoins: progress.worldCoins + coins, worldSteps: steps }, earned: coins }
}

export function isWorldUnlocked(progress: Progress, id: WorldId, size: WorldSize): boolean {
  const biggest = progress.worlds[id]
  return biggest !== undefined && WORLD_SIZES.indexOf(size) <= WORLD_SIZES.indexOf(biggest)
}

function payWorldCoins(progress: Progress, cost: number, worlds: Progress['worlds']): WorldPurchase {
  if (progress.worldCoins < cost) return { ok: false, reason: 'world-coins', missing: cost - progress.worldCoins }
  return { ok: true, cost, progress: { ...progress, worldCoins: progress.worldCoins - cost, worlds } }
}

/** Buys a locked world up to `size` (Small, Small + Medium, or all three). */
export function buyWorld(progress: Progress, id: WorldId, size: WorldSize, settings: Settings = SETTINGS): WorldPurchase {
  if (progress.worlds[id]) return { ok: false, reason: 'owned' }
  return payWorldCoins(progress, settings.worldPrices[size], { ...progress.worlds, [id]: size })
}

/** The next size of an unlocked world. */
export function nextSize(progress: Progress, id: WorldId): WorldSize | undefined {
  const biggest = progress.worlds[id]
  return biggest && WORLD_SIZES[WORLD_SIZES.indexOf(biggest) + 1]
}

/** Unlocks the next size of an unlocked world: Medium needs Small, Large needs Medium. */
export function growWorld(progress: Progress, id: WorldId, settings: Settings = SETTINGS): WorldPurchase {
  if (!progress.worlds[id]) return { ok: false, reason: 'locked' }
  const next = nextSize(progress, id)
  if (!next) return { ok: false, reason: 'owned' }
  return payWorldCoins(progress, settings.worldSizeStep, { ...progress.worlds, [id]: next })
}
