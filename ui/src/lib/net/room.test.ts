import { describe, expect, it } from 'vitest'
import { codeFrom, RoomConnection, roomLink, type RoomMessage, type Socket } from './room'

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
