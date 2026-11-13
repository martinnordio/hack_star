<script lang="ts">
  import jsQR from 'jsqr'
  import { t, type TextKey } from './i18n'

  let { onCode }: { onCode: (text: string) => void } = $props()

  let video = $state<HTMLVideoElement>()
  let problem = $state<TextKey>()

  function explain(error: unknown): TextKey {
    const name = error instanceof DOMException ? error.name : ''
    if (name === 'NotAllowedError') return 'qrScanner.notAllowed'
    if (name === 'NotFoundError' || name === 'OverconstrainedError') return 'qrScanner.noCamera'
    return 'qrScanner.failed'
  }

  $effect(() => {
    if (!video) return
    if (!navigator.mediaDevices?.getUserMedia) {
      // Browsers only allow the camera on https:// or localhost.
      problem = 'qrScanner.needsHttps'
      return
    }

    let stream: MediaStream | undefined
    let frame = 0
    let stopped = false
    const canvas = document.createElement('canvas')
    const context = canvas.getContext('2d', { willReadFrequently: true })!

    function scan() {
      if (stopped || !video) return
      if (video.readyState >= video.HAVE_ENOUGH_DATA) {
        canvas.width = video.videoWidth
        canvas.height = video.videoHeight
        context.drawImage(video, 0, 0)
        const image = context.getImageData(0, 0, canvas.width, canvas.height)
        const found = jsQR(image.data, image.width, image.height, { inversionAttempts: 'dontInvert' })
        if (found?.data) {
          onCode(found.data)
          return
        }
      }
      frame = requestAnimationFrame(scan)
    }

    navigator.mediaDevices
      .getUserMedia({ video: { facingMode: 'environment' }, audio: false })
      .then((s) => {
        stream = s
        if (stopped) return s.getTracks().forEach((t) => t.stop())
        video!.srcObject = s
        return video!.play().then(scan)
      })
      .catch((e) => (problem = explain(e)))

    return () => {
      stopped = true
      cancelAnimationFrame(frame)
      stream?.getTracks().forEach((t) => t.stop())
    }
  })
</script>

<div class="scanner">
  {#if problem}
    <p class="problem" role="alert">{$t(problem)}</p>
  {:else}
    <!-- svelte-ignore a11y_media_has_caption -->
    <video bind:this={video} playsinline muted></video>
    <div class="frame" aria-hidden="true"></div>
    <p class="hint">{$t('qrScanner.hint')}</p>
  {/if}
</div>

<style>
  .scanner {
    position: relative;
    border-radius: 1rem;
    overflow: hidden;
    border: 3px solid #39ff88;
    background: #020a05;
  }

  video {
    display: block;
    width: 100%;
    max-height: 50vh;
    object-fit: cover;
  }

  .frame {
    position: absolute;
    inset: 15% 25%;
    border: 4px solid #39ff88;
    border-radius: 1rem;
    box-shadow: 0 0 0 100vmax #0006;
  }

  .hint,
  .problem {
    margin: 0;
    padding: 0.6rem 0.8rem;
    font-weight: 800;
    color: #b8ffd4;
  }

  .hint {
    position: absolute;
    left: 0;
    right: 0;
    bottom: 0;
    text-align: center;
    background: #020a05cc;
  }
</style>
