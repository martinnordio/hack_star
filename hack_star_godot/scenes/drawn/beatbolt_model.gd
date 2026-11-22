extends RefCounted
## Beatbolt, from Mattia's drawing (spec 09, part A; credit in LICENSES.md): a chibi kid with
## spiky purple and navy hair crossed by a pink streak, big white-and-teal headphones (an orange
## mark on each cup, a red light on top of one), big dark-blue eyes under serious brows, a white
## jacket with teal collar, trim and shoulder pad, navy trousers, black shoes, a black fingerless
## glove on one hand and a long white tube arm cannon on the other. The drawing shows the front
## only: the back and the sides are guessed. Built from shapes with `FighterModel`'s building
## blocks, so the idle, run and attack animations and the see-through work as for every fighter.

const LOOKS: Dictionary = {
	"default":
	{
		"main": Color("6a2c9c"),
		"hair_dark": Color("2c2b88"),
		"streak": Color("ffb3cf"),
		"skin": Color("f7c97e"),
		"eyes": Color("1d2f8f"),
		"jacket": Color("f2f4f7"),
		"teal": Color("1f8a8c"),
		"orange": Color("ff9a2e"),
		"red": Color("e8322b"),
		"trousers": Color("1f2c7a"),
		"black": Color("23232b"),
	},
}
## Centre of the head; the hair and the headphones sit around it.
const HEAD_AT: Vector3 = Vector3(0.0, 1.68, 0.0)
const HEAD_RADIUS: float = 0.52
## The hair cap: centre and size (an ellipsoid over the back and the top of the head).
const HAIR_AT: Vector3 = Vector3(0.0, 1.9, -0.08)
const HAIR_SIZE: Vector3 = Vector3(0.6, 0.44, 0.54)
## The big hair locks, swept to both sides as in the drawing: turn around z (0 up, + to the
## model's right = screen left), tilt around x (+ forwards), length, and 1 for navy, 0 for purple.
const LOCKS: Array[Vector4] = [
	Vector4(0.4, 0.1, 0.55, 1.0),
	Vector4(1.1, 0.15, 1.05, 0.0),
	Vector4(1.55, 0.2, 0.95, 1.0),
	Vector4(2.05, 0.1, 0.6, 0.0),
	Vector4(-0.3, 0.05, 0.6, 0.0),
	Vector4(-1.0, 0.1, 1.05, 1.0),
	Vector4(-1.55, 0.05, 0.9, 0.0),
	Vector4(-2.1, -0.1, 0.65, 1.0),
	Vector4(0.5, -1.0, 0.7, 0.0),
	Vector4(-0.5, -1.0, 0.7, 1.0),
	Vector4(0.0, -1.7, 0.6, 1.0),
]
## The fringe over the forehead: x of each lock (navy and purple in turn).
const FRINGE: Array[float] = [-0.34, -0.17, 0.0, 0.17, 0.34]
## Where the long white tube points: out to the side, down and forwards.
const CANNON_DIRECTION: Vector3 = Vector3(-0.5, -0.5, 0.71)
const CANNON_LENGTH: float = 1.1
## The whole figure's scale.
const SIZE: float = 0.85


static func build(model: FighterModel, look: Dictionary) -> void:
	_body(model, look)
	_face(model, look)
	_hair(model, look)
	_headphones(model, look)
	_glove_arm(model, look)
	_arm_cannon(model, look)
	# The big hair and the headphones make him taller than the others: scaled down, the
	# headphone band stays under the health bar (`Fighter.BAR_Y`).
	model.get_rig().scale = Vector3.ONE * SIZE


static func _toon(color: Color, glow: Color = Color.BLACK, strength: float = 0.0) -> Material:
	return ToonMaterials.toon(color, glow, strength)


static func _flat(color: Color) -> Material:
	return ToonMaterials.toon(color, Color.BLACK, 0.0, false)


static func _body(model: FighterModel, look: Dictionary) -> void:
	var rig: Node3D = model.get_rig()
	var body: Node3D = model.get_body()
	var trousers: Material = _toon(look["trousers"])
	var black: Material = _toon(look["black"])
	var jacket: Material = _toon(look["jacket"])
	var teal: Material = _toon(look["teal"])
	for side: float in [-1.0, 1.0]:
		var leg_turn: Vector3 = Vector3(0.0, 0.0, side * 0.12)
		model.part(
			rig,
			FighterModel.capsule(0.15, 0.56),
			trousers,
			Vector3(side * 0.2, 0.32, 0.0),
			leg_turn
		)
		var shoe_at: Vector3 = Vector3(side * 0.24, 0.1, 0.07)
		model.part(
			rig, FighterModel.sphere(0.16), black, shoe_at, Vector3.ZERO, Vector3(1.0, 0.7, 1.45)
		)
	var jacket_part: MeshInstance3D = model.part(
		body, FighterModel.capsule(0.37, 0.98), jacket, Vector3(0.0, 0.86, 0.0)
	)
	jacket_part.name = "Jacket"
	model.part(body, FighterModel.torus(0.3, 0.42), teal, Vector3(0.0, 0.5, 0.0))
	model.part(body, FighterModel.torus(0.16, 0.3), teal, Vector3(0.0, 1.22, 0.0))
	model.part(body, FighterModel.box(0.07, 0.55, 0.05), teal, Vector3(0.09, 0.86, 0.35))


