shader_type canvas_item;

uniform vec4 new_colour: source_color;

void fragment() {
	// Called for every pixel the material is visible on.
	vec4 curr_color = texture(TEXTURE, UV);
	COLOR.rgb = new_colour.rgb * curr_color.rgb;
}
