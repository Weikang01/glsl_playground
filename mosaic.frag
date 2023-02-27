float rand(vec2 uv)
{
    return fract(sin(dot(uv.xy, vec2(233.12, 7661.32))) * 43758.5453123);
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = (fragCoord-.5*iResolution.xy)/iResolution.y;
    uv *= 10.;
    vec2 ipos = floor(uv);
    vec2 fpos = fract(uv);
    
    vec3 col = vec3(rand(ipos));

    fragColor = vec4(col,1.0);
}