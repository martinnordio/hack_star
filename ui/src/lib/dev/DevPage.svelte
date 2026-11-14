<script lang="ts">
  import { options } from '../options'
  import { turnOnDeveloper } from './developer'
  import MusicSection from './MusicSection.svelte'

  let code = $state('')
  let wrong = $state(false)
</script>

<!-- Developer page (/?dev): English only, reached by its address or from Settings in developer mode. -->
<div class="page">
<main>
  <header>
    <h1>Hack star · developer page</h1>
    <a href="/">← Back to the game</a>
  </header>

  {#if !$options.developer}
    <form class="code" onsubmit={(e) => (e.preventDefault(), (wrong = !turnOnDeveloper(code)))}>
      <label for="dev-code">Developer code</label>
      <input id="dev-code" type="password" autocomplete="off" bind:value={code} oninput={() => (wrong = false)} />
      <button type="submit">Open</button>
    </form>
    {#if wrong}<p class="wrong" role="alert">That is not the developer code.</p>{/if}
    <p class="hint">The code is asked once; this browser then stays in developer mode until it is turned off in Settings.</p>
  {:else}
    <nav aria-label="Sections">
      <a href="#music">Music</a>
    </nav>
    <section id="music">
      <h2>Music</h2>
      <MusicSection />
    </section>
  {/if}
</main>
</div>

<style>
  /* The game's html/body do not scroll, so the page scrolls inside its own full-screen layer. */
  .page {
    position: fixed;
    inset: 0;
    overflow-y: auto;
    background: linear-gradient(#2c1d7a, #1b1446);
    color: white;
    user-select: text;
    -webkit-user-select: text;
  }

  main {
    max-width: 64rem;
    margin: 0 auto;
    padding: 1rem;
    color: white;
    font-family: system-ui, sans-serif;
  }

  header {
    display: flex;
    flex-wrap: wrap;
    align-items: baseline;
    justify-content: space-between;
    gap: 0.5rem;
  }

  h1 {
    margin: 0;
    font-size: 1.6rem;
  }

  h2 {
    color: #ffd23f;
  }

  a {
    color: #ffd23f;
  }

  nav {
    display: flex;
    gap: 1rem;
    margin: 1rem 0;
  }

  .code {
    display: flex;
    flex-wrap: wrap;
    align-items: center;
    gap: 0.5rem;
    margin-top: 2rem;
  }

  input,
  button {
    padding: 0.4rem 0.7rem;
    border-radius: 0.5rem;
    border: 2px solid #000;
    font: inherit;
  }

  button {
    cursor: pointer;
    background: #ffd23f;
  }

  .wrong {
    color: #ff8a8a;
    font-weight: 700;
  }

  .hint {
    opacity: 0.8;
  }
</style>
