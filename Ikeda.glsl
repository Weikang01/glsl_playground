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

float randomSerie(float x, float freq, float t) {
    return step(.8,rand( floor(x*freq)-floor(t) ));
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = fragCoord/iResolution.xy;
    uv.x *= iResolution.x/iResolution.y;
    float freq = rand(floor(iTime)) + atan(iTime * .1);
    float time = 60. + iTime*(1.-freq)*30.;
    if(fract(uv.y)<.5)
    {
        time *= -1.;
    }
    
    freq += rand(floor(uv.y));
    
    float offset = .1;
    vec3 col = vec3(randomSerie(uv.x, freq*100., time+offset),
                    randomSerie(uv.x, freq*100., time),
                    randomSerie(uv.x, freq*100., time-offset));

    fragColor = vec4(1. - col,1.0);
}