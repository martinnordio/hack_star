import type { Track } from './candidates'

/** The part of an audio element the player uses (a fake one in tests). */
export interface AudioLike {
  src: string
  loop: boolean
  volume: number
  currentTime: number
  play(): Promise<void>
  pause(): void
}

interface PageLike {
  readonly visibilityState: DocumentVisibilityState
  addEventListener(type: 'visibilitychange', listener: () => void): void
}

export const MUSIC_FOLDER = '/assets/music/'

/** The track to play: the chosen one, or the first if it no longer ships; none when music is off. */
export function musicTrack(options: { music: boolean; track: string }, tracks: Track[]): Track | undefined {
  if (!options.music) return undefined
  return tracks.find((t) => t.id === options.track) ?? tracks[0]
}

/** One looping track at a time; it pauses while the page is hidden. */
export function createMusicPlayer(make: () => AudioLike, page?: PageLike) {
  let audio: AudioLike | undefined
  let playing = false

  const resume = () => {
    audio?.play().catch(() => undefined)
  }

  page?.addEventListener('visibilitychange', () => {
    if (!playing) return
    if (page.visibilityState === 'hidden') audio?.pause()
    else resume()
  })

  return {
    start(track: Track) {
      audio ??= make()
      audio.pause()
      audio.src = MUSIC_FOLDER + track.file
      audio.loop = true
      audio.volume = 0.5
      audio.currentTime = 0
      playing = true
      if (page?.visibilityState !== 'hidden') resume()
    },
    stop() {
      playing = false
      audio?.pause()
    },
    get playing() {
      return playing
    },
  }
}

export const music = createMusicPlayer(
  () => new Audio(),
  typeof document === 'undefined' ? undefined : document,
)
