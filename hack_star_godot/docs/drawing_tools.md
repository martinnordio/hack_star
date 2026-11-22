# Drawing tools: a better drawing-to-character workflow

A recommendation for turning a photo of a child's drawing into a **3D character with a
skeleton and animations** in the Godot game, with at most three tools (spec 09, part B). The
workflow that Claude runs alone, without other tools, is
[drawing_to_fighter.md](drawing_to_fighter.md) (part A, the way Beatbolt was made).

> **Not legal advice.** The terms below are summarised from the tools' own pages as read on the
> date given; they change often. Read the current terms before you upload or publish anything.
> Outputs of AI tools may not be protected by copyright at all; the drawing itself is the
> child's own work.

All facts were checked on **2026-11-22** unless another date is given; the sources are listed
in [Sources](#sources) with the date of each page.

## Recommendation

| | Workflow | Tools | When |
|-|----------|-------|------|
| **Main** | Google Flow → Meshy → Claude in Godot | 3 (all free to start) | You want a real 3D model with a skeleton and many animations, and accept Meshy's look and a credit line |
| **Fallback A** | Claude alone ([drawing_to_fighter.md](drawing_to_fighter.md)) | 1 | Always works; the result is built from shapes in the game's own outlined look (like Beatbolt) |
| **Fallback B** | Google Flow → Claude | 2 | Flow cleans the drawing into a clear front view first; Claude then builds it from shapes (more reliable colours and proportions than reading a pencil photo) |

**Licence first (B4):** only tools whose terms allow publishing the result in this MIT-licensed
open-source game are recommended. Meshy's **free plan** gives its outputs under
**CC BY 4.0** (commercial use allowed with credit to Meshy) — allowed, with a credit line.
Tripo's free plan (non-commercial) and Hunyuan3D (licence excludes the EU, UK and South Korea)
are **not** recommended; see [Tools not recommended](#tools-not-recommended).

## Main workflow, step by step

The author does steps 1–4 with his own accounts (the child does not need an account); Claude
does step 5 in the repository.

1. **Photo** — as in [drawing_to_fighter.md § 1](drawing_to_fighter.md#1-photograph-the-drawing):
   only the drawing, flat, daylight, no people, faces, full names or places, metadata removed;
   saved outside the repository in `%USERPROFILE%\hack_star_drawings\`.
2. **Google Flow (clean front view)** — upload the photo as a reference image and ask Nano
   Banana for a clean, full-body **front view** of the same character, **standing in a T-pose
   or A-pose**, arms away from the body, on a **plain white background**, in a flat toon style
   with dark outlines and the drawing's colours. Optionally ask for a side and back view too
   (for your own check; Meshy's multi-view needs a paid plan). Download the best image (PNG).
   Images can be generated with the free daily credits.
3. **Meshy (image to 3D)** — *Model → Image to 3D*, upload the Flow image, choose a model the
   free plan can download (**Meshy 6 Lite**: free downloads are limited to 10 Meshy 6 Lite
   models a month), set **Pose: A-Pose** (or T-Pose), generate (10 credits). Check it from all
   sides. If it has no colours, add *AI Texturing* (10 credits).
4. **Meshy (rig and animate)** — *Animate* → *Rig* (0 credits), then add an idle, a run and an
   attack-like clip from the free motions (adding a preset costs no credits; the free library
   has 20 motions). Download as **GLB** with *Animation: All Added*. Do **not** publish it to
   the Meshy Community (see [Meshy](#meshy)).
5. **Claude in Godot** — give Claude the GLB (outside the repository) and ask it to add it as a
   drawn fighter, as in [drawing_to_fighter.md](drawing_to_fighter.md), but with the GLB as the
   look: check the [fit limits](#fit-for-the-game-b5), import it into
   `assets/models/<id>/` (Godot imports glTF 2.0 `.glb` directly), give it the game's toon
   material and outline (D5: `ToonMaterials`, a texture uniform if the model is textured),
   connect the idle, run and attack clips to the same hooks as the other fighters (A4), credit
   Meshy and the child in `LICENSES.md`, and test it like Beatbolt.

Time (estimate, not yet measured — the [trial](#trial-b6) records the real one): 15–30 min of
the author for steps 1–4 (Meshy's model generation takes about a minute), 30–60 min of Claude for
step 5. Cost: free use only — Google Flow's 50 daily credits, Meshy's 100 monthly credits
(about 10–30 credits for one character).

## Facts per tool (B2, B3)

### Google Flow

| | |
|-|-|
| **What it does here** | Turns the photo into a clean front view (and side/back views) of the same character in a toon style: image generation and editing with **Nano Banana**, also from an uploaded reference image, lasso edits, character consistency across images; videos with Veo and Omni |
| **What it cannot do** | **No 3D model, no skeleton, no game asset formats** — only images and video clips. So it cannot make a game character alone (B3); its place is *before* the 3D tool, or before Claude (fallback B) |
| **Cost** | Without a subscription: 50 Flow credits a day (daily refresh, no roll-over), images can be generated free; Google AI Plus, Pro, Ultra add 200 / 1,000 / 10,000–25,000 credits a month |
| **Account and age** | A Google account, **18 or older with verified age**, a supported region, a Chromium-based browser (Chrome, Edge); the author uses his own account |
| **Output and Godot** | PNG/JPG images (and video): not loaded by Godot as a character; the input for Meshy or for Claude |
| **Training on uploads** | Google collects prompts, uploads and outputs and uses them "to provide, improve, and develop Google products … and machine learning technologies"; human reviewers see a sample (disconnected from the account). Turn off **"Help improve Flow"** in the main menu to stop this use; reviewed items are kept up to 18 months |
| **Terms for this MIT game** | Google Terms of Service: "Google won't claim ownership" of generated original content; you must not use AI output to develop machine-learning models; Generative AI Prohibited Use Policy applies; **every output carries an invisible SynthID watermark**. No explicit licence grant — the Flow image is only an *intermediate* step and is not committed; the game ships the 3D model (Meshy) or Claude's code |
| **Credit for `LICENSES.md`** | None required (the Flow image is not shipped) |

### Meshy

| | |
|-|-|
| **What it does here** | Image → textured 3D model; **Pose A-Pose/T-Pose** for characters; auto-rig of humanoids (0 credits); animation library (600+ presets, **20 on the free plan**); download as GLB, FBX, USDZ (also OBJ, STL, BLEND, 3MF) |
| **What it cannot do** | Fine lines and details of a child's drawing (it guesses the sides and back from one image; multi-view needs a paid plan); four-legged characters get only a walk; the free plan cannot download the newest model (Meshy 7.1) — free downloads: 10 Meshy 6 Lite models a month; Meshy 6 Lite has no texture at generation (AI Texturing: 10 credits); Smart Topology / Remesh for low-poly game meshes are listed for paid plans |
| **Cost** | Free: 100 credits a month, no credit card, up to 10 assets, 1 task at a time; Image to 3D 10 credits (Meshy 6 Lite) or 20 (Meshy 6 / 7.1); rigging 0; adding a preset motion 0. Pro: CHF 18 a month (1,000 credits; price shown to a Swiss visitor) |
| **Account and age** | A Meshy account; **14 or older** (or the minimum age of the country), under 18 only with a parent's permission — the author uses his own account |
| **Output and Godot** | **GLB** (glTF 2.0 binary, Godot's recommended 3D format, imported directly) with skeleton and animations |
| **Training on uploads** | Meshy "may use Customer Inputs and Customer Outputs … from non-Enterprise Customers to train, validate, test, or improve Services"; **opt out by e-mail to support@meshy.ai** (do this before the trial). No personal data in uploads (terms § 2.2) |
| **Terms for this MIT game** | **Free plan: Meshy owns the output and licenses it under CC BY 4.0** — commercial use and redistribution allowed with appropriate credit to Meshy; paid plans: the user owns the output. Do not remove Meshy's AI identifiers/watermarks from the output. **Do not publish to the Meshy Community**: Community uploads become CC BY-NC 4.0 (images, e.g. the drawing) and CC0 (models) |
| **Credit for `LICENSES.md`** | `<Fighter> 3D model — generated with Meshy (meshy.ai) from <child>'s drawing, free plan — CC BY 4.0 (https://creativecommons.org/licenses/by/4.0/), © Meshy LLC; changes: imported into Godot, toon material and outline added` |

### Claude via Copilot

| | |
|-|-|
| **What it does here** | Reads the photo or the Flow image; builds a fighter from shapes in code (fallbacks A and B); imports the GLB, fits it into the game (toon material, outline, animation hooks, tests, credits) |
| **What it cannot do** | It does not generate images or 3D models itself |
| **Cost** | Included in the author's Copilot plan (costs per run are measured in this repository's Stage logs) |
| **Account and age** | The author's GitHub Copilot account |
| **Output and Godot** | GDScript and scenes in the repository |
| **Terms for this MIT game** | Code written for the project, under the repository's MIT licence |

### Godot 4.7

Imports glTF 2.0 (`.gltf` text and `.glb` binary, **recommended**), `.blend` (needs Blender
installed), DAE, OBJ (no skeletons or animations) and FBX (through ufbx). A GLB from Meshy is
copied into the project and imported when the editor gets focus; its skeleton and animation
clips become a `Skeleton3D` and an `AnimationPlayer`. Free, MIT.

### Tools not recommended

| Tool | Why not (B4) |
|------|--------------|
| **Tripo** | Free plan (200 credits a month): outputs public and **non-commercial** — not allowed in this game without a paid plan |
| **Hunyuan3D (Tencent)** | Its community licence "does not apply in the European Union, United Kingdom and South Korea" — the author is in Europe |
| **TRELLIS.2 (Microsoft)** | MIT, but runs only on a PC with an NVIDIA GPU with **24 GB** of video memory, and has no rig or animations |

## Fit for the game (B5)

A generated character joins the game only if it meets all of these (project limits set by this
spec, measured by Claude in step 5):

| Limit | Value | Why |
|-------|-------|-----|
| Triangles | **≤ 10,000** per fighter (decimate in Godot's import settings or with Meshy's Remesh if more) | 4 fighters ≤ 40 k triangles, small next to the ~0.8 M primitives of a 4-fighter match (spec 09 Step 13) — keeps 30 fps on an iPad (G14) |
| File size | **GLB ≤ 2 MB**, textures ≤ 1024 × 1024 px | The web download may grow by at most 5 MB for the whole spec (G15); the spec used about 0.16 MB so far |
| Skeleton and clips | Humanoid rig with at least **idle, run and an attack** (A4); played by the same hooks as the other fighters | Moves like the others |
| Look | Toon material (3 bands) and the dark outline of `ToonMaterials` (D5) on every mesh; readable at card size (150 px) | The outlined cartoon look of G9 |
| Licence | Free plan CC BY 4.0 with the credit line above, or a paid plan's own licence; nothing published to the Meshy Community | B4, S4 |
| Child's choice | The child prefers it to the shapes version (Beatbolt) | B6 |

If one limit is not met, keep the GLB outside the repository and use fallback A or B.

## Trial (B6)

One drawing goes through the main workflow, done by the author with his own accounts on **free
use only** (no subscription, no paid credits). The drawing is the one of Beatbolt (Mattia's
`character_drawing_01`), so the result can be compared with the shapes version already in the
game. **Status: waiting for the author** (spec 09, Step 19).

### Before you start (5 min)

1. Make a folder **outside the repository**: `%USERPROFILE%\hack_star_drawings\trial\`. Every
   file of the trial goes there; nothing of it is committed by you.
2. Use the cleaned photo `%USERPROFILE%\hack_star_drawings\character_drawing_01_clean.png`
   (re-encoded by Claude, no metadata).
3. Note the start time.
4. Meshy: sign in with **your** account on the **Free** plan (no card). Send an e-mail to
   `support@meshy.ai` asking to opt out of training on your inputs and outputs (terms § 2.9).
   Never click *Publish* / *Share to Community*.
5. Google Flow: open <https://labs.google/fx/tools/flow> in Chrome or Edge with **your** Google
   account (18+, age verified). In the main menu, switch **"Help improve Flow"** off. Note your
   remaining Flow credits (profile picture → credits).

### Step A — Google Flow: a clean front view (10 min)

1. New project → create an **image** (Nano Banana) → add `character_drawing_01_clean.png` as the
   reference image (ingredient).
2. Paste this prompt:

   > Redraw the character from the reference image as a clean, full-body character sheet for a
   > 3D model: **front view**, standing straight in an **A-pose** (arms slightly away from the
   > body, legs apart), facing the camera, whole body visible from hair to shoes, centred, on a
   > **plain white background**, no shadow, no text, no other objects. Keep the character
   > exactly as drawn: a chibi kid with a big round head, spiky purple and navy hair with one
   > pink streak, big dark-blue eyes and serious brows, large white over-ear headphones with
   > teal cups, an orange mark and a small red light on the right cup, a white jacket with teal
   > collar, hem and stripe, a round teal shoulder pad with an orange edge, one black
   > fingerless glove, the other arm a long white tube arm cannon with an orange ring, navy
   > trousers, black shoes. **Toon style**: flat colours, two tones of shading, thick dark
   > outlines, like a cartoon game character. Same colours as the drawing.

3. Generate (it shows the credit cost first). If needed, try once more or fix one detail with
   the lasso and a short request (for example "make the arm cannon straight and white").
4. Optional (for your own check only): ask for "the same character from the side and from the
   back, same pose, same style, white background".
5. Download the best front view as `%USERPROFILE%\hack_star_drawings\trial\flow_front.png`
   (and `flow_side.png`, `flow_back.png` if made). Take a screenshot of the Flow page with the
   result: `trial\screen_flow.png`. Note the Flow credits used.

### Step B — Meshy: image to 3D (10 min)

1. *Model* → **Image to 3D** → upload `flow_front.png`.
2. Settings: model **Meshy 6 Lite** (the free plan can download it; 10 credits) — if the free plan
   offers *Meshy 6* or *Smart Topology* **and** lets you download it, you may try it instead and
   note it; **Pose: A-Pose**; *Image Enhancement* on; **License: CC BY 4.0** (the free plan's).
   If the panel has a *Poly Count*, set **8,000** (limit 10,000 triangles, B5).
3. Generate; rotate the model and check it from all sides. Screenshots: front, side, back →
   `trial\screen_meshy_front.png`, `…_side.png`, `…_back.png`.
4. If the model is grey (no colours): *AI Texturing* (10 credits) with the prompt
   *"toon style, flat colours as in the reference image, white jacket with teal trim, purple
   and navy hair, white headphones with teal cups, navy trousers, black shoes"*, texture size
   **1024** if you can choose.
5. Generate at most **3 models** in total (≤ 60 credits) so the 100 monthly credits are enough.

### Step C — Meshy: rig, animate, download (5 min)

1. *Animate* → select the model → **Rig** (0 credits; humanoid).
2. From the free motions add (0 credits each): an **idle**, a **run** (or walk) and one
   **attack-like** clip (punch, shoot or throw). Screenshot `trial\screen_meshy_animate.png`.
3. **Download** → Format **GLB**, Animation **All Added**, skeleton template as offered (Mixamo
   default) → save as `%USERPROFILE%\hack_star_drawings\trial\beatbolt_meshy.glb`.
4. Note the remaining Meshy credits and the end time.

### Step D — Mattia's preference (5 min)

Show Mattia the Meshy screenshots next to the shapes version in the game (home and fighter
screen, or `%LOCALAPPDATA%\hack_star\screens\09\step16\`). Ask: *"Which one is more your
drawing, and which one do you want in the game?"* — write down his words.

### What to send back to Claude

Put the files in `%USERPROFILE%\hack_star_drawings\trial\` and tell Claude in the chat:

- `beatbolt_meshy.glb` (and its size in MB),
- the screenshots (`screen_flow.png`, `screen_meshy_*.png`) and `flow_front.png`,
- the time you needed (start → end) and for each step,
- credits used: Google Flow (before / after) and Meshy (before / after), and that no paid plan
  was used,
- which Meshy model and settings you used, and whether the free plan allowed the GLB download,
- problems (blocked prompts, errors, missing download, wrong colours, broken hands …),
- Mattia's preference (Meshy or shapes) in his words,
- that the Meshy opt-out e-mail was sent and nothing was published to the Community.

Claude then fills the table below, checks the [fit limits](#fit-for-the-game-b5) and, only if
Mattia prefers it **and** the licence allows it (CC BY 4.0 with the credit line), imports it
(spec 09, Step 19); otherwise the files stay outside the repository and the reason is written
here.

### Trial results

| Item | Result |
|------|--------|
| Date of the trial | |
| Drawing | Beatbolt (`character_drawing_01`) |
| Google Flow: what came out | |
| Google Flow: credits used (free daily credits) | |
| Meshy: model and settings | |
| Meshy: what came out (shape, colours, details) | |
| Meshy: credits used (free plan) | |
| GLB size (MB) and triangles | |
| Rig and clips (idle, run, attack) | |
| Time: author (Flow, Meshy, total) | |
| Time: Claude (import) | |
| Problems | |
| Fit limits (B5) met? | |
| Licence (CC BY 4.0, credit Meshy) | |
| Mattia's preference | |
| Decision: imported or not, and why | |

## Sources

| Fact | Source | Page date | Read |
|------|--------|-----------|------|
| Flow: who can use it (18+, age verified, regions), 50 credits a day without subscription, Chromium browser, SynthID watermark, protections for minors and uploaded photos of people | [Google Flow Help: Get started](https://support.google.com/flow/answer/16353333) | — | 2026-11-22 |
| Flow: credits per plan, daily refresh, images and the Agent without subscription | [Google Flow Help: Manage your credits](https://support.google.com/flow/answer/16526234) | — | 2026-11-22 |
| Flow: Nano Banana built in, images generated for free, lasso edits | [Google blog: New ways to create in Flow](https://blog.google/innovation-and-ai/models-and-research/google-labs/flow-updates-february-2026/) | 2026-02-25 | 2026-11-22 |
| Flow: data use, human reviewers, "Help improve Flow" switch, 18-month retention | [Google Flow Privacy Notice](https://labs.google/flow/privacy) | 2026-05-19 | 2026-11-22 |
| Google: "won't claim ownership" of generated content; no AI output to develop ML models | [Google Terms of Service](https://policies.google.com/terms) | 2026-07-30 | 2026-11-22 |
| Google: Generative AI Prohibited Use Policy | [Prohibited Use Policy](https://policies.google.com/terms/generative-ai/use-policy) | — | 2026-11-22 |
| Meshy: plans, free 100 credits, 10 Meshy 6 Lite downloads, CC BY 4.0 on free, 20 animations free, formats | [Meshy pricing](https://www.meshy.ai/pricing) | — | 2026-11-22 |
| Meshy: credits per action (Image to 3D 10/20/25, rigging 0, animate 0), licence per plan | [Meshy docs: Pricing and credits](https://docs.meshy.ai/en/webapp/pricing) | — | 2026-11-22 |
| Meshy: Image to 3D options (pose, Meshy 6 Lite without texture, multi-view paid, image tips) | [Meshy docs: Image to 3D](https://docs.meshy.ai/en/webapp/image-to-3d) | — | 2026-11-22 |
| Meshy: rig and animate, 600+ presets, T/A-pose, GLB/FBX/USDZ download | [Meshy docs: Animation](https://docs.meshy.ai/en/webapp/guides/animate) | — | 2026-11-22 |
| Meshy: age 14+, no personal data in inputs, training on user content and opt-out, free-plan ownership and CC BY 4.0, Community licences, AI identifiers | [Meshy Terms of Service](https://www.meshy.ai/terms-of-use) | 2026-09-19 | 2026-11-22 |
| Meshy: what is collected and how it is used | [Meshy Privacy Policy](https://www.meshy.ai/privacy-policy) | 2026-09-19 | 2026-11-22 |
| Tripo free plan non-commercial; TRELLIS.2 MIT and 24 GB GPU; Hunyuan3D-2.1 community licence | [Image-to-3D in October 2026 (Littlewolf Labs)](https://news.littlewolflabs.com/posts/2026-10-18-image-to-3d-compared) | 2026-10-18 | 2026-11-22 |
| Hunyuan3D licence territory excludes the EU, UK and South Korea | [Hunyuan3D-2.1 LICENSE](https://raw.githubusercontent.com/Tencent-Hunyuan/Hunyuan3D-2.1/main/LICENSE) | 2025-06-13 | 2026-11-22 |
| Godot 4.7: glTF 2.0 recommended, `.blend`, DAE, OBJ, FBX via ufbx | [Godot docs: Available 3D formats](https://docs.godotengine.org/en/stable/tutorials/assets_pipeline/importing_3d_scenes/available_formats.html) | — | 2026-11-22 |
| CC BY 4.0: what the licence allows and the credit it requires | [Creative Commons: CC BY 4.0](https://creativecommons.org/licenses/by/4.0/) | — | 2026-11-22 |
