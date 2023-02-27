float pupil(in vec2 uv, in float shape)
{
    float shape_f = shape * shape * shape;
    float d1 = length(uv + vec2(shape_f, 0.));
    float d2 = length(uv - vec2(shape_f, 0.));
    float d = max(d1, d2);
    return smoothstep(mix(.1, 1., shape_f) + .01, mix(.1, 1., shape_f), d);
}

vec2 pupil_uv(in vec2 uv, in float shape)
{
    uv.y *= shape;
    float p_angle = atan(uv.x, uv.y);
    float p_distance = length(uv);
    vec2 st = vec2(p_angle, p_distance);
    return st;
}

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
    vec2 uv = (fragCoord - .5 * iResolution.xy)/iResolution.y;
    vec2 mouse = (iMouse.xy - .5 * iResolution.xy)/iResolution.y;
    mouse.x = abs(mouse.x);
    vec2 n_uv = pupil_uv(uv, mouse.x);
    
    float d = step(mouse.x * .5, n_uv.y);
    n_uv.x *= 5. * (1./(mouse.x + .1));
    n_uv.y *= 4.;
    
    n_uv.y *= .25 * cos(uv.y);
    
    
    vec2 noise = vec2(noise(n_uv));
    noise *= 1. - pupil(uv, mouse.x);
    
    float circle = smoothstep(.48, .52, distance(vec2(0), uv));
    vec3 col = mix(noise.xxx, vec3(1), circle);
    
    fragColor = vec4(col, 1.0);
}