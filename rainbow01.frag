void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	vec2 uv = fragCoord.xy / iResolution.xy;
    float nx = uv.x * 1.667 - .5;
    
    vec3 fcol = vec3(0);
    
    if (nx < 0.5)
        fcol.x = .5*cos(6.283*nx)+.5;
    if (nx > -.1667 && nx < .8333)
        fcol.y = .5*cos(6.283*(nx-0.333))+.5;
    if (nx > .1667)
        fcol.z = .5*cos(6.283*(nx+0.333))+.5;
    
    fragColor = vec4(fcol, 1.0);
}