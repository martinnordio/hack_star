<script lang="ts">
  import { Canvas } from '@threlte/core'
  import { PCFShadowMap } from 'three'
  import ArenaScene from './ArenaScene.svelte'
  import { CANYON } from './game/arena'
  import { newControls, stickVector } from './game/controls'
  import { World } from './game/world'

  interface Props {
    fighterId: string
    skinId: string
    onLeave: () => void
  }

  let { fighterId, skinId, onLeave }: Props = $props()

  const STICK_RADIUS = 60
  const TAP_MS = 250

  const world = new World(CANYON)
  const controls = newControls()
  const touchDevice = typeof navigator !== 'undefined' && navigator.maxTouchPoints > 0

  interface Stick {
    id: number
    side: 'move' | 'aim'
    startX: number
    startY: number
    x: number
    y: number
    startTime: number
    dragged: boolean
  }

  let sticks = $state<Stick[]>([])
  let root = $state<HTMLDivElement>()
  let overlay = $state<HTMLDivElement>()

  function setPointer(e: PointerEvent) {
    const r = root!.getBoundingClientRect()
    controls.pointer = { x: ((e.clientX - r.left) / r.width) * 2 - 1, y: -((e.clientY - r.top) / r.height) * 2 + 1 }
  }

  function down(e: PointerEvent) {
    if ((e.target as HTMLElement).closest('button')) return
    if (e.pointerType === 'mouse') {
      setPointer(e)
      if (e.button === 0) controls.mouseDown = true
      return
    }
    const r = root!.getBoundingClientRect()
    const side = e.clientX - r.left < r.width / 2 ? 'move' : 'aim'
    if (sticks.some((s) => s.side === side)) return
    try {
      root!.setPointerCapture(e.pointerId)
    } catch {
      // The pointer may already be gone; the stick still works while it stays over the arena.
    }
    sticks.push({ id: e.pointerId, side, startX: e.clientX, startY: e.clientY, x: e.clientX, y: e.clientY, startTime: performance.now(), dragged: false })
  }

  function move(e: PointerEvent) {
    if (e.pointerType === 'mouse') return setPointer(e)
    const stick = sticks.find((s) => s.id === e.pointerId)
    if (!stick) return
    stick.x = e.clientX
    stick.y = e.clientY
    const v = stickVector(stick.x - stick.startX, stick.y - stick.startY, STICK_RADIUS)
    const active = v.x !== 0 || v.z !== 0
    if (stick.side === 'move') {
      controls.moveStick = v
    } else {
      controls.aimStick = active ? v : null
      if (active) stick.dragged = true
    }
  }

  function up(e: PointerEvent) {
    if (e.pointerType === 'mouse') {
      controls.mouseDown = false
      return
    }
    const stick = sticks.find((s) => s.id === e.pointerId)
    if (!stick) return
    if (stick.side === 'move') {
      controls.moveStick = { x: 0, z: 0 }
    } else {
      if (stick.dragged && controls.aimStick) controls.fireDir = controls.aimStick
      else if (performance.now() - stick.startTime < TAP_MS) controls.tapFire = true
      controls.aimStick = null
    }
    sticks = sticks.filter((s) => s !== stick)
  }

  function knob(s: Stick) {
    const dx = s.x - s.startX
    const dy = s.y - s.startY
    const length = Math.hypot(dx, dy)
    const scale = length > STICK_RADIUS ? STICK_RADIUS / length : 1
    return { x: dx * scale, y: dy * scale }
  }

  $effect(() => {
    const keydown = (e: KeyboardEvent) => {
      if (e.code.startsWith('Arrow') || e.code === 'Space') e.preventDefault()
      if (e.code === 'Space') controls.tapFire = true
      controls.keys.add(e.code)
    }
    const keyup = (e: KeyboardEvent) => controls.keys.delete(e.code)
    const blur = () => {
      controls.keys.clear()
      controls.mouseDown = false
    }
    window.addEventListener('keydown', keydown)
    window.addEventListener('keyup', keyup)
    window.addEventListener('blur', blur)
    return () => {
      window.removeEventListener('keydown', keydown)
      window.removeEventListener('keyup', keyup)
      window.removeEventListener('blur', blur)
    }
  })
