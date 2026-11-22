shader_type spatial;
render_mode unshaded, cull_disabled, blend_mix, depth_draw_opaque, shadows_disabled;
// A picture fighter (spec 09, D21): the author's picture on a quad that turns to the camera
// (the model's own yaw does not matter), with a dark outline found
// from the picture's alpha in a ring of a fixed screen-pixel width (the width of `outline.gdshader`:
// `width_px` at 720 px, more on bigger screens, plus `grow` metres for close-ups). The quad is
// `pad` larger than the picture on each side, so the outline has room at the picture's border.
// `flash` mixes the picture to white (a hit), `fade` makes it see-through (cover, knock-out),
// `flip` mirrors it around the feet, `saturation` scales its colour.

uniform sampler2D picture : source_color, filter_linear_mipmap, repeat_disable;
uniform vec4 outline_color : source_color = vec4(0.086, 0.059, 0.2, 1.0);
uniform float width_px = 3.0;
// The `grow` of the outline in picture UV (metres / picture width and height).
uniform vec2 grow_uv = vec2(0.0);
uniform float pad = 0.05;
uniform float feet_x = 0.5;
uniform float flash : hint_range(0.0, 1.0) = 0.0;
uniform float fade : hint_range(0.0, 1.0) = 1.0;
uniform bool flip = false;
uniform float saturation = 1.0;
// How much of the camera's foreshortening the picture takes (0 none, 1 all).
uniform float foreshorten = 0.4;

const int RING_SAMPLES = 12;

void vertex() {
	UV = UV * (1.0 + 2.0 * pad) - vec2(pad);
	// Turned fully to the camera (as BaseMaterial3D's BILLBOARD_ENABLED), keeping the model's
	// scale. A camera that looks down sees an upright fighter shorter (by the cosine of its pitch,
	// the camera's up vector's y), so the picture shrinks around its feet by part of that: it keeps
	// its proportions and stays about as tall on screen as the fighters built from shapes, whose
	// heads and tops still show from above.
	VERTEX *= mix(1.0, clamp(INV_VIEW_MATRIX[1].y, 0.0, 1.0), foreshorten);
	MODELVIEW_MATRIX = VIEW_MATRIX * mat4(
		INV_VIEW_MATRIX[0], INV_VIEW_MATRIX[1], INV_VIEW_MATRIX[2], MODEL_MATRIX[3]);
	MODELVIEW_MATRIX = MODELVIEW_MATRIX * mat4(
		vec4(length(MODEL_MATRIX[0].xyz), 0.0, 0.0, 0.0),
		vec4(0.0, length(MODEL_MATRIX[1].xyz), 0.0, 0.0),
		vec4(0.0, 0.0, length(MODEL_MATRIX[2].xyz), 0.0),
		vec4(0.0, 0.0, 0.0, 1.0));
	MODELVIEW_NORMAL_MATRIX = mat3(MODELVIEW_MATRIX);
}

// The picture's alpha at `uv`, 0 outside the picture (no branch: the samples stay uniform).
float alpha_at(vec2 uv) {
	vec2 inside = step(vec2(0.0), uv) * step(uv, vec2(1.0));
	return texture(picture, clamp(uv, vec2(0.0), vec2(1.0))).a * inside.x * inside.y;
}

void fragment() {
	vec2 uv = UV;
	if (flip) {
		uv.x = 2.0 * feet_x - uv.x;
	}
	vec2 inside = step(vec2(0.0), uv) * step(uv, vec2(1.0));
	vec4 color = texture(picture, clamp(uv, vec2(0.0), vec2(1.0)));
	color.a *= inside.x * inside.y;
	// One screen pixel in picture UV, per axis.
	vec2 pixel_uv = vec2(length(vec2(dFdx(uv.x), dFdy(uv.x))), length(vec2(dFdx(uv.y), dFdy(uv.y))));
	float pixels = width_px * max(1.0, min(VIEWPORT_SIZE.x, VIEWPORT_SIZE.y) / 720.0);
	vec2 radius = pixel_uv * pixels + grow_uv;
	float ring = 0.0;
	for (int i = 0; i < RING_SAMPLES; i++) {
		float angle = float(i) * TAU / float(RING_SAMPLES);
		vec2 direction = vec2(cos(angle), sin(angle));
		ring = max(ring, alpha_at(uv + direction * radius));
		ring = max(ring, alpha_at(uv + direction * radius * 0.5));
	}
	float outline = smoothstep(0.35, 0.65, ring);
	vec3 rgb = color.rgb;
	float grey = dot(rgb, vec3(0.299, 0.587, 0.114));
	rgb = clamp(mix(vec3(grey), rgb, saturation), 0.0, 1.0);
	rgb = mix(rgb, vec3(1.0), flash);
	ALBEDO = mix(outline_color.rgb, rgb, color.a);
	ALPHA = max(color.a, outline) * fade;
	if (ALPHA < 0.01) {
		discard;
	}
}
