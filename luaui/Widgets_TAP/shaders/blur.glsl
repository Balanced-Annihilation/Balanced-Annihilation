uniform sampler2D src;
uniform vec2 texelSize;

//declare stuff

#define HALF_KERNEL_WIDTH 1 //3
#define KERNEL_WIDTH (HALF_KERNEL_WIDTH * 16 + 1) //*2 + 1

#define SIGMA 0.5 //3.0 //0.5

float kernel[KERNEL_WIDTH];


// shameless copy of https://www.shadertoy.com/view/XdfGDH
// can be made significantly cheaper, but I'm lazy.

float normpdf(in float x, in float sigma)
{
	return 0.39894 * exp(-0.5 * x * x / (sigma * sigma)) / sigma;
}

void main(void) {
	vec2 C0 = gl_TexCoord[0].st;

	float Z = 0.0;
	for (int j = 0; j <= HALF_KERNEL_WIDTH; ++j) {
		kernel[HALF_KERNEL_WIDTH + j] = kernel[HALF_KERNEL_WIDTH - j] = normpdf(float(j), SIGMA);
	}

	//get the normalization factor (as the gaussian has been clamped)
	for (int j = 0; j < KERNEL_WIDTH; ++j) {
		Z += kernel[j];
	}

	gl_FragColor = vec4(0.0);

	//read out the texels
	for (int i = -HALF_KERNEL_WIDTH; i <= HALF_KERNEL_WIDTH; ++i)
	{
		for (int j = -HALF_KERNEL_WIDTH; j <= HALF_KERNEL_WIDTH; ++j)
		{
			vec2 offset = vec2(float(i), float(j)) * texelSize;
			gl_FragColor += kernel[HALF_KERNEL_WIDTH + j]*kernel[HALF_KERNEL_WIDTH + i] * texture(src, (C0 + offset));
		}
	}

	gl_FragColor /= (Z * Z);
}