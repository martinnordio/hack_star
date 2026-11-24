shader_type canvas_item;
// The light sweep of a living fighter card (spec 09, M10, D40): a soft diagonal band of light in
// the rarity's colour crosses the card picture, drawn over it (added) and only where the picture
// is. `progress` is the band's place along the diagonal (0 the top left corner, 1 the bottom
// right); outside about -0.3..1.3 nothing shows.
render_mode blend_add;

uniform vec4 band_color : source_color = vec4(1.0);
uniform float progress = -1.0;
uniform float width = 0.2;
uniform float strength = 0.75;

void fragment() {
	float along = (UV.x + UV.y) * 0.5;
	float band = smoothstep(width, 0.0, abs(along - progress));
	COLOR = vec4(band_color.rgb, band * strength * texture(TEXTURE, UV).a);
}
