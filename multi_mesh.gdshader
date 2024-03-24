shader_type canvas_item;

uniform float a;
uniform float b;
uniform float c;
uniform float d;
uniform sampler2D wind_noise_map;

void vertex() {
	//VERTEX.x = UV.x * a;
	//VERTEX.y = UV.y * a;


	vec2 world_pos = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
	//VERTEX.x = UV.x * a + (1.-UV.y) * texture(wind_noise_map, UV).r * c;
	//VERTEX.x = UV.x * a + (1.0-pow(UV.y,d)) * c;
	VERTEX.x = UV.x * a + (pow(1.-UV.y, 2)) * c * texture(wind_noise_map, (MODEL_MATRIX * vec4(VERTEX + TIME*10000., 0.0, 1.0)).xy).r;
	//VERTEX.x = UV.x * a + (1.0-pow(UV.y,.5))* c;
	VERTEX.y = UV.y * a;
	//VERTEX.x = world_pos.x;

	if (world_pos.x > 0. && world_pos.y > 0.) {
		//VERTEX.x = world_pos.x;
		//VERTEX.y = UV.y * a;
	}
}

void fragment() {

	//COLOR.x = UV.x * a + (1.-UV.y) * texture(wind_noise_map, UV).r * c;
	//COLOR.y = UV.y * a;
	//COLOR = texture(TEXTURE, UV * b);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
