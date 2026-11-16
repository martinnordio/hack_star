import { totalTrophies, type Progress } from '../progress'
import { SETTINGS, type Settings } from './settings'
import { WORLD_SIZES, sizeIndex, type WorldId, type WorldSize } from './worlds'

export type WorldPurchase =
  | { ok: true; progress: Progress; cost: number }
  | { ok: false; reason: 'already-unlocked' | 'locked' | 'max-size' }
  | { ok: false; reason: 'world-coins'; missing: number }

/** World coins for the 500-trophy steps the account reached and has not been paid for yet. */
export function worldCoinsFor(total: number, paidSteps: number, settings: Settings = SETTINGS): { steps: number; coins: number } {
  const steps = Math.max(0, Math.floor(total / settings.trophiesPerWorldStep) - paidSteps)
  return { steps, coins: steps * settings.worldCoinsPerStep }
}

/** Pays the world coins for new steps once; `coins` is what the result screen shows. */
export function earnWorldCoins(progress: Progress, settings: Settings = SETTINGS): { progress: Progress; coins: number } {
  const { steps, coins } = worldCoinsFor(totalTrophies(progress), progress.worldSteps, settings)
  if (steps === 0) return { progress, coins: 0 }
  return {
    progress: { ...progress, worldSteps: progress.worldSteps + steps, worldCoins: progress.worldCoins + coins },
    coins,
  }
}

export function addWorldCoins(progress: Progress, amount: number): Progress {
  return { ...progress, worldCoins: Math.max(0, progress.worldCoins + amount) }
}

export function isWorldUnlocked(progress: Progress, id: WorldId, size: WorldSize = 'small'): boolean {
  const biggest = progress.worlds[id]
  return biggest !== undefined && sizeIndex(biggest) >= sizeIndex(size)
}

export function worldPrice(size: WorldSize, settings: Settings = SETTINGS): number {
  return settings.worldPrices[size]
}

function payWorldCoins(progress: Progress, cost: number): Progress | { ok: false; reason: 'world-coins'; missing: number } {
  if (progress.worldCoins < cost) return { ok: false, reason: 'world-coins', missing: cost - progress.worldCoins }
  return { ...progress, worldCoins: progress.worldCoins - cost }
}

/** Buys a locked world, in Small, up to Medium or up to Large, at once. */
export function buyWorld(progress: Progress, id: WorldId, size: WorldSize, settings: Settings = SETTINGS): WorldPurchase {
  if (progress.worlds[id] !== undefined) return { ok: false, reason: 'already-unlocked' }
  const cost = worldPrice(size, settings)
  const paid = payWorldCoins(progress, cost)
  if ('ok' in paid) return paid
  return { ok: true, cost, progress: { ...paid, worlds: { ...paid.worlds, [id]: size } } }
}

/** Unlocks the next size of an unlocked world. */
export function growWorld(progress: Progress, id: WorldId, settings: Settings = SETTINGS): WorldPurchase {
  const biggest = progress.worlds[id]
  if (biggest === undefined) return { ok: false, reason: 'locked' }
  const next = WORLD_SIZES[sizeIndex(biggest) + 1]
  if (!next) return { ok: false, reason: 'max-size' }
  const cost = settings.worldSizeStep
  const paid = payWorldCoins(progress, cost)
  if ('ok' in paid) return paid
  return { ok: true, cost, progress: { ...paid, worlds: { ...paid.worlds, [id]: next } } }
}

/** The world and size Play and Training use next; only unlocked ones can be chosen. */
export function chooseWorld(progress: Progress, id: WorldId, size: WorldSize): Progress | null {
  if (!isWorldUnlocked(progress, id, size)) return null
  return { ...progress, selectedWorld: { id, size } }
}
