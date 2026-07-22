using System.Collections;
using UnityEngine;
using UnityEngine.Networking;

namespace AnpusFeather
{
    /*
      Soundtrack — port of music.pde.
      Copyright-free music "Anubis" by Lucha and R3VXS.
    */
    public sealed class Music
    {
        AudioSource _source;
        float _volume = 1f;
        bool _wantPlay;

        public bool IsReady => _source != null && _source.clip != null;

        public void Attach(AudioSource source) => _source = source;

        public IEnumerator Load(string path)
        {
            // UnityWebRequest needs a URI (file://) for local StreamingAssets paths.
            string url = path.Contains("://") ? path : new System.Uri(path).AbsoluteUri;
            using var req = UnityWebRequestMultimedia.GetAudioClip(url, AudioType.WAV);
            ((DownloadHandlerAudioClip)req.downloadHandler).streamAudio = true;
            yield return req.SendWebRequest();
            if (req.result != UnityWebRequest.Result.Success || _source == null) yield break;
            _source.clip = DownloadHandlerAudioClip.GetContent(req);
            _source.loop = true;
            _source.playOnAwake = false;
            if (_wantPlay) Play();
        }

        public void Play()
        {
            _wantPlay = true;
            if (_source == null || _source.clip == null) return;
            _volume = 1f;
            _source.volume = _volume;
            _source.Play();
        }

        public void FadeOut(float dt)
        {
            if (_source == null || !_source.isPlaying || _volume <= 0f) return;
            _volume = Mathf.Max(0f, _volume - 0.05f * dt * World.Fps);
            _source.volume = _volume;
        }

        public void End()
        {
            if (_source != null) _source.Stop();
        }

        public void ToggleMute()
        {
            if (_source == null) return;
            _source.volume = _source.volume > 0f ? 0f : _volume;
        }
    }
}
