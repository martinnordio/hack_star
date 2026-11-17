<script lang="ts">
  import { t, type TextKey } from './i18n'
  import { progress } from './accounts'
  import { SETTINGS } from './game/settings'
  import { buyWorld, chooseWorld, growWorld, worldPrice, type WorldPurchase } from './game/worldShop'
  import { WORLDS, WORLD_SIZES, sizeIndex, type WorldId, type WorldSize } from './game/worlds'
  import { THEMES } from './models/themes'

  interface Props {
    onStart: () => void
  }

  let { onStart }: Props = $props()

  /** A purchase waiting for a yes or no; `size` is the size it unlocks. */
  interface Pending {
    kind: 'buy' | 'grow'
    id: WorldId
    size: WorldSize
  }

  let pending = $state<Pending | null>(null)
  let notice = $state('')

  // The notice clears by itself after 4 seconds; a new notice restarts the timer.
  $effect(() => {
    if (!notice) return
    const timer = setTimeout(() => (notice = ''), 4000)
    return () => clearTimeout(timer)
  })

  const worldName = (id: WorldId) => $t(`world.${id}` as TextKey)
  const sizeName = (size: WorldSize) => $t(`worldSize.${size}` as TextKey)
  const sizesUpTo = (size: WorldSize) =>
    WORLD_SIZES.slice(0, sizeIndex(size) + 1)
      .map((s) => sizeName(s))
      .join(' + ')

  function unlockedSize(id: WorldId): WorldSize | undefined {
    return $progress.worlds[id]
  }

  function lookOf(id: WorldId): string {
    const look = THEMES[WORLDS.find((w) => w.id === id)?.theme ?? 'canyon']
    return `--sky-top: ${look.sky[0]}; --sky-bottom: ${look.sky[1]}; --tile-a: ${look.tiles[0]}; --tile-b: ${look.tiles[1]}; --wall: ${look.wall.side}`
  }

  function choose(id: WorldId, size: WorldSize) {
    const result = chooseWorld($progress, id, size)
    if (result.ok) progress.set(result.progress)
  }

  function askBuy(id: WorldId, size: WorldSize) {
    const price = worldPrice(size)
    if ($progress.worldCoins < price) {
      notice = $t('worlds.needMore', { coins: price - $progress.worldCoins })
      return
    }
    pending = { kind: 'buy', id, size }
  }

  function askGrow(id: WorldId, size: WorldSize) {
    const price = SETTINGS.worldSizeStep
    if ($progress.worldCoins < price) {
      notice = $t('worlds.needMore', { coins: price - $progress.worldCoins })
      return
    }
    pending = { kind: 'grow', id, size }
  }

  function question(p: Pending): string {
    if (p.kind === 'buy') {
      return $t('worlds.confirmBuy', { world: worldName(p.id), size: sizeName(p.size), coins: worldPrice(p.size) })
    }
    return $t('worlds.confirmGrow', { world: worldName(p.id), size: sizeName(p.size), coins: SETTINGS.worldSizeStep })
  }

  /** Shows how many world coins are missing when a purchase is refused. */
  function refused(result: { ok: false; reason: string; missing?: number }) {
    notice = result.reason === 'world-coins' ? $t('worlds.needMore', { coins: result.missing ?? 0 }) : ''
  }

  function confirm() {
    if (!pending) return
    const { kind, id, size } = pending
    pending = null
    if (kind === 'buy') {
      const bought: WorldPurchase = buyWorld($progress, id, size)
      if (!bought.ok) return refused(bought)
      const chosen = chooseWorld(bought.progress, id, size)
      progress.set(chosen.ok ? chosen.progress : bought.progress)
      notice = $t('worlds.unlockedWorld', { world: worldName(id) })
    } else {
      const grown: WorldPurchase = growWorld($progress, id)
      if (!grown.ok) return refused(grown)
      const chosen = chooseWorld(grown.progress, id, size)
      progress.set(chosen.ok ? chosen.progress : grown.progress)
      notice = $t('worlds.unlockedSize', { world: worldName(id), size: sizeName(size) })
    }
  }
</script>

