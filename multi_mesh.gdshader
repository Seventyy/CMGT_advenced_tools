shader_type canvas_item;

uniform int a;
uniform float b;
uniform float c;

//const int instance_count = 4000;
//uniform vec2[instance_count] instances_positions;

uniform float grass_size;
uniform float world_size;

uniform vec2 wind_directon;
uniform float wind_speed;

uniform float horizontal_strength;
uniform float vertical_strength;

uniform vec4[2] grass_gradient : source_color;
uniform vec4 color_bend : source_color;

uniform sampler2D wind_noise_map;

varying float horizontal_gust;

void vertex() {
	vec2 vertex = vec2(0);
	horizontal_gust = texture(
		wind_noise_map,
		mod(MODEL_MATRIX[3].xy - wind_directon * TIME * wind_speed, world_size)/world_size
	).r;
	vertex.x = -pow(UV.y,2.) * -horizontal_strength * (horizontal_gust - 0.5) * 2.;
	VERTEX = (UV + vertex) * grass_size;
	VERTEX.y = -VERTEX.y;
	
}

void fragment() {
	COLOR = mix(mix(grass_gradient[0], grass_gradient[1], UV.y), color_bend, horizontal_gust);
}
