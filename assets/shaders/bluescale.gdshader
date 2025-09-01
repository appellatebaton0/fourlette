shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform float red_dist = 0.5;
uniform float dismalization = 0.5;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
    vec4 screen = textureLod(screen_texture, SCREEN_UV, 0.0).rgba;

	COLOR.r = screen.r * (1.0 - red_dist);
	COLOR.g = screen.g + (screen.r / (1.0 / red_dist / 2.0));
	COLOR.b = screen.b + (screen.r / (1.0 / red_dist / 2.0));
	
	COLOR.gb *= (1.0 - dismalization);
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
