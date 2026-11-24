shader_type canvas_item;
// A fighter picture rendered off-screen (premultiplied alpha); grey for a locked fighter.
render_mode blend_premul_alpha;

uniform bool grey = false;

void fragment() {
	if (grey) {
		float luminance = dot(COLOR.rgb, vec3(0.3, 0.59, 0.11));
		COLOR.rgb = vec3(luminance * 0.85);
	}
}
