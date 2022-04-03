shader_type canvas_item;

uniform float scan_line_jitter : hint_range(0.0,0.075) = 0.015;
uniform float horizontal_shake : hint_range(0.0,0.25) = 0.01;
uniform float color_drift : hint_range(0.0,0.1) = 0.03; 

float nrand(float x, float y) {
	return fract(sin(dot(vec2(x,y),vec2(12.9898, 78.233))) * 43758.5433);
}

void fragment() {
	float u = UV.x;
	float v = UV.y;
	
	float jitter = nrand(v, TIME) * 2.0 - 1.0;
	jitter *= step(0, abs(jitter)) * scan_line_jitter;
	float jump = mix(v, fract(v), 0.0);
	float shake = (nrand(TIME,2.0) - 0.5) * horizontal_shake;
	float drift = sin(jump) * color_drift;
	
	vec4 src1 = texture(TEXTURE, fract(vec2(u+jitter+shake,jump)));
	vec4 src2 = texture(TEXTURE, fract(vec2(u+jitter+shake+drift,jump)));
	COLOR = vec4(src1.r,src2.g,src1.b,src1.a);	
}