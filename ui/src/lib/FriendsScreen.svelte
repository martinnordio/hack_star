<script lang="ts">
  import QRCode from 'qrcode'
  import { onMount, untrack } from 'svelte'
  import type { Fighter } from './fighters'
  import { currentFighter } from './hacks'
  import { powerOf } from './game/economy'
  import { wornSkin } from './game/shop'
  import { codeFrom, createRoom, joinRoom, leaveRoom, room, roomLink, type Member } from './net/room'
  import { portrait } from './portraits'
  import { progress } from './accounts'
  import QrScanner from './QrScanner.svelte'
  import { options } from './options'

  let { fighters, initialCode, onStart }: { fighters: Fighter[]; initialCode?: string; onStart: () => void } = $props()

  const MAX_PLAYERS = 3
  let code = $state(untrack(() => initialCode ?? ''))
  let scanning = $state(false)
  let qr = $state<string>()

  function me(): Member {
    const p = $progress
    const fighter = currentFighter(p, fighters)
    return {
      fighter: fighter.id,
      skin: wornSkin(p, fighter.id),
      power: powerOf(p, fighter.id),
      hyper: p.activeHacks.includes('hypercharge'),
    }
  }

  function join(text: string) {
    code = codeFrom(text)
    if (code.length === 4) joinRoom(code, me())
  }

  onMount(() => {
    if (initialCode) join(initialCode)
  })

  const info = $derived($room?.info ?? null)
  const host = $derived(info?.you === 0)
  const name = (id: string) => fighters.find((f) => f.id === id)?.name ?? id
  const bots = $derived(info ? Math.max(1, $options.botCount + 1 - info.members.length) : 0)

  $effect(() => {
    if (!info) return
    const link = roomLink(location.origin, info.code)
    QRCode.toDataURL(link, { width: 360, margin: 1, errorCorrectionLevel: 'M' }).then((image) => (qr = image))
  })
</script>

