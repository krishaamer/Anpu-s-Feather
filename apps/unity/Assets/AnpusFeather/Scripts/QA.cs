using UnityEngine;

namespace AnpusFeather
{
    /*
      The YES / NO question — port of qa.pde.
    */
    public sealed class QA
    {
        public enum Answer
        {
            None,
            Yes,
            No
        }

        public Answer CurrentAnswer { get; private set; } = Answer.None;
        float _fillAlpha;

        const float Btn = 280f;
        const float Margin = 20f;

        readonly AssetStore _store;
        readonly Skeleton _skeleton;

        public QA(AssetStore store, Skeleton skeleton)
        {
            _store = store;
            _skeleton = skeleton;
        }

        Rect NoRect => new Rect(Margin, Margin, Btn, Btn);
        Rect YesRect => new Rect(World.W - Btn - Margin, Margin, Btn, Btn);

        public void AnswerReset() => CurrentAnswer = Answer.None;

        public void Ask(DrawCanvas canvas)
        {
            Button(canvas, NoRect, "NO", Color4.Rgba(255f, 0f, 0f, _fillAlpha / 255f));
            Button(canvas, YesRect, "YES", Color4.Rgba(0f, 0f, 255f, _fillAlpha / 255f));
        }

        void Button(DrawCanvas canvas, Rect r, string label, Color4 fill)
        {
            canvas.FillRect(r.xMin, r.yMin, r.width, r.height, fill);
            Message.DrawCentered(canvas, _store, label, r.center.x, r.center.y, 60f,
                new Color4(1f, 1f, 1f, _fillAlpha / 255f));
        }

        static bool Hit(float x, float y, Rect r) => r.Contains(new Vector2(x, y));

        public void EnableButtons((float x, float y)[] clicks)
        {
            foreach (var c in clicks)
            {
                if (Hit(c.x, c.y, YesRect)) CurrentAnswer = Answer.Yes;
                if (Hit(c.x, c.y, NoRect)) CurrentAnswer = Answer.No;
            }
        }

        public void EnableGestures()
        {
            Vec3[] p = _skeleton.Points;
            foreach (int hand in new[] { 4, 7 })
            {
                float x = p[hand].X + World.W / 2f;
                float y = p[hand].Y + World.H / 2f;
                if (Hit(x, y, YesRect)) CurrentAnswer = Answer.Yes;
                if (Hit(x, y, NoRect)) CurrentAnswer = Answer.No;
            }
        }

        public void FadeIn(float dt) => _fillAlpha = MathUtil.Clamp(_fillAlpha + dt * World.Fps, 0f, 255f);
        public void FadeOut(float dt) => _fillAlpha = MathUtil.Clamp(_fillAlpha - dt * World.Fps, 0f, 255f);
    }
}
