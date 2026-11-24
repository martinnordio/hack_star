# Simple sound-wave projectile. Spawn it, set `direction`, add it to the scene.
# If your game already has a bullet scene, just use echo_projectile.png as its texture.
extends Sprite3D

@export var speed := 12.0
@export var lifetime := 1.2
var direction := Vector3.FORWARD

func _ready() -> void:
	# lie flat on the ground and point the wave along the travel direction
	rotation.y = atan2(-direction.z, direction.x)

func _physics_process(delta: float) -> void:
	global_position += direction.normalized() * speed * delta
	lifetime -= delta
	if lifetime <= 0.0:
		queue_free()
