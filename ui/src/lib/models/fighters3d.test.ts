import * as THREE from 'three'
import { describe, expect, it } from 'vitest'
import { buildFighter } from './fighters3d'

const OLD = ['blaze', 'rocko', 'turbo', 'frosty', 'luna', 'pixel', 'coco', 'sparky', 'clank', 'kira']
const NEW = ['marina', 'drako', 'spectra', 'mecha', 'zeus']

/** Visible parts: meshes that are not the outline copy of another mesh. */
function parts(id: string): number {
  let count = 0
  buildFighter(id).root.traverse((o) => {
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
