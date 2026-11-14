<script lang="ts">
  import { progress } from './accounts'
  import type { BotLevel } from './game/settings'
  import { BOT_COUNTS, options } from './options'
  import { resetProgress } from './progress'
  import { language, setLanguage, t, type TextKey } from './i18n'
  import { LANGUAGES, LANGUAGE_NAMES } from './i18n/languages'
  import { turnOnDeveloper } from './dev/developer'
  import AboutPanel from './AboutPanel.svelte'

  let aboutOpen = $state(false)
  import { TRACKS } from './music/tracks'
  import { musicTrack } from './music/player'

  const currentTrack = $derived(musicTrack({ ...$options, music: true }, TRACKS)?.id)

  let confirming = $state(false)
  let resetDone = $state(false)
  let askingCode = $state(false)
  let code = $state('')
  let wrongCode = $state(false)

  function submitCode() {
    wrongCode = !turnOnDeveloper(code)
    if (!wrongCode) {
      askingCode = false
      code = ''
    }
  }

  function reset() {
    $progress = resetProgress($progress)
    confirming = false
    resetDone = true
  }

  const LEVELS: { id: BotLevel; name: TextKey; emoji: string; text: TextKey }[] = [
    { id: 'easy', name: 'botLevel.easy', emoji: '🙂', text: 'settings.easyText' },
    { id: 'medium', name: 'botLevel.medium', emoji: '😠', text: 'settings.mediumText' },
    { id: 'hard', name: 'botLevel.hard', emoji: '😈', text: 'settings.hardText' },
  ]
</script>

