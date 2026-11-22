extends Control
## The home screen: the chosen fighter and skin, the player's trophies and credits, the
## fighter's Prestige, **Play** (a match), **Training**, **Fighters**, **Info** and **Hack**.
## At each game start it first plays the entrance: the fighter drops in with a bounce, a light
## burst and sparkles, the title pops in; a click, a touch or a key skips to the end state.

## The whole entrance, in seconds (spec S2: at most 3).
const ENTRANCE_SECONDS: float = 2.4
const DROP_START: float = 0.15
const LANDING: float = 0.8
const DROP_HEIGHT: float = 2.2
const DROP_SCALE: float = 0.3
const TITLE_POP: float = 1.0
const UI_FADE_IN: float = 1.5
const BURST_COLOR: Color = Color(1.0, 0.9, 0.55)
## The icon of each home button (`Icons`), by the button's node name.
const BUTTON_ICONS: Dictionary[String, String] = {
	"PlayButton": "play",
	"TrainingButton": "training",
	"FightersButton": "fighters",
	"InfoButton": "info",
	"HackButton": "hack",
}

## True while the entrance plays.
var entrance_playing: bool = false

var _tween: Tween
var _effects: Node3D

@onready var _trophies_chip: IconChip = $Margin/Column/TopBar/TrophiesChip
@onready var _credits_chip: IconChip = $Margin/Column/TopBar/CreditsChip
@onready var _top_bar: Control = $Margin/Column/TopBar
@onready var _title: Control = $Margin/Column/Title
@onready var _stage: FighterStage = $Margin/Column/Body/FighterStage
@onready var _name_label: Label = $Margin/Column/Body/Controls/NameRow/NameLabel
@onready var _badge: PrestigeBadge = $Margin/Column/Body/Controls/NameRow/PrestigeBadge
@onready var _body: BoxContainer = $Margin/Column/Body
@onready var _controls: Control = $Margin/Column/Body/Controls
@onready var _play_button: Button = $Margin/Column/Body/Controls/PlayButton
@onready var _training_button: Button = $Margin/Column/Body/Controls/MoreRow/TrainingButton
@onready var _fighters_button: Button = $Margin/Column/Body/Controls/MoreRow/FightersButton
@onready var _info_button: Button = $Margin/Column/Body/Controls/MoreRow/InfoButton
@onready var _hack_button: Button = $Margin/Column/Body/Controls/MoreRow/HackButton
@onready var _flash: ColorRect = $Flash
@onready var _skip_hint: Label = $SkipHint


func _ready() -> void:
	# Opened from a QR link: straight to the hack screen, which redeems the code.
	if not GameState.start_code.is_empty():
		Screens.go_to.call_deferred(Screens.HACK)
		return
	_play_button.pressed.connect(_on_play_pressed)
	_training_button.pressed.connect(_on_training_pressed)
	_fighters_button.pressed.connect(_on_fighters_pressed)
	_info_button.pressed.connect(_on_info_pressed)
	_hack_button.pressed.connect(_on_hack_pressed)
	for button: Button in [
		_play_button, _training_button, _fighters_button, _info_button, _hack_button
	]:
		button.icon = Icons.get_icon(BUTTON_ICONS[button.name])
	GameState.progress_changed.connect(_refresh)
	resized.connect(_arrange)
	_title.resized.connect(_center_title_pivot)
	_arrange()
	_refresh()
	_center_title_pivot()
	if not GameState.entrance_played:
		_play_entrance()


# Skipping takes the event, so the tap that skips does not also press a button.
func _input(event: InputEvent) -> void:
	if entrance_playing and _is_skip(event):
		get_viewport().set_input_as_handled()
		skip_entrance()


## Jumps to the end of the entrance at once.
func skip_entrance() -> void:
	if not entrance_playing:
		return
	_tween.kill()
	_finish_entrance()


# Wide: the fighter on the left, the buttons on the right and Play in the bottom-right corner.
# Tall: one column with Play across the bottom.
func _arrange() -> void:
	var wide: bool = size.x > size.y
	_body.vertical = not wide
	_controls.size_flags_vertical = Control.SIZE_EXPAND_FILL if wide else Control.SIZE_FILL
	_play_button.size_flags_horizontal = Control.SIZE_SHRINK_END if wide else Control.SIZE_FILL


func _refresh() -> void:
	var fighter_id: String = GameState.selected_fighter
	_trophies_chip.text = str(GameState.total_trophies())
	_credits_chip.text = Hacks.credits_amount(GameState.credits, GameState.active_hacks)
	_name_label.text = Fighters.get_fighter(fighter_id)["name"]
	_badge.show_for_trophies(GameState.trophies[fighter_id])
	_stage.show_fighter(fighter_id, GameState.selected_skin())


func _center_title_pivot() -> void:
	_title.pivot_offset = _title.size / 2.0


func _on_play_pressed() -> void:
	Screens.go_to(Screens.MATCH)


func _on_training_pressed() -> void:
	Screens.go_to(Screens.ARENA)


