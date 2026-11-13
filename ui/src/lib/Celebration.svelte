<script lang="ts">
  import { t } from './i18n'

  let { title, subtitle, label }: { title: string; subtitle: string; label?: string } = $props()

  const COLORS = ['#ffd23f', '#ff4f9a', '#39ff88', '#4aa8ff', '#b64dff', '#ff7a1a']
  const pieces = Array.from({ length: 60 }, (_, i) => ({
    color: COLORS[i % COLORS.length],
    x: Math.cos(i * 2.4) * (30 + (i % 7) * 9),
    y: -40 - (i % 9) * 8,
    spin: (i % 2 ? 1 : -1) * (360 + (i % 5) * 180),
    delay: (i % 6) * 0.03,
  }))
</script>

<div class="celebration" role="status">
  {#each pieces as p}
    <span
      class="piece"
      style="--c: {p.color}; --x: {p.x}vw; --y: {p.y}vh; --r: {p.spin}deg; animation-delay: {p.delay}s"
    ></span>
  {/each}
  <div class="banner">
    <div class="hacked">{label ?? $t('celebration.hacked')}</div>
    <div class="title">{title}</div>
    <div class="subtitle">{subtitle}</div>
  </div>
</div>

<style>
  .celebration {
    position: fixed;
    inset: 0;
    display: grid;
    place-items: center;
    pointer-events: none;
    overflow: hidden;
    z-index: 10;
  }

  .piece {
    position: absolute;
    left: 50%;
    top: 55%;
    width: 0.8rem;
    height: 1.2rem;
    border-radius: 2px;
    background: var(--c);
    animation: fly 1.6s cubic-bezier(0.2, 0.7, 0.4, 1) both;
  }

  @keyframes fly {
    from {
      transform: translate(0, 0) rotate(0);
      opacity: 1;
    }
    70% {
      opacity: 1;
    }
    to {
      transform: translate(var(--x), calc(var(--y) + 60vh)) rotate(var(--r));
      opacity: 0;
    }
  }

  .banner {
    text-align: center;
    padding: 1rem 1.6rem;
    border-radius: 1.2rem;
    background: #06210fee;
    border: 4px solid #39ff88;
    box-shadow: 0 0 2rem #39ff88aa;
    animation: pop 0.5s cubic-bezier(0.3, 1.8, 0.5, 1);
  }

  @keyframes pop {
    from {
      transform: scale(0.2) rotate(-8deg);
    }
  }

  .hacked {
    font-family: ui-monospace, 'Cascadia Code', Consolas, monospace;
    font-weight: 900;
    font-size: clamp(1.2rem, 4vw, 1.8rem);
    color: #39ff88;
    letter-spacing: 0.2em;
  }

  .title {
    font-size: clamp(2rem, 8vw, 3.6rem);
    font-weight: 900;
    font-style: italic;
    color: #ffd23f;
    -webkit-text-stroke: 0.05em #000;
    paint-order: stroke fill;
    line-height: 1.1;
  }

  .subtitle {
    margin-top: 0.3rem;
    font-weight: 800;
    color: white;
  }
</style>
