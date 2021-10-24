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

float rand(float x)
{
    return fract(sin(x * 132.234)*1e4);
}

float rand(vec2 uv)
{
    return fract(sin(dot(uv.xy, vec2(233.12, 7661.32))) * 43758.5453123);
}

float noise(float x)
{
    float i = floor(x);
    float f = fract(x);
    float u = f * f * (3. - 2. * f);
    return mix(rand(i), rand(i+1.),f);
}

float noise (in vec2 uv) {
    vec2 i = floor(uv);
    vec2 f = fract(uv);
    
    float a = rand(i);
    float b = rand(i + vec2(1.,0.));
    float c = rand(i + vec2(0.,1.));
    float d = rand(i + vec2(1.,1.));

    vec2 u = f * f * (3. - 2. * f);
    
    return mix(a,b,u.x) + 
           (c - a) *u.y * (1. - u.x)+
           (d - b) *u.y * u.x;
}

mat2 rotate(in float angle)
{
    return mat2(sin(angle), cos(angle),
                -cos(angle), sin(angle));
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = (fragCoord-.5*iResolution.xy)/iResolution.y;
    uv += (noise(uv * rotate(mod(iTime, 2. * 3.14159265)) * 2.) - .5);
    
    vec3 col = vec3(1.) * smoothstep(.58, .6, noise(uv*3.));
    col += smoothstep(.15, .2, noise(uv*10.));
    col -= smoothstep(.25, .3, noise(uv*10.));

    fragColor = vec4(1. - col,1.0);
}