import { afterEach, beforeEach, describe, expect, it, vi } from 'vitest'
import { get } from 'svelte/store'
import { codeFrom, createRoom, forgetRemoved, leaveRoom, memberFor, room, RoomConnection, roomLink, type Member, type RoomMessage, type Socket } from './room'
import { createdFighter } from '../created'
import { defaultProgress } from '../progress'

function fakeSocket() {
  const sent: string[] = []
  const socket: Socket = {
    readyState: 1,
    send: (text) => void sent.push(text),
    close() {},
    onmessage: null,
    onclose: null,
  }
  return { socket, sent }
}

describe('room', () => {
  it('reads a typed code or a scanned link', () => {
    expect(codeFrom(' abcd ')).toBe('ABCD')
    expect(codeFrom(roomLink('http://192.168.1.20:5180', 'WXYZ'))).toBe('WXYZ')
    expect(codeFrom('ab-c1d9')).toBe('ABCD')
  })

  it('sends each created fighter ID, encoded look and name in its room member', () => {
    const look = { name: 'Comet', type: 'tank' as const, main: '#ff8a1a', second: '#ffd23f', head: 1, body: 0, hands: 0, legs: 0 }
    const fighter = createdFighter(look, 'custom-2')
    const progress = {
      ...defaultProgress(),
      createdFighters: [{ id: 'custom', look: { ...look, name: 'Nova' }, skins: [] }, { id: fighter.id, look, skins: [] }],
      selectedFighter: fighter.id,
    }
    expect(memberFor(progress, [fighter])).toMatchObject({
      fighter: 'custom-2',
      skin: 'L010ff8a1affd23f',
      version: 2,
      name: 'Comet',
    })
  })

  it('sends JSON and passes on messages; a closed socket tells its listeners', () => {
    const { socket, sent } = fakeSocket()
    const connection = new RoomConnection(socket)
    const got: RoomMessage[] = []
    connection.on((m) => got.push(m))
    connection.send({ type: 'input', x: 1 })
    expect(JSON.parse(sent[0])).toEqual({ type: 'input', x: 1 })
    socket.onmessage!({ data: '{"type":"state","t":2}' })
    socket.onmessage!({ data: 'not json' })
    socket.onclose!()
    expect(got).toEqual([{ type: 'state', t: 2 }, { type: 'disconnected' }])
  })
})

class FakeWebSocket {
  static opened: FakeWebSocket[] = []
  readyState = 0
  onopen: (() => void) | null = null
  onerror: (() => void) | null = null
  onmessage: ((event: { data: unknown }) => void) | null = null
  onclose: (() => void) | null = null

  constructor() {
    FakeWebSocket.opened.push(this)
    queueMicrotask(() => {
      this.readyState = 1
      this.onopen?.()
    })
  }

  send() {}

  close() {
    this.readyState = 3
  }

  receive(message: object) {
    this.onmessage?.({ data: JSON.stringify(message) })
  }
}

describe('room store', () => {
  const host: Member = { fighter: 'blaze', skin: 'base', power: 1, hyper: false, version: 2 }

  beforeEach(() => {
    FakeWebSocket.opened = []
    vi.stubGlobal('WebSocket', FakeWebSocket)
    vi.stubGlobal('location', { protocol: 'http:', host: 'localhost:5180' })
  })

  afterEach(() => {
    leaveRoom()
    vi.unstubAllGlobals()
  })

  it('keeps the friends a start removed until the host forgets them', async () => {
    await createRoom(host)
    const socket = FakeWebSocket.opened[0]
    socket.receive({ type: 'room', code: 'ABCD', you: 0, started: false, members: [] })
    socket.receive({
      type: 'removed',
      reason: 'update',
      members: [{ slot: 1, fighter: 'blaze', skin: 'base', power: 1, hyper: false }],
    })
    expect(get(room)?.removed.map((s) => s.slot)).toEqual([1])
    forgetRemoved()
    expect(get(room)?.removed).toEqual([])
  })

  it('keeps the update reason when the server closes the socket after it', async () => {
    await createRoom(host)
    const socket = FakeWebSocket.opened[0]
    socket.receive({ type: 'error', reason: 'update' })
    socket.onclose!()
    expect(get(room)?.error).toBe('room.error.update')
  })
})
