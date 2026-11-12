import { mount } from 'svelte'
import './app.css'
import App from './App.svelte'
import Gallery from './lib/Gallery.svelte'
import QrPage from './lib/QrPage.svelte'

const params = new URLSearchParams(location.search)
const page = params.has('gallery') ? Gallery : params.has('qr') ? QrPage : App

const app = mount(page, {
  target: document.getElementById('app')!,
})

export default app
