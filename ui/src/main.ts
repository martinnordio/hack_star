import { mount } from 'svelte'
import './app.css'
import App from './App.svelte'
import Gallery from './lib/Gallery.svelte'

const app = mount(location.search.includes('gallery') ? Gallery : App, {
  target: document.getElementById('app')!,
})

export default app
