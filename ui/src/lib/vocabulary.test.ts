import { describe, expect, it } from 'vitest'
import { VOCABULARY } from './vocabulary'

describe('vocabulary', () => {
  it('has at least the 24 words of the spec, each with a meaning', () => {
    expect(VOCABULARY.length).toBeGreaterThanOrEqual(24)
    for (const { word, meaning } of VOCABULARY) {
      expect(word.trim()).not.toBe('')
      expect(meaning.trim().length).toBeGreaterThan(5)
    }
  })

  it('has no duplicate words', () => {
    const words = VOCABULARY.map((w) => w.word.toLowerCase())
    expect(new Set(words).size).toBe(words.length)
  })
})