</script>

<!-- svelte-ignore a11y_no_static_element_interactions -->
<div
  class="arena"
  bind:this={root}
  onpointerdown={down}
  onpointermove={move}
  onpointerup={up}
  onpointercancel={up}
  onpointerleave={(e) => e.pointerType === 'mouse' && (controls.pointer = null)}
  oncontextmenu={(e) => e.preventDefault()}
>
  <div class="scene">
    <Canvas shadows={PCFShadowMap}>
      <ArenaScene {world} {controls} {fighterId} {skinId} {overlay} />
    </Canvas>
  </div>
  <div class="floaters" bind:this={overlay} aria-hidden="true"></div>

  {#if touchDevice && sticks.length === 0}
    <div class="hint move" aria-hidden="true"></div>
    <div class="hint aim" aria-hidden="true"></div>
  {/if}

  {#each sticks as s (s.id)}
    {@const k = knob(s)}
    <div class="base {s.side}" style="left: {s.startX}px; top: {s.startY}px" aria-hidden="true">
      <div class="knob" style="transform: translate({k.x}px, {k.y}px)"></div>
    </div>
  {/each}

  <button class="leave" onclick={onLeave} aria-label="Back to home">◀</button>
</div>

<style>
  .arena {
    position: fixed;
    inset: 0;
    overflow: hidden;
    background: linear-gradient(#7fd0ff, #ffe6b0);
    touch-action: none;
    -webkit-touch-callout: none;
  }

  .scene {
    position: absolute;
    inset: 0;
  }

  .floaters {
    position: absolute;
    inset: 0;
    pointer-events: none;
    overflow: hidden;
  }

  .floaters :global(.damage) {
    position: absolute;
    left: 0;
    top: 0;
    font-weight: 900;
    font-size: 1.6rem;
    color: #fff;
    -webkit-text-stroke: 0.08em #160f33;
    paint-order: stroke fill;
    text-shadow: 0 0.1em 0 #160f33;
    will-change: transform, opacity;
  }

  .base,
  .hint {
    position: absolute;
    width: 120px;
    height: 120px;
    margin: -60px 0 0 -60px;
    border-radius: 50%;
    border: 4px solid #ffffffaa;
    background: #00000033;
    pointer-events: none;
  }

  .base.aim,
  .hint.aim {
    border-color: #ffd23fcc;
  }

  .hint {
    bottom: max(1.5rem, env(safe-area-inset-bottom));
    margin: 0;
    opacity: 0.5;
  }

  .hint.move {
    left: max(1.5rem, env(safe-area-inset-left));
  }

  .hint.aim {
    right: max(1.5rem, env(safe-area-inset-right));
  }

  .knob {
    position: absolute;
    left: 50%;
    top: 50%;
    width: 56px;
    height: 56px;
    margin: -28px 0 0 -28px;
    border-radius: 50%;
    background: radial-gradient(circle at 35% 30%, #ffffff, #c9d1e0);
    border: 3px solid #000;
  }

  .aim .knob {
    background: radial-gradient(circle at 35% 30%, #fff3a0, #ffb000);
  }

  .leave {
    position: absolute;
    top: max(0.75rem, env(safe-area-inset-top));
    left: max(0.9rem, env(safe-area-inset-left));
    width: 3rem;
    height: 3rem;
    border-radius: 0.8rem;
    border: 3px solid #000;
    background: linear-gradient(#4aa8ff, #2f6bff);
    box-shadow: 0 0.25rem 0 #000;
    color: white;
    font-size: 1.3rem;
    cursor: pointer;
    touch-action: manipulation;
  }
</style>
