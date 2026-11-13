<script lang="ts">
  import { RARITY_COLORS, RARITY_KEYS, type Fighter } from './fighters'
  import { isUnlocked, maxPower } from './hacks'
  import { powerOf, unlockPrice } from './game/economy'
  import { wornSkin } from './game/shop'
  import { fighterType } from './game/types'
  import { portrait } from './portraits'
  import PrestigeBadge from './PrestigeBadge.svelte'
  import { progress } from './accounts'
  import { t } from './i18n'
  import { CREATED_ID } from './progress'

  let { fighters, onOpen, onCreate }: { fighters: Fighter[]; onOpen: (id: string) => void; onCreate: () => void } = $props()
</script>

<ul class="grid">
  {#each fighters as fighter (fighter.id)}
    {@const unlocked = isUnlocked($progress, fighter.id)}
    {@const trophies = $progress.trophies[fighter.id] ?? 0}
    {@const selected = $progress.selectedFighter === fighter.id}
    <li>
      <button
        class="card"
        class:locked={!unlocked}
        class:selected
        style="--rarity: {RARITY_COLORS[fighter.rarity]}"
        onclick={() => onOpen(fighter.id)}
        aria-label={unlocked ? fighter.name : $t('fighters.locked', { name: fighter.name })}
      >
        <span class="picture">
          <img src={portrait(fighter.id, wornSkin($progress, fighter.id))} alt="" />
          {#if !unlocked}<span class="lock">🔒</span>{/if}
          <span class="badge"><PrestigeBadge {trophies} size={2} /></span>
        </span>
        <span class="name">{fighter.name}</span>
        <span class="rarity">{$t(RARITY_KEYS[fighter.rarity])}</span>
        <span class="type">{fighterType(fighter.type).emoji} {$t(fighterType(fighter.type).nameKey)}</span>
        <span class="stats">
          <span>🏆 {trophies}</span>
          <span class="power">⚡ {powerOf($progress, fighter.id)}/{maxPower($progress)}</span>
        </span>
        {#if !unlocked && fighter.id === CREATED_ID}
          <span class="price">🔒 💻</span>
        {:else if !unlocked}
          <span class="price">🔒 {$t('common.price', { credits: unlockPrice(fighter.rarity) })}</span>
        {/if}
      </button>
    </li>
  {/each}
  {#if !$progress.createdFighter}
    <li>
      <button class="card create" onclick={onCreate}>
        <span class="picture plus" aria-hidden="true">➕</span>
        <span class="name">{$t('creator.title')}</span>
      </button>
    </li>
  {/if}
</ul>

<style>
  .create {
    height: 100%;
    border-style: dashed;
    border-color: #ffd23f;
  }

  .plus {
    display: grid;
    place-items: center;
    font-size: 3rem;
    min-height: 8rem;
  }
  .grid {
    list-style: none;
    margin: 0 auto;
    padding: 0.3rem 0 0;
    max-width: 60rem;
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(9.5rem, 1fr));
    gap: 0.9rem;
  }

  .card {
    position: relative;
    width: 100%;
    display: flex;
    flex-direction: column;
    align-items: stretch;
    padding: 0 0 0.5rem;
    border-radius: 1rem;
    border: 3px solid #000;
    background: #160f33;
    box-shadow: 0 0.3rem 0 #000;
    color: white;
    font: inherit;
    text-align: center;
    cursor: pointer;
    overflow: hidden;
    touch-action: manipulation;
  }

  .card:active {
    transform: translateY(0.15rem);
  }

  .card.selected {
    outline: 3px solid #ffd23f;
    outline-offset: 2px;
  }

  .picture {
    position: relative;
    display: block;
    aspect-ratio: 1;
    pointer-events: none;
    background: radial-gradient(circle at 50% 60%, color-mix(in srgb, var(--rarity) 70%, white), var(--rarity) 55%, color-mix(in srgb, var(--rarity) 50%, black));
  }

  img {
    width: 100%;
    height: 100%;
    display: block;
  }

  .locked img {
    filter: grayscale(1) brightness(0.45);
  }

  .locked .picture {
    background: #3a3a4a;
  }

  .lock {
    position: absolute;
    inset: 0;
    display: grid;
    place-items: center;
    font-size: 2.6rem;
  }

  .badge {
    position: absolute;
    top: 0.2rem;
    left: 0.2rem;
  }

  .name {
    margin-top: 0.35rem;
    font-weight: 900;
    font-size: 1.15rem;
    text-shadow: 0 2px 0 #000;
  }

  .rarity {
    font-size: 0.75rem;
    font-weight: 800;
    color: var(--rarity);
    text-transform: uppercase;
    letter-spacing: 0.05em;
  }

  .locked .rarity {
    color: #9aa5b1;
  }

  .type {
    font-size: 0.8rem;
    font-weight: 800;
    opacity: 0.85;
  }

  .stats {
    display: flex;
    justify-content: space-around;
    margin-top: 0.3rem;
    font-weight: 800;
    font-size: 0.85rem;
  }

  .power {
    color: #ffd23f;
  }

  .price {
    margin-top: 0.25rem;
    font-weight: 900;
    font-size: 0.9rem;
    color: #ffe45c;
  }
</style>
