shader_type canvas_item;

uniform sampler2D piece_texture;
uniform vec4 color : source_color;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	float mask = texture(piece_texture, UV).a;
	COLOR = vec4(color.rgb, mask);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
