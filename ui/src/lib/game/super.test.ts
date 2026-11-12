import { describe, expect, it } from 'vitest'
import { CANYON, type Arena } from './arena'
import { Bots } from './bots'
import { BOT_LEVELS, SETTINGS } from './settings'
import { PLAYER_SPEED, World } from './world'

const tick = 1 / 60

/** Player at the bottom, a wall in the middle, an enemy (or a dummy) at the top. */
const field: Arena = {
  ...CANYON,
  walls: [{ x: 0, z: -2, w: 6, d: 1 }],
  bushes: [],
  dummies: [{ x: 0, z: -5 }],
  start: { x: 0, z: 2 },
  spawns: [
    { x: 0, z: 2 },
    { x: 0, z: -5 },
    { x: 12, z: 10 },
  ],
}

/** Enemy straight below the player with nothing in between. */
const open: Arena = { ...field, walls: [], spawns: [{ x: 0, z: 0 }, { x: 0, z: -4 }] }

function run(world: World, seconds: number, each?: () => void) {
  for (let t = 0; t < seconds; t += tick) {
    each?.()
    world.step(tick)
  }
}

/** Land `hits` normal shots on fighter 1. */
function hit(world: World, hits: number) {
  const target = world.fighters[1]
  for (let i = 0; i < hits; i++) {
    run(world, 0.4)
    world.fire(target.x - world.player.x, target.z - world.player.z)
    run(world, 0.4)
    target.health = target.maxHealth
  }
}

describe('Super', () => {
  it('5 normal hits fill the Super meter', () => {
    const world = new World(open, { fighters: 2 })
    hit(world, 4)
    expect(world.player.superCharge).toBeCloseTo(0.8)
    hit(world, 1)
    expect(world.player.superCharge).toBe(1)
  })

  it('needs a full meter, and using it empties the meter', () => {
    const world = new World(open, { fighters: 2 })
    world.player.superCharge = 0.8
    expect(world.useSuper(world.player, 0, -1)).toBe(false)
    world.player.superCharge = 1
    expect(world.useSuper(world.player, 0, -1)).toBe(true)
    expect(world.player.superCharge).toBe(0)
    expect(world.shots.filter((s) => s.superShot)).toHaveLength(SETTINGS.superShots)
    expect(world.drainEvents().find((e) => e.type === 'super')).toMatchObject({ by: 0, hyper: false })
  })

  it('the blast goes through walls and does more damage; its hits do not charge', () => {
    const world = new World(field, { fighters: 2 })
    world.player.superCharge = 1
    world.useSuper(world.player, 0, -1)
    run(world, 1)
    const enemy = world.fighters[1]
    expect(enemy.maxHealth - enemy.health).toBeGreaterThan(SETTINGS.shotDamage)
    expect(world.player.superCharge).toBe(0)
  })

  it('a normal shot is still stopped by the wall', () => {
    const world = new World(field, { fighters: 2 })
    world.fire(0, -1)
    run(world, 1)
    expect(world.fighters[1].health).toBe(world.fighters[1].maxHealth)
  })

  it('hitting training dummies charges the Super too', () => {
    const world = new World(open)
    for (let i = 0; i < 5; i++) {
      run(world, 0.4)
      world.fire(0, -1)
      run(world, 0.5)
    }
    expect(world.player.superCharge).toBe(1)
  })
})

describe('Hypercharge', () => {
  it('2 Supers fill it; the next Super is a Hypercharge', () => {
    const world = new World(open, { fighters: 2 })
    for (let i = 0; i < 2; i++) {
      world.player.superCharge = 1
      world.useSuper(world.player, 0, -1)
    }
    expect(world.player.hyperCharge).toBe(1)
    expect(world.hyperReady(world.player)).toBe(true)
    world.drainEvents()
    world.player.superCharge = 1
    world.useSuper(world.player, 0, -1)
    const events = world.drainEvents()
    expect(events.some((e) => e.type === 'hypercharge' && e.fighterId === 0)).toBe(true)
    expect(events.find((e) => e.type === 'super')).toMatchObject({ hyper: true })
    expect(world.shots.filter((s) => s.superShot).length).toBeGreaterThanOrEqual(SETTINGS.hyperSuperShots)
    expect(world.player.hyperCharge).toBe(0)
  })

  it('lasts 5 seconds with +25% speed and damage', () => {
    const world = new World(open, { fighters: 2 })
    world.player.superCharge = 1
    world.player.hyperCharge = 1
    world.useSuper(world.player, 1, 0)
    expect(world.isHyper(world.player)).toBe(true)
    const x0 = world.player.x
    world.move(-1, 0, 0.1)
    expect(x0 - world.player.x).toBeCloseTo(PLAYER_SPEED * 1.25 * 0.1)
    run(world, 0.5)
    world.fire(0, -1)
    expect(world.shots.at(-1)!.damage).toBeCloseTo(SETTINGS.shotDamage * 1.25)
    run(world, 4.6)
    expect(world.isHyper(world.player)).toBe(false)
  })

  it('with alwaysHyper every Super is a Hypercharge; superGain charges faster', () => {
    const world = new World(open, { fighters: 2 })
    world.player.alwaysHyper = true
    world.player.superGain = SETTINGS.hackSuperGain
    hit(world, 2)
    expect(world.player.superCharge).toBe(1)
    world.useSuper(world.player, 0, -1)
    expect(world.isHyper(world.player)).toBe(true)
  })

  it('fighters that cannot hypercharge never do', () => {
    const world = new World(open, { fighters: 2 })
    world.player.canHyper = false
    for (let i = 0; i < 4; i++) {
      world.player.superCharge = 1
      world.useSuper(world.player, 0, -1)
    }
    expect(world.player.hyperCharge).toBe(0)
    expect(world.isHyper(world.player)).toBe(false)
  })
})

describe('Bots and Supers', () => {
  it('easy bots cannot hypercharge, harder ones can', () => {
    const easy = new World(open, { fighters: 2 })
    new Bots(easy, BOT_LEVELS.easy, true)
    expect(easy.fighters[1].canHyper).toBe(false)
    const hard = new World(open, { fighters: 2 })
    new Bots(hard, BOT_LEVELS.hard, true)
    expect(hard.fighters[1].canHyper).toBe(true)
  })

  it('a bot with a full Super uses it on its target', () => {
    const world = new World(open, { fighters: 2 })
    const bots = new Bots(world, BOT_LEVELS.hard, true, () => 0.5)
    world.fighters[1].superCharge = 1
    for (let t = 0; t < 1; t += tick) {
      bots.think(tick)
      world.step(tick)
    }
    expect(world.fighters[1].superCharge).toBeLessThan(1)
    expect(world.drainEvents().some((e) => e.type === 'super' && e.by === 1)).toBe(true)
  })
})
