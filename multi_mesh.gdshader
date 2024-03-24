shader_type canvas_item;

uniform int a;
uniform float b;
uniform float c;

const int instance_count = 4000;
uniform vec2[instance_count] instances_positions;

uniform float grass_size;
uniform float world_size;
uniform float horizontal_strength;
uniform float vertical_strength;
uniform sampler2D wind_noise_map;

varying vec4 color;

void vertex() {
	//VERTEX.x = UV.x * a + (1.-UV.y) * texture(wind_noise_map, UV).r * c;
	//VERTEX.x = UV.x * a + (1.0-pow(UV.y,d)) * c;
	//VERTEX.x = UV.x * a + (pow(1.-UV.y, 2)) * c * texture(wind_noise_map, (MODEL_MATRIX * vec4(VERTEX + TIME*10000., 0.0, 1.0)).xy).r;
	//VERTEX.x = UV.x * grass_size + (1.0 - pow(UV.y,.5)) * c;
	
	vec2 vertex = vec2(0);
	
	//VERTEX.x = UV.x * grass_size;
	//VERTEX.y = UV.y * grass_size;
	
	//VERTEX = UV * grass_size + vertex;
	
	vertex.x = -pow(UV.y-1.,2.) * -horizontal_strength;
	////vertex.y = (1.-UV.y) * pow(vertical_strength, 2);
	VERTEX = (UV + vertex) * grass_size;
	
	color = texture(wind_noise_map, mod(instances_positions[INSTANCE_ID], world_size)/world_size);
	
	//vec2 world_pos = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
	//if (instances_positions[INSTANCE_ID].x >= b){
		//VERTEX.y += 50.;
	//}
}

void fragment() {
	COLOR = color;
	
	//COLOR.r = texture(wind_noise_map, instances_positions[insta])
	//COLOR.x = UV.x * a + (1.-UV.y) * texture(wind_noise_map, UV).r * c;
	//COLOR.y = UV.y * a;
	//COLOR = texture(TEXTURE, UV * b);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
