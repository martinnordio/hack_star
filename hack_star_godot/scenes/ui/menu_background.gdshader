shader_type canvas_item;
// The menu background (spec 09, D6): a purple gradient, lighter behind the fighter, with slow
// soft light rays turning around a point above the middle. Drawn by the GPU, no texture.

uniform vec4 top_color : source_color = vec4(0.27, 0.16, 0.62, 1.0);
uniform vec4 bottom_color : source_color = vec4(0.12, 0.06, 0.32, 1.0);
uniform vec4 glow_color : source_color = vec4(0.55, 0.42, 0.95, 1.0);
uniform vec2 center = vec2(0.5, 0.42);
uniform float ray_count = 14.0;
uniform float ray_strength = 0.07;
// Turns per second of the rays (slow, so they never pull the eye).
uniform float ray_speed = 0.006;

void fragment() {
	// The background fills the screen, so the screen's shape is the rectangle's shape.
	vec2 aspect = vec2(SCREEN_PIXEL_SIZE.y / SCREEN_PIXEL_SIZE.x, 1.0);
	vec2 offset = (UV - center) * aspect;
	vec3 color = mix(top_color.rgb, bottom_color.rgb, UV.y);
	float distance_to_center = length(offset);
	color = mix(color, glow_color.rgb, smoothstep(0.75, 0.0, distance_to_center) * 0.55);
	float angle = atan(offset.y, offset.x) + TIME * ray_speed * 6.2832;
	float ray = smoothstep(-0.15, 0.25, sin(angle * ray_count));
	color += vec3(ray * ray_strength * smoothstep(0.05, 0.35, distance_to_center));
	COLOR = vec4(color, 1.0);
}
