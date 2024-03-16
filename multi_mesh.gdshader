shader_type canvas_item;

uniform float a;

void vertex() {
	VERTEX.x = UV.x * a;
	VERTEX.y = UV.y * a;
}

void fragment() {
	COLOR.rg = UV;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
