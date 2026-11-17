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
  /** The game version of the device; missing for older versions. */
  version?: number
}

/** The version this build sends; a friend without a newer one cannot play in other worlds. */
export const MEMBER_VERSION = 2

export function memberFor(progress: Progress, fighters: Fighter[]): Member {
  const fighter = currentFighter(progress, fighters)
  const look = createdLookFor(progress, fighter.id)
  return {
    fighter: fighter.id,
    skin: wornSkin(progress, fighter.id),
    power: powerOf(progress, fighter.id),
    hyper: isHackActive(progress, 'hypercharge'),
    version: MEMBER_VERSION,
    ...(look ? { name: look.name } : {}),
  }
}

/** A player's name: a created fighter's own name, else the fighter's name. */
export function displayName(member: Member, fighters: Fighter[]): string {
  return member.name ?? fighters.find((f) => f.id === member.fighter)?.name ?? member.fighter
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
  update: 'room.error.update',
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
  /** Friends the host lost at its last start because they are on an older version. */
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
    else if (m.type === 'removed') room.update((s) => s && { ...s, removed: m.members as unknown as Seat[] })
    else if (m.type === 'closed' || m.type === 'disconnected')
      // The server closes a removed friend's socket right after its reason: keep that reason.
      room.update((s) => s && { ...s, info: null, error: m.type === 'disconnected' && s.error ? s.error : ERRORS[m.type] })
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

/** Clears the friends removed at the last start, once the host has seen them. */
export function forgetRemoved() {
  room.update((s) => s && { ...s, removed: [] })
}

function closedSocket(): Socket {
  return { readyState: 3, send() {}, close() {}, onmessage: null, onclose: null }
}
