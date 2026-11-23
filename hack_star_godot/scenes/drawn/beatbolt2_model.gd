extends RefCounted
## Beatbolt2 (spec 09, part E, D53; credit in LICENSES.md): Echo â€” the sound-powered hero of
## Mattia's drawing, as the author's pictures show him in `characters/echo/` â€” rebuilt in 3D from
## shapes, starting from Beatbolt's model (`beatbolt_model.gd`, unchanged). The places and sizes
## are measured on Echo's idle frames: `_px` turns a pixel of the front frame (592 Ã— 503, the
## feet at y 498, the middle at x 300) into model space, so a part sits where it sits in the
## picture; the depth (z) is read from the side and back frames. The colours are the medians of
## regions of the frames (Step 46's Notes). Built with `FighterModel`'s building blocks, so the
## idle, run and attack animations and the see-through work as for every fighter of shapes.

const LOOKS: Dictionary = {
	"default":
	{
		"main": Color("07f6f8"),
		"hair_dark": Color("071896"),
		"hair_blue": Color("2e1ab9"),
		"hair_violet": Color("562be8"),
		"hair_light": Color("7e20df"),
		"lock": Color("a003cf"),
		"skin": Color("fec297"),
		"eyes": Color("03246e"),
		"brows": Color("450a77"),
		"white": Color("ebeaf6"),
		"teal": Color("007d97"),
		"teal_light": Color("06a5bc"),
		"collar": Color("012745"),
		"glow": Color("07f6f8"),
		"hem": Color("41e9f3"),
		"orange": Color("f47f0f"),
		"red": Color("e8322b"),
		"trousers": Color("1b2465"),
		"trousers_dark": Color("101959"),
		"shoes": Color("0c2f40"),
		"soles": Color("14fbfd"),
		"gloves": Color("23222b"),
	},
}
## The named parts that make Echo recognisable (checked by `test_beatbolt2.gd` and
## `test_drawn_fighter.gd`).
const IDEA_PARTS: Array[String] = [
	"SpikyHair", "MagentaLock", "Headphones", "ShoulderPads", "ArmCannon", "NeonSoles"
]
## Metres per pixel of Echo's front idle frame: his 480 px from the hair's tip to the soles
## become 2.2 m, about the height of the other fighters (the health bar stays above him).
const PX: float = 0.0046
const FRAME_MIDDLE_X: float = 300.0
const FRAME_FEET_Y: float = 498.0
const HEAD_AT: Vector3 = Vector3(0.0, 1.47, 0.0)
const HEAD_RADIUS: float = 0.37
## The hair cap: an ellipsoid over the top and the back of the head.
const HAIR_AT: Vector3 = Vector3(0.0, 1.68, -0.08)
const HAIR_SIZE: Vector3 = Vector3(0.42, 0.32, 0.4)
## The spikes: the tip as a pixel of the front frame (x, y), its depth z in metres, the radius
## at the root and the colour (0 dark blue, 1 blue, 2 violet, 3 light violet). The roots are
## inside the cap, on the line from its centre to the tip.
const SPIKES: Array[Vector4] = [
	Vector4(215.0, 25.0, 0.05, 3.22),
	Vector4(335.0, 18.0, -0.05, 2.18),
	Vector4(372.0, 30.0, -0.12, 1.16),
	Vector4(405.0, 55.0, -0.1, 2.18),
	Vector4(445.0, 95.0, -0.05, 1.2),
	Vector4(448.0, 140.0, 0.0, 1.18),
	Vector4(425.0, 185.0, -0.05, 0.16),
	Vector4(160.0, 95.0, 0.0, 2.2),
	Vector4(141.0, 130.0, 0.05, 1.2),
	Vector4(160.0, 180.0, 0.0, 0.18),
	Vector4(190.0, 215.0, 0.08, 1.14),
	Vector4(300.0, 245.0, -0.32, 0.2),
	Vector4(245.0, 232.0, -0.3, 1.18),
	Vector4(355.0, 232.0, -0.3, 0.18),
	Vector4(300.0, 45.0, -0.38, 2.18),
	Vector4(175.0, 160.0, -0.32, 1.18),
	Vector4(425.0, 165.0, -0.32, 1.18),
	Vector4(230.0, 70.0, -0.35, 3.16),
	Vector4(380.0, 75.0, -0.35, 1.16),
]
## The fringe over the forehead: the tip (pixel x, y of the front frame) of each lock.
const FRINGE: Array[Vector2] = [
	Vector2(236.0, 150.0),
	Vector2(252.0, 165.0),
	Vector2(280.0, 182.0),
	Vector2(304.0, 190.0),
	Vector2(330.0, 170.0),
	Vector2(356.0, 160.0),
]
## Where the arm cannon's grip and muzzle are (model space): out to his right, down and a little
## forwards, as in the idle frames.
const CANNON_GRIP: Vector3 = Vector3(-0.38, 0.81, 0.05)
const CANNON_MUZZLE: Vector3 = Vector3(-0.8, 0.16, 0.2)
const CANNON_SHOULDER: Vector3 = Vector3(-0.26, 1.06, 0.0)
## How far the headphone cups turn forwards from looking straight out (radians).
const CUP_TURN: float = 0.6
## The whole figure's scale.
const SIZE: float = 1.0


