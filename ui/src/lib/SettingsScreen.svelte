<script lang="ts">
  import { progress } from './accounts'
  import type { BotLevel } from './game/settings'
  import { BOT_COUNTS, options } from './options'
  import { resetProgress } from './progress'

  let confirming = $state(false)
  let resetDone = $state(false)

  function reset() {
    $progress = resetProgress($progress)
    confirming = false
    resetDone = true
  }

  const LEVELS: { id: BotLevel; name: string; emoji: string; text: string }[] = [
    { id: 'easy', name: 'Easy', emoji: '🙂', text: 'Slow bots that miss a lot' },
    { id: 'medium', name: 'Medium', emoji: '😠', text: 'Quicker bots with better aim' },
    { id: 'hard', name: 'Hard', emoji: '😈', text: 'Fast bots that rarely miss' },
  ]
</script>

<section>
  <h3>Bot level</h3>
  <div class="levels" role="radiogroup" aria-label="Bot level">
    {#each LEVELS as level (level.id)}
      <button
        class="level {level.id}"
        role="radio"
        aria-checked={$options.botLevel === level.id}
        onclick={() => ($options.botLevel = level.id)}
      >
        <span class="emoji">{level.emoji}</span>
        <span class="name">{level.name}</span>
        <span class="text">{level.text}</span>
      </button>
    {/each}
  </div>
</section>

<section>
  <h3>Number of bots</h3>
  <div class="counts" role="radiogroup" aria-label="Number of bots">
    {#each BOT_COUNTS as count (count)}
      <button
        class="count"
        role="radio"
        aria-checked={$options.botCount === count}
        aria-label="{count} {count === 1 ? 'bot' : 'bots'}"
        onclick={() => ($options.botCount = count)}
      >
        {count}
      </button>
    {/each}
  </div>
</section>

<p class="note">Saved on this device. Used in every match (not in Training).</p>

<section class="reset">
  <h3>Start again</h3>
  {#if confirming}
    <p class="warn" role="alert">
      Are you sure? This account gets 0 credits and 0 trophies, fighters are locked again, power
      levels and skins are gone. Hack codes and your created fighter stay.
    </p>
    <div class="row">
      <button class="danger" onclick={reset}>Yes, reset</button>
      <button class="plain" onclick={() => (confirming = false)}>Cancel</button>
    </div>
  {:else}
    <button class="danger" onclick={() => ((confirming = true), (resetDone = false))}>🔄 Reset coins and trophies</button>
    {#if resetDone}<p class="done" role="status">Done: this account starts again.</p>{/if}
  {/if}
</section>

<style>
  section {
    max-width: 40rem;
    margin: 0 auto 1rem;
  }

  h3 {
    margin: 0 0 0.5rem;
    font-size: 1.2rem;
    font-weight: 900;
    color: #ffd23f;
  }

  button {
    font: inherit;
    color: white;
    cursor: pointer;
    border: 3px solid #000;
    background: #160f33cc;
    box-shadow: 0 0.25rem 0 #000;
    touch-action: manipulation;
  }

  button[aria-checked='true'] {
    border-color: #ffd23f;
    box-shadow:
      0 0.25rem 0 #000,
      0 0 0.8rem #ffd23f88;
  }

  .levels {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(10rem, 1fr));
    gap: 0.6rem;
  }

  .level {
    display: grid;
    justify-items: center;
    gap: 0.15rem;
    padding: 0.6rem;
    border-radius: 1rem;
    text-align: center;
  }

  .level[aria-checked='true'].easy {
    background: linear-gradient(#4cd964, #1f9a3a);
  }

  .level[aria-checked='true'].medium {
    background: linear-gradient(#ffb000, #e06a00);
  }

  .level[aria-checked='true'].hard {
    background: linear-gradient(#ff4d4d, #b3122e);
  }

  .emoji {
    font-size: 2rem;
    line-height: 1.1;
  }

  .name {
    font-size: 1.3rem;
    font-weight: 900;
    text-shadow: 0 2px 0 #000;
  }

  .text {
    font-size: 0.9rem;
    font-weight: 700;
    opacity: 0.9;
  }

  .counts {
    display: flex;
    gap: 0.6rem;
  }

  .count {
    flex: 1;
    max-width: 5rem;
    aspect-ratio: 1;
    border-radius: 1rem;
    font-size: 1.8rem;
    font-weight: 900;
    text-shadow: 0 2px 0 #000;
  }

  .count[aria-checked='true'] {
    background: linear-gradient(#4aa8ff, #2f6bff);
  }

  .note {
    max-width: 40rem;
    margin: 0 auto;
    font-weight: 700;
    opacity: 0.8;
  }

  .reset {
    margin-top: 1.5rem;
  }

  .reset .row {
    display: flex;
    gap: 0.6rem;
    flex-wrap: wrap;
  }

  .danger,
  .plain {
    padding: 0.6rem 1.1rem;
    border-radius: 1rem;
    font-weight: 900;
    font-size: 1.1rem;
  }

  .danger {
    background: linear-gradient(#ff4d4d, #b3122e);
  }

  .warn,
  .done {
    margin: 0 0 0.6rem;
    font-weight: 800;
  }

  .warn {
    padding: 0.5rem 0.8rem;
    border-radius: 0.8rem;
    background: #8a1030;
    border: 2px solid #000;
  }
</style>
