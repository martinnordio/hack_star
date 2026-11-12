<script lang="ts">
  import QRCode from 'qrcode'
  import { hackLink, listHacks, type Hack } from './hacks'

  let cards = $state<{ hack: Hack; link: string; image: string }[]>()
  let error = $state<string>()

  listHacks()
    .then((hacks) =>
      Promise.all(
        hacks.map(async (hack) => {
          const link = hackLink(location.origin, hack.code)
          const image = await QRCode.toDataURL(link, { width: 480, margin: 2, errorCorrectionLevel: 'M' })
          return { hack, link, image }
        }),
      ),
    )
    .then((list) => (cards = list))
    .catch(() => (error = 'Cannot reach the Hack star server.'))
</script>

<main>
  <header>
    <h1>Hack star · QR codes</h1>
    <p>
      Scan one with the game's <strong>Scan QR</strong> button or with the camera app of an iPad or
      phone on the same Wi-Fi. The codes work only with this game address:
      <code>{location.origin}</code>
    </p>
    {#if ['localhost', '127.0.0.1', '[::1]'].includes(location.hostname)}
      <p class="warning" role="alert">
        This page was opened with <code>{location.hostname}</code>, which only works on this computer.
        Open it with the <strong>Network</strong> address that <code>npm run dev</code> prints (for
        example <code>http://192.168.1.20:5180/?qr</code>) so the QR codes work on iPads and phones.
      </p>
    {/if}
    <button onclick={() => print()}>Print</button>
  </header>

  {#if error}
    <p>{error}</p>
  {:else if !cards}
    <p>Loading…</p>
  {:else}
    <div class="cards">
      {#each cards as { hack, image } (hack.id)}
        <figure>
          <img src={image} alt="QR code for {hack.name}" />
          <figcaption>
            <strong>{hack.name}</strong>
            <span>{hack.description}</span>
            <code>{hack.code}</code>
          </figcaption>
        </figure>
      {/each}
    </div>
  {/if}
</main>

<style>
  main {
    max-width: 60rem;
    margin: 0 auto;
    padding: 1rem;
    color: #160f33;
    background: white;
    min-height: 100%;
    overflow-y: auto;
    height: 100%;
    box-sizing: border-box;
    -webkit-user-select: text;
    user-select: text;
  }

  h1 {
    margin: 0 0 0.4rem;
  }

  header p {
    margin: 0 0 0.8rem;
  }

  .warning {
    padding: 0.6rem 0.8rem;
    border-radius: 0.6rem;
    background: #fff1c2;
    border: 2px solid #ffb000;
  }

  button {
    font: inherit;
    font-weight: 800;
    padding: 0.4em 1.2em;
    border-radius: 0.6rem;
    border: 2px solid #160f33;
    background: #ffd23f;
    cursor: pointer;
  }

  .cards {
    margin-top: 1rem;
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(15rem, 1fr));
    gap: 1rem;
  }

  figure {
    margin: 0;
    padding: 0.8rem;
    border: 3px dashed #160f33;
    border-radius: 1rem;
    text-align: center;
    break-inside: avoid;
  }

  img {
    width: 100%;
    max-width: 16rem;
  }

  figcaption {
    display: grid;
    gap: 0.2rem;
  }

  figcaption strong {
    font-size: 1.3rem;
  }

  figcaption code {
    font-size: 1.1rem;
    letter-spacing: 0.1em;
  }

  @media print {
    header p,
    button {
      display: none;
    }

    :global(html),
    :global(body),
    :global(#app),
    main {
      height: auto;
      overflow: visible;
    }
  }
</style>
