<script lang="ts">
  import { Canvas } from '@threlte/core'
  import { untrack } from 'svelte'
  import { PCFShadowMap } from 'three'
  import ArenaScene, { type Hud, type Look } from './ArenaScene.svelte'
  import type { Fighter } from './fighters'
  import { CANYON } from './game/arena'
  import { newControls, stickVector } from './game/controls'
  import { Match } from './game/match'
  import { settingsFrom } from './game/settings'
  import { World } from './game/world'
  import { portrait } from './portraits'

  interface Props {
    mode: 'match' | 'training'
    player: Look
    fighters: Fighter[]
    onLeave: () => void
    onPlayAgain?: () => void
  }

  let { mode, player, fighters, onLeave, onPlayAgain }: Props = $props()

  const STICK_RADIUS = 60
  const TAP_MS = 250

  // A new Arena component is mounted for every match, so these are made once per match.
  const { match, world, looks } = untrack(() => {
    const match = mode === 'match' ? new Match(CANYON, settingsFrom(location.search)) : undefined
    const world = match?.world ?? new World(CANYON)
    const others = fighters.filter((f) => f.id !== player.fighterId).sort(() => Math.random() - 0.5)
    const looks: Look[] = world.fighters.map((f) =>
      f.id === 0 ? player : { fighterId: others[(f.id - 1) % others.length].id, skinId: 'default' },
    )
    return { match, world, looks }
  })
  const controls = newControls()
  const touchDevice = typeof navigator !== 'undefined' && navigator.maxTouchPoints > 0

  let hud = $state<Hud>()
  let showFight = $state(false)
  let showResult = $state(false)

  function onHud(next: Hud) {
    if (hud?.phase === 'countdown' && next.phase === 'fight') {
      showFight = true
      setTimeout(() => (showFight = false), 800)
    }
    if (hud?.phase !== 'over' && next.phase === 'over') setTimeout(() => (showResult = true), 1200)
    hud = next
  }

  const clock = (s: number) => `${Math.floor(s / 60)}:${String(s % 60).padStart(2, '0')}`
  const ordinal = (n: number) => `${n}${n === 1 ? 'st' : n === 2 ? 'nd' : n === 3 ? 'rd' : 'th'}`

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
      <ArenaScene {world} {match} {controls} {looks} {overlay} {onHud} />
    </Canvas>
  </div>
  <div class="floaters" bind:this={overlay} aria-hidden="true"></div>

  {#if hud}
    <div class="hud">
      <div class="timer" class:hurry={hud.timeLeft <= 10}>{clock(hud.timeLeft)}</div>
      <div class="left" aria-label="Fighters left">👤 {hud.fightersLeft}</div>
    </div>
    {#if hud.phase === 'countdown' && hud.countdown > 0}
      {#key hud.countdown}
        <div class="big" role="status">{hud.countdown}</div>
      {/key}
    {:else if showFight}
      <div class="big fight" role="status">FIGHT!</div>
    {/if}
  {/if}

  {#if showResult && hud?.result}
    {@const r = hud.result}
    <div class="result {r.kind}" role="dialog" aria-label="Match result">
      <div class="title">
        {r.kind === 'victory' ? 'VICTORY!' : r.kind === 'defeat' ? 'DEFEAT' : "TIME'S UP"}
      </div>
      <img src={portrait(player.fighterId, player.skinId)} alt="" />
      <div class="detail">
        {#if r.kind === 'victory'}
          Last fighter standing!
        {:else if r.kind === 'defeat'}
          You finished {ordinal(r.place)}
        {:else}
          Nobody won this time
        {/if}
      </div>
      <div class="actions">
        <button class="again" onclick={onPlayAgain}>Play again</button>
        <button class="home" onclick={onLeave}>Home</button>
      </div>
    </div>
  {/if}

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

  .floaters :global(.damage.mine) {
    color: #ff4d4d;
  }

  .hud {
    position: absolute;
    top: max(0.75rem, env(safe-area-inset-top));
    left: 50%;
    transform: translateX(-50%);
    display: flex;
    gap: 0.6rem;
    pointer-events: none;
  }

  .timer,
  .left {
    padding: 0.2em 0.7em;
    border-radius: 0.8rem;
    background: #160f33cc;
    border: 3px solid #000;
    color: white;
    font-weight: 900;
    font-size: clamp(1.2rem, 4vw, 1.7rem);
    font-variant-numeric: tabular-nums;
  }

  .timer.hurry {
    color: #ff4d4d;
    animation: pulse 1s infinite;
  }

  @keyframes pulse {
    50% {
      transform: scale(1.12);
    }
  }

  .big {
    position: absolute;
    left: 50%;
    top: 42%;
    transform: translate(-50%, -50%);
    font-size: clamp(4rem, 18vw, 9rem);
    font-weight: 900;
    font-style: italic;
    color: #ffd23f;
    -webkit-text-stroke: 0.05em #160f33;
    paint-order: stroke fill;
    text-shadow: 0 0.06em 0 #160f33;
    pointer-events: none;
    animation: count 0.9s ease-out both;
  }

  .big.fight {
    color: #ff4f9a;
  }

  @keyframes count {
    from {
      transform: translate(-50%, -50%) scale(2.2);
      opacity: 0;
    }
    25% {
      transform: translate(-50%, -50%) scale(1);
      opacity: 1;
    }
  }

  .result {
    position: absolute;
    inset: 0;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    gap: 0.4rem;
    padding: 1rem;
    background: radial-gradient(circle, #3a2a8cdd, #1b1446f2);
    color: white;
    text-align: center;
    animation: fade 0.4s;
  }

  .result.victory {
    background: radial-gradient(circle, #ffb000cc, #7a3a00f2);
  }

  .result.defeat {
    background: radial-gradient(circle, #6a1a2acc, #1b0a14f2);
  }

  @keyframes fade {
    from {
      opacity: 0;
    }
  }

  .result .title {
    font-size: clamp(2.6rem, 11vw, 5rem);
    font-weight: 900;
    font-style: italic;
    color: #ffd23f;
    -webkit-text-stroke: 0.05em #160f33;
    paint-order: stroke fill;
    text-shadow: 0 0.06em 0 #160f33;
    animation: count 0.6s ease-out both;
  }

  .result img {
    width: min(14rem, 38vh);
    aspect-ratio: 1;
  }

  .result .detail {
    font-size: 1.3rem;
    font-weight: 800;
  }

  .actions {
    display: flex;
    gap: 0.8rem;
    margin-top: 0.6rem;
  }

  .actions button {
    padding: 0.5em 1.2em;
    border-radius: 1rem;
    border: 3px solid #000;
    box-shadow: 0 0.3rem 0 #000;
    font: inherit;
    font-size: 1.3rem;
    font-weight: 900;
    cursor: pointer;
    touch-action: manipulation;
  }

  .again {
    background: linear-gradient(#ffe45c, #ffb000);
    color: #160f33;
  }

  .home {
    background: linear-gradient(#4aa8ff, #2f6bff);
    color: white;
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
