<script lang="ts">
  import { Canvas, T } from '@threlte/core'
  import FighterStage from './FighterStage.svelte'

  const all: [string, string][] = [
    ['blaze', 'default'], ['blaze', 'lava'], ['blaze', 'phoenix'],
    ['rocko', 'default'], ['rocko', 'crystal'],
    ['turbo', 'default'], ['turbo', 'neon'],
    ['frosty', 'default'], ['frosty', 'snow_king'],
    ['luna', 'default'], ['luna', 'galaxy'], ['luna', 'supernova'],
    ['pixel', 'default'], ['pixel', 'glitch'],
  ]
  const only = new URLSearchParams(location.search).get('gallery')
  const combos = only ? all.filter(([f]) => f === only) : all
  const columns = only ? combos.length : 7
</script>

<div style="position:fixed;inset:0;background:#3a2a8c">
  <Canvas>
    <T.PerspectiveCamera makeDefault position={[0, 3, only ? 7 : 15]} fov={50} oncreate={(c) => c.lookAt(0, 1, 0)} />
    <T.HemisphereLight args={['#ffffff', '#6a4fbf', 1.6]} />
    <T.DirectionalLight position={[3, 6, 8]} intensity={2.5} />
    {#each combos as [fighter, skin], i}
      <FighterStage
        fighterId={fighter}
        skinId={skin}
        position={[(i % columns) * 2.6 - (columns - 1) * 1.3, only ? 0 : i < 7 ? 2.6 : -1.2, 0]}
      />
    {/each}
  </Canvas>
</div>
