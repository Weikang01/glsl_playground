#define S(v, p) smoothstep(v+0.005, v, p)

float rand(float x)
{
    return fract(sin(x * 132.234)*1e4);
}

float rand(vec2 uv)
{
    return fract(sin(dot(uv.xy, vec2(233.12, 7661.32))) * 43758.5453123);
}

float noise(float x)
{
    float i = floor(x);
    float f = fract(x);
    float u = f * f * (3. - 2. * f);
    return mix(rand(i), rand(i+1.),f);
}

float noise (in vec2 uv) {
    vec2 i = floor(uv);
    vec2 f = fract(uv);
    
    float a = rand(i);
    float b = rand(i + vec2(1.,0.));
    float c = rand(i + vec2(0.,1.));
    float d = rand(i + vec2(1.,1.));

    vec2 u = f * f * (3. - 2. * f);
    
    return mix(a,b,u.x) + 
           (c - a) *u.y * (1. - u.x)+
           (d - b) *u.y * u.x;
}


void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = (fragCoord-.5 * iResolution.xy)/iResolution.y;
    vec2 mouse = (iMouse.xy-.5 * iResolution.xy)/iResolution.y;
    
    float n = noise(uv * 5.);
    float f = smoothstep(length(mouse) - .2,length(mouse), n)
    - smoothstep(length(mouse), length(mouse) + .2, n)
    //+ smoothstep(length(mouse) - .31,length(mouse) - .24, n * 2.)
    ;
    
    vec3 col = vec3(f);

    fragColor = vec4(col,1.0);
}