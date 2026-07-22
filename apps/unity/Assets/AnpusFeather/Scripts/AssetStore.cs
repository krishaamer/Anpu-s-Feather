using System.Collections.Generic;
using System.IO;
using UnityEngine;

namespace AnpusFeather
{
    /*
      Loads bundled media from StreamingAssets/Media and rasterizes text to textures.
    */
    public sealed class AssetStore
    {
        readonly Dictionary<string, Texture2D> _images = new Dictionary<string, Texture2D>();
        readonly Dictionary<string, Texture2D> _textCache = new Dictionary<string, Texture2D>();
        readonly Dictionary<string, string> _recordings = new Dictionary<string, string>();

        static readonly string[] FontNames = { "Georgia", "Times New Roman", "Arial" };

        string MediaRoot => Path.Combine(Application.streamingAssetsPath, "Media");

        public string MusicPath => Path.Combine(MediaRoot, "audio", "anpu.wav");

        public Texture2D Image(string name)
        {
            if (_images.TryGetValue(name, out var cached)) return cached;
            string path = Path.Combine(MediaRoot, "img", name + ".png");
            if (!File.Exists(path)) return null;
            byte[] bytes = File.ReadAllBytes(path);
            var tex = new Texture2D(2, 2, TextureFormat.RGBA32, false);
            tex.LoadImage(bytes);
            tex.filterMode = FilterMode.Bilinear;
            tex.wrapMode = TextureWrapMode.Clamp;
            _images[name] = tex;
            return tex;
        }

        public string Recording(string name)
        {
            if (_recordings.TryGetValue(name, out var cached)) return cached;
            string path = Path.Combine(MediaRoot, "data", name + ".txt");
            string text = File.Exists(path) ? File.ReadAllText(path) : string.Empty;
            _recordings[name] = text;
            return text;
        }

        public Texture2D Text(string text, int fontSize, float maxWidth = 0f, TextAnchor align = TextAnchor.MiddleCenter)
        {
            string key = text + "|" + fontSize + "|" + maxWidth + "|" + align;
            if (_textCache.TryGetValue(key, out var cached)) return cached;
            var tex = RasterizeText(text, fontSize, maxWidth, align);
            if (tex != null) _textCache[key] = tex;
            return tex;
        }

        Texture2D RasterizeText(string text, int fontSize, float maxWidth, TextAnchor align)
        {
            if (string.IsNullOrEmpty(text)) return null;

            var font = Font.CreateDynamicFontFromOSFont(FontNames, fontSize);
            font.RequestCharactersInTexture(text, fontSize, FontStyle.Normal);

            var lines = WrapLines(text, font, fontSize, maxWidth);
            float width = 0f;
            float lineHeight = fontSize * 1.25f;
            foreach (var line in lines)
                width = Mathf.Max(width, MeasureLine(line, font, fontSize));

            const float pad = 4f;
            int w = Mathf.Max(1, Mathf.CeilToInt(width + pad * 2f));
            int h = Mathf.Max(1, Mathf.CeilToInt(lines.Count * lineHeight + pad * 2f));

            var result = new Texture2D(w, h, TextureFormat.RGBA32, false);
            var clear = new Color[w * h];
            for (int i = 0; i < clear.Length; i++) clear[i] = Color.clear;
            result.SetPixels(clear);
            result.Apply(false, false);

            float y = pad;
            for (int li = 0; li < lines.Count; li++)
            {
                string line = lines[li];
                float lineW = MeasureLine(line, font, fontSize);
                float x = pad;
                switch (align)
                {
                    case TextAnchor.MiddleCenter:
                    case TextAnchor.UpperCenter:
                    case TextAnchor.LowerCenter:
                        x = pad + (width - lineW) * 0.5f;
                        break;
                    case TextAnchor.MiddleRight:
                    case TextAnchor.UpperRight:
                    case TextAnchor.LowerRight:
                        x = pad + width - lineW;
                        break;
                }

                DrawLine(result, font, line, x, y, fontSize);
                y += lineHeight;
            }

            result.Apply(false, false);
            result.filterMode = FilterMode.Bilinear;
            return result;
        }

        static List<string> WrapLines(string text, Font font, int fontSize, float maxWidth)
        {
            var lines = new List<string>();
            if (maxWidth <= 0f)
            {
                lines.Add(text);
                return lines;
            }

            string[] words = text.Split(' ');
            string current = string.Empty;
            foreach (string word in words)
            {
                string trial = string.IsNullOrEmpty(current) ? word : current + " " + word;
                if (MeasureLine(trial, font, fontSize) <= maxWidth || string.IsNullOrEmpty(current))
                    current = trial;
                else
                {
                    lines.Add(current);
                    current = word;
                }
            }
            if (!string.IsNullOrEmpty(current)) lines.Add(current);
            if (lines.Count == 0) lines.Add(text);
            return lines;
        }

        static float MeasureLine(string line, Font font, int fontSize)
        {
            float width = 0f;
            foreach (char c in line)
            {
                if (!font.GetCharacterInfo(c, out CharacterInfo info, fontSize, FontStyle.Normal)) continue;
                width += info.advance;
            }
            return width;
        }

        static void DrawLine(Texture2D target, Font font, string line, float x, float y, int fontSize)
        {
            float cursor = x;
            foreach (char c in line)
            {
                if (!font.GetCharacterInfo(c, out CharacterInfo info, fontSize, FontStyle.Normal)) continue;
                BlitGlyph(target, font, info, cursor + info.minX, y + info.maxY, fontSize);
                cursor += info.advance;
            }
        }

        static void BlitGlyph(Texture2D target, Font font, CharacterInfo info, float x, float y, int fontSize)
        {
            var src = font.material.mainTexture as Texture2D;
            if (src == null) return;

            int gw = info.glyphWidth;
            int gh = info.glyphHeight;
            if (gw <= 0 || gh <= 0) return;

            int sx = Mathf.RoundToInt(info.uvBottomLeft.x * src.width);
            int sy = Mathf.RoundToInt(info.uvBottomLeft.y * src.height);
            int sw = Mathf.Max(1, Mathf.RoundToInt((info.uvTopRight.x - info.uvBottomLeft.x) * src.width));
            int sh = Mathf.Max(1, Mathf.RoundToInt((info.uvTopRight.y - info.uvBottomLeft.y) * src.height));

            int dx = Mathf.RoundToInt(x);
            int dy = Mathf.RoundToInt(y - gh);

            for (int py = 0; py < sh; py++)
            {
                int ty = dy + py;
                if (ty < 0 || ty >= target.height) continue;
                for (int px = 0; px < sw; px++)
                {
                    int tx = dx + px;
                    if (tx < 0 || tx >= target.width) continue;
                    Color sample = src.GetPixelBilinear(
                        (sx + px + 0.5f) / src.width,
                        (sy + py + 0.5f) / src.height);
                    if (sample.a <= 0f) continue;
                    Color existing = target.GetPixel(tx, ty);
                    float a = sample.a;
                    target.SetPixel(tx, ty, new Color(1f, 1f, 1f, existing.a + a * (1f - existing.a)));
                }
            }
        }
    }
}
