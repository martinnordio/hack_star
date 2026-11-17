import { totalTrophies, type Progress } from '../progress'
import { SETTINGS, type Settings } from './settings'
import { sizeIndex, WORLD_SIZES, type WorldId, type WorldSize } from './worlds'

/** Buying and growing worlds costs world coins only; credits never count (S10). */
export type WorldPurchase =
  | { ok: true; progress: Progress; cost: number }
  | { ok: false; reason: 'already-unlocked' | 'locked' | 'max-size' }
  | { ok: false; reason: 'world-coins'; missing: number }

export type WorldChoice = { ok: true; progress: Progress } | { ok: false; reason: 'locked' }

/** Trophy steps the total has reached: 1 at 500, 2 at 1000, and so on. */
export function stepsReached(total: number, settings: Settings = SETTINGS): number {
  return Math.floor(total / settings.trophiesPerWorldStep)
}

/** World coins owed for the steps reached but not paid yet; a step is paid only once. */
export function worldCoinsFor(total: number, paidSteps: number, settings: Settings = SETTINGS): number {
  return Math.max(0, stepsReached(total, settings) - paidSteps) * settings.worldCoinsPerStep
}

/** Pays the world coins of the newly reached steps; `earned` is what this call paid. */
export function earnWorldCoins(progress: Progress, settings: Settings = SETTINGS): { progress: Progress; earned: number } {
  const total = totalTrophies(progress)
  const earned = worldCoinsFor(total, progress.worldSteps, settings)
  return {
    earned,
    progress: {
      ...progress,
      worldCoins: progress.worldCoins + earned,
      worldSteps: Math.max(progress.worldSteps, stepsReached(total, settings)),
    },
  }
}

/** World coins to unlock a locked world up to `size`: 500 for Small, 750 for Medium, 1000 for Large. */
export function worldPrice(size: WorldSize, settings: Settings = SETTINGS): number {
  return settings.worldPrices[size]
}

/** Unlocked at `size` or bigger (Small when not given). */
export function isWorldUnlocked(progress: Progress, id: WorldId, size: WorldSize = 'small'): boolean {
  const unlocked = progress.worlds[id]
  return unlocked !== undefined && sizeIndex(unlocked) >= sizeIndex(size)
}

function withPayment(progress: Progress, cost: number, change: (p: Progress) => Progress): WorldPurchase {
  if (progress.worldCoins < cost) return { ok: false, reason: 'world-coins', missing: cost - progress.worldCoins }
  return { ok: true, cost, progress: change({ ...progress, worldCoins: progress.worldCoins - cost }) }
}

/** Unlocks a locked world up to `size`; an unlocked world is refused (grow it instead). */
export function buyWorld(
  progress: Progress,
  id: WorldId,
  size: WorldSize = 'small',
  settings: Settings = SETTINGS,
): WorldPurchase {
  if (progress.worlds[id] !== undefined) return { ok: false, reason: 'already-unlocked' }
  return withPayment(progress, worldPrice(size, settings), (p) => ({ ...p, worlds: { ...p.worlds, [id]: size } }))
}

/** Adds one size to an unlocked world for `worldSizeStep` world coins: Small to Medium, Medium to Large. */
export function growWorld(progress: Progress, id: WorldId, settings: Settings = SETTINGS): WorldPurchase {
  const current = progress.worlds[id]
  if (current === undefined) return { ok: false, reason: 'locked' }
  const next = WORLD_SIZES[sizeIndex(current) + 1] as WorldSize | undefined
  if (next === undefined) return { ok: false, reason: 'max-size' }
  return withPayment(progress, settings.worldSizeStep, (p) => ({ ...p, worlds: { ...p.worlds, [id]: next } }))
}

/** The world and size the next match is played in; only unlocked ones can be chosen. */
export function chooseWorld(progress: Progress, id: WorldId, size: WorldSize): WorldChoice {
  if (!isWorldUnlocked(progress, id, size)) return { ok: false, reason: 'locked' }
  return { ok: true, progress: { ...progress, selectedWorld: { id, size } } }
}

/** Adds world coins (from codes or rewards); never below 0. */
export function addWorldCoins(progress: Progress, amount: number): Progress {
  return { ...progress, worldCoins: Math.max(0, progress.worldCoins + amount) }
}
