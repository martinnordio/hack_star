shader_type spatial;
// Cel shading for fighters, arena and world props (spec 09, D5): every light gives three clear
// bands (lit, mid, none), the ambient light is the shadow tone; a thin light rim on the lit
// side. Works in the Compatibility renderer.

uniform vec4 albedo : source_color = vec4(1.0);
uniform vec4 emission : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform float emission_energy = 0.0;
// Brightness of the lit, mid and shadow bands, as a share of the light.
uniform float lit_band = 0.85;
uniform float mid_band = 0.5;
uniform float shadow_band = 0.0;
uniform float rim_strength = 0.25;
// MultiMesh props: each instance's colour (set_instance_color) tints the albedo.
uniform bool use_instance_color = false;

void fragment() {
	ALBEDO = use_instance_color ? albedo.rgb * COLOR.rgb : albedo.rgb;
	ROUGHNESS = 1.0;
	SPECULAR = 0.0;
	EMISSION = emission.rgb * emission_energy;
}

void light() {
	float facing = dot(NORMAL, LIGHT);
	// A surface in a cast shadow gets the shadow band, whatever it faces.
	float lit = ATTENUATION > 0.5 ? facing : -1.0;
	float band = mix(shadow_band, mid_band, smoothstep(-0.12, -0.04, lit));
	band = mix(band, lit_band, smoothstep(0.36, 0.44, lit));
	DIFFUSE_LIGHT += LIGHT_COLOR * band / PI;
	float rim = smoothstep(0.66, 0.72, 1.0 - dot(NORMAL, VIEW)) * smoothstep(0.1, 0.3, lit);
	SPECULAR_LIGHT += LIGHT_COLOR * rim * rim_strength / PI;
}
