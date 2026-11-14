import { describe, expect, it } from 'vitest'
import type { Track } from './candidates'
import { createMusicPlayer, musicTrack, type AudioLike } from './player'

const track = (id: string): Track => ({ id, title: id, author: 'Us', licence: 'CC0', source: 'https://example.org', file: `${id}.mp3` })

function fakeAudio() {
  const log: string[] = []
  const audio: AudioLike = {
    src: '',
    loop: false,
    volume: 1,
    currentTime: 9,
    play: async () => void log.push(`play ${audio.src}`),
    pause: () => void log.push('pause'),
  }
  return { audio, log }
}

function fakePage() {
  const listeners: (() => void)[] = []
  const page = {
    visibilityState: 'visible' as DocumentVisibilityState,
    addEventListener: (_type: 'visibilitychange', listener: () => void) => void listeners.push(listener),
    set(state: DocumentVisibilityState) {
      page.visibilityState = state
      listeners.forEach((l) => l())
    },
  }
  return page
}

describe('music', () => {
  it('plays the chosen track, the first one if it is gone, and nothing when off', () => {
    const tracks = [track('a'), track('b')]
    expect(musicTrack({ music: true, track: 'b' }, tracks)?.id).toBe('b')
    expect(musicTrack({ music: true, track: 'gone' }, tracks)?.id).toBe('a')
    expect(musicTrack({ music: true, track: '' }, tracks)?.id).toBe('a')
    expect(musicTrack({ music: false, track: 'b' }, tracks)).toBeUndefined()
    expect(musicTrack({ music: true, track: 'b' }, [])).toBeUndefined()
  })

  it('starts a looping track from the beginning and stops it', () => {
    const { audio, log } = fakeAudio()
    const player = createMusicPlayer(() => audio, fakePage())
    player.start(track('a'))
    expect(audio).toMatchObject({ src: '/assets/music/a.mp3', loop: true, currentTime: 0 })
    expect(log.at(-1)).toBe('play /assets/music/a.mp3')
    expect(player.playing).toBe(true)
    player.stop()
    expect(log.at(-1)).toBe('pause')
    expect(player.playing).toBe(false)
  })

  it('pauses while the page is hidden and goes on when it is shown, only while playing', () => {
    const { audio, log } = fakeAudio()
    const page = fakePage()
    const player = createMusicPlayer(() => audio, page)
    player.start(track('a'))
    page.set('hidden')
    expect(log.at(-1)).toBe('pause')
    page.set('visible')
    expect(log.at(-1)).toBe('play /assets/music/a.mp3')
    player.stop()
    const count = log.length
    page.set('hidden')
    page.set('visible')
    expect(log.length).toBe(count)
  })
})
