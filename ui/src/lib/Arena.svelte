<script lang="ts">
  import { Canvas } from '@threlte/core'
  import { untrack } from 'svelte'
  import { PCFShadowMap } from 'three'
  import ArenaScene, { type Hud, type Look, type Power } from './ArenaScene.svelte'
  import type { Fighter } from './fighters'
  import { CANYON } from './game/arena'
  import { newControls, stickVector } from './game/controls'
  import { Match, type MatchLike } from './game/match'
  import { SETTINGS, settingsFrom } from './game/settings'
  import { World } from './game/world'
  import { portrait } from './portraits'
  import PrestigeBadge from './PrestigeBadge.svelte'
  import { progress } from './progress'
  import { superHack } from './hacks'
  import { fighterType } from './game/types'
  import { options } from './options'
  import { applyReward, nextPrestigeAt, rewardFor, type Reward } from './game/trophies'
  import type { MatchResult } from './game/match'
  import { Tween } from 'svelte/motion'
  import { cubicOut } from 'svelte/easing'
  import { get } from 'svelte/store'
  import { creditsFor, earn, powerOf, stats } from './game/economy'
  import type { RoomConnection } from './net/room'
  import { GuestMatch, HostMatch, type StartInfo } from './net/shared'

  interface Props {
    mode: 'match' | 'training'
    player: Look
    fighters: Fighter[]
    onLeave: () => void
    onPlayAgain?: () => void
    /** A match with friends: `you` is this device's room slot (0 is the host). */
    shared?: { start: StartInfo; you: number; connection: RoomConnection }
  }

  let { mode, player: chosen, fighters, onLeave, onPlayAgain, shared }: Props = $props()

  const STICK_RADIUS = 60
  const TAP_MS = 250

  function sharedMatch(s: NonNullable<Props['shared']>) {
    const match = s.you === 0 ? new HostMatch(CANYON, s.start, s.connection) : new GuestMatch(CANYON, s.start, s.you, s.connection)
    const looks: Look[] = s.start.fighters.map((f) => ({ fighterId: f.fighter, skinId: f.skin }))
    return { match, world: match.world, looks, player: looks[match.world.playerId] }
  }

  // A new Arena component is mounted for every match, so these are made once per match.
  const { match, world, looks, player } = untrack((): { match?: MatchLike & { stop?: () => void }; world: World; looks: Look[]; player: Look } => {
    if (shared) return sharedMatch(shared)
    const player = chosen
    const playerPower = powerOf(get(progress), player.fighterId)
    const settings = settingsFrom(location.search, SETTINGS, get(options))
    const others = fighters.filter((f) => f.id !== player.fighterId).sort(() => Math.random() - 0.5)
    const count = mode === 'match' ? settings.botCount + 1 : 1
    const ids = Array.from({ length: count }, (_, i) => (i === 0 ? player.fighterId : others[(i - 1) % others.length].id))
    const types = ids.map((id) => fighterType(fighters.find((f) => f.id === id)?.type))
    const match = mode === 'match' ? new Match(CANYON, settings, { playerPower, types }) : undefined
    const world = match?.world ?? new World(CANYON, { stats: [stats(playerPower, SETTINGS, types[0])], types })
    Object.assign(world.player, superHack(get(progress)))
    const looks: Look[] = ids.map((id, i) => (i === 0 ? player : { fighterId: id, skinId: 'default' }))
    return { match, world, looks, player }
  })
  const actions = match instanceof GuestMatch ? match : undefined
  // Leaving early: the host gives friends a draw; a friend hands its fighter to a bot.
  $effect(() => () => match?.stop?.())
  const controls = newControls()
  const touchDevice = typeof navigator !== 'undefined' && navigator.maxTouchPoints > 0

  let hud = $state<Hud>()
  let showFight = $state(false)
  let showOvertime = $state(false)
  let showResult = $state(false)
  let power = $state<Power>()
  let showHyper = $state(false)

  function onPower(next: Power) {
    if (power && !power.hyper && next.hyper) {
      showHyper = true
      setTimeout(() => (showHyper = false), 1200)
    }
    power = next
  }

  function onHud(next: Hud) {
    if (hud?.phase === 'countdown' && next.phase === 'fight') {
      showFight = true
      setTimeout(() => (showFight = false), 800)
    }
    if (hud && !hud.overtime && next.overtime) {
      showOvertime = true
      setTimeout(() => (showOvertime = false), 1600)
    }
    if (hud?.phase !== 'over' && next.phase === 'over') {
      if (match && next.result) saveReward(match, next.result)
      setTimeout(() => (showResult = true), 1200)
    }
    hud = next
  }

  // Saved as soon as the match ends, so leaving before the result screen still keeps it.
  let reward = $state<Reward>()
  let earned = $state(0)
  const shownTrophies = new Tween(0, { duration: 900, easing: cubicOut })

  function saveReward(m: MatchLike, result: MatchResult) {
    const current = get(progress).trophies[player.fighterId] ?? 0
    const r = rewardFor(current, result, m.settings)
    earned = creditsFor(result, m.settings)
    progress.update((p) => earn(applyReward(p, player.fighterId, r), earned))
    reward = r
    shownTrophies.set(r.before, { duration: 0 })
  }

  $effect(() => {
    // Count up once the result screen is on.
    if (showResult && reward) setTimeout(() => (shownTrophies.target = reward!.after), 400)
  })

  const clock = (s: number) => `${Math.floor(s / 60)}:${String(s % 60).padStart(2, '0')}`
  const LEVEL_NAMES = { easy: 'Easy', medium: 'Medium', hard: 'Hard' }
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
      if (e.button === 2) controls.superAim = true
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
      if (e.code === 'KeyE' && !e.repeat) controls.superAim = true
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
      <ArenaScene {world} {match} {actions} {controls} {looks} {overlay} {onHud} {onPower} />
    </Canvas>
  </div>
  <div class="floaters" bind:this={overlay} aria-hidden="true"></div>

  {#if hud}
    <div class="hud">
      <div class="timer" class:overtime={hud.overtime} class:hurry={hud.timeLeft <= 10}>{clock(hud.timeLeft)}</div>
      <div class="left" aria-label="Fighters left">👤 {hud.fightersLeft}</div>
    </div>
    {#if hud.phase === 'countdown' && hud.countdown > 0}
      {#key hud.countdown}
        <div class="big" role="status">{hud.countdown}</div>
      {/key}
      {#if match}
        <div class="level-chip">{LEVEL_NAMES[match.settings.botLevel]} · {match.settings.botCount} {match.settings.botCount === 1 ? 'bot' : 'bots'}</div>
      {/if}
    {:else if showFight}
      <div class="big fight" role="status">FIGHT!</div>
    {:else if showOvertime && hud.phase === 'fight'}
      <div class="big overtime" role="status">OVERTIME!<small>No more walls!</small></div>
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
          {shared ? 'Your team is the last one standing!' : 'Last fighter standing!'}
        {:else if r.kind === 'defeat'}
          {shared ? 'Your team' : 'You'} finished {ordinal(r.place)}
        {:else}
          Nobody won this time
        {/if}
      </div>
      {#if reward}
        {@const shown = Math.round(shownTrophies.current)}
        {@const floor = Math.floor(shown / 1000) * 1000}
        <div class="trophies" aria-label="Trophies">
          <span class="change" class:zero={reward.change === 0} class:minus={reward.change < 0}>
            {reward.change > 0 ? '+' : ''}{reward.change} 🏆
            <span class="credits">+{earned} <span class="coin">C</span></span>
          </span>
          <div class="bar" aria-label="{shown} of {nextPrestigeAt(shown)} trophies to the next Prestige">
            <div class="fill" style="width: {((shown - floor) / 1000) * 100}%"></div>
            <span>🏆 {shown} / {nextPrestigeAt(shown)}</span>
          </div>
        </div>
        {#if reward.prestigeAfter > reward.prestigeBefore && shown >= reward.after}
          <div class="prestige-up" role="status">
            <PrestigeBadge trophies={reward.after} size={2.2} />
            <span>PRESTIGE {reward.prestigeAfter}!</span>
          </div>
        {/if}
      {/if}
      <div class="actions">
        {#if shared}
          <button class="again" onclick={onLeave}>Back to the room</button>
        {:else}
          <button class="again" onclick={onPlayAgain}>Play again</button>
          <button class="home" onclick={onLeave}>Home</button>
        {/if}
      </div>
    </div>
  {/if}

  {#if showHyper && !showResult}
    <div class="big hyper" role="status">HYPERCHARGE!</div>
  {/if}

  {#if power && !showResult}
    {@const full = power.superCharge >= 1}
    <button
      class="super"
      class:full
      class:hyper={full && power.hyperReady}
      style="--fill: {power.superCharge * 360}deg"
      aria-label={full ? (power.hyperReady ? 'Hypercharge ready' : 'Super ready') : `Super ${Math.round(power.superCharge * 100)}%`}
      onclick={() => (controls.superAuto = true)}
    >
      <span class="label">{full && power.hyperReady ? 'HYPER' : 'SUPER'}</span>
      {#if !touchDevice}<span class="key">E</span>{/if}
    </button>
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

  .timer.overtime {
    background: #8a1030dd;
    border-color: #ffd23f;
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

  .big.hyper {
    top: 30%;
    font-size: clamp(2.2rem, 10vw, 5rem);
    color: #d58bff;
    white-space: nowrap;
  }

  .super {
    position: absolute;
    right: max(1.5rem, env(safe-area-inset-right));
    bottom: calc(max(1.5rem, env(safe-area-inset-bottom)) + 140px);
    width: 78px;
    height: 78px;
    padding: 0;
    border-radius: 50%;
    border: 3px solid #000;
    background:
      radial-gradient(circle, #3a2a8c 0 54%, transparent 55%),
      conic-gradient(#ffd23f var(--fill), #160f33aa 0);
    color: #cfc8f0;
    font: inherit;
    font-weight: 900;
    cursor: pointer;
    touch-action: manipulation;
    display: grid;
    place-items: center;
    align-content: center;
    box-shadow: 0 0.25rem 0 #000;
  }

  .super.full {
    background:
      radial-gradient(circle, #ffd23f 0 54%, transparent 55%),
      conic-gradient(#ffd23f 360deg, #ffd23f 0);
    color: #160f33;
    animation: ready 0.9s ease-in-out infinite;
  }

  .super.hyper {
    background:
      radial-gradient(circle, #b64dff 0 54%, transparent 55%),
      conic-gradient(#ffd23f 360deg, #ffd23f 0);
    color: white;
    box-shadow:
      0 0.25rem 0 #000,
      0 0 1.2rem #b64dff;
  }

  .super:active {
    transform: translateY(0.2rem);
  }

  .super .label {
    font-size: 0.85rem;
    letter-spacing: 0.02em;
  }

  .super .key {
    font-size: 0.7rem;
    opacity: 0.75;
  }

  @keyframes ready {
    50% {
      scale: 1.08;
    }
  }

  .level-chip {
    position: absolute;
    left: 50%;
    top: calc(max(0.75rem, env(safe-area-inset-top)) + 3.6rem);
    transform: translateX(-50%);
    padding: 0.25em 0.9em;
    border-radius: 999px;
    background: #160f33cc;
    border: 3px solid #000;
    color: white;
    font-weight: 900;
    font-size: clamp(1rem, 3.5vw, 1.4rem);
    white-space: nowrap;
    pointer-events: none;
  }

  .big.overtime {
    display: flex;
    flex-direction: column;
    align-items: center;
    font-size: clamp(2.6rem, 11vw, 6rem);
    color: #ff4d4d;
    white-space: nowrap;
    animation-duration: 1.6s;
  }

  .big.overtime small {
    font-size: 0.4em;
    color: #ffd23f;
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
    justify-content: safe center;
    gap: 0.4rem;
    padding: max(1rem, env(safe-area-inset-top)) 1rem max(1rem, env(safe-area-inset-bottom));
    overflow-y: auto;
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
    width: min(14rem, 24vh);
    aspect-ratio: 1;
    flex: none;
  }

  @media (max-height: 560px) {
    .result {
      gap: 0.2rem;
    }

    .result .title {
      font-size: 2.4rem;
    }

    .result img {
      /* Phones on their side: the buttons matter more than the picture. */
      display: none;
    }

    .result .detail {
      font-size: 1rem;
    }

    .change,
    .prestige-up {
      font-size: 1.6rem;
    }
  }

  .result .detail {
    font-size: 1.3rem;
    font-weight: 800;
  }

  .trophies {
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 0.4rem;
    width: min(22rem, 90%);
  }

  .change {
    font-size: clamp(1.8rem, 6vw, 2.6rem);
    font-weight: 900;
    color: #ffd23f;
    -webkit-text-stroke: 0.05em #160f33;
    paint-order: stroke fill;
    animation: count 0.6s 0.3s ease-out both;
  }

  .change.zero {
    color: #cfd3dc;
  }

  .change.minus {
    color: #ff4d4d;
  }

  .credits {
    margin-left: 0.6em;
    color: #ffe45c;
  }

  .coin {
    display: inline-grid;
    place-items: center;
    width: 1.1em;
    height: 1.1em;
    border-radius: 50%;
    background: radial-gradient(circle at 35% 30%, #fff3a0, #ffb000);
    color: #7a4a00;
    font-size: 0.7em;
    border: 2px solid #000;
    -webkit-text-stroke: 0;
    vertical-align: middle;
  }

  .bar {
    position: relative;
    width: 100%;
    height: 1.8rem;
    border-radius: 0.9rem;
    border: 3px solid #000;
    background: #160f33;
    overflow: hidden;
  }

  .bar .fill {
    position: absolute;
    inset: 0 auto 0 0;
    background: linear-gradient(#ffe45c, #ffb000);
  }

  .bar span {
    position: relative;
    display: block;
    line-height: 1.6rem;
    font-weight: 900;
    text-shadow: 0 2px 0 #000;
    font-variant-numeric: tabular-nums;
  }

  .prestige-up {
    display: flex;
    align-items: center;
    gap: 0.6rem;
    font-size: clamp(1.8rem, 7vw, 3rem);
    font-weight: 900;
    font-style: italic;
    color: #fff3a0;
    -webkit-text-stroke: 0.05em #160f33;
    paint-order: stroke fill;
    animation: count 0.7s cubic-bezier(0.3, 1.8, 0.5, 1) both;
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
