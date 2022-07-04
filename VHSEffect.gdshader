shader_type canvas_item;

uniform sampler2D vignette_texture;
uniform sampler2D noise_texture;
uniform sampler2D noisier_texture;
uniform sampler2D scanlines_texture;
uniform float speed ;//= 4;
uniform float noise_offset = 0.8;

float sawtooth_funky(float period, float offset){
	return 2.0*(TIME/sin(TIME*period) - floor(0.5 + TIME/sin(TIME*period))) 
				* 0.5+0.5 + offset;
}

float sawtooth(float period, float offset){
	return 2.0*(TIME/period - floor(0.5 + TIME/period)) 
				* 0.5+0.5 + offset;
}

float desmos_sound(){
	return exp(sin(tan(TIME)))*0.4-0.1;
}

vec2 uv_curved(vec2 uv) {
	uv = (uv - 0.5) * 2.0; //transform uv space to be -0.5 to 0.5 for better manipulation

	uv.x *= 1.0 + pow(abs(uv.y) / 3.0, 2.0);
	uv.y *= 1.0 + pow(abs(uv.x) / 5.0, 2.0);

	uv /= 1.1;
	uv = (uv * 0.5) + 0.5; //revert UV space back to 0 to 1 
	return uv;
}

void fragment(){
	//noises
	vec2 noise_uv = UV;
	noise_uv.y -= sawtooth_funky(speed, noise_offset);
	vec2 extra_noise = UV;
	extra_noise.y += sawtooth_funky(speed, noise_offset);
	vec2 screen_noise = UV;
	screen_noise.x = desmos_sound();
	screen_noise.y -= sawtooth(15,0);
	//scanlines
	vec2 scanlines_uv = UV;
	scanlines_uv.y += sawtooth(10,0);
	vec4 screen_color = texture(SCREEN_TEXTURE, uv_curved(SCREEN_UV));
	float r = texture(SCREEN_TEXTURE, uv_curved(SCREEN_UV) + vec2(SCREEN_PIXEL_SIZE.x * 2.5, 0.0)).r;
	float g = texture(SCREEN_TEXTURE, uv_curved(SCREEN_UV) + vec2(SCREEN_PIXEL_SIZE.x * 2.0, 0.0)).g;
	float b = texture(SCREEN_TEXTURE, uv_curved(SCREEN_UV) + vec2(SCREEN_PIXEL_SIZE.x* 1.6, 0.0)).b;
	screen_color.r = r;
	screen_color.g = g;
	screen_color.b = b;
	screen_color += texture(noise_texture, noise_uv).a;
	screen_color += texture(noise_texture, extra_noise).a;
	screen_color += texture(noisier_texture, screen_noise).a / 3.5;
	screen_color -= texture(scanlines_texture, scanlines_uv).a;
	screen_color -= texture(vignette_texture, UV).a;

	
	//COLOR = vec4(scanlines_uv, 0, 1);
	COLOR = vec4(screen_color);
}