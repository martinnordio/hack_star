import { describe, expect, it } from 'vitest'
import { choose, isAllowedLicence, MAX_CHOSEN, mergeCandidates, parseCandidates, remove, shipped, unchoose, type Candidate } from './candidates'

const track = (n: number, extra: Partial<Candidate> = {}): Candidate => ({
  id: `t${n}`,
  title: `Track ${n}`,
  author: 'Someone',
  licence: 'CC0',
  source: 'https://example.org/t',
  file: `t${n}.mp3`,
  chosen: false,
  ...extra,
})

describe('music candidates', () => {
  it('allows only CC0, CC BY or music made for the project', () => {
    for (const ok of ['CC0', 'CC0 1.0', 'CC BY', 'CC BY 3.0', 'cc by 4.0', 'Made for Hack star']) expect(isAllowedLicence(ok)).toBe(true)
    for (const bad of ['CC BY-NC 4.0', 'CC BY-ND 4.0', 'CC BY-SA 4.0', 'All rights reserved', '', 'CC BY 5.0']) expect(isAllowedLicence(bad)).toBe(false)
  })

  it('chooses at most five, and only with an allowed licence', () => {
    let tracks = [1, 2, 3, 4, 5, 6].map((n) => track(n))
    for (let n = 1; n <= MAX_CHOSEN; n++) {
      const result = choose(tracks, `t${n}`)
      expect(result.ok).toBe(true)
      if (result.ok) tracks = result.tracks
    }
    expect(choose(tracks, 't6')).toMatchObject({ ok: false })
    expect(choose([track(7, { licence: 'CC BY-NC 4.0' })], 't7')).toMatchObject({ ok: false })
    expect(choose(tracks, 'nope')).toMatchObject({ ok: false })
    expect(shipped(tracks).map((t) => t.id)).toEqual(['t1', 't2', 't3', 't4', 't5'])
    expect(shipped(tracks)[0]).not.toHaveProperty('chosen')
  })

  it('a chosen track cannot be deleted until it is unchosen', () => {
    const tracks = [track(1, { chosen: true }), track(2)]
    expect(remove(tracks, 't1')).toMatchObject({ ok: false })
    const unchosen = unchoose(tracks, 't1')
    expect(unchosen.ok && remove(unchosen.tracks, 't1')).toEqual({ ok: true, tracks: [track(2)] })
  })

  it('reads only well-formed candidates', () => {
    expect(parseCandidates({ tracks: [track(1), { ...track(2), file: '../secret.mp3' }, { ...track(3), id: 'Bad Id' }, 42] })).toEqual([track(1)])
    expect(parseCandidates(null)).toEqual([])
    expect(parseCandidates({})).toEqual([])
  })

  it('adds this computer\'s list to the repository\'s; the local entry wins', () => {
    const repository = [track(1), track(2)]
    const local = [track(2, { chosen: true }), track(3)]
    expect(mergeCandidates(repository, local)).toEqual([track(1), track(2, { chosen: true }), track(3)])
    expect(mergeCandidates([], local)).toEqual(local)
    expect(mergeCandidates(repository, [])).toEqual(repository)
  })
})
