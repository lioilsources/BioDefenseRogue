#include <flutter/runtime_effect.glsl>
precision mediump float;

uniform vec2  uResolution;
uniform float uTime;

out vec4 fragColor;

// Procedurální fluid pozadí — v M1+ nahradí EM textura přes sampler2D.
void main() {
    vec2 uv = FlutterFragCoord().xy / uResolution;

    float t = uTime * 0.15;

    // vrstvené sinusové posuny → fluidní drift
    float dx = sin(uv.y *  8.0 + t * 1.3) * 0.004
             + sin(uv.y * 19.0 - t * 0.7) * 0.002;
    float dy = cos(uv.x *  7.0 - t * 1.1) * 0.004
             + cos(uv.x * 23.0 + t * 0.9) * 0.0015;

    // jemné "dýchání" měřítka
    vec2 c  = uv - 0.5;
    float b = 1.0 + 0.01 * sin(t * 0.8);
    vec2 suv = c * b + 0.5 + vec2(dx, dy);

    // organická tmavě zelená membrána
    float r = sin(suv.x * 12.0 + t) * 0.5 + 0.5;
    float g = cos(suv.y *  9.0 - t * 0.7) * 0.5 + 0.5;
    float pattern = r * g;

    vec3 col = mix(
        vec3(0.03, 0.10, 0.04),   // tmavá základ
        vec3(0.06, 0.22, 0.09),   // světlejší organická struktura
        pattern * 0.6
    );

    fragColor = vec4(col, 1.0);
}
