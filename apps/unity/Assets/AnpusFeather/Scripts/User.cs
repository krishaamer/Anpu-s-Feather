using UnityEngine;

namespace AnpusFeather
{
    public enum UserMode
    {
        Light,
        Heavy,
        Questions
    }

    /*
      Draws the visitor's spirit — port of user.pde.
    */
    public sealed class User
    {
        float _fillAlpha;
        bool _seeded;

        const int Count = 3000;
        readonly float[] _xpos = new float[Count];
        readonly float[] _ypos = new float[Count];
        readonly float[] _vx = new float[Count];
        readonly float[] _vy = new float[Count];

        readonly Skeleton _skeleton;

        public User(Skeleton skeleton) => _skeleton = skeleton;

        public void FadeIn(float dt) => _fillAlpha = MathUtil.Clamp(_fillAlpha + dt * World.Fps, 0f, 255f);
        public void FadeOut(float dt) => _fillAlpha = MathUtil.Clamp(_fillAlpha - dt * World.Fps, 0f, 255f);

        public void Simulate()
        {
            if (!_seeded)
            {
                for (int i = 0; i < Count; i++)
                {
                    _xpos[i] = MathUtil.RandomRange(-500f, 500f);
                    _ypos[i] = MathUtil.RandomRange(-500f, 500f);
                }
                _seeded = true;
            }

            const float magnetism = 30f;
            const float principle = 0.95f;
            Vec3[] p = _skeleton.Points;
            Vec3 a1 = p[4], a2 = p[7], a3 = p[14], a4 = p[11];

            for (int i = 0; i < Count; i++)
            {
                float x = _xpos[i];
                float y = _ypos[i];
                float d1 = Mathf.Max(Vector2.Distance(new Vector2(a1.X, a1.Y), new Vector2(x, y)), 1f);
                float d2 = Mathf.Max(Vector2.Distance(new Vector2(a2.X, a2.Y), new Vector2(x, y)), 1f);
                float d3 = Mathf.Max(Vector2.Distance(new Vector2(a3.X, a3.Y), new Vector2(x, y)), 1f);
                float d4 = Mathf.Max(Vector2.Distance(new Vector2(a4.X, a4.Y), new Vector2(x, y)), 1f);

                Vec3 t = a1;
                if (d1 < 50f || (d1 < d2 && d1 < d3 && d1 < d4)) t = a2;
                if (d2 < 50f || (d2 < d1 && d2 < d3 && d2 < d4)) t = a3;
                if (d3 < 50f || (d3 < d1 && d3 < d4 && d3 < d2)) t = a4;
                if (d4 < 50f || (d4 < d1 && d4 < d2 && d4 < d3)) t = a1;

                float ax = magnetism * (t.X - x) / (d1 * d1);
                float ay = magnetism * (t.Y - y) / (d1 * d1);
                _vx[i] = (_vx[i] + ax) * principle;
                _vy[i] = (_vy[i] + ay) * principle;
                _xpos[i] += _vx[i];
                _ypos[i] += _vy[i];
            }
        }

        public void Draw(DrawCanvas canvas, UserMode mode)
        {
            switch (mode)
            {
                case UserMode.Light: DrawLight(canvas); break;
                case UserMode.Heavy: DrawHeavy(canvas); break;
                case UserMode.Questions: DrawHands(canvas); break;
            }
        }

        void DrawLight(DrawCanvas canvas)
        {
            float cx = World.W / 2f;
            float cy = World.H / 2f;
            float alphaScale = _fillAlpha / 255f;
            for (int i = 0; i < Count; i++)
            {
                float sokudo = Mathf.Sqrt(_vx[i] * _vx[i] + _vy[i] * _vy[i]);
                float r = MathUtil.Clamp(MathUtil.Map(sokudo, 0f, 5f, 0f, 255f), 0f, 255f);
                float g = MathUtil.Clamp(MathUtil.Map(sokudo, 0f, 5f, 64f, 255f), 0f, 255f);
                float b = MathUtil.Clamp(MathUtil.Map(sokudo, 0f, 5f, 128f, 255f), 0f, 255f);
                canvas.Point(cx + _xpos[i], cy + _ypos[i], 3f, Color4.Rgba(r, g, b, 0.24f * alphaScale));
            }

            var dot = new Color4(1f, 1f, 1f, alphaScale);
            Vec3[] p = _skeleton.Points;
            for (int i = 0; i < World.Joints; i++)
                canvas.FillEllipse(cx + p[i].X, cy + p[i].Y, 4f, 4f, dot, 10);
        }

