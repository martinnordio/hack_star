<script lang="ts">
  import { progress } from './accounts'
  import { t, type TextKey } from './i18n'
  import { WORLD_SIZES, WORLDS, type WorldId, type WorldSize } from './game/worlds'
  import { SETTINGS } from './game/settings'
  import { buyWorld, chooseWorld, chosenWorld, growWorld, worldOffers, type SizeOffer } from './game/worldShop'
  import { WORLD_LOOKS } from './models/arena3d'

  let { onStart }: { onStart: () => void } = $props()

  type Pending = { id: WorldId; size: WorldSize; offer: Extract<SizeOffer, { state: 'buy' | 'grow' }> }

  const chosen = $derived(chosenWorld($progress))
  let pending = $state<Pending>()
  let unlockedNote = $state<string>()

  const worldName = (id: WorldId) => $t(`world.${id}.name` as TextKey)
  const sizeName = (size: WorldSize) => $t(`world.size.${size}` as TextKey)
  const sizesUpTo = (size: WorldSize) =>
    WORLD_SIZES.slice(0, WORLD_SIZES.indexOf(size) + 1)
      .map(sizeName)
      .join(' + ')

  // Read live, so the dialog follows the balance and the unlocked sizes.
  const live = $derived(
    pending && worldOffers($progress, pending.id).find((o) => o.size === pending!.size && o.state === pending!.offer.state),
  )
  const missing = $derived(live && live.state !== 'unlocked' && live.state !== 'locked' ? live.missing : 0)

  function pick(id: WorldId, offer: SizeOffer) {
    unlockedNote = undefined
    if (offer.state === 'unlocked') progress.update((p) => chooseWorld(p, id, offer.size))
    else if (offer.state === 'buy' || offer.state === 'grow') pending = { id, size: offer.size, offer }
  }

  function confirm() {
    if (!pending || missing > 0) return
    const { id, size, offer } = pending
    const result = offer.state === 'buy' ? buyWorld($progress, id, size) : growWorld($progress, id)
    if (!result.ok) return
    progress.set(result.progress)
    unlockedNote = $t('worlds.unlocked', { world: worldName(id), size: sizeName(size) })
    pending = undefined
  }
</script>

