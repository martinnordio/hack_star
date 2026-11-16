<script lang="ts">
  import { progress } from './accounts'
  import { SETTINGS } from './game/settings'
  import { buyWorld, chosenWorld, growWorld, isWorldUnlocked, nextSize } from './game/worldShop'
  import { WORLD_SIZES, WORLDS, type WorldId, type WorldSize } from './game/worlds'
  import { t, type TextKey } from './i18n'
  import { THEMES } from './models/arena3d'

  interface Props {
    onStart: () => void
  }

  let { onStart }: Props = $props()

  /** A purchase waiting for the player's yes. */
  type Offer = { id: WorldId; size: WorldSize; cost: number; grow: boolean }
  let offer = $state<Offer>()

  const chosen = $derived(chosenWorld($progress))
  const name = (id: WorldId) => $t(`world.${id}` as TextKey)
  const sizeName = (size: WorldSize) => $t(`worldSize.${size}` as TextKey)

  /** What a size button does: choose it, buy the world up to it, grow to it, or nothing yet. */
  function sizeState(id: WorldId, size: WorldSize): { kind: 'open' } | { kind: 'buy' | 'grow'; cost: number } | { kind: 'later' } {
    if (isWorldUnlocked($progress, id, size)) return { kind: 'open' }
    if (!$progress.worlds[id]) return { kind: 'buy', cost: SETTINGS.worldPrices[size] }
    return nextSize($progress, id) === size ? { kind: 'grow', cost: SETTINGS.worldSizeStep } : { kind: 'later' }
  }

  function pick(id: WorldId, size: WorldSize) {
    const s = sizeState(id, size)
    if (s.kind === 'open') progress.update((p) => ({ ...p, selectedWorld: { id, size } }))
    else if (s.kind !== 'later') offer = { id, size, cost: s.cost, grow: s.kind === 'grow' }
  }

  function confirm() {
    if (!offer) return
    const { id, size, grow } = offer
    progress.update((p) => {
      const bought = grow ? growWorld(p, id) : buyWorld(p, id, size)
      return bought.ok ? { ...bought.progress, selectedWorld: { id, size } } : p
    })
    offer = undefined
  }
</script>

