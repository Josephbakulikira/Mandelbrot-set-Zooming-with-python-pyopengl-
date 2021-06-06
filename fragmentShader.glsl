#version 330 core
#define MAX_ITERATIONS 1000

uniform vec2  iMouse;
uniform float iTime;
uniform vec2  iResolution;

uniform float CenterX;
uniform float CenterY;
uniform float ZoomScale;
uniform vec4 ColorRanges;

in vec4 gl_FragCoord;
out vec4 frag_color;
out float frag_depth;

int GetIterations()
{
    //if you change the screen , change the value of offset X and offset Y till it the mandelbrot is centered on your screen
    float offsetX = 1.0f;
    float offsetY = 0.5f;
    float real = ((gl_FragCoord.x / 1080.0 - offsetX) * ZoomScale + CenterX )* 4.0;
    float imag = ((gl_FragCoord.y / 1080.0 - offsetY) * ZoomScale + CenterY )* 4.0;

    int iterations = 0;
    float real_number = real;
    float imaginary = imag;

    while (iterations < MAX_ITERATIONS)
    {
        float tmp_real = real;
        real = (pow(real, 2) - pow(imag, 2)) + real_number;
        imag = (2.0 * tmp_real * imag) + imaginary;

        float dist = pow(real, 2) + pow(imag, 2);

        if (dist > 4.0){
            break;
        }

        ++iterations;
    }
    return iterations;
}

vec4 GetColorValues()
{
    vec2 uv = gl_FragCoord.xy/iResolution.xy * 2.0 - 1.0;
    uv.x *= iResolution.x / iResolution.y;

    int iter = GetIterations();
    if (iter == MAX_ITERATIONS)
    {
        gl_FragDepth = 0.0f;
        return vec4(0.001f, 0.00f, 0.001f, 1.0f);
    }

    float iterations = float(iter) / MAX_ITERATIONS;
    gl_FragDepth = iterations;

    vec3 iColor = 0.5 + 0.5 * cos(iTime + uv.xyx + vec3(0.0, 2.0, 4.0));
    vec4 color_0 = vec4(0.0f, 0.0f, 0.0f, 1.0f);
    vec4 color_1 = vec4(iColor.x/2, 0.5f, 0.6f, 1.0f);
    vec4 color_2 = vec4(0.3f, iColor.y, 0.4f, 1.0f);
    vec4 color_3 = vec4(iColor, 1.0f);

    float fraction = 0.0f;
    if (iterations < ColorRanges[1])
    {
        fraction = (iterations - ColorRanges[0]) / (ColorRanges[1] - ColorRanges[0]);
        return mix(color_0, color_1, fraction);
    }
    else if(iterations < ColorRanges[2])
    {
        fraction = (iterations - ColorRanges[1]) / (ColorRanges[2] - ColorRanges[1]);
        return mix(color_1, color_2, fraction);
    }
    else
    {
        fraction = (iterations - ColorRanges[2]) / (ColorRanges[3] - ColorRanges[2]);
        return mix(color_2, color_3, fraction);
    }
}

void main()
{
    vec4 color = GetColorValues();
    frag_color = color;
}