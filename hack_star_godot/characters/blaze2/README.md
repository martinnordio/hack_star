# Blaze (hero upgrade) for Godot 4

## Files
| File | Use |
|---|---|
| blaze_hero.png | Full-body character, transparent background (1058 x 1415) |
| blaze_card.png | 512 x 512 portrait for the skin / character card |
| blaze_hero.tscn | Sprite3D version that stands on your 3D podium (feet at origin, ~1.6 units tall, always faces the camera) |
| blaze_hero_ui.tscn | TextureRect version for a pure 2D/Control menu |
| character_preview.gd | Optional: swaps characters on the podium with a pop-in and idle bob |

## Install
1. Copy the `characters/` folder into your project root so the path is `res://characters/blaze/`.
   (If you use another folder, fix the `path=` line at the top of both .tscn files.)
2. Let Godot import. Select `blaze_hero.png` > Import tab: keep Mipmaps on, press Reimport.

## Show it on the podium (3D select screen)
- Instance `blaze_hero.tscn` as a child of the node that sits on the podium top, or
- attach `character_preview.gd` to that node and call:
  `$PodiumAnchor.show_character(preload("res://characters/blaze/blaze_hero.tscn"))`
- Adjust size with `pixel_size` (bigger = taller), height with the node's position.

## Skin card
Set the card's TextureRect texture to `res://characters/blaze/blaze_card.png`
(Expand Mode: Ignore Size, Stretch Mode: Keep Aspect Centered).

## Notes
- This is a 2D image shown in 3D (billboard). It will not rotate or animate like your 3D model.
- For a real 3D model: run blaze_hero.png through an image-to-3D tool, clean/rig in Blender,
  export .glb, drop it in res://characters/blaze/ and instance it instead of blaze_hero.tscn.
