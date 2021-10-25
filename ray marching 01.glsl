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

#define MAX_STEPS 100
#define SURFACE_DIST .01
#define MAX_DIST 100.

float getDist(in vec3 p)
{
    vec4 sphere = vec4(0, 1, 4, 1);
    float dS = length(p - sphere.xyz) - sphere.w;
    float dP = p.y;
    float d = min(dS, dP);
    return d;
}

vec3 getNormal(in vec3 p)
{
    vec2 e = vec2(.01, 0.);
    float d = getDist(p);
    vec3 n = d - vec3(
        getDist(p - e.xyy),
        getDist(p - e.yxy),
        getDist(p - e.yyx)
    );
    return normalize(n);
}


float rayMarch(in vec3 ro,in vec3 rd)
{
    float d0 = 0.;
    for (int i = 0; i < MAX_STEPS; i++)
    {
        vec3 p = ro + d0 * rd;
        float ds = getDist(p);
        d0 += ds;
        if (ds < SURFACE_DIST || d0 > MAX_DIST)
            break;
    }
    return d0;
}

float getLight(vec3 p)
{
    vec3 lightPos = vec3(sin(iTime), 5., cos(iTime));
    vec3 l = normalize(lightPos - p);
    vec3 n = getNormal(p);
    
    float dif = clamp(dot(l, n), 0., 1.);
    float d = rayMarch(p + n * SURFACE_DIST * 2., l);
    
    return d < length(lightPos - p)? dif * .1: dif;
}


void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = (fragCoord - .5 * iResolution.xy) / iResolution.y;
    
    vec3 col = vec3(0);
    
    vec3 ro = vec3(0, 1, 0);
    vec3 rd = normalize(vec3(uv.x, uv.y, 1));
    float d = rayMarch(ro, rd);
    
    vec3 p = ro + rd * d;
    
    float dif = getLight(p);
    col = vec3(dif);
    
    fragColor = vec4(col,1.0);
}