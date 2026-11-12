import * as THREE from 'three'

interface Particle {
  mesh: THREE.Mesh
  material: THREE.MeshBasicMaterial
  velocity: THREE.Vector3
  age: number
  life: number
  startScale: number
  endScale: number
  gravity: number
}

export interface Burst {
  color: string
  at: THREE.Vector3
  count: number
  speed: number
  life: number
  size: number
  endSize?: number
  up?: number
  gravity?: number
  /** Box pieces instead of round puffs (used for broken dummies). */
  chunky?: boolean
}

/** A fixed pool of small meshes for dust, flashes, sparks and pieces (no allocation while playing). */
export class Particles {
  readonly group = new THREE.Group()
  private particles: Particle[] = []
  private next = 0

  constructor(size = 160) {
    const round = new THREE.IcosahedronGeometry(1, 0)
    const chunk = new THREE.BoxGeometry(1.6, 1.6, 1.6)
    for (let i = 0; i < size; i++) {
      const material = new THREE.MeshBasicMaterial({ transparent: true, depthWrite: false })
      const mesh = new THREE.Mesh(i % 4 === 0 ? chunk : round, material)
      mesh.visible = false
      this.group.add(mesh)
      this.particles.push({ mesh, material, velocity: new THREE.Vector3(), age: 0, life: 0, startScale: 1, endScale: 0, gravity: 0 })
    }
  }

  private take(chunky: boolean): Particle {
    // Box pieces sit at every 4th slot; round puffs use the others.
    const n = this.particles.length
    for (let tries = 0; tries < n; tries++) {
      const i = this.next
      this.next = (i + 1) % n
      if ((i % 4 === 0) === chunky) return this.particles[i]
    }
    return this.particles[0]
  }

  burst(b: Burst) {
    for (let i = 0; i < b.count; i++) {
      const p = this.take(!!b.chunky)
      const a = Math.random() * Math.PI * 2
      const s = b.speed * (0.5 + Math.random() * 0.5)
      p.velocity.set(Math.cos(a) * s, (b.up ?? 0) * (0.6 + Math.random() * 0.8), Math.sin(a) * s)
      p.mesh.position.copy(b.at)
      p.mesh.rotation.set(Math.random() * 3, Math.random() * 3, 0)
      p.material.color.set(b.color)
      p.material.opacity = 1
      p.age = 0
      p.life = b.life * (0.7 + Math.random() * 0.6)
      p.startScale = b.size
      p.endScale = b.endSize ?? 0
      p.gravity = b.gravity ?? 0
      p.mesh.scale.setScalar(b.size)
      p.mesh.visible = true
    }
  }

  update(dt: number) {
    for (const p of this.particles) {
      if (!p.mesh.visible) continue
      p.age += dt
      if (p.age >= p.life) {
        p.mesh.visible = false
        continue
      }
      const t = p.age / p.life
      p.velocity.y -= p.gravity * dt
      p.mesh.position.addScaledVector(p.velocity, dt)
      if (p.mesh.position.y < 0.05) {
        p.mesh.position.y = 0.05
        p.velocity.y = Math.abs(p.velocity.y) * 0.3
        p.velocity.x *= 0.7
        p.velocity.z *= 0.7
      }
      p.mesh.rotation.x += dt * 6
      p.mesh.scale.setScalar(p.startScale + (p.endScale - p.startScale) * t)
      p.material.opacity = 1 - t * t
    }
  }
}
