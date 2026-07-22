using System.Collections.Generic;
using UnityEngine;

namespace AnpusFeather
{
    /*
      Skeleton playback — port of Skeleton.swift / skeleton.ts.
    */
    public sealed class Skeleton
    {
        public Vec3[] Points { get; } = new Vec3[World.Joints];

        readonly List<Vec3[]> _frames = new List<Vec3[]>();
        float _frameClock;
        int _index;
        float _handBlend;

        readonly string[] _names =
        {
            "wave1", "wave2", "pray1", "pray2", "swim1", "turn1", "dig1", "shrugging"
        };

        readonly AssetStore _store;
        readonly Pointer _pointer;

        public Skeleton(AssetStore store, Pointer pointer)
        {
            _store = store;
            _pointer = pointer;
            Load(_names[0]);
        }

        void Load(string name)
        {
            _frames.Clear();
            string text = _store.Recording(name);
            foreach (string line in text.Split('\n'))
            {
                string[] pieces = line.Split(',');
                if (pieces.Length < World.Joints * 3) continue;
                var frame = new Vec3[World.Joints];
                int idx = 0;
                for (int j = 0; j < World.Joints; j++)
                {
                    float.TryParse(pieces[idx], out float x);
                    float.TryParse(pieces[idx + 1], out float y);
                    float.TryParse(pieces[idx + 2], out float z);
                    frame[j] = new Vec3(x, y, z);
                    idx += 3;
                }
                _frames.Add(frame);
            }
            _frameClock = 0f;
        }

        public void NextRecording()
        {
            _index = (_index + 1) % _names.Length;
            Load(_names[_index]);
        }

        public void PrevRecording()
        {
            _index = (_index - 1 + _names.Length) % _names.Length;
            Load(_names[_index]);
        }

        public void RandomRecording()
        {
            _index = Random.Range(0, _names.Length);
            Load(_names[_index]);
        }

        public void Update(float dt)
        {
            if (_frames.Count == 0) return;
            _frameClock += dt * World.Fps;
            int idx = ((int)_frameClock) % _frames.Count;
            Vec3[] frame = _frames[idx];

            float target = _pointer.IdleSeconds() < 2f ? 1f : 0f;
            _handBlend = MathUtil.Lerp(_handBlend, target, MathUtil.Clamp(dt * 3f, 0f, 1f));

            float px = _pointer.X - World.W / 2f;
            float py = _pointer.Y - World.H / 2f;

            for (int i = 0; i < World.Joints; i++) Points[i] = frame[i];

            float b = _handBlend;
            Points[4] = new Vec3(MathUtil.Lerp(Points[4].X, px - 50f, b), MathUtil.Lerp(Points[4].Y, py, b), Points[4].Z);
            Points[7] = new Vec3(MathUtil.Lerp(Points[7].X, px + 50f, b), MathUtil.Lerp(Points[7].Y, py, b), Points[7].Z);
        }
    }
}
