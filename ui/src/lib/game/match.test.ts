import { describe, expect, it } from 'vitest'
import { CANYON, type Arena } from './arena'
import { Match } from './match'
import { SETTINGS } from './settings'
import { SHOT_DAMAGE, World } from './world'

const open: Arena = {
  ...CANYON,
  walls: [],
  bushes: [],
  spawns: [
    { x: 0, z: 0 },
    { x: 0, z: -4 },
    { x: 10, z: 10 },
    { x: -10, z: 10 },
  ],
}

const tick = 1 / 60

function run(seconds: number, each: (dt: number) => void) {
  for (let t = 0; t < seconds; t += tick) each(tick)
}

/** Fire at fighter `target` from fighter 0 until it is out or time is up. */
function shootUntilOut(world: World, target: number, seconds = 20) {
  const f = world.fighters[target]
  run(seconds, (dt) => {
    if (f.out) return
    world.fire(f.x - world.player.x, f.z - world.player.z)
    world.step(dt)
  })
}

describe('World with fighters', () => {
  it('a shot hurts another fighter but never its shooter', () => {
    const world = new World(open, { fighters: 2 })
    world.fire(0, -1)
    run(0.5, (dt) => world.step(dt))
    expect(world.fighters[1].health).toBe(world.fighters[1].maxHealth - SHOT_DAMAGE)
    expect(world.player.health).toBe(world.player.maxHealth)
    const hurt = world.drainEvents().find((e) => e.type === 'hurt')
    expect(hurt).toMatchObject({ fighterId: 1, by: 0 })
  })

  it('heals after 3 calm seconds, not before', () => {
    const world = new World(open, { fighters: 2 })
    world.fire(0, -1)
    run(0.5, (dt) => world.step(dt))
    const hurtHealth = world.fighters[1].health
    run(2, (dt) => world.step(dt))
    expect(world.fighters[1].health).toBe(hurtHealth)
    run(2, (dt) => world.step(dt))
    expect(world.fighters[1].health).toBeGreaterThan(hurtHealth)
  })

  it('knocks out a fighter at 0 health', () => {
    const world = new World(open, { fighters: 2 })
    shootUntilOut(world, 1)
    expect(world.fighters[1].out).toBe(true)
    expect(world.fighters[1].health).toBe(0)
    expect(world.drainEvents().some((e) => e.type === 'knockout' && e.fighterId === 1)).toBe(true)
    expect(world.alive()).toHaveLength(1)
  })

  it('bushes hide fighters unless the viewer is close', () => {
    const world = new World({ ...open, bushes: [{ x: 0, z: -4, r: 1 }] }, { fighters: 2 })
    expect(world.canSee(world.player, world.fighters[1], 10)).toBe(false)
    world.player.z = -2
    expect(world.canSee(world.player, world.fighters[1], 10)).toBe(true)
  })
})