static func build(model: FighterModel, look: Dictionary) -> void:
	_legs(model, look)
	_jacket(model, look)
	_glove_arm(model, look)
	_arm_cannon(model, look)
	_face(model, look)
	_hair(model, look)
	_headphones(model, look)
	model.get_rig().scale = Vector3.ONE * SIZE


## A pixel of Echo's front idle frame in model space, with a depth `z` in metres.
static func _px(x: float, y: float, z: float = 0.0) -> Vector3:
	return Vector3((x - FRAME_MIDDLE_X) * PX, (FRAME_FEET_Y - y) * PX, z)


static func _toon(color: Color, glow: Color = Color.BLACK, strength: float = 0.0) -> Material:
	return ToonMaterials.toon(color, glow, strength)


static func _flat(color: Color, glow: Color = Color.BLACK, strength: float = 0.0) -> Material:
	return ToonMaterials.toon(color, glow, strength, false)


## The rotation that turns a shape's y axis (cones, cylinders, capsules) along `direction`.
static func _along(direction: Vector3) -> Vector3:
	return Basis(Quaternion(Vector3.UP, direction.normalized())).get_euler()


## A shape of `mesh` from `from` to `to` (its y axis along the line), squeezed by `flat` across.
static func _between(
	model: FighterModel,
	parent: Node3D,
	mesh: Mesh,
	material: Material,
	from: Vector3,
	to: Vector3,
	flat: float = 1.0
) -> MeshInstance3D:
	var turn: Vector3 = _along(to - from)
	return model.part(parent, mesh, material, (from + to) / 2.0, turn, Vector3(1.0, 1.0, flat))


static func _legs(model: FighterModel, look: Dictionary) -> void:
	var rig: Node3D = model.get_rig()
	var trousers: Material = _toon(look["trousers"])
	var pocket: Material = _toon(look["trousers_dark"])
	var shoes: Material = _toon(look["shoes"])
	var sock: Material = _flat(look["orange"])
	var soles: Node3D = model.group(rig, "NeonSoles")
	var sole: Material = _toon(look["soles"], look["soles"], 0.7)
	for side: float in [-1.0, 1.0]:
		var leg_turn: Vector3 = Vector3(0.0, 0.0, side * 0.08)
		model.part(
			rig,
			FighterModel.capsule(0.16, 0.62),
			trousers,
			Vector3(side * 0.18, 0.55, 0.0),
			leg_turn
		)
		var cuff_at: Vector3 = Vector3(side * 0.2, 0.34, 0.0)
		model.part(
			rig, FighterModel.sphere(0.18), trousers, cuff_at, Vector3.ZERO, Vector3(1.0, 0.7, 1.0)
		)
		var pocket_at: Vector3 = Vector3(side * 0.32, 0.52, 0.0)
		model.part(rig, FighterModel.box(0.06, 0.16, 0.14), pocket, pocket_at, leg_turn)
		var sock_at: Vector3 = Vector3(side * 0.23, 0.27, 0.03)
		model.part(rig, FighterModel.torus(0.07, 0.11), sock, sock_at)
		var foot_turn: Vector3 = Vector3(0.0, side * 0.25, 0.0)
		var shoe_at: Vector3 = Vector3(side * 0.27, 0.15, 0.06)
		model.part(
			rig, FighterModel.sphere(0.17), shoes, shoe_at, foot_turn, Vector3(1.15, 0.9, 1.5)
		)
		var sole_at: Vector3 = Vector3(side * 0.27, 0.03, 0.06)
		model.part(
			soles,
			FighterModel.cylinder(0.2, 0.2, 0.05),
			sole,
			sole_at,
			foot_turn,
			Vector3(0.95, 1.0, 1.3)
		)


