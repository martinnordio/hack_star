<script lang="ts">
  import { prestigeLevel } from './fighters'

  let { trophies, size = 2.2 }: { trophies: number; size?: number } = $props()

  const level = $derived(prestigeLevel(trophies))
</script>

{#if level > 0}
  <span class="badge" style="--size: {size}em" title="Prestige {level}" aria-label="Prestige {level}">
    <span class="number">{level}</span>
  </span>
{/if}

<style>
  .badge {
    position: relative;
    display: inline-grid;
    place-items: center;
    width: var(--size);
    height: var(--size);
    flex: none;
  }

  /* A diamond, as the kids describe the Prestige badge. */
  .badge::before {
    content: '';
    position: absolute;
    inset: 12%;
    transform: rotate(45deg);
    border-radius: 18%;
    background: linear-gradient(135deg, #fff7b0, #ffd23f 40%, #ff9d00);
    border: 0.12em solid #160f33;
    box-shadow:
      0 0 0.6em #ffd23fcc,
      inset 0 -0.2em 0 #c96f00;
    animation: shine 2.4s ease-in-out infinite;
  }

  .number {
    position: relative;
    font-weight: 900;
    font-size: calc(var(--size) * 0.45);
    color: #160f33;
  }

  @keyframes shine {
    50% {
      box-shadow:
        0 0 1.1em #fff3a0,
        inset 0 -0.2em 0 #c96f00;
    }
  }
</style>
