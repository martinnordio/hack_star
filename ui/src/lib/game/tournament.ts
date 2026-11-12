import { CANYON } from './arena'
import { Bots } from './bots'
import { stats } from './economy'
import { BOT_LEVELS, SETTINGS } from './settings'
import { FIGHTER_TYPES, type FighterTypeId } from './types'
import { World } from './world'

/** Bot-only matches with one fighter of each type (fairness check, more fighters spec S5). */
export function tournament(matches: number, seconds = 150) {
  const tick = 1 / 60
  const ids = Object.keys(FIGHTER_TYPES) as FighterTypeId[]
  const wins = Object.fromEntries(ids.map((id) => [id, 0])) as Record<FighterTypeId, number>
  let seed = 7
  const random = () => ((seed = (seed * 16807) % 2147483647) / 2147483647)
  let decided = 0
  let time = 0
  for (let m = 0; m < matches; m++) {
    // Rotate who starts where, so no type always gets the best spot.
    const types = ids.map((_, i) => FIGHTER_TYPES[ids[(i + m) % ids.length]])
    const world = new World(CANYON, { fighters: types.length, types, stats: types.map((t) => stats(5, SETTINGS, t)) })
    const bots = new Bots(world, BOT_LEVELS.hard, true, random, [])
    let t = 0
    for (; t < seconds && world.alive().length > 1; t += tick) {
      bots.think(tick)
      world.step(tick)
      if (t > seconds - 30) world.removeCover()
    }
    time += t
    const alive = world.alive()
    if (alive.length === 1) {
      wins[alive[0].type.id as FighterTypeId]++
      decided++
    }
  }
  return { wins, decided, averageSeconds: Math.round(time / matches) }
}
