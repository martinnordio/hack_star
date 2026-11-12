import { describe, expect, it } from 'vitest'
import { CANYON, type Arena } from './arena'
import { DUMMY_HEALTH, FIRE_COOLDOWN, PLAYER_RADIUS, RESPAWN_SECONDS, SHOT_DAMAGE, World } from './world'

const empty: Arena = {
  width: 30,
  depth: 30,
  walls: [{ x: 0, z: 0, w: 4, d: 2 }],
  bushes: [{ x: 8, z: 8, r: 2 }],
  decorations: [],
  dummies: [{ x: -8, z: -8 }],
  start: { x: 0, z: 5 },
}

function run(world: World, seconds: number, each?: () => void) {
  for (let t = 0; t < seconds; t += 1 / 60) {
    each?.()
    world.step(1 / 60)
  }
}

describe('World', () => {
  it('cannot walk through a wall', () => {
    const world = new World(empty)
    run(world, 2, () => world.move(0, -1, 1 / 60))
    expect(world.player.z).toBeCloseTo(1 + PLAYER_RADIUS, 2)
  })

  it('slides along a wall when pushing diagonally into it', () => {
    const world = new World(empty)
    run(world, 0.8, () => world.move(0, -1, 1 / 60))
    const x0 = world.player.x
    run(world, 0.3, () => world.move(1, -1, 1 / 60))
    expect(world.player.x).toBeGreaterThan(x0 + 0.5)
    expect(world.player.z).toBeCloseTo(1 + PLAYER_RADIUS, 2)
  })

  it('stays inside the arena', () => {
    const world = new World(empty)
    run(world, 5, () => world.move(1, 1, 1 / 60))
    expect(world.player.x).toBeCloseTo(15 - PLAYER_RADIUS)
    expect(world.player.z).toBeCloseTo(15 - PLAYER_RADIUS)
  })

  it('a shot stops at a wall', () => {
    const world = new World(empty)
    expect(world.fire(0, -1)).toBe(true)
    run(world, 1)
    expect(world.shots).toHaveLength(0)
    const blocked = world.drainEvents().find((e) => e.type === 'blocked')
    expect(blocked && blocked.type === 'blocked' && blocked.z).toBeGreaterThan(0.9)
  })

  it('waits for the cool-down between shots', () => {
    const world = new World(empty)
    expect(world.fire(1, 0)).toBe(true)
    expect(world.fire(1, 0)).toBe(false)
    run(world, FIRE_COOLDOWN + 0.02)
    expect(world.fire(1, 0)).toBe(true)
  })

  it('hits a dummy, breaks it at 0 health and brings it back after 5 s', () => {
    const world = new World({ ...empty, walls: [], start: { x: -8, z: -4 } })
    const dummy = world.dummies[0]
    const shotsNeeded = Math.ceil(DUMMY_HEALTH / SHOT_DAMAGE)
    for (let i = 0; i < shotsNeeded; i++) {
      world.fire(0, -1)
      run(world, FIRE_COOLDOWN + 0.05)
      if (i === 0) expect(dummy.health).toBe(DUMMY_HEALTH - SHOT_DAMAGE)
    }
    expect(dummy.health).toBe(0)
    expect(dummy.brokenAt).not.toBeNull()
    const events = world.drainEvents()
    expect(events.filter((e) => e.type === 'hit')).toHaveLength(shotsNeeded)
    expect(events.some((e) => e.type === 'break')).toBe(true)

    world.fire(0, -1)
    run(world, 1)
    expect(dummy.health).toBe(0)

    run(world, RESPAWN_SECONDS)
    expect(dummy.brokenAt).toBeNull()
    expect(dummy.health).toBe(DUMMY_HEALTH)
    expect(world.drainEvents().some((e) => e.type === 'respawn')).toBe(true)
  })

  it('knows when the fighter stands in a bush', () => {
    const world = new World(empty)
    expect(world.inBush()).toBe(false)
    world.player.x = 8.5
    world.player.z = 7.5
    expect(world.inBush()).toBe(true)
  })

  it('the canyon start point is free and every dummy is reachable', () => {
    const world = new World(CANYON)
    const { x, z } = world.player
    world.move(0.001, 0, 0.001)
    expect(world.player.x).toBeCloseTo(x, 2)
    expect(world.player.z).toBeCloseTo(z, 2)
    expect(world.nearestDummy()).toBeDefined()
  })
})
