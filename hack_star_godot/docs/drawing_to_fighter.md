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
