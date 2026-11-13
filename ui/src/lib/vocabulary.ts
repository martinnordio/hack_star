import type { TextKey } from './i18n/en'

/** Text keys of a word and its meaning. */
export interface Word {
  word: TextKey
  meaning: TextKey
}

const WORDS = [
  'fighter',
  'trophies',
  'prestige',
  'powerLevel',
  'rarity',
  'skin',
  'legendarySkin',
  'credits',
  'shop',
  'skinOfTheDay',
  'upgrade',
  'super',
  'hypercharge',
  'overtime',
  'lastFighterStanding',
  'bush',
  'main',
  'push',
  'camping',
  'tank',
  'sharpshooter',
  'thrower',
  'spreader',
  'speedy',
  'gg',
  'hackCode',
  'room',
  'teammate',
  'superBlast',
  'hyperchargeCode',
  'account',
  'createdFighter',
] as const

export const VOCABULARY: Word[] = WORDS.map(
  (id): Word => ({ word: `vocabulary.${id}.word`, meaning: `vocabulary.${id}.meaning` }),
)
