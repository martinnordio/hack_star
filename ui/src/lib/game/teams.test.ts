import { describe, expect, it } from 'vitest'
import { CANYON, type Arena } from './arena'
import { Bots } from './bots'
import { Match } from './match'
import { BOT_LEVELS, SETTINGS } from './settings'
import { FIGHTER_TYPES } from './types'
import { World } from './world'

const tick = 1 / 60

function run(seconds: number, each: (dt: number) => void) {
  for (let t = 0; t < seconds; t += tick) each(tick)
}

/** Three in a column: 0 at the bottom, 1 in the middle, 2 at the top. */
const column: Arena = {
  ...CANYON,
  walls: [],
  bushes: [],
  spawns: [
    { x: 0, z: 4 },
    { x: 0, z: 0 },
    { x: 0, z: -4 },
    { x: 12, z: 10 },
  ],
}

describe('teams', () => {
  it('shots fly through teammates and hurt only enemies', () => {
    const w = new World(column, { fighters: 3, teams: [0, 0, 2] })
    w.fire(0, -1)
    run(1, (dt) => w.step(dt))
    expect(w.fighters[1].health).toBe(w.fighters[1].maxHealth)
    expect(w.fighters[2].health).toBeLessThan(w.fighters[2].maxHealth)
  })

  it('explosions and dashes spare teammates', () => {
    const thrower = new World(column, { fighters: 3, teams: [0, 0, 2], types: [FIGHTER_TYPES.thrower] })
    thrower.fire(0, -4)
    run(1.5, (dt) => thrower.step(dt))
    expect(thrower.fighters[1].health).toBe(thrower.fighters[1].maxHealth)

    const speedy = new World(column, { fighters: 3, teams: [0, 0, 2], types: [FIGHTER_TYPES.speedy] })
    speedy.player.superCharge = 1
    speedy.useSuper(speedy.player, 0, -1)
    run(0.6, (dt) => speedy.step(dt))
    expect(speedy.fighters[1].health).toBe(speedy.fighters[1].maxHealth)
  })

  it('without teams everyone is an enemy (today\u2019s game)', () => {
    const w = new World(column, { fighters: 3 })
    w.fire(0, -1)
    run(1, (dt) => w.step(dt))
    expect(w.fighters[1].health).toBeLessThan(w.fighters[1].maxHealth)
  })

  it('the player can be any fighter', () => {
    const w = new World(column, { fighters: 3, playerId: 2 })
    expect(w.player.id).toBe(2)
  })

  it('bots never target a teammate and leave people alone', () => {
    const w = new World(column, { fighters: 4, teams: [0, 0, 2, 3] })
    const bots = new Bots(w, BOT_LEVELS.hard, true, () => 0.5, [0, 1])
    expect(bots.states.map((s) => s.id)).toEqual([2, 3])
    bots.addBot(1)
    expect(bots.states.map((s) => s.id)).toEqual([2, 3, 1])
    run(1, (dt) => {
      bots.think(dt)
      w.step(dt)
    })
    // Fighter 1 (now a bot on team 0) never shot fighter 0.
    expect(w.player.health).toBe(w.player.maxHealth)
  })
})

describe('team match', () => {
  const settings = { ...SETTINGS, botCount: 2, countdownSeconds: 0.1, overtimeSeconds: 0 }

  it('friends take the place of bots, with at least one bot', () => {
    expect(new Match(CANYON, settings, { humans: 2 }).world.fighters).toHaveLength(3)
    expect(new Match(CANYON, { ...settings, botCount: 1 }, { humans: 3 }).world.fighters).toHaveLength(4)
    const m = new Match(CANYON, settings, { humans: 2, powers: [11, 3] })
    expect(m.world.fighters.map((f) => f.team)).toEqual([0, 0, 2])
    expect(m.world.fighters[0].maxHealth).toBeGreaterThan(m.world.fighters[1].maxHealth)
    expect(m.bots!.states.map((s) => s.id)).toEqual([2])
  })

  it('the team wins even when one of them is out', () => {
    const m = new Match(CANYON, settings, { humans: 2, bots: false })
    run(0.2, (dt) => m.update(dt))
    m.world.fighters[0].out = true
    m.world.fighters[2].out = true
    run(0.1, (dt) => m.update(dt))
    expect(m.result).toEqual({ kind: 'victory' })
  })

  it('the team loses with a place when all of it is out', () => {
    const m = new Match(CANYON, { ...settings, botCount: 3 }, { humans: 2, bots: false })
    run(0.2, (dt) => m.update(dt))
    m.world.fighters[0].out = true
    expect(m.result).toBeNull()
    m.world.fighters[1].out = true
    run(0.1, (dt) => m.update(dt))
    expect(m.result).toEqual({ kind: 'defeat', place: 3 })
  })
})
