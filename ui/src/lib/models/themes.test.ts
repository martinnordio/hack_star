import * as THREE from 'three'
import { describe, expect, it } from 'vitest'
import { arenaFor, THEME_IDS, WORLD_SIZES, WORLDS } from '../game/worlds'
import { buildArena } from './arena3d'
import { ARENA_THEMES } from './themes'

describe('world looks', () => {
  it('has a look for every theme id and every world uses one', () => {
    expect(Object.keys(ARENA_THEMES).sort()).toEqual([...THEME_IDS].sort())
    for (const world of WORLDS) expect(ARENA_THEMES[world.theme], world.id).toBeDefined()
    expect(new Set(WORLDS.map((w) => w.theme)).size).toBe(WORLDS.length)
  })

  it('uses real colours for every theme', () => {
    const color = /^#[0-9a-f]{6}$/i
    for (const [id, theme] of Object.entries(ARENA_THEMES)) {
      const all = [...theme.tiles, theme.floor, theme.wallSide, theme.wallTop, theme.patch, theme.crate, theme.barrel, theme.rock, ...theme.sky, ...theme.borderColors, ...theme.plantColors]
      for (const c of all) expect(c, id).toMatch(color)
    }
  })

  it.each(WORLDS.flatMap((w) => WORLD_SIZES.map((size) => ({ id: w.id, theme: w.theme, size }))))(
    '$id $size builds ground, border, walls and plants',
    ({ id, theme, size }) => {
      const arena = arenaFor(id, size)
      const root = buildArena(arena, theme)
      const walls = root.getObjectByName('walls') as THREE.Group
      const bushes = root.getObjectByName('bushes') as THREE.Group
      expect(root.children.length).toBe(4 + arena.decorations.length)
      expect(root.children.some((c) => c.children.some((m) => m instanceof THREE.InstancedMesh))).toBe(true)
      expect(walls.children.length).toBeGreaterThanOrEqual(arena.walls.length * 4)
      expect(bushes.children.length).toBeGreaterThan(arena.bushes.length)
    },
  )

  it('draws Canyon when no theme is given', () => {
    expect(buildArena(arenaFor('canyon', 'small')).children).toHaveLength(4 + arenaFor('canyon', 'small').decorations.length)
  })
})
