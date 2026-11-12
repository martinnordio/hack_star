<script lang="ts">
  import { T, useTask, useThrelte } from '@threlte/core'
  import * as THREE from 'three'
  import { CANYON } from './game/arena'
  import type { World } from './game/world'
  import { buildArena } from './models/arena3d'
  import { animateFighter, buildFighter, disposeRig } from './models/fighters3d'

  interface Props {
    world: World
    fighterId: string
    skinId: string
    /** Called every frame before drawing, to apply input to the world. */
    onFrame?: (dt: number) => void
  }

  let { world, fighterId, skinId, onFrame }: Props = $props()

  const scenery = buildArena(CANYON)
  const rig = $derived(buildFighter(fighterId, skinId))
  $effect(() => {
    const current = rig
    return () => disposeRig(current)
  })

  const { size } = useThrelte()
  // Portrait screens are narrow: pull the camera back so the fighter sees enough around it.
  const zoom = $derived(Math.max(1, 0.85 / ($size.width / $size.height)))

  let camera = $state<THREE.PerspectiveCamera>()
  const focus = new THREE.Vector3()
  const wanted = new THREE.Vector3()
  let placed = false
  let time = 0

  useTask((dt) => {
    // Long frames (tab switch) would make everything jump.
    dt = Math.min(dt, 1 / 20)
    time += dt
    onFrame?.(dt)
    world.step(dt)

    const p = world.player
    rig.root.position.set(p.x, 0, p.z)
    rig.root.rotation.y = p.facing
    animateFighter(rig, time)

    if (camera) {
      focus.set(p.x, 0.8, p.z)
      wanted.set(p.x, 13 * zoom, p.z + 9 * zoom)
      if (!placed) {
        camera.position.copy(wanted)
        placed = true
      } else {
        camera.position.lerp(wanted, 1 - Math.exp(-6 * dt))
      }
      camera.lookAt(camera.position.x, focus.y, camera.position.z - 9 * zoom)
    }
  })
</script>

<T.PerspectiveCamera makeDefault fov={45} near={0.5} far={120} bind:ref={camera} />

<T.HemisphereLight args={['#d6f0ff', '#c98a50', 1.35]} />
<T.DirectionalLight
  position={[8, 18, 8]}
  intensity={2.4}
  color="#fff1d6"
  castShadow
  shadow.mapSize={[2048, 2048]}
  shadow.camera.left={-20}
  shadow.camera.right={20}
  shadow.camera.top={20}
  shadow.camera.bottom={-20}
  shadow.camera.far={60}
  shadow.bias={-0.0005}
/>

<T is={scenery} />
<T is={rig.root} />
