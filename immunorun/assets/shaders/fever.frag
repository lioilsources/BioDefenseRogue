#include <flutter/runtime_effect.glsl>
precision mediump float;

uniform vec2  uResolution;
uniform float uTime;
uniform float uFever;   // 0..1 normalizováno z 36.5..42
uniform sampler2D uTexture;

out vec4 fragColor;

void main() {
    vec2 uv = FlutterFragCoord().xy / uResolution;

    // UV jitter při vysoké horečce
    vec2 suv = uv;
    if (uFever > 0.8) {
        float jitter = (uFever - 0.8) * 0.02;
        suv.x += sin(uv.y * 40.0 + uTime * 8.0) * jitter;
        suv.y += cos(uv.x * 35.0 + uTime * 7.0) * jitter;
    }

    vec4 color = texture(uTexture, suv);

    // vinětace: přechod modrá→zlatá→červená podle horečky
    vec2 center = uv - 0.5;
    float dist = length(center) * 2.0;
    float vignette = 1.0 - smoothstep(0.4, 1.0, dist) * (0.3 + uFever * 0.5);

    vec3 tint = mix(vec3(0.7, 0.85, 1.0),   // normální — chladně modravé
                    vec3(1.0, 0.85, 0.3),    // febrilní — zlaté
                    smoothstep(0.0, 0.6, uFever));
    tint = mix(tint,
               vec3(1.0, 0.3, 0.1),          // kritická — červená
               smoothstep(0.7, 1.0, uFever));

    // pulsující jas při horečce
    float pulse = 1.0 + sin(uTime * 3.0) * uFever * 0.04;

    fragColor = vec4(color.rgb * tint * vignette * pulse, color.a);
}