{#if !info}
  <div class="start">
    <p class="intro">Play on your own iPads, phones or computers on the same Wi-Fi: you and up to 2 friends on one team against the bots.</p>
    {#if $room?.error}
      <p class="error" role="alert">{$room.error}</p>
    {/if}
    <button class="big create" onclick={() => createRoom(me())}>➕ Create a room</button>
    <div class="join">
      <label for="room-code">Join with a code</label>
      <div class="row">
        <input
          id="room-code"
          bind:value={code}
          maxlength="4"
          autocomplete="off"
          autocapitalize="characters"
          placeholder="ABCD"
          oninput={() => (code = codeFrom(code))}
          onkeydown={(e) => e.key === 'Enter' && join(code)}
        />
        <button class="big" disabled={code.length !== 4} onclick={() => join(code)}>Join</button>
      </div>
      <button class="scan" onclick={() => (scanning = !scanning)}>{scanning ? 'Stop scanning' : '📷 Scan QR'}</button>
      {#if scanning}
        <QrScanner
          onCode={(text) => {
            scanning = false
            join(text)
          }}
        />
      {/if}
    </div>
    {#if $room && !$room.error}
      <p class="wait">Connecting…</p>
    {/if}
  </div>
{:else}
  <div class="lobby">
    <div class="code-box">
      <span class="label">Room code</span>
      <span class="code" aria-label="Room code {info.code.split('').join(' ')}">{info.code}</span>
      {#if qr}<img class="qr" src={qr} alt="QR code to join room {info.code}" />{/if}
      <span class="hint">Friends: tap <strong>Friends</strong> and type the code, or scan the QR code.</span>
    </div>

    <ul class="players">
      {#each { length: MAX_PLAYERS } as _, slot}
        {@const seat = info.members.find((m) => m.slot === slot)}
        <li class:empty={!seat} class:mine={seat?.slot === info.you}>
          {#if seat}
            <img src={portrait(seat.fighter, seat.skin)} alt="" />
            <span class="who">
              <strong>Player {slot + 1}{slot === 0 ? ' 👑' : ''}</strong>
              <span>{name(seat.fighter)} · ⚡ {seat.power}{seat.slot === info.you ? ' · you' : ''}</span>
            </span>
          {:else}
            <span class="who"><strong>Player {slot + 1}</strong><span>Waiting for a friend…</span></span>
          {/if}
        </li>
      {/each}
    </ul>

    {#if $room?.error}
      <p class="error" role="alert">{$room.error}</p>
    {/if}

    {#if host}
      <button class="big start-match" onclick={onStart}>
        ▶ START · {info.members.length} {info.members.length === 1 ? 'player' : 'players'} + {bots} {bots === 1 ? 'bot' : 'bots'}
      </button>
    {:else}
      <p class="wait">Waiting for Player 1 to start…</p>
    {/if}
    <button class="leave" onclick={leaveRoom}>Leave the room</button>
  </div>
{/if}

<style>
  .start,
  .lobby {
    max-width: 40rem;
    margin: 0 auto;
    display: flex;
    flex-direction: column;
    gap: 0.9rem;
    font-weight: 700;
  }

  .intro {
    margin: 0;
    opacity: 0.9;
  }

  .error {
    margin: 0;
    padding: 0.5rem 0.8rem;
    border-radius: 0.8rem;
    background: #8a1030;
    border: 2px solid #000;
  }

  .wait {
    margin: 0;
    text-align: center;
    opacity: 0.85;
  }

  button {
    font: inherit;
    cursor: pointer;
    color: white;
    border: 3px solid #000;
    border-radius: 1rem;
    box-shadow: 0 0.25rem 0 #000;
    touch-action: manipulation;
  }

  button:disabled {
    opacity: 0.5;
    cursor: default;
  }

  .big {
    padding: 0.6rem 1.2rem;
    font-size: 1.3rem;
    font-weight: 900;
    background: linear-gradient(#4aa8ff, #2f6bff);
    text-shadow: 0 2px 0 #000;
  }

  .create,
  .start-match {
    background: linear-gradient(#ffe45c, #ffb000);
    color: #160f33;
    text-shadow: none;
  }

  .join {
    display: flex;
    flex-direction: column;
    gap: 0.5rem;
    padding: 0.8rem;
    border-radius: 1rem;
    background: #160f33cc;
    border: 2px solid #000;
  }

  .row {
    display: flex;
    gap: 0.5rem;
  }

  input {
    flex: 1;
    min-width: 0;
    padding: 0.4rem 0.7rem;
    border-radius: 0.8rem;
    border: 3px solid #000;
    font: inherit;
    font-size: 1.8rem;
    font-weight: 900;
    letter-spacing: 0.3em;
    text-transform: uppercase;
  }

  .scan,
  .leave {
    padding: 0.4rem 1rem;
    background: #3a2a8c;
  }

  .code-box {
    display: grid;
    justify-items: center;
    gap: 0.3rem;
    padding: 0.8rem;
    border-radius: 1rem;
    background: #160f33cc;
    border: 2px solid #000;
    text-align: center;
  }

  .label {
    opacity: 0.8;
  }

  .code {
    font-size: clamp(2.6rem, 12vw, 4rem);
    font-weight: 900;
    letter-spacing: 0.25em;
    color: #ffd23f;
    text-shadow: 0 3px 0 #000;
    line-height: 1;
  }

  .qr {
    width: min(11rem, 40vw);
    aspect-ratio: 1;
    border-radius: 0.5rem;
    background: white;
  }

  .hint {
    font-size: 0.9rem;
    opacity: 0.85;
  }

  .players {
    list-style: none;
    margin: 0;
    padding: 0;
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(11rem, 1fr));
    gap: 0.6rem;
  }

  .players li {
    display: flex;
    align-items: center;
    gap: 0.6rem;
    padding: 0.4rem;
    border-radius: 1rem;
    background: #160f33cc;
    border: 3px solid #000;
  }

  .players li.mine {
    border-color: #ffd23f;
  }

  .players li.empty {
    opacity: 0.6;
    border-style: dashed;
    min-height: 4rem;
  }

  .players img {
    width: 3.6rem;
    height: 3.6rem;
    border-radius: 0.6rem;
    background: #3a2a8c;
  }

  .who {
    display: flex;
    flex-direction: column;
  }

  .who span {
    font-size: 0.9rem;
    opacity: 0.9;
  }
</style>
