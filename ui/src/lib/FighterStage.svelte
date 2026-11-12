<script lang="ts">
  import { T, useTask } from '@threlte/core'
  import { animateFighter, buildFighter, disposeRig } from './models/fighters3d'

  interface Props {
    fighterId: string
    skinId?: string
    position?: [number, number, number]
    rotationY?: number
    scale?: number
  }

  let { fighterId, skinId = 'default', position = [0, 0, 0], rotationY = 0, scale = 1 }: Props = $props()

  const rig = $derived(buildFighter(fighterId, skinId))
  let time = 0

  $effect(() => {
    const current = rig
    return () => disposeRig(current)
  })

  useTask((delta) => {
    time += delta
    animateFighter(rig, time)
  })
</script>

<T is={rig.root} {position} rotation.y={rotationY} scale={scale} />
