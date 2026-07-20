#include <metal_stdlib>
using namespace metal;

/*
  The whole experience is 2D: textured quads (images and rasterized text),
  flat-colored triangles (filled shapes, thick lines, bezier arcs) and points
  (the light-heart particles). Three vertex/fragment pairs cover all of it.
  Geometry is built on the CPU in world coordinates and projected here by an
  orthographic matrix.
*/

struct Vertex {
    float2 position;
    float2 uv;
    float4 color;
};

struct Uniforms {
    float4x4 projection;
};

struct VOut {
    float4 position [[position]];
    float2 uv;
    float4 color;
};

struct VPointOut {
    float4 position [[position]];
    float4 color;
    float pointSize [[point_size]];
};

// --- Triangles: textured and flat-colored share this vertex stage ---
vertex VOut vtx_main(const device Vertex *verts [[buffer(0)]],
                     constant Uniforms &u [[buffer(1)]],
                     uint vid [[vertex_id]]) {
    Vertex v = verts[vid];
    VOut out;
    out.position = u.projection * float4(v.position, 0.0, 1.0);
    out.uv = v.uv;
    out.color = v.color;
    return out;
}

// Textured (images + text atlases). Texture is premultiplied-alpha-safe: we
// multiply sampled color by the tint/alpha vertex color.
fragment float4 frag_textured(VOut in [[stage_in]],
                              texture2d<float> tex [[texture(0)]],
                              sampler samp [[sampler(0)]]) {
    float4 t = tex.sample(samp, in.uv);
    return t * in.color;
}

// Flat-colored shapes.
fragment float4 frag_color(VOut in [[stage_in]]) {
    return in.color;
}

// --- Points: the particle cloud ---
vertex VPointOut vtx_point(const device Vertex *verts [[buffer(0)]],
                           constant Uniforms &u [[buffer(1)]],
                           uint vid [[vertex_id]]) {
    Vertex v = verts[vid];
    VPointOut out;
    out.position = u.projection * float4(v.position, 0.0, 1.0);
    out.color = v.color;
    out.pointSize = v.uv.x; // point size smuggled through the uv slot
    return out;
}

fragment float4 frag_point(VPointOut in [[stage_in]],
                           float2 pc [[point_coord]]) {
    // Soft round point so the particles read as sparks, not squares.
    float d = distance(pc, float2(0.5));
    if (d > 0.5) discard_fragment();
    return in.color;
}
