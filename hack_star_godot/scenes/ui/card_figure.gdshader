shader_type canvas_item;
// The figure on a living fighter card (spec 09, M10, D40): the frame with the dark outline of the
// fighters (`cutout.gdshader`'s ring of samples of the frame's alpha), so the small figure stands
// out from the card picture behind it. `radius_uv` is the outline's width in the frame's UV.

uniform vec4 outline_color : source_color = vec4(0.086, 0.059, 0.2, 1.0);
uniform vec2 radius_uv = vec2(0.015);

const int RING_SAMPLES = 12;

void fragment() {
	vec4 color = texture(TEXTURE, UV);
	float ring = 0.0;
	for (int i = 0; i < RING_SAMPLES; i++) {
		float angle = float(i) * TAU / float(RING_SAMPLES);
		vec2 uv = UV + vec2(cos(angle), sin(angle)) * radius_uv;
		// 0 outside the frame (no branch: the samples stay uniform).
		vec2 inside = step(vec2(0.0), uv) * step(uv, vec2(1.0));
		ring = max(ring, texture(TEXTURE, clamp(uv, vec2(0.0), vec2(1.0))).a * inside.x * inside.y);
	}
	float outline = smoothstep(0.3, 0.6, ring);
	COLOR = vec4(mix(outline_color.rgb, color.rgb, color.a), max(color.a, outline));
}
