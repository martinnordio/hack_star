<script lang="ts">
  import { Canvas, T } from '@threlte/core'
  import { lookSkin } from './created'
  import FighterStage from './FighterStage.svelte'
  import WorldGallery from './WorldGallery.svelte'
  import { VARIANTS } from './models/skins3d'

  // Created fighters: every head and body, and each body with new hands and legs.
  const created: [string, string][] = [0, 1, 2, 3, 4].flatMap((n) => [
    ['custom', lookSkin({ type: 'tank', main: '#2fb5ff', second: '#ffd23f', head: n, body: n, hands: 0, legs: 0 })],
    ['custom', lookSkin({ type: 'tank', main: '#e8322b', second: '#39d353', head: (n + 2) % 5, body: n, hands: 1 + (n % 2), legs: 2 - (n % 2) })],
  ])

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
    ...created,
  ]
  const only = new URLSearchParams(location.search).get('gallery')
  const combos = only ? all.filter(([f]) => f === only) : all
  const columns = only ? combos.length : 8
  const rows = Math.ceil(combos.length / columns)
</script>

{#if only === 'worlds'}
  <WorldGallery />
{:else}
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
{/if}
