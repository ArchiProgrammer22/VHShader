#version 460

uniform sampler2D gtexture;
uniform sampler2D lightmap;
uniform float time;
uniform vec2 resolution;

layout(location = 0) out vec4 outColor0;

in vec2 texCoord;
in vec4 foliageColor;
in vec2 lightMapCoords;

float random(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898, 78.233))) * 43758.5453);
}

void main() {
    vec4 texColor = texture(gtexture, texCoord);
    vec4 lightColor = texture(lightmap, vec2(lightMapCoords));
    vec4 baseColor = texColor * foliageColor * lightColor;

    if (baseColor.a < 0.1) discard;

    float noise1 = (random(gl_FragCoord.xy * 0.5 + time * 7.0) - 0.5) * 0.10;
    float noise2 = (random(gl_FragCoord.xy * 2.0 + time * 15.0) - 0.5) * 0.05;
    float noise3 = (random(gl_FragCoord.xy * 5.0 + time * 40.0) - 0.5) * 0.03;

    float totalNoise = noise1 + noise2 + noise3;

    float scanline = sin(gl_FragCoord.y * 1.5) * 0.03;

    float flicker = 0.03 * sin(time * 10.0);

    vec3 finalColor = baseColor.rgb + totalNoise - scanline + flicker;

    outColor0 = vec4(clamp(finalColor, 0.0, 1.0), baseColor.a);
}
