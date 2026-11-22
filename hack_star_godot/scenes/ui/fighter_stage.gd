class_name FighterStage
extends SubViewportContainer
## A live 3D fighter inside a 2D screen: a sub-viewport with its own 3D world, a camera, two
## lights and one `FighterModel`, standing on a round pedestal (spec 09, D6). The camera keeps
## the whole fighter (and the pedestal) in view whether the stage is wide or tall. On a pedestal
## (home, the fighter screen, the result) every fighter shown pops in with the reveal (C3, D23).

const PEDESTAL_SIDE: Color = Color(0.25, 0.27, 0.68)
const PEDESTAL_RIM: Color = Color(0.96, 0.82, 0.52)
const PEDESTAL_TOP: Color = Color(0.5, 0.5, 0.88)
const PEDESTAL_HEIGHT: float = 0.32
## The camera when the pedestal shows: a little farther and higher, so its front edge is in view.
const PEDESTAL_CAMERA_POSITION: Vector3 = Vector3(0.0, 1.75, 7.4)
const PEDESTAL_CAMERA_TILT: float = -0.1
## The reveal (spec 09, C3, D23): the fighter grows from this scale to its size with a short
## overshoot (`TRANS_BACK`), sparks burst and a halo in the rarity colour flares and settles.
const REVEAL_SECONDS: float = 0.45
const REVEAL_START_SCALE: float = 0.3
const REVEAL_SPARKS: int = 24
const HALO_SIZE: Vector2 = Vector2(3.6, 4.0)
const HALO_POSITION: Vector3 = Vector3(0.0, 1.35, -0.9)
const HALO_FLARE_SECONDS: float = 0.15
const HALO_FLARE_SCALE: float = 1.2
const HALO_SETTLE_SECONDS: float = 0.45
## How strong the halo stays behind the fighter once the reveal is over.
const HALO_ALPHA: float = 0.55
## The most the reveal moves on in one frame (seconds).
const MAX_REVEAL_STEP: float = 1.0 / 30.0

## The fighter stands on a pedestal. Off for the card pictures (set before the stage is added).
@export var pedestal: bool = true

var model: FighterModel:
	get:
		return $Viewport/FighterModel

## Seconds into the reveal; below 0 when none plays.
var _reveal_time: float = -1.0
var _reveal_pop: bool = true
## The fighter and skin shown last.
var _shown: Array[String] = []
var _halo: MeshInstance3D
var _sparks: CPUParticles3D

@onready var camera: Camera3D = $Viewport/Camera


func _ready() -> void:
	if pedestal:
		_build_pedestal()
		_build_reveal()
		camera.position = PEDESTAL_CAMERA_POSITION
		camera.rotation.x = PEDESTAL_CAMERA_TILT
	resized.connect(_fit_camera)
	_fit_camera()


## Shows a fighter in one of its skins; on a pedestal it pops in with the reveal. Showing the same
## fighter and skin again (home refreshes on every change of progress) changes nothing.
func show_fighter(fighter_id: String, skin_id: String = Fighters.DEFAULT_SKIN) -> void:
	if _shown == [fighter_id, skin_id]:
		return
	_shown = [fighter_id, skin_id]
	_kill_reveal()
	model.setup(fighter_id, skin_id)
	if pedestal:
		reveal()


## The halo behind the fighter (null without a pedestal).
func get_halo() -> MeshInstance3D:
	return _halo


## The burst of sparks of the reveal (null without a pedestal).
func get_sparks() -> CPUParticles3D:
	return _sparks


## Plays the reveal of the shown fighter in its rarity colour. With `pop` false only the sparks and
## the halo play (home's entrance drops the fighter in on its own).
func reveal(pop: bool = true) -> void:
	if _halo == null:
		return
	_kill_reveal()
	var color: Color = rarity_color()
	(_sparks.material_override as StandardMaterial3D).albedo_color = color.lightened(0.35)
	_sparks.visible = true
	_sparks.restart()
	_reveal_pop = pop
	_reveal_time = 0.0
	_apply_reveal(0.0)


