using System.IO;
using UnityEngine;

namespace AnpusFeather
{
    /*
      Wisdom cards — port of wisdom.pde.
    */
    public sealed class Wisdom
    {
        float _alpha;
        string _quote = string.Empty;
        bool _hasRun;

        readonly Rect _window = new Rect(97f, 265f, 363f, 367f);
        readonly Rect _quoteBox = new Rect(545f, 300f, 355f, 380f);

        readonly AssetStore _store;

        readonly string[] _quotes =
        {
            "If you would only accomplish this, becoming expert in writing: Those writers of knowledge from the time of events after the gods, those who foretold the future, their names have become fixed for eternity, though they are gone, they have completed their lifespan, and all their kin are forgotten.",
            "They did not make for themselves a chapel of copper, or a stela for it of iron from the sky. They did not manage to leave heirs, from their children, to pronounce their names, but they have achieved heirs out of writings, out of the teachings in those.",
            "They are given the book as ritual-priest, The writing-board as loving-son. Teachings are their chapels, the writing-rush their child, and the block of stone the wife. From great to small, (all) are given as his children, for the writer, he is their leader.",
            "The doors of their chapels are undone, Their ka-priests have gone. Their tombstones are smeared with mud, their tombs are forgotten, but their names are read out on their scrolls, written when they were young. Being remembered makes them, to the limits of eternity.",
            "Be a writer - put it in your heart, and your name is created by the same. Scrolls are more useful than tombstones, than building a solid enclosure. They act as chapels and chambers, by the desire of the one pronouncing their name. For sure there is most use in the cemetery for a name in the mouths of men.",
            "A man is dead, his corpse is in the ground: when all his family are laid in the earth, It is writing that lets him be remembered, in the mouth of the reciter of the formula. Scrolls are more useful than a built house, than chapels on the west, they are more perfect than palace towers, longer-lasting than a monument in a temple.",
            "Is there anyone here like Hordedef? Is there another like Imhotep? There is no family born for us like Neferty, and Khety their leader. Let me remind you of the name of Ptahemdjehuty Khakheperraseneb. Is there another like Ptahhotep? Kaires too?",
            "Those who knew how to foretell the future, What came from their mouths took place, and may be found in (their) phrasing. They are given the offspring of others as heirs as if their (own) children. They hid their powers from the whole land, to be read in (their) teachings. They are gone, their names might be forgotten, but writing lets them be remembered.",
        };

        public Wisdom(AssetStore store) => _store = store;

        public string GetQuote(float featherY)
        {
            if (!_hasRun)
            {
                _hasRun = true;
                int choice = Mathf.FloorToInt(MathUtil.Clamp(
                    MathUtil.Map(featherY, -480f, 300f, 0f, _quotes.Length), 0f, _quotes.Length - 1));
                _quote = _quotes[choice];
            }
            return _quote;
        }

        public void SetAlpha(float a) => _alpha = a;
        public void FadeIn(float speed, float dt) => _alpha = MathUtil.Clamp(_alpha + speed * dt * World.Fps, 0f, 255f);
        public void FadeOut(float speed, float dt) => _alpha = MathUtil.Clamp(_alpha - speed * dt * World.Fps, 0f, 255f);

        public void ShowCard(DrawCanvas canvas, Texture capture, Vector2 captureSize)
        {
            Texture2D card = _store.Image("wisdom_card_bg");
            if (card == null) return;

            float a = _alpha / 255f;
            float cardW = card.width;
            float cardH = card.height;
            float scale = Mathf.Min(World.W * 0.62f / cardW, World.H * 0.98f / cardH);
            float cw = cardW * scale;
            float ch = cardH * scale;
            float cx = World.W / 2f - cw / 2f;
            float cy = World.H / 2f - ch / 2f;

            canvas.DrawImage(card, cx, cy, cw, ch, new Color4(1f, 1f, 1f, a));

            Rect win = new Rect(
                cx + _window.xMin * scale,
                cy + _window.yMin * scale,
                _window.width * scale,
                _window.height * scale);

            float srcAspect = captureSize.x / captureSize.y;
            float dstAspect = win.width / win.height;
            float sw = captureSize.x;
            float sh = captureSize.y;
            if (srcAspect > dstAspect) sw = sh * dstAspect;
            else sh = sw / dstAspect;
            float sx = (captureSize.x - sw) * 0.5f;
            float sy = (captureSize.y - sh) * 0.5f;

            canvas.DrawImage(capture, win.xMin, win.yMin, win.width, win.height,
                new Color4(1f, 1f, 1f, a),
                new Rect(sx, sy, sw, sh), captureSize);

            float qx = cx + _quoteBox.xMin * scale;
            float qy = cy + _quoteBox.yMin * scale;
            float qw = _quoteBox.width * scale;
            Message.DrawCenteredLeft(canvas, _store, _quote, qx, qy, Mathf.Round(19f * scale), qw,
                Color4.Rgba(230f, 222f, 200f, a));
        }

