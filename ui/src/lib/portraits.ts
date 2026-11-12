import * as THREE from 'three'
import { animateFighter, buildFighter, disposeRig } from './models/fighters3d'

const SIZE = 256
const cache = new Map<string, string>()

let renderer: THREE.WebGLRenderer | undefined
let scene: THREE.Scene | undefined
let camera: THREE.PerspectiveCamera | undefined

function setup() {
  renderer = new THREE.WebGLRenderer({ antialias: true, alpha: true, preserveDrawingBuffer: true })
  renderer.setSize(SIZE, SIZE)
  renderer.setPixelRatio(1)
  scene = new THREE.Scene()
  scene.add(new THREE.HemisphereLight('#fff4e0', '#5b3fd6', 1.6))
  const sun = new THREE.DirectionalLight('#ffffff', 2.4)
  sun.position.set(2, 4, 5)
  scene.add(sun)
  camera = new THREE.PerspectiveCamera(32, 1, 0.1, 50)
  camera.position.set(0, 1.6, 5.4)
  camera.lookAt(0, 1.2, 0)
}

/** A PNG data URL of the fighter, rendered once and cached (one WebGL context for all pictures). */
export function portrait(fighterId: string, skinId = 'default'): string {
  const key = `${fighterId}/${skinId}`
  const cached = cache.get(key)
  if (cached) return cached
  if (!renderer) setup()
  const rig = buildFighter(fighterId, skinId)
  animateFighter(rig, 0)
  rig.root.rotation.y = -0.35
  scene!.add(rig.root)
  renderer!.render(scene!, camera!)
  const url = renderer!.domElement.toDataURL('image/png')
  scene!.remove(rig.root)
  disposeRig(rig)
  cache.set(key, url)
  return url
}
