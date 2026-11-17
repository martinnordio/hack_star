import { describe, expect, it } from 'vitest'
import { THEME_IDS, WORLDS, WORLD_SIZES, arenaFor } from '../game/worlds'
import { buildArena } from './arena3d'
import { THEMES } from './themes'

const HEX = /^#[0-9a-f]{6}$/i

describe('themes', () => {
  it('has one look per theme id', () => {
    expect(Object.keys(THEMES).sort()).toEqual([...THEME_IDS].sort())
  })

  it('uses hex colours everywhere', () => {
    for (const theme of Object.values(THEMES)) {
      const colors = [
        ...theme.tiles,
        theme.floor,
        ...theme.border.colors,
        theme.wall.side,
        theme.wall.top,
        ...theme.plant.colors,
        theme.patch,
        theme.props.crate,
        theme.props.barrel,
        theme.props.rock,
        ...theme.sky,
      ]
      if (theme.glow) colors.push(theme.glow)
      for (const color of colors) expect(color).toMatch(HEX)
    }
  })

  it('gives every world a known theme', () => {
    for (const world of WORLDS) expect(THEME_IDS).toContain(world.theme)
  })
})

describe('buildArena', () => {
  it('draws ground, walls and plants for every world and size', () => {
    for (const world of WORLDS) {
      for (const size of WORLD_SIZES) {
        const arena = arenaFor(world.id, size)
        const scenery = buildArena(arena, world.theme)
        const label = `${world.id} ${size}`
        expect(scenery.getObjectByName('ground')?.children.length, label).toBeGreaterThan(0)
        expect(scenery.getObjectByName('walls')?.children.length, label).toBeGreaterThanOrEqual(arena.walls.length * 2)
        expect(scenery.getObjectByName('bushes')?.children.length, label).toBeGreaterThanOrEqual(arena.bushes.length)
      }
    }
  })

  it('defaults to the canyon look', () => {
    const arena = arenaFor('canyon', 'small')
    const explicit = buildArena(arena, 'canyon')
    const implicit = buildArena(arena)
    expect(implicit.children.length).toBe(explicit.children.length)
  })
})
