<script lang="ts">
  import { Canvas } from '@threlte/core'
  import { untrack } from 'svelte'
  import { PCFShadowMap } from 'three'
  import { MAX_POWER_LEVEL, RARITY_COLORS, type Fighter } from './fighters'
  import HomeScene from './HomeScene.svelte'
  import { portrait } from './portraits'
  import PrestigeBadge from './PrestigeBadge.svelte'
  import { progress } from './progress'

  let { fighter, onSelected }: { fighter: Fighter; onSelected: () => void } = $props()

  const unlocked = $derived($progress.unlockedFighters.includes(fighter.id))
  const trophies = $derived($progress.trophies[fighter.id] ?? 0)
  const power = $derived($progress.powerLevels[fighter.id] ?? 1)
  let previewSkin = $state(untrack(() => $progress.selectedSkins[fighter.id] ?? 'default'))
  const isCurrent = $derived(
    $progress.selectedFighter === fighter.id && ($progress.selectedSkins[fighter.id] ?? 'default') === previewSkin,
  )

  function select() {
    progress.update((p) => ({
      ...p,
      selectedFighter: fighter.id,
      selectedSkins: { ...p.selectedSkins, [fighter.id]: previewSkin },
    }))
    onSelected()
  }
</script>

<div class="detail" style="--rarity: {RARITY_COLORS[fighter.rarity]}">
  <div class="stage" class:locked={!unlocked}>
    <div class="canvas">
      <Canvas shadows={PCFShadowMap}>
        <HomeScene fighterId={fighter.id} skinId={previewSkin} entrance={false} />
      </Canvas>
    </div>
  </div>

  <div class="info">
    <div class="heading">
      <PrestigeBadge {trophies} size={2.6} />
      <div>
        <h3>{fighter.name}</h3>
        <div class="rarity">{fighter.rarity} · {fighter.idea}</div>
      </div>
    </div>

    <div class="stats">
      <span>🏆 {trophies} trophies</span>
      <span class="power">
        ⚡ Power {power}
        <span class="bar" aria-hidden="true">
          {#each { length: MAX_POWER_LEVEL } as _, i}
            <span class:on={i < power}></span>
          {/each}
        </span>
      </span>
    </div>

    <h4>Skins</h4>
    <ul class="skins">
      {#each fighter.skins as skin (skin.id)}
        <li>
          <button
            class="skin"
            class:legendary={skin.rarity === 'Legendary'}
            class:active={previewSkin === skin.id}
            style="--skin-rarity: {RARITY_COLORS[skin.rarity]}"
            onclick={() => (previewSkin = skin.id)}
          >
            <img src={portrait(fighter.id, skin.id)} alt="" />
            <span class="skin-name">{skin.name}</span>
            <span class="skin-rarity">{skin.rarity === 'Default' ? 'Default' : skin.rarity}</span>
          </button>
        </li>
      {/each}
    </ul>

    {#if !unlocked}
      <button class="select" disabled>🔒 Locked</button>
    {:else if isCurrent}
      <button class="select" disabled>✔ Selected</button>
    {:else}
      <button class="select" onclick={select}>SELECT</button>
    {/if}
  </div>
</div>

<style>
  .detail {
    display: grid;
    grid-template-columns: 1fr 1fr;
    align-items: start;
    gap: 1rem;
    max-width: 70rem;
    margin: 0 auto;
  }

  .stage {
    position: relative;
    height: min(72vh, 34rem);
    border-radius: 1.2rem;
    overflow: hidden;
    border: 3px solid #000;
    background: radial-gradient(ellipse at 50% 45%, #6a4bff, #2c1d7a);
    touch-action: none;
  }

  .canvas {
    position: absolute;
    inset: 0;
  }

  .stage.locked {
    filter: grayscale(0.9) brightness(0.6);
  }

  .info {
    display: flex;
    flex-direction: column;
    gap: 0.6rem;
  }

  .heading {
    display: flex;
    align-items: center;
    gap: 0.6rem;
  }

  h3 {
    margin: 0;
    font-size: clamp(1.8rem, 5vw, 2.6rem);
    font-weight: 900;
    color: var(--rarity);
    text-shadow: 0 3px 0 #000;
    line-height: 1;
  }

  .rarity {
    font-weight: 700;
    opacity: 0.9;
  }

  .stats {
    display: flex;
    flex-wrap: wrap;
    gap: 0.4rem 1.2rem;
    font-weight: 800;
  }

  .power {
    display: flex;
    align-items: center;
    gap: 0.5rem;
    color: #ffd23f;
  }

  .bar {
    display: flex;
    gap: 2px;
  }

  .bar span {
    width: 0.55rem;
    height: 0.9rem;
    border-radius: 2px;
    background: #ffffff30;
  }

  .bar span.on {
    background: #ffd23f;
  }

  h4 {
    margin: 0.4rem 0 0;
    font-size: 1.1rem;
  }

  .skins {
    list-style: none;
    margin: 0;
    padding: 0;
    display: grid;
    grid-template-columns: repeat(3, minmax(0, 1fr));
    gap: 0.6rem;
  }

  .skin {
    width: 100%;
    display: flex;
    flex-direction: column;
    align-items: center;
    padding: 0.3rem 0.3rem 0.45rem;
    border-radius: 0.9rem;
    border: 3px solid var(--skin-rarity);
    background: #160f33;
    color: white;
    font: inherit;
    cursor: pointer;
    touch-action: manipulation;
  }

  .skin.active {
    background: color-mix(in srgb, var(--skin-rarity) 35%, #160f33);
    transform: translateY(-0.15rem);
  }

  .skin.legendary {
    animation: legendary 1.6s ease-in-out infinite;
  }

  @keyframes legendary {
    50% {
      box-shadow: 0 0 1.1rem #ffd23f, 0 0 0.3rem #fff3a0 inset;
    }
  }

  .skin img {
    width: 100%;
    aspect-ratio: 1;
    pointer-events: none;
  }

  .skin-name {
    font-weight: 900;
    font-size: 0.95rem;
  }

  .skin-rarity {
    font-size: 0.7rem;
    font-weight: 800;
    text-transform: uppercase;
    color: var(--skin-rarity);
  }

  .select {
    margin-top: 0.4rem;
    padding: 0.5em 1em;
    border-radius: 1rem;
    border: 3px solid #000;
    background: linear-gradient(#ffe45c, #ffb000);
    box-shadow: 0 0.3rem 0 #000;
    color: #160f33;
    font: inherit;
    font-size: 1.6rem;
    font-weight: 900;
    font-style: italic;
    cursor: pointer;
    touch-action: manipulation;
  }

  .select:disabled {
    background: #3a3a4a;
    color: #cfd3dc;
    cursor: default;
  }

  @media (max-aspect-ratio: 1/1) {
    .detail {
      grid-template-columns: 1fr;
    }

    .stage {
      height: 38vh;
    }
  }
</style>
