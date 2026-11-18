import { describe, expect, it } from 'vitest'
import { SETTINGS } from '../game/settings'
import { RoomConnection, type Seat, type Socket } from './room'
import { arenaFor } from '../game/worlds'
import { GuestMatch, HostMatch, SEND_EVERY, sharedArena, startInfo, type SharedWorld, type StartInfo } from './shared'

const tick = 1 / 60
const catalogue = [
  { id: 'blaze', type: 'spreader' },
  { id: 'rocko', type: 'tank' },
  { id: 'luna', type: 'sharpshooter' },
  { id: 'coco', type: 'thrower' },
]
const CANYON_SMALL: SharedWorld = { id: 'canyon', size: 'small' }
const LARGE_DOCKS: SharedWorld = { id: 'neon-docks', size: 'large' }
const seats: Seat[] = [
  { slot: 0, fighter: 'blaze', skin: 'default', power: 7, hyper: false, version: 2 },
  { slot: 1, fighter: 'rocko', skin: 'crystal', power: 4, hyper: true, version: 2 },
]

/** Two connections joined like the server does: the host's messages go to the friend, the friend's input to the host. */
function hub() {
  const sockets: Socket[] = [0, 1].map(() => ({ readyState: 1, send() {}, close() {}, onmessage: null, onclose: null }))
  const deliver = (to: Socket, message: object) => to.onmessage?.({ data: JSON.stringify(message) })
  sockets[0].send = (text) => deliver(sockets[1], JSON.parse(text))
  sockets[1].send = (text) => deliver(sockets[0], { ...JSON.parse(text), slot: 1 })
  return {
    host: new RoomConnection(sockets[0]),
    friend: new RoomConnection(sockets[1]),
    friendLeaves: () => deliver(sockets[0], { type: 'left', slot: 1 }),
    hostLeaves: () => deliver(sockets[1], { type: 'closed' }),
    toHost: (message: object) => deliver(sockets[0], message),
  }
}

function setup(world = CANYON_SMALL) {
  const settings = { ...SETTINGS, botCount: 3, countdownSeconds: 0.2 }
  const start = startInfo(settings, seats, catalogue, world, () => 0.5)
  // The friend gets the start message through the server, as JSON.
  const received = JSON.parse(JSON.stringify(start)) as StartInfo
  const net = hub()
  const host = new HostMatch(sharedArena(start).arena, start, net.host)
  const guest = new GuestMatch(sharedArena(received).arena, received, 1, net.friend)
  const run = (seconds: number, each?: () => void) => {
    for (let t = 0; t < seconds; t += tick) {
      each?.()
      host.update(tick)
      guest.update(tick)
    }
  }
  return { start, host, guest, net, run }
}

