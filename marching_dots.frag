#define S(v, p) smoothstep(v+0.005, v, p)
#define PI 3.14159265359
#define TWO_PI 6.28318530718

vec2 movable_uv(in vec2 uv, in float size, float speed)
{
    uv *= size;
    
    vec2 bias = step(1., mod(uv.yx,2.)) * 2. - 1.;
    
    float range = 2.;
    float time = iTime*speed;
    
    if (fract(time)>.5)
    {
        if (fract(uv.y*.5)>.5)
        {
            uv.x += fract(time) * 2.0;
        }
        else
        {
            uv.x -= fract(time) * 2.0;
        }
    }
    else
    {
        if (fract(uv.x*.5)>.5)
        {
            uv.y += fract(time) * 2.0;
        }
        else
        {
            uv.y -= fract(time) * 2.0;
        }
    
    }
    
    return fract(uv);
}

float circle(in vec2 uv, in float r)
{
    return S(r, length(uv-.5));
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv =( fragCoord-.5*iResolution.xy)/iResolution.y;
    
    float c = circle(movable_uv(uv, 6.,.2), .3);

    vec3 col = vec3(1.-c);
    
    fragColor = vec4(col,1.0);
}