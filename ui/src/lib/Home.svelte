<script lang="ts">
  import { Canvas } from '@threlte/core'
  import { untrack } from 'svelte'
  import { PCFShadowMap } from 'three'
  import { RARITY_COLORS, type Fighter } from './fighters'
  import { credits, currentFighter } from './hacks'
  import { wornSkin } from './game/shop'
  import HomeScene from './HomeScene.svelte'
  import PrestigeBadge from './PrestigeBadge.svelte'
  import { progress, totalTrophies } from './progress'

  interface Props {
    fighters: Fighter[]
    entrance: boolean
    onEntranceEnd: () => void
    onNavigate: (screen: 'fighters' | 'shop' | 'info' | 'hack' | 'settings' | 'friends' | 'match' | 'training') => void
  }

  let { fighters, entrance, onEntranceEnd, onNavigate }: Props = $props()

  const fighter = $derived(currentFighter($progress, fighters))
  const skinId = $derived(wornSkin($progress, fighter.id))
  const trophies = $derived($progress.trophies[fighter.id] ?? 0)
  const shownCredits = $derived(credits($progress))

  let skipped = $state(false)
  let playing = $state(untrack(() => entrance))

  function skip() {
    if (playing) skipped = true
  }
</script>

<!-- svelte-ignore a11y_click_events_have_key_events, a11y_no_static_element_interactions -->
<div class="home" class:entering={playing} onpointerdown={skip}>
  <div class="scene">
    <Canvas shadows={PCFShadowMap}>
      <HomeScene
        fighterId={fighter.id}
        {skinId}
        {entrance}
        {skipped}
        onEntranceEnd={() => {
          playing = false
          onEntranceEnd()
        }}
      />
    </Canvas>
  </div>

  <header class="top">
    <div class="chip" aria-label="Total trophies">
      <span class="icon">🏆</span>{totalTrophies($progress).toLocaleString()}
    </div>
    <h1 class="title">Hack<span>star</span></h1>
    <div class="chip" aria-label="Credits">
      <span class="icon coin">C</span>{shownCredits === Infinity ? '∞' : shownCredits.toLocaleString()}
    </div>
  </header>

  <nav class="side">
    <button class="round friends" onclick={() => onNavigate('friends')}>
      <span class="big">👫</span>Friends
    </button>
    <button class="round" onclick={() => onNavigate('fighters')}>
      <span class="big">🦸</span>Fighters
    </button>
    <button class="round shop" onclick={() => onNavigate('shop')}>
      <span class="big">🛍️</span>Shop
    </button>
    <button class="round" onclick={() => onNavigate('info')}>
      <span class="big">📖</span>Info
    </button>
    <button class="round" onclick={() => onNavigate('training')}>
      <span class="big">🎯</span>Training
    </button>
    <button class="round hack" onclick={() => onNavigate('hack')}>
      <span class="big">💻</span>Hack
    </button>
    <button class="round settings" onclick={() => onNavigate('settings')}>
      <span class="big">⚙️</span>Settings
    </button>
  </nav>

  <div class="plate" style="--rarity: {RARITY_COLORS[fighter.rarity]}">
    <PrestigeBadge {trophies} />
    <div>
      <div class="name">{fighter.name}</div>
      <div class="trophies">🏆 {trophies}</div>
    </div>
  </div>

  <button class="play" onclick={() => onNavigate('match')}>PLAY</button>

  {#if playing}
    <div class="skip">Tap to skip</div>
  {/if}
</div>

<style>
  .home {
    position: fixed;
    inset: 0;
    overflow: hidden;
    background:
      radial-gradient(ellipse at 50% 45%, #6a4bff 0%, #3a2a8c 45%, #1b1446 100%);
    color: white;
    --pad-top: max(0.75rem, env(safe-area-inset-top));
    --pad-right: max(0.9rem, env(safe-area-inset-right));
    --pad-bottom: max(0.9rem, env(safe-area-inset-bottom));
    --pad-left: max(0.9rem, env(safe-area-inset-left));
  }

  .scene {
    position: absolute;
    inset: 0;
    touch-action: none;
  }

  .top {
    position: absolute;
    top: var(--pad-top);
    left: var(--pad-left);
    right: var(--pad-right);
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 0.5rem;
  }

  .chip {
    display: flex;
    align-items: center;
    gap: 0.35em;
    padding: 0.3em 0.8em 0.3em 0.35em;
    border-radius: 999px;
    background: #160f33cc;
    border: 2px solid #000;
    font-weight: 900;
    font-size: clamp(0.95rem, 2.6vw, 1.3rem);
    text-shadow: 0 2px 0 #000;
  }

  .icon {
    font-size: 1.2em;
  }

  .coin {
    display: grid;
    place-items: center;
    width: 1.3em;
    height: 1.3em;
    border-radius: 50%;
    background: radial-gradient(circle at 35% 30%, #fff3a0, #ffb000);
    color: #7a4a00;
    font-size: 0.85em;
    border: 2px solid #000;
    text-shadow: none;
  }

  .title {
    margin: 0;
    font-size: clamp(1.6rem, 6vw, 3.4rem);
    font-weight: 900;
    font-style: italic;
    letter-spacing: 0.02em;
    color: #ffd23f;
    -webkit-text-stroke: 0.06em #160f33;
    paint-order: stroke fill;
    text-shadow: 0 0.08em 0 #160f33;
    transform: rotate(-3deg);
    white-space: nowrap;
  }

  .title span {
    margin-left: 0.2em;
    color: #ff4f9a;
  }

  .entering .title {
    animation: pop 0.6s 1.2s cubic-bezier(0.3, 1.8, 0.5, 1) backwards;
  }

  @keyframes pop {
    from {
      transform: rotate(-3deg) scale(0);
    }
  }

  .side {
    position: absolute;
    left: var(--pad-left);
    top: 50%;
    transform: translateY(-50%);
    display: grid;
    grid-template-columns: repeat(3, auto);
    gap: 0.6rem;
  }

  button {
    font: inherit;
    cursor: pointer;
    color: white;
    border: 3px solid #000;
    touch-action: manipulation;
  }

  .round {
    display: flex;
    flex-direction: column;
    align-items: center;
    min-width: 4.6rem;
    padding: 0.45rem 0.6rem;
    border-radius: 1rem;
    background: linear-gradient(#4aa8ff, #2f6bff);
    box-shadow: 0 0.3rem 0 #000;
    font-weight: 900;
    font-size: 0.85rem;
    text-shadow: 0 2px 0 #000;
  }

  .round:active,
  .play:active {
    transform: translateY(0.2rem);
    box-shadow: 0 0.1rem 0 #000;
  }

  .round.hack {
    background: linear-gradient(#39ff88, #0a9f4a);
    color: #06210f;
    text-shadow: none;
  }

  .round.shop {
    background: linear-gradient(#ff8ac2, #e8327a);
  }

  .round.settings {
    background: linear-gradient(#a99bd6, #6a5aa8);
  }

  .round.friends {
    background: linear-gradient(#ffb15c, #ff6a1a);
  }

  .big {
    font-size: 1.8rem;
    line-height: 1.1;
  }

  .plate {
    position: absolute;
    left: 50%;
    bottom: calc(var(--pad-bottom) + 0.4rem);
    transform: translateX(-50%);
    display: flex;
    align-items: center;
    gap: 0.5rem;
    padding: 0.35rem 1rem 0.35rem 0.5rem;
    border-radius: 0.8rem;
    background: #160f33cc;
    border: 3px solid var(--rarity);
    box-shadow: 0 0 1rem color-mix(in srgb, var(--rarity) 60%, transparent);
  }

  .name {
    font-weight: 900;
    font-size: clamp(1.1rem, 3.5vw, 1.6rem);
    color: var(--rarity);
    text-shadow: 0 2px 0 #000;
    line-height: 1.1;
  }

  .trophies {
    font-weight: 800;
    font-size: 0.9rem;
  }

  .play {
    position: absolute;
    right: var(--pad-right);
    bottom: var(--pad-bottom);
    padding: 0.5em 1.6em;
    border-radius: 1rem;
    background: linear-gradient(#ffe45c, #ffb000);
    color: #160f33;
    font-size: clamp(1.6rem, 5vw, 2.4rem);
    font-weight: 900;
    font-style: italic;
    box-shadow: 0 0.35rem 0 #000;
  }

  @media (max-aspect-ratio: 3/4) {
    .play {
      left: var(--pad-left);
      right: var(--pad-right);
    }

    .side {
      top: auto;
      bottom: calc(var(--pad-bottom) + 6.5rem);
      transform: none;
      grid-template-columns: repeat(3, auto);
    }

    .plate {
      top: calc(var(--pad-top) + 4rem);
      bottom: auto;
      left: auto;
      right: var(--pad-right);
      transform: none;
    }
  }

  .skip {
    position: absolute;
    left: 50%;
    top: calc(var(--pad-top) + 4rem);
    transform: translateX(-50%);
    font-weight: 800;
    opacity: 0.7;
  }
</style>
