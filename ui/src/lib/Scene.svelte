<script lang="ts">
  import { T, useTask, useThrelte } from '@threlte/core'
  import { interactivity } from '@threlte/extras'
  import type { PerspectiveCamera } from 'three'

  interactivity()

  const HOP_SECONDS = 0.45

  const { size } = useThrelte()
  // Portrait screens are narrow: move the camera back so the arena still fits.
  const zoom = $derived(Math.max(1, 0.75 / ($size.width / $size.height)))

  let camera = $state<PerspectiveCamera>()
  $effect(() => {
    camera?.position.set(0, 13 * zoom, 11 * zoom)
    camera?.lookAt(0, 0, 0)
  })

  let time = $state(0)
  let hopStart = $state(-Infinity)

  useTask((delta) => {
    time += delta
  })

  const hop = $derived.by(() => {
    const t = (time - hopStart) / HOP_SECONDS
    return t >= 0 && t < 1 ? Math.sin(t * Math.PI) * 1.4 : 0
  })
  const bob = $derived(Math.sin(time * 3) * 0.08)

  const walls: [number, number, number][] = [
    [-5, 0.5, -3],
    [5, 0.5, -3],
    [-4, 0.5, 4],
    [4, 0.5, 4],
  ]
  const bushes: [number, number][] = [
    [-2.5, -5],
    [2.5, -5],
    [0, 5.5],
  ]
</script>

<T.PerspectiveCamera
  makeDefault
  fov={45}
  bind:ref={camera}
/>

<T.HemisphereLight args={['#cfe9ff', '#5a3d1e', 1.4]} />
<T.DirectionalLight
  position={[6, 12, 6]}
  intensity={2.2}
  castShadow
  shadow.mapSize={[1024, 1024]}
  shadow.camera.left={-12}
  shadow.camera.right={12}
  shadow.camera.top={12}
  shadow.camera.bottom={-12}
/>

<!-- Arena floor: tap or click it to make the fighter hop. -->
<T.Mesh rotation.x={-Math.PI / 2} receiveShadow onpointerdown={() => (hopStart = time)}>
  <T.PlaneGeometry args={[22, 22]} />
  <T.MeshStandardMaterial color="#e9c27a" />
</T.Mesh>

{#each walls as position}
  <T.Mesh {position} castShadow receiveShadow>
    <T.BoxGeometry args={[2.5, 1, 1]} />
    <T.MeshStandardMaterial color="#b0603a" />
  </T.Mesh>
{/each}

{#each bushes as [x, z]}
  <T.Mesh position={[x, 0.6, z]} castShadow>
    <T.SphereGeometry args={[0.9, 16, 12]} />
    <T.MeshStandardMaterial color="#3fa34d" />
  </T.Mesh>
{/each}

<!-- Placeholder fighter until real models arrive (basic UI and graphics demo specs). -->
<T.Group position.y={bob + hop} rotation.y={Math.sin(time * 0.8) * 0.4}>
  <T.Mesh position.y={0.8} castShadow>
    <T.CapsuleGeometry args={[0.5, 0.6, 8, 16]} />
    <T.MeshStandardMaterial color="#ff4f9a" />
  </T.Mesh>
  <T.Mesh position.y={1.75} castShadow>
    <T.SphereGeometry args={[0.45, 24, 16]} />
    <T.MeshStandardMaterial color="#ffd6a5" />
  </T.Mesh>
  {#each [-0.16, 0.16] as x}
    <T.Mesh position={[x, 1.8, 0.4]}>
      <T.SphereGeometry args={[0.08, 12, 8]} />
      <T.MeshStandardMaterial color="#1b1446" />
    </T.Mesh>
  {/each}
</T.Group>
