import { describe, expect, it } from 'vitest'
import { translate } from './i18n'
import { VOCABULARY } from './vocabulary'

const english = VOCABULARY.map(({ word, meaning }) => ({ word: translate('en', word), meaning: translate('en', meaning) }))

describe('vocabulary', () => {
  it('has at least the 24 words of the spec, each with a meaning', () => {
    expect(english.length).toBeGreaterThanOrEqual(24)
    for (const { word, meaning } of english) {
      expect(word.trim()).not.toBe('')
      expect(meaning.trim().length).toBeGreaterThan(5)
    }
  })

  it('has no duplicate words', () => {
    const words = english.map((w) => w.word.toLowerCase())
    expect(new Set(words).size).toBe(words.length)
  })
})
