import { isQrPassword } from '../hacks'
import { options } from '../options'

/** Turns developer mode on in this browser if `code` is the developer code (a lock for kids, not security). */
export function turnOnDeveloper(code: string): boolean {
  if (!isQrPassword(code.trim())) return false
  options.update((o) => ({ ...o, developer: true }))
  return true
}
