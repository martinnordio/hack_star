class_name FighterModel
extends Node3D
## A fighter's 3D look, built in code from primitive meshes and the shared cartoon materials of
## `ToonMaterials` (cel shading and a dark outline; no imported art).
## `setup(fighter_id, skin_id)` builds the fighter; the front faces +Z (towards the stage camera),
## the feet stand on y = 0. The idle animation (breathing, sway, flickering flames and screens)
## runs in `_process` while `idle_enabled` is true; switch it off for still pictures.
## While `running` is true the run animation (bounce, forward lean) replaces the idle one;
## `play_attack()` adds a short recoil on top of either.

const OUTLINE_COLOR: Color = ToonMaterials.OUTLINE_COLOR
## Eyes darker than this get a white around the pupil.
const EYE_WHITE_BELOW: float = 0.35
## Height of the neck: the head turns around this point.
const NECK_Y: float = 1.2
const BREATH_SPEED: float = 2.2
const BREATH_HEIGHT: float = 0.04
const SWAY_SPEED: float = 0.9
const SWAY_ANGLE: float = 0.15
const HEAD_TILT_SPEED: float = 1.3
const HEAD_TILT_ANGLE: float = 0.06
const FLICKER_SPEED: float = 9.0
const FLICKER_AMOUNT: float = 0.07
const SPIN_SPEED: float = 0.8
const RUN_BOUNCE_SPEED: float = 10.0
const RUN_BOUNCE_HEIGHT: float = 0.12
const RUN_LEAN_ANGLE: float = 0.18
const RUN_HEAD_SPEED: float = 2.4
const ATTACK_SECONDS: float = 0.25
const ATTACK_KICK: float = 0.18
const ATTACK_SQUASH: float = 0.14
## How opaque a fighter stays in a cactus patch (1 solid, 0 invisible).
const SEE_THROUGH_ALPHA: float = ToonMaterials.SEE_THROUGH_ALPHA
const SOLID_META: String = "solid_material"

## Colours of each fighter's look, per skin. `main` is the colour a player sees most.
const LOOKS: Dictionary = {
	"blaze":
	{
		"default":
		{
			"main": Color("e8322b"),
			"legs": Color("3b2a5c"),
			"hair": Color("ff7a1a"),
			"tip": Color("ffd23f"),
			"skin": Color("ffd2a8"),
			"shoes": Color("2a1d1d"),
		},
		"lava":
		{
			"main": Color("3a2626"),
			"glow": Color("ff3300"),
			"legs": Color("1f1414"),
			"hair": Color("ff4500"),
			"tip": Color("ffb000"),
			"skin": Color("c98a6a"),
			"shoes": Color("2a1d1d"),
		},
		"phoenix":
		{
			"main": Color("ffb300"),
			"legs": Color("b3261e"),
			"hair": Color("ff3d00"),
			"tip": Color("fff3a0"),
			"skin": Color("ffd9b5"),
			"shoes": Color("b3261e"),
			"wing": Color("ff6a00"),
			"halo": Color("ff9a1a"),
		},
	},
	"rocko":
	{
		"default":
		{
			"main": Color("8d7f73"),
			"dark": Color("5f544b"),
			"moss": Color("5fae3c"),
			"eyes": Color("ffd23f"),
		},
		"crystal":
		{
			"main": Color("7fd6ff"),
			"glow": Color("2a8cff"),
			"dark": Color("4aa8ff"),
			"moss": Color("e0f7ff"),
			"eyes": Color("0b2a66"),
		},
	},
	"turbo":
	{
		"default":
		{
			"main": Color("2f7bff"),
			"legs": Color("283048"),
			"skin": Color("e9b48a"),
			"shoes": Color("ffffff"),
			"helmet": Color("ffd23f"),
			"visor": Color("1b1446"),
			"stripe": Color("e8322b"),
		},
		"neon":
		{
			"main": Color("141428"),
			"glow": Color("3a0a5a"),
			"legs": Color("0d0d1a"),
			"skin": Color("e9b48a"),
			"shoes": Color("39ff88"),
			"helmet": Color("ff2bd6"),
			"visor": Color("39ff88"),
			"stripe": Color("39ff88"),
			"neon": true,
		},
	},
	"frosty":
	{
		"default":
		{
			"main": Color("ffffff"),
			"face": Color("8fd3ff"),
			"horn": Color("bfe9ff"),
			"nose": Color("3a5a9a"),
		},
		"snow_king":
		{
			"main": Color("b4dcff"),
			"glow": Color("9fd8ff"),
			"face": Color("eaf6ff"),
			"horn": Color("7fd6ff"),
			"nose": Color("2a4bd6"),
			"cape": Color("2a4bd6"),
			"halo": Color("9fd8ff"),
		},
	},
	"luna":
	{
		"default":
		{
			"main": Color("7b4dff"),
			"fur": Color("5a5a6e"),
			"inner": Color("ff9ac8"),
			"accent": Color("ffd23f"),
			"metal": Color("c9d1e0"),
		},
		"galaxy":
		{
			"main": Color("141a4a"),
			"glow": Color("3a2aff"),
			"fur": Color("26205a"),
			"inner": Color("7ff0ff"),
			"accent": Color("7ff0ff"),
			"metal": Color("9aa6ff"),
		},
		"supernova":
		{
			"main": Color("fff3c4"),
			"glow": Color("ffb000"),
			"fur": Color("ffd8a0"),
			"inner": Color("ff7a1a"),
			"accent": Color("ff7a1a"),
			"metal": Color("fff8e0"),
			"halo": Color("ffcf33"),
		},
	},
	"pixel":
	{
		"default":
		{
			"main": Color("e8edf5"),
			"trim": Color("2f7bff"),
			"screen": Color("0b0d1a"),
			"pixels": Color("39ff88"),
		},
		"glitch":
		{
			"main": Color("2a0f3a"),
			"glow": Color("ff2bd6"),
			"trim": Color("00e5ff"),
			"screen": Color("0b0d1a"),
			"pixels": Color("ff2bd6"),
			"halo": Color("ff2bd6"),
		},
	},
}