## The white jacket: a teal glowing hem, the dark high collar, teal piping down the front, a
## glowing badge, the orange marks on the back and the round teal shoulder pads.
static func _jacket(model: FighterModel, look: Dictionary) -> void:
	var body: Node3D = model.get_body()
	var white: Material = _toon(look["white"])
	var teal: Material = _toon(look["teal"])
	var jacket: MeshInstance3D = model.part(
		body,
		FighterModel.capsule(0.27, 0.54),
		white,
		Vector3(0.0, 1.0, 0.0),
		Vector3.ZERO,
		Vector3(1.05, 1.0, 0.85)
	)
	jacket.name = "Jacket"
	model.part(
		body,
		FighterModel.torus(0.2, 0.29),
		_toon(look["hem"], look["hem"], 0.6),
		Vector3(0.0, 0.79, 0.0),
		Vector3.ZERO,
		Vector3(1.0, 1.0, 0.85)
	)
	model.part(
		body,
		FighterModel.cylinder(0.15, 0.2, 0.12),
		_toon(look["collar"]),
		Vector3(0.0, 1.2, 0.0),
		Vector3.ZERO,
		Vector3(1.0, 1.0, 0.9)
	)
	var piping: Material = _flat(look["teal"])
	for side: float in [-1.0, 1.0]:
		var piping_at: Vector3 = Vector3(side * 0.05, 0.98, 0.215)
		model.part(body, FighterModel.box(0.025, 0.4, 0.02), piping, piping_at)
		var mark_at: Vector3 = Vector3(side * 0.12, 0.97, -0.205)
		var mark_turn: Vector3 = Vector3(0.0, 0.0, side * 0.35)
		model.part(
			body, FighterModel.capsule(0.018, 0.32), _flat(look["orange"]), mark_at, mark_turn
		)
	model.part(body, FighterModel.box(0.03, 0.3, 0.02), piping, Vector3(0.0, 0.98, -0.215))
	model.part(
		body,
		FighterModel.box(0.06, 0.05, 0.02),
		_flat(look["glow"], look["glow"], 0.6),
		_px(318.0, 268.0, 0.215)
	)
	var pads: Node3D = model.group(body, "ShoulderPads")
	var rim: Material = _flat(look["orange"])
	for side: float in [-1.0, 1.0]:
		var pad_at: Vector3 = Vector3(side * 0.235, 1.1, 0.0)
		model.part(
			pads, FighterModel.sphere(0.11), teal, pad_at, Vector3.ZERO, Vector3(1.0, 0.85, 1.0)
		)
		var rim_at: Vector3 = Vector3(side * 0.27, 1.05, 0.0)
		model.part(pads, FighterModel.torus(0.08, 0.11), rim, rim_at, Vector3(0.0, 0.0, side * 0.6))


## The model's left arm (screen right from the front): white sleeve, teal cuff and a black
## fingerless glove with the fingertips showing.
static func _glove_arm(model: FighterModel, look: Dictionary) -> void:
	var body: Node3D = model.get_body()
	var arm_turn: Vector3 = Vector3(0.0, 0.0, 0.3)
	model.part(
		body,
		FighterModel.capsule(0.075, 0.4),
		_toon(look["white"]),
		Vector3(0.305, 0.905, 0.0),
		arm_turn
	)
	model.part(
		body,
		FighterModel.torus(0.06, 0.1),
		_toon(look["teal"]),
		Vector3(0.345, 0.77, 0.0),
		arm_turn
	)
	model.part(
		body,
		FighterModel.sphere(0.085),
		_toon(look["gloves"]),
		Vector3(0.36, 0.68, 0.02),
		Vector3.ZERO,
		Vector3(0.9, 1.05, 0.9)
	)
	model.part(body, FighterModel.sphere(0.04), _toon(look["skin"]), Vector3(0.36, 0.62, 0.07))


