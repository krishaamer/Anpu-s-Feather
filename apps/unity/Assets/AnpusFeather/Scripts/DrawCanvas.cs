using System.Collections.Generic;
using UnityEngine;

namespace AnpusFeather
{
    public enum DrawPipe
    {
        Color,
        Textured,
        Point
    }

    public struct CanvasVertex
    {
        public Vector3 Position;
        public Vector2 Uv;
        public Color Color;
    }

    public struct DrawCommand
    {
        public DrawPipe Pipe;
        public bool BlendAdd;
        public Texture Texture;
        public int Start;
        public int Count;
    }

    /*
      Immediate-mode 2D canvas mirroring the iOS Metal Canvas.
    */
    public sealed class DrawCanvas
    {
        readonly List<CanvasVertex> _verts = new List<CanvasVertex>();
        readonly List<DrawCommand> _cmds = new List<DrawCommand>();

        public bool BlendAdd { get; set; }

        public IReadOnlyList<CanvasVertex> Vertices => _verts;
        public IReadOnlyList<DrawCommand> Commands => _cmds;
        public bool IsEmpty => _verts.Count == 0;

        public void Reset()
        {
            _verts.Clear();
            _cmds.Clear();
            BlendAdd = false;
        }

        void Push(DrawPipe pipe, Texture texture, int count)
        {
            if (_cmds.Count > 0)
            {
                var last = _cmds[_cmds.Count - 1];
                if (last.Pipe == pipe && last.BlendAdd == BlendAdd && last.Texture == texture &&
                    last.Start + last.Count == _verts.Count - count)
                {
                    last.Count += count;
                    _cmds[_cmds.Count - 1] = last;
                    return;
                }
            }

            _cmds.Add(new DrawCommand
            {
                Pipe = pipe,
                BlendAdd = BlendAdd,
                Texture = texture,
                Start = _verts.Count - count,
                Count = count
            });
        }

        CanvasVertex V(float x, float y, float u, float v, Color4 c) => new CanvasVertex
        {
            Position = new Vector3(x, y, 0f),
            Uv = new Vector2(u, v),
            Color = c.ToUnity()
        };

        public void FillRect(float x, float y, float w, float h, Color4 c)
        {
            _verts.Add(V(x, y, 0f, 0f, c));
            _verts.Add(V(x + w, y, 0f, 0f, c));
            _verts.Add(V(x + w, y + h, 0f, 0f, c));
            _verts.Add(V(x, y, 0f, 0f, c));
            _verts.Add(V(x + w, y + h, 0f, 0f, c));
            _verts.Add(V(x, y + h, 0f, 0f, c));
            Push(DrawPipe.Color, null, 6);
        }

        public void Clear() => FillRect(0f, 0f, World.W, World.H, Color4.Black);

        public void Fade(float alpha) => FillRect(0f, 0f, World.W, World.H, new Color4(0f, 0f, 0f, alpha));

        public void FillEllipse(float cx, float cy, float rx, float ry, Color4 c, int segments = 40)
        {
            Vector2 prev = new Vector2(cx + rx, cy);
            for (int i = 1; i <= segments; i++)
            {
                float a = i / (float)segments * Mathf.PI * 2f;
                Vector2 p = new Vector2(cx + Mathf.Cos(a) * rx, cy + Mathf.Sin(a) * ry);
                _verts.Add(V(cx, cy, 0f, 0f, c));
                _verts.Add(V(prev.x, prev.y, 0f, 0f, c));
                _verts.Add(V(p.x, p.y, 0f, 0f, c));
                prev = p;
            }
            Push(DrawPipe.Color, null, segments * 3);
        }

        public void StrokeEllipse(float cx, float cy, float rx, float ry, float lineW, Color4 c, int segments = 48)
        {
            float hw = lineW / 2f;
            int added = 0;

            (Vector2 outer, Vector2 inner) Ring(float ang)
            {
                float ca = Mathf.Cos(ang);
                float sa = Mathf.Sin(ang);
                return (
                    new Vector2(cx + ca * (rx + hw), cy + sa * (ry + hw)),
                    new Vector2(cx + ca * (rx - hw), cy + sa * (ry - hw))
                );
            }

            var prev = Ring(0f);
            Color col = c.ToUnity();
            for (int i = 1; i <= segments; i++)
            {
                float a = i / (float)segments * Mathf.PI * 2f;
                var cur = Ring(a);
                _verts.Add(new CanvasVertex { Position = new Vector3(prev.outer.x, prev.outer.y, 0f), Color = col });
                _verts.Add(new CanvasVertex { Position = new Vector3(prev.inner.x, prev.inner.y, 0f), Color = col });
                _verts.Add(new CanvasVertex { Position = new Vector3(cur.outer.x, cur.outer.y, 0f), Color = col });
                _verts.Add(new CanvasVertex { Position = new Vector3(cur.outer.x, cur.outer.y, 0f), Color = col });
                _verts.Add(new CanvasVertex { Position = new Vector3(prev.inner.x, prev.inner.y, 0f), Color = col });
                _verts.Add(new CanvasVertex { Position = new Vector3(cur.inner.x, cur.inner.y, 0f), Color = col });
                prev = cur;
                added += 6;
            }
            Push(DrawPipe.Color, null, added);
        }