## Hides the halo and stops the reveal (home's entrance, before the fighter lands).
func hide_reveal() -> void:
	_kill_reveal()
	if _halo != null:
		_halo.scale = Vector3.ZERO
		# Stopped particles keep showing their last frame, so the sparks in the air are hidden.
		_sparks.emitting = false
		_sparks.visible = false


## Jumps to the end of the reveal: the fighter at its size, the halo settled.
func finish_reveal() -> void:
	_kill_reveal()
	if _halo != null:
		_apply_reveal(HALO_FLARE_SECONDS + HALO_SETTLE_SECONDS)


## True while the reveal plays.
func is_revealing() -> bool:
	return _reveal_time >= 0.0


## The colour of the shown fighter's rarity (`Rarity`).
func rarity_color() -> Color:
	return Rarity.color(Fighters.get_fighter(model.fighter_id).get("rarity", ""))


# The reveal's own clock takes at most one 30th of a second per frame, so the hitch of a screen's
# first frame slows the pop down instead of skipping it.
func _process(delta: float) -> void:
	if _reveal_time < 0.0:
		return
	_reveal_time += minf(delta, MAX_REVEAL_STEP)
	_apply_reveal(_reveal_time)
	if _reveal_time >= maxf(REVEAL_SECONDS, HALO_FLARE_SECONDS + HALO_SETTLE_SECONDS):
		_reveal_time = -1.0


# The reveal at `time` seconds: the pop (if any), and the halo that flares, then settles.
func _apply_reveal(time: float) -> void:
	if _reveal_pop and model.get_rig() != null:
		var grow: float = Tween.interpolate_value(
			REVEAL_START_SCALE,
			1.0 - REVEAL_START_SCALE,
			minf(time, REVEAL_SECONDS),
			REVEAL_SECONDS,
			Tween.TRANS_BACK,
			Tween.EASE_OUT
		)
		model.get_rig().scale = Vector3.ONE * grow
	var halo_scale: float
	var halo_alpha: float
	if time < HALO_FLARE_SECONDS:
		halo_scale = Tween.interpolate_value(
			0.0, HALO_FLARE_SCALE, time, HALO_FLARE_SECONDS, Tween.TRANS_CUBIC, Tween.EASE_OUT
		)
		halo_alpha = 1.0
	else:
		var settle: float = minf(time - HALO_FLARE_SECONDS, HALO_SETTLE_SECONDS)
		halo_scale = Tween.interpolate_value(
			HALO_FLARE_SCALE,
			1.0 - HALO_FLARE_SCALE,
			settle,
			HALO_SETTLE_SECONDS,
			Tween.TRANS_SINE,
			Tween.EASE_IN_OUT
		)
		halo_alpha = lerpf(1.0, HALO_ALPHA, settle / HALO_SETTLE_SECONDS)
	_halo.scale = Vector3.ONE * halo_scale
	var halo_material: StandardMaterial3D = _halo.material_override
	halo_material.albedo_color = Color(rarity_color(), halo_alpha)


func _kill_reveal() -> void:
	_reveal_time = -1.0
	if model.get_rig() != null:
		model.get_rig().scale = Vector3.ONE


