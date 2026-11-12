<script lang="ts">
  import { loadFighters, type Fighter } from './lib/fighters'
  import Home from './lib/Home.svelte'
  import Panel from './lib/Panel.svelte'

  type Screen = 'home' | 'fighters' | 'info'

  let screen = $state<Screen>('home')
  let fighters = $state<Fighter[]>()
  let error = $state<string>()
  // The entrance plays once per visit, not when coming back to home.
  let entrance = $state(true)

  function load() {
    error = undefined
    loadFighters()
      .then((list) => (fighters = list))
      .catch(() => (error = 'Cannot reach the Hack star server.'))
  }

  load()
</script>

{#if error}
  <div class="message">
    <p>{error}</p>
    <button onclick={load}>Try again</button>
  </div>
{:else if !fighters}
  <div class="message"><p>Loading…</p></div>
{:else if screen === 'home'}
  <Home
    {fighters}
    {entrance}
    onEntranceEnd={() => (entrance = false)}
    onNavigate={(next) => {
      entrance = false
      screen = next
    }}
  />
{:else if screen === 'fighters'}
  <Panel title="Fighters" onBack={() => (screen = 'home')}>
    <p>Coming in the next step.</p>
  </Panel>
{:else if screen === 'info'}
  <Panel title="Info" onBack={() => (screen = 'home')}>
    <p>Coming in the next step.</p>
  </Panel>
{/if}

<style>
  .message {
    position: fixed;
    inset: 0;
    display: grid;
    place-content: center;
    gap: 1rem;
    text-align: center;
    background: #1b1446;
    color: white;
    font-size: 1.3rem;
    font-weight: 800;
  }

  .message button {
    font: inherit;
    padding: 0.5em 1.2em;
    border-radius: 0.8rem;
    border: 3px solid #000;
    background: #ffd23f;
    cursor: pointer;
  }
</style>
