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


void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = (fragCoord-.5*iResolution.xy)/iResolution.y;
    vec2 mouse = (iMouse.xy-.5*iResolution.xy)/iResolution.y;
    mouse.x = abs(mouse.x);
    
    vec3 col = vec3(0);
    
    // Number of sides of your shape
    int N = 6;
    
    float a = atan(uv.x, uv.y)+PI;
    float r = TWO_PI/float(N);
    
    float d = cos(floor(.5+a/r)*r-a)*length(uv);
    
    
    col = vec3(S(mouse.x,d));

    fragColor = vec4(col,1.0);
}