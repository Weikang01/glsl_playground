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

float box(in vec2 uv,in vec2 size)
{
    vec2 hSize = .5 * size;
    float b;
    b = S(size.x,uv.x);
    b *= S(size.x,-uv.x);
    b *= S(size.y, uv.y);
    b *= S(size.y,-uv.y);
    return b;
}

float cross(in vec2 uv, float size)
{
    return box(uv, vec2(size, size * .25)) + box(uv, vec2(size * .25, size));
}

mat2 rotate(float angle)
{
    return mat2(cos(angle),-sin(angle),
                sin(angle), cos(angle));
}

mat2 scale(vec2 _scale)
{
    return mat2(_scale.x,0.,
                0.,_scale.y);
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = (fragCoord-.5*iResolution.xy)/iResolution.y;
    vec2 mouse = (iMouse.xy-.5*iResolution.xy)/iResolution.y;
    
    vec3 col = vec3(0);
    
    
    col += cross(rotate(sin(iTime)*PI) * (uv*8. - mouse*8.), 1.);


    fragColor = vec4(col,1.0);
}