describe('Match', () => {
  const settings = { ...SETTINGS, botCount: 1, countdownSeconds: 3, matchSeconds: 10 }
  const still = { bots: false }

  it('nobody moves or shoots during the countdown', () => {
    const match = new Match(open, settings, still)
    match.movePlayer(1, 0, 1)
    expect(match.firePlayer(0, -1)).toBe(false)
    expect(match.world.player.x).toBe(0)
    run(3.1, (dt) => match.update(dt))
    expect(match.phase).toBe('fight')
    match.movePlayer(1, 0, 0.5)
    expect(match.world.player.x).toBeGreaterThan(0)
  })

  it('the last one standing wins', () => {
    const match = new Match(open, settings, still)
    run(3.1, (dt) => match.update(dt))
    const bot = match.world.fighters[1]
    run(10, (dt) => {
      if (match.phase === 'fight') match.firePlayer(bot.x - match.world.player.x, bot.z - match.world.player.z)
      match.update(dt)
    })
    expect(match.result).toEqual({ kind: 'victory' })
  })

  it('a knocked-out player loses with a place', () => {
    const match = new Match(open, { ...settings, botCount: 3 }, still)
    run(3.1, (dt) => match.update(dt))
    match.world.player.health = 1
    const bot = match.world.fighters[1]
    match.world.fireFrom(bot, 0, 1)
    run(1, (dt) => match.update(dt))
    expect(match.result).toEqual({ kind: 'defeat', place: 4 })
  })

  it('time up with bots still in is a draw (or a defeat if set so) without overtime', () => {
    const noOvertime = { ...settings, overtimeSeconds: 0 }
    const draw = new Match(open, noOvertime, still)
    run(13.2, (dt) => draw.update(dt))
    expect(draw.result).toEqual({ kind: 'timeup' })

    const defeat = new Match(open, { ...noOvertime, timeUpResult: 'defeat' }, still)
    run(13.2, (dt) => defeat.update(dt))
    expect(defeat.result).toEqual({ kind: 'defeat', place: 2 })
  })

  describe('overtime', () => {
    const overtime = { ...settings, overtimeSeconds: 5 }

    it('starts when time runs out with fighters still in, and removes walls and bushes', () => {
      const match = new Match(CANYON, overtime, still)
      run(13.05, (dt) => match.update(dt))
      expect(match.result).toBeNull()
      expect(match.overtime).toBe(true)
      expect(match.timeLeft).toBeGreaterThan(4.5)
      expect(match.world.walls).toEqual([])
      expect(match.world.bushes).toEqual([])
      expect(match.world.drainEvents().filter((e) => e.type === 'coverGone')).toHaveLength(1)
    })

    it('ends in a draw when overtime runs out', () => {
      const match = new Match(open, overtime, still)
      run(17.9, (dt) => match.update(dt))
      expect(match.result).toBeNull()
      run(0.3, (dt) => match.update(dt))
      expect(match.result).toEqual({ kind: 'timeup' })
    })

    it('a win during overtime is a normal victory', () => {
      const match = new Match(open, overtime, still)
      run(13.1, (dt) => match.update(dt))
      const bot = match.world.fighters[1]
      run(4, (dt) => {
        if (match.phase === 'fight') match.firePlayer(bot.x - match.world.player.x, bot.z - match.world.player.z)
        match.update(dt)
      })
      expect(match.result).toEqual({ kind: 'victory' })
    })

    it('keeps the walls when set so', () => {
      const match = new Match(CANYON, { ...overtime, overtimeRemovesCover: false }, still)
      run(13.1, (dt) => match.update(dt))
      expect(match.overtime).toBe(true)
      expect(match.world.walls).toHaveLength(CANYON.walls.length)
    })
  })

  it('a shot flies through where a wall was once the cover is gone', () => {
    const arena: Arena = { ...open, walls: [{ x: 0, z: -2, w: 4, d: 1 }] }
    const blocked = new World(arena, { fighters: 2 })
    blocked.fire(0, -1)
    run(0.5, (dt) => blocked.step(dt))
    expect(blocked.fighters[1].health).toBe(blocked.fighters[1].maxHealth)

    const open2 = new World(arena, { fighters: 2 })
    open2.removeCover()
    open2.fire(0, -1)
    run(0.5, (dt) => open2.step(dt))
    expect(open2.fighters[1].health).toBeLessThan(open2.fighters[1].maxHealth)
    expect(CANYON.walls.length).toBeGreaterThan(0)
  })

  it('uses the number of bots from the settings', () => {
    expect(new Match(CANYON, { ...SETTINGS, botCount: 5 }).world.fighters).toHaveLength(6)
    expect(new Match(CANYON).world.fighters).toHaveLength(SETTINGS.botCount + 1)
  })

  it('gives the player the stats of its power level and bots those of the bot power', () => {
    const match = new Match(CANYON, { ...SETTINGS, botCount: 2, botPower: 5 }, { playerPower: 11 })
    const [player, bot] = match.world.fighters
    expect([player.maxHealth, player.damage]).toEqual([6400, 960])
    expect([bot.maxHealth, bot.damage]).toEqual([4480, 672])
  })
})

describe('Power in the world', () => {
  it('a shot does its shooter\u2019s damage', () => {
    const world = new World(open, { fighters: 2, stats: [{ health: 6400, damage: 960 }] })
    world.fire(0, -1)
    run(0.5, (dt) => world.step(dt))
    expect(world.fighters[1].health).toBe(3200 - 960)
    expect(world.drainEvents().find((e) => e.type === 'hurt')).toMatchObject({ damage: 960 })
  })
})
