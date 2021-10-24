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

vec2 rand2(in vec2 uv)
{
    return fract(sin(vec2(dot(uv,vec2(127.1,311.7)),dot(uv,vec2(269.5,183.3))))*43758.5453);
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = (fragCoord-.5*iResolution.xy)/iResolution.y;
    uv*=3.;
    vec3 col= vec3(0.);
    
    vec2 ipos = floor(uv);
    vec2 fpos = fract(uv);
    
    float m_dist = 1.;
    
    for (int y = -1; y <= 1; y++)
    {
        for (int x = -1; x <= 1; x++)
        {
            vec2 neighbor = vec2(float(x), float(y));
            vec2 p = rand2(ipos + neighbor);
            p += sin(iTime + 5. * p)*.2;
            
            vec2 diff = neighbor + p - fpos;
            
            float dist = length(diff);
            
            m_dist = min(m_dist, dist);
        }
    }
    
    col += m_dist;
    
    //col += smoothstep(.025, .01, m_dist);
    //col.r += (step(.99, fpos.x) + step(.99, fpos.y))*.3;
    
    fragColor = vec4(col,1.0);
}