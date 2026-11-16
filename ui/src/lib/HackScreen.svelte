<script lang="ts">
  import Celebration from './Celebration.svelte'
  import { codeFromScan, hackTimeRemaining, isHackActive, isWorldCode, redeem, UnknownCodeError, useWorldCode, withHack, type Hack, type HackId } from './hacks'
  import { progress } from './accounts'
  import QrScanner from './QrScanner.svelte'
  import { language, t, tOr } from './i18n'

  /** `initialCode` comes from a scanned link that opened the game (`?hack=`). */
  let { hacks, initialCode }: { hacks: Hack[]; initialCode?: string } = $props()

  let code = $state('')
  let now = $state(Date.now())
  let busy = $state(false)
  let error = $state<'hackScreen.unknownCode' | 'common.serverDown'>()
  /** A world-coin code used too recently: when it works again. */
  let refusedUntil = $state<number>()
  let shake = $state(false)
  let celebrating = $state<Hack>()
  let confirmReset = $state(false)
  let scanning = $state(false)
  let celebrationTimer: ReturnType<typeof setTimeout> | undefined
  let handledInitialCode: string | undefined

  const active = $derived(hacks.filter((h) => isHackActive($progress, h.id, now)))
  const usedCodes = $derived(
    hacks.filter(isWorldCode).flatMap((hack) => {
      const until = $progress.worldCodes[hack.id]
      return until !== undefined && until > now ? [{ hack, until }] : []
    }),
  )
  // Browsers have no Swiss German dates: use Swiss Standard German ones.
  const date = (time: number) => new Date(time).toLocaleDateString($language === 'gsw' ? 'de-CH' : $language)
  const hackName = (hack: Hack) =>
    isWorldCode(hack) ? $t('hack.worldCoins.name', { coins: hack.world_coins }) : $tOr(`hack.${hack.id}.name`, hack.name)
  const hackDescription = (hack: Hack) =>
    isWorldCode(hack)
      ? $t('hack.worldCoins.description', { coins: hack.world_coins, days: hack.reuse_days })
      : $tOr(`hack.${hack.id}.description`, hack.description)

  $effect(() => {
    const updateTime = () => (now = Date.now())
    const onVisibilityChange = () => {
      if (document.visibilityState === 'visible') updateTime()
    }
    const interval = window.setInterval(updateTime, 60 * 60 * 1000)
    document.addEventListener('visibilitychange', onVisibilityChange)
    return () => {
      window.clearInterval(interval)
      document.removeEventListener('visibilitychange', onVisibilityChange)
    }
  })

  $effect(() => {
    const expiries = active
      .map((hack) => $progress.hackExpiries[hack.id])
      .filter((expiry): expiry is number => expiry !== undefined && expiry !== null)
    if (expiries.length === 0) return
    const timeout = window.setTimeout(() => (now = Date.now()), Math.max(0, Math.min(...expiries) - Date.now() + 1))
    return () => window.clearTimeout(timeout)
  })

  async function apply(text: string) {
    if (!text.trim() || busy) return
    busy = true
    error = undefined
    refusedUntil = undefined
    try {
      const hack = await redeem(text)
      now = Date.now()
      if (isWorldCode(hack)) {
        const used = useWorldCode($progress, hack, now)
        if (!used.ok) {
          refusedUntil = used.until
          shake = false
          requestAnimationFrame(() => (shake = true))
          return
        }
        progress.update((p) => {
          const again = useWorldCode(p, hack, now)
          return again.ok ? again.progress : p
        })
      } else {
        progress.update((p) => withHack(p, hack.id as HackId, hack.duration_seconds))
      }
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
    progress.update((p) => ({ ...p, activeHacks: [], hackExpiries: {} }))
    confirmReset = false
  }

  $effect(() => {
    if (initialCode && handledInitialCode !== initialCode) {
      handledInitialCode = initialCode
      apply(initialCode)
    }
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
        oninput={() => {
          error = undefined
          refusedUntil = undefined
        }}
      />
      <button class="go" disabled={busy || !code.trim()}>{$t('hackScreen.go')}</button>
    </div>
    {#if error}
      <p class="error" role="alert">{$t(error)}</p>
    {:else if refusedUntil}
      <p class="error" role="alert">{$t('hackScreen.worldCodeUsed', { date: date(refusedUntil) })}</p>
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
          {@const remaining = hackTimeRemaining($progress, hack.id, now)}
          <li>
            <span class="on">{$t('hackScreen.on')}</span>
            <span class="details">
              <strong>{$tOr(`hack.${hack.id}.name`, hack.name)}</strong><br />{$tOr(`hack.${hack.id}.description`, hack.description)}
              {#if remaining?.kind === 'permanent'}
                <small class="duration">{$t('hackScreen.permanent')}</small>
              {:else if remaining?.kind === 'timed'}
                <small class="duration">{$t('hackScreen.timeRemaining', { days: remaining.days, hours: remaining.hours })}</small>
              {/if}
            </span>
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

  {#if usedCodes.length}
    <section>
      <h3>{$t('hackScreen.usedCodes')}</h3>
      <ul class="active">
        {#each usedCodes as { hack, until } (hack.id)}
          <li>
            <span class="on used">🌍</span>
            <span class="details">
              <strong>{hackName(hack)}</strong>
              <small class="duration">{$t('hackScreen.usableAgain', { date: date(until) })}</small>
            </span>
          </li>
        {/each}
      </ul>
    </section>
  {/if}
</div>

{#if celebrating}
  <Celebration title={hackName(celebrating)} subtitle={hackDescription(celebrating)} />
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

  .details {
    flex: 1;
    min-width: 0;
  }

  .duration {
    display: block;
    margin-top: 0.25rem;
    font-weight: 800;
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
