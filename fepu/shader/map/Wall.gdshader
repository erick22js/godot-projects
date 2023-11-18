shader_type spatial;
render_mode unshaded;

uniform vec3 color = vec3(1.0, 1.0, 1.0);
uniform float color_top_stop = 100.0;
uniform float color_bottom_stop = -40.0;
uniform vec3 color_top = vec3(0.9, 0.9, 0.9);
uniform vec3 color_bottom = vec3(0.2, 0.2, 0.2);

uniform bool relative_uv = true;
uniform bool relative_gradient = false;

uniform vec2 texture_uv = vec2(0.0, 0.0);
uniform sampler2D tex: filter_nearest;

varying float abs_altitude;
varying float rel_altitude;
varying float uv_altitude;
varying float grad_altitude;

void vertex() {
	// Define individual altitudes
	abs_altitude = (MODEL_MATRIX * vec4(VERTEX, 1.0)).y;
	rel_altitude = abs_altitude - NODE_POSITION_WORLD.y;
	
	uv_altitude = relative_uv? rel_altitude: abs_altitude;
	grad_altitude = relative_gradient? rel_altitude: abs_altitude;
	
	COLOR.rgb *= color;
	UV = vec2(sqrt(VERTEX.x*VERTEX.x + VERTEX.z*VERTEX.z), uv_altitude) + texture_uv;
}

void fragment() {
	// Place fragment code here.
	vec2 uv = UV / vec2(textureSize(tex, 0));
	vec3 grad_color;
	{
		float v = (grad_altitude-color_bottom_stop) / (color_top_stop-color_bottom_stop);
		v = clamp(v, 0, 1);
		grad_color = mix(color_bottom, color_top, v);
	}
	ALBEDO.rgb = texture(tex, uv).xyz * COLOR.rgb * grad_color;
}
