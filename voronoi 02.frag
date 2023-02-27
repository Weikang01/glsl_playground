vec2 rand2(in vec2 uv)
{
    return fract(sin(vec2(dot(uv,vec2(127.1,311.7)),dot(uv,vec2(269.5,183.3))))*43758.5453);
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = fragCoord/iResolution.xy;
    uv.x *= iResolution.x/iResolution.y;
    uv*=8.;
    vec3 col= vec3(0.);
    
    vec2 ipos = floor(uv);
    vec2 fpos = fract(uv);
    
    float m_dist = 1.;
    vec2 m_point;
    
    for (int y = -1; y <= 1; y++)
    {
        for (int x = -1; x <= 1; x++)
        {
            vec2 neighbor = vec2(float(x), float(y));
            vec2 p = rand2(ipos + neighbor);
            p *= p;
            p += sin(iTime + 10. * p)*.5;
            
            vec2 diff = neighbor + p - fpos;
            
            float dist = length(diff);
            
            if (dist<m_dist)
            {
                m_dist = dist;
                m_point = p;
            }
        }
    }
    
    col += m_dist;
    col.rg = m_point;
    
    //col += smoothstep(.025, .01, m_dist);
    //col.r += (step(.98, fpos.x) + step(.98, fpos.y))*.3;
    
    fragColor = vec4(col,1.0);
}