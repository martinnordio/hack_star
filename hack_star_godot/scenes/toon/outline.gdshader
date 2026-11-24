shader_type spatial;
render_mode unshaded, cull_front, shadows_disabled;
// The dark outline (spec 09, D5): an inverted hull, drawn as the toon material's next pass. Each
// vertex moves out from the part's centre by `grow` metres (thick on close-ups, as the Svelte
// game's hull) and then by `width_px` pixels on screen (3 px while the shorter side of the view is
// up to 720 px, more on bigger screens), so the outline stays visible on a card and on a small
// fighter in the arena.

uniform vec4 outline_color : source_color = vec4(0.086, 0.059, 0.2, 1.0);
uniform float width_px = 3.0;
uniform float grow = 0.012;

void vertex() {
	// Out from the centre, not along the face normal: box corners stay closed.
	vec3 out_dir = length(VERTEX) > 0.0001 ? normalize(VERTEX) : NORMAL;
	vec4 clip = PROJECTION_MATRIX * (MODELVIEW_MATRIX * vec4(VERTEX + out_dir * grow, 1.0));
	vec3 view_dir = (MODELVIEW_MATRIX * vec4(out_dir, 0.0)).xyz;
	vec2 screen_dir = (PROJECTION_MATRIX * vec4(view_dir, 0.0)).xy;
	if (length(screen_dir) > 0.0001) {
		float pixels = width_px * max(1.0, min(VIEWPORT_SIZE.x, VIEWPORT_SIZE.y) / 720.0);
		clip.xy += normalize(screen_dir) * pixels * 2.0 / VIEWPORT_SIZE * clip.w;
	}
	POSITION = clip;
}

void fragment() {
	ALBEDO = outline_color.rgb;
}