## Plays the idle animation every frame; off for still pictures (the fighter list).
@export var idle_enabled: bool = true

var fighter_id: String = ""
var skin_id: String = ""
## The colour a player sees most on this fighter in this skin.
var main_color: Color = Color.WHITE
var time_seconds: float = 0.0
## Set by the fighter while it walks.
var running: bool = false
## Seconds left of the attack recoil; 0 when none plays.
var attack_left: float = 0.0
## True while the whole fighter is see-through.
var see_through: bool = false
var _rig: Node3D
var _body: Node3D
var _head: Node3D
var _flickers: Array[Node3D] = []
var _flicker_scales: Array[Vector3] = []
var _spinners: Array[Node3D] = []


func _ready() -> void:
	if _rig == null:
		setup(SampleProgress.SELECTED_FIGHTER)


func _process(delta: float) -> void:
	attack_left = maxf(attack_left - delta, 0.0)
	if idle_enabled and _rig != null:
		time_seconds += delta
		animate(time_seconds)


## Builds the fighter in a skin, replacing what was built before. An unknown fighter shows
## Blaze; an unknown skin shows the Default look.
func setup(new_fighter_id: String, new_skin_id: String = Fighters.DEFAULT_SKIN) -> void:
	fighter_id = new_fighter_id if LOOKS.has(new_fighter_id) else "blaze"
	var looks: Dictionary = LOOKS[fighter_id]
	skin_id = new_skin_id if looks.has(new_skin_id) else Fighters.DEFAULT_SKIN
	var look: Dictionary = looks[skin_id]
	main_color = look["main"]
	_clear()
	match fighter_id:
		"rocko":
			_build_rocko(look)
		"turbo":
			_build_turbo(look)
		"frosty":
			_build_frosty(look)
		"luna":
			_build_luna(look)
		"pixel":
			_build_pixel(look)
		_:
			_build_blaze(look)
	animate(time_seconds)
	_apply_see_through(_rig)


## Makes the whole fighter see-through (in a cactus patch) or solid again.
func set_see_through(on: bool) -> void:
	if on == see_through:
		return
	see_through = on
	if _rig != null:
		_apply_see_through(_rig)


## The Compatibility renderer ignores `GeometryInstance3D.transparency`, so the fighter's
## materials are swapped for see-through copies (`ToonMaterials.see_through`), and back.
func _apply_see_through(node: Node) -> void:
	for child: Node in node.get_children():
		if child is MeshInstance3D:
			_swap_material(child)
		_apply_see_through(child)


func _swap_material(mesh: MeshInstance3D) -> void:
	if not mesh.has_meta(SOLID_META):
		mesh.set_meta(SOLID_META, mesh.material_override)
	var solid: Material = mesh.get_meta(SOLID_META)
	mesh.material_override = ToonMaterials.see_through(solid) if see_through else solid


## Starts the short recoil of a shot: the body kicks back and squashes, then springs back.
func play_attack() -> void:
	attack_left = ATTACK_SECONDS


## Puts the animation at a moment in time (seconds): idle or run, plus the attack recoil.
func animate(time: float) -> void:
	if _rig == null:
		return
	var recoil: float = sin((1.0 - attack_left / ATTACK_SECONDS) * PI) if attack_left > 0.0 else 0.0
	if running:
		_rig.rotation.x = RUN_LEAN_ANGLE
		_body.position.y = absf(sin(time * RUN_BOUNCE_SPEED)) * RUN_BOUNCE_HEIGHT
		_body.rotation.y = 0.0
		_head.rotation.z = sin(time * RUN_BOUNCE_SPEED * RUN_HEAD_SPEED) * HEAD_TILT_ANGLE
	else:
		_rig.rotation.x = 0.0
		_body.position.y = sin(time * BREATH_SPEED) * BREATH_HEIGHT
		_body.rotation.y = sin(time * SWAY_SPEED) * SWAY_ANGLE
		_head.rotation.z = sin(time * HEAD_TILT_SPEED) * HEAD_TILT_ANGLE
	_body.position.z = -recoil * ATTACK_KICK
	_body.scale = Vector3(1.0 + recoil * ATTACK_SQUASH, 1.0 - recoil * ATTACK_SQUASH, 1.0)
	for index: int in _flickers.size():
		var wave: float = 1.0 + sin(time * FLICKER_SPEED + index * 1.7) * FLICKER_AMOUNT
		_flickers[index].scale = _flicker_scales[index] * wave
	for spinner: Node3D in _spinners:
		spinner.rotation.y = time * SPIN_SPEED


