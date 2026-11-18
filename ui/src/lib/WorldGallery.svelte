<script lang="ts">
  import { Canvas, T } from '@threlte/core'
  import { PCFShadowMap } from 'three'
  import FighterStage from './FighterStage.svelte'
  import {
    WORLDS,
    WORLD_SIZES,
    arenaFor,
    isWorldId,
    isWorldSize,
    worldInfo,
    worldNameKey,
    worldSizeKey,
    type WorldId,
    type WorldSize,
  } from './game/worlds'
  import { t } from './i18n'
  import { WORLD_LOOKS, buildArena, disposeArena, shadowReach } from './models/arena3d'

  // `/?gallery=worlds&world=<id>&size=<size>`: one world at a time, to look at the themes.
  const params = new URLSearchParams(location.search)
  const askedWorld = params.get('world')
  const askedSize = params.get('size')
  let id = $state<WorldId>(isWorldId(askedWorld) ? askedWorld : 'canyon')
  let size = $state<WorldSize>(isWorldSize(askedSize) ? askedSize : 'small')
  let width = $state(window.innerWidth)
  let height = $state(window.innerHeight)

  const arena = $derived(arenaFor(id, size))
  const look = $derived(WORLD_LOOKS[worldInfo(id).theme])
  const scenery = $derived(buildArena(arena, worldInfo(id).theme))
  const reach = $derived(shadowReach(arena))
  // The whole arena on screen, seen from the camera's side as in a match.
  const distance = $derived(Math.max(arena.width / (width / height), arena.depth) * 0.95 + 4)

  $effect(() => {
    const built = scenery
    return () => disposeArena(built)
  })

  function choose(nextId: WorldId, nextSize: WorldSize) {
    id = nextId
    size = nextSize
    const url = new URL(location.href)
    url.searchParams.set('world', nextId)
    url.searchParams.set('size', nextSize)
    history.replaceState(null, '', url)
  }

  // Frames per second, for browser checks of big worlds on tablets (`data-fps`).
  let fps = $state(0)
  $effect(() => {
    let frames = 0
    let last = performance.now()
    let handle = 0
    const tick = (now: number) => {
      frames++
      if (now - last >= 1000) {
        fps = Math.round((frames * 1000) / (now - last))
        frames = 0
        last = now
      }
      handle = requestAnimationFrame(tick)
    }
    handle = requestAnimationFrame(tick)
    return () => cancelAnimationFrame(handle)
  })
</script>

<svelte:window bind:innerWidth={width} bind:innerHeight={height} />

<div class="worlds" data-fps={fps} style:--sky-top={look.sky[0]} style:--sky-bottom={look.sky[1]}>
  <Canvas shadows={PCFShadowMap} renderMode="always">
    {#key `${id}/${size}/${distance}`}
      <T.PerspectiveCamera
        makeDefault
        fov={45}
        near={0.5}
        far={200}
        position={[0, distance, distance * 0.75]}
        oncreate={(c) => c.lookAt(0, 0, 0)}
      />
    {/key}
    <T.HemisphereLight args={['#d6f0ff', '#c98a50', 1.35]} />
    {#key reach}
      <T.DirectionalLight
        position={[8, 18, 8]}
        intensity={2.4}
        color="#fff1d6"
        castShadow
        shadow.mapSize={[2048, 2048]}
        shadow.camera.left={-reach}
        shadow.camera.right={reach}
        shadow.camera.top={reach}
        shadow.camera.bottom={-reach}
        shadow.camera.far={60}
        shadow.bias={-0.0005}
      />
    {/key}
    {#key scenery}
      <T is={scenery} />
    {/key}
    <FighterStage fighterId="blaze" position={[arena.start.x, 0, arena.start.z]} />
  </Canvas>

  <nav>
    <div class="row">
      {#each WORLDS as w (w.id)}
        <button aria-pressed={w.id === id} onclick={() => choose(w.id, size)}>{$t(worldNameKey(w.id))}</button>
      {/each}
    </div>
    <div class="row">
      {#each WORLD_SIZES as s (s)}
        <button aria-pressed={s === size} onclick={() => choose(id, s)}>{$t(worldSizeKey(s))}</button>
      {/each}
    </div>
  </nav>
</div>

<style>
  .worlds {
    position: fixed;
    inset: 0;
    background: linear-gradient(var(--sky-top), var(--sky-bottom));
  }

  nav {
    position: absolute;
    top: max(8px, env(safe-area-inset-top));
    left: max(8px, env(safe-area-inset-left));
    right: max(8px, env(safe-area-inset-right));
    display: flex;
    flex-direction: column;
    gap: 6px;
  }

  .row {
    display: flex;
    flex-wrap: wrap;
    gap: 6px;
  }

  button {
    padding: 6px 10px;
    border: 2px solid #160f33;
    border-radius: 10px;
    background: #160f33cc;
    color: white;
    font: inherit;
    font-size: 0.85rem;
    cursor: pointer;
  }

  button[aria-pressed='true'] {
    background: #ffd23f;
    color: #160f33;
  }
</style>
