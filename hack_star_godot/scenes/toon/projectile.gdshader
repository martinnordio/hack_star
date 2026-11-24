shader_type spatial;
render_mode unshaded, cull_disabled, blend_mix, depth_draw_never, shadows_disabled, skip_vertex_transform;
// A picture shot (spec 09, D38): the fighter's projectile picture (flying to the picture's right)
// on a quad that faces the camera and is turned on the screen along the flight. The flight is the
// model's x axis (`Shot` turns the node). Flying to the left of the screen the picture is mirrored
// top to bottom, so its light stays on top. It is drawn `lift` metres nearer the camera, so the
// floor never cuts it in a steep view.

uniform sampler2D picture : source_color, filter_linear_mipmap, repeat_disable;
uniform float lift = 0.6;
// The pedestal's showcase shot fades out with its own material (shots in play stay at 1).
uniform float fade : hint_range(0.0, 1.0) = 1.0;

void vertex() {
	vec3 centre = (VIEW_MATRIX * vec4(MODEL_MATRIX[3].xyz, 1.0)).xyz;
	vec3 flight = mat3(VIEW_MATRIX) * MODEL_MATRIX[0].xyz;
	vec2 along = length(flight.xy) > 0.0001 ? normalize(flight.xy) : vec2(1.0, 0.0);
	vec2 across = vec2(-along.y, along.x);
	if (along.x < 0.0) {
		across = -across;
	}
	vec3 offset = vec3(VERTEX.x * along + VERTEX.y * across, 0.0);
	VERTEX = centre + offset + normalize(-centre) * lift;
	NORMAL = vec3(0.0, 0.0, 1.0);
}

void fragment() {
	vec4 color = texture(picture, UV);
	ALBEDO = color.rgb;
	ALPHA = color.a * fade;
}
