shader_type canvas_item;

uniform float  lerp_precent: hint_range(0.0, 1.0, 0.05);
uniform vec3 rgb = vec3(1.0, 1.0, 1.0);

void fragment() {
	vec4 native_color = texture(TEXTURE, UV);
	vec4 target_color = mix(native_color, vec4(rgb, native_color.a), lerp_precent);
	COLOR = target_color;
}