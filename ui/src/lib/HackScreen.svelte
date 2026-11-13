<script lang="ts">
  import Celebration from './Celebration.svelte'
  import { codeFromScan, redeem, UnknownCodeError, withHack, type Hack, type HackId } from './hacks'
  import { progress } from './accounts'
  import QrScanner from './QrScanner.svelte'
  import { t, tOr } from './i18n'

  /** `initialCode` comes from a scanned link that opened the game (`?hack=`). */
  let { hacks, initialCode }: { hacks: Hack[]; initialCode?: string } = $props()

  let code = $state('')
  let busy = $state(false)
  let error = $state<'hackScreen.unknownCode' | 'common.serverDown'>()
  let shake = $state(false)
  let celebrating = $state<Hack>()
  let confirmReset = $state(false)
  let scanning = $state(false)
  let celebrationTimer: ReturnType<typeof setTimeout> | undefined

  const active = $derived(hacks.filter((h) => $progress.activeHacks.includes(h.id as HackId)))

  async function apply(text: string) {
    if (!text.trim() || busy) return
    busy = true
    error = undefined
    try {
      const hack = await redeem(text)
      progress.update((p) => withHack(p, hack.id))
      code = ''
      celebrating = hack
      clearTimeout(celebrationTimer)
      celebrationTimer = setTimeout(() => (celebrating = undefined), 2600)
    } catch (e) {
      error = e instanceof UnknownCodeError ? 'hackScreen.unknownCode' : 'common.serverDown'
      shake = false
      requestAnimationFrame(() => (shake = true))
    } finally {
      busy = false
    }
  }

  function reset() {
    progress.update((p) => ({ ...p, activeHacks: [] }))
    confirmReset = false
  }

  $effect(() => {
    if (initialCode) apply(initialCode)
  })
</script>

<div class="hack-screen">
  <form
    class="terminal"
    class:shake
    onsubmit={(e) => {
      e.preventDefault()
      apply(code)
    }}
  >
    <label for="code">{$t('hackScreen.enterCode')}</label>
    <div class="row">
      <input
        id="code"
        bind:value={code}
        autocomplete="off"
        autocapitalize="characters"
        spellcheck="false"
        maxlength="100"
        placeholder="●●●●●●"
        oninput={() => (error = undefined)}
      />
      <button class="go" disabled={busy || !code.trim()}>{$t('hackScreen.go')}</button>
    </div>
    {#if error}
      <p class="error" role="alert">{$t(error)}</p>
    {/if}
  </form>

  <div class="qr">
    <button class="scan" onclick={() => (scanning = !scanning)}>
      {scanning ? $t('common.stopScanning') : `📷 ${$t('common.scanQr')}`}
    </button>
    <a href="/?qr" target="_blank" rel="noopener">{$t('hackScreen.printQr')}</a>
  </div>
  {#if scanning}
    <QrScanner
      onCode={(text) => {
        scanning = false
        apply(codeFromScan(text))
      }}
    />
  {/if}

  <section>
    <h3>{$t('hackScreen.active')}</h3>
    {#if active.length === 0}
      <p class="none">{$t('hackScreen.none')}</p>
    {:else}
      <ul class="active">
        {#each active as hack (hack.id)}
          <li>
            <span class="on">{$t('hackScreen.on')}</span>
            <span><strong>{$tOr(`hack.${hack.id}.name`, hack.name)}</strong><br />{$tOr(`hack.${hack.id}.description`, hack.description)}</span>
          </li>
        {/each}
      </ul>
      {#if confirmReset}
        <div class="confirm">
          <span>{$t('hackScreen.confirmReset')}</span>
          <button class="danger" onclick={reset}>{$t('common.yesReset')}</button>
          <button onclick={() => (confirmReset = false)}>{$t('common.no')}</button>
        </div>
      {:else}
        <button class="reset" onclick={() => (confirmReset = true)}>{$t('hackScreen.reset')}</button>
      {/if}
    {/if}
  </section>
</div>

{#if celebrating}
  <Celebration
    title={$tOr(`hack.${celebrating.id}.name`, celebrating.name)}
    subtitle={$tOr(`hack.${celebrating.id}.description`, celebrating.description)}
  />
{/if}

<style>
  .hack-screen {
    max-width: 40rem;
    margin: 0 auto;
    display: flex;
    flex-direction: column;
    gap: 1.2rem;
  }

  .terminal {
    padding: 1rem;
    border-radius: 1rem;
    background: #020a05;
    border: 3px solid #39ff88;
    box-shadow: 0 0 1.4rem #39ff8855;
    font-family: ui-monospace, 'Cascadia Code', Consolas, monospace;
    color: #39ff88;
  }

  .terminal.shake {
    animation: shake 0.4s;
  }

  @keyframes shake {
    20%,
    60% {
      transform: translateX(-0.6rem);
    }
    40%,
    80% {
      transform: translateX(0.6rem);
    }
  }

  label {
    display: block;
    margin-bottom: 0.6rem;
    font-weight: 900;
    letter-spacing: 0.1em;
  }

  .row {
    display: flex;
    gap: 0.6rem;
  }

  input {
    flex: 1;
    min-width: 0;
    padding: 0.5em 0.7em;
    border-radius: 0.6rem;
    border: 2px solid #39ff88;
    background: #06210f;
    color: #b8ffd4;
    font: inherit;
    font-size: 1.4rem;
    letter-spacing: 0.12em;
    text-transform: uppercase;
  }

  input:focus {
    outline: 3px solid #ffd23f;
  }

  button {
    font: inherit;
    font-weight: 900;
    border: 3px solid #000;
    border-radius: 0.8rem;
    cursor: pointer;
    touch-action: manipulation;
  }

  .go {
    padding: 0 1.1em;
    font-size: 1.3rem;
    background: linear-gradient(#39ff88, #0a9f4a);
    color: #06210f;
  }

  .go:disabled {
    opacity: 0.5;
    cursor: default;
  }

  .error {
    margin: 0.7rem 0 0;
    font-weight: 900;
    font-size: 1.2rem;
    color: #ff4d4d;
  }

  .qr {
    display: flex;
    flex-wrap: wrap;
    align-items: center;
    justify-content: space-between;
    gap: 0.8rem;
  }

  .scan {
    padding: 0.5em 1.1em;
    font-size: 1.2rem;
    background: linear-gradient(#4aa8ff, #2f6bff);
    color: white;
    box-shadow: 0 0.25rem 0 #000;
  }

  .qr a {
    color: #b8ffd4;
    font-weight: 800;
  }

  h3 {
    margin: 0 0 0.5rem;
  }

  .none {
    margin: 0;
    opacity: 0.8;
  }

  .active {
    list-style: none;
    margin: 0 0 0.8rem;
    padding: 0;
    display: grid;
    gap: 0.5rem;
  }

  .active li {
    display: flex;
    align-items: center;
    gap: 0.8rem;
    padding: 0.6rem 0.8rem;
    border-radius: 0.8rem;
    background: #160f33cc;
    border: 2px solid #39ff88;
  }

  .on {
    padding: 0.2em 0.5em;
    border-radius: 0.4rem;
    background: #39ff88;
    color: #06210f;
    font-weight: 900;
  }

  .reset,
  .confirm button {
    padding: 0.5em 1em;
    background: #3a3a4a;
    color: white;
  }

  .confirm {
    display: flex;
    flex-wrap: wrap;
    align-items: center;
    gap: 0.6rem;
    font-weight: 800;
  }

  .confirm .danger {
    background: #e8322b;
  }
</style>