<div class="worlds">
  <p class="wallet" aria-live="polite">
    {#each $t('worlds.balance').split(/\{(\w+)\}/) as part, i}{#if i % 2 === 0}{part}{:else}<strong>{$progress.worldCoins.toLocaleString()}</strong>{/if}{/each}
  </p>
  {#if unlockedNote}<p class="note" role="status">🎉 {unlockedNote}</p>{/if}

  <ul class="grid">
    {#each WORLDS as world (world.id)}
      {@const look = WORLD_LOOKS[world.theme]}
      {@const offers = worldOffers($progress, world.id)}
      <li
        class="card"
        class:chosen={chosen.id === world.id}
        style:--sky-top={look.sky[0]}
        style:--sky-bottom={look.sky[1]}
        style:--tile={look.tiles[0]}
        style:--floor={look.floor}
      >
        <div class="banner">
          <span class="name">{worldName(world.id)}</span>
          {#if world.free}<span class="tag">{$t('worlds.free')}</span>{/if}
        </div>
        <div class="sizes">
          {#each offers as offer (offer.size)}
            {@const isChosen = offer.state === 'unlocked' && chosen.id === world.id && chosen.size === offer.size}
            <button
              class="size {offer.state}"
              class:chosen={isChosen}
              disabled={offer.state === 'locked'}
              aria-pressed={offer.state === 'unlocked' ? isChosen : undefined}
              aria-label="{worldName(world.id)} · {sizeName(offer.size)}{offer.state === 'unlocked' ? '' : offer.state === 'locked' ? ` · ${$t('worlds.sizeLocked')}` : ` · ${$t('worlds.price', { coins: offer.price })}`}"
              onclick={() => pick(world.id, offer)}
            >
              <span class="size-name">{sizeName(offer.size)}</span>
              <span class="state">
                {#if offer.state === 'unlocked'}{isChosen ? `✔ ${$t('worlds.chosen')}` : '✔'}
                {:else if offer.state === 'locked'}🔒
                {:else}{$t('worlds.price', { coins: offer.price })}{/if}
              </span>
            </button>
          {/each}
        </div>
      </li>
    {/each}
  </ul>

  <div class="bar">
    <span class="playing">{worldName(chosen.id)} · {sizeName(chosen.size)}</span>
    <button class="start" onclick={onStart}>{$t('worlds.start')}</button>
  </div>
</div>

{#if pending}
  <div class="backdrop" role="presentation">
    <div class="dialog" role="dialog" aria-modal="true" aria-label={worldName(pending.id)}>
      <p class="question">
        {#if pending.offer.state === 'buy'}
          {$t('worlds.confirmBuy', { world: worldName(pending.id), sizes: sizesUpTo(pending.size), coins: pending.offer.price })}
        {:else}
          {$t('worlds.confirmGrow', { world: worldName(pending.id), size: sizeName(pending.size), coins: pending.offer.price })}
        {/if}
      </p>
      {#if missing > 0}
        <p class="refusal" role="alert">{$t('worlds.needMore', { coins: missing })}</p>
      {/if}
      <div class="choices">
        <button class="yes" disabled={missing > 0} onclick={confirm}>
          {$t(pending.offer.state === 'buy' ? 'worlds.buy' : 'worlds.unlock')} · {$t('worlds.price', { coins: pending.offer.price })}
        </button>
        <button class="no" onclick={() => (pending = undefined)}>{$t('common.cancel')}</button>
      </div>
    </div>
  </div>
{/if}

<style>
  .worlds {
    max-width: 64rem;
    margin: 0 auto;
  }

  .wallet {
    margin: 0 0 0.8rem;
    font-weight: 700;
  }

  .wallet strong {
    color: #7be3ff;
    font-size: 1.2rem;
  }

  .note {
    margin: 0 0 0.8rem;
    font-weight: 900;
    color: #39ff88;
  }

  .grid {
    list-style: none;
    margin: 0 0 5.5rem;
    padding: 0;
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(min(100%, 17rem), 1fr));
    gap: 0.9rem;
  }

  .card {
    border-radius: 1rem;
    border: 3px solid #000;
    overflow: hidden;
    background: #160f33;
  }

  .card.chosen {
    border-color: #ffe45c;
    box-shadow: 0 0 1rem #ffe45c88;
  }

  .banner {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 0.5rem;
    padding: 0.7rem 0.8rem;
    background:
      linear-gradient(135deg, transparent 60%, var(--floor) 60%),
      linear-gradient(var(--sky-top), var(--sky-bottom));
    color: white;
    font-weight: 900;
  }

  .name {
    font-size: 1.15rem;
    text-shadow:
      0 2px 0 #000,
      0 0 0.3rem #000;
  }

  .tag {
    padding: 0.1em 0.6em;
    border-radius: 999px;
    border: 2px solid #000;
    background: #39ff88;
    font-size: 0.8rem;
  }

  .sizes {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 0.4rem;
    padding: 0.5rem;
  }

  button {
    font: inherit;
    font-weight: 900;
    border: 3px solid #000;
    border-radius: 0.8rem;
    cursor: pointer;
    touch-action: manipulation;
  }

  .size {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    gap: 0.1rem;
    min-height: 3.4rem;
    padding: 0.3rem 0.2rem;
    color: #06210f;
  }

  .size-name {
    font-size: 0.95rem;
  }

  .state {
    font-size: 0.8rem;
  }

  .size.unlocked {
    background: linear-gradient(#39ff88, #0a9f4a);
  }

  .size.unlocked.chosen {
    background: linear-gradient(#ffe45c, #ffb000);
  }

  .size.buy,
  .size.grow {
    background: linear-gradient(#4aa8ff, #2f6bff);
    color: white;
  }

  .size.locked {
    background: #3a3a4a;
    color: #cfd3dc;
    cursor: default;
  }

  .bar {
    position: fixed;
    left: 0;
    right: 0;
    bottom: 0;
    z-index: 5;
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 0.8rem;
    padding: 0.6rem max(0.9rem, env(safe-area-inset-right)) max(0.7rem, env(safe-area-inset-bottom))
      max(0.9rem, env(safe-area-inset-left));
    background: #160f33ee;
    border-top: 3px solid #000;
  }

  .playing {
    font-weight: 900;
    font-size: clamp(1rem, 3vw, 1.3rem);
    color: #ffe45c;
  }

  .start {
    padding: 0.4em 1.6em;
    border-radius: 1rem;
    background: linear-gradient(#ffe45c, #ffb000);
    color: #160f33;
    font-size: clamp(1.4rem, 4vw, 2rem);
    font-style: italic;
    box-shadow: 0 0.3rem 0 #000;
  }

  .start:active {
    transform: translateY(0.2rem);
    box-shadow: 0 0.1rem 0 #000;
  }

  .backdrop {
    position: fixed;
    inset: 0;
    z-index: 20;
    display: grid;
    place-items: center;
    padding: 1rem;
    background: #000a;
  }

  .dialog {
    width: min(26rem, 100%);
    padding: 1.2rem;
    border-radius: 1rem;
    border: 3px solid #000;
    background: #2a1d5e;
    color: white;
    text-align: center;
  }

  .question {
    margin: 0 0 0.8rem;
    font-weight: 800;
    font-size: 1.15rem;
  }

  .refusal {
    margin: 0 0 0.8rem;
    font-weight: 900;
    color: #ffb0a0;
  }

  .choices {
    display: flex;
    justify-content: center;
    flex-wrap: wrap;
    gap: 0.6rem;
  }

  .choices button {
    padding: 0.5em 1.2em;
    box-shadow: 0 0.25rem 0 #000;
  }

  .yes {
    background: linear-gradient(#39ff88, #0a9f4a);
    color: #06210f;
  }

  .yes:disabled {
    background: #3a3a4a;
    color: #cfd3dc;
    box-shadow: none;
    cursor: default;
  }

  .no {
    background: linear-gradient(#4aa8ff, #2f6bff);
    color: white;
  }
</style>
