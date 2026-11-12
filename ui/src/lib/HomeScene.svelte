<script lang="ts">
  import { T, useTask, useThrelte } from '@threlte/core'
  import { untrack } from 'svelte'
  import * as THREE from 'three'
  import FighterStage from './FighterStage.svelte'
  import { toon } from './models/parts'

  interface Props {
    fighterId: string
    skinId: string
    /** Play the entrance (drop-in, burst) instead of starting at rest. */
    entrance: boolean
    skipped?: boolean
    onEntranceEnd?: () => void
  }

  let { fighterId, skinId, entrance, skipped = false, onEntranceEnd }: Props = $props()

  const ENTRANCE_SECONDS = 2.2

  const { size } = useThrelte()
  const zoom = $derived(Math.max(1, 0.9 / ($size.width / $size.height)))

  let camera = $state<THREE.PerspectiveCamera>()
  $effect(() => {
    camera?.position.set(0, 2.1, 8 * zoom)
    camera?.lookAt(0, 1.45, 0)
  })

  let t = $state(untrack(() => (entrance ? 0 : ENTRANCE_SECONDS)))
  let ended = untrack(() => !entrance)

  // Drop from the sky with a bounce (easeOutBounce), then a squash on landing.
  function bounce(x: number): number {
    const n = 7.5625
    const d = 2.75
    if (x < 1 / d) return n * x * x
    if (x < 2 / d) return n * (x -= 1.5 / d) * x + 0.75
    if (x < 2.5 / d) return n * (x -= 2.25 / d) * x + 0.9375
    return n * (x -= 2.625 / d) * x + 0.984375
  }
  const drop = $derived(Math.min(1, t / 1.1))
  const fighterY = $derived(7 * (1 - bounce(drop)))
  const spin = $derived(drop < 1 ? (1 - drop) * Math.PI * 4 : 0)

  // Light rays behind the fighter.
  const rays = new THREE.Group()
  const rayMaterial = new THREE.MeshBasicMaterial({
    color: '#ffe27a',
    transparent: true,
    opacity: 0.16,
    blending: THREE.AdditiveBlending,
    depthWrite: false,
    side: THREE.DoubleSide,
  })
  for (let i = 0; i < 14; i++) {
    const ray = new THREE.Mesh(new THREE.PlaneGeometry(0.9, 14), rayMaterial)
    ray.geometry.translate(0, 7, 0)
    ray.rotation.z = (i / 14) * Math.PI * 2
    rays.add(ray)
  }

  // Burst of sparkles when the fighter lands.
  const burst = new THREE.Group()
  const sparkMaterial = new THREE.MeshBasicMaterial({ color: '#fff3a0', transparent: true })
  const sparks = Array.from({ length: 36 }, (_, i) => {
    const mesh = new THREE.Mesh(new THREE.OctahedronGeometry(0.09), sparkMaterial)
    const a = (i / 36) * Math.PI * 2
    const v = new THREE.Vector3(Math.cos(a) * (2 + (i % 3)), 2 + (i % 4) * 1.2, Math.sin(a) * (2 + (i % 3)))
    burst.add(mesh)
    return { mesh, v }
  })

  let time = 0
  useTask((delta) => {
    time += delta
    rays.rotation.z = time * 0.15
    rayMaterial.opacity = 0.12 + Math.sin(time * 1.5) * 0.04

    if (!ended) {
      t = Math.min(ENTRANCE_SECONDS, t + delta)
      if (t >= ENTRANCE_SECONDS) {
        ended = true
        onEntranceEnd?.()
      }
    }
    const since = t - 1.1
    burst.visible = since > 0 && since < 1.1
    if (burst.visible) {
      for (const { mesh, v } of sparks) {
        mesh.position.set(v.x * since, 0.3 + v.y * since - 4 * since * since, v.z * since)
        mesh.rotation.y = time * 6
      }
      sparkMaterial.opacity = 1 - since / 1.1
    }
  })

  $effect(() => {
    if (skipped) t = ENTRANCE_SECONDS
  })

  const podiumTop = toon('#5b3fd6')
  const podiumSide = toon('#2c1d7a')
  const podiumRim = toon('#ffd23f', '#ffb000', 0.4)
</script>

<T.PerspectiveCamera makeDefault fov={40} bind:ref={camera} />

<T.HemisphereLight args={['#fff4e0', '#5b3fd6', 1.5]} />
<T.DirectionalLight position={[3, 6, 5]} intensity={2.4} castShadow shadow.mapSize={[1024, 1024]} />

<T is={rays} position={[0, 1.4, -3]} />

<!-- Podium -->
<T.Mesh position.y={-0.25} receiveShadow material={podiumSide}>
  <T.CylinderGeometry args={[1.5, 1.7, 0.5, 40]} />
</T.Mesh>
<T.Mesh position.y={0.005} receiveShadow material={podiumTop}>
  <T.CylinderGeometry args={[1.45, 1.45, 0.02, 40]} />
</T.Mesh>
<T.Mesh position.y={0.0} rotation.x={Math.PI / 2} material={podiumRim}>
  <T.TorusGeometry args={[1.5, 0.05, 8, 48]} />
</T.Mesh>

<FighterStage {fighterId} {skinId} position={[0, fighterY, 0]} rotationY={spin} scale={1.25} />

<T is={burst} />
