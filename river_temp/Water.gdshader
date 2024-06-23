shader_type spatial;

uniform vec3 albedo: source_color;
uniform vec3 albedo2: source_color;
uniform float metallic : hint_range(0.0, 1.0) = 0;
uniform float roughness : hint_range(0.0, 1.0) = 0.02;

uniform sampler2D texture_normal;
uniform sampler2D texture_normal2;

uniform vec2 wave_direction = vec2(2.0, 0.0);
uniform vec2 wave_direction2 = vec2(0.0, 1.0);
uniform float time_scale : hint_range(0.0, 0.2, 0.005) = 0.025;

uniform float alpha : hint_range(0.0, 1.0, 0.005) = 1.0;

float fresnel(float amount, vec3 normal, vec3 view){
	return pow((1.0 - clamp(dot(normalize(normal), normalize(view)), 0.0, 1.0)), amount);
}



void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Time calcs for wave's movement
	vec2 time = (TIME * wave_direction) * time_scale; // movement rate of first wave
	vec2 time2 = (TIME * wave_direction2) * time_scale; //Movement rate of secondw wave
	
	// blend texture maps into a single one 
	vec3 normal_blend = mix(texture(texture_normal,UV + time).rgb, texture(texture_normal2,UV+time).rgb, 0.5);
	
	// Calculate Fresnel
	float fresnel = fresnel(5.0, NORMAL, VIEW);
	vec3 surface_color = mix(albedo, albedo2, fresnel); // Interpolate albedo values by fresnel
	
	
	
	ALBEDO = surface_color;
	METALLIC = metallic;
	ROUGHNESS = roughness;
	NORMAL_MAP = normal_blend * vec3(1.5,.5,1);
	ALPHA = alpha;
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
