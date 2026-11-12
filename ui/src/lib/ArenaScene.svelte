<script lang="ts">
  import { T, useTask, useThrelte } from '@threlte/core'
  import * as THREE from 'three'
  import { CANYON } from './game/arena'
  import { keyboardDirection, type Controls, type Vec2 } from './game/controls'
  import { SHOT_RADIUS, SHOT_RANGE, type World } from './game/world'
  import { buildArena } from './models/arena3d'
  import { animateFighter, buildFighter, disposeRig } from './models/fighters3d'

  interface Props {
    world: World
    controls: Controls
    fighterId: string
    skinId: string
  }

  let { world, controls, fighterId, skinId }: Props = $props()

  const SHOT_COLORS: Record<string, string> = {
    blaze: '#ff7a1a',
    rocko: '#e0b07a',
    turbo: '#39c6ff',
    frosty: '#9fe4ff',
    luna: '#ffd23f',
    pixel: '#39ff88',
  }

  const scenery = buildArena(CANYON)
  const rig = $derived(buildFighter(fighterId, skinId))
  $effect(() => {
    const current = rig
    return () => disposeRig(current)
  })

  // Shots: a fixed pool of glowing balls, reused every frame.
  const shotColor = $derived(SHOT_COLORS[fighterId] ?? '#ffd23f')
  const shotMaterial = new THREE.MeshBasicMaterial()
  const glowMaterial = new THREE.MeshBasicMaterial({
    transparent: true,
    opacity: 0.35,
    blending: THREE.AdditiveBlending,
    depthWrite: false,
  })
  $effect(() => {
    shotMaterial.color.set(shotColor).lerp(new THREE.Color('#ffffff'), 0.35)
    glowMaterial.color.set(shotColor)
  })
  const shotPool = new THREE.Group()
  const shotMeshes = Array.from({ length: 24 }, () => {
    const ball = new THREE.Mesh(new THREE.SphereGeometry(SHOT_RADIUS, 12, 8), shotMaterial)
    ball.add(new THREE.Mesh(new THREE.SphereGeometry(SHOT_RADIUS * 2, 12, 8), glowMaterial))
    ball.visible = false
    shotPool.add(ball)
    return ball
  })

  // Aim guide: a flat translucent strip from the fighter, as long as a shot flies.
  const aimGeometry = new THREE.PlaneGeometry(0.5, SHOT_RANGE)
  aimGeometry.rotateX(-Math.PI / 2)
  aimGeometry.translate(0, 0.03, SHOT_RANGE / 2)
  const aimLine = new THREE.Mesh(
    aimGeometry,
    new THREE.MeshBasicMaterial({ color: '#ffffff', transparent: true, opacity: 0.5, depthWrite: false }),
  )
  aimLine.visible = false

  const { size } = useThrelte()
  // Portrait screens are narrow: pull the camera back so the fighter sees enough around it.
  const zoom = $derived(Math.max(1, 0.85 / ($size.width / $size.height)))

  let camera = $state<THREE.PerspectiveCamera>()
  const wanted = new THREE.Vector3()
  const raycaster = new THREE.Raycaster()
  const groundPlane = new THREE.Plane(new THREE.Vector3(0, 1, 0), 0)
  const hit = new THREE.Vector3()
  let placed = false
  let time = 0
  let runTime = 0
  let lastShotAt = -1

  function pointerAim(): Vec2 | null {
    if (!controls.pointer || !camera) return null
    raycaster.setFromCamera(new THREE.Vector2(controls.pointer.x, controls.pointer.y), camera)
    if (!raycaster.ray.intersectPlane(groundPlane, hit)) return null
    return { x: hit.x - world.player.x, z: hit.z - world.player.z }
  }

  function fire(dir: Vec2) {
    if (world.fire(dir.x, dir.z)) lastShotAt = time
  }

  function applyControls(dt: number) {
    const keys = keyboardDirection(controls.keys)
    const mx = keys.x + controls.moveStick.x
    const mz = keys.z + controls.moveStick.z
    const running = Math.hypot(mx, mz) > 0.05
    if (running) {
      world.move(mx, mz, dt)
      runTime += dt
    } else {
      runTime = 0
    }

    const stickAim = controls.aimStick
    const aim = stickAim ?? pointerAim()
    if (controls.mouseDown && aim) fire(aim)
    if (controls.fireDir) {
      fire(controls.fireDir)
      controls.fireDir = null
    }
    if (controls.tapFire) {
      const target = world.nearestDummy()
      const p = world.player
      fire(target ? { x: target.x - p.x, z: target.z - p.z } : { x: Math.sin(p.facing), z: Math.cos(p.facing) })
      controls.tapFire = false
    }

    aimLine.visible = !!aim && (stickAim !== null || controls.pointer !== null)
    if (aim) {
      aimLine.position.set(world.player.x, 0, world.player.z)
      aimLine.rotation.y = Math.atan2(aim.x, aim.z)
    }
    return running
  }

  useTask((dt) => {
    // Long frames (tab switch) would make everything jump.
    dt = Math.min(dt, 1 / 20)
    time += dt
    const running = applyControls(dt)
    world.step(dt)
    world.drainEvents()

    const p = world.player
    animateFighter(rig, time)
    const recoil = Math.max(0, 1 - (time - lastShotAt) / 0.15)
    const hop = running ? Math.abs(Math.sin(runTime * 13)) * 0.18 : 0
    rig.root.position.set(p.x - Math.sin(p.facing) * recoil * 0.15, hop, p.z - Math.cos(p.facing) * recoil * 0.15)
    rig.root.rotation.y = p.facing
    rig.body.rotation.x = running ? 0.22 : -recoil * 0.25

    shotMeshes.forEach((mesh, i) => {
      const shot = world.shots[i]
      mesh.visible = !!shot
      if (shot) mesh.position.set(shot.x, 0.8, shot.z)
    })

    // Development only: state for browser checks (the page cannot read JS objects from outside).
    if (import.meta.env.DEV) {
      const el = document.querySelector('.arena')
      el?.setAttribute('data-player', `${p.x.toFixed(2)},${p.z.toFixed(2)}`)
      el?.setAttribute('data-shots', String(world.shots.length))
      el?.setAttribute('data-dummies', world.dummies.map((d) => d.health).join(','))
      el?.setAttribute('data-in-bush', String(world.inBush()))
    }

    if (camera) {
      wanted.set(p.x, 13 * zoom, p.z + 9 * zoom)
      if (!placed) {
        camera.position.copy(wanted)
        placed = true
      } else {
        camera.position.lerp(wanted, 1 - Math.exp(-6 * dt))
      }
      camera.lookAt(camera.position.x, 0.8, camera.position.z - 9 * zoom)
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
<T is={aimLine} />
<T is={rig.root} />
<T is={shotPool} />