func _clear() -> void:
	if _rig != null:
		remove_child(_rig)
		_rig.free()
	_flickers.clear()
	_flicker_scales.clear()
	_spinners.clear()
	_rig = Node3D.new()
	_rig.name = "Rig"
	add_child(_rig)
	_body = _group(_rig, "Body")
	_head = _group(_body, "Head", Vector3(0.0, NECK_Y, 0.0))
	var shadow: MeshInstance3D = _part(
		_rig, _cylinder(0.75, 0.75, 0.01), _shadow_material(), Vector3(0.0, 0.006, 0.0)
	)
	shadow.name = "Shadow"
	shadow.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF


# --- The six fighters -------------------------------------------------------------------------


func _build_blaze(look: Dictionary) -> void:
	_human(look["skin"], look["main"], look["legs"], look["shoes"], look.get("glow", Color.BLACK))
	var flame: ShaderMaterial = _toon(look["hair"], look["hair"], 0.6)
	var tip: ShaderMaterial = _toon(look["tip"], look["tip"], 0.9)
	var hair: Node3D = _group(_head, "FlameHair")
	_part(
		hair, _sphere(0.52), flame, Vector3(0.0, 1.86, -0.16), Vector3.ZERO, Vector3(1.02, 0.7, 1)
	)
	for side: float in [-1.0, 1.0]:
		var lock_turn: Vector3 = Vector3(0.0, 0.0, side * 0.12)
		_part(hair, _capsule(0.15, 0.75), flame, Vector3(side * 0.42, 1.55, -0.12), lock_turn)
	var ponytail_turn: Vector3 = Vector3(-2.4, 0.0, 0.0)
	_flicker(_part(hair, _cone(0.2, 0.7), flame, Vector3(0.0, 1.7, -0.62), ponytail_turn))
	for index: int in 7:
		var angle: float = -1.3 + index / 6.0 * 2.6
		var position_on_head: Vector3 = Vector3(sin(angle) * 0.38, 2.1, -0.1 - cos(angle) * 0.18)
		var cone: MeshInstance3D = _part(
			hair, _cone(0.2, 0.75), flame, position_on_head, Vector3(-0.35, 0.0, -angle * 0.55)
		)
		_flicker(cone)
	_flicker(_part(hair, _cone(0.18, 0.6), tip, Vector3(0.0, 2.5, -0.12), Vector3(-0.3, 0.0, 0.0)))
	var ball: MeshInstance3D = _part(
		_body,
		_sphere(0.2),
		_toon(Color("ffcf33"), Color("ff7a00"), 1.2, false),
		Vector3(0.62, 0.78, 0.25)
	)
	ball.name = "Fireball"
	_flicker(ball)
	var skirt: ShaderMaterial = _toon(look["legs"])
	_part(_body, _cylinder(0.3, 0.46, 0.28), skirt, Vector3(0.0, 0.45, 0.0))
	if skin_id == "lava":
		var cracks: Node3D = _group(_body, "LavaCracks")
		var lava: ShaderMaterial = _toon(look["tip"], Color("ff5a00"), 1.5, false)
		var lines: Array[Vector4] = [
			Vector4(-0.12, 1.02, 0.26, 0.45),
			Vector4(0.1, 0.84, 0.3, -0.5),
			Vector4(-0.02, 0.64, 0.24, 0.25),
		]
		for line: Vector4 in lines:
			var turn: Vector3 = Vector3(0.0, 0.0, line.w)
			_part(cracks, _box(line.z, 0.045, 0.03), lava, Vector3(line.x, line.y, 0.35), turn)
	elif skin_id == "phoenix":
		var wings: Node3D = _group(_body, "Wings")
		var feather: ShaderMaterial = _toon(look["wing"], look["hair"], 0.7)
		for side: float in [-1.0, 1.0]:
			var wing_at: Vector3 = Vector3(side * 0.7, 1.15, -0.35)
			var wing_turn: Vector3 = Vector3(0.3, 0.0, -side * 1.0)
			var flat: Vector3 = Vector3(1.0, 1.0, 0.3)
			_part(wings, _cone(0.35, 1.3, 4), feather, wing_at, wing_turn, flat)
		_legendary_glow(look["halo"])


