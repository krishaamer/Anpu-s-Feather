using UnityEngine;

namespace AnpusFeather
{
    /*
      The weighing of the heart — port of scales.pde.
    */
    public sealed class Scales
    {
        float _tintAlpha;
        float _t;
        float _xn1;
        float _xn2;
        float _yn1;
        float _yn2;
        float _featherY = -300f;
        const float Easing = 0.01f;
        bool _diagramVisible = true;
        FeatherStart _from = FeatherStart.Middle;

        public enum FeatherStart
        {
            Top,
            Middle
        }

        readonly AssetStore _store;
        readonly Skeleton _skeleton;

        public Scales(AssetStore store, Skeleton skeleton)
        {
            _store = store;
            _skeleton = skeleton;
        }

        public void ShowDiagram(bool visible) => _diagramVisible = visible;
        public void StartFrom(FeatherStart from) => _from = from;
        public float Feather => _featherY;

        public void Update(DrawCanvas canvas, float dt, float clock)
        {
            Vec3[] p = _skeleton.Points;
            float xdist1 = Mathf.Abs(p[4].X - _xn1); _xn1 = p[4].X;
            float xdist2 = Mathf.Abs(p[7].X - _xn2); _xn2 = p[7].X;
            float ydist1 = Mathf.Abs(p[4].Y - _yn1); _yn1 = p[4].Y;
            float ydist2 = Mathf.Abs(p[7].Y - _yn2); _yn2 = p[7].Y;
            float avdist = (xdist1 + xdist2 + ydist1 + ydist2) / 4f;

            float val = MathUtil.Map(-avdist, -30f, 0f, -300f, 500f);
            if (val == 100f) val = MathUtil.RandomRange(100f, 300f);
            if (val < 0f) val = MathUtil.RandomRange(-480f, -100f);

            if (Mathf.Abs(val - _featherY) > 100f)
                _featherY += (val - _featherY) * Easing * dt * World.Fps;
            else
            {
                _t += 0.2f * dt * World.Fps;
                _featherY += Mathf.Sin(_t) * 5f * dt * World.Fps;
            }

            var tint = new Color4(1f, 1f, 1f, _tintAlpha / 255f);
            Texture2D feather = _store.Image("feather");
            if (feather != null)
            {
                float fw = feather.width * 0.6f;
                float fh = feather.height * 0.6f;
                float y = _from == FeatherStart.Top ? _featherY : _featherY + World.H / 2f;
                canvas.DrawImage(feather, World.W / 2f - fw / 2f, y - fh / 2f, fw, fh, tint);
            }

            if (_diagramVisible) DrawDiagram(canvas, clock, tint);
        }

        void DrawDiagram(DrawCanvas canvas, float clock, Color4 tint)
        {
            string name = clock % 0.74f < 0.37f ? "diagram1" : "diagram2";
            canvas.FillRect(World.W / 2f + 350f, World.H / 2f + 150f, 300f, 300f, Color4.Black);
            Texture2D diagram = _store.Image(name);
            if (diagram != null)
                canvas.DrawImage(diagram, World.W / 2f + 350f, World.H / 2f + 150f, diagram.width, diagram.height, tint);
            Texture2D scale = _store.Image("scale");
            if (scale != null)
                canvas.DrawImage(scale, -50f, -100f, scale.width, scale.height, tint);
        }

        public void FadeIn(float dt) => _tintAlpha = Mathf.Min(255f, _tintAlpha + dt * World.Fps);
        public void FadeOut(float dt) => _tintAlpha = Mathf.Max(0f, _tintAlpha - dt * World.Fps);
    }
}
