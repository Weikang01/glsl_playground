#define S(v, p) smoothstep(v+0.005, v, p)

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

float rand(vec2 uv)
{
    return fract(sin(dot(uv.xy, vec2(233.12, 7661.32))) * 43758.5453123);
}

float truchetPattern(vec2 uv, float index)
{
    if (index < 0.5)
        return S(uv.x+.1, uv.y)-S(uv.x-.1,uv.y);
    else
        return S(uv.x+.1, 1.-uv.y)-S(uv.x-.1,1.-uv.y);
        
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = (fragCoord-.5*iResolution.xy)/iResolution.y;
    uv *= 10.;
    vec2 ipos = floor(uv);
    vec2 fpos = fract(uv);
    float index = rand(ipos);
    vec3 col = vec3(truchetPattern(fpos, index));

    fragColor = vec4(col,1.0);
}