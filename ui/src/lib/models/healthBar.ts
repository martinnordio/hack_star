import * as THREE from 'three'

const WIDTH = 1.4

export interface HealthBar {
  group: THREE.Group
  fill: THREE.Mesh
  /** Fixed colour (fighters), or traffic-light colours by health when unset (dummies). */
  color?: string
}

export function buildHealthBar(height: number, color?: string): HealthBar {
  const group = new THREE.Group()
  group.position.y = height
  const back = new THREE.Mesh(new THREE.PlaneGeometry(WIDTH + 0.1, 0.24), new THREE.MeshBasicMaterial({ color: '#160f33' }))
  const fillGeometry = new THREE.PlaneGeometry(WIDTH, 0.14)
  fillGeometry.translate(WIDTH / 2, 0, 0)
  const fill = new THREE.Mesh(fillGeometry, new THREE.MeshBasicMaterial({ color: color ?? '#4cd964' }))
  fill.position.set(-WIDTH / 2, 0, 0.01)
  group.add(back, fill)
  return { group, fill, color }
}

export function setBarHealth(bar: HealthBar, fraction: number) {
  bar.fill.scale.x = Math.max(0.001, fraction)
  if (bar.color) return
  const color = fraction > 0.5 ? '#4cd964' : fraction > 0.25 ? '#ffd23f' : '#ff3b30'
  ;(bar.fill.material as THREE.MeshBasicMaterial).color.set(color)
}
