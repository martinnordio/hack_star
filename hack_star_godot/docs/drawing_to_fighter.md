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

## Picture fighters (Flarekid, Echo)

A drawing can also join the game as a **picture fighter**: the author makes a full-body picture
and a card picture from it with an AI image tool, and the game shows the picture itself instead
of a figure built from shapes. Flarekid (`characters/blaze2/`) and Echo (`characters/echo/`) are
the first two (spec 09, part C).

### What the game does with one picture

- **Look:** the full-body picture stands on an outlined quad that always turns to the camera
  (`scenes/toon/cutout.gdshader`), with a soft round shadow; the card picture is shown as it is on
  the fighter card and the skin button (`CutoutFighters`, `scenes/cutout/cutout_fighters.gd`).
- **Moves** (`CutoutMotion`, `scenes/cutout/cutout_motion.gd`): it pops in on the pedestal;
  standing, it breathes, bobs and sways; running, it hops with a squash on landing and leans
  forward; it is mirrored to look left or right with the movement (and keeps its last facing when
  going straight up or down); a shot gives a recoil and a star at its muzzle, a hit a short white
  flash, a knock-out tips it over and fades it; in a bush it is see-through.

### What a single picture cannot do

- **No side or back view:** the picture always shows its front; it never really turns, it is only
  mirrored. Going up the arena it still looks at the player.
- **No drawn run, shot or hit:** the hop, lean, recoil and flash move and colour the whole
  picture; the legs never step and the arm never aims.
- **One pose for everything:** the pose of the picture (Echo crouching, Flarekid holding his
  fireball) is the pose in every moment, also on a card.

### What the author can make to improve it

With the same image tool, from the same picture (same character, same style), as **transparent
PNGs of the same height with the feet at the same point**:

| File (in `characters/<folder>/`) | What it is | What the game then does |
|---|---|---|
| `<name>_side.png`, `<name>_back.png` | A side and a back view | Shows the side view when running left or right and the back view when running up the arena |
| `<name>_run1.png` … `<name>_run8.png` | A run cycle of 4–8 frames | Swaps the frames while running instead of the hop alone |
| `<name>_shot.png` | A shot pose | Shows it for the recoil of each shot |
| `<name>_hit.png` | A hit pose | Shows it with the white flash |

Or a **3D model** (GLB with a skeleton and animations) through the workflow of
[drawing tools](drawing_tools.md) (Google Flow → Meshy → Claude in Godot): it replaces the
picture, and the fighter turns and moves like the fighters built from shapes.

The frames are swapped by the picture fighter's animation (one texture per pose on the same quad,
so the outline, the flip, the flash and the see-through keep working). Adding them is a later
spec; the author's directional gameplay frames in `characters/echo_new/gameplay/frames/` (idle,
walk and shoot looking down, up and to the side) are such a set, waiting for it (spec 09, D31).

### Art the author has already dropped (for a follow-up)

While spec 09 was being built, the author put newer art next to the two picture fighters. It is
**not used yet**, not committed and kept out of the web export (`exclude_filter`:
`characters/*_new/*`, `characters/magmax*/*`, `characters/*.zip`; spec 09, D31), so a follow-up
spec can pick it up as it is:

| Folder | What is there | What a follow-up can do with it |
|---|---|---|
| `characters/echo_new/` | A new hero and card picture of Echo, and `gameplay/frames/`: `echo_<down\|side\|up>_<idle\|walk1\|walk2\|shoot>.png` (directional idle, two walk frames and a shoot pose), a projectile picture, an animation preview and the author's own `SpriteFrames` scene | Echo's in-play animation: the side, back and front views and the walk and shot frames of the table above, chosen by the running direction |
| `characters/blaze_new/` | The same for Flarekid (Blaze's upgrade): a new hero and card picture and `gameplay/frames/blaze_<down\|side\|up>_<idle\|walk1\|walk2\|shoot>.png`, a projectile, a preview | Flarekid's in-play animation, the same way |
| `characters/magmax/` | A hero and a card picture of a new character, **Magmax** | A third picture fighter (*Add a picture fighter* below) |
| `characters/magmax_new/` | Magmax's newer pictures with the same `gameplay/frames/` set | Magmax with its in-play animation from the start |

What such a spec does: import the frames as in step 1 of *Add a picture fighter* (not
VRAM-compressed, within the web size budget — the frames of the three folders are 36 PNGs, about 8.2 MB, so they need lossy WebP and a `size_limit`), give `CutoutFighters` one texture per pose
and direction and let `CutoutMotion` choose it, keep the author's preview scripts and scenes out of
the export, and credit every picture in `LICENSES.md` (which tool made it — still to be confirmed
by the author for Flarekid and Echo).

### Add a picture fighter

1. Put the two pictures (`<name>_hero.png`, `<name>_card.png`, transparent background) in a new
   folder `characters/<folder>/`. In the import dock: not VRAM-compressed (`compress/mode`
   lossless, or lossy WebP 0.9 for the hero if the export grows too much), `detect_3d` off,
   `size_limit` 768 for the hero (with mipmaps) and 256 for the card; re-import.
2. Add its row to `CutoutFighters.FIGHTERS`: `hero`, `card`, `height` (metres, 2.5–2.7 to stand
   as tall as the others), `feet` (the feet point of the picture in UV, feet at the bottom),
   `main` (its main colour, different from every other fighter's), `faces_left` (true when the
   picture looks to the left) and `muzzle` (where its shot leaves the picture, UV).
3. Add its entry to `Fighters.LIST` (`"unlocked": true`, `"cutout": true`, one `default` skin,
   `"plays_like"` an existing fighter) and its two lines to `game/sample_progress.gd` (0 trophies,
   power level 1).
4. Add a row per picture to `LICENSES.md` (who made it, from which drawing, with which tool).
5. Keep the files the game does not use out of the web export (`exclude_filter` in
   `export_presets.cfg`), then run `tools/test.ps1`, `tools/lint.ps1` and `tools/export_web.ps1`
   (the export must stay within its size budget; see the README).

### Remove a picture fighter

Delete its row in `CutoutFighters.FIGHTERS`, its entry in `Fighters.LIST`, its two lines in
`game/sample_progress.gd` and its rows in `LICENSES.md`; the folder can stay or go. A save that
chose it falls back to the default fighter, as for a drawn fighter above.