        public Texture2D ExportTexture(Texture2D danceImage)
        {
            Texture2D card = _store.Image("wisdom_card_bg");
            if (card == null) return null;

            int w = card.width;
            int h = card.height;
            var result = new Texture2D(w, h, TextureFormat.RGBA32, false);
            var pixels = new Color[w * h];
            for (int i = 0; i < pixels.Length; i++) pixels[i] = Color.black;
            result.SetPixels(pixels);
            Blit(card, result, 0, 0, w, h);

            if (danceImage != null)
            {
                float dw = danceImage.width;
                float dh = danceImage.height;
                float srcAspect = dw / dh;
                float dstAspect = _window.width / _window.height;
                float sw = dw;
                float sh = dh;
                if (srcAspect > dstAspect) sw = sh * dstAspect;
                else sh = sw / dstAspect;
                int sx = Mathf.RoundToInt((dw - sw) * 0.5f);
                int sy = Mathf.RoundToInt((dh - sh) * 0.5f);
                int dx = Mathf.RoundToInt(_window.xMin);
                int dy = Mathf.RoundToInt(_window.yMin);
                int dww = Mathf.RoundToInt(_window.width);
                int dhh = Mathf.RoundToInt(_window.height);
                BlitScaled(danceImage, result, sx, sy, Mathf.RoundToInt(sw), Mathf.RoundToInt(sh), dx, dy, dww, dhh);
            }

            Texture2D quoteTex = _store.Text(_quote, 19, _quoteBox.width, TextAnchor.UpperLeft);
            if (quoteTex != null)
                Blit(quoteTex, result, Mathf.RoundToInt(_quoteBox.xMin), Mathf.RoundToInt(_quoteBox.yMin),
                    quoteTex.width, quoteTex.height, Color4.Rgba(230f, 222f, 200f, 1f));

            result.Apply();
            return result;
        }

        static void Blit(Texture2D src, Texture2D dst, int dx, int dy, int dw, int dh, Color4 tint)
        {
            for (int y = 0; y < dh; y++)
            {
                int ty = dy + y;
                if (ty < 0 || ty >= dst.height) continue;
                for (int x = 0; x < dw; x++)
                {
                    int tx = dx + x;
                    if (tx < 0 || tx >= dst.width) continue;
                    Color sample = src.GetPixelBilinear((x + 0.5f) / dw, (y + 0.5f) / dh);
                    Color existing = dst.GetPixel(tx, ty);
                    sample.r *= tint.R;
                    sample.g *= tint.G;
                    sample.b *= tint.B;
                    sample.a *= tint.A;
                    dst.SetPixel(tx, ty, AlphaBlend(existing, sample));
                }
            }
        }

        static void Blit(Texture2D src, Texture2D dst, int dx, int dy, int dw, int dh) =>
            Blit(src, dst, dx, dy, dw, dh, Color4.White);

        static void BlitScaled(Texture2D src, Texture2D dst, int sx, int sy, int sw, int sh, int dx, int dy, int dw, int dh)
        {
            for (int y = 0; y < dh; y++)
            {
                int ty = dy + y;
                if (ty < 0 || ty >= dst.height) continue;
                for (int x = 0; x < dw; x++)
                {
                    int tx = dx + x;
                    if (tx < 0 || tx >= dst.width) continue;
                    float u = sx + (x + 0.5f) / dw * sw;
                    float v = sy + (y + 0.5f) / dh * sh;
                    Color sample = src.GetPixelBilinear(u / src.width, v / src.height);
                    dst.SetPixel(tx, ty, AlphaBlend(dst.GetPixel(tx, ty), sample));
                }
            }
        }

        static Color AlphaBlend(Color dst, Color src)
        {
            float a = src.a + dst.a * (1f - src.a);
            if (a <= 0f) return Color.clear;
            return new Color(
                (src.r * src.a + dst.r * dst.a * (1f - src.a)) / a,
                (src.g * src.a + dst.g * dst.a * (1f - src.a)) / a,
                (src.b * src.a + dst.b * dst.a * (1f - src.a)) / a,
                a);
        }

        public static void SaveTexture(Texture2D tex, string path)
        {
            byte[] png = tex.EncodeToPNG();
            File.WriteAllBytes(path, png);
        }
    }
}
