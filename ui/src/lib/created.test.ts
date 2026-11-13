import { describe, expect, it } from 'vitest'
import { CREATED_ID, createdFighter, lookSkin, parseLookSkin, saveCreated, withCreated } from './created'
import type { Fighter } from './fighters'
import { unlock } from './game/economy'
import { wornSkin } from './game/shop'
import { currentFighter, isUnlocked, withHack } from './hacks'
import { defaultProgress, type CreatedLook } from './progress'

const look: CreatedLook = { name: 'Zappy', type: 'thrower', main: '#e8322b', second: '#39d353', head: 2, body: 1 }
const blaze = { id: 'blaze', name: 'Blaze', rarity: 'Rare', type: 'spreader', idea: '', skins: [], unlocked_at_start: true } as Fighter

describe('created fighter', () => {
  it('its look travels as a 16-character skin id', () => {
    const skin = lookSkin(look)
    expect(skin).toHaveLength(16)
    const { name: _, ...rest } = look
    expect(parseLookSkin(skin)).toEqual(rest)
    expect(parseLookSkin('default')).toBeNull()
  })

  it('creating is free; it joins the fighter list, locked', () => {
    const result = saveCreated({ ...defaultProgress(), credits: 0 }, look)
    expect(result.ok).toBe(true)
    if (!result.ok) return
    expect(result.cost).toBe(0)
    const list = withCreated([blaze], result.progress)
    expect(list.map((f) => f.id)).toEqual(['blaze', CREATED_ID])
    expect(isUnlocked(result.progress, CREATED_ID)).toBe(false)
    expect(currentFighter({ ...result.progress, selectedFighter: CREATED_ID }, list).id).toBe('blaze')
    expect(wornSkin(result.progress, CREATED_ID)).toBe(lookSkin(look))
  })

  it('refuses an empty or too long name', () => {
    expect(saveCreated(defaultProgress(), { ...look, name: '  ' })).toEqual({ ok: false, reason: 'name' })
    expect(saveCreated(defaultProgress(), { ...look, name: 'x'.repeat(13) })).toEqual({ ok: false, reason: 'name' })
  })

  it('only the CREATOR code unlocks it, not credits or OPENSESAME', () => {
    const p = { ...defaultProgress(), credits: 99_999, createdFighter: look }
    expect(unlock(p, createdFighter(look))).toEqual({ ok: false, reason: 'locked' })
    expect(isUnlocked(withHack(p, 'unlock_all'), CREATED_ID)).toBe(false)
    expect(isUnlocked(withHack(p, 'creator'), CREATED_ID)).toBe(true)
  })

  it('CREATOR entered before creating unlocks it at creation', () => {
    const result = saveCreated(withHack(defaultProgress(), 'creator'), look)
    expect(result.ok && isUnlocked(result.progress, CREATED_ID)).toBe(true)
  })

  it('changing costs 500 credits and keeps trophies and power', () => {
    const p = { ...defaultProgress(), credits: 600, createdFighter: look, trophies: { custom: 70 }, powerLevels: { custom: 3 } }
    const result = saveCreated(p, { ...look, name: 'Zappy 2' })
    expect(result.ok).toBe(true)
    if (!result.ok) return
    expect(result.cost).toBe(500)
    expect(result.progress.credits).toBe(100)
    expect(result.progress.trophies.custom).toBe(70)
    expect(result.progress.powerLevels.custom).toBe(3)
    expect(result.progress.createdFighter?.name).toBe('Zappy 2')
  })

  it('changing without enough credits is refused; INFINITY makes it free', () => {
    const p = { ...defaultProgress(), credits: 120, createdFighter: look }
    expect(saveCreated(p, look)).toEqual({ ok: false, reason: 'credits', missing: 380 })
    const free = saveCreated(withHack(p, 'infinite_credits'), look)
    expect(free.ok && free.progress.credits).toBe(120)
  })
})
