import { describe, expect, it } from 'vitest'
import {
  canAddCreatedFighter,
  CREATED_ID,
  createdFighter,
  lookSkin,
  MAX_CREATED_FIGHTERS,
  nextCreatedFighterId,
  parseLookSkin,
  saveCreated,
  withCreated,
} from './created'
import type { Fighter } from './fighters'
import { unlock } from './game/economy'
import { wornSkin } from './game/shop'
import { currentFighter, isUnlocked, withHack } from './hacks'
import { defaultProgress, TEMPORARY_HACK_SECONDS, type CreatedLook } from './progress'

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

  it('creating is free; it joins the fighter list and is usable immediately', () => {
    const result = saveCreated({ ...defaultProgress(), credits: 0 }, look)
    expect(result.ok).toBe(true)
    if (!result.ok) return
    expect(result.cost).toBe(0)
    const list = withCreated([blaze], result.progress)
    expect(list.map((f) => f.id)).toEqual(['blaze', CREATED_ID])
    expect(isUnlocked(result.progress, CREATED_ID)).toBe(true)
    expect(currentFighter({ ...result.progress, selectedFighter: CREATED_ID }, list).id).toBe(CREATED_ID)
    expect(wornSkin(result.progress, CREATED_ID)).toBe(lookSkin(look))
  })

  it('refuses an empty or too long name', () => {
    expect(saveCreated(defaultProgress(), { ...look, name: '  ' })).toEqual({ ok: false, reason: 'name' })
    expect(saveCreated(defaultProgress(), { ...look, name: 'x'.repeat(13) })).toEqual({ ok: false, reason: 'name' })
  })

  it('keeps the first fighter usable and requires CREATOR for extra fighters', () => {
    const extra = createdFighter(look, 'custom-2')
    const p = { ...defaultProgress(), credits: 99_999, createdFighters: [{ id: CREATED_ID, look }, { id: extra.id, look }] }
    expect(unlock(p, extra)).toEqual({ ok: false, reason: 'locked' })
    expect(isUnlocked(p, CREATED_ID)).toBe(true)
    expect(isUnlocked(p, extra.id)).toBe(false)
    expect(isUnlocked(withHack(p, 'unlock_all', TEMPORARY_HACK_SECONDS), extra.id)).toBe(false)
    expect(isUnlocked(withHack(p, 'creator', TEMPORARY_HACK_SECONDS), extra.id)).toBe(true)
  })

  it('falls back to the first fighter when CREATOR expires', () => {
    const extra = createdFighter(look, 'custom-2')
    const now = Date.now()
    const p = withHack({
      ...defaultProgress(),
      createdFighters: [{ id: CREATED_ID, look }, { id: extra.id, look }],
      selectedFighter: extra.id,
    }, 'creator', TEMPORARY_HACK_SECONDS, now)
    expect(currentFighter(p, withCreated([blaze], p)).id).toBe(extra.id)
    const expired = { ...p, hackExpiries: { ...p.hackExpiries, creator: now } }
    expect(isUnlocked(expired, extra.id)).toBe(false)
    expect(currentFighter(expired, withCreated([blaze], expired)).id).toBe('blaze')
  })

  it('CREATOR entered before creating unlocks it at creation', () => {
    const result = saveCreated(withHack(defaultProgress(), 'creator', TEMPORARY_HACK_SECONDS), look)
    expect(result.ok && isUnlocked(result.progress, CREATED_ID)).toBe(true)
  })

  it('changing costs 500 credits and keeps trophies and power', () => {
    const p = { ...defaultProgress(), credits: 600, createdFighters: [{ id: CREATED_ID, look }], trophies: { custom: 70 }, powerLevels: { custom: 3 } }
    const result = saveCreated(p, { ...look, name: 'Zappy 2' }, CREATED_ID)
    expect(result.ok).toBe(true)
    if (!result.ok) return
    expect(result.cost).toBe(500)
    expect(result.progress.credits).toBe(100)
    expect(result.progress.trophies.custom).toBe(70)
    expect(result.progress.powerLevels.custom).toBe(3)
    expect(result.progress.createdFighters[0].look.name).toBe('Zappy 2')
  })

  it('changing without enough credits is refused; INFINITY makes it free', () => {
    const p = { ...defaultProgress(), credits: 120, createdFighters: [{ id: CREATED_ID, look }] }
    expect(saveCreated(p, look, CREATED_ID)).toEqual({ ok: false, reason: 'credits', missing: 380 })
    const free = saveCreated(withHack(p, 'infinite_credits', TEMPORARY_HACK_SECONDS), look, CREATED_ID)
    expect(free.ok && free.progress.credits).toBe(120)
  })

  it('creates the first fighter with INFINITY and zero credits', () => {
    const p = withHack({ ...defaultProgress(), credits: 0 }, 'infinite_credits', TEMPORARY_HACK_SECONDS)
    const result = saveCreated(p, look)
    expect(result.ok && result.cost).toBe(0)
    expect(result.ok && result.progress.createdFighters[0].id).toBe(CREATED_ID)
    expect(result.ok && result.progress.credits).toBe(0)
  })

  it('creates an extra fighter only with CREATOR and charges 500 credits', () => {
    const first = saveCreated({ ...defaultProgress(), credits: 600 }, look)
    expect(first.ok).toBe(true)
    if (!first.ok) return
    expect(saveCreated(first.progress, look)).toEqual({ ok: false, reason: 'creator' })
    expect(canAddCreatedFighter(first.progress)).toBe(false)

    const creator = withHack(first.progress, 'creator', TEMPORARY_HACK_SECONDS)
    expect(canAddCreatedFighter(creator)).toBe(true)
    const extra = saveCreated(creator, { ...look, name: 'Second' })
    expect(extra).toMatchObject({ ok: true, fighterId: 'custom-2', cost: 500 })
    expect(extra.ok && extra.progress.credits).toBe(100)
    expect(extra.ok && extra.progress.createdFighters.map((fighter) => fighter.id)).toEqual(['custom', 'custom-2'])
  })

  it('allocates the first unused stable fighter ID', () => {
    const progress = {
      ...defaultProgress(),
      createdFighters: [{ id: 'custom', look }, { id: 'custom-3', look }],
    }
    expect(nextCreatedFighterId(progress)).toBe('custom-2')
  })

  it('edits the requested extra fighter without changing other fighters or their progress', () => {
    const creator = withHack({
      ...defaultProgress(),
      credits: 700,
      createdFighters: [{ id: 'custom', look }, { id: 'custom-2', look: { ...look, name: 'Second' } }],
      trophies: { custom: 70, 'custom-2': 20 },
      powerLevels: { custom: 3, 'custom-2': 5 },
    }, 'creator', TEMPORARY_HACK_SECONDS)
    const result = saveCreated(creator, { ...look, name: 'Second 2' }, 'custom-2')
    expect(result).toMatchObject({ ok: true, cost: 500, fighterId: 'custom-2' })
    expect(result.ok && result.progress.credits).toBe(200)
    expect(result.ok && result.progress.createdFighters[0].look.name).toBe('Zappy')
    expect(result.ok && result.progress.createdFighters[1].look.name).toBe('Second 2')
    expect(result.ok && result.progress.trophies).toEqual({ custom: 70, 'custom-2': 20 })
    expect(result.ok && result.progress.powerLevels).toEqual({ custom: 3, 'custom-2': 5 })
  })

  it('refuses edits to inactive extras and creation beyond 15 fighters', () => {
    const createdFighters = Array.from({ length: MAX_CREATED_FIGHTERS }, (_, index) => ({
      id: index === 0 ? CREATED_ID : `custom-${index + 1}`,
      look,
    }))
    const full = withHack({ ...defaultProgress(), createdFighters }, 'creator', TEMPORARY_HACK_SECONDS)
    expect(canAddCreatedFighter(full)).toBe(false)
    expect(saveCreated(full, look)).toEqual({ ok: false, reason: 'limit' })

    const expired = { ...full, hackExpiries: { ...full.hackExpiries, creator: Date.now() } }
    expect(saveCreated(expired, look, 'custom-2')).toEqual({ ok: false, reason: 'inactive' })
  })

  it('places created fighters after unlocked catalogue fighters and before locked ones', () => {
    const first = saveCreated(defaultProgress(), look)
    expect(first.ok).toBe(true)
    if (!first.ok) return
    const locked = { ...blaze, id: 'locked', name: 'Locked' }
    const list = withCreated([locked, blaze], first.progress)
    expect(list.map((fighter) => fighter.id)).toEqual(['blaze', 'custom', 'locked'])
  })
})