func _build_rocko(look: Dictionary) -> void:
	var glow: Color = look.get("glow", Color.BLACK)
	var rock: ShaderMaterial = _toon(look["main"], glow, 0.45)
	var dark: ShaderMaterial = _toon(look["dark"], glow, 0.5)
	var moss: ShaderMaterial = _toon(
		look["moss"], look["moss"], 0.6 if glow != Color.BLACK else 0.0
	)
	var blocks: Node3D = _group(_body, "RockBlocks")
	for side: float in [-1.0, 1.0]:
		_part(_rig, _box(0.42, 0.4, 0.46), dark, Vector3(side * 0.3, 0.2, 0.0), Vector3(0, 0.3, 0))
		_part(
			blocks,
			_box(0.5, 0.48, 0.5),
			rock,
			Vector3(side * 0.8, 1.0, 0.05),
			Vector3(0.4, side * 0.6, side * 0.2)
		)
		_part(
			blocks, _box(0.4, 0.4, 0.4), dark, Vector3(side * 0.86, 0.55, 0.2), Vector3(0.3, 0.5, 0)
		)
	_part(blocks, _box(1.1, 1.0, 0.8), rock, Vector3(0.0, 0.95, 0.0), Vector3(0.0, 0.0, 0.04))
	_part(blocks, _box(0.55, 0.45, 0.1), dark, Vector3(0.0, 0.85, 0.42), Vector3(0.0, 0.0, 0.1))
	var moss_at: Vector3 = Vector3(0.05, 2.02, 0.0)
	_part(_head, _sphere(0.24), moss, moss_at, Vector3.ZERO, Vector3(1.3, 0.4, 1.1))
	_part(_head, _box(0.7, 0.55, 0.6), rock, Vector3(0.0, 1.74, 0.0), Vector3(0.0, 0.0, -0.04))
	_part(_head, _box(0.6, 0.1, 0.12), dark, Vector3(0.0, 1.88, 0.3), Vector3(0.0, 0.0, 0.08))
	_part(_head, _box(0.22, 0.05, 0.04), _toon(look["dark"]), Vector3(0.0, 1.57, 0.31))
	_eyes(_head, 1.7, 0.36, look["eyes"], 0.38)
	if skin_id == "crystal":
		var crystals: Node3D = _group(_body, "Crystals")
		var spots: Array[Vector4] = [
			Vector4(-0.55, 1.52, -0.15, 0.4),
			Vector4(0.52, 1.48, -0.15, -0.5),
			Vector4(0.0, 1.62, -0.3, 0.0),
		]
		for spot: Vector4 in spots:
			_crystal(crystals, moss, Vector3(spot.x, spot.y, spot.z), spot.w)


## A gem of two four-sided pyramids, base to base, tilted sideways by `tilt`.
func _crystal(parent: Node3D, material: Material, at: Vector3, tilt: float) -> void:
	var gem: Node3D = _group(parent, "Crystal", at)
	gem.rotation.z = tilt
	var half: Vector3 = Vector3(0.0, 0.24, 0.0)
	_part(gem, _cone(0.14, 0.34, 4), material, at + half, Vector3.ZERO, Vector3(0.8, 1.4, 0.8))
	var down: Vector3 = Vector3(PI, 0.0, 0.0)
	_part(gem, _cone(0.14, 0.34, 4), material, at - half, down, Vector3(0.8, 1.4, 0.8))


func _build_turbo(look: Dictionary) -> void:
	_human(look["skin"], look["main"], look["legs"], look["shoes"], look.get("glow", Color.BLACK))
	var neon: bool = look.get("neon", false)
	var helmet_shell: SphereMesh = _sphere(0.56)
	helmet_shell.is_hemisphere = true
	helmet_shell.height = 0.56
	var helmet_material: ShaderMaterial = _toon(
		look["helmet"], look["helmet"], 0.5 if neon else 0.0
	)
	var helmet: MeshInstance3D = _part(
		_head, helmet_shell, helmet_material, Vector3(0.0, 1.76, -0.02)
	)
	helmet.name = "Helmet"
	var visor_glow: Color = look["visor"] if neon else Color("2244aa")
	var visor: MeshInstance3D = _part(
		_head,
		_box(0.72, 0.2, 0.12),
		_toon(look["visor"], visor_glow, 1.0 if neon else 0.3),
		Vector3(0.0, 1.92, 0.5),
		Vector3(-0.35, 0.0, 0.0)
	)
	visor.name = "Visor"
	var stripe_glow: float = 0.8 if neon else 0.0
	var stripe: ShaderMaterial = _toon(look["stripe"], look["stripe"], stripe_glow, false)
	_part(_head, _box(0.14, 0.05, 1.0), stripe, Vector3(0.0, 2.31, -0.02), Vector3(0.2, 0, 0))
	var scarf: ShaderMaterial = _toon(look["stripe"], look["stripe"], stripe_glow)
	if neon:
		var strips: Node3D = _group(_body, "NeonStrips")
		for side: float in [-1.0, 1.0]:
			_part(strips, _box(0.05, 0.5, 0.03), stripe, Vector3(side * 0.16, 0.85, 0.355))
	_part(_body, _torus(0.22, 0.4), scarf, Vector3(0.0, 1.2, 0.0))
	_flicker(
		_part(
			_body, _box(0.16, 0.5, 0.06), scarf, Vector3(0.15, 1.05, -0.38), Vector3(0.5, 0.0, 0.3)
		)
	)


