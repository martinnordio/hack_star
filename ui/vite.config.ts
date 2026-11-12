/// <reference types="vitest/config" />
import { svelte } from '@sveltejs/vite-plugin-svelte'
import { defineConfig } from 'vite'

export default defineConfig({
  plugins: [svelte()],
  server: {
    // Listen on the network so iPads and phones on the same Wi-Fi can open the game.
    host: true,
    port: 5180,
    strictPort: true,
    proxy: {
      '/api': 'http://127.0.0.1:8180',
    },
  },
  test: {
    include: ['src/**/*.test.ts'],
  },
})
