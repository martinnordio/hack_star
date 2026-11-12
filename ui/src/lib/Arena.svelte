<script lang="ts">
  import { Canvas } from '@threlte/core'
  import { PCFShadowMap } from 'three'
  import ArenaScene from './ArenaScene.svelte'
  import { CANYON } from './game/arena'
  import { World } from './game/world'

  interface Props {
    fighterId: string
    skinId: string
    onLeave: () => void
  }

  let { fighterId, skinId, onLeave }: Props = $props()

  const world = new World(CANYON)
</script>

<div class="arena">
  <div class="scene">
    <Canvas shadows={PCFShadowMap}>
      <ArenaScene {world} {fighterId} {skinId} />
    </Canvas>
  </div>

  <button class="leave" onclick={onLeave} aria-label="Back to home">◀</button>
</div>

<style>
  .arena {
    position: fixed;
    inset: 0;
    overflow: hidden;
    background: linear-gradient(#7fd0ff, #ffe6b0);
    -webkit-touch-callout: none;
  }

  .scene {
    position: absolute;
    inset: 0;
    touch-action: none;
  }

  .leave {
    position: absolute;
    top: max(0.75rem, env(safe-area-inset-top));
    left: max(0.9rem, env(safe-area-inset-left));
    width: 3rem;
    height: 3rem;
    border-radius: 0.8rem;
    border: 3px solid #000;
    background: linear-gradient(#4aa8ff, #2f6bff);
    box-shadow: 0 0.25rem 0 #000;
    color: white;
    font-size: 1.3rem;
    cursor: pointer;
    touch-action: manipulation;
  }
</style>
