#define S(v, p) smoothstep(v+0.005, v, p)
#define PI 3.14159265359
#define TWO_PI 6.28318530718

uniform vec3      iResolution;           // viewport resolution (in pixels)
uniform float     iTime;                 // shader playback time (in seconds)
uniform float     iTimeDelta;            // render time (in seconds)
uniform int       iFrame;                // shader playback frame
uniform float     iChannelTime[4];       // channel playback time (in seconds)
uniform vec3      iChannelResolution[4]; // channel resolution (in pixels)
uniform vec4      iMouse;                // mouse pixel coords. xy: current (if MLB down), zw: click
// uniform samplerXX iChannel0..3;          // input channel. XX = 2D/Cube
uniform vec4      iDate;                 // (year, month, day, time in seconds)
uniform float     iSampleRate;           // sound sample rate (i.e., 44100)

vec2 tile(in vec2 uv, in float zoom)
{
    vec2 t = uv*zoom;
    t.x += step(1., mod(floor(uv.y*zoom),2.)) * .5;
    return fract(t);
}

float box(in vec2 uv, in vec2 size)
{
    float b = S(size.x, uv.x);
    b *= S(size.x, -uv.x);
    b *= S(size.y, uv.y);
    return b * S(size.y, -uv.y);
}


void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv =( fragCoord-.5*iResolution.xy)/iResolution.y;

    
    float b = box(tile(uv, 3.), vec2(.95, .95));
    
    vec3 col = vec3(b);

    fragColor = vec4(col,1.0);
}