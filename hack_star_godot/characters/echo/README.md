# Echo for Godot 4: menu + in-game (multi-view, animated)

## Folder
characters/echo/
  echo_hero.png, echo_card.png, echo_hero.tscn, echo_hero_ui.tscn, character_preview.gd   <- character-select (same as before)
  gameplay/
    frames/                      12 frames (592 x 503, transparent, feet aligned at the bottom centre)
      echo_down_*.png            front view  (moving toward the camera / S key)
      echo_up_*.png              back view   (moving away from the camera / W key)  <- default in-game view
      echo_side_*.png            side view facing right (D key); mirrored automatically for left (A key)
        each view: idle, walk1, walk2, shoot
    echo_frames.tres             SpriteFrames: idle_up/down/side, walk_up/down/side (4-frame loop), shoot_up/down/side
    echo_gameplay.tscn           AnimatedSprite3D (billboard, ~1.3 units tall, feet at origin) + animator script
    echo_animator.gd             chooses view + animation from the player's velocity, plays shoot pose, small walk hop
    echo_projectile.png/.tscn/.gd   sound-wave bullet lying flat on the floor
    echo_animation_preview.png   all 12 frames at a glance

## Install
Unzip and copy `characters/` into your project root (replace the old echo folder; nothing else is touched).

## Use in the arena
1. Open your player scene (the CharacterBody3D that moves with WASD).
2. Hide/remove the current 3D model for Echo and instance `res://characters/echo/gameplay/echo_gameplay.tscn` as a child.
3. Press F5. The script reads the body's `velocity` automatically:
   W -> back view walking, S -> front view, A/D -> side view (mirrored for A), stop -> idle in last direction.
   Space (or your "shoot" input action) -> shoot pose for 0.25 s.
4. Size: change `pixel_size` on the Sprite node (0.0027 ~= 1.3 units). Raise/lower the node if the feet float.

## Driving it from your own code (optional)
Turn off `auto_from_parent` / `auto_shoot_input` in the Inspector and call:
  $EchoGameplay/Sprite.set_motion(velocity)
  $EchoGameplay/Sprite.play_shoot(aim_direction)

## Projectile
If your game already spawns bullets, just set their texture to `gameplay/echo_projectile.png`.
Otherwise: var p = preload("res://characters/echo/gameplay/echo_projectile.tscn").instantiate()
           p.direction = aim_dir; get_tree().current_scene.add_child(p); p.global_position = muzzle_pos

## Assumptions
- Camera looks toward -Z (up the screen), as in your arena. If W moves along +Z in your game, swap "up"/"down" in _set_facing_from().
- Diagonal movement uses the closest of front / back / side.
