class_name FighterStage
extends SubViewportContainer
## A live 3D fighter inside a 2D screen: a sub-viewport with its own 3D world, a camera, two
## lights and one `FighterModel`, standing on a round pedestal (spec 09, D6). The camera keeps
## the whole fighter (and the pedestal) in view whether the stage is wide or tall. On a pedestal
## (home, the fighter screen, the result) every fighter shown pops in with the reveal (C3, D23); an
## animated picture fighter then plays its showcase (`CutoutShowcase`, M8, D39), and on the
## fighter screen (`interactive`) a drag turns it and a tap makes it shoot (M9).

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
## A drag turns the figure one view every this many pixels; a press and release shorter and
## smaller than these is a tap (D39).
const DRAG_STEP_PIXELS: float = 80.0
const TAP_SECONDS: float = 0.25
const TAP_PIXELS: float = 10.0
## After the last drag or tap the showcase starts again after this long.
const RESUME_SECONDS: float = 3.0
const SHOT_SPARKS: int = 14
const PROJECTILE_SHADER: Shader = preload("res://scenes/toon/projectile.gdshader")

## The fighter stands on a pedestal. Off for the card pictures (set before the stage is added).
@export var pedestal: bool = true
## The player can turn an animated fighter by dragging and make it shoot with a tap (the fighter
## screen).
@export var interactive: bool = false

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
## Seconds into the showcase's loop; below 0 when none plays (no pedestal, a fighter of shapes).
var _showcase_time: float = -1.0
## Seconds left before the showcase starts again after a drag or tap.
var _hold_left: float = 0.0
## Where the press started (INF when none is down), when, whether it became a drag, and the view
## (ring index) the drag turns from.
var _press_at: Vector2 = Vector2.INF
var _press_msec: int = 0
var _dragged: bool = false
var _drag_from: int = 0
## The showcase's projectile, its time in flight (below 0 when none flies), start and direction.
var _shot: MeshInstance3D
var _shot_time: float = -1.0
var _shot_from: Vector3 = Vector3.ZERO
var _shot_toward: Vector3 = Vector3.RIGHT
var _shot_sparks: CPUParticles3D

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
	_end_shot()
	_hold_left = 0.0
	_showcase_time = 0.0 if pedestal and model.cutout_animator() != null else -1.0
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
	# The showcase starts with the reveal (home's landing reveals again).
	if _showcase_time >= 0.0:
		_showcase_time = 0.0


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


## True while an animated fighter's showcase plays (paused by a drag or tap or not).
func is_showcasing() -> bool:
	return _showcase_time >= 0.0


## Seconds into the showcase's loop (below 0 when none plays).
func showcase_time() -> float:
	return _showcase_time


## True while a drag or tap holds the showcase.
func is_holding() -> bool:
	return _hold_left > 0.0


## The showcase's projectile (null before the first shot); visible while it flies.
func get_shot() -> MeshInstance3D:
	return _shot


## The burst of sparks at the showcase's shot (null before the first shot).
func get_shot_sparks() -> CPUParticles3D:
	return _shot_sparks


## The showcase moves on by `delta` seconds: the pose of the loop (or the held pose after a drag
## or tap, until `RESUME_SECONDS` have passed) and the projectile in flight.
func step_showcase(delta: float) -> void:
	var animator: CutoutAnimator = model.cutout_animator()
	if _showcase_time < 0.0 or animator == null:
		return
	_step_shot(delta)
	if _hold_left > 0.0:
		_hold_left = maxf(_hold_left - delta, 0.0)
		if _hold_left <= 0.0:
			_showcase_time = 0.0
			_pose(CutoutShowcase.at(0.0))
		return
	var was_shooting: bool = CutoutShowcase.at(_showcase_time)["shooting"]
	_showcase_time = fposmod(_showcase_time + delta, CutoutShowcase.LOOP_SECONDS)
	var pose: Dictionary = CutoutShowcase.at(_showcase_time)
	_pose(pose)
	if pose["shooting"] and not was_shooting:
		shoot()


## The shoot pose in the shown view with the projectile flying out and a burst of sparks in the
## fighter's main colour (an animated fighter only).
func shoot() -> void:
	var animator: CutoutAnimator = model.cutout_animator()
	if animator == null:
		return
	var direction: Vector2 = CutoutShowcase.shot_direction(animator.view, animator.mirrored)
	model.running = false
	model.play_shoot(direction)
	animator.shoot_left = CutoutShowcase.SHOOT_SECONDS
	model.play_attack()
	model.muzzle_flash()
	_launch_shot(model.get_muzzle_flash().global_position, Vector3(direction.x, 0.0, direction.y))


func _pose(pose: Dictionary) -> void:
	var animator: CutoutAnimator = model.cutout_animator()
	animator.view = pose["view"]
	animator.mirrored = pose["mirrored"]
	model.running = pose["running"]


func _launch_shot(from: Vector3, toward: Vector3) -> void:
	if _shot == null:
		_build_shot()
	var picture: Texture2D = CutoutFighters.projectile(model.fighter_id)
	var quad: QuadMesh = _shot.mesh
	quad.size = Vector2(
		Shot.PICTURE_LENGTH, Shot.PICTURE_LENGTH * picture.get_height() / picture.get_width()
	)
	(_shot.material_override as ShaderMaterial).set_shader_parameter("picture", picture)
	_shot.basis = Basis(Vector3.UP, atan2(-toward.z, toward.x))
	_shot_from = from
	_shot_toward = toward
	_shot_time = 0.0
	_step_shot(0.0)
	_shot_sparks.position = from
	(_shot_sparks.material_override as StandardMaterial3D).albedo_color = (
		model.main_color.lightened(0.3)
	)
	_shot_sparks.visible = true
	_shot_sparks.restart()


