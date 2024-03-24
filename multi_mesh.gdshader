shader_type canvas_item;

uniform int a;
uniform float b;
uniform float c;

const int instance_count = 4000;
uniform vec2[instance_count] instances_positions;

uniform float grass_size;
uniform float world_size;

uniform vec2 wind_directon;
uniform float wind_speed;

uniform float horizontal_strength;
uniform float vertical_strength;

uniform sampler2D wind_noise_map;

varying vec4 color;

void vertex() {
	vec2 vertex = vec2(0);
	color = texture(wind_noise_map, mod(instances_positions[INSTANCE_ID] - wind_directon * TIME * wind_speed, world_size)/world_size);
	vertex.x = -pow(UV.y-1.,2.) * -horizontal_strength;
	VERTEX = (UV + vertex) * grass_size;
}

void fragment() {
	COLOR = color;
}