static func _face(model: FighterModel, look: Dictionary) -> void:
	var head: Node3D = model.get_head()
	model.part(head, FighterModel.sphere(HEAD_RADIUS), _toon(look["skin"]), HEAD_AT)
	model.eyes(head, HEAD_AT.y - 0.08, HEAD_RADIUS, look["eyes"], 0.38)
	var dark: Material = _flat(FighterModel.OUTLINE_COLOR)
	var brows: Node3D = model.group(head, "Brows")
	for side: float in [-1.0, 1.0]:
		var lid_at: Vector3 = Vector3(side * 0.2, 1.73, 0.5)
		var lid_turn: Vector3 = Vector3(-0.3, side * 0.35, side * 0.12)
		model.part(brows, FighterModel.box(0.2, 0.04, 0.04), dark, lid_at, lid_turn)
		var brow_at: Vector3 = Vector3(side * 0.2, 1.84, 0.46)
		var brow_turn: Vector3 = Vector3(-0.45, side * 0.35, side * 0.35)
		model.part(brows, FighterModel.box(0.2, 0.045, 0.04), dark, brow_at, brow_turn)
	# A small frown, as in the drawing.
	for side: float in [-1.0, 1.0]:
		var mouth_at: Vector3 = Vector3(side * 0.035, 1.42, 0.48)
		var mouth_turn: Vector3 = Vector3(0.0, 0.0, -side * 0.35)
		model.part(head, FighterModel.box(0.075, 0.025, 0.03), dark, mouth_at, mouth_turn)


## A point on the hair cap's surface at a turn around y (0 front, + to the model's right) and a
## height angle (0 the widest ring, PI / 2 the top), a little outside it.
static func _on_hair(turn: float, height: float, out: float = 1.02) -> Vector3:
	var ring: Vector3 = Vector3(-sin(turn) * cos(height), sin(height), cos(turn) * cos(height))
	return HAIR_AT + ring * HAIR_SIZE * out


static func _hair(model: FighterModel, look: Dictionary) -> void:
	var purple: Material = _toon(look["main"])
	var navy: Material = _toon(look["hair_dark"])
	var hair: Node3D = model.group(model.get_head(), "SpikyHair")
	var cap: MeshInstance3D = model.part(
		hair, FighterModel.sphere(1.0), purple, HAIR_AT, Vector3.ZERO, HAIR_SIZE
	)
	cap.name = "HairCap"
	model.part(hair, FighterModel.sphere(0.53), navy, HEAD_AT + Vector3(0.0, 0.0, -0.16))
	for lock: Vector4 in LOCKS:
		var direction: Vector3 = Vector3(-sin(lock.x), cos(lock.x), 0.0).rotated(
			Vector3.RIGHT, lock.y
		)
		var at: Vector3 = HAIR_AT + direction * (0.36 + lock.z * 0.4)
		var material: Material = navy if lock.w > 0.5 else purple
		var turn: Vector3 = Vector3(lock.y, 0.0, lock.x)
		model.part(
			hair, FighterModel.cone(0.24, lock.z), material, at, turn, Vector3(1.0, 1.0, 0.6)
		)
	for index: int in FRINGE.size():
		var x: float = FRINGE[index]
		var fringe_at: Vector3 = Vector3(x, 1.95 - absf(x) * 0.25, 0.5 - absf(x) * 0.22)
		var fringe_turn: Vector3 = Vector3(PI - 0.5, -x * 1.2, x * 0.9)
		var material: Material = navy if index % 2 == 0 else purple
		model.part(
			hair,
			FighterModel.cone(0.12, 0.42),
			material,
			fringe_at,
			fringe_turn,
			Vector3(1.0, 1.0, 0.5)
		)
	var streak_material: Material = _flat(look["streak"])
	var streak: Node3D = model.group(hair, "PinkStreak")
	for index: int in 4:
		var turn: float = 1.15 - index * 0.23
		var height: float = 0.25 + index * 0.16
		var at: Vector3 = _on_hair(turn, height, 1.03)
		var ahead: Vector3 = _on_hair(turn - 0.12, height + 0.08)
		var along: Vector3 = (ahead - _on_hair(turn + 0.12, height - 0.08)).normalized()
		var segment_turn: Vector3 = Basis(Quaternion(Vector3.UP, along)).get_euler()
		model.part(streak, FighterModel.capsule(0.04, 0.3), streak_material, at, segment_turn)


