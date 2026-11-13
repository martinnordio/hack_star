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
  import { leaveRoom, room, type RoomConnection } from './lib/net/room'
  import { startInfo, type StartInfo } from './lib/net/shared'
  import { options } from './lib/options'
  import { SETTINGS, settingsFrom } from './lib/game/settings'
  import { untrack } from 'svelte'
  import { progress } from './lib/accounts'
  import { wornSkin } from './lib/game/shop'
  import { t } from './lib/i18n'

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
  let error = $state(false)
  // The entrance plays once per visit, not when coming back to home.
  let entrance = $state(true)
  // Changing it mounts a fresh arena (Play again).
  let matchNumber = $state(0)

  function load() {
    error = false
    Promise.all([loadFighters(), listHacks()])
      .then(([fighterList, hackList]) => {
        fighters = fighterList
        hacks = hackList
      })
      .catch(() => (error = true))
  }

  load()

  /** The shared match being played with friends (set by the host's start). */
  let shared = $state<{ start: StartInfo; you: number; connection: RoomConnection }>()

  function playShared(start: StartInfo) {
    if (!$room?.info) return
    shared = { start, you: $room.info.you, connection: $room.connection }
    matchNumber++
    screen = 'match'
  }

  function startShared() {
    if (!$room?.info || !fighters) return
    const settings = settingsFrom(location.search, SETTINGS, $options)
    const start = startInfo(settings, $room.info.members, fighters)
    $room.connection.send(start)
    playShared(start)
  }

  // Friends follow the host into the match.
  $effect(() => {
    const connection = $room?.connection
    if (!connection) return
    return connection.on((m) => {
      if (m.type === 'start' && untrack(() => $room?.info?.you) !== 0) playShared(m as unknown as StartInfo)
    })
  })

  function leaveShared() {
    if (shared?.you === 0) shared.connection.send({ type: 'lobby' })
    shared = undefined
    screen = $room?.info || $room?.error ? 'friends' : 'home'
  }
</script>

{#if error}
  <div class="message">
    <p>{$t('common.serverDown')}</p>
    <button onclick={load}>{$t('common.tryAgain')}</button>
  </div>
{:else if !fighters || !hacks}
  <div class="message"><p>{$t('common.loading')}</p></div>
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
      shared={screen === 'match' ? shared : undefined}
      onLeave={() => (shared ? leaveShared() : (screen = 'home'))}
      onPlayAgain={() => matchNumber++}
    />
  {/key}
{:else if screen === 'fighters'}
  <Panel title={$t('panel.fighters')} onBack={() => (screen = 'home')}>
    <FighterList
      {fighters}
      onOpen={(id) => {
        openFighter = fighters?.find((f) => f.id === id)
        screen = 'fighter'
      }}
    />
  </Panel>
{:else if screen === 'fighter' && openFighter}
  <Panel title={$t('panel.fighter')} onBack={() => (screen = 'fighters')}>
    <FighterDetail fighter={openFighter} {fighters} onSelected={() => (screen = 'home')} />
  </Panel>
{:else if screen === 'shop'}
  <Panel title={$t('panel.shop')} onBack={() => (screen = 'home')}>
    <ShopScreen {fighters} />
  </Panel>
{:else if screen === 'info'}
  <Panel title={$t('panel.info')} onBack={() => (screen = 'home')}>
    <InfoPage />
  </Panel>
{:else if screen === 'settings'}
  <Panel title={$t('panel.settings')} onBack={() => (screen = 'home')}>
    <SettingsScreen />
  </Panel>
{:else if screen === 'friends'}
  <Panel
    title={$t('panel.friends')}
    onBack={() => {
      leaveRoom()
      screen = 'home'
    }}
  >
    <FriendsScreen {fighters} initialCode={roomInLink} onStart={startShared} />
  </Panel>
{:else if screen === 'hack'}
  <Panel
    title={$t('panel.hack')}
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
