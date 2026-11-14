import * as THREE from 'three'
import { describe, expect, it } from 'vitest'
import { lookSkin } from '../created'
import { PART_COUNTS } from '../progress'
import { buildCreated } from './custom3d'

/** Number of meshes and a checksum of their positions: equal fingerprints mean the same model. */
function fingerprint(skinId: string): string {
  const rig = buildCreated(skinId)
  rig.root.updateMatrixWorld(true)
  let count = 0
  let sum = 0
  const p = new THREE.Vector3()
  rig.root.traverse((o) => {
    if (!(o instanceof THREE.Mesh)) return
    count++
    o.getWorldPosition(p)
    sum += p.x + p.y * 3 + p.z * 7
  })
  return `${count}:${sum.toFixed(4)}`
}

describe('created fighter model', () => {
  it('draws every look saved before hands and legs existed exactly as before', () => {
    // Recorded from the models of version 6 (head, body).
    const before: Record<string, string> = {
      '00': '37:143.3627', '01': '37:143.3327', '02': '41:154.4627',
      '10': '25:71.8500', '11': '25:71.8200', '12': '29:82.9500',
      '20': '34:122.1331', '21': '34:122.1031', '22': '38:133.2331',
    }
    for (const [parts, expected] of Object.entries(before)) {
      expect(fingerprint(`L4${parts}2fb5ffffd23f`)).toBe(expected)
    }
  })

  it('builds every combination of head, body, hands and legs', () => {
    const seen = new Set<string>()
    for (let head = 0; head < PART_COUNTS.head; head++)
      for (let body = 0; body < PART_COUNTS.body; body++)
        for (let hands = 0; hands < PART_COUNTS.hands; hands++)
          for (let legs = 0; legs < PART_COUNTS.legs; legs++) {
            const skin = lookSkin({ type: 'tank', main: '#2fb5ff', second: '#ffd23f', head, body, hands, legs })
            seen.add(fingerprint(skin))
          }
    expect(seen.size).toBe(PART_COUNTS.head * PART_COUNTS.body * PART_COUNTS.hands * PART_COUNTS.legs)
  })
})
