<script lang="ts">
  import { Canvas } from '@threlte/core'
  import { untrack } from 'svelte'
  import { PCFShadowMap } from 'three'
  import { RARITY_COLORS, RARITY_KEYS, type Fighter } from './fighters'
  import { credits, isUnlocked, maxPower } from './hacks'
  import Celebration from './Celebration.svelte'
  import { powerOf, stats, unlock, unlockPrice, upgrade, upgradeCost } from './game/economy'
  import { SETTINGS } from './game/settings'
  import { buySkin, ownsSkin, skinPrice, wornSkin } from './game/shop'
  import { fighterType } from './game/types'
  import HomeScene from './HomeScene.svelte'
  import { portrait } from './portraits'
  import PrestigeBadge from './PrestigeBadge.svelte'
  import { progress } from './accounts'
  import { t, tOr } from './i18n'
  import { CREATED_ID } from './progress'

  let {
    fighter,
    fighters,
    onSelected,
    onChange,
  }: { fighter: Fighter; fighters: Fighter[]; onSelected: () => void; onChange: () => void } = $props()

  const created = $derived(fighter.id === CREATED_ID)

  const today = new Date()

  const unlocked = $derived(isUnlocked($progress, fighter.id))
  const trophies = $derived($progress.trophies[fighter.id] ?? 0)
  const power = $derived(powerOf($progress, fighter.id))
  const max = $derived(maxPower($progress))
  const type = $derived(fighterType(fighter.type))
  const fighterStats = $derived(stats(power, SETTINGS, type))
  const wallet = $derived(credits($progress))
  const price = $derived(unlockPrice(fighter.rarity))
  const nextCost = $derived(upgradeCost(power))
  const free = $derived(wallet === Infinity)
  const priceText = (credits: number) => (free ? $t('common.free') : $t('common.price', { credits }))
  let celebrating = $state<{ label: string; title: string; subtitle: string }>()
  let celebrationTimer: ReturnType<typeof setTimeout> | undefined

  function celebrate(label: string, title: string, subtitle: string) {
    celebrating = { label, title, subtitle }
    clearTimeout(celebrationTimer)
    celebrationTimer = setTimeout(() => (celebrating = undefined), 2200)
  }

  function buyUnlock() {
    const result = unlock($progress, fighter)
    if (!result.ok) return
    progress.set(result.progress)
    celebrate($t('fighterDetail.unlocked'), fighter.name, $t('fighterDetail.rarityFighter', { rarity: $t(RARITY_KEYS[fighter.rarity]) }))
  }

  function buyUpgrade() {
    const result = upgrade($progress, fighter.id)
    if (!result.ok) return
    progress.set(result.progress)
    const s = stats(power, SETTINGS, type)
    celebrate($t('fighterDetail.upgraded'), $t('fighterDetail.powerLevel', { power }), `❤️ ${s.health}  💥 ${s.damage}`)
  }
  let previewSkin = $state(untrack(() => wornSkin($progress, fighter.id)))
  const previewOwned = $derived(ownsSkin($progress, fighter.id, previewSkin))
  const previewPrice = $derived.by(() => {
    const skin = fighter.skins.find((s) => s.id === previewSkin)
    return skin ? skinPrice($progress, fighters, fighter, skin, today) : 0
  })
  const isCurrent = $derived(
    $progress.selectedFighter === fighter.id && wornSkin($progress, fighter.id) === previewSkin,
  )

  function buyPreviewSkin() {
    const skin = fighter.skins.find((s) => s.id === previewSkin)
    if (!skin) return
    const result = buySkin($progress, fighters, fighter, skin, today)
    if (!result.ok) return
    progress.set(result.progress)
    celebrate($t('common.newSkin'), skin.name, fighter.name)
  }

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
        <div class="rarity">{$t(RARITY_KEYS[fighter.rarity])}{#if !created} · {$tOr(`fighter.${fighter.id}.idea`, fighter.idea)}{/if}</div>
      </div>
    </div>

    <div class="type">
      <strong>{type.emoji} {$t(type.nameKey)}</strong> — {$t(type.aboutKey)} <span class="super">{$t('fighterDetail.super', { name: $t(type.superNameKey) })}</span>
    </div>

    <div class="stats">
      <span>🏆 {$t('fighterDetail.trophies', { count: trophies })}</span>
      <span class="power">
        ⚡ {$t('fighterDetail.power', { power, max })}
        <span class="bar" aria-hidden="true">
          {#each { length: max } as _, i}
            <span class:on={i < power}></span>
          {/each}
        </span>
      </span>
      <span aria-label={$t('fighterDetail.health')}>❤️ {fighterStats.health}</span>
      <span aria-label={$t('fighterDetail.damage')}>💥 {fighterStats.damage}</span>
    </div>

    {#if created}
      <button class="buy" onclick={onChange}>✏️ {$t('creator.change')}</button>
      {#if !unlocked}<p class="locked-note" role="note">🔒 {$t('creator.locked')}</p>{/if}
    {/if}

    {#if created && !unlocked}
      <!-- Only the CREATOR hack code unlocks it. -->
    {:else if !unlocked}
      <button class="buy" disabled={wallet < price} onclick={buyUnlock}>
        {#if wallet >= price}
          🔓 {$t('fighterDetail.unlock', { price: priceText(price) })}
        {:else}
          🔒 {$t('common.needMore', { credits: price - wallet })}
        {/if}
      </button>
    {:else if power >= max}
      <button class="buy" disabled>⚡ {$t('fighterDetail.maxPower')}</button>
    {:else}
      <button class="buy" disabled={wallet < nextCost} onclick={buyUpgrade}>
        {#if wallet >= nextCost}
          ⚡ {$t('fighterDetail.upgrade', { power: power + 1, price: priceText(nextCost) })}
        {:else}
          ⚡ {$t('fighterDetail.needMoreToUpgrade', { credits: nextCost - wallet })}
        {/if}
      </button>
    {/if}

    {#if !created}
    <h4>{$t('fighterDetail.skins')}</h4>
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
            <span class="skin-rarity">{$t(RARITY_KEYS[skin.rarity])}</span>
            {#if !ownsSkin($progress, fighter.id, skin.id)}
              <span class="skin-price">🔒 {$t('common.price', { credits: skinPrice($progress, fighters, fighter, skin, today) })}</span>
            {/if}
          </button>
        </li>
      {/each}
    </ul>
    {/if}

    {#if !unlocked}
      <!-- The unlock button above says what is needed. -->
    {:else if !previewOwned}
      <button class="select" disabled={wallet < previewPrice} onclick={buyPreviewSkin}>
        {#if wallet === Infinity}
          {$t('fighterDetail.buySkin', { price: $t('common.free') })}
        {:else if wallet >= previewPrice}
          {$t('fighterDetail.buySkin', { price: $t('common.price', { credits: previewPrice }) })}
        {:else}
          {$t('common.needMore', { credits: previewPrice - wallet })}
        {/if}
      </button>
    {:else if isCurrent}
      <button class="select" disabled>✔ {$t('fighterDetail.selected')}</button>
    {:else}
      <button class="select" onclick={select}>{$t('fighterDetail.select')}</button>
    {/if}
  </div>
</div>

{#if celebrating}
  <Celebration label={celebrating.label} title={celebrating.title} subtitle={celebrating.subtitle} />
{/if}

<style>
  .locked-note {
    margin: 0.4rem 0;
    padding: 0.4rem 0.7rem;
    border-radius: 0.7rem;
    background: #160f33;
    border: 2px solid #ffd23f;
    font-weight: 800;
  }
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

  .type {
    font-weight: 700;
    line-height: 1.35;
  }

  .type strong {
    font-weight: 900;
    color: #ffd23f;
  }

  .type .super {
    display: inline-block;
    padding: 0 0.5em;
    border-radius: 999px;
    background: #ffd23f;
    color: #160f33;
    font-weight: 900;
    font-size: 0.85em;
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

  .skin-price {
    font-size: 0.8rem;
    font-weight: 900;
    color: #ffe45c;
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

  .buy {
    padding: 0.45em 1em;
    border-radius: 1rem;
    border: 3px solid #000;
    background: linear-gradient(#39ff88, #0a9f4a);
    box-shadow: 0 0.3rem 0 #000;
    color: #06210f;
    font: inherit;
    font-size: 1.15rem;
    font-weight: 900;
    cursor: pointer;
    touch-action: manipulation;
  }

  .buy:active:not(:disabled) {
    transform: translateY(0.15rem);
    box-shadow: 0 0.15rem 0 #000;
  }

  .buy:disabled {
    background: #3a3a4a;
    color: #cfd3dc;
    box-shadow: none;
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
