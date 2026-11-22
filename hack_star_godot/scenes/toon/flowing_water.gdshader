shader_type spatial;
// Cartoon water that flows (spec 09, L2, D26): bands of light ripple along `flow` (UV units per
// second) over the water colour; the canyon's stream flows along u, a waterfall down v and fades
// out at its foot (`foot_fade`).
render_mode cull_disabled, unshaded, depth_draw_opaque;

uniform vec4 water : source_color = vec4(0.18, 0.83, 0.78, 1.0);
uniform vec4 highlight : source_color = vec4(0.74, 0.99, 0.96, 1.0);
uniform vec2 flow = vec2(1.0, 0.0);
uniform vec2 bands = vec2(12.0, 2.0);
uniform float foot_fade = 0.0;

void fragment() {
	vec2 direction = normalize(flow);
	vec2 at = UV * bands - flow * TIME;
	float along = dot(at, direction);
	float across = dot(at, vec2(-direction.y, direction.x));
	float wave = sin(along * 6.2832 + sin(across * 6.2832) * 1.4);
	ALBEDO = mix(water.rgb, highlight.rgb, smoothstep(0.55, 0.9, wave));
	ALPHA = water.a * (1.0 - foot_fade * smoothstep(0.55, 1.0, UV.y));
}