describe('shared match', () => {
  it('a created fighter plays with the type in its look; bots never take it', () => {
    const settings = { ...SETTINGS, botCount: 5 }
    const created: Seat = { slot: 1, fighter: 'custom', skin: 'L321e8322b39d353', power: 3, hyper: false, name: 'Zappy' }
    const start = startInfo(settings, [seats[0], created], [...catalogue, { id: 'custom', type: 'spreader' }], CANYON_SMALL, () => 0.5)
    expect(start.fighters[1]).toMatchObject({ fighter: 'custom', type: 'thrower', skin: created.skin })
    expect(start.fighters.slice(2).some((f) => f.fighter === 'custom')).toBe(false)
  })

  it('distinct created fighters retain their IDs and derive their types from their looks', () => {
    const settings = { ...SETTINGS, botCount: 3 }
    const first: Seat = { slot: 0, fighter: 'custom', skin: 'L321e8322b39d353', power: 3, hyper: false, name: 'Nova' }
    const extra: Seat = { slot: 1, fighter: 'custom-2', skin: 'L010ff8a1affd23f', power: 5, hyper: false, name: 'Comet' }
    const start = startInfo(settings, [first, extra], [...catalogue, { id: 'custom', type: 'spreader' }], CANYON_SMALL, () => 0.5)
    expect(start.fighters.slice(0, 2)).toMatchObject([
      { fighter: 'custom', type: 'thrower', skin: first.skin, slot: 0 },
      { fighter: 'custom-2', type: 'tank', skin: extra.skin, slot: 1 },
    ])
    expect(start.fighters.slice(2).some((fighter) => fighter.fighter.startsWith('custom'))).toBe(false)
  })

  it('the start message puts people first, then bots with other fighters', () => {
    const { start } = setup()
    expect(start.fighters.map((f) => [f.fighter, f.slot])).toEqual([
      ['blaze', 0],
      ['rocko', 1],
      ['luna', undefined],
      ['coco', undefined],
    ])
    expect(start.fighters[1]).toMatchObject({ type: 'tank', power: 4, hyper: true })
  })

  it('both devices see the same fighters; each follows its own', () => {
    const { host, guest } = setup()
    expect(host.world.player.id).toBe(0)
    expect(guest.world.player.id).toBe(1)
    expect(guest.world.fighters.map((f) => f.team)).toEqual([0, 0, 2, 3])
    expect(guest.world.fighters[1].maxHealth).toBe(host.world.fighters[1].maxHealth)
    expect(host.world.fighters[1].alwaysHyper).toBe(true)
  })

  it('the friend moves at once on its device, and on the host a moment later', () => {
    const { host, guest, run } = setup()
    run(0.3)
    expect(guest.phase).toBe('fight')
    const x0 = guest.world.player.x
    run(0.5, () => guest.world.move(1, 0, tick))
    expect(guest.world.player.x).toBeGreaterThan(x0 + 2)
    run(SEND_EVERY * 2)
    expect(host.world.fighters[1].x).toBeCloseTo(guest.world.player.x, 1)
  })

  it('the host and the bots appear on the friend\u2019s screen, gliding to the snapshots', () => {
    const { host, guest, run } = setup()
    run(0.3)
    run(1, () => host.world.move(0, -1, tick))
    expect(guest.world.fighters[0].z).toBeCloseTo(host.world.fighters[0].z, 0)
    expect(guest.timeLeft).toBeCloseTo(host.timeLeft, 0)
  })

  it('a friend\u2019s shot is fired by the host and its damage reaches the friend\u2019s screen', () => {
    const { host, guest, run } = setup()
    run(0.3)
    const bot = host.world.fighters[2]
    bot.x = guest.world.player.x
    bot.z = guest.world.player.z - 3
    host.match.bots!.states.length = 0
    run(SEND_EVERY * 2)
    guest.fire(0, -1)
    run(1)
    expect(host.world.fighters[2].health).toBeLessThan(host.world.fighters[2].maxHealth)
    expect(guest.world.fighters[2].health).toBe(host.world.fighters[2].health)
  })

  it('the result is for the team and reaches the friend', () => {
    const { host, guest, run } = setup()
    run(0.3)
    host.world.fighters[0].out = true
    host.world.fighters[2].out = true
    host.world.fighters[3].out = true
    run(0.2)
    expect(host.result).toEqual({ kind: 'victory' })
    expect(guest.result).toEqual({ kind: 'victory' })
  })

  it('a friend who leaves becomes a bot; if the host leaves, the friend gets a draw', () => {
    const left = setup()
    left.run(0.3)
    left.net.friendLeaves()
    expect(left.host.match.bots!.states.map((s) => s.id)).toContain(1)

    const closed = setup()
    closed.run(0.3)
    closed.net.hostLeaves()
    expect(closed.guest.phase).toBe('over')
    expect(closed.guest.result).toEqual({ kind: 'timeup' })
  })

  it('a host leaving the match early gives friends a draw', () => {
    const { host, guest, run } = setup()
    run(0.3)
    host.stop()
    expect(guest.result).toEqual({ kind: 'timeup' })
  })

  it('the start message carries the host\u2019s world; the friend builds the same arena and look', () => {
    const { start, host, guest, run } = setup(LARGE_DOCKS)
    expect(start.settings.world).toEqual(LARGE_DOCKS)
    expect(sharedArena(JSON.parse(JSON.stringify(start)))).toEqual({ arena: arenaFor('neon-docks', 'large'), theme: 'neon' })
    expect(guest.world.walls).toEqual(host.world.walls)
    expect(guest.world.bushes).toEqual(host.world.bushes)
    expect(guest.world.fighters.map((f) => [f.x, f.z])).toEqual(host.world.fighters.map((f) => [f.x, f.z]))
    // The friend can walk to the far side of the Large world.
    run(0.3)
    run(6, () => guest.world.move(-1, 0, tick))
    expect(guest.world.player.x).toBeLessThan(-15)
  })

  it('a start without a known world (previous host) is played in Canyon Small', () => {
    const start = startInfo(SETTINGS, seats, catalogue, CANYON_SMALL)
    const oldSettings: Record<string, unknown> = { ...start.settings }
    delete oldSettings.world
    expect(sharedArena({ ...start, settings: oldSettings } as unknown as StartInfo).arena).toBe(arenaFor('canyon', 'small'))
    const odd = { ...start, settings: { ...start.settings, world: { id: 'mars', size: 'huge' } } } as unknown as StartInfo
    expect(sharedArena(odd)).toEqual({ arena: arenaFor('canyon', 'small'), theme: 'canyon' })
  })

  it('friends of the previous version play only in Canyon Small; a late one is taken over by a bot', () => {
    const old: Seat = { slot: 2, fighter: 'luna', skin: 'default', power: 2, hyper: false }
    const inCanyon = startInfo(SETTINGS, [...seats, old], catalogue, CANYON_SMALL, () => 0.5)
    expect(inCanyon.fighters.map((f) => f.slot)).toEqual([0, 1, 2, undefined])
    const inDocks = startInfo(SETTINGS, [...seats, old], catalogue, LARGE_DOCKS, () => 0.5)
    expect(inDocks.fighters.filter((f) => f.slot !== undefined).map((f) => f.slot)).toEqual([0, 1])

    const { host, net } = setup(LARGE_DOCKS)
    net.toHost({ type: 'removed', reason: 'update-the-game', members: [{ slot: 1 }] })
    expect(host.match.bots!.states.map((s) => s.id)).toContain(1)
  })
})