## The model's right arm holds the striped arm cannon (Echo's sound blaster) down and out to the
## side, its muzzle glowing; it fires Beatbolt2's shots (Luna's attack). The arm and the cannon
## are one group that turns around the shoulder.
static func _arm_cannon(model: FighterModel, look: Dictionary) -> void:
	var cannon: Node3D = model.group(model.get_body(), "ArmCannon", CANNON_SHOULDER)
	var white: Material = _toon(look["white"])
	var hand: Vector3 = CANNON_GRIP + Vector3(0.01, 0.02, -0.02)
	_between(
		model,
		cannon,
		FighterModel.capsule(0.075, 0.34),
		white,
		CANNON_SHOULDER,
		hand + Vector3.UP * 0.06
	)
	model.part(
		cannon,
		FighterModel.torus(0.06, 0.1),
		_toon(look["teal"]),
		hand + Vector3(0.015, 0.06, 0.0),
		_along(hand - CANNON_SHOULDER)
	)
	model.part(cannon, FighterModel.sphere(0.085), _toon(look["gloves"]), hand)
	var direction: Vector3 = (CANNON_MUZZLE - CANNON_GRIP).normalized()
	var length: float = (CANNON_MUZZLE - CANNON_GRIP).length()
	var turn: Vector3 = _along(direction)
	var tube_end: Vector3 = CANNON_GRIP + direction * (length - 0.1)
	var tube: Mesh = FighterModel.cylinder(0.065, 0.065, CANNON_GRIP.distance_to(tube_end))
	_between(model, cannon, tube, white, CANNON_GRIP, tube_end)
	var stripe: Material = _toon(look["teal_light"])
	for along: float in [0.16, 0.3, 0.44, 0.58, 0.72]:
		var stripe_at: Vector3 = CANNON_GRIP + direction * (length * along)
		model.part(cannon, FighterModel.cylinder(0.072, 0.072, 0.07), stripe, stripe_at, turn)
	var housing_at: Vector3 = CANNON_GRIP + direction * (length - 0.07)
	model.part(cannon, FighterModel.cylinder(0.095, 0.095, 0.1), white, housing_at, turn)
	var glow: Material = _toon(look["glow"], look["glow"], 1.0)
	model.part(cannon, FighterModel.torus(0.08, 0.13), glow, CANNON_MUZZLE, turn)
	var muzzle: MeshInstance3D = model.part(
		cannon,
		FighterModel.sphere(0.1),
		_toon(look["white"], look["glow"], 1.0),
		CANNON_MUZZLE + direction * 0.04
	)
	muzzle.name = "Muzzle"
	model.flicker(muzzle)


static func _face(model: FighterModel, look: Dictionary) -> void:
	var head: Node3D = model.get_head()
	model.part(
		head,
		FighterModel.sphere(HEAD_RADIUS),
		_toon(look["skin"]),
		HEAD_AT,
		Vector3.ZERO,
		Vector3(1.0, 0.95, 1.0)
	)
	model.eyes(head, 1.35, 0.42, look["eyes"], 0.43)
	var brows: Node3D = model.group(head, "Brows")
	var brow: Material = _flat(look["brows"])
	var mouth: Material = _flat(FighterModel.OUTLINE_COLOR)
	for side: float in [-1.0, 1.0]:
		var brow_at: Vector3 = Vector3(side * 0.17, 1.52, 0.3)
		var brow_turn: Vector3 = Vector3(-0.3, side * 0.45, side * 0.3)
		model.part(brows, FighterModel.box(0.17, 0.04, 0.04), brow, brow_at, brow_turn)
		# A small smile: the ends turn up.
		var mouth_at: Vector3 = Vector3(side * 0.03, 1.22, 0.31)
		var mouth_turn: Vector3 = Vector3(0.0, 0.0, side * 0.35)
		model.part(head, FighterModel.box(0.065, 0.02, 0.03), mouth, mouth_at, mouth_turn)