func _on_fighters_pressed() -> void:
	Screens.go_to(Screens.FIGHTERS)


func _on_info_pressed() -> void:
	Screens.go_to(Screens.INFO)


func _on_hack_pressed() -> void:
	Screens.go_to(Screens.HACK)


static func _is_skip(event: InputEvent) -> bool:
	var press: bool = (
		event is InputEventMouseButton
		or event is InputEventScreenTouch
		or event is InputEventKey
		or event is InputEventJoypadButton
	)
	return press and event.is_pressed() and not event.is_echo()


# --- Entrance ---------------------------------------------------------------------------------


func _play_entrance() -> void:
	GameState.entrance_played = true
	entrance_playing = true
	var model: FighterModel = _stage.model
	_effects = _build_effects()
	# Small and high, so the fighter falls in from the sky inside the stage, not cut by its edge.
	model.position.y = DROP_HEIGHT
	model.rotation.y = -TAU
	model.scale = Vector3.ONE * DROP_SCALE
	# Hidden, not scaled: the column resets its children's scale when it lays them out.
	_title.modulate.a = 0.0
	_top_bar.modulate.a = 0.0
	_controls.modulate.a = 0.0
	_flash.visible = true
	_skip_hint.visible = true

	_tween = create_tween().set_parallel(true)
	var fall: float = LANDING - DROP_START
	(
		_tween
		. tween_property(model, "position:y", 0.0, fall)
		. set_delay(DROP_START)
		. set_trans(Tween.TRANS_QUAD)
		. set_ease(Tween.EASE_IN)
	)
	(
		_tween
		. tween_property(model, "rotation:y", 0.0, fall)
		. set_delay(DROP_START)
		. set_trans(Tween.TRANS_SINE)
		. set_ease(Tween.EASE_OUT)
	)
	# Same ease as the fall: the top of the fighter stays at the same height while it falls.
	(
		_tween
		. tween_property(model, "scale", Vector3.ONE, fall)
		. set_delay(DROP_START)
		. set_trans(Tween.TRANS_QUAD)
		. set_ease(Tween.EASE_IN)
	)
	# Landing: squash, then spring back with a bounce.
	var squash: Vector3 = Vector3(1.25, 0.75, 1.25)
	_tween.tween_property(model, "scale", squash, 0.1).set_delay(LANDING)
	(
		_tween
		. tween_property(model, "scale", Vector3.ONE, 0.5)
		. set_delay(LANDING + 0.1)
		. set_trans(Tween.TRANS_ELASTIC)
		. set_ease(Tween.EASE_OUT)
	)
	_tween.tween_callback(_burst).set_delay(LANDING)
	_tween_burst(_effects)
	_tween.tween_property(_flash, "color:a", 0.3, 0.05).set_delay(LANDING)
	_tween.tween_property(_flash, "color:a", 0.0, 0.25).set_delay(LANDING + 0.05)
	_tween.tween_property(_title, "modulate:a", 1.0, 0.1).set_delay(TITLE_POP)
	(
		_tween
		. tween_property(_title, "scale", Vector2.ONE, 0.5)
		. from(Vector2.ONE * 0.2)
		. set_delay(TITLE_POP)
		. set_trans(Tween.TRANS_BACK)
		. set_ease(Tween.EASE_OUT)
	)
	_tween.tween_property(_top_bar, "modulate:a", 1.0, 0.5).set_delay(UI_FADE_IN)
	_tween.tween_property(_controls, "modulate:a", 1.0, 0.5).set_delay(UI_FADE_IN)
	_tween.tween_interval(ENTRANCE_SECONDS)
	_tween.finished.connect(_finish_entrance)


# The end state, the same whether the entrance ran to the end or was skipped.
func _finish_entrance() -> void:
	entrance_playing = false
	var model: FighterModel = _stage.model
	model.position.y = 0.0
	model.rotation.y = 0.0
	model.scale = Vector3.ONE
	_title.scale = Vector2.ONE
	_title.modulate.a = 1.0
	_top_bar.modulate.a = 1.0
	_controls.modulate.a = 1.0
	_flash.visible = false
	_flash.color.a = 0.0
	_skip_hint.visible = false
	if _effects != null:
		_effects.queue_free()
		_effects = null


