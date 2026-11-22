class_name CutoutMotion
extends RefCounted
## How a picture fighter (`CutoutFighters`) moves, a flat "paper" figure (spec 09, C4, C5, D23,
## D24): standing, it breathes (stretch and squash), bobs and sways around the view axis (the
## shader's `tilt`), each at its own speed; running, it hops with a squash on landing and leans
## towards where it looks. A shot shows a star at the picture's muzzle, a hit a white flash, and a
## knock-out tips the picture over and fades it. `FighterModel` applies the poses and effects.

const BREATH_SPEED: float = 2.2
const BREATH_STRETCH: float = 0.03
const BREATH_SQUASH: float = 0.02
const BOB_SPEED: float = 1.6
const BOB_HEIGHT: float = 0.04
const SWAY_SPEED: float = 0.9
const SWAY_ANGLE: float = 4.0 * PI / 180.0
const HOP_SPEED: float = 10.0
const HOP_HEIGHT: float = 0.18
const LAND_SQUASH: Vector2 = Vector2(1.08, 0.9)
const LEAN_ANGLE: float = 8.0 * PI / 180.0
const FLASH_SECONDS: float = 0.12
const MUZZLE_FLASH_SECONDS: float = 0.08
const MUZZLE_FLASH_SIZE: float = 1.5
const MUZZLE_FLASH_COLOR: Color = Color(1.0, 0.9, 0.45)
const KNOCK_OUT_TIP: float = 80.0 * PI / 180.0

static var _star: Texture2D


## The pose at `time` seconds: the body's lift over the feet (`lift`, metres), its scale
## (`scale`) and the picture's turn around the view axis (`tilt`, radians).
static func pose(time: float, running: bool, facing_left: bool) -> Dictionary:
	if running:
		var hop: float = absf(sin(time * HOP_SPEED))
		var landing: float = 1.0 - smoothstep(0.0, 0.35, hop)
		return {
			"lift": hop * HOP_HEIGHT,
			"scale":
			Vector3(lerpf(1.0, LAND_SQUASH.x, landing), lerpf(1.0, LAND_SQUASH.y, landing), 1.0),
			"tilt": LEAN_ANGLE if facing_left else -LEAN_ANGLE,
		}
	var wave: float = sin(time * BREATH_SPEED)
	return {
		# Up from the feet only, so the picture never sinks into the ground.
		"lift": (0.5 + 0.5 * sin(time * BOB_SPEED)) * BOB_HEIGHT,
		"scale": Vector3(1.0 - wave * BREATH_SQUASH, 1.0 + wave * BREATH_STRETCH, 1.0),
		"tilt": sin(time * SWAY_SPEED) * SWAY_ANGLE,
	}


## The muzzle star, hidden, under `parent`.
static func build_muzzle_flash(parent: Node3D) -> MeshInstance3D:
	var quad: QuadMesh = QuadMesh.new()
	quad.size = Vector2.ONE * MUZZLE_FLASH_SIZE
	var material: StandardMaterial3D = StandardMaterial3D.new()
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	# Over the picture and the floor, whatever their depth: drawn after the picture (both are
	# transparent, so the order decides).
	material.no_depth_test = true
	material.render_priority = 1
	material.albedo_color = MUZZLE_FLASH_COLOR
	material.albedo_texture = _star_texture()
	material.billboard_mode = BaseMaterial3D.BILLBOARD_ENABLED
	material.billboard_keep_scale = true
	var star: MeshInstance3D = MeshInstance3D.new()
	star.name = "MuzzleFlash"
	star.mesh = quad
	star.material_override = material
	star.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	star.visible = false
	parent.add_child(star)
	return star


## Puts the star where the picture's muzzle shows on screen: the picture stands at `body`, turns
## to the camera and shrinks with its foreshortening (`cutout.gdshader`), mirrored when `mirrored`.
static func place_muzzle_flash(
	star: Node3D, fighter_id: String, body: Node3D, mirrored: bool, camera: Camera3D
) -> void:
	var offset: Vector2 = CutoutFighters.muzzle_offset(fighter_id)
	if mirrored:
		offset.x = -offset.x
	var view: Basis = camera.global_basis.orthonormalized()
	var shrink: float = lerpf(1.0, clampf(view.y.y, 0.0, 1.0), CutoutFighters.FORESHORTEN)
	var stretch: Vector3 = body.global_basis.get_scale()
	var at: Vector3 = view.x * offset.x * stretch.x + view.y * offset.y * stretch.y
	# A little towards the camera, so the star is drawn over the picture.
	star.global_position = body.global_position + at * shrink + view.z * 0.3


# A white four-pointed star with a soft glow, drawn once.
static func _star_texture() -> Texture2D:
	if _star == null:
		var size: int = 64
		var image: Image = Image.create(size, size, false, Image.FORMAT_RGBA8)
		for y: int in size:
			for x: int in size:
				var point: Vector2 = (Vector2(x, y) + Vector2.ONE * 0.5) / size * 2.0 - Vector2.ONE
				var rays: float = maxf(
					1.0 - absf(point.y) * 5.0 - absf(point.x),
					1.0 - absf(point.x) * 5.0 - absf(point.y)
				)
				var glow: float = pow(clampf(1.0 - point.length() * 1.5, 0.0, 1.0), 1.5)
				image.set_pixel(x, y, Color(1.0, 1.0, 1.0, clampf(maxf(rays, glow), 0.0, 1.0)))
		_star = ImageTexture.create_from_image(image)
	return _star
