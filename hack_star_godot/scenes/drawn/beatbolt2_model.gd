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
## The head is a little lower than wide.
const HEAD_FLATTEN: float = 0.95
## The middle of his right eye (the left one mirrors it), on the head's surface.
const EYE_AT: Vector2 = Vector2(0.17, 1.35)
## The hair cap: an ellipsoid over the top and the back of the head.
const HAIR_AT: Vector3 = Vector3(0.0, 1.68, -0.12)
const HAIR_SIZE: Vector3 = Vector3(0.42, 0.32, 0.38)
## The locks seen from the front: the tip as a pixel of the front frame (x, y), its depth z in
## metres, and the colour (0 dark blue, 1 blue, 2 violet, 3 light violet) plus the width at the
## root (the fraction). The roots are on the cap, on the line from its centre to the tip; each
## lock is a cone flattened front to back, so it reads broad from the front.
const LOCKS: Array[Vector4] = [
	Vector4(215.0, 25.0, 0.05, 3.28),
	Vector4(178.0, 72.0, 0.06, 3.2),
	Vector4(335.0, 18.0, -0.05, 3.2),
	Vector4(372.0, 30.0, -0.12, 1.18),
	Vector4(405.0, 55.0, -0.1, 3.2),
	Vector4(445.0, 95.0, -0.05, 1.22),
	Vector4(448.0, 140.0, 0.0, 1.2),
	Vector4(425.0, 185.0, -0.05, 0.18),
	Vector4(160.0, 95.0, 0.0, 2.22),
	Vector4(141.0, 130.0, 0.05, 1.22),
	Vector4(160.0, 180.0, 0.0, 0.2),
	Vector4(190.0, 215.0, 0.08, 1.16),
]
## The back of the hair is a burst of broad locks from a whorl, as in Echo's back frame: the tip
## as a pixel of the back frame (x, y; its x is mirrored), its depth z, the colour and width.
const BACK_WHORL: Vector3 = Vector3(0.0, 1.62, -0.48)
const BACK_LOCKS: Array[Vector4] = [
	Vector4(205.0, 100.0, -0.32, 3.22),
	Vector4(300.0, 45.0, -0.34, 2.22),
	Vector4(390.0, 95.0, -0.32, 2.22),
	Vector4(432.0, 180.0, -0.34, 1.22),
	Vector4(375.0, 238.0, -0.42, 0.22),
	Vector4(300.0, 250.0, -0.44, 0.24),
	Vector4(228.0, 238.0, -0.42, 1.22),
	Vector4(165.0, 185.0, -0.34, 1.22),
]
## The locks that sweep back on each side (model space for his left side, mirrored for his right):
## the tip and the colour and width; flattened side to side, so they read broad from the side
## and three-quarters, where Echo's hair streams back.
const SIDE_LOCKS: Array[Vector4] = [
	Vector4(0.42, 2.02, -0.42, 2.2),
	Vector4(0.52, 1.78, -0.58, 1.22),
	Vector4(0.48, 1.5, -0.6, 0.2),
]
## The glowing magenta stroke along the big crescent lock at the front of his right side (pixels
## of the front frame and depths).
const MAGENTA_FRONT: Array[Vector3] = [
	Vector3(212.0, 112.0, 0.24),
	Vector3(200.0, 76.0, 0.2),
	Vector3(224.0, 44.0, 0.14),
]
## The fringe over the forehead: the tip (pixel x, y of the front frame) of each lock.
const FRINGE: Array[Vector2] = [
	Vector2(240.0, 152.0),
	Vector2(266.0, 175.0),
	Vector2(300.0, 190.0),
	Vector2(330.0, 170.0),
	Vector2(356.0, 160.0),
]
## Where the arm cannon's grip and muzzle are (model space): out to his right, down and a little
## forwards, as in the idle frames.
const CANNON_GRIP: Vector3 = Vector3(-0.38, 0.81, 0.05)
const CANNON_MUZZLE: Vector3 = Vector3(-0.8, 0.16, 0.2)
const CANNON_SHOULDER: Vector3 = Vector3(-0.26, 1.06, 0.0)
## How far the headphone cups turn forwards from looking straight out (radians).
const CUP_TURN: float = 0.35
## The whole figure's scale.
const SIZE: float = 1.0
## How far the head is tilted back (radians).
const HEAD_LIFT: float = 0.2


