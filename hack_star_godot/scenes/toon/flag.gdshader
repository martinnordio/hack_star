shader_type spatial;
// A flag that waves in the wind (spec 09, L2, D26): the cloth bends more the farther it is from
// the pole (x = 0 at the pole, `length` at the free end); flags at other places wave out of step.
render_mode cull_disabled, unshaded;

uniform vec4 color : source_color = vec4(1.0, 0.25, 0.35, 1.0);
uniform float length = 0.9;
uniform float amplitude = 0.14;
uniform float speed = 4.0;

varying float shade;

void vertex() {
	float along = clamp(VERTEX.x / length, 0.0, 1.0);
	float phase = TIME * speed - VERTEX.x * 6.0 + NODE_POSITION_WORLD.x + NODE_POSITION_WORLD.z;
	VERTEX.z += sin(phase) * amplitude * along;
	VERTEX.y -= (1.0 - cos(phase)) * 0.03 * along;
	shade = 0.82 + 0.18 * cos(phase);
}

void fragment() {
	ALBEDO = color.rgb * shade;
}
