<script lang="ts">
  import Arena from './lib/Arena.svelte'
  import { loadFighters, type Fighter } from './lib/fighters'
  import FighterDetail from './lib/FighterDetail.svelte'
  import FighterList from './lib/FighterList.svelte'
  import HackScreen from './lib/HackScreen.svelte'
  import { currentFighter, listHacks, type Hack } from './lib/hacks'
  import Home from './lib/Home.svelte'
  import InfoPage from './lib/InfoPage.svelte'
  import Panel from './lib/Panel.svelte'
  import ShopScreen from './lib/ShopScreen.svelte'
  import SettingsScreen from './lib/SettingsScreen.svelte'
  import FriendsScreen from './lib/FriendsScreen.svelte'
  import { leaveRoom } from './lib/net/room'
  import { progress } from './lib/progress'
  import { wornSkin } from './lib/game/shop'

  type Screen = 'home' | 'fighters' | 'fighter' | 'shop' | 'info' | 'hack' | 'settings' | 'friends' | 'match' | 'training'

  // A QR code scanned with the camera app opens the game with `?hack=<CODE>` or `?room=<CODE>`.
  const params = new URLSearchParams(location.search)
  const codeInLink = params.get('hack') ?? undefined
  const roomInLink = params.get('room') ?? undefined
  if (codeInLink || roomInLink) history.replaceState(null, '', location.pathname)
  let linkedCode = $state(codeInLink)

  let screen = $state<Screen>(codeInLink ? 'hack' : roomInLink ? 'friends' : 'home')
  let openFighter = $state<Fighter>()
  let fighters = $state<Fighter[]>()
  let hacks = $state<Hack[]>()
  let error = $state<string>()
  // The entrance plays once per visit, not when coming back to home.
  let entrance = $state(true)
  // Changing it mounts a fresh arena (Play again).
  let matchNumber = $state(0)

  function load() {
    error = undefined
    Promise.all([loadFighters(), listHacks()])
      .then(([fighterList, hackList]) => {
        fighters = fighterList
        hacks = hackList
      })
      .catch(() => (error = 'Cannot reach the Hack star server.'))
  }

  load()
</script>

{#if error}
  <div class="message">
    <p>{error}</p>
    <button onclick={load}>Try again</button>
  </div>
{:else if !fighters || !hacks}
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
{:else if screen === 'match' || screen === 'training'}
  {@const fighter = currentFighter($progress, fighters)}
  {#key `${screen}-${matchNumber}`}
    <Arena
      mode={screen}
      player={{ fighterId: fighter.id, skinId: wornSkin($progress, fighter.id) }}
      {fighters}
      onLeave={() => (screen = 'home')}
      onPlayAgain={() => matchNumber++}
    />
  {/key}
{:else if screen === 'fighters'}
  <Panel title="Fighters" onBack={() => (screen = 'home')}>
    <FighterList
      {fighters}
      onOpen={(id) => {
        openFighter = fighters?.find((f) => f.id === id)
        screen = 'fighter'
      }}
    />
  </Panel>
{:else if screen === 'fighter' && openFighter}
  <Panel title="Fighter" onBack={() => (screen = 'fighters')}>
    <FighterDetail fighter={openFighter} {fighters} onSelected={() => (screen = 'home')} />
  </Panel>
{:else if screen === 'shop'}
  <Panel title="Shop" onBack={() => (screen = 'home')}>
    <ShopScreen {fighters} />
  </Panel>
{:else if screen === 'info'}
  <Panel title="Info" onBack={() => (screen = 'home')}>
    <InfoPage />
  </Panel>
{:else if screen === 'settings'}
  <Panel title="Settings" onBack={() => (screen = 'home')}>
    <SettingsScreen />
  </Panel>
{:else if screen === 'friends'}
  <Panel
    title="Play with friends"
    onBack={() => {
      leaveRoom()
      screen = 'home'
    }}
  >
    <FriendsScreen {fighters} initialCode={roomInLink} onStart={() => {}} />
  </Panel>
{:else if screen === 'hack'}
  <Panel
    title="Hack"
    onBack={() => {
      linkedCode = undefined
      screen = 'home'
    }}
  >
    <HackScreen {hacks} initialCode={linkedCode} />
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