static func build(model: FighterModel, look: Dictionary) -> void:
	_legs(model, look)
	_jacket(model, look)
	_glove_arm(model, look)
	_arm_cannon(model, look)
	_face(model, look)
	_hair(model, look)
	_headphones(model, look)
	# Lifted a little, so a camera from above (the arena's views) still sees his face under the
	# big hair, as every one of Echo's pictures shows it.
	model.get_head().rotation.x = -HEAD_LIFT
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


## A basis whose y axis runs along `along` and whose z axis is as close to `facing` as it can be.
static func _facing_basis(along: Vector3, facing: Vector3) -> Basis:
	var y: Vector3 = along.normalized()
	var z: Vector3 = (facing - y * facing.dot(y)).normalized()
	return Basis(y.cross(z), y, z)


## A hair lock from `root` to `tip`: a cone `width` wide at the root, flattened along `facing`
## (front to back by default), so it reads broad seen along `facing`.
static func _lock(
	model: FighterModel,
	parent: Node3D,
	material: Material,
	root: Vector3,
	tip: Vector3,
	width: float,
	facing: Vector3 = Vector3.BACK
) -> MeshInstance3D:
	var middle: Vector3 = (root + tip) / 2.0
	var basis: Basis = _facing_basis(tip - root, facing)
	var mesh: Mesh = FighterModel.cone(width, root.distance_to(tip))
	var stretch: Vector3 = Vector3(1.0, 1.0, 0.4)
	return model.part(parent, mesh, material, middle, basis.get_euler(), stretch)


