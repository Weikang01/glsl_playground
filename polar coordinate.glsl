#define S(v, p) smoothstep(v, v+0.01, p)
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

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = (fragCoord-.5*iResolution.xy)/iResolution.y;
    vec2 mouse = iMouse.xy/iResolution.y;
    
    //vec2 uv = fragCoord/iResolution.xy;
    //vec2 pos = uv;
    
    
    float r = length(uv)*2.;
    float a = atan(uv.x,uv.y);
    
    float f = cos(a*mouse.x*mouse.y*10.);
    
    vec3 col = vec3(S(f,r));

    fragColor = vec4(col,1.0);
}