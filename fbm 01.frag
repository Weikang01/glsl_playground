// Fractal Brownian Motion

float rand(in vec2 uv)
{
    return fract(sin(dot(uv, vec2(327.234,422.772))) * 43758.5453123);
}

float noise(in vec2 uv)
{
    vec2 i = floor(uv);
    vec2 f = fract(uv);
    
    float a = rand(i);
    float b = rand(i + vec2(1., 0.));
    float c = rand(i + vec2(0., 1.));
    float d = rand(i + vec2(1., 1.));
    
    vec2 u = f * f * (3. - 2. * f);
    return mix(a, b, u.x) + (c - a) * u.y * (1. - u.x) + (d - b) * u.x * u.y;
}

#define OCTAVES 6

float fbm(in vec2 uv)
{
    float value = 0.;
    float ampl = .5;
    float freq = 0.;
    
    for (int i = 0; i < OCTAVES; i++)
    {
        value += ampl * noise(uv);
        uv *= 2.;
        ampl *= .5;
    }
    return value;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = (fragCoord - .5 * iResolution.xy) / iResolution.y;
    uv *=20.;
    vec3 col = vec3(fbm(uv * 2.));
    fragColor = vec4(col,1.0);
}