import * as THREE from 'three'
import { describe, expect, it } from 'vitest'
import { CANYON } from '../game/arena'
import { WORLD_SIZES, WORLDS, arenaFor } from '../game/worlds'
import { WORLD_LOOKS, buildArena, disposeArena, shadowReach } from './arena3d'

/** Triangles, a checksum of their corners' positions and a checksum of their colours. */
function fingerprint(root: THREE.Object3D): { triangles: number; place: number; colour: number } {
  root.updateMatrixWorld(true)
  let corners = 0
  let place = 0
  let colour = 0
  const v = new THREE.Vector3()
  const instance = new THREE.Matrix4()
  const matrix = new THREE.Matrix4()
  const tint = new THREE.Color()
  root.traverse((o) => {
    if (!(o instanceof THREE.Mesh)) return
    const geometry = o.geometry as THREE.BufferGeometry
    const position = geometry.getAttribute('position')
    const index = geometry.getIndex()
    const count = index ? index.count : position.count
    const material = o.material as THREE.MeshBasicMaterial
    const copies = o instanceof THREE.InstancedMesh ? o.count : 1
    for (let c = 0; c < copies; c++) {
      matrix.copy(o.matrixWorld)
      tint.copy(material.color)
      if (o instanceof THREE.InstancedMesh) {
        o.getMatrixAt(c, instance)
        matrix.multiply(instance)
        if (o.instanceColor) {
          const own = new THREE.Color()
          o.getColorAt(c, own)
          tint.multiply(own)
        }
      }
      for (let i = 0; i < count; i++) {
        v.fromBufferAttribute(position, index ? index.getX(i) : i).applyMatrix4(matrix)
        place += v.x + v.y * 3 + v.z * 7
        colour += tint.r + tint.g * 3 + tint.b * 7
      }
      corners += count
    }
  })
  return { triangles: corners / 3, place, colour }
}

const meshes = (o: THREE.Object3D | undefined) => {
  let count = 0
  o?.traverse((m) => {
    if (m instanceof THREE.Mesh) count++
  })
  return count
}

describe('arena look', () => {
  it('has a look for every theme of the catalogue', () => {
    for (const w of WORLDS) expect(WORLD_LOOKS[w.theme], w.id).toBeDefined()
    expect(new Set(WORLDS.map((w) => w.theme)).size).toBe(WORLDS.length)
    expect(Object.keys(WORLD_LOOKS).sort()).toEqual(WORLDS.map((w) => w.theme).sort())
  })

  it('draws ground, border, walls and cover for every world and size', () => {
    for (const w of WORLDS) {
      for (const size of WORLD_SIZES) {
        const arena = arenaFor(w.id, size)
        const root = buildArena(arena, w.theme)
        const name = `${w.id} ${size}`
        expect(meshes(root.getObjectByName('ground')), name).toBe(2)
        expect(meshes(root.getObjectByName('edge')), name).toBeGreaterThan(0)
        expect(meshes(root.getObjectByName('walls')), name).toBeGreaterThan(0)
        expect(meshes(root.getObjectByName('bushes')), name).toBeGreaterThan(0)
        // Merged by material: a few draw calls, even in a Large world.
        expect(meshes(root), name).toBeLessThan(40)
        disposeArena(root)
      }
    }
  })

  it('draws more cover in a bigger size', () => {
    for (const w of WORLDS) {
      const triangles = WORLD_SIZES.map((size) => {
        const root = buildArena(arenaFor(w.id, size), w.theme)
        return fingerprint(root.getObjectByName('walls')!).triangles + fingerprint(root.getObjectByName('bushes')!).triangles
      })
      expect(triangles[1], w.id).toBeGreaterThan(triangles[0])
      expect(triangles[2], w.id).toBeGreaterThan(triangles[1])
    }
  })

  it('draws the canyon exactly as before worlds existed', () => {
    // Recorded from the canyon model before themes and merging.
    const before = fingerprint(buildArena(CANYON))
    expect(before.triangles).toBe(94922)
    expect(before.place).toBeCloseTo(-2686660.61, 0)
    expect(before.colour).toBeCloseTo(352832.37, 0)
  })

  it('makes the shadow cover the whole arena', () => {
    expect(shadowReach(CANYON)).toBe(20)
    for (const size of WORLD_SIZES) {
      const arena = arenaFor('canyon', size)
      expect(shadowReach(arena)).toBeGreaterThanOrEqual(Math.hypot(arena.width, arena.depth) / 2)
    }
  })
})
