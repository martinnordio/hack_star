<script lang="ts">
  import { t } from './i18n'
  import { VOCABULARY } from './vocabulary'
</script>

<p class="intro">{$t('info.intro')}</p>

<dl>
  {#each VOCABULARY as { word, meaning }}
    <div class="entry">
      <dt>{$t(word)}</dt>
      <dd>{$t(meaning)}</dd>
    </div>
  {/each}
</dl>

<style>
  .intro {
    max-width: 48rem;
    margin: 0 auto 0.8rem;
    font-weight: 700;
    opacity: 0.85;
  }

  dl {
    max-width: 48rem;
    margin: 0 auto;
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(18rem, 1fr));
    gap: 0.6rem;
  }

  .entry {
    padding: 0.6rem 0.8rem;
    border-radius: 0.8rem;
    background: #160f33cc;
    border: 2px solid #000;
  }

  dt {
    font-weight: 900;
    font-size: 1.1rem;
    color: #ffd23f;
  }

  dd {
    margin: 0.2rem 0 0;
    line-height: 1.35;
  }
</style>
