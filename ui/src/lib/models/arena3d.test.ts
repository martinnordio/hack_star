import * as THREE from 'three'
import { describe, expect, it } from 'vitest'
import { arenaFor, WORLD_SIZES, WORLDS } from '../game/worlds'
import { buildArena, THEMES } from './arena3d'

const meshes = (o: THREE.Object3D | undefined) => {
  let count = 0
  o?.traverse((child) => {
    if (child instanceof THREE.Mesh) count++
  })
  return count
}

describe('world looks', () => {
  it('every world has a theme of its own', () => {
    for (const w of WORLDS) expect(THEMES[w.theme], w.id).toBeDefined()
    expect(new Set(WORLDS.map((w) => w.theme)).size).toBe(WORLDS.length)
  })

  it.each(WORLDS.flatMap((w) => WORLD_SIZES.map((size) => [w.id, size, w.theme] as const)))('%s %s has ground, walls and cover', (id, size, theme) => {
    const arena = arenaFor(id, size)
    const root = buildArena(arena, theme)
    expect(meshes(root.getObjectByName('ground'))).toBeGreaterThanOrEqual(2)
    expect(meshes(root.getObjectByName('walls'))).toBeGreaterThanOrEqual(arena.walls.length)
    expect(meshes(root.getObjectByName('bushes'))).toBeGreaterThan(arena.bushes.length)
  })
})