        void DrawHeavy(DrawCanvas canvas)
        {
            const float s = 0.38f;
            float ox = World.W / 2f;
            float oy = World.H / 2f + 100f;
            float Wx(float v) => ox + v * s;
            float Wy(float v) => oy + v * s;
            float lw = 10f * s;
            float fa = _fillAlpha / 255f;
            Vec3[] p = _skeleton.Points;

            void Ring(float cx, float cy, float a) =>
                canvas.StrokeEllipse(Wx(cx), Wy(cy), 60f * s, 60f * s, lw,
                    new Color4(1f, 1f, 1f, a / 255f * fa), 40);

            void Droop(Vec3 from, float cx, float cy, Vec3 to, float a) =>
                canvas.Bezier(Wx(from.X), Wy(from.Y), Wx(cx), Wy(cy), Wx(to.X), Wy(to.Y), Wx(to.X), Wy(to.Y),
                    lw, new Color4(1f, 1f, 1f, a / 255f * fa));

            float x1 = (p[4].X + p[3].X) / 2f;
            float x2 = (p[3].X + p[2].X) / 2f;
            float x3 = (p[2].X + p[0].X) / 2f;
            float x4 = (p[6].X + p[7].X) / 2f;
            float x5 = (p[5].X + p[6].X) / 2f;
            float x6 = (p[0].X + p[5].X) / 2f;
            float y7 = p[0].Y - 30f;
            float y8 = y7 + 20f;
            float y9 = (y7 + y8) / 2f;
            float y10 = (p[4].Y + y8) / 2f;
            float y11 = (p[7].Y + y8) / 2f;
            float y12 = (p[4].Y + y10) / 2f;
            float y13 = (y7 + y10) / 2f;
            float y14 = p[15].Y + (p[15].Y - (p[16].Y + 20f));

            Ring(p[4].X, p[4].Y, 255f);
            Ring(p[7].X, p[7].Y, 255f);
            Ring(x1, y12, 210f);
            Ring(x4, y12, 210f);
            Ring(p[3].X, y10, 180f);
            Ring(p[6].X, y11, 180f);
            Ring(x2, y13, 150f);
            Ring(x5, y13, 150f);
            Ring(p[2].X, y7, 120f);
            Ring(p[5].X, y7, 120f);
            Ring(p[0].X, p[0].Y, 90f);

            Droop(p[8], p[10].X - 400f, p[10].Y - 350f, p[11], 210f);
            Droop(p[8], p[13].X + 400f, p[13].Y - 350f, p[14], 210f);
            Droop(p[8], p[10].X - 300f, p[10].Y - 280f, p[11], 170f);
            Droop(p[8], p[13].X + 300f, p[13].Y - 280f, p[14], 170f);
            Droop(p[8], p[10].X - 200f, p[10].Y - 200f, p[11], 190f);
            Droop(p[8], p[13].X + 200f, p[13].Y - 200f, p[14], 190f);

            Ring(x3, y9, 70f);
            Ring(x6, y9, 70f);
            Ring(p[16].X + 40f, p[16].Y + 20f, 70f);
            Ring(p[16].X - 40f, p[16].Y + 20f, 70f);
            Ring(p[16].X + 40f, p[15].Y, 70f);
            Ring(p[16].X - 40f, p[15].Y, 70f);
            Ring(p[15].X + 40f, y14, 70f);
            Ring(p[15].X - 40f, y14, 70f);
        }

        void DrawHands(DrawCanvas canvas)
        {
            float cx = World.W / 2f;
            float cy = World.H / 2f;
            var c = new Color4(1f, 1f, 1f, _fillAlpha / 255f);
            Vec3[] p = _skeleton.Points;
            foreach (int hand in new[] { 4, 7 })
                canvas.StrokeEllipse(cx + p[hand].X, cy + p[hand].Y, 10f, 10f, 10f, c, 24);
        }
    }
}
