import * as THREE from 'three'
import { describe, expect, it } from 'vitest'
import { buildFighter } from './fighters3d'
import { VARIANTS } from './skins3d'

const OLD = ['blaze', 'rocko', 'turbo', 'frosty', 'luna', 'pixel', 'coco', 'sparky', 'clank', 'kira']
const NEW = ['marina', 'drako', 'spectra', 'mecha', 'zeus']

/** Visible parts: meshes that are not the outline copy of another mesh. */
function parts(id: string, skin = 'default'): number {
  let count = 0
  buildFighter(id, skin).root.traverse((o) => {
    if (o instanceof THREE.Mesh && !(o.parent instanceof THREE.Mesh && o.geometry === o.parent.geometry)) count++
  })
  return count
}

describe('new fighters (more detailed)', () => {
  const average = OLD.reduce((sum, id) => sum + parts(id), 0) / OLD.length

  it.each(NEW)('%s has at least twice the parts of an average current fighter', (id) => {
    expect(parts(id)).toBeGreaterThanOrEqual(2 * average)
  })

  it.each(NEW)('%s moves at least 3 parts in its idle animation and uses shiny or glowing materials', (id) => {
    const rig = buildFighter(id)
    expect(rig.moves.length + rig.flickers.length + rig.spinners.length).toBeGreaterThanOrEqual(3)
    expect(rig.moves.length).toBeGreaterThanOrEqual(2)
    let polished = 0
    rig.root.traverse((o) => {
      if (o instanceof THREE.Mesh && (o.material instanceof THREE.MeshStandardMaterial || (o.material instanceof THREE.MeshBasicMaterial && o.material.transparent))) polished++
    })
    expect(polished).toBeGreaterThanOrEqual(5)
  })
})

describe('three more skins per fighter', () => {
  const colours = (id: string, skin: string) => {
    const set = new Set<string>()
    buildFighter(id, skin).root.traverse((o) => {
      if (o instanceof THREE.Mesh && 'color' in o.material) set.add((o.material as THREE.MeshToonMaterial).color.getHexString())
    })
    return [...set].sort().join()
  }

  it('there are 3 for each of the 15 fighters', () => {
    expect(Object.keys(VARIANTS).sort()).toEqual([...OLD, ...NEW].sort())
    for (const skins of Object.values(VARIANTS)) expect(Object.keys(skins)).toHaveLength(3)
  })

  it.each(Object.entries(VARIANTS).flatMap(([id, skins]) => Object.keys(skins).map((skin) => [id, skin])))(
    '%s %s has other colours and an extra part',
    (id, skin) => {
      expect(colours(id, skin)).not.toBe(colours(id, 'default'))
      expect(parts(id, skin)).toBeGreaterThan(parts(id, 'default'))
    },
  )
})
