class_name QrImage
extends RefCounted
## Draws a QR code (`QrCode`) as an image: black on white, a quiet zone of 4 modules around it,
## 8 pixels per module (spec 05, D10).

const MODULE_PIXELS: int = 8
const QUIET_MODULES: int = 4


## The image of `text`, or null when the text does not fit a QR code.
static func image_for(text: String) -> Image:
	var matrix: Array[Array] = QrCode.encode(text)
	if matrix.is_empty():
		return null
	var modules: int = matrix.size() + 2 * QUIET_MODULES
	var image: Image = Image.create(
		modules * MODULE_PIXELS, modules * MODULE_PIXELS, false, Image.FORMAT_RGB8
	)
	image.fill(Color.WHITE)
	for row: int in matrix.size():
		for column: int in matrix.size():
			if matrix[row][column]:
				var origin: Vector2i = (
					Vector2i(column + QUIET_MODULES, row + QUIET_MODULES) * MODULE_PIXELS
				)
				image.fill_rect(Rect2i(origin, Vector2i.ONE * MODULE_PIXELS), Color.BLACK)
	return image


static func texture_for(text: String) -> ImageTexture:
	var image: Image = image_for(text)
	if image == null:
		return null
	return ImageTexture.create_from_image(image)
