<script lang="ts">
  import { Canvas } from '@threlte/core'
  import { PCFShadowMap } from 'three'
  import Scene from './lib/Scene.svelte'

  type ServerStatus = 'checking' | 'online' | 'offline'

  let server = $state<ServerStatus>('checking')
  let fps = $state(0)

  $effect(() => {
    fetch('/api/health')
      .then((response) => (server = response.ok ? 'online' : 'offline'))
      .catch(() => (server = 'offline'))
  })

  $effect(() => {
    let frames = 0
    let last = performance.now()
    let id = requestAnimationFrame(function count(now) {
      frames++
      if (now - last >= 1000) {
        fps = Math.round((frames * 1000) / (now - last))
        frames = 0
        last = now
      }
      id = requestAnimationFrame(count)
    })
    return () => cancelAnimationFrame(id)
  })
</script>

<main>
  <div class="scene">
    <Canvas shadows={PCFShadowMap}>
      <Scene />
    </Canvas>
  </div>

  <header class="hud">
    <h1>Hack star</h1>
    <p>
      <span class="dot {server}"></span>
      Server {server} · {fps} FPS
    </p>
  </header>
</main>

<style>
  main {
    position: fixed;
    inset: 0;
    background: radial-gradient(circle at 50% 30%, #3a2a8c, #1b1446);
  }

  .scene {
    position: absolute;
    inset: 0;
    touch-action: none;
  }

  .hud {
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    padding: max(0.75rem, env(safe-area-inset-top)) max(1rem, env(safe-area-inset-right)) 0
      max(1rem, env(safe-area-inset-left));
    display: flex;
    flex-wrap: wrap;
    align-items: center;
    justify-content: space-between;
    gap: 0.5rem;
    pointer-events: none;
    color: white;
    text-shadow: 0 2px 0 #000a;
  }

  h1 {
    margin: 0;
    font-size: clamp(1.5rem, 5vw, 2.75rem);
    font-weight: 900;
    letter-spacing: 0.04em;
    color: #ffd23f;
    -webkit-text-stroke: 2px #1b1446;
  }

  p {
    margin: 0;
    font-size: clamp(0.8rem, 2.5vw, 1rem);
    font-weight: 700;
  }

  .dot {
    display: inline-block;
    width: 0.6em;
    height: 0.6em;
    border-radius: 50%;
    background: #aaa;
  }
  .dot.online {
    background: #4cd964;
  }
  .dot.offline {
    background: #ff3b30;
  }
</style>
