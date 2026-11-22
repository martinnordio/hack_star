class_name UiScale
extends RefCounted
## How much the 2D interface is scaled so that it stays readable and touchable (spec 04, D13).
## The project's stretch (`canvas_items`, `expand`) shrinks a 1280-wide layout to the window, so
## on a narrow phone every pixel of the layout becomes a fraction of a screen pixel. The content
## scale factor raises the scale to at least `MIN_STRETCH`; the layouts then fit the smaller
## content area.

## The smallest scale of the interface: 28 px text stays above 14 px and the 80 px buttons
## above 44 px on the screen.
const MIN_STRETCH: float = 0.6


## The scale the project's stretch gives the layout of `base_size` in a window of `window_size`.
static func stretch(window_size: Vector2, base_size: Vector2) -> float:
	return minf(window_size.x / base_size.x, window_size.y / base_size.y)


## The content scale factor for the window (1.0 when the stretch alone is big enough).
static func factor(window_size: Vector2, base_size: Vector2) -> float:
	return maxf(1.0, MIN_STRETCH / stretch(window_size, base_size))


## Layout pixels to screen pixels with the factor applied.
static func total(window_size: Vector2, base_size: Vector2) -> float:
	return stretch(window_size, base_size) * factor(window_size, base_size)
