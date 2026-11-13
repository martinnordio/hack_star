<script lang="ts">
  import type { Snippet } from 'svelte'
  import { t } from './i18n'

  let { title, onBack, children }: { title: string; onBack: () => void; children: Snippet } = $props()
</script>

<section class="panel">
  <header>
    <button class="back" onclick={onBack} aria-label={$t('common.backHome')}>◀</button>
    <h2>{title}</h2>
  </header>
  <div class="content">
    {@render children()}
  </div>
</section>

<style>
  .panel {
    position: fixed;
    inset: 0;
    display: flex;
    flex-direction: column;
    background: radial-gradient(ellipse at 50% 0%, #4b36c9, #1b1446 70%);
    color: white;
  }

  header {
    display: flex;
    align-items: center;
    gap: 0.8rem;
    padding: max(0.75rem, env(safe-area-inset-top)) max(0.9rem, env(safe-area-inset-right)) 0.6rem
      max(0.9rem, env(safe-area-inset-left));
  }

  h2 {
    margin: 0;
    font-size: clamp(1.4rem, 5vw, 2.2rem);
    font-weight: 900;
    font-style: italic;
    color: #ffd23f;
    -webkit-text-stroke: 0.06em #160f33;
    paint-order: stroke fill;
    text-shadow: 0 0.08em 0 #160f33;
  }

  .back {
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

  .back:active {
    transform: translateY(0.15rem);
    box-shadow: 0 0.1rem 0 #000;
  }

  .content {
    flex: 1;
    min-height: 0;
    overflow-y: auto;
    -webkit-overflow-scrolling: touch;
    padding: 0 max(0.9rem, env(safe-area-inset-right)) max(1rem, env(safe-area-inset-bottom))
      max(0.9rem, env(safe-area-inset-left));
  }
</style>