func _build_frosty(look: Dictionary) -> void:
	var fur: ShaderMaterial = _toon(look["main"], look.get("glow", Color.BLACK), 0.2)
	var face: ShaderMaterial = _toon(look["face"])
	var horn: ShaderMaterial = _toon(look["horn"], Color("7fd0ff"), 0.5)
	var horns: Node3D = _group(_head, "Horns")
	for side: float in [-1.0, 1.0]:
		_part(
			_rig,
			_sphere(0.24),
			fur,
			Vector3(side * 0.3, 0.2, 0.05),
			Vector3.ZERO,
			Vector3(1, .8, 1.2)
		)
		_part(
			_body,
			_capsule(0.17, 0.79),
			fur,
			Vector3(side * 0.7, 0.85, 0.05),
			Vector3(0.0, 0.0, side * 0.3)
		)
		_part(
			horns, _cone(0.1, 0.4), horn, Vector3(side * 0.44, 2.02, 0), Vector3(0, 0, -side * 0.6)
		)
	var body_fur: MeshInstance3D = _part(
		_body, _sphere(0.72), fur, Vector3(0.0, 0.95, 0.0), Vector3.ZERO, Vector3(1.0, 0.95, 0.9)
	)
	body_fur.name = "Fur"
	_part(_head, _sphere(0.52), fur, Vector3(0.0, 1.72, 0.0))
	for index: int in 3:
		var tuft: Vector3 = Vector3((index - 1) * 0.16, 2.2 - absf(index - 1) * 0.04, 0.02)
		_part(_head, _sphere(0.13), fur, tuft, Vector3.ZERO, Vector3(1.0, 1.3, 1.0))
	var face_patch: Vector3 = Vector3(1.0, 0.85, 0.75)
	_part(_head, _sphere(0.4), face, Vector3(0.0, 1.66, 0.22), Vector3.ZERO, face_patch)
	_eyes(_head, 1.72, 0.55)
	_part(
		_head, _sphere(0.08), _toon(look["nose"], Color.BLACK, 0.0, false), Vector3(0, 1.58, 0.53)
	)
	if skin_id == "snow_king":
		var gold: ShaderMaterial = _toon(Rarity.LEGENDARY_GOLD, Color("ffb000"), 0.5)
		var crown: Node3D = _group(_head, "Crown")
		_part(crown, _cylinder(0.3, 0.26, 0.18), gold, Vector3(0.0, 2.3, 0.0))
		for index: int in 5:
			var angle: float = index / 5.0 * TAU
			var spike_at: Vector3 = Vector3(sin(angle) * 0.27, 2.48, cos(angle) * 0.27)
			_part(crown, _cone(0.07, 0.2, 4), gold, spike_at)
		var gem: ShaderMaterial = _toon(Color("7fd6ff"), Color("2a8cff"), 1.0, false)
		_part(crown, _sphere(0.07), gem, Vector3(0.0, 2.3, 0.3))
		var cape: MeshInstance3D = _part(
			_body,
			_cylinder(0.5, 0.95, 1.2),
			_toon(look["cape"]),
			Vector3(0.0, 0.75, -0.3),
			Vector3.ZERO,
			Vector3(1.0, 1.0, 0.6)
		)
		cape.name = "Cape"
		_legendary_glow(look["halo"])


