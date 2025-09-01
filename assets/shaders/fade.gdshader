shader_type canvas_item;

uniform float progress = 0.5;

void fragment() {
	COLOR.a = max((2.0 * progress) - (UV.y), 0.0);
	// Called for every pixel the material is visible on.
}