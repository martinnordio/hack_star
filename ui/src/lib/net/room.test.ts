import { describe, expect, it } from 'vitest'
import { codeFrom, ERRORS, MEMBER_VERSION, memberFor, RoomConnection, roomLink, type RoomMessage, type Socket } from './room'
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
      name: 'Comet',
      version: MEMBER_VERSION,
    })
    expect(MEMBER_VERSION).toBeGreaterThanOrEqual(2)
    expect(ERRORS.update).toBe('room.error.update')
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
