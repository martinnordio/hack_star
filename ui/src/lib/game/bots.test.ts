import { describe, expect, it } from 'vitest'
import { CANYON, type Arena } from './arena'
import { Bots } from './bots'
import { Match } from './match'
import { BOT_LEVELS, SETTINGS } from './settings'
import { World } from './world'

const easy = BOT_LEVELS.easy

function arena(spawns: { x: number; z: number }[], bushes: Arena['bushes'] = []): Arena {
  return { ...CANYON, walls: [], bushes, spawns }
}

const tick = 1 / 60
function run(seconds: number, each: (dt: number) => void) {
  for (let t = 0; t < seconds; t += tick) each(tick)
}

function play(world: World, bots: Bots, seconds: number) {
  run(seconds, (dt) => {
    bots.think(dt)
    world.step(dt)
  })
}

describe('Bots', () => {
  it('walk towards a visible opponent that is far away', () => {
    const world = new World(arena([{ x: 0, z: 0 }, { x: 0, z: -7.5 }]), { fighters: 2 })
    const bots = new Bots(world, easy, true, () => 0.5)
    play(world, bots, 2)
    expect(world.fighters[1].z).toBeGreaterThan(-6.5)
    expect(bots.states[0].targetId).toBe(0)
  })

  it('wait for their reaction time, then shoot when in range', () => {
    const world = new World(arena([{ x: 0, z: 0 }, { x: 0, z: -5 }]), { fighters: 2 })
    const bots = new Bots(world, easy, true, () => 0.5)
    play(world, bots, easy.reaction * 0.8)
    expect(world.drainEvents().some((e) => e.type === 'fire')).toBe(false)
    expect(world.fighters[1].z).toBe(-5)
    play(world, bots, 0.3)
    expect(world.drainEvents().some((e) => e.type === 'fire' && e.by === 1)).toBe(true)
  })

  it('do not see a fighter hiding in a bush unless close', () => {
    const world = new World(arena([{ x: 0, z: 0 }, { x: 0, z: -6 }], [{ x: 0, z: 0, r: 1.5 }]), { fighters: 2 })
    const bots = new Bots(world, easy, true, () => 0.5)
    play(world, bots, 0.2)
    expect(bots.states[0].targetId).toBeNull()
  })

  it('miss on easy: shots spread by the aim error', () => {
    const world = new World(arena([{ x: 0, z: 0 }, { x: 0, z: -5 }]), { fighters: 2 })
    const bots = new Bots(world, easy, true, () => 1)
    play(world, bots, easy.reaction + 0.1)
    const fire = world.drainEvents().find((e) => e.type === 'fire' && e.by === 1)
    if (fire?.type !== 'fire') throw new Error('the bot did not shoot')
    // Direction to the player from where the shot started, compared with where it went.
    const towardsPlayer = Math.atan2(world.player.x - fire.x, world.player.z - fire.z)
    expect(Math.abs(Math.atan2(fire.dx, fire.dz) - towardsPlayer)).toBeGreaterThan(easy.aimError * 0.7)
  })

  it('fight each other when the player is out of sight', () => {
    const world = new World(arena([{ x: 0, z: 11 }, { x: -12, z: -9 }, { x: -9, z: -9 }]), { fighters: 3 })
    const bots = new Bots(world, easy, true, () => 0.5)
    play(world, bots, 0.1)
    expect(bots.states[0].targetId).toBe(2)
    expect(bots.states[1].targetId).toBe(1)
  })

  it('leave each other alone when set so', () => {
    const world = new World(arena([{ x: 0, z: 11 }, { x: -12, z: -9 }, { x: -9, z: -9 }]), { fighters: 3 })
    const bots = new Bots(world, easy, false, () => 0.5)
    play(world, bots, 0.1)
    expect(bots.states.map((s) => s.targetId)).toEqual([null, null])
  })

  it('are slower and shoot less often on easy', () => {
    const world = new World(arena([{ x: 0, z: 0 }, { x: 0, z: -5 }]), { fighters: 2 })
    new Bots(world, easy, true)
    expect(world.fighters[1].speedFactor).toBeLessThan(1)
    expect(world.fighters[1].cooldownFactor).toBeGreaterThan(1)
    expect(world.player.speedFactor).toBe(1)
  })

  it('a full match with default settings ends within its time and overtime', () => {
    const match = new Match(CANYON, SETTINGS)
    run(SETTINGS.countdownSeconds + SETTINGS.matchSeconds + SETTINGS.overtimeSeconds + 1, (dt) => match.update(dt))
    expect(match.phase).toBe('over')
    expect(match.result).not.toBeNull()
  })
})