<div class="screen">
  <p class="balance">{$t('worlds.balance', { coins: $progress.worldCoins })}</p>
  <p class="hint">{$t('worlds.hint', { trophies: SETTINGS.trophiesPerWorldStep, coins: SETTINGS.worldCoinsPerStep })}</p>
  {#if notice}
    <p class="notice" role="status">{notice}</p>
  {/if}

  <div class="grid">
    {#each WORLDS as info (info.id)}
      {@const unlocked = unlockedSize(info.id)}
      <article class="card" class:locked={unlocked === undefined}>
        <div class="preview" style={lookOf(info.id)}>
          <span class="wall"></span>
        </div>
        <div class="head">
          <h3>{worldName(info.id)}</h3>
          {#if info.free}
            <span class="tag">{$t('worlds.free')}</span>
          {:else if unlocked === undefined}
            <span class="tag locked-tag">{$t('worlds.locked')}</span>
          {/if}
        </div>

        {#if unlocked === undefined}
          <div class="sizes">
            {#each WORLD_SIZES as size (size)}
              {@const price = worldPrice(size)}
              {@const short = $progress.worldCoins < price}
              <button class="btn buy" class:short disabled={short} onclick={() => askBuy(info.id, size)}>
                {short
                  ? $t('worlds.needMore', { coins: price - $progress.worldCoins })
                  : $t('worlds.buy', { sizes: sizesUpTo(size), coins: price })}
              </button>
            {/each}
          </div>
        {:else}
          <div class="sizes">
            {#each WORLD_SIZES.slice(0, sizeIndex(unlocked) + 1) as size (size)}
              {@const chosen = $progress.selectedWorld.id === info.id && $progress.selectedWorld.size === size}
              <button class="btn size" class:chosen aria-pressed={chosen} onclick={() => choose(info.id, size)}>
                {#if chosen}<span aria-hidden="true">✔</span>{/if}
                {sizeName(size)}
              </button>
            {/each}
            {#if sizeIndex(unlocked) < WORLD_SIZES.length - 1}
              {@const next = WORLD_SIZES[sizeIndex(unlocked) + 1]}
              {@const short = $progress.worldCoins < SETTINGS.worldSizeStep}
              <button class="btn buy" disabled={short} onclick={() => askGrow(info.id, next)}>
                {short
                  ? $t('worlds.needMore', { coins: SETTINGS.worldSizeStep - $progress.worldCoins })
                  : $t('worlds.lockedSize', { size: sizeName(next), coins: SETTINGS.worldSizeStep })}
              </button>
            {/if}
          </div>
        {/if}
      </article>
    {/each}
  </div>
</div>

<footer class="bar">
  <p>{$t('worlds.playingIn', { world: worldName($progress.selectedWorld.id), size: sizeName($progress.selectedWorld.size) })}</p>
  <button class="start" onclick={onStart}>{$t('worlds.start')}</button>
</footer>

{#if pending}
  <div class="confirm">
    <div class="box" role="dialog" aria-modal="true">
      <p>{question(pending)}</p>
      <div class="answers">
        <button class="btn size" onclick={confirm}>{$t('common.yes')}</button>
        <button class="btn size" onclick={() => (pending = null)}>{$t('common.no')}</button>
      </div>
    </div>
  </div>
{/if}

<style>
  .screen {
    display: flex;
    flex-direction: column;
    gap: 0.75rem;
    padding-bottom: 6.5rem;
  }

  .balance {
    margin: 0;
    font-size: clamp(1.2rem, 4vw, 1.6rem);
    font-weight: 900;
    color: #fff3a0;
    text-shadow: 0 2px 0 #000;
  }

  .hint {
    margin: 0;
    font-weight: 700;
    opacity: 0.85;
  }

  .notice {
    margin: 0;
    padding: 0.5rem 0.8rem;
    border-radius: 0.8rem;
    background: #160f33cc;
    border: 2px solid #ffd23f;
    font-weight: 900;
  }

  .grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(15rem, 1fr));
    gap: 0.8rem;
  }

  .card {
    display: flex;
    flex-direction: column;
    gap: 0.5rem;
    padding: 0.6rem;
    border-radius: 1rem;
    background: #160f33cc;
    border: 3px solid #000;
    box-shadow: 0 0.3rem 0 #000;
  }

  .card.locked {
    opacity: 0.92;
  }

  .preview {
    position: relative;
    height: 5rem;
    overflow: hidden;
    border-radius: 0.6rem;
    border: 2px solid #000;
    background: linear-gradient(var(--sky-top), var(--sky-bottom));
  }

  .preview::before {
    content: '';
    position: absolute;
    left: 0;
    right: 0;
    bottom: 0;
    height: 36%;
    background: repeating-conic-gradient(var(--tile-a) 0% 25%, var(--tile-b) 0% 50%) 0 0 / 1.2rem 1.2rem;
  }

  .wall {
    position: absolute;
    right: 12%;
    bottom: 30%;
    width: 1.6rem;
    height: 2.6rem;
    background: var(--wall);
    border: 2px solid #000;
  }

  .head {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 0.5rem;
  }

  h3 {
    margin: 0;
    font-size: 1.1rem;
    font-weight: 900;
    color: #ffd23f;
    text-shadow: 0 2px 0 #000;
  }

  .tag {
    padding: 0.15rem 0.6rem;
    border-radius: 999px;
    background: #39ff88;
    color: #06210f;
    font-weight: 900;
    font-size: 0.8rem;
    white-space: nowrap;
  }

  .tag.locked-tag {
    background: #ff8ac2;
    color: #3a0a20;
  }

  .sizes {
    display: flex;
    flex-wrap: wrap;
    gap: 0.4rem;
  }

  .btn {
    font: inherit;
    font-weight: 900;
    min-height: 2.75rem;
    padding: 0.35rem 0.7rem;
    border-radius: 0.8rem;
    border: 3px solid #000;
    color: white;
    background: linear-gradient(#4aa8ff, #2f6bff);
    box-shadow: 0 0.2rem 0 #000;
    cursor: pointer;
    touch-action: manipulation;
    text-shadow: 0 2px 0 #000;
  }

  .btn:active:not(:disabled) {
    transform: translateY(0.15rem);
    box-shadow: 0 0.05rem 0 #000;
  }

  .btn:disabled {
    cursor: not-allowed;
    background: #4a4368;
    color: #d8d2ec;
    text-shadow: none;
  }

  .btn.buy {
    flex: 1 1 100%;
    background: linear-gradient(#ffe45c, #ffb000);
    color: #160f33;
    text-shadow: none;
  }

  .btn.buy:disabled {
    background: #4a4368;
    color: #ffb4c9;
  }

  .btn.size.chosen {
    background: linear-gradient(#39ff88, #0a9f4a);
    color: #06210f;
    text-shadow: none;
  }

  .bar {
    position: fixed;
    left: 0;
    right: 0;
    bottom: 0;
    display: flex;
    align-items: center;
    justify-content: space-between;
    flex-wrap: wrap;
    gap: 0.6rem;
    padding: 0.6rem max(0.9rem, env(safe-area-inset-right)) max(0.7rem, env(safe-area-inset-bottom))
      max(0.9rem, env(safe-area-inset-left));
    background: #160f33ee;
    border-top: 3px solid #000;
  }

  .bar p {
    margin: 0;
    font-weight: 900;
  }

  .start {
    font: inherit;
    min-height: 3rem;
    padding: 0.4em 1.6em;
    border-radius: 1rem;
    border: 3px solid #000;
    background: linear-gradient(#ffe45c, #ffb000);
    color: #160f33;
    font-size: clamp(1.4rem, 4.5vw, 2rem);
    font-weight: 900;
    font-style: italic;
    box-shadow: 0 0.3rem 0 #000;
    cursor: pointer;
    touch-action: manipulation;
  }

  .start:active {
    transform: translateY(0.2rem);
    box-shadow: 0 0.1rem 0 #000;
  }

  .confirm {
    position: fixed;
    inset: 0;
    display: grid;
    place-items: center;
    padding: 1rem;
    background: #000a;
    z-index: 10;
  }

  .box {
    display: flex;
    flex-direction: column;
    gap: 0.9rem;
    max-width: 26rem;
    padding: 1.1rem;
    border-radius: 1rem;
    background: #2a1f5c;
    border: 3px solid #000;
    box-shadow: 0 0.4rem 0 #000;
    font-weight: 900;
    font-size: 1.1rem;
    text-align: center;
  }

  .box p {
    margin: 0;
  }

  .answers {
    display: flex;
    justify-content: center;
    gap: 0.8rem;
  }

  .answers .btn {
    min-width: 6rem;
  }
</style>