        public void ThickLine(float x1, float y1, float x2, float y2, float width, Color4 c)
        {
            float dx = x2 - x1;
            float dy = y2 - y1;
            float len = Mathf.Max(Mathf.Sqrt(dx * dx + dy * dy), 0.0001f);
            float nx = -dy / len * width / 2f;
            float ny = dx / len * width / 2f;
            _verts.Add(V(x1 + nx, y1 + ny, 0f, 0f, c));
            _verts.Add(V(x2 + nx, y2 + ny, 0f, 0f, c));
            _verts.Add(V(x2 - nx, y2 - ny, 0f, 0f, c));
            _verts.Add(V(x1 + nx, y1 + ny, 0f, 0f, c));
            _verts.Add(V(x2 - nx, y2 - ny, 0f, 0f, c));
            _verts.Add(V(x1 - nx, y1 - ny, 0f, 0f, c));
            Push(DrawPipe.Color, null, 6);
        }

        public void Bezier(float x0, float y0, float cx1, float cy1, float cx2, float cy2, float x1, float y1,
            float width, Color4 c, int steps = 24)
        {
            float px = x0;
            float py = y0;
            for (int i = 1; i <= steps; i++)
            {
                float t = i / (float)steps;
                float mt = 1f - t;
                float a = mt * mt * mt;
                float b = 3f * mt * mt * t;
                float d = 3f * mt * t * t;
                float e = t * t * t;
                float x = a * x0 + b * cx1 + d * cx2 + e * x1;
                float y = a * y0 + b * cy1 + d * cy2 + e * y1;
                ThickLine(px, py, x, y, width, c);
                px = x;
                py = y;
            }
        }

        public void DrawImage(Texture2D tex, float dx, float dy, float dw, float dh, Color4 tint,
            Rect? src = null, Vector2? texSize = null)
        {
            if (tex == null) return;
            DrawImage((Texture)tex, dx, dy, dw, dh, tint, src, texSize ?? new Vector2(tex.width, tex.height));
        }

        public void DrawImage(Texture tex, float dx, float dy, float dw, float dh, Color4 tint,
            Rect? src = null, Vector2? texSize = null)
        {
            if (tex == null) return;
            // Unity textures are V-up; our world is Y-down — flip V so art is upright.
            float u0 = 0f, v0 = 1f, u1 = 1f, v1 = 0f;
            if (src.HasValue && texSize.HasValue && texSize.Value.x > 0f && texSize.Value.y > 0f)
            {
                var s = src.Value;
                var ts = texSize.Value;
                u0 = s.xMin / ts.x;
                u1 = s.xMax / ts.x;
                // src rect is Y-down (top = yMin); convert to Unity V-up UVs.
                v0 = 1f - s.yMin / ts.y;
                v1 = 1f - s.yMax / ts.y;
            }

            _verts.Add(V(dx, dy, u0, v0, tint));
            _verts.Add(V(dx + dw, dy, u1, v0, tint));
            _verts.Add(V(dx + dw, dy + dh, u1, v1, tint));
            _verts.Add(V(dx, dy, u0, v0, tint));
            _verts.Add(V(dx + dw, dy + dh, u1, v1, tint));
            _verts.Add(V(dx, dy + dh, u0, v1, tint));
            Push(DrawPipe.Textured, tex, 6);
        }

        public void Point(float x, float y, float size, Color4 c)
        {
            float hs = size;
            _verts.Add(V(x - hs, y - hs, 0f, 0f, c));
            _verts.Add(V(x + hs, y - hs, 1f, 0f, c));
            _verts.Add(V(x + hs, y + hs, 1f, 1f, c));
            _verts.Add(V(x - hs, y - hs, 0f, 0f, c));
            _verts.Add(V(x + hs, y + hs, 1f, 1f, c));
            _verts.Add(V(x - hs, y + hs, 0f, 1f, c));
            Push(DrawPipe.Point, null, 6);
        }
    }
}
