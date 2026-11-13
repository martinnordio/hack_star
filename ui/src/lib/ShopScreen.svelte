<script lang="ts">
  import Celebration from './Celebration.svelte'
  import { RARITY_COLORS, type Fighter, type Skin } from './fighters'
  import { buySkin, ownsSkin, skinOfTheDay, skinPrice } from './game/shop'
  import { SETTINGS } from './game/settings'
  import { credits, isUnlocked } from './hacks'
  import { portrait } from './portraits'
  import { progress } from './accounts'

  let { fighters }: { fighters: Fighter[] } = $props()

  // Fixed while the screen is open, so the skin of the day does not jump at midnight.
  const today = new Date()

  const daily = $derived(skinOfTheDay($progress, fighters, today))
  const items = $derived(
    fighters.flatMap((fighter) =>
      fighter.skins.filter((s) => s.id !== 'default').map((skin) => ({ fighter, skin })),
    ),
  )
  const wallet = $derived(credits($progress))

  let bought = $state<{ fighter: Fighter; skin: Skin }>()
  let celebrationTimer: ReturnType<typeof setTimeout> | undefined

  function buy(fighter: Fighter, skin: Skin) {
    const result = buySkin($progress, fighters, fighter, skin, today)
    if (!result.ok) return
    progress.set(result.progress)
    bought = { fighter, skin }
    clearTimeout(celebrationTimer)
    celebrationTimer = setTimeout(() => (bought = undefined), 4000)
  }

  function wear(fighter: Fighter, skin: Skin) {
    progress.update((p) => ({
      ...p,
      selectedFighter: fighter.id,
      selectedSkins: { ...p.selectedSkins, [fighter.id]: skin.id },
    }))
    bought = undefined
  }

  const isDaily = (f: Fighter, s: Skin) => daily?.fighter.id === f.id && daily.skin.id === s.id
</script>

{#snippet card(fighter: Fighter, skin: Skin, featured: boolean)}
  {@const owned = ownsSkin($progress, fighter.id, skin.id)}
  {@const price = skinPrice($progress, fighters, fighter, skin, today)}
  {@const fighterUnlocked = isUnlocked($progress, fighter.id)}
  <li class="item" class:featured class:legendary={skin.rarity === 'Legendary'} style="--rarity: {RARITY_COLORS[skin.rarity]}">
    {#if featured}<span class="ribbon">⭐ Skin of the day · 30% off</span>{/if}
    <img src={portrait(fighter.id, skin.id)} alt="" />
    <span class="skin-name">{skin.name}</span>
    <span class="fighter-name">{fighter.name}</span>
    <span class="rarity">{skin.rarity}</span>
    {#if owned}
      <span class="owned">✔ Owned</span>
    {:else if !fighterUnlocked}
      <span class="hint">🔒 Unlock {fighter.name} first</span>
    {:else}
      <button class="buy" disabled={wallet < price} onclick={() => buy(fighter, skin)}>
        {#if wallet === Infinity}
          Buy · free
        {:else if wallet >= price}
          Buy · {#if featured}<s class="was">{SETTINGS.skinPrices[skin.rarity]}</s>{/if}{price} C
        {:else}
          Need {price - wallet} more C
        {/if}
      </button>
    {/if}
  </li>
{/snippet}

<div class="shop">
  <p class="wallet">
    Your credits: <strong>{wallet === Infinity ? '∞' : wallet}</strong> C · win matches to earn more
  </p>

  {#if daily}
    <ul class="grid daily">
      {@render card(daily.fighter, daily.skin, true)}
    </ul>
  {/if}

  <ul class="grid">
    {#each items as { fighter, skin } (`${fighter.id}/${skin.id}`)}
      {#if !isDaily(fighter, skin)}
        {@render card(fighter, skin, false)}
      {/if}
    {/each}
  </ul>
</div>

{#if bought}
  <Celebration label="NEW SKIN!" title={bought.skin.name} subtitle={bought.fighter.name} />
  <div class="wear">
    <button onclick={() => wear(bought!.fighter, bought!.skin)}>Wear it</button>
    <button class="later" onclick={() => (bought = undefined)}>Later</button>
  </div>
{/if}

<style>
  .shop {
    max-width: 60rem;
    margin: 0 auto;
  }

  .wallet {
    margin: 0 0 0.8rem;
    font-weight: 700;
  }

  .wallet strong {
    color: #ffe45c;
    font-size: 1.2rem;
  }

  .grid {
    list-style: none;
    margin: 0 0 1rem;
    padding: 0;
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(10rem, 1fr));
    gap: 0.9rem;
  }

  .grid.daily {
    grid-template-columns: minmax(0, 18rem);
    justify-content: center;
  }

  .item {
    position: relative;
    display: flex;
    flex-direction: column;
    align-items: center;
    padding: 0.5rem 0.5rem 0.7rem;
    border-radius: 1rem;
    border: 3px solid var(--rarity);
    background: #160f33;
    text-align: center;
  }

  .item.featured {
    padding-top: 1.8rem;
    background: radial-gradient(circle at 50% 30%, color-mix(in srgb, var(--rarity) 40%, #160f33), #160f33 70%);
  }

  .item.legendary {
    animation: legendary 1.6s ease-in-out infinite;
  }

  @keyframes legendary {
    50% {
      box-shadow: 0 0 1.1rem #ffd23f, 0 0 0.3rem #fff3a0 inset;
    }
  }

  .ribbon {
    position: absolute;
    top: -0.8rem;
    padding: 0.2em 0.8em;
    border-radius: 999px;
    border: 3px solid #000;
    background: linear-gradient(#ffe45c, #ffb000);
    color: #160f33;
    font-weight: 900;
    font-size: 0.85rem;
    white-space: nowrap;
  }

  img {
    width: 100%;
    max-width: 10rem;
    aspect-ratio: 1;
    pointer-events: none;
  }

  .skin-name {
    font-weight: 900;
    font-size: 1.15rem;
  }

  .fighter-name {
    font-weight: 700;
    opacity: 0.85;
  }

  .rarity {
    font-size: 0.75rem;
    font-weight: 800;
    text-transform: uppercase;
    color: var(--rarity);
  }

  .owned,
  .hint {
    margin-top: 0.5rem;
    font-weight: 900;
  }

  .owned {
    color: #39ff88;
  }

  .hint {
    font-size: 0.9rem;
    opacity: 0.85;
  }

  button {
    font: inherit;
    font-weight: 900;
    border: 3px solid #000;
    border-radius: 0.8rem;
    cursor: pointer;
    touch-action: manipulation;
  }

  .buy {
    margin-top: 0.5rem;
    padding: 0.4em 1em;
    background: linear-gradient(#39ff88, #0a9f4a);
    color: #06210f;
    box-shadow: 0 0.25rem 0 #000;
  }

  .buy:disabled {
    background: #3a3a4a;
    color: #cfd3dc;
    box-shadow: none;
    cursor: default;
  }

  .buy s {
    opacity: 0.6;
    margin-right: 0.35em;
  }

  .wear {
    position: fixed;
    left: 50%;
    bottom: max(1.5rem, env(safe-area-inset-bottom));
    transform: translateX(-50%);
    display: flex;
    gap: 0.8rem;
    z-index: 11;
  }

  .wear button {
    padding: 0.5em 1.4em;
    font-size: 1.3rem;
    background: linear-gradient(#ffe45c, #ffb000);
    color: #160f33;
    box-shadow: 0 0.3rem 0 #000;
  }

  .wear .later {
    background: linear-gradient(#4aa8ff, #2f6bff);
    color: white;
  }
</style>
