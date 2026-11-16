<script lang="ts">
  import { progress } from './accounts'
  import { SETTINGS } from './game/settings'
  import { buyWorld, chooseWorld, growWorld, isWorldUnlocked, worldPrice } from './game/worldShop'
  import { WORLD_SIZES, WORLDS, sizeIndex, type WorldId, type WorldInfo, type WorldSize } from './game/worlds'
  import { t, type TextKey } from './i18n'
  import { ARENA_THEMES } from './models/themes'

  interface Props {
    onStart: () => void
  }

  let { onStart }: Props = $props()

  type Pending = { kind: 'buy' | 'grow'; id: WorldId; size: WorldSize }

  const nameOf = (id: WorldId) => $t(`world.${id}` as TextKey)
  const sizeName = (size: WorldSize) => $t(`worldSize.${size}` as TextKey)
  const bundleName = (size: WorldSize) => $t(`worlds.bundle.${size}` as TextKey)

  let pending = $state<Pending>()
  let message = $state<string>()
  let messageTimer: ReturnType<typeof setTimeout> | undefined

  const coins = $derived($progress.worldCoins)
  const chosen = $derived($progress.selectedWorld)

  const costOf = (p: Pending) => (p.kind === 'buy' ? worldPrice(p.size) : SETTINGS.worldSizeStep)
  const nextSize = (info: WorldInfo): WorldSize | undefined => {
    const biggest = $progress.worlds[info.id]
    return biggest ? WORLD_SIZES[sizeIndex(biggest) + 1] : undefined
  }

  function choose(id: WorldId, size: WorldSize) {
    const next = chooseWorld($progress, id, size)
    if (next) progress.set(next)
  }

  function confirm() {
    if (!pending) return
    const { kind, id, size } = pending
    const result = kind === 'buy' ? buyWorld($progress, id, size) : growWorld($progress, id)
    pending = undefined
    if (!result.ok) return
    // The world or size that was just unlocked is the one to play next.
    const biggest = result.progress.worlds[id] ?? size
    progress.set(chooseWorld(result.progress, id, biggest) ?? result.progress)
    message = $t('worlds.unlocked', { world: nameOf(id) })
    clearTimeout(messageTimer)
    messageTimer = setTimeout(() => (message = undefined), 3000)
  }

  const missing = (cost: number) => Math.max(0, cost - coins)
</script>

