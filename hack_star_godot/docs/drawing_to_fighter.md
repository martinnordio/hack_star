# From a drawing to a fighter

How a child's drawing becomes a fighter of the Godot game, done by Claude via Copilot with no
other tool (spec 09, part A). The first one is **Beatbolt**, from Mattia's drawing. For a
workflow with image and 3D tools, see [drawing_tools.md](drawing_tools.md) (part B).

## 1. Photograph the drawing

- Only the drawing: lay the whole sheet flat, in daylight, on a plain surface, and photograph it
  from straight above, with nothing else in the picture.
- **No people, faces, full names, addresses or places** in the photo, and no writing on the
  drawing that tells who drew it (a first name or a nickname is chosen later, for the credit).
- Remove the photo's metadata (location/GPS, camera, date): on Windows *Properties → Details →
  Remove Properties and Personal Information*, or send a screenshot of the photo. Claude removes
  it again anyway (step 3).
- The drawing must be the child's own idea — not a character copied from a game, film, book or
  brand.

## 2. Put it where Claude finds it

Save the photo as `%USERPROFILE%\hack_star_drawings\<something>.jpg` (or `.png`), **outside the
repository**, or attach it in the chat. The original photo is never committed.

Decide three things (or let Claude suggest them):

- the fighter's **name**: 1–12 letters, not the name of an existing fighter, a game, a film or a
  brand;
- the **existing fighter** whose attack, rarity and starting numbers (trophies, power) it copies — every
  fighter shoots with the same rules today, so this is the fighter it "plays like";
- the **first name or nickname** for the credit in `LICENSES.md`.

## 3. Ask Claude

Open Copilot (CLI or chat) in the repository on the branch of the spec that adds the fighter, and
give this request (replace the parts in `<…>`):

> Turn the drawing `%USERPROFILE%\hack_star_drawings\<file>` into a new fighter of the Godot game,
> following `hack_star_godot/docs/drawing_to_fighter.md`. Name: `<Name>`; it copies the attack,
> rarity and starting numbers of `<fighter>`; credit: "`<first name or nickname>` (drawing)".
> Re-encode the photo with Godot's `Image` (at most 1024 px, PNG, outside the repository) and
> check that it shows only the drawing. Build the fighter from shapes in
> `scenes/drawn/<id>_model.gd` with the toon materials, register it in
> `scenes/drawn/drawn_fighters.gd`, add it to `Fighters.LIST` (`drawn: true`, unlocked, one
> default skin) and `SampleProgress`, credit it in `LICENSES.md`, compare
> screenshots of the card, the fighter screen, home and a match with the photo until it reads
> like the drawing, and run `tools/test.ps1` and `tools/lint.ps1`. Do not commit the photo.

What Claude then does:

