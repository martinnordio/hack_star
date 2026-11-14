import { writable } from 'svelte/store'

/** `shown` after the first failed save of this visit, until the player closes the notice. */
export type SaveNotice = 'none' | 'shown' | 'dismissed'

export const saveNotice = writable<SaveNotice>('none')

export function reportSave(ok: boolean): void {
  if (!ok) saveNotice.update((notice) => (notice === 'none' ? 'shown' : notice))
}

export function dismissSaveNotice(): void {
  saveNotice.set('dismissed')
}

/** The browser's storage, or `null` when the browser blocks it (reading `localStorage` can throw). */
export function browserStorage(): Storage | null {
  try {
    const storage = window.localStorage
    const key = 'hack-star.check'
    storage.setItem(key, '1')
    storage.removeItem(key)
    return storage
  } catch {
    return null
  }
}

/** Asks the browser not to delete the saved data when the game has not been opened for a while. */
export function keepSavedData(): void {
  navigator.storage?.persist?.().catch(() => undefined)
}