# The halo (a soft radial glow facing the camera, behind the fighter) and the sparks; coloured on
# each reveal. CPU particles: GPU particles are limited on WebGL with the Compatibility renderer.
func _build_reveal() -> void:
	var root: Node3D = Node3D.new()
	root.name = "Reveal"
	$Viewport.add_child(root)
	var glow: GradientTexture2D = GradientTexture2D.new()
	glow.fill = GradientTexture2D.FILL_RADIAL
	glow.fill_from = Vector2(0.5, 0.5)
	glow.fill_to = Vector2(0.5, 0.0)
	glow.gradient = Gradient.new()
	glow.gradient.set_color(0, Color(1.0, 1.0, 1.0, 0.9))
	glow.gradient.set_color(1, Color(1.0, 1.0, 1.0, 0.0))
	var halo_material: StandardMaterial3D = StandardMaterial3D.new()
	halo_material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	halo_material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	halo_material.billboard_mode = BaseMaterial3D.BILLBOARD_ENABLED
	halo_material.billboard_keep_scale = true
	halo_material.albedo_texture = glow
	var halo_quad: QuadMesh = QuadMesh.new()
	halo_quad.size = HALO_SIZE
	_halo = MeshInstance3D.new()
	_halo.name = "Halo"
	_halo.mesh = halo_quad
	_halo.material_override = halo_material
	_halo.position = HALO_POSITION
	_halo.scale = Vector3.ZERO
	_halo.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	root.add_child(_halo)

	_sparks = CPUParticles3D.new()
	_sparks.name = "Sparks"
	_sparks.position = Vector3(0.0, 1.0, 0.0)
	_sparks.emitting = false
	_sparks.one_shot = true
	_sparks.explosiveness = 1.0
	_sparks.amount = REVEAL_SPARKS
	_sparks.lifetime = 0.9
	_sparks.emission_shape = CPUParticles3D.EMISSION_SHAPE_SPHERE
	_sparks.emission_sphere_radius = 0.5
	_sparks.direction = Vector3.UP
	_sparks.spread = 80.0
	_sparks.initial_velocity_min = 1.5
	_sparks.initial_velocity_max = 3.2
	_sparks.gravity = Vector3(0.0, -4.0, 0.0)
	_sparks.damping_min = 1.0
	_sparks.damping_max = 2.0
	var fade: Curve = Curve.new()
	fade.add_point(Vector2(0.0, 1.0))
	fade.add_point(Vector2(1.0, 0.0))
	_sparks.scale_amount_curve = fade
	var star: SphereMesh = SphereMesh.new()
	star.radius = 0.09
	star.height = 0.18
	star.radial_segments = 6
	star.rings = 3
	_sparks.mesh = star
	var spark_material: StandardMaterial3D = StandardMaterial3D.new()
	spark_material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	_sparks.material_override = spark_material
	_sparks.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	root.add_child(_sparks)


func _fit_camera() -> void:
	# A tall stage keeps the width in view, a wide one the height, so nothing is cut off.
	if size.x < size.y:
		camera.keep_aspect = Camera3D.KEEP_WIDTH
	else:
		camera.keep_aspect = Camera3D.KEEP_HEIGHT


# A cel-shaded, outlined drum: blue sides, a golden rim and a lighter top just under the feet.
func _build_pedestal() -> void:
	var root: Node3D = Node3D.new()
	root.name = "Pedestal"
	$Viewport.add_child(root)
	_drum(root, "Side", 1.2, 1.38, PEDESTAL_HEIGHT, PEDESTAL_SIDE, -PEDESTAL_HEIGHT / 2.0 - 0.06)
	_drum(root, "Rim", 1.24, 1.24, 0.1, PEDESTAL_RIM, -0.05)
	_drum(root, "Top", 1.08, 1.08, 0.02, PEDESTAL_TOP, -0.005)


static func _drum(
	parent: Node3D,
	part_name: String,
	top_radius: float,
	bottom_radius: float,
	height: float,
	color: Color,
	center_y: float
) -> void:
	var mesh: CylinderMesh = CylinderMesh.new()
	mesh.top_radius = top_radius
	mesh.bottom_radius = bottom_radius
	mesh.height = height
	mesh.radial_segments = 48
	mesh.rings = 1
	var part: MeshInstance3D = MeshInstance3D.new()
	part.name = part_name
	part.mesh = mesh
	part.material_override = ToonMaterials.toon(color)
	part.position.y = center_y
	part.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	parent.add_child(part)
