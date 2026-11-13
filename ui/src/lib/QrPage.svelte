<script lang="ts">
  import QRCode from 'qrcode'
  import { hackLink, listHacks, type Hack } from './hacks'
  import { t, tOr } from './i18n'

  let cards = $state<{ hack: Hack; link: string; image: string }[]>()
  let error = $state(false)

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
    .catch(() => (error = true))
</script>

<main>
  <header>
    <h1>{$t('qr.title')}</h1>
    <p>
      {#each $t('qr.intro').split(/\{(\w+)\}/) as part, i}{#if i % 2 === 0}{part}{:else if part === 'button'}<strong>{$t('common.scanQr')}</strong>{:else}<code>{location.origin}</code>{/if}{/each}
    </p>
    {#if ['localhost', '127.0.0.1', '[::1]'].includes(location.hostname)}
      <p class="warning" role="alert">
        {#each $t('qr.localWarning').split(/\{(\w+)\}/) as part, i}{#if i % 2 === 0}{part}{:else if part === 'host'}<code>{location.hostname}</code>{:else if part === 'network'}<strong>Network</strong>{:else if part === 'command'}<code>npm run dev</code>{:else}<code>http://192.168.1.20:5180/?qr</code>{/if}{/each}
      </p>
    {/if}
    <button onclick={() => print()}>{$t('qr.print')}</button>
  </header>

  {#if error}
    <p>{$t('common.serverDown')}</p>
  {:else if !cards}
    <p>{$t('common.loading')}</p>
  {:else}
    <div class="cards">
      {#each cards as { hack, image } (hack.id)}
        {@const name = $tOr(`hack.${hack.id}.name`, hack.name)}
        <figure>
          <img src={image} alt={$t('qr.imageAlt', { name })} />
          <figcaption>
            <strong>{name}</strong>
            <span>{$tOr(`hack.${hack.id}.description`, hack.description)}</span>
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