## The light and sparkles of the landing, in the fighter's 3D world; freed after the entrance.
func _build_effects() -> Node3D:
	var effects: Node3D = Node3D.new()
	effects.name = "Entrance"
	_stage.get_node("Viewport").add_child(effects)

	var light: OmniLight3D = OmniLight3D.new()
	light.name = "BurstLight"
	light.position = Vector3(0.0, 1.2, 1.5)
	light.light_color = BURST_COLOR
	light.light_energy = 0.0
	light.omni_range = 6.0
	effects.add_child(light)

	var glow: GradientTexture2D = GradientTexture2D.new()
	glow.fill = GradientTexture2D.FILL_RADIAL
	glow.fill_from = Vector2(0.5, 0.5)
	glow.fill_to = Vector2(0.5, 0.0)
	glow.gradient = Gradient.new()
	glow.gradient.set_color(0, Color(1.0, 1.0, 1.0, 1.0))
	glow.gradient.set_color(1, Color(1.0, 1.0, 1.0, 0.0))
	var halo_material: StandardMaterial3D = _additive(BURST_COLOR)
	halo_material.albedo_texture = glow
	halo_material.billboard_mode = BaseMaterial3D.BILLBOARD_ENABLED
	var halo_quad: QuadMesh = QuadMesh.new()
	halo_quad.size = Vector2(4.0, 4.0)
	var halo: MeshInstance3D = _mesh(effects, "BurstHalo", halo_quad, halo_material)
	halo.position = Vector3(0.0, 1.0, -0.6)
	halo.scale = Vector3.ZERO

	var ring_mesh: TorusMesh = TorusMesh.new()
	ring_mesh.inner_radius = 0.9
	ring_mesh.outer_radius = 1.0
	var ring: MeshInstance3D = _mesh(effects, "Shockwave", ring_mesh, _additive(BURST_COLOR))
	ring.position = Vector3(0.0, 0.05, 0.0)
	ring.scale = Vector3.ZERO

	effects.add_child(_burst_sparkles())
	return effects


func _tween_burst(effects: Node3D) -> void:
	var light: OmniLight3D = effects.get_node("BurstLight")
	_tween.tween_property(light, "light_energy", 6.0, 0.08).set_delay(LANDING)
	_tween.tween_property(light, "light_energy", 0.0, 0.7).set_delay(LANDING + 0.08)
	var halo: MeshInstance3D = effects.get_node("BurstHalo")
	var halo_material: StandardMaterial3D = halo.material_override as StandardMaterial3D
	(
		_tween
		. tween_property(halo, "scale", Vector3.ONE * 1.4, 0.35)
		. set_delay(LANDING)
		. set_trans(Tween.TRANS_CUBIC)
		. set_ease(Tween.EASE_OUT)
	)
	_tween.tween_property(halo_material, "albedo_color:a", 0.0, 0.9).set_delay(LANDING + 0.2)
	var ring: MeshInstance3D = effects.get_node("Shockwave")
	var ring_material: StandardMaterial3D = ring.material_override as StandardMaterial3D
	(
		_tween
		. tween_property(ring, "scale", Vector3(1.8, 1.0, 1.8), 0.6)
		. set_delay(LANDING)
		. set_trans(Tween.TRANS_CUBIC)
		. set_ease(Tween.EASE_OUT)
	)
	_tween.tween_property(ring_material, "albedo_color:a", 0.0, 0.6).set_delay(LANDING)


func _burst() -> void:
	if _effects != null:
		(_effects.get_node("BurstSparkles") as CPUParticles3D).restart()


# A one-shot burst of sparkles in the fighter's colour and gold (`CPUParticles3D`: GPU particles
# are limited on WebGL with the Compatibility renderer).
func _burst_sparkles() -> CPUParticles3D:
	var particles: CPUParticles3D = CPUParticles3D.new()
	particles.name = "BurstSparkles"
	particles.position = Vector3(0.0, 0.6, 0.0)
	particles.emitting = false
	particles.one_shot = true
	particles.explosiveness = 1.0
	particles.amount = 64
	particles.lifetime = 1.2
	particles.direction = Vector3.UP
	particles.spread = 75.0
	particles.initial_velocity_min = 1.2
	particles.initial_velocity_max = 2.8
	particles.gravity = Vector3(0.0, -6.0, 0.0)
	particles.damping_min = 1.5
	particles.damping_max = 2.5
	var fade: Curve = Curve.new()
	fade.add_point(Vector2(0.0, 1.0))
	fade.add_point(Vector2(1.0, 0.0))
	particles.scale_amount_curve = fade
	var colors: Gradient = Gradient.new()
	colors.set_color(0, Rarity.LEGENDARY_GOLD)
	colors.set_color(1, _stage.model.main_color.lightened(0.2))
	particles.color_initial_ramp = colors
	var star: SphereMesh = SphereMesh.new()
	star.radius = 0.1
	star.height = 0.2
	star.radial_segments = 6
	star.rings = 3
	particles.mesh = star
	var material: StandardMaterial3D = _additive(Color.WHITE)
	material.vertex_color_use_as_albedo = true
	particles.material_override = material
	particles.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	return particles


static func _mesh(
	parent: Node3D, node_name: String, mesh: Mesh, material: Material
) -> MeshInstance3D:
	var instance: MeshInstance3D = MeshInstance3D.new()
	instance.name = node_name
	instance.mesh = mesh
	instance.material_override = material
	instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	parent.add_child(instance)
	return instance


static func _additive(color: Color) -> StandardMaterial3D:
	var material: StandardMaterial3D = StandardMaterial3D.new()
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = color
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	material.blend_mode = BaseMaterial3D.BLEND_MODE_ADD
	return material
