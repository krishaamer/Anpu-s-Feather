using UnityEngine;

namespace AnpusFeather
{
    /*
      The Nile — port of river.pde.
    */
    public sealed class River
    {
        float _theta;
        float _fillAlpha = 170f;
        const int Cols = 25;
        const int Rows = 45;
        const float Speed = 0.0223f;

        readonly (float r, float g, float b)[] _colors =
        {
            (0x83, 0xa0, 0xff), (0x51, 0x73, 0xdf), (0x19, 0x4d, 0xf4), (0x0a, 0x34, 0xbc)
        };

        public void Update(DrawCanvas canvas, float dt)
        {
            float gap = World.W / Cols;
            float horizon = World.H * 0.42f;
            float theta2 = Mathf.PI / 6f;

            for (int j = 0; j < Rows; j++)
            {
                var (r, g, b) = _colors[j % _colors.Length];
                var col = Color4.Rgba(r, g, b, _fillAlpha / 255f);
                theta2 += (Mathf.PI * 2f) / 36f;
                float offSetY = MathUtil.Map(Mathf.Sin(theta2), -1f, 1f, 0f, Mathf.PI * 2f);

                float t = (j + 0.5f) / Rows;
                float persp = 0.22f + 0.78f * t * t;
                float y = horizon + (World.H - horizon + 80f) * t * t;

                for (int i = 0; i < Cols; i++)
                {
                    float offSetX = (Mathf.PI * 2f / Rows) * i;
                    float x = World.W / 2f + (i + 0.5f - Cols / 2f) * gap * (0.5f + persp);
                    float sz = MathUtil.Map(Mathf.Sin(_theta + offSetX + offSetY), -1f, 1f, 5f, gap * 1.5f) * persp;
                    canvas.FillEllipse(x, y, sz / 2f, (sz / 2f) * 0.45f, col, 14);
                }
            }

            _theta -= Speed * dt * World.Fps;
        }

        public void FadeIn(float dt) => _fillAlpha = MathUtil.Clamp(_fillAlpha + dt * World.Fps, 0f, 255f);
        public void FadeOut(float dt) => _fillAlpha = MathUtil.Clamp(_fillAlpha - dt * World.Fps, 0f, 255f);
    }
}
