class_name Fighter
extends CharacterBody3D
## A fighter that walks on the ground plane. The arena sets `input_direction` every physics
## frame from the keyboard and the touch joystick; tests may set it directly.

@export var speed_per_second: float = 5.0
## The fighter counts as running above this speed (m/s).
@export var running_speed: float = 0.1

## Direction from the keyboard or the joystick, length at most 1.
var input_direction: Vector2 = Vector2.ZERO

@onready var model: FighterModel = $Model
@onready var muzzle: Marker3D = $Muzzle


## Shows a fighter in a skin (the arena calls this with the player's choice).
func set_look(fighter_id: String, skin_id: String) -> void:
	model.setup(fighter_id, skin_id)


func _physics_process(_delta: float) -> void:
	velocity = Movement.velocity(input_direction, speed_per_second)
	move_and_slide()
	model.running = velocity.length() > running_speed
	if not input_direction.is_zero_approx():
		rotation.y = Movement.facing_yaw(input_direction)
