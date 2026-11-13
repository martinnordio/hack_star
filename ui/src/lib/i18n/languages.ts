export const LANGUAGES = ['en', 'de', 'gsw', 'es', 'it'] as const
export type Language = (typeof LANGUAGES)[number]

export const LANGUAGE_NAMES: Record<Language, string> = {
  en: 'English',
  de: 'Deutsch',
  gsw: 'Schwiizerdütsch',
  es: 'Español',
  it: 'Italiano',
}

export function isLanguage(value: unknown): value is Language {
  return (LANGUAGES as readonly unknown[]).includes(value)
}

/** The first browser language the game speaks; Swiss browsers (`de-CH`) get Swiss German. */
export function browserLanguage(preferred: readonly string[]): Language {
  for (const tag of preferred) {
    const lower = tag.toLowerCase()
    if (lower === 'gsw' || lower.startsWith('gsw-') || lower === 'de-ch') return 'gsw'
    const base = lower.split('-')[0]
    if (isLanguage(base)) return base
  }
  return 'en'
}
