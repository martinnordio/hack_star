/// <reference types="vitest/config" />
import { svelte } from '@sveltejs/vite-plugin-svelte'
import basicSsl from '@vitejs/plugin-basic-ssl'
import { defineConfig } from 'vite'
import { musicDevTools } from './dev/musicPlugin.ts'

// `npm run dev:https` (mode "https"): self-signed HTTPS so the camera works on iPads and phones.
export default defineConfig(({ mode }) => ({
  plugins: [svelte(), musicDevTools(), ...(mode === 'https' ? [basicSsl()] : [])],
  server: {
    // Listen on the network so iPads and phones on the same Wi-Fi can open the game.
    host: true,
    port: 5180,
    strictPort: true,
    // The About panel shows the repository's LICENSE (outside ui/).
    fs: { allow: ['.', '../LICENSE'] },
    proxy: {
      // `ws` also forwards the room WebSockets (`/api/rooms`).
      '/api': { target: 'http://127.0.0.1:8180', ws: true },
    },
  },
  test: {
    include: ['src/**/*.test.ts'],
  },
}))