# The projectile flies `SHOT_DISTANCE` out and fades over the second half of its flight.
func _step_shot(delta: float) -> void:
	if _shot_time < 0.0:
		return
	_shot_time += delta
	var progress: float = _shot_time / CutoutShowcase.SHOT_FLIGHT_SECONDS
	if progress >= 1.0:
		_end_shot()
		return
	_shot.visible = true
	_shot.position = _shot_from + _shot_toward * CutoutShowcase.SHOT_DISTANCE * progress
	var fade: float = 1.0 - clampf((progress - 0.5) / 0.5, 0.0, 1.0)
	(_shot.material_override as ShaderMaterial).set_shader_parameter("fade", fade)


func _end_shot() -> void:
	_shot_time = -1.0
	if _shot != null:
		_shot.visible = false


func _build_shot() -> void:
	var material: ShaderMaterial = ShaderMaterial.new()
	material.shader = PROJECTILE_SHADER
	_shot = MeshInstance3D.new()
	_shot.name = "ShowcaseShot"
	_shot.mesh = QuadMesh.new()
	_shot.material_override = material
	_shot.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	_shot.extra_cull_margin = Shot.PICTURE_LENGTH
	_shot.visible = false
	$Viewport.add_child(_shot)
	_shot_sparks = _new_sparks("ShotSparks", SHOT_SPARKS, 0.15)
	$Viewport.add_child(_shot_sparks)


# --- The fighter screen's drag (turn) and tap (shoot), with the mouse and touch ---------------


func _gui_input(event: InputEvent) -> void:
	if not interactive or model.cutout_animator() == null:
		return
	# A touch also arrives as an emulated mouse event: only the touch counts.
	var emulated: bool = event.device == InputEvent.DEVICE_ID_EMULATION
	if event is InputEventMouseButton and not emulated:
		if (event as InputEventMouseButton).button_index != MOUSE_BUTTON_LEFT:
			return
		_press(event.pressed, event.position)
	elif event is InputEventScreenTouch and (event as InputEventScreenTouch).index == 0:
		_press(event.pressed, event.position)
	elif event is InputEventMouseMotion and not emulated:
		_drag(event.position)
	elif event is InputEventScreenDrag and (event as InputEventScreenDrag).index == 0:
		_drag(event.position)
	else:
		return
	accept_event()


func _press(pressed: bool, at: Vector2) -> void:
	var animator: CutoutAnimator = model.cutout_animator()
	if pressed:
		_press_at = at
		_press_msec = Time.get_ticks_msec()
		_dragged = false
		_drag_from = CutoutShowcase.ring_index(animator.view, animator.mirrored)
		return
	if _press_at == Vector2.INF:
		return
	var seconds: float = (Time.get_ticks_msec() - _press_msec) / 1000.0
	if not _dragged and seconds <= TAP_SECONDS and at.distance_to(_press_at) <= TAP_PIXELS:
		_hold()
		shoot()
	_press_at = Vector2.INF


func _drag(at: Vector2) -> void:
	if _press_at == Vector2.INF:
		return
	if not _dragged and at.distance_to(_press_at) <= TAP_PIXELS:
		return
	_dragged = true
	_hold()
	var steps: int = int((at.x - _press_at.x) / DRAG_STEP_PIXELS)
	var pose: Dictionary = CutoutShowcase.ring(_drag_from + steps)
	var animator: CutoutAnimator = model.cutout_animator()
	if animator.view != pose["view"] or animator.mirrored != pose["mirrored"]:
		animator.shoot_left = 0.0
	_pose(pose.merged({"running": false}))


func _hold() -> void:
	if _showcase_time < 0.0:
		return
	_hold_left = RESUME_SECONDS
	model.running = false


# The reveal's own clock takes at most one 30th of a second per frame, so the hitch of a screen's
# first frame slows the pop down instead of skipping it.
func _process(delta: float) -> void:
	step_showcase(delta)
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
# each reveal.
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

	_sparks = _new_sparks("Sparks", REVEAL_SPARKS, 0.5)
	_sparks.position = Vector3(0.0, 1.0, 0.0)
	root.add_child(_sparks)


# A one-shot burst of small round sparks that fly up and out, fall and shrink; coloured by its
# material. CPU particles: GPU particles are limited on WebGL with the Compatibility renderer.
static func _new_sparks(sparks_name: String, amount: int, radius: float) -> CPUParticles3D:
	var sparks: CPUParticles3D = CPUParticles3D.new()
	sparks.name = sparks_name
	sparks.emitting = false
	sparks.one_shot = true
	sparks.explosiveness = 1.0
	sparks.amount = amount
	sparks.lifetime = 0.9
	sparks.emission_shape = CPUParticles3D.EMISSION_SHAPE_SPHERE
	sparks.emission_sphere_radius = radius
	sparks.direction = Vector3.UP
	sparks.spread = 80.0
	sparks.initial_velocity_min = 1.5
	sparks.initial_velocity_max = 3.2
	sparks.gravity = Vector3(0.0, -4.0, 0.0)
	sparks.damping_min = 1.0
	sparks.damping_max = 2.0
	var fade: Curve = Curve.new()
	fade.add_point(Vector2(0.0, 1.0))
	fade.add_point(Vector2(1.0, 0.0))
	sparks.scale_amount_curve = fade
	var star: SphereMesh = SphereMesh.new()
	star.radius = 0.09
	star.height = 0.18
	star.radial_segments = 6
	star.rings = 3
	sparks.mesh = star
	var spark_material: StandardMaterial3D = StandardMaterial3D.new()
	spark_material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	sparks.material_override = spark_material
	sparks.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	return sparks


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