func _build_luna(look: Dictionary) -> void:
	var suit_glow: Color = look.get("glow", Color.BLACK)
	_human(look["fur"], look["main"], look["main"], look["accent"], suit_glow)
	var fur: ShaderMaterial = _toon(look["fur"])
	var inner: ShaderMaterial = _toon(look["inner"], Color.BLACK, 0.0, false)
	var whisker: ShaderMaterial = _toon(Color.WHITE, Color.BLACK, 0.0, false)
	var ears: Node3D = _group(_head, "Ears")
	for side: float in [-1.0, 1.0]:
		var turn: Vector3 = Vector3(0.0, PI / 4.0, side * -0.3)
		_part(ears, _cone(0.2, 0.4, 4), fur, Vector3(side * 0.3, 2.12, 0.0), turn)
		_part(ears, _cone(0.11, 0.24, 4), inner, Vector3(side * 0.3, 2.1, 0.08), turn)
		var whisker_turn: Vector3 = Vector3(0.0, 0.0, side * 0.15)
		_part(
			_head, _box(0.25, 0.02, 0.02), whisker, Vector3(side * 0.42, 1.55, 0.42), whisker_turn
		)
	_part(_head, _sphere(0.06), inner, Vector3(0.0, 1.6, 0.5))
	var tail: Node3D = _group(_body, "Tail")
	for index: int in 8:
		var angle: float = index / 7.0 * PI * 1.3
		var point: Vector3 = Vector3(0.12 * sin(angle * 0.5), 0.5 + sin(angle) * 0.35, -0.45)
		point.z -= (1.0 - cos(angle)) * 0.25
		_part(tail, _sphere(0.08 - index * 0.004), fur, point)
	var gun: Node3D = _group(_body, "RayGun")
	var metal: ShaderMaterial = _toon(look["metal"])
	var gun_turn: Vector3 = Vector3(0.0, 0.0, PI / 2.0)
	_part(gun, _cylinder(0.07, 0.1, 0.45), metal, Vector3(0.84, 0.74, 0.12), gun_turn)
	_part(gun, _box(0.08, 0.2, 0.1), metal, Vector3(0.66, 0.62, 0.12), Vector3(0.0, 0.0, 0.3))
	_part(gun, _torus(0.09, 0.14), _toon(look["accent"]), Vector3(0.84, 0.74, 0.12), gun_turn)
	var beam: ShaderMaterial = _toon(look["accent"], look["accent"], 1.2, false)
	_flicker(_part(gun, _sphere(0.1), beam, Vector3(1.08, 0.74, 0.12)))
	var bubble: StandardMaterial3D = StandardMaterial3D.new()
	bubble.albedo_color = Color(0.75, 0.91, 1.0, 0.18)
	bubble.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	bubble.roughness = 0.0
	var helmet: MeshInstance3D = _part(_head, _sphere(0.68), bubble, Vector3(0.0, 1.68, 0.0))
	helmet.name = "SpaceHelmet"
	helmet.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	if skin_id == "galaxy":
		var stars: Node3D = _group(_body, "Stars")
		var star: StandardMaterial3D = _additive(Color.WHITE, 1.0)
		for index: int in 14:
			var angle: float = -1.2 + fmod(index * 0.83, 2.4)
			var star_at: Vector3 = Vector3(
				sin(angle) * 0.37, 0.55 + (index % 5) * 0.13, cos(angle) * 0.37
			)
			_part(stars, _sphere(0.028), star, star_at)
	elif skin_id == "supernova":
		var ring: MeshInstance3D = _part(
			_body,
			_torus(0.78, 0.86),
			_toon(look["accent"], look["accent"], 1.0, false),
			Vector3(0.0, 0.9, 0.0),
			Vector3(0.35, 0.0, 0.2)
		)
		ring.name = "NovaRing"
		_legendary_glow(look["halo"])


func _build_pixel(look: Dictionary) -> void:
	var glow: Color = look.get("glow", Color.BLACK)
	var shell: ShaderMaterial = _toon(look["main"], glow, 0.25)
	var trim: ShaderMaterial = _toon(
		look["trim"], look["trim"], 0.6 if glow != Color.BLACK else 0.0
	)
	var lit: ShaderMaterial = _toon(look["pixels"], look["pixels"], 1.2, false)
	for side: float in [-1.0, 1.0]:
		_part(_rig, _box(0.22, 0.45, 0.28), trim, Vector3(side * 0.2, 0.23, 0.0))
		_part(
			_body,
			_cylinder(0.08, 0.08, 0.45),
			shell,
			Vector3(side * 0.55, 0.9, 0.0),
			Vector3(0.0, 0.0, side * 0.5)
		)
		_part(_body, _box(0.2, 0.2, 0.2), trim, Vector3(side * 0.68, 0.68, 0.05))
	_part(_body, _box(0.8, 0.7, 0.55), shell, Vector3(0.0, 0.85, 0.0))
	_part(_body, _box(0.3, 0.2, 0.05), trim, Vector3(0.0, 0.9, 0.29))
	_part(_head, _box(1.0, 0.75, 0.75), shell, Vector3(0.0, 1.65, 0.0))
	var face: Node3D = _group(_head, "ScreenFace")
	_part(face, _box(0.82, 0.55, 0.05), _toon(look["screen"]), Vector3(0.0, 1.65, 0.38))
	var dots: Array[Vector2] = [
		Vector2(-0.2, 1.75),
		Vector2(0.2, 1.75),
		Vector2(-0.18, 1.5),
		Vector2(-0.06, 1.46),
		Vector2(0.06, 1.46),
		Vector2(0.18, 1.5),
	]
	for dot: Vector2 in dots:
		_part(face, _box(0.1, 0.1, 0.03), lit, Vector3(dot.x, dot.y, 0.42))
	_flicker(face)
	var antenna: Node3D = _group(_head, "Antenna")
	_part(antenna, _cylinder(0.03, 0.03, 0.35), trim, Vector3(0.0, 2.17, 0.0))
	_flicker(_part(antenna, _sphere(0.09), lit, Vector3(0.0, 2.38, 0.0)))
	if skin_id == "glitch":
		var ghosts: Node3D = _group(_head, "GlitchGhosts")
		for ghost_color: Color in [Color("00e5ff"), Color("ff2bd6")]:
			var shift: float = -0.06 if ghost_color == Color("00e5ff") else 0.06
			var ghost_material: StandardMaterial3D = _additive(ghost_color, 0.25)
			var ghost_at: Vector3 = Vector3(shift, 1.65, 0.0)
			_flicker(_part(ghosts, _box(1.0, 0.75, 0.75), ghost_material, ghost_at))
		_legendary_glow(look["halo"])


