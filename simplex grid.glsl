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

vec2 skew(vec2 uv)
{
    vec2 r = vec2(0.);
    r.x = 1.1547*uv.x; // 2*sqrt3/3
    r.y = uv.y + .5*r.x;
    return r;
}

vec3 simplexGrid(vec2 uv)
{
    vec3 xyz = vec3(0.);
    
    vec2 p = fract(skew(uv));
    if(p.x>p.y)
    {
        xyz.xy = 1. - vec2(p.x, p.y - p.x);
        xyz.z = p.y;
    }
    else
    {
        xyz.yz = 1. - vec2(p.x - p.y, p.y);
        xyz.x = p.x;
    }
    return fract(xyz);
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = (fragCoord-.5*iResolution.xy)/iResolution.y;
    uv *= 10.;
    vec3 col = vec3(simplexGrid(uv));
    
    fragColor = vec4(col,1.0);
}