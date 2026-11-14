# Asset licences

Hack star uses only original art or art that may be used freely; no art, names or logos from
other games.

Allowed sources:

- [Quaternius](https://quaternius.com/) — CC0
- [Kenney](https://kenney.nl/assets) — CC0
- Art made for this project

Every asset added to `ui/public/assets/` gets a line below.

| Asset | Source | Licence |
|-------|--------|---------|
| _none yet: fighters and arena are built from simple 3D shapes_ | | |

## Music

**This repository contains no music and does not offer or distribute any.** The game plays
music only when a developer adds tracks on their own computer (see the README, **Developer
page**). Those tracks and the lists that name them (`ui/dev/music/candidates.local.json`,
`ui/src/lib/music/tracks.local.json`, `ui/dev/music/files/`, `ui/public/assets/music/`) are
git-ignored and are never committed or published. The repository's own lists,
`ui/dev/music/candidates.json` and `ui/src/lib/music/tracks.json`, stay empty.

The developer page only accepts tracks whose licence is said to be CC0, CC BY with its
version or "Made for Hack star". The game's **About** panel credits every chosen track from
the developer's local list: title linked to its source, author (or the exact credit the
source asks for, field `credit`), the licence linked to its official Creative Commons page,
and a note that the tracks are unchanged and not under the MIT licence. Neither check is a
licence review.

### Getting music

Developers find music themselves, for example in free-music libraries that let you filter by
licence, or make it themselves. Recommended licences, and what each one needs:

| Licence | What you must do | Notes |
|---------|------------------|-------|
| [CC0 1.0](https://creativecommons.org/publicdomain/zero/1.0/) | Nothing; a credit is a courtesy | Best choice: no conditions |
| [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/) | Credit title, author (in the form the source asks for), source link and licence link; say if you changed the track | The About panel does this from the track's entry |
| [CC BY 3.0](https://creativecommons.org/licenses/by/3.0/) | The same as CC BY 4.0 | Must not be shipped with copy protection (DRM) that limits users, which some app stores add |

Never use NC (non-commercial), ND (no changes) or SA (share-alike) licences, or music that
copies or samples an existing recording, melody or lyrics.

For each track: read the licence on the source's own page, keep a dated copy of that page,
and record the title, author, source, licence with its version, and the exact credit text if
the page asks for one (field `credit`). **Whoever adds or publishes a track is responsible for
checking and following its licence;** the authors of Hack star make no statement that any
track may be used.
