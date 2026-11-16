<script lang="ts">
  import { Canvas, T } from '@threlte/core'
  import { arenaFor, isWorldSize, WORLDS } from './game/worlds'
  import { buildArena } from './models/arena3d'
  import { ARENA_THEMES } from './models/themes'

  // /?gallery=worlds shows every world; add &world=<id> for one at full size and &size=medium|large.
  const params = new URLSearchParams(location.search)
  const requested = params.get('size')
  const size = isWorldSize(requested) ? requested : 'small'
  const one = WORLDS.find((w) => w.id === params.get('world'))
  const shown = one ? [one] : WORLDS
  const scale = one ? 1 : 0.1
  const columns = one ? 1 : 4
  const rows = Math.ceil(shown.length / columns)
  const cell = one ? 0 : 4.6
  const reach = one ? 44 : 20
  const items = shown.map((world, i) => ({
    world,
    scenery: buildArena(arenaFor(world.id, size), world.theme),
    x: ((i % columns) - (columns - 1) / 2) * cell,
    z: (Math.floor(i / columns) - (rows - 1) / 2) * cell * 0.8,
  }))
  const [skyTop, skyBottom] = one ? ARENA_THEMES[one.theme].sky : ['#3a2a8c', '#3a2a8c']
</script>

<div style="position:fixed;inset:0;background:linear-gradient({skyTop},{skyBottom})">
  <Canvas>
    <T.PerspectiveCamera makeDefault position={[0, reach, reach * 0.55]} fov={45} near={0.5} far={200} oncreate={(c) => c.lookAt(0, 0, 0)} />
    <T.HemisphereLight args={['#d6f0ff', '#c98a50', 1.6]} />
    <T.DirectionalLight position={[8, 18, 8]} intensity={2.4} color="#fff1d6" />
    {#each items as item (item.world.id)}
      <T.Group position={[item.x, 0, item.z]} scale={scale}>
        <T is={item.scenery} />
      </T.Group>
    {/each}
  </Canvas>
</div>
