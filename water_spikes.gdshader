shader_type canvas_item;

uniform vec2 motion = vec2(0.0);
uniform float scale = 1.0;
uniform vec2 offset = vec2(0.0);
uniform vec2 frame_coords = vec2(0.0);

void vertex(){
	
	UV = (VERTEX + TIME * motion+offset) * TEXTURE_PIXEL_SIZE;
	
}