<section>
  <h3>{$t('settings.language')}</h3>
  <div class="languages" role="radiogroup" aria-label={$t('settings.language')}>
    {#each LANGUAGES as code (code)}
      <button class="language" role="radio" lang={code === 'gsw' ? 'gsw' : code} aria-checked={$language === code} onclick={() => setLanguage(code)}>
        {LANGUAGE_NAMES[code]}
      </button>
    {/each}
  </div>
</section>

<section>
  <h3>{$t('settings.botLevel')}</h3>
  <div class="levels" role="radiogroup" aria-label={$t('settings.botLevel')}>
    {#each LEVELS as level (level.id)}
      <button
        class="level {level.id}"
        role="radio"
        aria-checked={$options.botLevel === level.id}
        onclick={() => ($options.botLevel = level.id)}
      >
        <span class="emoji">{level.emoji}</span>
        <span class="name">{$t(level.name)}</span>
        <span class="text">{$t(level.text)}</span>
      </button>
    {/each}
  </div>
</section>

<section>
  <h3>{$t('settings.botCount')}</h3>
  <div class="counts" role="radiogroup" aria-label={$t('settings.botCount')}>
    {#each BOT_COUNTS as count (count)}
      <button
        class="count"
        role="radio"
        aria-checked={$options.botCount === count}
        aria-label={$t(count === 1 ? 'common.bots.one' : 'common.bots.other', { count })}
        onclick={() => ($options.botCount = count)}
      >
        {count}
      </button>
    {/each}
  </div>
</section>

<p class="note">{$t('settings.note')}</p>

<section>
  <h3>{$t('settings.music')}</h3>
  {#if TRACKS.length === 0}
    <p class="note">{$t('settings.musicNone')}</p>
  {:else}
    <div class="music" role="radiogroup" aria-label={$t('settings.music')}>
      <button class="plain" role="radio" aria-checked={$options.music} onclick={() => ($options.music = true)}>🎵 {$t('settings.musicOn')}</button>
      <button class="plain" role="radio" aria-checked={!$options.music} onclick={() => ($options.music = false)}>🔇 {$t('settings.musicOff')}</button>
    </div>
    {#if $options.music}
      <div class="music tracks" role="radiogroup" aria-label={$t('settings.musicTrack')}>
        {#each TRACKS as track (track.id)}
          <button class="plain" role="radio" aria-checked={currentTrack === track.id} onclick={() => ($options.track = track.id)}>
            {track.title}
          </button>
        {/each}
      </div>
    {/if}
    <p class="note">{$t('settings.musicNote')}</p>
  {/if}
</section>

<section class="reset">
  <h3>{$t('settings.startAgain')}</h3>
  {#if confirming}
    <p class="warn" role="alert">
      {$t('settings.resetWarning')}
    </p>
    <div class="row">
      <button class="danger" onclick={reset}>{$t('common.yesReset')}</button>
      <button class="plain" onclick={() => (confirming = false)}>{$t('common.cancel')}</button>
    </div>
  {:else}
    <button class="danger" onclick={() => ((confirming = true), (resetDone = false))}>🔄 {$t('settings.reset')}</button>
    {#if resetDone}<p class="done" role="status">{$t('settings.resetDone')}</p>{/if}
  {/if}
</section>

<section class="developer">
  <h3>{$t('settings.developer')}</h3>
  {#if $options.developer}
    <p class="note">{$t('settings.developerOn')}</p>
    <div class="row">
      <a class="plain link" href="/?dev">🛠️ {$t('settings.developerPage')}</a>
      <button class="plain" onclick={() => ($options.developer = false)}>{$t('settings.developerTurnOff')}</button>
    </div>
  {:else if askingCode}
    <form class="row" onsubmit={(e) => (e.preventDefault(), submitCode())}>
      <label class="sr" for="developer-code">{$t('settings.developerCode')}</label>
      <input
        id="developer-code"
        type="password"
        autocomplete="off"
        placeholder={$t('settings.developerCode')}
        bind:value={code}
        oninput={() => (wrongCode = false)}
      />
      <button class="plain" type="submit">{$t('settings.developerTurnOn')}</button>
      <button class="plain" type="button" onclick={() => ((askingCode = false), (wrongCode = false))}>{$t('common.cancel')}</button>
    </form>
    {#if wrongCode}<p class="warn" role="alert">{$t('settings.developerWrongCode')}</p>{/if}
  {:else}
    <button class="plain" onclick={() => (askingCode = true)}>🛠️ {$t('settings.developerTurnOn')}</button>
  {/if}
</section>

<section>
  <button class="plain about" onclick={() => (aboutOpen = true)}>ℹ️ {$t('about.open')}</button>
</section>

{#if aboutOpen}
  <AboutPanel onClose={() => (aboutOpen = false)} />
{/if}

<style>
  .about {
    padding: 0.5rem 0.9rem;
    border-radius: 0.8rem;
    font-weight: 800;
  }

  .music {
    display: flex;
    flex-wrap: wrap;
    gap: 0.5rem;
  }

  .music button {
    padding: 0.5rem 0.9rem;
    border-radius: 0.8rem;
    font-weight: 800;
  }

  .tracks {
    margin-top: 0.5rem;
  }

  .developer input {
    padding: 0.45rem 0.7rem;
    border-radius: 0.8rem;
    border: 3px solid #000;
    font: inherit;
  }

  .link {
    display: inline-block;
    padding: 0.5rem 0.9rem;
    border: 3px solid #000;
    border-radius: 0.8rem;
    background: #160f33cc;
    box-shadow: 0 0.25rem 0 #000;
    color: white;
    font-weight: 800;
    text-decoration: none;
  }

  .sr {
    position: absolute;
    width: 1px;
    height: 1px;
    overflow: hidden;
    clip-path: inset(50%);
  }

  section {
    max-width: 40rem;
    margin: 0 auto 1rem;
  }

  h3 {
    margin: 0 0 0.5rem;
    font-size: 1.2rem;
    font-weight: 900;
    color: #ffd23f;
  }

  button {
    font: inherit;
    color: white;
    cursor: pointer;
    border: 3px solid #000;
    background: #160f33cc;
    box-shadow: 0 0.25rem 0 #000;
    touch-action: manipulation;
  }

  button[aria-checked='true'] {
    border-color: #ffd23f;
    box-shadow:
      0 0.25rem 0 #000,
      0 0 0.8rem #ffd23f88;
  }

  .levels {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(10rem, 1fr));
    gap: 0.6rem;
  }

  .level {
    display: grid;
    justify-items: center;
    gap: 0.15rem;
    padding: 0.6rem;
    border-radius: 1rem;
    text-align: center;
  }

  .level[aria-checked='true'].easy {
    background: linear-gradient(#4cd964, #1f9a3a);
  }

  .level[aria-checked='true'].medium {
    background: linear-gradient(#ffb000, #e06a00);
  }

  .level[aria-checked='true'].hard {
    background: linear-gradient(#ff4d4d, #b3122e);
  }

  .emoji {
    font-size: 2rem;
    line-height: 1.1;
  }

  .name {
    font-size: 1.3rem;
    font-weight: 900;
    text-shadow: 0 2px 0 #000;
  }

  .text {
    font-size: 0.9rem;
    font-weight: 700;
    opacity: 0.9;
  }

  .counts {
    display: flex;
    gap: 0.6rem;
  }

  .count {
    flex: 1;
    max-width: 5rem;
    aspect-ratio: 1;
    border-radius: 1rem;
    font-size: 1.8rem;
    font-weight: 900;
    text-shadow: 0 2px 0 #000;
  }

  .count[aria-checked='true'] {
    background: linear-gradient(#4aa8ff, #2f6bff);
  }

  .note {
    max-width: 40rem;
    margin: 0 auto;
    font-weight: 700;
    opacity: 0.8;
  }

  .reset {
    margin-top: 1.5rem;
  }

  .languages {
    display: flex;
    flex-wrap: wrap;
    gap: 0.5rem;
  }

  .language {
    padding: 0.5rem 0.9rem;
    border-radius: 1rem;
    font-weight: 900;
    font-size: 1.05rem;
  }

  .language[aria-checked='true'] {
    background: linear-gradient(#4aa8ff, #2f6bff);
  }

  .reset .row {
    display: flex;
    gap: 0.6rem;
    flex-wrap: wrap;
  }

  .danger,
  .plain {
    padding: 0.6rem 1.1rem;
    border-radius: 1rem;
    font-weight: 900;
    font-size: 1.1rem;
  }

  .danger {
    background: linear-gradient(#ff4d4d, #b3122e);
  }

  .warn,
  .done {
    margin: 0 0 0.6rem;
    font-weight: 800;
  }

  .warn {
    padding: 0.5rem 0.8rem;
    border-radius: 0.8rem;
    background: #8a1030;
    border: 2px solid #000;
  }
</style>