static func _legs(model: FighterModel, look: Dictionary) -> void:
	var rig: Node3D = model.get_rig()
	var trousers: Material = _toon(look["trousers"])
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
		var sock_at: Vector3 = Vector3(side * 0.23, 0.27, 0.03)
		model.part(rig, FighterModel.torus(0.07, 0.11), sock, sock_at)
		var foot_turn: Vector3 = Vector3(0.0, side * 0.25, 0.0)
		var shoe_at: Vector3 = Vector3(side * 0.27, 0.15, 0.06)
		model.part(
			rig, FighterModel.sphere(0.17), shoes, shoe_at, foot_turn, Vector3(1.0, 0.9, 1.5)
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
	var stripe: Material = _flat(look["teal_light"])
	for along: float in [0.2, 0.37, 0.54, 0.71]:
		var stripe_at: Vector3 = CANNON_GRIP + direction * (length * along)
		model.part(cannon, FighterModel.cylinder(0.072, 0.072, 0.07), stripe, stripe_at, turn)
	var housing_at: Vector3 = CANNON_GRIP + direction * (length - 0.07)
	model.part(cannon, FighterModel.cylinder(0.095, 0.095, 0.1), white, housing_at, turn)
	var glow: Material = _toon(look["glow"], look["glow"], 1.0)
	model.part(cannon, FighterModel.torus(0.08, 0.13), glow, CANNON_MUZZLE, turn)
	var muzzle: MeshInstance3D = model.part(
		cannon,
		FighterModel.sphere(0.1),
		_toon(look["glow"], look["glow"], 1.0),
		CANNON_MUZZLE + direction * 0.04
	)
	muzzle.name = "Muzzle"
	model.flicker(muzzle)


## How far forwards the face's surface is at (x, y) of model space (0 off the head).
static func _face_depth(x: float, y: float) -> float:
	var up: float = (y - HEAD_AT.y) / HEAD_FLATTEN
	return sqrt(maxf(HEAD_RADIUS * HEAD_RADIUS - x * x - up * up, 0.0))


## Echo's big anime eyes, lying on the head: an outlined white a little taller than wide, a
## dark-blue iris filling most of it, a shine at its upper left and a thick upper lash.
static func _eyes(model: FighterModel, head: Node3D, look: Dictionary) -> void:
	var white: Material = _toon(Color.WHITE)
	var iris: Material = _flat(look["eyes"])
	var lash: Material = _flat(FighterModel.OUTLINE_COLOR)
	var shine: StandardMaterial3D = StandardMaterial3D.new()
	shine.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	var below: float = EYE_AT.y - HEAD_AT.y
	for side: float in [-1.0, 1.0]:
		var x: float = side * EYE_AT.x
		var z: float = _face_depth(x, EYE_AT.y)
		var normal: Vector3 = Vector3(x, below / (HEAD_FLATTEN * HEAD_FLATTEN), z).normalized()
		var basis: Basis = _facing_basis(Vector3.UP, normal)
		var at: Vector3 = HEAD_AT + Vector3(x, below, z)
		var label: String = "Left" if side < 0.0 else "Right"
		var eye_white: MeshInstance3D = model.part(
			head,
			FighterModel.sphere(0.11),
			white,
			at + normal * 0.005,
			basis.get_euler(),
			Vector3(1.0, 1.2, 0.3)
		)
		eye_white.name = label + "EyeWhite"
		var iris_at: Vector3 = at + normal * 0.022 + Vector3(0.0, -0.012, 0.0)
		var pupil: MeshInstance3D = model.part(
			head,
			FighterModel.sphere(0.085),
			iris,
			iris_at,
			basis.get_euler(),
			Vector3(0.9, 1.2, 0.3)
		)
		pupil.name = label + "Pupil"
		var shine_at: Vector3 = iris_at + normal * 0.022 + Vector3(-0.028, 0.04, 0.0)
		model.part(head, FighterModel.sphere(0.03), shine, shine_at)
		var lash_turn: Vector3 = (basis * Basis(Vector3.BACK, -side * 0.15)).get_euler()
		var lash_at: Vector3 = at + normal * 0.02 + Vector3(0.0, 0.115, 0.0)
		model.part(head, FighterModel.box(0.23, 0.035, 0.03), lash, lash_at, lash_turn)


static func _face(model: FighterModel, look: Dictionary) -> void:
	var head: Node3D = model.get_head()
	model.part(
		head,
		FighterModel.sphere(HEAD_RADIUS),
		_toon(look["skin"]),
		HEAD_AT,
		Vector3.ZERO,
		Vector3(1.0, HEAD_FLATTEN, 1.0)
	)
	_eyes(model, head, look)
	var brows: Node3D = model.group(head, "Brows")
	var brow: Material = _flat(look["brows"])
	var mouth: Material = _flat(FighterModel.OUTLINE_COLOR)
	for side: float in [-1.0, 1.0]:
		var brow_at: Vector3 = Vector3(side * 0.17, 1.53, _face_depth(0.17, 1.53))
		var brow_turn: Vector3 = Vector3(-0.3, side * 0.45, side * 0.3)
		model.part(brows, FighterModel.box(0.17, 0.04, 0.04), brow, brow_at, brow_turn)
		# A small smile: the ends turn up.
		var mouth_at: Vector3 = Vector3(side * 0.03, 1.22, _face_depth(0.03, 1.22))
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
	var back_hair_at: Vector3 = Vector3(0.0, 1.47, -0.1)
	model.part(
		hair,
		FighterModel.sphere(1.0),
		colours[0],
		back_hair_at,
		Vector3.ZERO,
		Vector3(0.38, 0.36, 0.3)
	)
	for lock: Vector4 in LOCKS:
		var tip: Vector3 = _px(lock.x, lock.y, lock.z)
		var root: Vector3 = HAIR_AT + (tip - HAIR_AT).normalized() * 0.3
		_lock(model, hair, colours[int(lock.w)], root, tip, fmod(lock.w, 1.0))
	for lock: Vector4 in BACK_LOCKS:
		var tip: Vector3 = _px(2.0 * FRAME_MIDDLE_X - lock.x, lock.y, lock.z)
		var outwards: Vector3 = ((BACK_WHORL + tip) / 2.0 - HAIR_AT).normalized()
		_lock(model, hair, colours[int(lock.w)], BACK_WHORL, tip, fmod(lock.w, 1.0), outwards)
	for lock: Vector4 in SIDE_LOCKS:
		for side: float in [-1.0, 1.0]:
			var tip: Vector3 = Vector3(side * lock.x, lock.y, lock.z)
			var root: Vector3 = HAIR_AT + (tip - HAIR_AT).normalized() * 0.3
			var width: float = fmod(lock.w, 1.0)
			_lock(model, hair, colours[int(lock.w)], root, tip, width, Vector3.RIGHT)
	for index: int in FRINGE.size():
		var tip: Vector3 = _px(FRINGE[index].x, FRINGE[index].y)
		tip.z = _face_depth(tip.x, tip.y) + 0.05
		var root: Vector3 = Vector3(tip.x * 0.8, 1.72, 0.0)
		root.z = _face_depth(root.x, root.y) + 0.08
		_lock(model, hair, colours[1 + index % 2], root, tip, 0.12)
	_magenta_lock(model, hair, look)


## The glowing magenta lock: a stroke along the big crescent lock at the front of his right side
## and one along the light violet lock at the back of his left side, so it shows on the left of
## the picture from the front and from the back, as in Echo's frames.
static func _magenta_lock(model: FighterModel, hair: Node3D, look: Dictionary) -> void:
	var lock: Node3D = model.group(hair, "MagentaLock")
	var material: Material = _flat(look["lock"], look["lock"], 0.8)
	var front: Array[Vector3] = []
	for point: Vector3 in MAGENTA_FRONT:
		front.append(_px(point.x, point.y, point.z))
	var back_lock: Vector4 = BACK_LOCKS[0]
	var back_tip: Vector3 = _px(2.0 * FRAME_MIDDLE_X - back_lock.x, back_lock.y, back_lock.z)
	var back: Array[Vector3] = []
	for t: float in [0.25, 0.6, 0.95]:
		var point: Vector3 = BACK_WHORL.lerp(back_tip, t)
		back.append(point + (point - HAIR_AT).normalized() * 0.06)
	for stroke: Array[Vector3] in [front, back]:
		for index: int in stroke.size() - 1:
			var length: float = stroke[index].distance_to(stroke[index + 1]) + 0.08
			var segment: Mesh = FighterModel.capsule(0.03, length)
			_between(model, lock, segment, material, stroke[index], stroke[index + 1])


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
		var shell: Vector3 = Vector3(1.0, 0.5, 1.0)
		model.part(phones, FighterModel.sphere(0.18), white, cup_at, facing, shell)
		var ring_at: Vector3 = cup_at + outwards * 0.075
		model.part(phones, FighterModel.torus(0.11, 0.16), glow, ring_at, facing)
		var disc_at: Vector3 = cup_at + outwards * 0.07
		model.part(phones, FighterModel.cylinder(0.11, 0.11, 0.03), disc, disc_at, facing)
		var mark_at: Vector3 = cup_at + Vector3(side * -0.02, -0.08, 0.13)
		model.part(phones, FighterModel.box(0.03, 0.07, 0.03), orange, mark_at)
	var band: Array[Vector3] = []
	for index: int in 4:
		var angle: float = -1.15 + index / 3.0 * 2.3
		band.append(Vector3(sin(angle) * 0.46, 1.46 + cos(angle) * 0.56, -0.02))
	for index: int in band.size() - 1:
		var length: float = band[index].distance_to(band[index + 1]) + 0.09
		var segment: Mesh = FighterModel.capsule(0.05, length)
		_between(model, phones, segment, white, band[index], band[index + 1])
	var light: MeshInstance3D = model.part(
		phones,
		FighterModel.box(0.06, 0.05, 0.05),
		_toon(look["red"], look["red"], 0.6),
		Vector3(0.43, 1.6, 0.06)
	)
	light.name = "BeatLight"
	model.flicker(light)
