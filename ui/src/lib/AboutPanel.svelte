<script lang="ts">
  import { version } from '../../package.json'
  import licence from '../../../LICENSE?raw'
  import { t } from './i18n'
  import { licenceUrl } from './music/candidates'
  import { TRACKS } from './music/tracks'

  let { onClose }: { onClose: () => void } = $props()

  // Same words as LICENSE; its fixed line breaks are joined so the text flows on small screens.
  const paragraphs = licence
    .trim()
    .split(/\r?\n\s*\r?\n/)
    .map((p) => p.replace(/\s*\r?\n\s*/g, ' '))
</script>

<!-- svelte-ignore a11y_click_events_have_key_events, a11y_no_static_element_interactions -->
<div class="backdrop" onpointerdown={(e) => e.target === e.currentTarget && onClose()}>
  <div class="panel" role="dialog" aria-modal="true" aria-labelledby="about-title">
    <header>
      <h2 id="about-title">Hack star</h2>
      <button class="close" aria-label={$t('common.close')} onclick={onClose}>✕</button>
    </header>

    <p class="version">{$t('about.version', { version })}</p>

    <h3>{$t('about.music')}</h3>
    {#if TRACKS.length === 0}
      <p>{$t('about.noMusic')}</p>
    {:else}
      <ul class="credits" lang="en">
        {#each TRACKS as track (track.id)}
          {@const url = licenceUrl(track.licence)}
          <li>
            “<a href={track.source} target="_blank" rel="noopener noreferrer">{track.title}</a>” —
            {track.credit ?? track.author} ·
            {#if url}<a href={url} target="_blank" rel="noopener noreferrer license">{track.licence}</a>{:else}{track.licence}{/if}
          </li>
        {/each}
      </ul>
      <p class="note">{$t('about.musicNote')}</p>
    {/if}

    <h3>{$t('about.licence')}</h3>
    <p>{$t('about.licenceIntro')}</p>
    <div class="licence" lang="en">
      {#each paragraphs as paragraph, i (i)}<p>{paragraph}</p>{/each}
    </div>
  </div>
</div>

<style>
  .backdrop {
    position: fixed;
    inset: 0;
    z-index: 20;
    display: grid;
    place-items: center;
    padding: 1rem;
    background: #0008;
  }

  .panel {
    width: min(36rem, 100%);
    max-height: calc(100dvh - 2rem);
    overflow-y: auto;
    padding: 1rem 1.2rem;
    border: 3px solid #000;
    border-radius: 1.2rem;
    background: linear-gradient(#3a2a8c, #1b1446);
    box-shadow: 0 0.4rem 0 #000;
    color: white;
  }

  header {
    display: flex;
    align-items: center;
    justify-content: space-between;
  }

  h2 {
    margin: 0;
    font-size: 1.8rem;
    font-weight: 900;
    font-style: italic;
    color: #ffd23f;
    text-shadow: 0 3px 0 #000;
  }

  h3 {
    margin: 1rem 0 0.4rem;
    color: #ffd23f;
  }

  .close {
    width: 2.4rem;
    height: 2.4rem;
    border: 3px solid #000;
    border-radius: 0.7rem;
    background: #160f33;
    color: white;
    font: inherit;
    cursor: pointer;
    touch-action: manipulation;
  }

  .version {
    margin: 0.3rem 0 0;
    font-weight: 700;
    opacity: 0.85;
  }

  .credits {
    margin: 0;
    padding-left: 1.2rem;
    line-height: 1.5;
  }

  a {
    color: #ffd23f;
  }

  .licence {
    padding: 0.2rem 0.8rem;
    border-radius: 0.7rem;
    background: #160f33;
    font-size: 0.8rem;
    line-height: 1.4;
  }
</style>
