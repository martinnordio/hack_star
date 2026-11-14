// Development only (`npm run dev`): the developer page's music tools. Never part of `npm run build`.
// Music stays on this computer: changes go to the git-ignored *.local.json files and public/assets/music/.
import { copyFile, mkdir, readFile, rm, writeFile } from 'node:fs/promises'
import { createReadStream, existsSync } from 'node:fs'
import type { IncomingMessage, ServerResponse } from 'node:http'
import { join } from 'node:path'
import type { Plugin } from 'vite'
import { choose, isTrackFile, mergeCandidates, parseCandidates, remove, shipped, unchoose, type Candidate, type ListChange } from '../src/lib/music/candidates.ts'

const ROOT = join(import.meta.dirname, '..')
const LIST = join(ROOT, 'dev', 'music', 'candidates.json')
const LOCAL_LIST = join(ROOT, 'dev', 'music', 'candidates.local.json')
const FILES = join(ROOT, 'dev', 'music', 'files')
const PUBLIC = join(ROOT, 'public', 'assets', 'music')
const LOCAL_SHIPPED = join(ROOT, 'src', 'lib', 'music', 'tracks.local.json')

async function readCandidates(file: string): Promise<Candidate[]> {
  try {
    // Windows editors may save the file with a byte-order mark.
    return parseCandidates(JSON.parse((await readFile(file, 'utf-8')).replace(/^\uFEFF/, '')))
  } catch {
    return []
  }
}

async function readList(): Promise<Candidate[]> {
  return mergeCandidates(await readCandidates(LIST), await readCandidates(LOCAL_LIST))
}

async function writeLists(tracks: Candidate[]): Promise<void> {
  await writeFile(LOCAL_LIST, JSON.stringify({ tracks }, null, 2) + '\n', 'utf-8')
  await writeFile(LOCAL_SHIPPED, JSON.stringify(shipped(tracks), null, 2) + '\n', 'utf-8')
}

function send(res: ServerResponse, status: number, body: unknown): void {
  res.statusCode = status
  res.setHeader('Content-Type', 'application/json')
  res.end(JSON.stringify(body))
}

async function readId(req: IncomingMessage): Promise<string> {
  let body = ''
  for await (const chunk of req) {
    body += chunk
    if (body.length > 1000) break
  }
  const id = (JSON.parse(body) as { id?: unknown }).id
  return typeof id === 'string' ? id : ''
}

/** Only this computer: the dev server also listens on the Wi-Fi for phones. */
function fromThisComputer(req: IncomingMessage): boolean {
  const address = req.socket.remoteAddress ?? ''
  return address === '127.0.0.1' || address === '::1' || address === '::ffff:127.0.0.1'
}

async function change(id: string, action: string): Promise<ListChange> {
  const tracks = await readList()
  const track = tracks.find((t) => t.id === id)
  const result = action === 'choose' ? choose(tracks, id) : action === 'unchoose' ? unchoose(tracks, id) : remove(tracks, id)
  if (!result.ok || !track) return result
  if (action === 'choose') {
    if (!existsSync(join(FILES, track.file))) return { ok: false, reason: `The file ${track.file} is missing in ui/dev/music/files/.` }
    await mkdir(PUBLIC, { recursive: true })
    await copyFile(join(FILES, track.file), join(PUBLIC, track.file))
  } else if (action === 'unchoose') {
    await rm(join(PUBLIC, track.file), { force: true })
  } else {
    await rm(join(FILES, track.file), { force: true })
  }
  await writeLists(result.tracks)
  return result
}

export function musicDevTools(): Plugin {
  return {
    name: 'hack-star-music-dev-tools',
    apply: 'serve',
    configureServer(server) {
      server.middlewares.use('/__dev/music', async (req, res) => {
        try {
          const url = new URL(req.url ?? '/', 'http://localhost')
          if (!fromThisComputer(req)) return send(res, 403, { ok: false, reason: 'Only from the computer that runs npm run dev.' })
          if (req.method === 'GET' && url.pathname === '/list') {
            const tracks = await readList()
            return send(res, 200, tracks.map((t) => ({ ...t, hasFile: existsSync(join(FILES, t.file)) })))
          }
          const file = decodeURIComponent(url.pathname.replace(/^\/file\//, ''))
          if (req.method === 'GET' && url.pathname.startsWith('/file/') && isTrackFile(file) && existsSync(join(FILES, file))) {
            res.setHeader('Content-Type', 'audio/mpeg')
            return createReadStream(join(FILES, file)).pipe(res)
          }
          const action = url.pathname.slice(1)
          if (req.method === 'POST' && ['choose', 'unchoose', 'delete'].includes(action)) {
            const result = await change(await readId(req), action)
            return send(res, result.ok ? 200 : 400, result)
          }
          send(res, 404, { ok: false, reason: 'Not found.' })
        } catch {
          send(res, 500, { ok: false, reason: 'The music tools failed; see the npm run dev terminal.' })
        }
      })
    },
  }
}
