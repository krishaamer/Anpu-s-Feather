using UnityEngine;

namespace AnpusFeather
{
    /*
      Text overlays — port of message.pde.
    */
    public sealed class Message
    {
        float _alpha;
        readonly AssetStore _store;

        public Message(AssetStore store) => _store = store;

        public void SetAlpha(float a) => _alpha = a;
        public void FadeIn(float speed, float dt) => _alpha = MathUtil.Clamp(_alpha + speed * dt * World.Fps, 0f, 255f);
        public void FadeOut(float speed, float dt) => _alpha = MathUtil.Clamp(_alpha - speed * dt * World.Fps, 0f, 255f);

        public static void DrawCentered(DrawCanvas canvas, AssetStore store, string text, float cx, float cy,
            float fontSize, Color4 tint, float maxWidth = 0f)
        {
            Texture2D tex = store.Text(text, Mathf.RoundToInt(fontSize), maxWidth, TextAnchor.MiddleCenter);
            if (tex == null) return;
            float w = tex.width;
            float h = tex.height;
            canvas.DrawImage(tex, cx - w / 2f, cy - h / 2f, w, h, tint);
        }

        public static void DrawCenteredLeft(DrawCanvas canvas, AssetStore store, string text, float x, float y,
            float fontSize, float maxWidth, Color4 tint)
        {
            Texture2D tex = store.Text(text, Mathf.RoundToInt(fontSize), maxWidth, TextAnchor.UpperLeft);
            if (tex == null) return;
            canvas.DrawImage(tex, x, y, tex.width, tex.height, tint);
        }

        public void Say(DrawCanvas canvas, string msg) =>
            DrawCentered(canvas, _store, msg, World.W / 2f, World.H / 2f, 40f,
                new Color4(1f, 1f, 1f, _alpha / 255f));

        public void Subtitle(DrawCanvas canvas, string msg) =>
            DrawCentered(canvas, _store, msg, World.W / 2f, World.H / 2f + 40f, 20f,
                new Color4(1f, 1f, 1f, _alpha / 255f));

        public void Alert(DrawCanvas canvas, string msg, bool red)
        {
            var tint = red ? Color4.Rgba(255f, 0f, 0f, 1f) : Color4.Rgba(80f, 80f, 255f, 1f);
            DrawCentered(canvas, _store, msg, World.W / 2f, World.H / 2f, 40f, tint);
        }

        public void Countdown(DrawCanvas canvas, int maxVal, float s)
        {
            float x = World.W - 80f;
            float y = 30f;
            canvas.FillRect(x - 50f, y - 25f, 100f, 50f, Color4.Black);
            DrawCentered(canvas, _store, (maxVal - Mathf.FloorToInt(s)).ToString(), x, y, 40f, Color4.Rgba(255f, 0f, 0f, 1f));
        }
    }
}
