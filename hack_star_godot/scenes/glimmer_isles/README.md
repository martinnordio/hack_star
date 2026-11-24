# Glimmer Isles - Godot 4 palette pack

## In Hack star
The pack lives in `scenes/glimmer_isles/` of the Godot game (`res://scenes/glimmer_isles/`), next
to the world itself (`scenes/worlds/glimmer_isles/`). The world Glimmer Isles uses the palette
(`GlimmerPalette`), the materials, the environment and the lighting scene for its colours, sky and
light. The UI theme is kept with the pack but not used: the game's screens keep their own theme.
Only what the game uses is in the web export (not the palette picture, the `.gpl`, `.hex` and
`.json` files, this README or the UI theme). Made by the author, under the repository's licence
(MIT; see `LICENSES.md`).

## Files
- `glimmer_palette.gd` - all 66 colours as constants (`GlimmerPalette.MAGENTA_CAP`, `GlimmerPalette.ALL["lagoon"]`).
- `glimmer_isles_environment.tres` - sky, ambient light, fog, glow and colour boost. Drop on your WorldEnvironment.
- `glimmer_isles_lighting.tscn` - ready WorldEnvironment + warm sun + soft violet magic fill light. Instance it in your arena scene (remove the old WorldEnvironment/DirectionalLight3D).
- `glimmer_isles_ui_theme.tres` - buttons, panels and labels. Project Settings > GUI > Theme > Custom, or set `theme` on your root Control.
- `materials/` - water, waterfall, grass, leaf, moss, stone, sand, mushroom_cap, mushroom_stem, glow_mushroom, crystal_gold.
- `glimmer_isles.gpl` / `.hex` / `.json` - the same palette for Aseprite, Krita, GIMP, Photoshop (via Lospec) or tools.

## Colour roles
| Group | Colours (dark to light) |
|---|---|
| Lagoon Water | deep_lagoon `#0B3C5D`, lagoon `#0E6E8C`, shallow_water `#14A3B8`, turquoise `#3FD0D4`, waterfall_light `#8BEFE6`, foam `#E0FFFB` |
| Sky & Mist | night_sky `#2A2350`, twilight `#4B3F8C`, dream_violet `#7C6FD6`, day_sky `#A9C8FF`, blush_cloud `#FFD6E8`, sun_mist `#FFF4D6` |
| Leaves & Grass | deep_jungle `#12352B`, forest `#1F5E3B`, leaf `#2E8B47`, grass `#5CC14F`, spring `#A6E35A`, sunlit_leaf `#E4F98B` |
| Ferns & Moss | moss_shadow `#0F4A47`, fern `#1B7A6E`, jade `#2FB39A`, mint `#6FE0C0`, dew `#B8F5E0`, pale_mint `#E6FFF5` |
| Mushroom Caps | berry_shadow `#5A1846`, plum_cap `#9B2D6F`, magenta_cap `#D6458F`, bubblegum `#FF77B7`, pink_spot `#FFB3D9`, cap_highlight `#FFE3F1` |
| Glow Mushrooms | glow_deep `#3B1E77`, glow_violet `#6A3FD1`, glow_lilac `#9D7BFF`, glow_cyan `#4FF2E3`, glow_lime `#C6FF6B`, glow_core `#F4FFFC` |
| Stems & Roots | root_dark `#3E2A24`, bark `#6B4E3D`, stem `#A67C5B`, stem_light `#D9B48F`, cream `#F2DFC2`, ivory `#FFF6E6` |
| Cliffs & Stone | stone_shadow `#23233A`, cliff `#3B3D5C`, stone `#5C6185`, pebble `#8790B0`, stone_light `#B9C2D9`, stone_glint `#E3E8F5` |
| Sand & Paths | earth_dark `#4A2E2A`, earth `#7A4B35`, path `#B07A4F`, sand `#DDAE74`, beach `#F2D49B`, shell `#FFF0C9` |
| Glimmer Gold | amber_dark `#8A4B00`, amber `#D98A00`, gold `#FFB627`, sunbeam `#FFD95A`, sparkle `#FFF1A8`, star_white `#FFFDF0` |
| UI & Gameplay | ui_outline `#0E0F1F`, ui_panel `#1A1B33`, info_blue `#3DA5FF`, energy_green `#2EE6A8`, warning_orange `#FF8A3D`, health_red `#FF4D5E` |

## Tips
- Keep the arena floor mid-tones (grass, sand, path) so heroes and projectiles pop.
- Only glow items use the Glow Mushrooms / Glimmer Gold colours with emission; glow is enabled in the environment.
- Shadows: use the darkest colour of each ramp, never pure black. Outlines: `ui_outline`.
- In code: `$Ground.material_override.albedo_color = GlimmerPalette.GRASS`.
