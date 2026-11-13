import { describe, expect, it } from 'vitest'
import { CANYON } from '../game/arena'
import { SETTINGS } from '../game/settings'
import { RoomConnection, type Seat, type Socket } from './room'
import { GuestMatch, HostMatch, SEND_EVERY, startInfo } from './shared'

const tick = 1 / 60
const catalogue = [
  { id: 'blaze', type: 'spreader' },
  { id: 'rocko', type: 'tank' },
  { id: 'luna', type: 'sharpshooter' },
  { id: 'coco', type: 'thrower' },
]
const seats: Seat[] = [
  { slot: 0, fighter: 'blaze', skin: 'default', power: 7, hyper: false },
  { slot: 1, fighter: 'rocko', skin: 'crystal', power: 4, hyper: true },
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
  }
}

function setup() {
  const settings = { ...SETTINGS, botCount: 3, countdownSeconds: 0.2 }
  const start = startInfo(settings, seats, catalogue, () => 0.5)
  const net = hub()
  const host = new HostMatch(CANYON, start, net.host)
  const guest = new GuestMatch(CANYON, start, 1, net.friend)
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
    const start = startInfo(settings, [seats[0], created], [...catalogue, { id: 'custom', type: 'spreader' }], () => 0.5)
    expect(start.fighters[1]).toMatchObject({ fighter: 'custom', type: 'thrower', skin: created.skin })
    expect(start.fighters.slice(2).some((f) => f.fighter === 'custom')).toBe(false)
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
})