<div class="worlds">
  <p class="wallet">
    {$t('worlds.balance')}: <strong>{coins}</strong>
    <span class="hint">{$t('worlds.earnHint')}</span>
  </p>

  <ul class="grid">
    {#each WORLDS as info (info.id)}
      {@const theme = ARENA_THEMES[info.theme]}
      {@const unlocked = $progress.worlds[info.id] !== undefined}
      {@const next = nextSize(info)}
      <li class="world" class:chosen={chosen.id === info.id} style="--tile: {theme.tiles[0]}; --tile2: {theme.tiles[1]}; --floor: {theme.floor}; --wall: {theme.wallTop}; --side: {theme.wallSide}; --plant: {theme.plantColors[0]}">
        <div class="art" aria-hidden="true"><i></i><i></i><i class="bush"></i></div>
        <span class="name">{nameOf(info.id)}</span>
        {#if info.free}<span class="tag">{$t('worlds.free')}</span>{/if}

        {#if unlocked}
          <div class="sizes">
            {#each WORLD_SIZES as size (size)}
              {#if isWorldUnlocked($progress, info.id, size)}
                <button
                  class="size"
                  class:on={chosen.id === info.id && chosen.size === size}
                  aria-pressed={chosen.id === info.id && chosen.size === size}
                  onclick={() => choose(info.id, size)}
                >
                  {sizeName(size)}
                </button>
              {:else if size === next}
                <button class="size locked" disabled={coins < SETTINGS.worldSizeStep} onclick={() => (pending = { kind: 'grow', id: info.id, size })}>
                  🔒 {sizeName(size)} · {coins >= SETTINGS.worldSizeStep ? $t('worlds.price', { coins: SETTINGS.worldSizeStep }) : $t('worlds.needMore', { coins: missing(SETTINGS.worldSizeStep) })}
                </button>
              {:else}
                <button class="size locked" disabled title={$t('worlds.needSmaller')}>🔒 {sizeName(size)}</button>
              {/if}
            {/each}
          </div>
        {:else}
          <div class="sizes">
            {#each WORLD_SIZES as size (size)}
              {@const price = worldPrice(size)}
              <button class="size locked" disabled={coins < price} onclick={() => (pending = { kind: 'buy', id: info.id, size })}>
                🔒 {bundleName(size)} · {coins >= price ? $t('worlds.price', { coins: price }) : $t('worlds.needMore', { coins: missing(price) })}
              </button>
            {/each}
          </div>
        {/if}
      </li>
    {/each}
  </ul>

  {#if message}<p class="message" role="status">{message}</p>{/if}

  <div class="bar">
    <span class="playing">{$t('worlds.playingIn', { world: nameOf(chosen.id), size: sizeName(chosen.size) })}</span>
    <button class="start" onclick={onStart}>{$t('worlds.start')}</button>
  </div>
</div>

{#if pending}
  <div class="confirm" role="dialog" aria-label={$t('worlds.yes')}>
    <p>
      {#if pending.kind === 'buy'}
        {$t('worlds.confirmBuy', { world: nameOf(pending.id), sizes: bundleName(pending.size), coins: costOf(pending) })}
      {:else}
        {$t('worlds.confirmGrow', { world: nameOf(pending.id), size: sizeName(pending.size), coins: costOf(pending) })}
      {/if}
    </p>
    <div class="buttons">
      <button class="yes" onclick={confirm}>{$t('worlds.yes')}</button>
      <button class="no" onclick={() => (pending = undefined)}>{$t('common.no')}</button>
    </div>
  </div>
{/if}

<style>
  .worlds {
    max-width: 62rem;
    margin: 0 auto;
    padding-bottom: 5.5rem;
  }

  .wallet {
    margin: 0 0 0.8rem;
    font-weight: 700;
  }

  .wallet strong {
    color: #7ff0ff;
    font-size: 1.2rem;
  }

  .hint {
    display: block;
    font-size: 0.85rem;
    font-weight: 600;
    opacity: 0.8;
  }

  .grid {
    list-style: none;
    margin: 0;
    padding: 0;
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(15rem, 1fr));
    gap: 0.9rem;
  }

  .world {
    position: relative;
    display: flex;
    flex-direction: column;
    gap: 0.4rem;
    padding: 0.6rem;
    border-radius: 1rem;
    border: 3px solid #000;
    background: #160f33;
  }

  .world.chosen {
    border-color: #ffd23f;
    box-shadow: 0 0 0.9rem #ffd23f88;
  }

  .art {
    position: relative;
    height: 4.5rem;
    border-radius: 0.6rem;
    border: 3px solid var(--floor);
    background: repeating-conic-gradient(var(--tile) 0% 25%, var(--tile2) 0% 50%) 0 0 / 1.2rem 1.2rem;
    overflow: hidden;
  }

  .art i {
    position: absolute;
    width: 28%;
    height: 0.7rem;
    border-radius: 0.2rem;
    background: var(--wall);
    border-bottom: 0.3rem solid var(--side);
    top: 22%;
    left: 12%;
  }

  .art i:nth-child(2) {
    left: auto;
    right: 12%;
    top: 55%;
  }

  .art i.bush {
    width: 1.6rem;
    height: 1.6rem;
    border: 0;
    border-radius: 50%;
    background: var(--plant);
    top: 50%;
    left: 40%;
  }

  .name {
    font-weight: 900;
    font-size: 1.15rem;
  }

  .tag {
    position: absolute;
    top: 0.3rem;
    right: 0.3rem;
    padding: 0.1em 0.6em;
    border-radius: 999px;
    border: 2px solid #000;
    background: #39ff88;
    color: #06210f;
    font-size: 0.75rem;
    font-weight: 900;
  }

  .sizes {
    display: flex;
    flex-direction: column;
    gap: 0.35rem;
  }

  button {
    font: inherit;
    cursor: pointer;
    touch-action: manipulation;
  }

  .size {
    min-height: 2.75rem;
    padding: 0.35em 0.8em;
    border-radius: 0.7rem;
    border: 3px solid #000;
    background: linear-gradient(#4aa8ff, #2f6bff);
    color: white;
    font-weight: 800;
    text-shadow: 0 2px 0 #000;
  }

  .size.on {
    background: linear-gradient(#ffe45c, #ffb000);
    color: #160f33;
    text-shadow: none;
  }

  .size.locked {
    background: #2a2160;
    color: #cfc8ee;
    text-shadow: none;
  }

  .size:disabled {
    cursor: default;
    opacity: 0.75;
  }

  .message {
    margin: 0.8rem 0 0;
    font-weight: 900;
    color: #39ff88;
  }

  .bar {
    position: fixed;
    left: 0;
    right: 0;
    bottom: 0;
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 0.8rem;
    padding: 0.6rem max(0.9rem, env(safe-area-inset-right)) max(0.6rem, env(safe-area-inset-bottom)) max(0.9rem, env(safe-area-inset-left));
    background: #160f33ee;
    border-top: 3px solid #000;
  }

  .playing {
    font-weight: 800;
  }

  .start {
    padding: 0.4em 1.6em;
    border-radius: 1rem;
    border: 3px solid #000;
    background: linear-gradient(#ffe45c, #ffb000);
    box-shadow: 0 0.3rem 0 #000;
    color: #160f33;
    font-size: clamp(1.3rem, 4vw, 1.9rem);
    font-weight: 900;
    font-style: italic;
  }

  .confirm {
    position: fixed;
    inset: 0;
    display: grid;
    place-content: center;
    gap: 1rem;
    padding: 1.5rem;
    background: #000000b3;
    text-align: center;
    z-index: 10;
  }

  .confirm p {
    margin: 0;
    font-size: 1.2rem;
    font-weight: 800;
  }

  .buttons {
    display: flex;
    justify-content: center;
    gap: 0.8rem;
  }

  .yes,
  .no {
    min-height: 3rem;
    padding: 0.4em 1.4em;
    border-radius: 0.8rem;
    border: 3px solid #000;
    font-weight: 900;
    font-size: 1.1rem;
  }

  .yes {
    background: linear-gradient(#39ff88, #0a9f4a);
    color: #06210f;
  }

  .no {
    background: linear-gradient(#a99bd6, #6a5aa8);
    color: white;
  }
</style>