static func _headphones(model: FighterModel, look: Dictionary) -> void:
	var white: Material = _toon(look["jacket"])
	var teal: Material = _toon(look["teal"])
	var orange: Material = _flat(look["orange"])
	var phones: Node3D = model.group(model.get_head(), "Headphones")
	var sideways: Vector3 = Vector3(0.0, 0.0, PI / 2.0)
	for side: float in [-1.0, 1.0]:
		var cup_at: Vector3 = HEAD_AT + Vector3(side * 0.55, -0.04, 0.0)
		model.part(phones, FighterModel.cylinder(0.25, 0.25, 0.18), white, cup_at, sideways)
		var slider_at: Vector3 = cup_at + Vector3(side * 0.06, 0.32, 0.01)
		model.part(phones, FighterModel.capsule(0.07, 0.34), white, slider_at)
		model.part(
			phones,
			FighterModel.cylinder(0.18, 0.18, 0.06),
			teal,
			cup_at + Vector3(side * 0.1, 0.0, 0.02),
			sideways
		)
		model.part(
			phones,
			FighterModel.box(0.05, 0.12, 0.05),
			orange,
			cup_at + Vector3(side * 0.14, -0.08, 0.12)
		)
	for index: int in 7:
		var angle: float = -1.2 + (index + 0.5) / 7.0 * 2.4
		var at: Vector3 = HEAD_AT + Vector3(sin(angle) * 0.76, cos(angle) * 0.76, 0.02)
		model.part(
			phones, FighterModel.capsule(0.07, 0.36), white, at, Vector3(0.0, 0.0, PI / 2.0 - angle)
		)
	var light: MeshInstance3D = model.part(
		phones,
		FighterModel.box(0.13, 0.08, 0.08),
		_toon(look["red"], look["red"], 0.6),
		HEAD_AT + Vector3(0.58, 0.24, 0.06)
	)
	light.name = "BeatLight"
	model.flicker(light)


## The model's left arm (screen right): white sleeve, teal cuff, a black fingerless glove with the
## fingertips showing, and the round teal shoulder pad with an orange edge.
static func _glove_arm(model: FighterModel, look: Dictionary) -> void:
	var body: Node3D = model.get_body()
	var arm_turn: Vector3 = Vector3(0.0, 0.0, 0.4)
	model.part(
		body,
		FighterModel.capsule(0.11, 0.56),
		_toon(look["jacket"]),
		Vector3(0.5, 0.9, 0.05),
		arm_turn
	)
	model.part(
		body,
		FighterModel.torus(0.08, 0.14),
		_toon(look["teal"]),
		Vector3(0.6, 0.68, 0.06),
		arm_turn
	)
	model.part(body, FighterModel.sphere(0.13), _toon(look["black"]), Vector3(0.63, 0.58, 0.07))
	var skin: Material = _toon(look["skin"])
	for index: int in 3:
		var finger_at: Vector3 = Vector3(0.57 + index * 0.06, 0.46, 0.1)
		model.part(body, FighterModel.capsule(0.025, 0.12), skin, finger_at)
	var pad: MeshInstance3D = model.part(
		body,
		FighterModel.sphere(0.2),
		_toon(look["teal"]),
		Vector3(0.42, 1.12, 0.02),
		Vector3.ZERO,
		Vector3(1.0, 0.85, 1.0)
	)
	pad.name = "ShoulderPad"
	model.part(
		body,
		FighterModel.torus(0.15, 0.21),
		_flat(look["orange"]),
		Vector3(0.44, 1.02, 0.02),
		Vector3(0.0, 0.0, 0.5)
	)


## The model's right arm (screen left) is the long white tube from the drawing, held out and down;
## it is the arm cannon that fires Beatbolt's shots (Luna's attack).
static func _arm_cannon(model: FighterModel, look: Dictionary) -> void:
	var white: Material = _toon(look["jacket"])
	var cannon: Node3D = model.group(model.get_body(), "ArmCannon")
	var shoulder: Vector3 = Vector3(-0.46, 1.02, 0.06)
	model.part(cannon, FighterModel.sphere(0.15), white, shoulder)
	var direction: Vector3 = CANNON_DIRECTION.normalized()
	var turn: Vector3 = Basis(Quaternion(Vector3.UP, direction)).get_euler()
	var cuff_at: Vector3 = shoulder + direction * 0.12
	model.part(cannon, FighterModel.torus(0.12, 0.2), white, cuff_at, turn)
	model.part(
		cannon,
		FighterModel.torus(0.1, 0.16),
		_flat(look["orange"]),
		cuff_at + direction * 0.04 + Vector3(0.0, -0.04, 0.0),
		turn
	)
	var tube_at: Vector3 = shoulder + direction * (0.12 + CANNON_LENGTH / 2.0)
	model.part(cannon, FighterModel.cylinder(0.13, 0.13, CANNON_LENGTH), white, tube_at, turn)
	var end_at: Vector3 = shoulder + direction * (0.12 + CANNON_LENGTH)
	model.part(cannon, FighterModel.sphere(0.13), white, end_at)
