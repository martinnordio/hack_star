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
  import WorldScreen from './lib/WorldScreen.svelte'
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
  import CreatorScreen from './lib/CreatorScreen.svelte'
  import { withCreated } from './lib/created'
  import { dismissSaveNotice, saveNotice } from './lib/saving'

  type Screen = 'home' | 'fighters' | 'fighter' | 'creator' | 'shop' | 'info' | 'hack' | 'settings' | 'friends' | 'world' | 'match' | 'training'

  // A QR code scanned with the camera app opens the game with `?hack=<CODE>` or `?room=<CODE>`.
  const params = new URLSearchParams(location.search)
  const codeInLink = params.get('hack') ?? undefined
  const roomInLink = params.get('room') ?? undefined
  if (codeInLink || roomInLink) history.replaceState(null, '', location.pathname)
  let linkedCode = $state(codeInLink)

  let screen = $state<Screen>(codeInLink ? 'hack' : roomInLink ? 'friends' : 'home')
  let openFighterId = $state<string>()
  let creatorFighterId = $state<string>()
  let creatorSkinId = $state<string>()
  let catalogue = $state<Fighter[]>()
  // The server's fighters plus this account's created fighter.
  const fighters = $derived(catalogue ? withCreated(catalogue, $progress) : undefined)
  const openFighter = $derived(fighters?.find((f) => f.id === openFighterId))
  let hacks = $state<Hack[]>()
  let error = $state(false)
  // The entrance plays once per visit, not when coming back to home.
  let entrance = $state(true)
  // Changing it mounts a fresh arena (Play again).
  let matchNumber = $state(0)
  // Play and Training open the world screen first; this is where Start goes afterwards.
  let afterWorld = $state<'match' | 'training'>('match')

  function load() {
    error = false
    Promise.all([loadFighters(), listHacks()])
      .then(([fighterList, hackList]) => {
        catalogue = fighterList
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
      if (next === 'match' || next === 'training') {
        afterWorld = next
        screen = 'world'
      } else screen = next
    }}
  />
{:else if screen === 'world'}
  <Panel title={$t('panel.world')} onBack={() => (screen = 'home')}>
    <WorldScreen
      onStart={() => {
        matchNumber++
        screen = afterWorld
      }}
    />
  </Panel>
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
        openFighterId = id
        screen = 'fighter'
      }}
      onCreate={() => {
        creatorFighterId = undefined
        screen = 'creator'
      }}
    />
  </Panel>
{:else if screen === 'fighter' && openFighter}
  <Panel title={$t('panel.fighter')} onBack={() => (screen = 'fighters')}>
    <FighterDetail
      fighter={openFighter}
      {fighters}
      onSelected={() => (screen = 'home')}
      onChange={(id) => {
        creatorFighterId = id
        creatorSkinId = undefined
        screen = 'creator'
      }}
      onSkin={(id, skinId) => {
        creatorFighterId = id
        creatorSkinId = skinId
        screen = 'creator'
      }}
    />
  </Panel>
{:else if screen === 'creator'}
  <Panel
    title={$t(creatorSkinId ? (creatorSkinId === 'new' ? 'createdSkins.newTitle' : 'createdSkins.editTitle') : creatorFighterId ? 'creator.editTitle' : 'creator.title')}
    onBack={() => (screen = creatorSkinId ? 'fighter' : 'fighters')}
  >
    <CreatorScreen
      fighterId={creatorFighterId}
      skinId={creatorSkinId}
      onDone={() => {
        const backToFighter = creatorSkinId !== undefined
        creatorFighterId = undefined
        creatorSkinId = undefined
        screen = backToFighter ? 'fighter' : 'fighters'
      }}
    />
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

{#if $saveNotice === 'shown'}
  <div class="save-notice" role="alert">
    <span>{$t('saving.blocked')}</span>
    <button onclick={dismissSaveNotice}>{$t('common.close')}</button>
  </div>
{/if}

<style>
  .save-notice {
    position: fixed;
    left: 50%;
    bottom: max(1rem, env(safe-area-inset-bottom));
    z-index: 50;
    transform: translateX(-50%);
    display: flex;
    align-items: center;
    gap: 0.75rem;
    width: min(34rem, calc(100% - 2rem));
    padding: 0.75rem 1rem;
    border-radius: 0.75rem;
    background: #2a1d1d;
    color: white;
    font-weight: 700;
    box-shadow: 0 0.3rem 1rem #0008;
  }

  .save-notice button {
    flex: none;
    padding: 0.4rem 0.8rem;
    border: 0;
    border-radius: 0.5rem;
    background: #ffd23f;
    color: #2a1d1d;
    font: inherit;
    cursor: pointer;
  }

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