1. **Re-encodes the photo** with Godot's `Image` (load → shrink to at most 1024 px → `save_png`)
   into a folder outside the repository (`%USERPROFILE%\hack_star_drawings\` or
   `%LOCALAPPDATA%\hack_star\`). The new PNG has no metadata. Claude looks at it and stops if it
   shows anything but the drawing.
2. **Reads the drawing**: the main shapes (head, hair, body, arms, legs, a hat, a weapon…) and
   their colours, written down in the spec's Notes (no personal data).
3. **Builds the fighter from shapes** — spheres, capsules, cones, boxes and rings — in
   `scenes/drawn/<id>_model.gd`, with the game's cel-shaded, dark-outlined materials
   (`ToonMaterials`) and the same idle, run and attack animations and see-through in a bush as the
   other fighters (`FighterModel` does them). It is scaled so that it is about as tall as the
   others and its health bar stays visible in a match (Beatbolt: 0.85, for his big hair).
4. **Adds it to the game** in three places: the row in `scenes/drawn/drawn_fighters.gd`, the
   entry in `game/fighters.gd` (`Fighters.LIST`, `"drawn": true`, unlocked, one `default` skin,
   the copied rarity, `"plays_like"` naming the fighter it copies) and the starting numbers in
   `game/sample_progress.gd`. The look file also names the parts that make the drawing
   recognisable (`IDEA_PARTS`, e.g. Beatbolt's hair, pink streak, headphones and arm cannon),
   which the tests look for. It is unlocked for every player, old saves included, and appears in
   the fighter list, the fighter screen, home, Training and matches (also as a bot).
5. **Credits it** in `LICENSES.md` as the child's own work under the repository's MIT licence.
6. **Checks the look on screenshots** (a game window, not headless) next to the photo, improves
   the shapes until the fighter reads like the drawing, and runs the tests and the linter.
7. **Shows you the screenshots**: the child says whether "this is my drawing"; Claude changes
   what the child points at.

## What the result can and cannot be

- **One drawing per run.**
- **Front view only:** the drawing shows the front; the sides and the back are guessed.
- **Shapes, not lines:** the fighter is made of simple round and straight shapes in the drawing's
  main colours. Fine lines, textures, shading, patterns and writing of the drawing are not copied;
  small details (a logo, freckles) become a dot or are left out. A pose in the drawing (crouching,
  jumping) becomes the game's standing pose, which the animations need.
- **A fighter, not a new attack:** it copies the attack and the numbers of an existing fighter;
  new attacks, skins (spec 10) or abilities are other specs.
- **Name:** 1–12 letters.
- **Cut-out fallback:** only when a drawing is too detailed for shapes, the re-encoded picture is
  shown as a flat, outlined paper figure that bobs and turns (then the PNG joins the repository).
  Shapes are always tried first.

## How long it takes

- **You:** about 5 minutes to photograph the drawing and answer the three questions, and about
  10 minutes with the child to look at the screenshots.
- **Claude:** about 30–60 minutes on its own (reading the drawing, building the shapes, a few
  rounds of screenshots, tests), plus a short round for each change the child asks for.

## Add another drawing

Do sections 1–3 again with the new drawing: one drawing per run, each in its own look file. A new
drawn fighter touches only its own places, never another fighter:

1. a new file `scenes/drawn/<id>_model.gd` (copy the structure of `beatbolt_model.gd`: `LOOKS`,
   `IDEA_PARTS`, a static `build`);
2. one new row in `DrawnFighters.MODELS` (`scenes/drawn/drawn_fighters.gd`);
3. one new entry at the end of `Fighters.LIST` (`game/fighters.gd`) and its two numbers in
   `game/sample_progress.gd` (`TROPHIES`, `POWER_LEVELS`);
4. a row in `LICENSES.md` (*Own work*).

The tests need no change: `tests/test_drawn_fighter.gd` checks every drawn fighter (unlocked, one
Default skin, a 1–12 letter name, the numbers of the fighter it plays like, its look file and its
`IDEA_PARTS`, old saves) and plays the first one on home, in Training and in a match;
`test_drawn_fighters_change_no_other_fighter` checks that the six original fighters keep their
order, names, rarities, skins, start numbers and looks. The fighter's main colour must differ
from every other fighter's (`test_fighter_model.gd`).

## Remove a drawn fighter

Delete the fighter's places, and nothing else:

1. the file `scenes/drawn/<id>_model.gd` and its `.gd.uid`;
2. its row in `DrawnFighters.MODELS` (with the last one gone: `const MODELS: Dictionary[String,
   GDScript] = {}`);
3. its entry in `Fighters.LIST` and its two lines in `game/sample_progress.gd`;
4. its row in `LICENSES.md`, and its mentions in the docs (this file, `docs/architecture.md`).

Then run `tools/test.ps1` and `tools/lint.ps1`. A player whose save chose the removed fighter gets
the default fighter (Blaze) at the next start, and keeps everything else: the save file is read
field by field and unknown fighters are left out (`SaveData`, spec 08). Checked by
`test_a_save_that_chose_a_removed_drawn_fighter_falls_back_to_the_default`, and by a dry run that
removed Beatbolt from a copy of the project: all tests passed.

## Picture fighters (Flarekid, Echo, MagMax)

A character can also join the game as a **picture fighter**: the author makes its pictures with
an AI image tool (from Mattia's drawing or his own idea), and the game shows those pictures
instead of a figure built from shapes. Flarekid (`characters/blaze2/`), Echo (`characters/echo/`)
and MagMax (`characters/magmax2/`) are the three of them (spec 09, parts C and M); each comes
from one delivery of **12 gameplay frames, a card, a hero picture and a projectile**.

### How the animated fighters work

- **Frames** (`CutoutFighters`, `scenes/cutout/cutout_fighters.gd`): each fighter's row names its
  card (preloaded), its delivered `SpriteFrames` (`gameplay/<name>_frames.tres`: `idle_`,
  `walk_` and `shoot_` × `down` = front, `up` = back, `side` = looking right) and its projectile
  picture; frames and projectile are loaded the first time the fighter is shown and kept, so only
  the fighters in use are in memory. The row also says how tall the figure stands
  (`figure_height`, metres), where its feet and its top are in the frames (`feet`, `top`) and,
  per view, where its shot leaves the shoot frame (`muzzle`). The frame stands on an outlined quad
  that always faces the camera (`scenes/toon/cutout.gdshader`) with a soft round shadow.
- **In play** (`CutoutAnimator`, `scenes/cutout/cutout_animator.gd`): moving up the screen shows
  the back, down the front, left or right the side (mirrored for left); standing still keeps the
  last view (the front at the start). Walking plays the view's walk loop (walk 1, idle, walk 2,
  idle) at a pace from the speed with a small hop; standing shows the view's idle frame and
  breathes. Every shot (the player's and the bots') turns the fighter to the shot's view and shows
  its shoot frame for 0.25 s with a star at the fist, blaster or fireball. The camera never turns,
  so this is the same in all four camera views. The white hit flash, the see-through in a bush,
  the knock-out (tip over and fade) and the bar over the head work in every frame.
- **Projectiles** (`Shot`, `scenes/toon/projectile.gdshader`): their shots fly as their own
  picture (lava fist, sound wave, fireball), 1 m long, turned along the flight and facing the
  camera; speed, range, damage and walls as every other shot.
- **On the pedestal** (`CutoutShowcase`, `scenes/cutout/cutout_showcase.gd`; home, the fighter
  screen, the result): after the pop-in, a 7 s loop — idle, a turn through front, side, back and
  the other side, walk steps on the spot, a side shot with the projectile and sparks, idle. On the
  fighter screen a drag left or right turns the fighter and a tap or click makes it shoot (mouse
  and touch); the loop starts again 3 s later.
- **Living cards** (`FighterCard`, `scenes/ui/card_figure.gdshader`, `scenes/ui/card_sweep.gdshader`):
  on the fighter list a small outlined figure idles and walks on the card picture and a light sweep
  in the rarity colour crosses it every 4 s — only while the card is visible; a locked card stays
  grey and still.
- **Not used:** the hero picture (its pose does not match the frames, so switching to them jumped)
  and the delivery's preview sheet, example scripts and scenes; they stay in the folder but are not
  in the web export.

### Add an animated fighter from a delivery

The delivery is the same kind as the three: a folder with `<name>_hero.png`, `<name>_card.png`
(512 × 512) and `gameplay/` with `frames/<name>_<down|side|up>_<idle|walk1|walk2|shoot>.png`
(12 transparent PNGs of one size, the feet at the bottom centre, the side frames looking right),
`<name>_frames.tres` (a `SpriteFrames` with the animations `idle_`, `walk_` and `shoot_` × `down`,
`up`, `side`; the walk animation in the order walk 1, idle, walk 2, idle) and
`<name>_projectile.png` (flying to the right).

1. **Folder and paths:** move (not copy) the delivery to `characters/<folder>/` (a folder name
   that no other fighter uses). Every `res://` path in its `.tscn`, `.tres`, `.gd` and README must
   point to that folder; delete the delivered `.import` files of the pictures so Godot writes its
   own, then open the editor or run `tools/test.ps1` once to import.
2. **Imports** (import dock, *Reimport*; all not VRAM-compressed, `detect_3d/compress_to`
   disabled): the **frames** lossy WebP 0.85 with mipmaps and `process/size_limit` 448; the
   **card** lossless, `size_limit` 256; the **projectile** lossless with mipmaps. The hero picture
   is not exported, so its import does not matter.
3. **`CutoutFighters.FIGHTERS`** (`scenes/cutout/cutout_fighters.gd`): a row with `card`
   (`preload`), `frames` and `projectile` (paths), `figure_height` (2.5–2.7 m to stand as tall as
   the others), `feet` (usually `Vector2(0.5, 0.993)`), `top` (where the head starts in the
   `idle_down` frame, UV y), `main` (its main colour, at least 0.1 from every other fighter's — a
   test checks) and `muzzle` per view (`down`, `up`, `side`: where the shot leaves the shoot frame,
   UV).
4. **`Fighters.LIST`** (`game/fighters.gd`): its entry (`"unlocked": true`, `"cutout": true`, one
   `default` skin, a rarity, `"plays_like"` an existing fighter) and its two lines in
   `game/sample_progress.gd` (0 trophies, power level 1). Old saves get it at the next start.
5. **`LICENSES.md`:** a row per picture (hero, card, the 12 frames, projectile) — who made it,
   from which drawing or idea, with which tool.
6. **Export filter** (`export_presets.cfg`, `exclude_filter`): the existing patterns
   (`characters/*/*_hero.png`, `characters/*/gameplay/*_animation_preview.png`, `*_animator.gd`,
   `*_gameplay.tscn`, `*_projectile.gd`, `*_projectile.tscn`, `character_preview.gd`, the README)
   already keep the unused files of a delivery with the same names out; add a pattern for any other
   file the game does not use.
7. Run `tools/test.ps1`, `tools/lint.ps1` and `tools/export_web.ps1`: the export must stay within
   its size budget (see the README; the three fighters take about 0.9 MB each).

A character without frames (one picture only) cannot turn, walk or shoot this way; ask the image
tool for the full set of 12 frames of the same character in the same style.

### Remove a picture fighter

Delete its row in `CutoutFighters.FIGHTERS`, its entry in `Fighters.LIST`, its two lines in
`game/sample_progress.gd` and its rows in `LICENSES.md`; the folder can stay or go. A save that
chose it falls back to the default fighter, as for a drawn fighter above.
