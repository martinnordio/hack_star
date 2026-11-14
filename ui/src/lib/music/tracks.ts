import type { Track } from './candidates'

// tracks.json (repository, empty) and tracks.local.json (this computer only, written by the developer page).
const lists = import.meta.glob<Track[]>('./tracks*.json', { eager: true, import: 'default' })

/** The tracks the game plays; the local list wins for the same id. */
export const TRACKS: Track[] = Object.keys(lists)
  .sort()
  .flatMap((file) => lists[file])
  .filter((track, i, all) => all.findLastIndex((t) => t.id === track.id) === i)
