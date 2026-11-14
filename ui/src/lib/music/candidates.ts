/** Candidate music for the developer page and the tracks that ship (no imports: used by the game and the dev server). */

export interface Track {
  id: string
  title: string
  author: string
  /** For example "CC0", "CC BY 4.0" or "Made for Hack star". */
  licence: string
  /** The page the track and its licence come from. */
  source: string
  /** File name in `ui/dev/music/files/` and, once chosen, in `ui/public/assets/music/`. */
  file: string
  /** The exact credit the author asks for on the source page, if any (shown instead of the author). */
  credit?: string
}

export interface Candidate extends Track {
  chosen: boolean
}

export const MAX_CHOSEN = 10
export const MAX_CANDIDATES = 15
const FILE = /^[\w-]+\.mp3$/
const ID = /^[a-z0-9-]{1,40}$/
const CC0 = /^CC0(?: 1\.0)?$/i
const CC_BY = /^CC BY ([1-4])\.0$/i

/** CC0, CC BY with its version (credited in the About panel) or made for the project; never NC, ND or SA. */
export function isAllowedLicence(licence: string): boolean {
  const l = licence.trim()
  return CC0.test(l) || CC_BY.test(l) || /^Made for Hack star$/i.test(l)
}

/** The official page of the licence, linked in the credits; none for music made for the project. */
export function licenceUrl(licence: string): string | undefined {
  const l = licence.trim()
  if (CC0.test(l)) return 'https://creativecommons.org/publicdomain/zero/1.0/'
  const by = CC_BY.exec(l)
  return by ? `https://creativecommons.org/licenses/by/${by[1]}.0/` : undefined
}

export function isTrackFile(file: string): boolean {
  return FILE.test(file)
}

function isCandidate(value: unknown): value is Candidate {
  if (typeof value !== 'object' || value === null) return false
  const c = value as Record<string, unknown>
  return (
    typeof c.id === 'string' &&
    ID.test(c.id) &&
    typeof c.title === 'string' &&
    typeof c.author === 'string' &&
    typeof c.licence === 'string' &&
    typeof c.source === 'string' &&
    typeof c.file === 'string' &&
    isTrackFile(c.file) &&
    (c.credit === undefined || typeof c.credit === 'string') &&
    typeof c.chosen === 'boolean'
  )
}

/** The candidates of `candidates.json`; entries that are not well formed are left out. */
export function parseCandidates(value: unknown): Candidate[] {
  const tracks = (value as { tracks?: unknown } | null)?.tracks
  return Array.isArray(tracks) ? tracks.filter(isCandidate) : []
}

/** The repository's list together with this computer's own list; for the same id the local entry wins. */
export function mergeCandidates(repository: Candidate[], local: Candidate[]): Candidate[] {
  return [...repository.filter((t) => !local.some((l) => l.id === t.id)), ...local]
}

export type ListChange = { ok: true; tracks: Candidate[] } | { ok: false; reason: string }

export function choose(tracks: Candidate[], id: string): ListChange {
  const track = tracks.find((t) => t.id === id)
  if (!track) return { ok: false, reason: 'Unknown track.' }
  if (track.chosen) return { ok: true, tracks }
  if (!isAllowedLicence(track.licence)) return { ok: false, reason: `"${track.licence}" is not allowed: only CC0, CC BY with its version (e.g. CC BY 3.0) or made for Hack star.` }
  if (tracks.filter((t) => t.chosen).length >= MAX_CHOSEN) return { ok: false, reason: `Already ${MAX_CHOSEN} tracks chosen: unchoose one first.` }
  return { ok: true, tracks: tracks.map((t) => (t.id === id ? { ...t, chosen: true } : t)) }
}

export function unchoose(tracks: Candidate[], id: string): ListChange {
  if (!tracks.some((t) => t.id === id)) return { ok: false, reason: 'Unknown track.' }
  return { ok: true, tracks: tracks.map((t) => (t.id === id ? { ...t, chosen: false } : t)) }
}

export function remove(tracks: Candidate[], id: string): ListChange {
  const track = tracks.find((t) => t.id === id)
  if (!track) return { ok: false, reason: 'Unknown track.' }
  if (track.chosen) return { ok: false, reason: 'A chosen track cannot be deleted: unchoose it first.' }
  return { ok: true, tracks: tracks.filter((t) => t.id !== id) }
}

/** The tracks the game ships: the chosen candidates, without the `chosen` flag. */
export function shipped(tracks: Candidate[]): Track[] {
  return tracks.filter((t) => t.chosen).map(({ chosen: _chosen, ...track }) => track)
}
