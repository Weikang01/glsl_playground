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

/*
* GetDist
* * Sphere:
* * * d = length(p) - radius;
* * Capsule:
* * * t = dot(ap, ab)/dot(ab, ab)
* * * t = clamp(t, 0, 1)
* * * c = A + t * ab;
* * * d = length(p - c) - radius;
* * Torus:
* * * x = length(p_xz) - r1;
* * * y = p_y;
* * * d = length(vec2(x,y)) - r2;
* * Box:
* * * d = length(max(abs(p)-size, 0))
* * Cylinder:
* * * t = dot(ap, ab)/dot(ab, ab)
* * * c = A + t * ab;
* * * d = length(p - c) - radius;
* * * y = (abs(t - .5) - .5) * length(ab)
* * * e = length(max(vec2(d, y), 0))
* * * i = min(max(d, y), 0)
* * * D = e + i
*/

float sdBox(in vec3 p, in vec3 o, in vec3 size)
{
    return length(max(abs(p - o)-size, 0.));
}

float sdSphere(in vec3 p, in vec4 sphere)
{
    return length(p - sphere.xyz) - sphere.w;
}

float sdCapsule(in vec3 p, in vec3 a, in vec3 b, in float radius)
{
    vec3 ab = b - a;
    vec3 ap = p - a;
    float t = dot(ab, ap) / dot(ab, ab);
    t = clamp(t, 0., 1.);
    vec3 c = a + t * ab;
    return length(p - c) - radius;
}

float sdTorus(in vec3 p, in vec3 o, in vec2 r)
{
    float x = length(p.xz - o.xz) - r.x;
    float y = p.y - o.y;
    return length(vec2(x,y))-r.y;
}

float sdCylinder(in vec3 p, in vec3 a, in vec3 b, in float radius)
{
    vec3 ab = b - a;
    vec3 ap = p - a;
    float t = dot(ab, ap) / dot(ab, ab);
    vec3 c = a + t * ab;
    float d = length(p - c) - radius;
    float y = (abs(t - .5) - .5) * length(ab);
    float e = length(max(vec2(d, y), 0.));
    float i = min(max(d,y),0.);
    
    return e + i;
}

float getDist(in vec3 p)
{
    vec4 sphere = vec4(0, 1, 4, 1);
    float dS = sdSphere(p, vec4(3, 1, 4, .55));
    float dP = p.y;
    float dC = sdCapsule(p, vec3(0, 1, 6), vec3(1, 2, 6), .3);
    float dT = sdTorus(p, vec3(0, .3, 6), vec2(1.5, .3));
    float dB = sdBox(p, vec3(-3, .75, 6), vec3(.75));
    float dCy = sdCylinder(p, vec3(-2, .5, 8), vec3(-2.5, 2, 9), .4);
    
    float d = min(dS, dP);
    d = min(d, dC);
    d = min(d, dT);
    d = min(d, dB);
    d = min(d, dCy);
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
    
    vec3 ro = vec3(0, 2, 0);
    vec3 rd = normalize(vec3(uv.x, uv.y, 1));
    float d = rayMarch(ro, rd);
    
    vec3 p = ro + rd * d;
    
    float dif = getLight(p);
    col = vec3(dif);
    
    fragColor = vec4(col,1.0);
}