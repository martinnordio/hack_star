import { describe, expect, it } from 'vitest'
import { CANYON, type Arena } from './arena'
import { stats } from './economy'
import { SETTINGS } from './settings'
import { tournament } from './tournament'
import { BASIC, FIGHTER_TYPES, type FighterType } from './types'
import { PLAYER_SPEED, World } from './world'

const tick = 1 / 60
const T = FIGHTER_TYPES

function run(world: World, seconds: number, each?: () => void) {
  for (let t = 0; t < seconds; t += tick) {
    each?.()
    world.step(tick)
  }
}

/** Player at the bottom, a wall in the middle, an enemy at the top. */
const field: Arena = {
  ...CANYON,
  walls: [{ x: 0, z: -2, w: 6, d: 1 }],
  bushes: [],
  dummies: [],
  spawns: [
    { x: 0, z: 2 },
    { x: 0, z: -5 },
    { x: 12, z: 10 },
  ],
}
const open: Arena = { ...field, walls: [] }

function duel(type: FighterType, arena = open, enemyType: FighterType = BASIC) {
  return new World(arena, {
    fighters: 2,
    types: [type, enemyType],
    stats: [stats(1, SETTINGS, type), stats(1, SETTINGS, enemyType)],
  })
}

const lost = (w: World, id = 1) => w.fighters[id].maxHealth - w.fighters[id].health

describe('fighter types', () => {
  it('health and damage follow the type', () => {
    expect(stats(1, SETTINGS, T.tank).health).toBeGreaterThan(stats(1).health)
    expect(stats(1, SETTINGS, T.sharpshooter).health).toBeLessThan(stats(1).health)
    expect(stats(1, SETTINGS, BASIC)).toEqual(stats(1))
  })

  it('a Tank cannot reach far; a Sharpshooter can', () => {
    const far: Arena = { ...open, spawns: [{ x: 0, z: 2 }, { x: 0, z: -6 }] }
    const tank = duel(T.tank, far)
    tank.fire(0, -1)
    run(tank, 1.5)
    expect(lost(tank)).toBe(0)
    const sniper = duel(T.sharpshooter, far)
    sniper.fire(0, -1)
    run(sniper, 1.5)
    expect(lost(sniper)).toBeGreaterThan(0)
  })

  it('Speedy runs faster', () => {
    const w = duel(T.speedy)
    const x0 = w.player.x
    w.move(1, 0, 0.1)
    expect(w.player.x - x0).toBeCloseTo(PLAYER_SPEED * 1.25 * 0.1)
  })

  it('a Spreader fires a fan of 3; up close all of them hit', () => {
    const w = duel(T.spreader, { ...open, spawns: [{ x: 0, z: 0 }, { x: 0, z: -1.6 }] })
    w.fire(0, -1)
    expect(w.shots).toHaveLength(3)
    run(w, 0.5)
    expect(lost(w)).toBe(3 * Math.round(w.player.damage * T.spreader.attack.share))
  })

  it('a Thrower lobs over the wall and the explosion hurts', () => {
    const w = duel(T.thrower, field)
    w.fire(0, -7)
    run(w, 1.2)
    expect(lost(w)).toBe(w.player.damage)
    expect(w.drainEvents().some((e) => e.type === 'explode')).toBe(true)
  })

  it('normal shots of other types are stopped by the wall', () => {
    const w = duel(T.sharpshooter, field)
    w.fire(0, -1)
    run(w, 1)
    expect(lost(w)).toBe(0)
  })
})

describe('Supers per type', () => {
  function superOf(type: FighterType, arena = field, aim = { x: 0, z: -7 }, hyper = false) {
    const w = duel(type, arena)
    w.player.superCharge = 1
    if (hyper) w.player.hyperCharge = 1
    expect(w.useSuper(w.player, aim.x, aim.z)).toBe(true)
    return w
  }

  it('Shockwave: a ring of shots all around; bigger when hypercharged', () => {
    expect(superOf(T.tank).shots).toHaveLength(16)
    expect(superOf(T.tank, field, undefined, true).shots).toHaveLength(24)
  })

  it('Piercing beam goes through the wall and through every fighter on its way', () => {
    const line: Arena = { ...field, spawns: [{ x: 0, z: 4 }, { x: 0, z: -5 }, { x: 0, z: -8 }] }
    const w = new World(line, { fighters: 3, types: [T.sharpshooter, BASIC, BASIC] })
    w.player.superCharge = 1
    w.useSuper(w.player, 0, -1)
    run(w, 1)
    expect(lost(w, 1)).toBeGreaterThan(0)
    expect(lost(w, 2)).toBeGreaterThan(0)
  })

  it('Big bomb flies over the wall and explodes wide', () => {
    const w = superOf(T.thrower)
    run(w, 1.2)
    expect(lost(w)).toBeGreaterThan(2 * w.player.damage)
    expect(w.drainEvents().find((e) => e.type === 'explode')).toMatchObject({ radius: 3 })
  })

  it('Dash rushes forward and hits the enemy on the way, once', () => {
    const w = superOf(T.speedy, open, { x: 0, z: -1 })
    const z0 = w.player.z
    run(w, 0.6)
    expect(z0 - w.player.z).toBeGreaterThan(5)
    expect(lost(w)).toBe(Math.round(w.player.damage * 2.2))
    expect(w.player.dash).toBeNull()
  })

  it('Super blast for Spreaders', () => {
    expect(superOf(T.spreader).shots).toHaveLength(SETTINGS.superShots)
  })

  it('normal hits of a Spreader fill the Super by damage, not by pellets', () => {
    const w = duel(T.spreader, { ...open, spawns: [{ x: 0, z: 0 }, { x: 0, z: -1.6 }] })
    w.fire(0, -1)
    run(w, 0.5)
    expect(w.player.superCharge).toBeCloseTo((3 * T.spreader.attack.share) / SETTINGS.superHits, 2)
  })
})

describe('fairness', () => {
  it('in bot-only matches every type wins 10% to 30% of the decided ones', () => {
    const { wins, decided } = tournament(200)
    expect(decided).toBeGreaterThan(150)
    for (const [id, n] of Object.entries(wins)) {
      expect(n / decided, `${id} won ${n} of ${decided}`).toBeGreaterThanOrEqual(0.1)
      expect(n / decided, `${id} won ${n} of ${decided}`).toBeLessThanOrEqual(0.3)
    }
  }, 60_000)
})