static func _hair(model: FighterModel, look: Dictionary) -> void:
	var colours: Array[Material] = [
		_toon(look["hair_dark"]),
		_toon(look["hair_blue"]),
		_toon(look["hair_violet"]),
		_toon(look["hair_light"]),
	]
	var hair: Node3D = model.group(model.get_head(), "SpikyHair")
	var cap: MeshInstance3D = model.part(
		hair, FighterModel.sphere(1.0), colours[1], HAIR_AT, Vector3.ZERO, HAIR_SIZE
	)
	cap.name = "HairCap"
	var back_hair_at: Vector3 = Vector3(0.0, 1.45, -0.12)
	model.part(
		hair,
		FighterModel.sphere(1.0),
		colours[0],
		back_hair_at,
		Vector3.ZERO,
		Vector3(0.4, 0.4, 0.32)
	)
	for spike: Vector4 in SPIKES:
		var tip: Vector3 = _px(spike.x, spike.y, spike.z)
		var root: Vector3 = HAIR_AT + (tip - HAIR_AT).normalized() * 0.22
		var radius: float = fmod(spike.w, 1.0)
		var material: Material = colours[int(spike.w)]
		_between(
			model, hair, FighterModel.cone(radius, root.distance_to(tip)), material, root, tip, 0.55
		)
	for index: int in FRINGE.size():
		var tip: Vector3 = _px(FRINGE[index].x, FRINGE[index].y, 0.3)
		var root: Vector3 = Vector3(tip.x * 0.75, 1.84, 0.18)
		var material: Material = colours[1 + index % 2]
		_between(
			model, hair, FighterModel.cone(0.11, root.distance_to(tip)), material, root, tip, 0.5
		)
	_magenta_lock(model, hair, look)


## A point on the hair cap's surface at a turn around y (0 front, + to the model's left) and a
## height angle (0 the widest ring, PI / 2 the top), a little outside it.
static func _on_hair(turn: float, height: float, out: float = 1.03) -> Vector3:
	var ring: Vector3 = Vector3(sin(turn) * cos(height), sin(height), cos(turn) * cos(height))
	return HAIR_AT + ring * HAIR_SIZE * out


## The glowing magenta lock runs over the crown from his front right to his back left, so it
## shows on the left of the picture from the front and from the back, as in Echo's frames.
static func _magenta_lock(model: FighterModel, hair: Node3D, look: Dictionary) -> void:
	var lock: Node3D = model.group(hair, "MagentaLock")
	var material: Material = _flat(look["lock"], look["lock"], 0.8)
	var points: Array[Vector3] = []
	for index: int in 6:
		var turn: float = -0.9 - index * 0.54
		var height: float = 0.55 + sin(index / 5.0 * PI) * 0.6
		points.append(_on_hair(turn, height))
	for index: int in points.size() - 1:
		var length: float = points[index].distance_to(points[index + 1]) + 0.07
		var segment: Mesh = FighterModel.capsule(0.035, length)
		_between(model, lock, segment, material, points[index], points[index + 1])


static func _headphones(model: FighterModel, look: Dictionary) -> void:
	var white: Material = _toon(look["white"])
	var glow: Material = _toon(look["glow"], look["glow"], 0.8)
	var disc: Material = _toon(look["teal"])
	var orange: Material = _flat(look["orange"])
	var phones: Node3D = model.group(model.get_head(), "Headphones")
	for side: float in [-1.0, 1.0]:
		# The cups look out and a little forwards, so their glowing rings show from the front.
		var outwards: Vector3 = Vector3(side * cos(CUP_TURN), 0.0, sin(CUP_TURN))
		var facing: Vector3 = _along(outwards)
		var cup_at: Vector3 = Vector3(side * 0.43, 1.42, 0.0)
		model.part(phones, FighterModel.cylinder(0.17, 0.17, 0.14), white, cup_at, facing)
		var ring_at: Vector3 = cup_at + outwards * 0.075
		model.part(phones, FighterModel.torus(0.11, 0.16), glow, ring_at, facing)
		var disc_at: Vector3 = cup_at + outwards * 0.07
		model.part(phones, FighterModel.cylinder(0.11, 0.11, 0.03), disc, disc_at, facing)
		var mark_at: Vector3 = cup_at + Vector3(side * -0.02, -0.08, 0.13)
		model.part(phones, FighterModel.box(0.03, 0.07, 0.03), orange, mark_at)
	var band: Array[Vector3] = []
	for index: int in 7:
		var angle: float = -1.15 + index / 6.0 * 2.3
		band.append(Vector3(sin(angle) * 0.45, 1.46 + cos(angle) * 0.52, 0.02))
	for index: int in band.size() - 1:
		var length: float = band[index].distance_to(band[index + 1]) + 0.09
		var segment: Mesh = FighterModel.capsule(0.045, length)
		_between(model, phones, segment, white, band[index], band[index + 1])
	var light: MeshInstance3D = model.part(
		phones,
		FighterModel.box(0.06, 0.05, 0.05),
		_toon(look["red"], look["red"], 0.6),
		Vector3(0.43, 1.6, 0.06)
	)
	light.name = "BeatLight"
	model.flicker(light)
