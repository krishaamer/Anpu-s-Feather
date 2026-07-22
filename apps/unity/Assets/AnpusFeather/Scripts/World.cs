using UnityEngine;

namespace AnpusFeather
{
    /*
      Shared constants and helpers — the Swift counterpart of Core.swift / core.ts.
      The world is responsive: a fixed design height (900) with a width that tracks
      the view's aspect ratio.
    */
    public static class World
    {
        public const float DesignH = 900f;
        public const float MinAspect = 1.2f;
        public const float MaxAspect = 2.6f;
        public const float Fps = 27f;
        public const int Joints = 17;

        public static float W { get; private set; } = 1600f;
        public static float H { get; private set; } = DesignH;

        public static void SetViewport(float pixelW, float pixelH)
        {
            float aspect = MathUtil.Clamp(pixelW / Mathf.Max(pixelH, 1f), MinAspect, MaxAspect);
            H = DesignH;
            W = Mathf.Round(DesignH * aspect);
        }

        public static bool IsPortrait(float pixelW, float pixelH) =>
            pixelW / Mathf.Max(pixelH, 1f) < MinAspect;
    }

    public struct Vec3
    {
        public float X;
        public float Y;
        public float Z;

        public Vec3(float x, float y, float z)
        {
            X = x;
            Y = y;
            Z = z;
        }
    }

    public struct Color4
    {
        public float R;
        public float G;
        public float B;
        public float A;

        public Color4(float r, float g, float b, float a)
        {
            R = r;
            G = g;
            B = b;
            A = a;
        }

        public static readonly Color4 White = new Color4(1f, 1f, 1f, 1f);
        public static readonly Color4 Black = new Color4(0f, 0f, 0f, 1f);

        public static Color4 Rgba(float r, float g, float b, float a) =>
            new Color4(r / 255f, g / 255f, b / 255f, a);

        public Color ToUnity() => new Color(R, G, B, A);
    }

    public static class MathUtil
    {
        public static float Lerp(float a, float b, float t) => a + (b - a) * t;

        public static float Clamp(float v, float lo, float hi) => Mathf.Min(hi, Mathf.Max(lo, v));

        // Processing's map(): intentionally unclamped.
        public static float Map(float v, float inLo, float inHi, float outLo, float outHi) =>
            outLo + ((v - inLo) / (inHi - inLo)) * (outHi - outLo);

        public static float RandomRange(float lo, float hi) =>
            lo + Random.value * (hi - lo);
    }
}
