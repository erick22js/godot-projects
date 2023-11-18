shader_type spatial;
render_mode unshaded;

uniform sampler2D tex;
uniform vec2 texture_offset;
uniform vec2 texture_scale;

uniform vec4 m_color:hint_color;

uniform vec4 fog_color:hint_color;
uniform float fog_distance;

uniform vec4 upper_color:hint_color;
uniform float upper_m_grad;
uniform bool use_upper_color;
uniform vec4 downer_color:hint_color;
uniform float downer_m_grad;
uniform bool use_downer_color;

void fragment(){
	
	vec3 color = texture(tex, UV*texture_scale+texture_offset).xyz;
	color*=m_color.xyz;
	float dist = -VERTEX.z;
	float alpha_full = fog_color.a*(dist/fog_distance);
	if(dist>fog_distance) alpha_full = fog_color.a;
	
	color=(color*(1.-alpha_full)+fog_color.xyz*alpha_full);
	
	float posY = UV.y;
	
	if(use_upper_color){
		float alpha_grad = upper_color.a*(1.-posY*upper_m_grad); 
		if(alpha_grad<0.) alpha_grad = 0.;
		color = color*(1.-alpha_grad)+upper_color.xyz*(alpha_grad);
	}
	if(use_downer_color){
		float alpha_grad = downer_color.a*(posY*downer_m_grad); 
		color = color*(1.-alpha_grad)+downer_color.xyz*(alpha_grad);
	}
//
//	vec4 gradUpper = upper_color;
//	float len_alpha_upper = 1.-gradUpper.a*(posY);
//	vec4 gradDowner = downer_color*(1.-posY);
//	float len_alpha_downer = gradUpper.a;
//
//	color = color*(1.-len_alpha_upper)+gradUpper.xyz*(len_alpha_upper);
	
	ALBEDO = color;
}

void vertex(){
	
}