## Legendary skins: a soft halo, a ring of sparkles turning around the fighter and rising
## sparkles (`CPUParticles3D`: GPU particles are limited on WebGL with the Compatibility renderer).
func _legendary_glow(color: Color) -> void:
	var glow: Node3D = _group(_rig, "LegendaryGlow")
	var light: GradientTexture2D = GradientTexture2D.new()
	light.fill = GradientTexture2D.FILL_RADIAL
	light.fill_from = Vector2(0.5, 0.5)
	light.fill_to = Vector2(0.5, 0.0)
	light.gradient = Gradient.new()
	light.gradient.set_color(0, Color(color, 0.75))
	light.gradient.set_color(1, Color(color, 0.0))
	var halo_material: StandardMaterial3D = _additive(Color.WHITE, 1.0)
	halo_material.albedo_texture = light
	halo_material.billboard_mode = BaseMaterial3D.BILLBOARD_ENABLED
	var halo_quad: QuadMesh = QuadMesh.new()
	halo_quad.size = Vector2(3.0, 3.3)
	# Behind the fighter, so the light shines around it and does not tint it.
	var halo: MeshInstance3D = _part(glow, halo_quad, halo_material, Vector3(0.0, 1.15, -0.8))
	halo.name = "LegendaryHalo"
	halo.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	_flicker(halo)
	var ring: Node3D = _group(glow, "SparkleRing", Vector3(0.0, 1.1, 0.0))
	var sparkle: StandardMaterial3D = _additive(Color("fff6c8"), 1.0)
	for index: int in 10:
		var angle: float = index / 10.0 * TAU
		var at: Vector3 = Vector3(
			cos(angle) * 1.05, 1.1 + sin(angle * 3.0) * 0.35, sin(angle) * 1.05
		)
		_part(ring, _sphere(0.06), sparkle, at)
	_spinners.append(ring)
	glow.add_child(_sparkles(color))


func _sparkles(color: Color) -> CPUParticles3D:
	var particles: CPUParticles3D = CPUParticles3D.new()
	particles.name = "Sparkles"
	particles.position = Vector3(0.0, 1.1, 0.0)
	particles.amount = 24
	particles.lifetime = 1.6
	# Already sparkling in the first frame, also for still pictures.
	particles.preprocess = 1.6
	particles.emission_shape = CPUParticles3D.EMISSION_SHAPE_SPHERE
	particles.emission_sphere_radius = 1.1
	particles.direction = Vector3.UP
	particles.spread = 30.0
	particles.gravity = Vector3.ZERO
	particles.initial_velocity_min = 0.2
	particles.initial_velocity_max = 0.5
	var fade: Curve = Curve.new()
	fade.add_point(Vector2(0.0, 0.0))
	fade.add_point(Vector2(0.3, 1.0))
	fade.add_point(Vector2(1.0, 0.0))
	particles.scale_amount_curve = fade
	var mesh: SphereMesh = _sphere(0.05)
	mesh.radial_segments = 6
	mesh.rings = 3
	particles.mesh = mesh
	particles.material_override = _additive(color.lightened(0.5), 1.0)
	particles.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	return particles


# --- Shared parts -----------------------------------------------------------------------------


## Chibi kid body: big head, short legs; head centre at y = 1.65.
func _human(
	skin: Color, top: Color, legs: Color, shoes: Color, top_glow: Color = Color.BLACK
) -> void:
	var top_material: ShaderMaterial = _toon(top, top_glow, 0.5)
	var legs_material: ShaderMaterial = _toon(legs)
	var shoes_material: ShaderMaterial = _toon(shoes)
	var skin_material: ShaderMaterial = _toon(skin)
	for side: float in [-1.0, 1.0]:
		_part(_rig, _capsule(0.13, 0.51), legs_material, Vector3(side * 0.17, 0.3, 0.0))
		var shoe_scale: Vector3 = Vector3(1.0, 0.7, 1.35)
		var shoe_at: Vector3 = Vector3(side * 0.17, 0.1, 0.05)
		_part(_rig, _sphere(0.15), shoes_material, shoe_at, Vector3.ZERO, shoe_scale)
		var arm_turn: Vector3 = Vector3(0.0, 0.0, side * 0.45)
		_part(_body, _capsule(0.1, 0.5), top_material, Vector3(side * 0.47, 0.92, 0.0), arm_turn)
		_part(_body, _sphere(0.12), skin_material, Vector3(side * 0.58, 0.7, 0.03))
	_part(_body, _capsule(0.36, 1.02), top_material, Vector3(0.0, 0.85, 0.0))
	_part(_head, _sphere(0.5), skin_material, Vector3(0.0, 1.65, 0.0))
	_eyes(_head, 1.65, 0.5)


