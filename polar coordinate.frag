#define S(v, p) smoothstep(v, v+0.01, p)

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