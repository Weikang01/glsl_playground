#define S(v, p) smoothstep(v+0.005, v, p)
#define PI 3.14159265359
#define TWO_PI 6.28318530718

float box(in vec2 uv, in vec2 size)
{
    float b = S(size.x, uv.x);
    b *= S(size.x, -uv.x);
    b *= S(size.y, uv.y);
    return b*S(size.y, -uv.y);
}

mat2 rotate(in float angle)
{
    return mat2(cos(angle), -sin(angle),
                sin(angle), cos(angle));
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = (fragCoord-.5*iResolution.xy)/iResolution.y;
    vec2 mouse = (iMouse.xy-.5*iResolution.xy)/iResolution.y;
    uv *= 3.;
    uv = fract(uv);
    
    vec3 col = vec3(0.);
    col += box(rotate(.25 * PI) * (uv-vec2(.5))*1.43, vec2(.5));
    
    fragColor = vec4(col,1.0);
}