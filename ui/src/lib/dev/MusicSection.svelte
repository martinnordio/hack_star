<script lang="ts">
  import { isAllowedLicence, licenceUrl, MAX_CANDIDATES, MAX_CHOSEN, type Candidate } from '../music/candidates'

  type Row = Candidate & { hasFile: boolean }

  let tracks = $state<Row[]>([])
  let message = $state<string>()
  let playing = $state<string>()
  let confirmDelete = $state<string>()
  let copied = $state(false)
  let available = $state(true)
  const audio = typeof Audio === 'undefined' ? undefined : new Audio()
  audio?.addEventListener('ended', () => (playing = undefined))

  const chosen = $derived(tracks.filter((t) => t.chosen).length)

  const REQUEST = `Find candidate music tracks for Hack star (an open-source, MIT-licensed browser game).
- Moods: big-drum anthemic pop-rock; a funky dance groove; classic arcade or chiptune game music. Styles only: no track that imitates a specific artist or song.
- Licence: CC0, or CC BY with its version (e.g. CC BY 3.0; the credit is shown in the game), or made by us. Never NC (non-commercial), ND (no changes) or SA (share-alike). Check the licence on the source's own page.
- No copied or sampled recordings, melodies or lyrics.
- At most ${MAX_CANDIDATES} candidates in total (now {count}); MP3, at most about 3 MB each.
- For each track record: id (lowercase, dashes), title, author, licence, source (the page with the licence), file (<id>.mp3), and credit (only if the page asks for an exact credit text).
- Add each one to ui/dev/music/candidates.local.json (git-ignored, never committed) with "chosen": false, and download its MP3 into ui/dev/music/files/.`

  const request = $derived(REQUEST.replace('{count}', String(tracks.length)))

  async function load() {
    try {
      const response = await fetch('/__dev/music/list')
      if (!response.ok) throw new Error(String(response.status))
      tracks = await response.json()
      available = true
    } catch {
      available = false
    }
  }

  async function act(action: 'choose' | 'unchoose' | 'delete', id: string) {
    const response = await fetch(`/__dev/music/${action}`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ id }),
    })
    const result = await response.json()
    message = result.ok ? undefined : result.reason
    confirmDelete = undefined
    await load()
  }

  function toggle(track: Row) {
    if (!audio) return
    if (playing === track.id) {
      audio.pause()
      playing = undefined
      return
    }
    audio.src = `/__dev/music/file/${encodeURIComponent(track.file)}`
    audio.play().then(() => (playing = track.id)).catch(() => (message = `Cannot play ${track.file}.`))
  }

  async function copyRequest() {
    await navigator.clipboard.writeText(request)
    copied = true
    setTimeout(() => (copied = false), 2000)
  }

  $effect(() => {
    load()
    return () => audio?.pause()
  })
</script>

{#if !available}
  <p>The music tools work only with <code>npm run dev</code> (they are not part of the built game).</p>
{:else}
  <p>
    {tracks.length} of at most {MAX_CANDIDATES} candidates · <strong>{chosen} of {MAX_CHOSEN} chosen</strong> for the game on this computer.
    Music stays on this computer: your list is <code>ui/dev/music/candidates.local.json</code> and chosen tracks are copied to
    <code>ui/public/assets/music/</code> — all git-ignored, never committed. Check each licence on its source page yourself.
  </p>

  {#if message}<p class="message" role="alert">{message}</p>{/if}

  {#if tracks.length === 0}
    <p>No candidate tracks yet. Copy the request below into the AI assistant to find some.</p>
  {:else}
    <table>
      <thead>
        <tr><th>Track</th><th>Licence</th><th>Listen</th><th>In the game</th><th></th></tr>
      </thead>
      <tbody>
        {#each tracks as track (track.id)}
          <tr class:chosen={track.chosen}>
            <td>
              <strong>{track.title}</strong><br />
              {track.author} · <a href={track.source} target="_blank" rel="noopener noreferrer">source page</a>
              {#if track.credit}<br /><small>Credit asked for: {track.credit}</small>{/if}
            </td>
            <td class:bad={!isAllowedLicence(track.licence)}>
              {#if licenceUrl(track.licence)}
                <a href={licenceUrl(track.licence)} target="_blank" rel="noopener noreferrer license">{track.licence}</a>
              {:else}
                {track.licence}
              {/if}
              {#if !isAllowedLicence(track.licence)}<br /><small>not allowed</small>{/if}
            </td>
            <td>
              {#if track.hasFile}
                <button onclick={() => toggle(track)}>{playing === track.id ? '■ Stop' : '▶ Play'}</button>
              {:else}
                <span class="bad">file missing</span>
              {/if}
            </td>
            <td>
              {#if track.chosen}
                <button onclick={() => act('unchoose', track.id)}>✔ Chosen · unchoose</button>
              {:else}
                <button disabled={chosen >= MAX_CHOSEN || !track.hasFile} onclick={() => act('choose', track.id)}>Choose</button>
              {/if}
            </td>
            <td>
              {#if !track.chosen}
                <button class="danger" onclick={() => (confirmDelete === track.id ? act('delete', track.id) : (confirmDelete = track.id))}>
                  {confirmDelete === track.id ? 'Click again to delete' : 'Delete'}
                </button>
              {/if}
            </td>
          </tr>
        {/each}
      </tbody>
    </table>
  {/if}

  <h3>Find more music</h3>
  <pre>{request}</pre>
  <button onclick={copyRequest}>{copied ? 'Copied ✔' : 'Copy the request'}</button>
{/if}

<style>
  table {
    width: 100%;
    border-collapse: collapse;
  }

  th,
  td {
    padding: 0.4rem;
    border-bottom: 1px solid #ffffff30;
    text-align: left;
    vertical-align: top;
  }

  tr.chosen {
    background: #ffd23f22;
  }

  button {
    padding: 0.3rem 0.6rem;
    border-radius: 0.4rem;
    border: 2px solid #000;
    background: #ffd23f;
    font: inherit;
    cursor: pointer;
  }

  button:disabled {
    opacity: 0.5;
    cursor: default;
  }

  .danger {
    background: #ff8a8a;
  }

  .bad {
    color: #ff8a8a;
    font-weight: 700;
  }

  .message {
    padding: 0.4rem 0.7rem;
    border-radius: 0.5rem;
    background: #8a1030;
  }

  pre {
    white-space: pre-wrap;
    padding: 0.7rem;
    border-radius: 0.5rem;
    background: #160f33;
  }

  a {
    color: #ffd23f;
  }
</style>
