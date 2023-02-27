float N21(vec2 p)
{
    return fract(sin(p.x*122.+p.y*3232.)*2323.);
}

float SmoothNoise(vec2 p)
{
    vec2 lv = fract(p);
    vec2 id = floor(p);
    
    lv = lv*lv*(3.-2.*lv);
    
    float bl = N21(id);
    float br = N21(id+vec2(1,0));
    float b = mix(bl,br,lv.x);
    
    float tl = N21(id+vec2(0,1));
    float tr = N21(id+vec2(1,1));
    float t = mix(tl,tr,lv.x);
    
    return mix(b,t,lv.y);
}

float SmoothNoise2(vec2 p)
{
    float c = SmoothNoise(p*4.);
    c += SmoothNoise(p*8.)*.5;
    c += SmoothNoise(p*16.)*.25;
    c += SmoothNoise(p*32.)*.125;
    c += SmoothNoise(p*64.)*.0625;

    return c / 2.;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = fragCoord/iResolution.xy;
    
    float c = SmoothNoise2(uv);
    
    vec3 col = vec3(c);
    //col.rg = id * .1;
    
    fragColor = vec4(col,1.0);
}