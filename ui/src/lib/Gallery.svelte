<script lang="ts">
  import { Canvas, T } from '@threlte/core'
  import FighterStage from './FighterStage.svelte'
  import { VARIANTS } from './models/skins3d'

  const all: [string, string][] = [
    ['blaze', 'default'], ['blaze', 'lava'], ['blaze', 'phoenix'],
    ['rocko', 'default'], ['rocko', 'crystal'],
    ['turbo', 'default'], ['turbo', 'neon'],
    ['frosty', 'default'], ['frosty', 'snow_king'],
    ['luna', 'default'], ['luna', 'galaxy'], ['luna', 'supernova'],
    ['pixel', 'default'], ['pixel', 'glitch'],
    ['coco', 'default'], ['coco', 'pirate'],
    ['sparky', 'default'], ['sparky', 'gold'],
    ['clank', 'default'], ['clank', 'dragon'],
    ['kira', 'default'], ['kira', 'sakura'],
    ['marina', 'default'], ['drako', 'default'], ['spectra', 'default'], ['mecha', 'default'], ['zeus', 'default'],
    ...Object.entries(VARIANTS).flatMap(([fighter, skins]) => Object.keys(skins).map((skin): [string, string] => [fighter, skin])),
  ]
  const only = new URLSearchParams(location.search).get('gallery')
  const combos = only ? all.filter(([f]) => f === only) : all
  const columns = only ? combos.length : 8
  const rows = Math.ceil(combos.length / columns)
</script>

<div style="position:fixed;inset:0;background:#3a2a8c">
  <Canvas>
    <T.PerspectiveCamera makeDefault position={[0, 3, only ? 7 : 19]} fov={50} oncreate={(c) => c.lookAt(0, 1, 0)} />
    <T.HemisphereLight args={['#ffffff', '#6a4fbf', 1.6]} />
    <T.DirectionalLight position={[3, 6, 8]} intensity={2.5} />
    {#each combos as [fighter, skin], i}
      <FighterStage
        fighterId={fighter}
        skinId={skin}
        position={[(i % columns) * 2.6 - (columns - 1) * 1.3, ((rows - 1) / 2 - Math.floor(i / columns)) * 3.6, 0]}
      />
    {/each}
  </Canvas>
</div>
