#include <flutter/runtime_effect.glsl>
precision mediump float;

uniform vec2  uResolution;
uniform float uTime;
uniform float uFever;   // 0..1 normalizováno z 36.5..42

out vec4 fragColor;

void main() {
    vec2 uv     = FlutterFragCoord().xy / uResolution;
    vec2 center = uv - 0.5;
    float dist  = length(center) * 2.0;  // 0 = střed, ~1.41 = rohy

    // Žádný efekt při normální teplotě
    if (uFever < 0.05) {
        fragColor = vec4(0.0);
        return;
    }

    // Vinětace: silnější s horečkou, kraje → střed
    float vigStrength = smoothstep(0.35, 1.0, dist) * (0.2 + uFever * 0.65);

    // Barva: modrá (febrile) → oranžová (hyper) → červená (critical)
    vec3 tint = mix(vec3(0.15, 0.45, 1.0),
                    vec3(1.0, 0.45, 0.05),
                    smoothstep(0.2, 0.6, uFever));
    tint = mix(tint,
               vec3(1.0, 0.08, 0.04),
               smoothstep(0.6, 1.0, uFever));

    // Pulzování při hyper/critical
    float pulse = 1.0;
    if (uFever > 0.6) {
        float rate  = 2.5 + uFever * 5.0;
        float depth = (uFever - 0.6) * 0.9;
        pulse = 1.0 - depth * (0.5 - 0.5 * sin(uTime * rate));
    }

    // Jitter UV efekt při critical (šum na okrajích)
    float jitter = 0.0;
    if (uFever > 0.82) {
        float j = (uFever - 0.82) * 0.06;
        jitter = sin(uv.y * 45.0 + uTime * 9.0) * j * smoothstep(0.5, 1.0, dist);
    }

    float alpha = (vigStrength + jitter) * pulse;
    alpha = clamp(alpha, 0.0, 0.88);

    fragColor = vec4(tint, alpha);
}
