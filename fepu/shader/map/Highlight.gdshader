shader_type spatial;
render_mode blend_mix;

uniform bool enabled = false;

uniform sampler2D stex:hint_screen_texture;

void fragment() {
	if (enabled){
		EMISSION = texture(stex, SCREEN_UV).rgb*0.25 + vec3(1.0, 0.4, 0.4);
	}
	else{
		EMISSION = texture(stex, SCREEN_UV).rgb;
	}
}
