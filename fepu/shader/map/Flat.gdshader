shader_type spatial;
render_mode unshaded;

uniform vec3 color = vec3(1.0, 1.0, 1.0);

uniform vec2 texture_uv = vec2(0.0, 0.0);
uniform sampler2D tex: filter_nearest;


void vertex() {
	COLOR.rgb *= color;
	UV = VERTEX.xz + texture_uv;
}

void fragment() {
	// Place fragment code here.
	vec2 uv = UV / vec2(textureSize(tex, 0));
	ALBEDO.rgb = texture(tex, uv).xyz * COLOR.rgb * 0.5;
}
