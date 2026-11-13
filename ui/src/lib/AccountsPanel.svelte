<script lang="ts">
  import {
    MAX_ACCOUNTS,
    MAX_NAME,
    accounts,
    addAccount,
    currentAccount,
    renameAccount,
    switchAccount,
    type AccountsChange,
    type NameProblem,
  } from './accounts'
  import { browserLanguage } from './i18n/languages'
  import { totalTrophies } from './progress'

  let { onClose }: { onClose: () => void } = $props()

  const MESSAGES: Record<NameProblem, string> = {
    empty: 'Type a name.',
    long: `At most ${MAX_NAME} characters.`,
    taken: 'That name is already used.',
    full: `You can have up to ${MAX_ACCOUNTS} accounts.`,
  }

  let newName = $state('')
  let renaming = $state<string>()
  let renameText = $state('')
  let error = $state<string>()

  const current = $derived(currentAccount($accounts))

  function apply(change: AccountsChange): boolean {
    if (!change.ok) {
      error = MESSAGES[change.reason]
      return false
    }
    $accounts = change.state
    error = undefined
    return true
  }

  function add() {
    if (apply(addAccount($accounts, newName, browserLanguage(navigator.languages)))) {
      newName = ''
      onClose()
    }
  }

  function pick(id: string) {
    $accounts = switchAccount($accounts, id)
    onClose()
  }

  function startRename(id: string, name: string) {
    renaming = id
    renameText = name
    error = undefined
  }

  function saveRename() {
    if (renaming && apply(renameAccount($accounts, renaming, renameText))) renaming = undefined
  }
</script>

<!-- svelte-ignore a11y_click_events_have_key_events, a11y_no_static_element_interactions -->
<div class="backdrop" onpointerdown={(e) => e.target === e.currentTarget && onClose()}>
  <div class="panel" role="dialog" aria-modal="true" aria-labelledby="accounts-title">
    <header>
      <h2 id="accounts-title">Accounts</h2>
      <button class="close" aria-label="Close" onclick={onClose}>✕</button>
    </header>

    <ul>
      {#each $accounts.accounts as account (account.id)}
        <li class:current={account.id === current.id}>
          {#if renaming === account.id}
            <input
              aria-label="New name"
              bind:value={renameText}
              maxlength={MAX_NAME + 4}
              onkeydown={(e) => e.key === 'Enter' && saveRename()}
            />
            <button class="small ok" onclick={saveRename}>Save</button>
            <button class="small" onclick={() => (renaming = undefined)}>Cancel</button>
          {:else}
            <button class="pick" onclick={() => pick(account.id)}>
              <strong>{account.name}</strong>
              <span>🏆 {totalTrophies(account.progress).toLocaleString()}{account.id === current.id ? ' · playing' : ''}</span>
            </button>
            <button class="small" aria-label="Rename {account.name}" onclick={() => startRename(account.id, account.name)}>✏️</button>
          {/if}
        </li>
      {/each}
    </ul>

    {#if $accounts.accounts.length < MAX_ACCOUNTS}
      <div class="add">
        <label for="new-account">New account</label>
        <div class="row">
          <input
            id="new-account"
            bind:value={newName}
            maxlength={MAX_NAME + 4}
            autocomplete="off"
            placeholder="Name"
            onkeydown={(e) => e.key === 'Enter' && add()}
          />
          <button class="small ok" onclick={add}>➕ Add</button>
        </div>
      </div>
    {:else}
      <p class="full">You can have up to {MAX_ACCOUNTS} accounts.</p>
    {/if}

    {#if error}
      <p class="error" role="alert">{error}</p>
    {/if}
  </div>
</div>

<style>
  .backdrop {
    position: fixed;
    inset: 0;
    z-index: 20;
    display: grid;
    place-items: center;
    padding: 1rem;
    background: #0008;
  }

  .panel {
    width: min(26rem, 100%);
    max-height: 90vh;
    overflow-y: auto;
    padding: 0.9rem;
    border-radius: 1.2rem;
    background: #1b1446;
    border: 3px solid #000;
    box-shadow: 0 0.4rem 0 #000;
    color: white;
    font-weight: 800;
  }

  header {
    display: flex;
    justify-content: space-between;
    align-items: center;
  }

  h2 {
    margin: 0;
    color: #ffd23f;
    font-size: 1.5rem;
    font-weight: 900;
  }

  ul {
    list-style: none;
    margin: 0.7rem 0;
    padding: 0;
    display: grid;
    gap: 0.5rem;
  }

  li {
    display: flex;
    gap: 0.4rem;
    align-items: center;
  }

  button {
    font: inherit;
    color: white;
    cursor: pointer;
    border: 3px solid #000;
    border-radius: 0.8rem;
    background: #3a2a8c;
    box-shadow: 0 0.2rem 0 #000;
    touch-action: manipulation;
  }

  .pick {
    flex: 1;
    display: flex;
    flex-direction: column;
    align-items: flex-start;
    padding: 0.45rem 0.8rem;
    background: #160f33;
    text-align: left;
  }

  .pick strong {
    font-size: 1.15rem;
  }

  .pick span {
    font-size: 0.85rem;
    opacity: 0.85;
  }

  li.current .pick {
    border-color: #ffd23f;
  }

  .small {
    padding: 0.45rem 0.7rem;
  }

  .ok {
    background: linear-gradient(#ffe45c, #ffb000);
    color: #160f33;
  }

  .close {
    padding: 0.2rem 0.6rem;
  }

  input {
    flex: 1;
    min-width: 0;
    padding: 0.45rem 0.6rem;
    border-radius: 0.7rem;
    border: 3px solid #000;
    font: inherit;
  }

  .add {
    display: grid;
    gap: 0.3rem;
  }

  .row {
    display: flex;
    gap: 0.4rem;
  }

  .full {
    margin: 0;
    opacity: 0.85;
  }

  .error {
    margin: 0.5rem 0 0;
    padding: 0.4rem 0.7rem;
    border-radius: 0.7rem;
    background: #8a1030;
    border: 2px solid #000;
  }
</style>