## Two big shiny cartoon eyes on the front of a head of radius `radius` centred at `y`: a dark
## pupil with a light shine on an outlined white (dark eyes only; bright eyes glow on their own),
## large enough to read on a card.
func _eyes(
	parent: Node3D, y: float, radius: float, color: Color = OUTLINE_COLOR, spread: float = 0.34
) -> void:
	var eye: ShaderMaterial = _toon(color, Color.BLACK, 0.0, false)
	var white: ShaderMaterial = _toon(Color.WHITE)
	var shine: StandardMaterial3D = StandardMaterial3D.new()
	shine.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	var dark: bool = color.get_luminance() < EYE_WHITE_BELOW
	for side: float in [-1.0, 1.0]:
		var x: float = side * radius * spread
		var z: float = sqrt(maxf(0.0, radius * radius - x * x)) * 0.92
		var eye_at: Vector3 = Vector3(x, y + radius * 0.05, z)
		if dark:
			var white_at: Vector3 = Vector3(x, y + radius * 0.07, z + radius * 0.03)
			var white_scale: Vector3 = Vector3(1.0, 1.3, 0.55)
			var eye_white: MeshInstance3D = _part(
				parent, _sphere(radius * 0.22), white, white_at, Vector3.ZERO, white_scale
			)
			eye_white.name = ("Left" if side < 0.0 else "Right") + "EyeWhite"
			eye_at.z += radius * 0.09
		var eye_scale: Vector3 = Vector3(1.0, 1.35, 0.6)
		var pupil: MeshInstance3D = _part(
			parent, _sphere(radius * 0.16), eye, eye_at, Vector3.ZERO, eye_scale
		)
		pupil.name = ("Left" if side < 0.0 else "Right") + "Pupil"
		var shine_at: Vector3 = Vector3(
			x + radius * 0.05, y + radius * 0.13, eye_at.z + radius * 0.08
		)
		_part(parent, _sphere(radius * 0.055), shine, shine_at)


# --- Building blocks --------------------------------------------------------------------------


func _group(parent: Node3D, group_name: String, at: Vector3 = Vector3.ZERO) -> Node3D:
	var group: Node3D = Node3D.new()
	group.name = group_name
	parent.add_child(group)
	group.position = at - _model_offset(parent)
	return group


## Adds a mesh; `at` is in model space (feet at the origin), whatever the parent.
func _part(
	parent: Node3D,
	mesh: Mesh,
	material: Material,
	at: Vector3,
	turn: Vector3 = Vector3.ZERO,
	stretch: Vector3 = Vector3.ONE
) -> MeshInstance3D:
	var part: MeshInstance3D = MeshInstance3D.new()
	part.mesh = mesh
	part.material_override = material
	parent.add_child(part)
	part.position = at - _model_offset(parent)
	part.rotation = turn
	part.scale = stretch
	return part


## Where a node of the rig sits in model space (the rig has no rotation while it is built).
func _model_offset(node: Node3D) -> Vector3:
	var offset: Vector3 = Vector3.ZERO
	var current: Node = node
	while current != self and current is Node3D:
		offset += (current as Node3D).position
		current = current.get_parent()
	return offset


func _flicker(node: Node3D) -> void:
	_flickers.append(node)
	_flicker_scales.append(node.scale)


## Cartoon material: cel shading, an optional glow and the dark outline (`ToonMaterials`).
func _toon(
	color: Color, glow: Color = Color.BLACK, glow_strength: float = 0.0, outlined: bool = true
) -> ShaderMaterial:
	return ToonMaterials.toon(color, glow, glow_strength, outlined)


## Bright light that adds to what is behind it: halos, sparkles, glitch copies.
func _additive(color: Color, alpha: float) -> StandardMaterial3D:
	var material: StandardMaterial3D = StandardMaterial3D.new()
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color(color, alpha)
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	material.blend_mode = BaseMaterial3D.BLEND_MODE_ADD
	return material


func _shadow_material() -> StandardMaterial3D:
	var material: StandardMaterial3D = StandardMaterial3D.new()
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color(0.0, 0.0, 0.0, 0.3)
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	return material


static func _sphere(radius: float) -> SphereMesh:
	var mesh: SphereMesh = SphereMesh.new()
	mesh.radius = radius
	mesh.height = radius * 2.0
	mesh.radial_segments = 24
	mesh.rings = 12
	return mesh


## A capsule `height` tall in all (Godot counts the round ends in the height).
static func _capsule(radius: float, height: float) -> CapsuleMesh:
	var mesh: CapsuleMesh = CapsuleMesh.new()
	mesh.radius = radius
	mesh.height = height
	return mesh


static func _cone(radius: float, height: float, sides: int = 14) -> CylinderMesh:
	var mesh: CylinderMesh = _cylinder(0.0, radius, height)
	mesh.radial_segments = sides
	return mesh


static func _cylinder(top_radius: float, bottom_radius: float, height: float) -> CylinderMesh:
	var mesh: CylinderMesh = CylinderMesh.new()
	mesh.top_radius = top_radius
	mesh.bottom_radius = bottom_radius
	mesh.height = height
	mesh.radial_segments = 16
	mesh.rings = 1
	return mesh


static func _box(width: float, height: float, depth: float) -> BoxMesh:
	var mesh: BoxMesh = BoxMesh.new()
	mesh.size = Vector3(width, height, depth)
	return mesh


## A ring lying flat (around the y axis).
static func _torus(inner_radius: float, outer_radius: float) -> TorusMesh:
	var mesh: TorusMesh = TorusMesh.new()
	mesh.inner_radius = inner_radius
	mesh.outer_radius = outer_radius
	return mesh