<div class="worlds">
  <p class="wallet" aria-label={$t('worlds.balance')}>
    <span class="globe" aria-hidden="true">🌍</span><strong>{$progress.worldCoins.toLocaleString()}</strong>
    <span class="how">{$t('worlds.howToEarn', { coins: SETTINGS.worldCoinsPerStep, trophies: SETTINGS.trophiesPerWorldStep })}</span>
  </p>

  <ul class="grid">
    {#each WORLDS as world (world.id)}
      {@const look = THEMES[world.theme]}
      {@const owned = $progress.worlds[world.id] !== undefined}
      <li class="card" class:locked={!owned} class:chosen={chosen.id === world.id}>
        <div class="swatch" style="--a: {look.tiles[0]}; --b: {look.tiles[1]}; --edge: {look.edgeColors[0]}; --wall: {look.wallSide}; --cover: {look.coverColors[0]}" aria-hidden="true">
          <span class="wall"></span><span class="bush"></span><span class="wall two"></span>
        </div>
        <div class="name">{owned ? '' : '🔒 '}{name(world.id)}</div>
        <div class="sizes">
          {#each WORLD_SIZES as size}
            {@const s = sizeState(world.id, size)}
            <button
              class="size {s.kind}"
              class:on={chosen.id === world.id && chosen.size === size}
              disabled={s.kind === 'later'}
              aria-pressed={chosen.id === world.id && chosen.size === size}
              onclick={() => pick(world.id, size)}
            >
              <span>{sizeName(size)}</span>
              {#if s.kind === 'buy' || s.kind === 'grow'}
                <small>🌍 {s.kind === 'grow' ? '+' : ''}{s.cost}</small>
              {:else if s.kind === 'later'}
                <small>🔒</small>
              {/if}
            </button>
          {/each}
        </div>
      </li>
    {/each}
  </ul>
</div>

<div class="start-bar">
  <span class="chosen-name">{name(chosen.id)} · {sizeName(chosen.size)}</span>
  <button class="start" onclick={onStart}>{$t('worlds.start')}</button>
</div>

{#if offer}
  {@const missing = offer.cost - $progress.worldCoins}
  <div class="backdrop" role="presentation" onclick={() => (offer = undefined)}></div>
  <div class="dialog" role="dialog" aria-modal="true" aria-label={name(offer.id)}>
    <p>
      {$t(offer.grow ? 'worlds.growQuestion' : 'worlds.buyQuestion', { world: name(offer.id), size: sizeName(offer.size), coins: offer.cost })}
    </p>
    {#if missing > 0}
      <p class="missing" role="alert">{$t('worlds.needMore', { coins: missing })}</p>
      <div class="buttons"><button class="cancel" onclick={() => (offer = undefined)}>{$t('common.close')}</button></div>
    {:else}
      <div class="buttons">
        <button class="buy" onclick={confirm}>{$t('worlds.unlock')} · 🌍 {offer.cost}</button>
        <button class="cancel" onclick={() => (offer = undefined)}>{$t('common.cancel')}</button>
      </div>
    {/if}
  </div>
{/if}

<style>
  .worlds {
    max-width: 60rem;
    margin: 0 auto;
    padding-bottom: 5.5rem;
  }

  .wallet {
    display: flex;
    flex-wrap: wrap;
    align-items: center;
    gap: 0.4rem;
    margin: 0 0 0.8rem;
    font-weight: 700;
  }

  .wallet strong {
    color: #8fe3ff;
    font-size: 1.3rem;
  }

  .globe {
    font-size: 1.4rem;
  }

  .how {
    font-size: 0.9rem;
    opacity: 0.85;
  }

  .grid {
    list-style: none;
    margin: 0;
    padding: 0;
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(13rem, 1fr));
    gap: 0.9rem;
  }

  .card {
    display: flex;
    flex-direction: column;
    gap: 0.4rem;
    padding: 0.5rem;
    border-radius: 1rem;
    border: 3px solid #4b36c9;
    background: #160f33;
  }

  .card.chosen {
    border-color: #ffd23f;
    box-shadow: 0 0 0.8rem #ffd23f88;
  }

  .swatch {
    position: relative;
    height: 4.5rem;
    border-radius: 0.6rem;
    border: 4px solid var(--edge);
    background: repeating-conic-gradient(var(--a) 0 25%, var(--b) 0 50%) 0 0 / 1.2rem 1.2rem;
  }

  .locked .swatch {
    filter: saturate(0.5) brightness(0.75);
  }

  .swatch .wall {
    position: absolute;
    left: 18%;
    top: 30%;
    width: 22%;
    height: 18%;
    border-radius: 0.2rem;
    background: var(--wall);
    border: 2px solid #160f33;
  }

  .swatch .wall.two {
    left: 60%;
    top: 55%;
  }

  .swatch .bush {
    position: absolute;
    left: 46%;
    top: 20%;
    width: 1.4rem;
    height: 1.4rem;
    border-radius: 50%;
    background: var(--cover);
    border: 2px solid #160f33;
  }

  .name {
    font-weight: 900;
    font-size: 1.1rem;
  }

  .sizes {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 0.35rem;
  }

  button {
    font: inherit;
    font-weight: 900;
    border: 3px solid #000;
    border-radius: 0.8rem;
    cursor: pointer;
    touch-action: manipulation;
    color: white;
  }

  .size {
    display: flex;
    flex-direction: column;
    align-items: center;
    min-height: 3rem;
    padding: 0.25rem 0.2rem;
    font-size: 0.85rem;
    background: linear-gradient(#4aa8ff, #2f6bff);
    box-shadow: 0 0.2rem 0 #000;
  }

  .size small {
    font-size: 0.8rem;
  }

  .size.buy,
  .size.grow {
    background: linear-gradient(#5a5470, #3a3550);
  }

  .size.later {
    background: #2a2540;
    color: #8a86a0;
    box-shadow: none;
    cursor: default;
  }

  .size.on {
    background: linear-gradient(#ffe45c, #ffb000);
    color: #160f33;
  }

  .size:active:not(:disabled) {
    transform: translateY(0.15rem);
    box-shadow: 0 0.05rem 0 #000;
  }

  .start-bar {
    position: fixed;
    left: 0;
    right: 0;
    bottom: 0;
    display: flex;
    align-items: center;
    justify-content: flex-end;
    gap: 0.8rem;
    padding: 0.6rem max(0.9rem, env(safe-area-inset-right)) max(0.8rem, env(safe-area-inset-bottom)) max(0.9rem, env(safe-area-inset-left));
    background: linear-gradient(transparent, #1b1446 40%);
  }

  .chosen-name {
    font-weight: 900;
    text-shadow: 0 2px 0 #000;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
  }

  .start {
    flex: none;
    padding: 0.4em 1.6em;
    font-size: clamp(1.3rem, 4vw, 1.9rem);
    font-style: italic;
    background: linear-gradient(#ffe45c, #ffb000);
    color: #160f33;
    box-shadow: 0 0.3rem 0 #000;
  }

  .backdrop {
    position: fixed;
    inset: 0;
    z-index: 20;
    background: #0008;
  }

  .dialog {
    position: fixed;
    left: 50%;
    top: 50%;
    z-index: 21;
    transform: translate(-50%, -50%);
    width: min(24rem, calc(100% - 2rem));
    padding: 1rem;
    border-radius: 1rem;
    border: 3px solid #000;
    background: #2a1f66;
    text-align: center;
    font-weight: 800;
  }

  .missing {
    color: #ff8a8a;
  }

  .buttons {
    display: flex;
    justify-content: center;
    gap: 0.6rem;
  }

  .buttons button {
    padding: 0.45em 1.1em;
    box-shadow: 0 0.25rem 0 #000;
  }

  .buy {
    background: linear-gradient(#39ff88, #0a9f4a);
    color: #06210f;
  }

  .cancel {
    background: linear-gradient(#4aa8ff, #2f6bff);
  }
</style>
