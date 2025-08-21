shader_type canvas_item;

uniform sampler2D piece_texture;
uniform sampler2D color_shining_gradient;
uniform vec4 outline_color : source_color;
uniform float outline_width = 0.03;
uniform float shining_freq = 15.;
uniform float shining_speed = 1.;
uniform float shining_intensity = 0.1;
uniform float shining_inverse_contrast = 1.0;
uniform vec2 shining_direction = vec2(1.0, 1.0);

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	float mask = texture(piece_texture, UV).a;

	vec2 outline_offset1 = vec2(outline_width, outline_width);
	vec2 outline_offset2 = vec2(-outline_width, outline_width);
	vec2 outline_offset3 = vec2(outline_width, -outline_width);
	vec2 outline_offset4 = vec2(-outline_width, -outline_width);
	float outline = texture(piece_texture, UV + outline_offset1).a - texture(piece_texture, UV ).a;
	outline += texture(piece_texture, UV + outline_offset2).a - texture(piece_texture, UV ).a;
	outline += texture(piece_texture, UV + outline_offset3).a - texture(piece_texture, UV ).a;
	outline += texture(piece_texture, UV + outline_offset4).a - texture(piece_texture, UV ).a;

	vec2 dir = shining_direction * UV;
	float shining_factor = (sin(TIME * shining_speed + (dir.x + dir.y) * shining_freq ) + shining_intensity) / shining_inverse_contrast;
	vec3 color_base = texture(color_shining_gradient, vec2(shining_factor)).rgb;
	COLOR = vec4(color_base, mask);
	if (outline > 0.3) {
		COLOR = vec4(outline_color.rgb, outline);
	}



}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
