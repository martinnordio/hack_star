<script lang="ts" module>
  import type { MatchPhase, MatchResult } from './game/match'

  export interface Look {
    fighterId: string
    skinId: string
  }

  export interface Hud {
    phase: MatchPhase
    countdown: number
    timeLeft: number
    overtime: boolean
    fightersLeft: number
    result: MatchResult | null
  }

  /** The player's Super state, for the Super button. */
  export interface Power {
    superCharge: number
    hyperReady: boolean
    hyper: boolean
  }
</script>

<script lang="ts">
  import { T, useTask, useThrelte } from '@threlte/core'
  import { untrack } from 'svelte'
  import * as THREE from 'three'
  import { CANYON } from './game/arena'
  import { keyboardDirection, type Controls, type Vec2 } from './game/controls'
  import type { MatchLike } from './game/match'
  import { BUSH_SIGHT, DUMMY_HEALTH, SHOT_RADIUS, SHOT_RANGE, type World, type WorldEvent } from './game/world'
  import { buildArena } from './models/arena3d'
  import { buildDummy, setHealth } from './models/dummy3d'
  import { animateFighter, buildFighter, disposeRig, setRigOpacity } from './models/fighters3d'
  import { parseLookSkin } from './created'
  import { buildHealthBar, setBarHealth, type HealthBar } from './models/healthBar'
  import { Particles } from './models/particles'
  import type { Rig } from './models/parts'

  interface Props {
    world: World
    /** Present in a match; absent in training. */
    match?: MatchLike
    /** A friend in a shared match asks the host to shoot instead of shooting locally. */
    actions?: { fire(dx: number, dz: number): void; useSuper(dx: number, dz: number): void }
    controls: Controls
    /** Look of each fighter, by fighter id. */
    looks: Look[]
    /** HTML layer over the canvas for floating damage numbers. */
    overlay?: HTMLElement
    onHud?: (hud: Hud) => void
    onPower?: (power: Power) => void
  }

  let { world, match, actions, controls, looks, overlay, onHud, onPower }: Props = $props()
  /** The fighter this device controls. */
  const me = untrack(() => world.playerId)

  const SHOT_COLORS: Record<string, string> = {
    blaze: '#ff7a1a',
    rocko: '#e0b07a',
    turbo: '#39c6ff',
    frosty: '#9fe4ff',
    luna: '#ffd23f',
    pixel: '#39ff88',
    coco: '#b07a3c',
    sparky: '#7ff0ff',
    clank: '#e8edf5',
    kira: '#ff4f9a',
  }

  const scenery = buildArena(CANYON)
  const HYPER_COLOR = '#b64dff'
  const haloGeometry = new THREE.SphereGeometry(1.3, 24, 16)
  const haloMaterial = new THREE.MeshBasicMaterial({
    color: HYPER_COLOR,
    transparent: true,
    opacity: 0.3,
    blending: THREE.AdditiveBlending,
    depthWrite: false,
  })
  const cover = ['walls', 'bushes'].map((name) => scenery.getObjectByName(name)!)
  let coverGoneAt: number | null = null

  /** Overtime: walls and cacti burst into pieces, then sink away. */
  function breakCover() {
    coverGoneAt = time
    for (const w of CANYON.walls) {
      for (let i = 0; i < Math.ceil(w.w * w.d); i++) {
        const x = w.x + (Math.random() - 0.5) * w.w
        const z = w.z + (Math.random() - 0.5) * w.d
        particles.burst({ color: '#b5653a', at: at(x, 1, z), count: 4, speed: 4, up: 6, gravity: 14, life: 1.2, size: 0.16, endSize: 0.08, chunky: true })
      }
      particles.burst({ color: '#e8d2a8', at: at(w.x, 0.5, w.z), count: 8, speed: 2.5, up: 1, life: 0.9, size: 0.5, endSize: 1.2 })
    }
    for (const b of CANYON.bushes) {
      particles.burst({ color: '#4cbf4f', at: at(b.x, 0.8, b.z), count: 14, speed: 4, up: 5, gravity: 12, life: 1, size: 0.14, endSize: 0.06, chunky: true })
    }
  }

  function sinkCover() {
    if (coverGoneAt === null) return
    const t = Math.min(1, (time - coverGoneAt) / 0.5)
    for (const group of cover) {
      group.scale.y = Math.max(0.01, 1 - t)
      group.visible = t < 1
    }
  }

  // One world per arena visit: fighter and dummy views are built once.
  interface FighterView {
    rig: Rig
    bar: HealthBar
    /** Purple halo while hypercharged. */
    halo: THREE.Mesh
    color: string
    core: THREE.MeshBasicMaterial
    glow: THREE.MeshBasicMaterial
    lastX: number
    lastZ: number
    runTime: number
    lastShotAt: number
    knockedAt: number | null
    hidden: boolean
  }

  const views: FighterView[] = untrack(() =>
    world.fighters.map((f) => {
      const look = looks[f.id] ?? looks[0]
      const rig = buildFighter(look.fighterId, look.skinId)
      // Mine green, teammates blue, enemies red.
      const barColor = f.id === me ? '#4cd964' : world.enemies(world.player, f) ? '#ff3b30' : '#4aa8ff'
      const bar = buildHealthBar(2.9, barColor)
      // Training has only the player: no bar over it.
      bar.group.visible = world.fighters.length > 1
      rig.root.add(bar.group)
      const halo = new THREE.Mesh(haloGeometry, haloMaterial)
      halo.position.y = 1.1
      halo.visible = false
      rig.root.add(halo)
      const color = SHOT_COLORS[look.fighterId] ?? parseLookSkin(look.skinId)?.main ?? '#ffd23f'
      const core = new THREE.MeshBasicMaterial({ color: new THREE.Color(color).lerp(new THREE.Color('#ffffff'), 0.35) })
      const glow = new THREE.MeshBasicMaterial({
        color,
        transparent: true,
        opacity: 0.35,
        blending: THREE.AdditiveBlending,
        depthWrite: false,
      })
      return { rig, bar, halo, color, core, glow, lastX: f.x, lastZ: f.z, runTime: 0, lastShotAt: -1, knockedAt: null, hidden: false }
    }),
  )
  // The player's Super meter: a thin yellow bar under its health bar.
  const superBar = buildHealthBar(2.62, '#ffd23f')
  superBar.group.scale.set(1, 0.6, 1)
  views[me].rig.root.add(superBar.group)
  const fighterGroup = new THREE.Group()
  views.forEach((v) => fighterGroup.add(v.rig.root))
  $effect(() => () => views.forEach((v) => disposeRig(v.rig)))

  // Shots: a fixed pool of glowing balls, reused every frame and coloured by who fired them.
  const shotPool = new THREE.Group()
  const shotGeometry = new THREE.SphereGeometry(SHOT_RADIUS, 12, 8)
  const glowGeometry = new THREE.SphereGeometry(SHOT_RADIUS * 2, 12, 8)
  const shotMeshes = Array.from({ length: 96 }, () => {
    const ball = new THREE.Mesh(shotGeometry, views[me].core)
    ball.add(new THREE.Mesh(glowGeometry, views[me].glow))
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
  const playerAttack = untrack(() => world.player.type.attack)
  // Throwers see where their shot will land.
  const aimRing = new THREE.Mesh(
    new THREE.RingGeometry(playerAttack.blast * 0.85, playerAttack.blast, 32).rotateX(-Math.PI / 2),
    new THREE.MeshBasicMaterial({ color: '#ffffff', transparent: true, opacity: 0.6, depthWrite: false }),
  )
  aimRing.visible = false

  function aimLength(aim: Vec2): number {
    if (!playerAttack.lob) return playerAttack.range
    const length = Math.hypot(aim.x, aim.z)
    return Math.max(1.5, Math.min(playerAttack.range, length <= 1 ? length * playerAttack.range : length))
  }

  const particles = new Particles()

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

  function showDamage(x: number, z: number, damage: number, mine: boolean) {
    if (!overlay) return
    const el = document.createElement('div')
    el.className = mine ? 'damage mine' : 'damage'
    el.textContent = String(damage)
    overlay.appendChild(el)
    floaters.push({ el, at: new THREE.Vector3(x + (Math.random() - 0.5) * 0.6, 2.6, z), age: 0 })
  }

  function at(x: number, y: number, z: number) {
    return new THREE.Vector3(x, y, z)
  }

  function sparks(color: string, x: number, z: number) {
    particles.burst({ color, at: at(x, 1.2, z), count: 10, speed: 5, up: 3, gravity: 10, life: 0.4, size: 0.12 })
    particles.burst({ color: '#fff3a0', at: at(x, 1.2, z), count: 5, speed: 3, up: 2, life: 0.25, size: 0.1 })
  }

  function handle(e: WorldEvent) {
    if (e.type === 'fire') {
      const v = views[e.by]
      v.lastShotAt = time
      if (v.hidden) return
      particles.burst({ color: v.color, at: at(e.x, 0.8, e.z), count: 5, speed: 1.5, life: 0.12, size: 0.3, endSize: 0.6 })
      particles.burst({ color: '#ffffff', at: at(e.x, 0.8, e.z), count: 2, speed: 0.5, life: 0.08, size: 0.25, endSize: 0.5 })
    } else if (e.type === 'hit') {
      dummies[e.dummyId].flashUntil = time + 0.12
      sparks(views[me].color, e.x, e.z)
      showDamage(e.x, e.z, e.damage, false)
    } else if (e.type === 'hurt') {
      sparks(views[e.by]?.color ?? '#ffffff', e.x, e.z)
      if (e.fighterId === me || e.by === me) showDamage(e.x, e.z, e.damage, e.fighterId === me)
    } else if (e.type === 'knockout') {
      const v = views[e.fighterId]
      v.knockedAt = time
      particles.burst({ color: v.color, at: at(e.x, 1.2, e.z), count: 14, speed: 4, up: 6, gravity: 14, life: 1.1, size: 0.14, endSize: 0.06, chunky: true })
      particles.burst({ color: '#ffffff', at: at(e.x, 0.8, e.z), count: 12, speed: 2.5, up: 1.5, life: 0.8, size: 0.35, endSize: 0.9 })
    } else if (e.type === 'explode') {
      const color = views[e.by]?.color ?? '#ffb000'
      const count = Math.round(8 + e.radius * 8)
      particles.burst({ color, at: at(e.x, 0.5, e.z), count, speed: e.radius * 4, up: 3, gravity: 10, life: 0.6, size: 0.25, endSize: 0.1, chunky: true })
      particles.burst({ color: '#fff3a0', at: at(e.x, 0.6, e.z), count: 6, speed: e.radius * 2, up: 1, life: 0.35, size: 0.6, endSize: 1.4 })
      particles.burst({ color: '#e8d2a8', at: at(e.x, 0.3, e.z), count: 8, speed: e.radius * 2.5, up: 0.6, life: 0.8, size: 0.4, endSize: 1 })
    } else if (e.type === 'blocked') {
      const color = views[e.owner]?.color ?? '#ffffff'
      particles.burst({ color, at: at(e.x, 0.8, e.z), count: 6, speed: 3, up: 2, gravity: 8, life: 0.3, size: 0.1 })
      particles.burst({ color: '#e8d2a8', at: at(e.x, 0.6, e.z), count: 3, speed: 0.8, up: 0.5, life: 0.4, size: 0.15, endSize: 0.4 })
    } else if (e.type === 'break') {
      dummies[e.dummyId].rig.root.visible = false
      particles.burst({ color: '#e8c26a', at: at(e.x, 1.2, e.z), count: 16, speed: 4, up: 6, gravity: 14, life: 1.3, size: 0.13, endSize: 0.08, chunky: true })
      particles.burst({ color: '#8a5a2b', at: at(e.x, 0.6, e.z), count: 6, speed: 3, up: 5, gravity: 14, life: 1.3, size: 0.1, endSize: 0.06, chunky: true })
      particles.burst({ color: '#e8d2a8', at: at(e.x, 0.4, e.z), count: 10, speed: 2, up: 0.8, life: 0.7, size: 0.3, endSize: 0.8 })
    } else if (e.type === 'respawn') {
      const d = dummies[e.dummyId]
      d.rig.root.visible = true
      d.spawnedAt = time
      const w = world.dummies[e.dummyId]
      particles.burst({ color: '#ffffff', at: at(w.x, 0.3, w.z), count: 10, speed: 2.5, up: 1, life: 0.5, size: 0.2, endSize: 0.5 })
    } else if (e.type === 'coverGone') {
      breakCover()
    } else if (e.type === 'super') {
      const v = views[e.by]
      v.lastShotAt = time
      const color = e.hyper ? HYPER_COLOR : v.color
      const ahead = at(e.x + e.dx * 0.9, 0.9, e.z + e.dz * 0.9)
      particles.burst({ color, at: ahead, count: 14, speed: 5, up: 2, life: 0.35, size: 0.35, endSize: 0.8 })
      particles.burst({ color: '#ffffff', at: ahead, count: 6, speed: 2, life: 0.2, size: 0.5, endSize: 1.2 })
    } else if (e.type === 'hypercharge') {
      const f = world.fighters[e.fighterId]
      particles.burst({ color: HYPER_COLOR, at: at(f.x, 1, f.z), count: 24, speed: 6, up: 4, gravity: 6, life: 0.8, size: 0.25, endSize: 0.05 })
      particles.burst({ color: '#ffffff', at: at(f.x, 1, f.z), count: 8, speed: 3, up: 2, life: 0.5, size: 0.5, endSize: 1.4 })
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
  let lastHud = ''

  function pointerAim(): Vec2 | null {
    if (!controls.pointer || !camera) return null
    raycaster.setFromCamera(new THREE.Vector2(controls.pointer.x, controls.pointer.y), camera)
    if (!raycaster.ray.intersectPlane(groundPlane, hit)) return null
    return { x: hit.x - world.player.x, z: hit.z - world.player.z }
  }

  const canAct = () => !world.player.out && (!match || match.canAct)

  function fire(dir: Vec2) {
    if (!canAct()) return
    if (actions) actions.fire(dir.x, dir.z)
    else world.fire(dir.x, dir.z)
  }

  /** Nearest thing worth shooting: a visible enemy in a match, a dummy in training. */
  function nearestTarget(): { x: number; z: number } | undefined {
    const p = world.player
    const bots = world.fighters.filter((f) => world.enemies(p, f) && world.canSee(p, f, SHOT_RANGE * 1.5))
    const candidates: { x: number; z: number }[] = bots.length ? bots : (world.nearestDummy() ? [world.nearestDummy()!] : [])
    return candidates.sort((a, b) => Math.hypot(a.x - p.x, a.z - p.z) - Math.hypot(b.x - p.x, b.z - p.z))[0]
  }

  /** Towards the nearest target, or the way the player faces. */
  function autoAim(): Vec2 {
    const target = nearestTarget()
    const p = world.player
    return target ? { x: target.x - p.x, z: target.z - p.z } : { x: Math.sin(p.facing), z: Math.cos(p.facing) }
  }

  function applyControls(dt: number) {
    const keys = keyboardDirection(controls.keys)
    const mx = keys.x + controls.moveStick.x
    const mz = keys.z + controls.moveStick.z
    if (canAct() && Math.hypot(mx, mz) > 0.05) world.move(mx, mz, dt)

    const stickAim = controls.aimStick
    const aim = stickAim ?? pointerAim()
    if (controls.mouseDown && aim) fire(aim)
    if (controls.fireDir) {
      fire(controls.fireDir)
      controls.fireDir = null
    }
    if (controls.tapFire) {
      fire(autoAim())
      controls.tapFire = false
    }
    if (controls.superAim || controls.superAuto) {
      const dir = (controls.superAim && aim) || autoAim()
      if (canAct()) {
        if (actions) actions.useSuper(dir.x, dir.z)
        else world.useSuper(world.player, dir.x, dir.z)
      }
      controls.superAim = false
      controls.superAuto = false
    }

    aimLine.visible = canAct() && !!aim && (stickAim !== null || controls.pointer !== null)
    aimRing.visible = aimLine.visible && playerAttack.lob
    if (aim) {
      const length = aimLength(aim)
      const angle = Math.atan2(aim.x, aim.z)
      aimLine.position.set(world.player.x, 0, world.player.z)
      aimLine.rotation.y = angle
      aimLine.scale.z = length / SHOT_RANGE
      aimRing.position.set(world.player.x + Math.sin(angle) * length, 0.05, world.player.z + Math.cos(angle) * length)
    }
  }

  function updateFighters(dt: number) {
    const p = world.player
    for (const f of world.fighters) {
      const v = views[f.id]
      const moved = Math.hypot(f.x - v.lastX, f.z - v.lastZ) > 0.002
      v.lastX = f.x
      v.lastZ = f.z
      v.runTime = moved ? v.runTime + dt : 0

      if (v.knockedAt !== null) {
        // Knock-out: spin, shrink, then gone.
        const t = (time - v.knockedAt) / 0.45
        v.rig.root.visible = t < 1
        v.rig.root.rotation.y += dt * 20
        v.rig.root.scale.setScalar(Math.max(0.01, 1 - t))
        continue
      }

      // Enemies in a bush are invisible unless the player is close; the player is see-through.
      const inBush = world.inBush(f)
      const hidden = world.enemies(p, f) && inBush && Math.hypot(f.x - p.x, f.z - p.z) > BUSH_SIGHT
      v.hidden = hidden
      v.rig.root.visible = !hidden
      if (f.id === me && inBush !== wasInBush) {
        setRigOpacity(v.rig, inBush ? 0.35 : 1)
        wasInBush = inBush
      }

      animateFighter(v.rig, time + f.id)
      const hyper = world.isHyper(f)
      v.halo.visible = hyper
      if (hyper) v.halo.scale.setScalar(1 + Math.sin(time * 12) * 0.08)
      const recoil = Math.max(0, 1 - (time - v.lastShotAt) / 0.15)
      const hop = moved ? Math.abs(Math.sin(v.runTime * 13)) * 0.18 : 0
      v.rig.root.position.set(f.x - Math.sin(f.facing) * recoil * 0.15, hop, f.z - Math.cos(f.facing) * recoil * 0.15)
      v.rig.root.rotation.y = f.facing
      v.rig.body.rotation.x = moved ? 0.22 : -recoil * 0.25
      setBarHealth(v.bar, f.health / f.maxHealth)
      // The bar hangs on the turning fighter: undo its turn so the bar faces the camera.
      if (camera) v.bar.group.quaternion.copy(v.rig.root.quaternion).invert().multiply(camera.quaternion)
      if (f.id === me) {
        setBarHealth(superBar, f.superCharge)
        superBar.group.quaternion.copy(v.bar.group.quaternion)
      }

      if (moved && !inBush && !hidden) {
        if (f.dash) {
          particles.burst({ color: v.color, at: at(f.x, 0.8, f.z), count: 2, speed: 1, up: 0.5, life: 0.35, size: 0.35, endSize: 0.1 })
        }
        dustTimer -= dt / world.fighters.length
        if (dustTimer <= 0) {
          dustTimer = 0.09
          particles.burst({
            color: '#e8d2a8',
            at: at(f.x - Math.sin(f.facing) * 0.3, 0.1, f.z - Math.cos(f.facing) * 0.3),
            count: 1,
            speed: 0.5,
            up: 0.8,
            life: 0.5,
            size: 0.15,
            endSize: 0.45,
          })
        }
      }
    }
  }

  let lastPower = ''

  function reportPower() {
    if (!onPower) return
    const p = world.player
    const power: Power = {
      // Steps of 5% keep Svelte updates rare.
      superCharge: Math.floor(p.superCharge * 20) / 20,
      hyperReady: world.hyperReady(p),
      hyper: world.isHyper(p),
    }
    const key = JSON.stringify(power)
    if (key !== lastPower) {
      lastPower = key
      onPower(power)
    }
  }

  function reportHud() {
    if (!match || !onHud) return
    const hud: Hud = {
      phase: match.phase,
      countdown: Math.ceil(match.countdown),
      timeLeft: Math.ceil(match.timeLeft),
      overtime: match.overtime,
      fightersLeft: world.alive().length,
      result: match.result,
    }
    const key = JSON.stringify(hud)
    if (key !== lastHud) {
      lastHud = key
      onHud(hud)
    }
  }

  useTask((dt) => {
    // Long frames (tab switch) would make everything jump.
    dt = Math.min(dt, 1 / 20)
    time += dt
    applyControls(dt)
    if (match) match.update(dt)
    else world.step(dt)
    for (const e of world.drainEvents()) handle(e)
    sinkCover()
    particles.update(dt)
    updateFighters(dt)
    reportHud()
    reportPower()

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
      if (camera) view.rig.bar.group.quaternion.copy(camera.quaternion)
    })

    shotMeshes.forEach((mesh, i) => {
      const shot = world.shots[i]
      const owner = shot && views[shot.owner]
      // Shots fired from a hidden bush stay hidden too.
      mesh.visible = !!owner && !owner.hidden
      if (!shot || !owner) return
      // Lobbed shots fly in an arc.
      const arc = shot.lob ? Math.sin(Math.PI * Math.min(1, shot.travelled / shot.range)) * (1 + shot.range * 0.25) : 0
      mesh.position.set(shot.x, 0.8 + arc, shot.z)
      mesh.scale.setScalar(shot.radius / SHOT_RADIUS)
      mesh.material = owner.core
      ;(mesh.children[0] as THREE.Mesh).material = owner.glow
    })

    const p = world.player
    // Development only: state for browser checks (the page cannot read JS objects from outside).
    if (import.meta.env.DEV) {
      const el = document.querySelector('.arena')
      el?.setAttribute('data-player', `${p.x.toFixed(2)},${p.z.toFixed(2)}`)
      el?.setAttribute('data-shots', String(world.shots.length))
      el?.setAttribute('data-dummies', world.dummies.map((d) => d.health).join(','))
      el?.setAttribute('data-health', world.fighters.map((f) => Math.round(f.health)).join(','))
      el?.setAttribute('data-positions', world.fighters.map((f) => `${f.x.toFixed(1)}:${f.z.toFixed(1)}`).join(','))
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
<T is={aimRing} />
<T is={dummyGroup} />
<T is={fighterGroup} />
<T is={shotPool} />
<T is={particles.group} />
