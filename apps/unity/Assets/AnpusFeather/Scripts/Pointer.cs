using System.Collections.Generic;
using UnityEngine;

namespace AnpusFeather
{
    /*
      Touch / mouse input — the native stand-in for the Kinect.
      Positions are in world coordinates.
    */
    public sealed class Pointer
    {
        public float X { get; private set; } = World.W / 2f;
        public float Y { get; private set; } = World.H / 2f;
        public float Speed { get; private set; }

        float _lastMoveAt = -1e9f;
        readonly List<(float x, float y)> _clicks = new List<(float x, float y)>();

        public void Moved(float wx, float wy)
        {
            float dx = wx - X;
            float dy = wy - Y;
            float dist = Mathf.Sqrt(dx * dx + dy * dy);
            Speed = Speed * 0.85f + dist * 0.15f;
            X = MathUtil.Clamp(wx, 0f, World.W);
            Y = MathUtil.Clamp(wy, 0f, World.H);
            if (dist > 1f) _lastMoveAt = Time.unscaledTime;
        }

        public void Down(float wx, float wy)
        {
            _clicks.Add((wx, wy));
            _lastMoveAt = Time.unscaledTime;
            Moved(wx, wy);
        }

        public float IdleSeconds() => Time.unscaledTime - _lastMoveAt;

        public (float x, float y)[] TakeClicks()
        {
            var c = _clicks.ToArray();
            _clicks.Clear();
            return c;
        }

        public void Decay() => Speed *= 0.92f;
    }
}
