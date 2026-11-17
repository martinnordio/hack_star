<script lang="ts">
  import { Canvas, T } from '@threlte/core'
  import * as THREE from 'three'
  import { t, type TextKey } from './i18n'
  import { WORLDS, WORLD_SIZES, arenaFor, isWorldSize, type WorldSize } from './game/worlds'
  import { buildArena } from './models/arena3d'
  import { THEMES } from './models/themes'

  // Opened as /?gallery=worlds: every world at Small, or one world with &world=<id>&size=<size>.
  const params = new URLSearchParams(location.search)
  const chosen = WORLDS.find((w) => w.id === params.get('world'))
  const requested = params.get('size')
  const cellSize: WorldSize = !chosen ? 'small' : isWorldSize(requested) ? requested : 'large'

  // Each arena's sand floor reaches 20 units past its edges, so grid cells are drawn at half size.
  const CELL_W = 44
  const CELL_H = 36
  const SCALE = chosen ? 1 : 0.5
  const COLUMNS = chosen ? 1 : 4
  const shown = chosen ? [chosen] : WORLDS
  const rows = Math.ceil(shown.length / COLUMNS)

  /** A sky wall behind an arena, shaded from the top colour to the bottom colour. */
  function backdrop(width: number, height: number, sky: [string, string]): THREE.Mesh {
    const geometry = new THREE.PlaneGeometry(width, height)
    const top = new THREE.Color(sky[0])
    const bottom = new THREE.Color(sky[1])
    const position = geometry.getAttribute('position')
    const colors: number[] = []
    for (let i = 0; i < position.count; i++) {
      const shade = top.clone().lerp(bottom, (height / 2 - position.getY(i)) / height)
      colors.push(shade.r, shade.g, shade.b)
    }
    geometry.setAttribute('color', new THREE.Float32BufferAttribute(colors, 3))
    return new THREE.Mesh(geometry, new THREE.MeshBasicMaterial({ vertexColors: true }))
  }

  const scenes = shown.map((info, i) => {
    const arena = arenaFor(info.id, cellSize)
    const group = buildArena(arena, info.theme)
    // In the grid a sky wall would hide the row behind it, so only the single world gets one.
    if (chosen) {
      const wall = backdrop(Math.max(CELL_W / SCALE, arena.width + 10), CELL_H, THEMES[info.theme].sky)
      wall.position.set(0, CELL_H / 2, -arena.depth / 2 - 24)
      group.add(wall)
    }
    group.scale.setScalar(SCALE)
    const row = Math.floor(i / COLUMNS)
    group.position.set((i % COLUMNS - (COLUMNS - 1) / 2) * CELL_W, 0, (row - (rows - 1) / 2) * CELL_H)
    return group
  })

  // The grid sits higher in the frame so the link bar does not cover the last row.
  const cameraPosition: [number, number, number] = chosen ? [0, 30, 42] : [0, 170, 190]
  const lookTarget: [number, number, number] = chosen ? [0, 0, 0] : [0, -16, 0]
</script>

<div class="worlds">
  <Canvas>
    <T.PerspectiveCamera makeDefault position={cameraPosition} fov={50} oncreate={(c) => c.lookAt(...lookTarget)} />
    <T.HemisphereLight args={['#d6f0ff', '#c98a50', 1.35]} />
    <T.DirectionalLight position={[8, 18, 8]} intensity={2.4} color="#fff1d6" />
    {#each scenes as group}
      <T is={group} />
    {/each}
  </Canvas>
  <nav class="links">
    {#if chosen}
      {#each WORLD_SIZES as option}
        <a href="?gallery=worlds&world={chosen.id}&size={option}" aria-current={option === cellSize ? 'page' : undefined}>{$t(`worldSize.${option}` as TextKey)}</a>
      {/each}
    {:else}
      {#each WORLDS as info}
        <a href="?gallery=worlds&world={info.id}&size=large">{$t(`world.${info.id}` as TextKey)}</a>
      {/each}
    {/if}
  </nav>
</div>

<style>
  .worlds {
    position: fixed;
    inset: 0;
    background: #3a2a8c;
  }

  .links {
    position: absolute;
    left: 0;
    right: 0;
    bottom: 0;
    display: flex;
    flex-wrap: wrap;
    justify-content: center;
    gap: 0.5rem;
    padding: 0.5rem;
  }

  .links a {
    color: #fff;
    background: rgb(0 0 0 / 0.4);
    border-radius: 6px;
    padding: 0.3rem 0.6rem;
    font: 600 14px/1.2 system-ui, sans-serif;
    text-decoration: none;
  }

  .links a[aria-current='page'] {
    background: #ff9f1c;
    color: #1b1140;
  }
</style>
