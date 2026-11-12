<script lang="ts">
  import { T, useTask, useThrelte } from '@threlte/core'
  import { untrack } from 'svelte'
  import * as THREE from 'three'
  import { CANYON } from './game/arena'
  import { keyboardDirection, type Controls, type Vec2 } from './game/controls'
  import { SHOT_RADIUS, SHOT_RANGE, DUMMY_HEALTH, type World, type WorldEvent } from './game/world'
  import { buildArena } from './models/arena3d'
  import { buildDummy, setHealth } from './models/dummy3d'
  import { animateFighter, buildFighter, disposeRig, setRigOpacity } from './models/fighters3d'
  import { Particles } from './models/particles'

  interface Props {
    world: World
    controls: Controls
    fighterId: string
    skinId: string
    /** HTML layer over the canvas for floating damage numbers. */
    overlay?: HTMLElement
  }

  let { world, controls, fighterId, skinId, overlay }: Props = $props()

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

  const particles = new Particles()

  // One world per arena visit: the dummy views are built once.
  const dummies = untrack(() => world.dummies).map((d) => {
    const rig = buildDummy()
    rig.root.position.set(d.x, 0, d.z)
    return { rig, flashUntil: 0, spawnedAt: -10 }
  })
  const dummyGroup = new THREE.Group()
  dummies.forEach((d) => dummyGroup.add(d.rig.root))

  // Floating damage numbers: a few DOM elements positioned over the canvas each frame.
  const floaters: { el: HTMLElement; at: THREE.Vector3; age: number }[] = []
  const projected = new THREE.Vector3()

  function showDamage(x: number, z: number, damage: number) {
    if (!overlay) return
    const el = document.createElement('div')
    el.className = 'damage'
    el.textContent = String(damage)
    overlay.appendChild(el)
    floaters.push({ el, at: new THREE.Vector3(x + (Math.random() - 0.5) * 0.6, 2.3, z), age: 0 })
  }

  function at(x: number, y: number, z: number) {
    return new THREE.Vector3(x, y, z)
  }

  function handle(e: WorldEvent) {
    if (e.type === 'fire') {
      particles.burst({ color: shotColor, at: at(e.x, 0.8, e.z), count: 5, speed: 1.5, life: 0.12, size: 0.3, endSize: 0.6 })
      particles.burst({ color: '#ffffff', at: at(e.x, 0.8, e.z), count: 2, speed: 0.5, life: 0.08, size: 0.25, endSize: 0.5 })
    } else if (e.type === 'hit') {
      const d = dummies[e.dummyId]
      d.flashUntil = time + 0.12
      particles.burst({ color: shotColor, at: at(e.x, 1.2, e.z), count: 10, speed: 5, up: 3, gravity: 10, life: 0.4, size: 0.12 })
      particles.burst({ color: '#fff3a0', at: at(e.x, 1.2, e.z), count: 5, speed: 3, up: 2, life: 0.25, size: 0.1 })
      showDamage(e.x, e.z, e.damage)
    } else if (e.type === 'blocked') {
      particles.burst({ color: shotColor, at: at(e.x, 0.8, e.z), count: 6, speed: 3, up: 2, gravity: 8, life: 0.3, size: 0.1 })
      particles.burst({ color: '#e8d2a8', at: at(e.x, 0.6, e.z), count: 3, speed: 0.8, up: 0.5, life: 0.4, size: 0.15, endSize: 0.4 })
    } else if (e.type === 'break') {
      const d = dummies[e.dummyId]
      d.rig.root.visible = false
      particles.burst({ color: '#e8c26a', at: at(e.x, 1.2, e.z), count: 16, speed: 4, up: 6, gravity: 14, life: 1.3, size: 0.13, endSize: 0.08, chunky: true })
      particles.burst({ color: '#8a5a2b', at: at(e.x, 0.6, e.z), count: 6, speed: 3, up: 5, gravity: 14, life: 1.3, size: 0.1, endSize: 0.06, chunky: true })
      particles.burst({ color: '#e8d2a8', at: at(e.x, 0.4, e.z), count: 10, speed: 2, up: 0.8, life: 0.7, size: 0.3, endSize: 0.8 })
    } else if (e.type === 'respawn') {
      const d = dummies[e.dummyId]
      d.rig.root.visible = true
      d.spawnedAt = time
      const w = world.dummies[e.dummyId]
      particles.burst({ color: '#ffffff', at: at(w.x, 0.3, w.z), count: 10, speed: 2.5, up: 1, life: 0.5, size: 0.2, endSize: 0.5 })
    }
  }

  let wasInBush = false
  let dustTimer = 0

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
    for (const e of world.drainEvents()) handle(e)
    particles.update(dt)

    const p = world.player

    const inBush = world.inBush()
    if (inBush !== wasInBush) {
      setRigOpacity(rig, inBush ? 0.35 : 1)
      wasInBush = inBush
    }

    dustTimer -= dt
    if (running && dustTimer <= 0 && !inBush) {
      dustTimer = 0.09
      particles.burst({
        color: '#e8d2a8',
        at: at(p.x - Math.sin(p.facing) * 0.3, 0.1, p.z - Math.cos(p.facing) * 0.3),
        count: 1,
        speed: 0.5,
        up: 0.8,
        life: 0.5,
        size: 0.15,
        endSize: 0.45,
      })
    }

    world.dummies.forEach((d, i) => {
      const view = dummies[i]
      setHealth(view.rig, d.health / DUMMY_HEALTH)
      const flashing = time < view.flashUntil
      for (const m of view.rig.materials) {
        m.emissive.set(flashing ? '#ffffff' : '#000000')
        m.emissiveIntensity = flashing ? 0.8 : 0
      }
      view.rig.body.rotation.z = flashing ? Math.sin(time * 80) * 0.08 : 0
      const pop = Math.min(1, (time - view.spawnedAt) / 0.35)
      view.rig.root.scale.setScalar(pop < 1 ? 1 + Math.sin(pop * Math.PI) * 0.25 : 1)
      if (camera) view.rig.bar.quaternion.copy(camera.quaternion)
    })
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
      // Look a bit ahead of the fighter (up the screen), where the action is.
      wanted.set(p.x, 13 * zoom, p.z + 7 * zoom)
      if (!placed) {
        camera.position.copy(wanted)
        placed = true
      } else {
        camera.position.lerp(wanted, 1 - Math.exp(-6 * dt))
      }
      camera.lookAt(camera.position.x, 0.8, camera.position.z - 9 * zoom)

      for (let i = floaters.length - 1; i >= 0; i--) {
        const f = floaters[i]
        f.age += dt
        if (f.age > 0.9) {
          f.el.remove()
          floaters.splice(i, 1)
          continue
        }
        projected.copy(f.at).project(camera)
        const x = ((projected.x + 1) / 2) * $size.width
        const y = ((1 - projected.y) / 2) * $size.height - f.age * 60
        f.el.style.transform = `translate(${x}px, ${y}px) translate(-50%, -50%) scale(${f.age < 0.12 ? 0.6 + f.age * 4 : 1})`
        f.el.style.opacity = String(f.age > 0.6 ? (0.9 - f.age) / 0.3 : 1)
      }
    }
  })

  $effect(() => () => floaters.forEach((f) => f.el.remove()))
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
<T is={dummyGroup} />
<T is={rig.root} />
<T is={shotPool} />
<T is={particles.group} />
