# Echo (sound-powered hero) for Godot 4

Echo is a sound-powered hero: glowing teal headphones that send out sound waves, a "sound blaster" staff,
and neon-soled sneakers. Built from your hand-drawn sketch.

## Files
| File | Use |
|---|---|
| echo_hero.png | Full-body character, transparent background (1088 x 1431) |
| echo_card.png | 512 x 512 portrait for the character / skin card |
| echo_hero.tscn | Sprite3D that stands on your 3D podium (feet at origin, ~1.3 units tall, faces the camera) |
| echo_hero_ui.tscn | TextureRect version for a 2D/Control menu |
| character_preview.gd | Optional: swaps characters on the podium with a pop-in and idle bob (same script as Blaze) |

## Install
1. Copy the `characters/` folder into your project root (next to project.godot) so the path is `res://characters/echo/`.
   It sits next to `res://characters/blaze/` without conflicts.
2. Open the project; Godot imports everything automatically.

## Show it on the podium
`$PodiumAnchor.show_character(preload("res://characters/echo/echo_hero.tscn"))`
Change `pixel_size` on the Sprite3D to make Echo bigger or smaller.

## Skin card
Set the card's TextureRect texture to `res://characters/echo/echo_card.png`
(Expand Mode: Ignore Size, Stretch Mode: Keep Aspect Centered).

## Note
This is a 2D image shown in 3D (billboard); it does not rotate or animate like a 3D model.
