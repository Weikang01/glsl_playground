void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = (fragCoord-.5*iResolution.xy)/iResolution.y;
    vec2 mouse = iMouse.xy/iResolution.xy;
    
    vec3 col = vec3(0);
    
    float angle = (2./3.)*3.1415926;
    vec2 n = vec2(sin(angle), cos(angle));
    
    float scale = 1.;
    uv.x += .5;
    for (int i=0;i<5;i++)
    {
        uv *= 3.;
        scale *= 3.;
        uv.x -= 1.5;
        
        uv.x = abs(uv.x);
        uv.x -= .5;
        uv -= n*min(0., dot(uv,n))*2.;
    }

    float d = length(uv - vec2(clamp(uv.x,-1.,1.),0.));
    col += smoothstep(1./iResolution.y, 0., d/scale);
    //col.rg += uv;
    
    fragColor = vec4(col,1.0);

}