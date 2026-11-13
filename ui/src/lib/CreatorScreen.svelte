<script lang="ts">
  import { Canvas } from '@threlte/core'
  import { untrack } from 'svelte'
  import { PCFShadowMap } from 'three'
  import { progress } from './accounts'
  import Celebration from './Celebration.svelte'
  import {
    BODIES,
    CREATED_COLORS,
    CREATED_ID,
    HEADS,
    MAX_CREATED_NAME,
    createCost,
    defaultLook,
    lookSkin,
    saveCreated,
  } from './created'
  import { credits } from './hacks'
  import { FIGHTER_TYPE_IDS, fighterType } from './game/types'
  import HomeScene from './HomeScene.svelte'
  import { t, type TextKey } from './i18n'
  import type { CreatedLook } from './progress'

  let { onDone }: { onDone: () => void } = $props()

  let look = $state<CreatedLook>(untrack(() => ({ ...($progress.createdFighter ?? defaultLook()) })))
  let problem = $state<string>()
  let celebrating = $state(false)

  const editing = $derived($progress.createdFighter !== null)
  const cost = $derived(createCost($progress))
  const wallet = $derived(credits($progress))
  const skin = $derived(lookSkin(look))

  function save() {
    const result = saveCreated($progress, look)
    if (!result.ok) {
      problem =
        result.reason === 'name' ? $t('creator.nameProblem') : $t('common.needMore', { credits: result.missing })
      return
    }
    problem = undefined
    $progress = result.progress
    celebrating = true
    setTimeout(onDone, 1600)
  }
</script>

<div class="creator">
  <div class="stage">
    <Canvas shadows={PCFShadowMap}>
      <HomeScene fighterId={CREATED_ID} skinId={skin} entrance={false} />
    </Canvas>
  </div>

  <div class="form">
    <label for="created-name">{$t('creator.name')}</label>
    <input id="created-name" bind:value={look.name} maxlength={MAX_CREATED_NAME} autocomplete="off" />

    <span class="label" id="created-type">{$t('creator.type')}</span>
    <div class="choices" role="radiogroup" aria-labelledby="created-type">
      {#each FIGHTER_TYPE_IDS as type (type)}
        {@const info = fighterType(type)}
        <button role="radio" aria-checked={look.type === type} onclick={() => (look.type = type)}>
          {info.emoji} {$t(info.nameKey)}
        </button>
      {/each}
    </div>

    {#each [['main', 'creator.mainColor'], ['second', 'creator.secondColor']] as const as [field, label] (field)}
      <span class="label" id="created-{field}">{$t(label)}</span>
      <div class="swatches" role="radiogroup" aria-labelledby="created-{field}">
        {#each CREATED_COLORS as color, i (color)}
          <button
            class="swatch"
            role="radio"
            aria-checked={look[field] === color}
            aria-label={$t('creator.color', { n: i + 1 })}
            style="--color: {color}"
            onclick={() => (look[field] = color)}
          ></button>
        {/each}
      </div>
    {/each}

    {#each [['head', HEADS], ['body', BODIES]] as const as [field, options] (field)}
      <span class="label" id="created-{field}">{$t(`creator.${field}` as TextKey)}</span>
      <div class="choices" role="radiogroup" aria-labelledby="created-{field}">
        {#each options as option (option)}
          <button role="radio" aria-checked={look[field] === option} onclick={() => (look[field] = option)}>
            {$t(`creator.${field}.${option}` as TextKey)}
          </button>
        {/each}
      </div>
    {/each}

    {#if problem}<p class="problem" role="alert">{problem}</p>{/if}

    <button class="save" onclick={save}>
      {#if !editing}
        ✨ {$t('creator.create')}
      {:else}
        💾 {$t('creator.save', { price: wallet === Infinity ? $t('common.free') : $t('common.price', { credits: cost }) })}
      {/if}
    </button>
  </div>
</div>

{#if celebrating}
  <Celebration label={$t('creator.created')} title={look.name.trim()} subtitle={$t(fighterType(look.type).nameKey)} />
{/if}

<style>
  .creator {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 1rem;
    max-width: 70rem;
    margin: 0 auto;
    color: white;
    font-weight: 800;
  }

  .stage {
    height: min(70vh, 32rem);
    border-radius: 1.2rem;
    border: 3px solid #000;
    overflow: hidden;
    background: radial-gradient(ellipse at 50% 40%, #6a4bff, #1b1446);
  }

  .form {
    display: flex;
    flex-direction: column;
    gap: 0.45rem;
  }

  label,
  .label {
    color: #ffd23f;
    font-weight: 900;
  }

  input {
    padding: 0.45rem 0.7rem;
    border-radius: 0.8rem;
    border: 3px solid #000;
    font: inherit;
    font-size: 1.2rem;
  }

  button {
    font: inherit;
    color: white;
    cursor: pointer;
    border: 3px solid #000;
    border-radius: 0.8rem;
    background: #160f33;
    box-shadow: 0 0.2rem 0 #000;
    touch-action: manipulation;
  }

  .choices {
    display: flex;
    flex-wrap: wrap;
    gap: 0.4rem;
  }

  .choices button {
    padding: 0.35rem 0.7rem;
  }

  button[aria-checked='true'] {
    border-color: #ffd23f;
    background: #3a2a8c;
  }

  .swatches {
    display: flex;
    flex-wrap: wrap;
    gap: 0.4rem;
  }

  .swatch {
    width: 2.2rem;
    height: 2.2rem;
    border-radius: 50%;
    background: var(--color);
  }

  .swatch[aria-checked='true'] {
    background: var(--color);
    outline: 3px solid #fff;
  }

  .problem {
    margin: 0;
    padding: 0.4rem 0.7rem;
    border-radius: 0.7rem;
    background: #8a1030;
    border: 2px solid #000;
  }

  .save {
    margin-top: 0.4rem;
    padding: 0.6rem 1rem;
    font-size: 1.3rem;
    font-weight: 900;
    background: linear-gradient(#ffe45c, #ffb000);
    color: #160f33;
  }

  @media (max-width: 700px), (max-aspect-ratio: 3/4) {
    .creator {
      grid-template-columns: 1fr;
    }

    .stage {
      height: 40vh;
    }
  }
</style>
