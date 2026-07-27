#include <flutter/runtime_effect.glsl>
precision mediump float;

uniform vec2  uResolution;
uniform float uTime;
uniform float uIntensity;   // 0..1 celková síla efektu

out vec4 fragColor;

float hash(float n) {
    return fract(sin(n) * 43758.5453);
}

// Optické artefakty objektivu: plovoucí smítka v roztoku,
// ztmavení okrajů zorného pole a tenký falešný chromatický lem.
void main() {
    vec2 uv     = FlutterFragCoord().xy / uResolution;
    vec2 center = uv - 0.5;
    float dist  = length(center) * 2.0;
    float aspect = uResolution.x / uResolution.y;
    vec2 p = vec2(center.x * aspect, center.y);

    // Smítka: pomalu driftující měkké disky, wrap přes obrazovku
    float motes = 0.0;
    for (int i = 0; i < 9; i++) {
        float fi = float(i);
        float h1 = hash(fi + 0.37);
        float h2 = hash(fi + 5.91);
        float h3 = hash(fi + 11.13);

        vec2 mp = vec2(
            fract(h1 + uTime * (0.006 + 0.010 * h3)) * 2.0 - 1.0,
            fract(h2 + uTime * (0.004 + 0.008 * h1)) * 2.0 - 1.0
        );
        mp = vec2(mp.x * aspect, mp.y);
        mp += 0.02 * vec2(sin(uTime * 0.5 + fi * 2.1),
                          cos(uTime * 0.4 + fi * 1.7));

        float r    = 0.015 + 0.035 * h2;
        float soft = smoothstep(r, r * 0.25, length(p - mp));
        motes = max(motes, soft * (0.4 + 0.6 * h3));
    }
    float aMotes = motes * 0.10;

    // Ztmavení rohů — okraj zorného pole objektivu
    float aVig = smoothstep(0.85, 1.45, dist) * 0.22;

    // Tenký zeleno-magenta lem u okraje
    float fringeG = smoothstep(0.86, 0.95, dist)
                  * (1.0 - smoothstep(0.95, 1.04, dist)) * 0.05;
    float fringeM = smoothstep(0.94, 1.03, dist)
                  * (1.0 - smoothstep(1.03, 1.12, dist)) * 0.05;
    float aFringe = fringeG + fringeM;

    float aSum = aVig + aMotes + aFringe;
    vec3 col = (vec3(0.01, 0.03, 0.01) * aVig
              + vec3(0.70, 0.80, 0.66) * aMotes
              + vec3(0.25, 0.85, 0.35) * fringeG
              + vec3(0.80, 0.25, 0.70) * fringeM)
             / max(aSum, 1e-4);

    float alpha = clamp(aSum * uIntensity, 0.0, 0.35);
    fragColor = vec4(col, alpha);
}
