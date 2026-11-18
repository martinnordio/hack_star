import { writable } from 'svelte/store'
import type { TextKey } from '../i18n/en'
import { createdLookFor } from '../created'
import { powerOf } from '../game/economy'
import { wornSkin } from '../game/shop'
import { currentFighter, isHackActive } from '../hacks'
import type { Fighter } from '../fighters'
import type { Progress } from '../progress'

/** What a device tells the others about its player (see server `rooms.py`). */
export interface Member {
  fighter: string
  skin: string
  power: number
  /** The HYPERCHARGE hack is on for this player. */
  hyper: boolean
  /** The name of a created fighter (its look is in `skin`). */
  name?: string
  /** Missing for the previous version of the game, which plays only in Canyon Small (D11). */
  version?: number
}

/** The room version of this game: friends with it can play in every world. */
export const ROOM_VERSION = 2

export function memberFor(progress: Progress, fighters: Fighter[]): Member {
  const fighter = currentFighter(progress, fighters)
  const look = createdLookFor(progress, fighter.id)
  return {
    fighter: fighter.id,
    skin: wornSkin(progress, fighter.id),
    power: powerOf(progress, fighter.id),
    hyper: isHackActive(progress, 'hypercharge'),
    ...(look ? { name: look.name } : {}),
    version: ROOM_VERSION,
  }
}

/** A friend on the previous version can play only in Canyon Small; the server removes them elsewhere. */
export function canPlayIn(member: Member, world: { id: string; size: string }): boolean {
  return member.version !== undefined || (world.id === 'canyon' && world.size === 'small')
}

export interface Seat extends Member {
  slot: number
}

export interface RoomInfo {
  code: string
  /** This device's slot: 0 is the host. */
  you: number
  started: boolean
  members: Seat[]
}

export type RoomMessage = { type: string; [key: string]: unknown }

type Listener = (message: RoomMessage) => void

/** The parts of a WebSocket the room uses (tests pass a fake). */
export interface Socket {
  readyState: number
  send(text: string): void
  close(): void
  onmessage: ((event: { data: unknown }) => void) | null
  onclose: (() => void) | null
}

export const ERRORS: Record<string, TextKey> = {
  'no-room': 'room.error.noRoom',
  full: 'room.error.full',
  started: 'room.error.started',
  'bad-member': 'room.error.badMember',
  'too-many-rooms': 'room.error.tooManyRooms',
  disconnected: 'room.error.disconnected',
  closed: 'room.error.closed',
  'update-the-game': 'room.error.update',
}

/** One device's connection to a room on the game server. */
export class RoomConnection {
  private listeners = new Set<Listener>()

  constructor(private socket: Socket) {
    socket.onmessage = (event) => {
      let message: unknown
      try {
        message = JSON.parse(String(event.data))
      } catch {
        return
      }
      if (typeof message === 'object' && message !== null && 'type' in message) {
        for (const listener of [...this.listeners]) listener(message as RoomMessage)
      }
    }
    socket.onclose = () => {
      for (const listener of [...this.listeners]) listener({ type: 'disconnected' })
    }
  }

  send<T extends { type: string }>(message: T) {
    if (this.socket.readyState === 1) this.socket.send(JSON.stringify(message))
  }

  on(listener: Listener): () => void {
    this.listeners.add(listener)
    return () => this.listeners.delete(listener)
  }

  close() {
    this.listeners.clear()
    this.socket.onclose = null
    this.socket.close()
  }
}

export function roomLink(origin: string, code: string): string {
  return `${origin}/?room=${encodeURIComponent(code)}`
}

/** A room code from a typed code or a scanned `?room=` link. */
export function codeFrom(text: string): string {
  let code = text
  try {
    code = new URL(text).searchParams.get('room') ?? text
  } catch {
    // Not a link: the text is the code.
  }
  return code.trim().toUpperCase().replace(/[^A-Z]/g, '').slice(0, 4)
}

function openSocket(): Promise<RoomConnection> {
  return new Promise((resolve, reject) => {
    const protocol = location.protocol === 'https:' ? 'wss' : 'ws'
    const socket = new WebSocket(`${protocol}://${location.host}/api/rooms`)
    socket.onopen = () => resolve(new RoomConnection(socket as unknown as Socket))
    socket.onerror = () => reject(new Error('disconnected'))
  })
}

export interface RoomState {
  connection: RoomConnection
  info: RoomInfo | null
  /** A text key, or the server's reason when it is unknown. */
  error: string | null
  /** Friends the server removed at the last start because their game is too old for the world. */
  removed: Seat[]
}

/** The room this device is in (one at a time). */
export const room = writable<RoomState | null>(null)

let current: RoomState | null = null
room.subscribe((value) => (current = value))
let attempt = 0

async function enter(message: RoomMessage): Promise<void> {
  leaveRoom()
  const mine = ++attempt
  let connection: RoomConnection
  try {
    connection = await openSocket()
  } catch {
    if (mine === attempt) room.set({ connection: new RoomConnection(closedSocket()), info: null, error: ERRORS.disconnected, removed: [] })
    return
  }
  if (mine !== attempt) {
    // A newer create or join started meanwhile.
    connection.close()
    return
  }
  connection.on((m) => {
    if (m.type === 'room') room.update((s) => s && { ...s, info: m as unknown as RoomInfo, error: null })
    else if (m.type === 'error') room.update((s) => s && { ...s, error: ERRORS[String(m.reason)] ?? String(m.reason) })
    else if (m.type === 'removed') room.update((s) => s && { ...s, removed: removedSeats(m) })
    else if (m.type === 'closed' || m.type === 'disconnected')
      room.update((s) => s && { ...s, info: null, error: ERRORS[m.type] })
  })
  room.set({ connection, info: null, error: null, removed: [] })
  connection.send(message)
}

export const createRoom = (member: Member) => enter({ type: 'create', member })
export const joinRoom = (code: string, member: Member) => enter({ type: 'join', code, member })

export function leaveRoom() {
  attempt++
  current?.connection.close()
  room.set(null)
}

/** The host starts again: the last removal notice is old news. */
export function clearRemoved() {
  room.update((s) => s && { ...s, removed: [] })
}

function removedSeats(m: RoomMessage): Seat[] {
  const members = Array.isArray(m.members) ? (m.members as unknown[]) : []
  return members.filter(
    (s): s is Seat =>
      typeof s === 'object' && s !== null && typeof (s as Seat).slot === 'number' && typeof (s as Seat).fighter === 'string',
  )
}

function closedSocket(): Socket {
  return { readyState: 3, send() {}, close() {}, onmessage: null, onclose: null }
}
