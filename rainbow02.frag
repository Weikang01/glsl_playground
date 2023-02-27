void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	vec2 uv = fragCoord.xy / iResolution.xy;
	fragColor = vec4(.5*cos(6.283*(uv.x+vec3(0.,-.33333,.33333)))+.5,1.0);
}