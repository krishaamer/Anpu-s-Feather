using UnityEngine;

namespace AnpusFeather
{
    /*
      Background imagery — port of pyramid.pde.
    */
    public sealed class Pyramid
    {
        float _tintAlpha;
        float _clock;
        readonly AssetStore _store;

        public Pyramid(AssetStore store) => _store = store;

        public void Tick(float dt) => _clock += dt;
        public void SetAlpha(float a) => _tintAlpha = a;

        Color4 Tint => new Color4(1f, 1f, 1f, _tintAlpha / 255f);

        public void Show(DrawCanvas canvas)
        {
            Texture2D p0 = _store.Image("pyramid0");
            Texture2D p2 = _store.Image("pyramid2");
            if (p0 == null || p2 == null) return;

            float half = Mathf.Ceil(World.W / 2f) + 1f;
            float lh = p2.height * (half / p2.width);
            float rh = p0.height * (half / p0.width);
            canvas.DrawImage(p2, 0f, 0f, half, lh, Tint);
            canvas.DrawImage(p0, World.W - half, 0f, half, rh, Tint);

            string name = _clock % 1.1f < 0.55f ? "anubis1" : "anubis2";
            Texture2D anubis = _store.Image(name);
            if (anubis != null)
            {
                float w = anubis.width;
                float h = anubis.height;
                canvas.DrawImage(anubis, World.W / 2f - w / 2f, World.H / 2f - 100f - h / 2f, w, h, Tint);
            }
        }

        public void ShowAlt(DrawCanvas canvas)
        {
            Texture2D img = _store.Image("pyramid3");
            if (img == null) return;
            float scale = World.W / img.width;
            float h = img.height * scale;
            canvas.DrawImage(img, 0f, World.H - h, World.W, h, Tint);
        }

        public void FadeIn(float dt) => _tintAlpha = MathUtil.Clamp(_tintAlpha + 5f * dt * World.Fps, 0f, 255f);
        public void FadeOut(float dt) => _tintAlpha = MathUtil.Clamp(_tintAlpha - 10f * dt * World.Fps, 0f, 255f);
    }
}
