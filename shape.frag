#define S(v, p) smoothstep(v+0.005, v, p)
#define PI 3.14159265359
#define TWO_PI 6.28318530718

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = (fragCoord-.5*iResolution.xy)/iResolution.y;
    vec2 mouse = (iMouse.xy-.5*iResolution.xy)/iResolution.y;
    mouse.x = abs(mouse.x);
    
    vec3 col = vec3(0);
    
    // Number of sides of your shape
    float N = 1.0 + ceil(4.0 * (cos(iTime) + 1.0));
    
    float a = atan(uv.x, uv.y)+PI;
    float r = TWO_PI/N;
    
    float d = cos(floor(.5+a/r)*r-a)*length(uv);
    
    
    col = vec3(S(mouse.x,d));

    fragColor = vec4(col,1.0);
}