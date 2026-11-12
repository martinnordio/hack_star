import jsQR from 'jsqr'
import QRCode from 'qrcode'
import { describe, expect, it } from 'vitest'
import { codeFromScan, hackLink } from './hacks'

/** Draw a QR code as black/white RGBA pixels, like a camera frame. */
function render(text: string, scale = 4, margin = 4) {
  const { modules } = QRCode.create(text, { errorCorrectionLevel: 'M' })
  const size = (modules.size + margin * 2) * scale
  const pixels = new Uint8ClampedArray(size * size * 4).fill(255)
  for (let y = 0; y < modules.size; y++) {
    for (let x = 0; x < modules.size; x++) {
      if (!modules.get(y, x)) continue
      for (let dy = 0; dy < scale; dy++) {
        for (let dx = 0; dx < scale; dx++) {
          const i = (((y + margin) * scale + dy) * size + (x + margin) * scale + dx) * 4
          pixels[i] = pixels[i + 1] = pixels[i + 2] = 0
        }
      }
    }
  }
  return { pixels, size }
}

describe('QR codes', () => {
  it.each(['INFINITY', 'OPENSESAME', 'POWER22'])('a printed QR for %s scans back to its code', (code) => {
    const link = hackLink('http://192.168.1.20:5180', code)
    const { pixels, size } = render(link)
    const found = jsQR(pixels, size, size)
    expect(found?.data).toBe(link)
    expect(codeFromScan(found!.data)).toBe(code)
  })
})
