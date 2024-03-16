shader_type spatial;

uniform float a;

void vertex() {
	//VERTEX.x = UV.x * a;
}

void fragment() {
	ALBEDO.r = UV.x * a;
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
