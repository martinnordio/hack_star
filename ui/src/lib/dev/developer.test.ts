import { get } from 'svelte/store'
import { afterEach, describe, expect, it } from 'vitest'
import { options } from '../options'
import { turnOnDeveloper } from './developer'

describe('developer mode', () => {
  afterEach(() => options.update((o) => ({ ...o, developer: false })))

  it('a wrong code does not turn it on', () => {
    expect(turnOnDeveloper('nope')).toBe(false)
    expect(turnOnDeveloper('')).toBe(false)
    expect(get(options).developer).toBe(false)
  })

  it('the developer code turns it on', () => {
    expect(turnOnDeveloper(' M6D2 ')).toBe(true)
    expect(get(options).developer).toBe(true)
  })
})
