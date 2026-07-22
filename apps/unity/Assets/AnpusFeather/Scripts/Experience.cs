using UnityEngine;

namespace AnpusFeather
{
    /*
      The scene director — port of Experience.swift / experience.ts.
    */
    public sealed class Experience
    {
        readonly GameRenderer _renderer;
        readonly AssetStore _store;
        readonly Pointer _pointer;
        readonly Music _music;
        readonly System.Action _onRestart;

        readonly Narrative _story = new Narrative();
        readonly Skeleton _skeleton;
        readonly Message _message;
        readonly River _river = new River();
        readonly Pyramid _pyramid;
        readonly User _user;
        readonly Scales _scales;
        readonly QA _qa;
        readonly Wisdom _wisdom;

        float _clock;
        bool _captureStarted;

        public bool ShowSave { get; private set; }
        public Narrative Story => _story;
        public Skeleton Skeleton => _skeleton;

        DrawCanvas Scene => _renderer.Scene;
        DrawCanvas Capture => _renderer.Capture;

        public Experience(GameRenderer renderer, AssetStore store, Pointer pointer, Music music,
            System.Action onRestart)
        {
            _renderer = renderer;
            _store = store;
            _pointer = pointer;
            _music = music;
            _onRestart = onRestart;

            _skeleton = new Skeleton(store, pointer);
            _message = new Message(store);
            _pyramid = new Pyramid(store);
            _user = new User(_skeleton);
            _scales = new Scales(store, _skeleton);
            _qa = new QA(store, _skeleton);
            _wisdom = new Wisdom(store);
            _story.SetMode(Mode.Intro);
        }

        public void Start() => _music.Play();
        public void Stop() => _music.End();

        public Texture2D ExportCardImage()
        {
            Texture2D dance = _renderer.ReadCaptureTexture();
            return _wisdom.ExportTexture(dance);
        }

        public void OnKey(string key)
        {
            switch (key)
            {
                case "1": _story.SetMode(Mode.Intro); break;
                case "2": _story.SetMode(Mode.Questions); break;
                case "3": _story.SetMode(Mode.Scales); break;
                case "4": _story.SetMode(Mode.Heavy); break;
                case "5": _story.SetMode(Mode.Light); break;
                case "6": _story.SetMode(Mode.Wisdom); break;
                case "7": _story.SetMode(Mode.Outro); break;
            }

            if (key == "r" || key == "R") _story.ResetTime();
            if (key == "ArrowRight") _skeleton.NextRecording();
            if (key == "ArrowLeft") _skeleton.PrevRecording();
            if (key == "m" || key == "M") _music.ToggleMute();
        }

        public void Update(float dt)
        {
            _clock += dt;
            _story.Update(dt);
            _skeleton.Update(dt);
            _pyramid.Tick(dt);
            _pointer.Decay();

            float t = _story.Time;
            switch (_story.CurrentMode)
            {
                case Mode.Intro: Intro(t, dt); break;
                case Mode.Questions: Questions(t, dt); break;
                case Mode.Light: Light(t, dt); break;
                case Mode.Heavy: Heavy(t, dt); break;
                case Mode.Scales: ScalesScene(t, dt); break;
                case Mode.Wisdom: WisdomScene(t, dt); break;
                case Mode.Outro: Outro(t, dt); break;
            }

            bool showSave = _story.CurrentMode == Mode.Wisdom && t > 5.2f;
            if (ShowSave != showSave) ShowSave = showSave;
        }

        void Clear() => Scene.Clear();
        void Fade(float a) => Scene.Fade(a);

        void Intro(float t, float dt)
        {
            Clear();
            if (t < 2.5f)
            {
                _message.FadeIn(10f, dt);
                _river.Update(Scene, dt);
            }
            else if (t < 3.5f)
            {
                _message.FadeOut(10f, dt);
                _river.Update(Scene, dt);
            }

            if (t < 3.5f)
            {
                _message.Say(Scene, "Em heset net Anpu!");
                _message.Subtitle(Scene, "Praise the God");
            }

            if (t >= 3.5f && t < 3.6f)
            {
                _message.SetAlpha(0f);
                _river.Update(Scene, dt);
            }

            if (t >= 3.6f && t < 8.9f)
            {
                _river.Update(Scene, dt);
                _river.FadeOut(dt);
                _pyramid.Show(Scene);
                _pyramid.FadeIn(dt);
                if (t < 7f) _message.FadeIn(8f, dt);
                else _message.FadeOut(10f, dt);
                _message.Say(Scene, "I have been waiting for You");
            }

            if (t >= 8.9f && t < 12f)
            {
                _river.Update(Scene, dt);
                _river.FadeOut(dt);
                _pyramid.Show(Scene);
                _pyramid.FadeOut(dt);
                if (t >= 11.9f) _message.SetAlpha(0f);
            }

            if (t >= 12f && t < 19f)
            {
                if (t < 16f)
                {
                    _message.FadeIn(8f, dt);
                    _scales.FadeIn(dt);
                }
                else
                {
                    _message.FadeOut(8f, dt);
                    _scales.FadeOut(dt);
                }
                _scales.ShowDiagram(false);
                _scales.StartFrom(Scales.FeatherStart.Top);
                _scales.Update(Scene, dt, _clock);
                _message.Say(Scene, "How heavy is your heart?");
            }

            if (t > 19f)
            {
                _message.SetAlpha(0f);
                _story.SetMode(Mode.Questions);
                _skeleton.RandomRecording();
            }
        }

        void Questions(float t, float dt)
        {
            Clear();
            if (t < 0.1f)
            {
                _qa.AnswerReset();
                _message.SetAlpha(0f);
            }

            if (t >= 0.1f && t < 1f)
            {
                _message.FadeIn(8f, dt);
                _message.Say(Scene, "Have you cried this week?");
            }

            if (t >= 1f)
            {
                _qa.EnableGestures();
                _qa.EnableButtons(_pointer.TakeClicks());

                _message.Say(Scene, "Have you cried this week?");
                _message.FadeOut(6f, dt);

                _pyramid.Show(Scene);
                _pyramid.FadeIn(dt);

                _qa.Ask(Scene);
                _qa.FadeIn(dt);

                _user.Draw(Scene, UserMode.Questions);
                _user.FadeIn(dt);

                if (_qa.CurrentAnswer == QA.Answer.Yes)
                {
                    _message.SetAlpha(0f);
                    _story.SetMode(Mode.Light);
                    return;
                }

                if (_qa.CurrentAnswer == QA.Answer.No)
                {
                    _message.SetAlpha(0f);
                    _story.SetMode(Mode.Heavy);
                }
            }
        }

        void Light(float t, float dt)
        {
            if (t < 0.1f)
            {
                Clear();
                _message.SetAlpha(0f);
                _pyramid.SetAlpha(0f);
                _captureStarted = false;
            }

            if (t < 4.9f) Clear();

            if (t >= 0.1f && t < 0.5f) _message.Alert(Scene, "YES", false);

            if (t >= 0.5f && t < 3f)
            {
                _pyramid.ShowAlt(Scene);
                _pyramid.FadeIn(dt);
                if (t < 2f) _message.FadeIn(8f, dt);
                else _message.FadeOut(8f, dt);
                _message.Say(Scene, "Your heart seems light");
            }

            if (t >= 3f && t < 3.1f) _message.SetAlpha(0f);

            if (t >= 3.2f && t < 4.9f)
            {
                if (t < 4f) _message.FadeIn(30f, dt);
                else _message.FadeOut(30f, dt);
                _message.Say(Scene, "Show me");
            }

            if (t >= 4.9f && t < 5f) _message.SetAlpha(0f);

            if (t >= 4f && t < 19.9f)
            {
                _user.Simulate();
                Scene.BlendAdd = true;
                _user.Draw(Scene, UserMode.Light);
                Scene.BlendAdd = false;
                _user.FadeIn(dt);
            }

            if (t >= 5f && t < 20f)
            {
                if (!_captureStarted)
                {
                    _captureStarted = true;
                    _renderer.ClearCaptureTexture();
                }
                Capture.BlendAdd = true;
                _user.Draw(Capture, UserMode.Light);
                Capture.BlendAdd = false;
            }

            if (t > 20f)
            {
                _message.SetAlpha(0f);
                _story.SetMode(Mode.Scales);
            }
        }

        void Heavy(float t, float dt)
        {
            Clear();
            if (t < 0.1f)
            {
                _message.SetAlpha(0f);
                _pyramid.SetAlpha(0f);
                _captureStarted = false;
            }

            if (t >= 0.1f && t < 0.5f) _message.Alert(Scene, "NO", true);

            if (t >= 0.5f && t < 3f)
            {
                _pyramid.ShowAlt(Scene);
                _pyramid.FadeIn(dt);
                if (t < 1.5f) _message.FadeIn(10f, dt);
                else _message.FadeOut(8f, dt);
                _message.Say(Scene, "Your heart must be heavy");
            }

            if (t >= 3f && t < 13f)
            {
                _pyramid.ShowAlt(Scene);
                _pyramid.FadeIn(dt);
                _user.Draw(Scene, UserMode.Heavy);
                _user.FadeIn(dt);
            }

            if (t >= 3f && t < 3.1f) _message.SetAlpha(0f);

            if (t >= 3.1f && t < 6f)
            {
                if (t < 5f) _message.FadeIn(8f, dt);
                else _message.FadeOut(8f, dt);
                _message.Say(Scene, "Show me");
            }

            if (t >= 6f && t < 13f)
            {
                if (!_captureStarted)
                {
                    _captureStarted = true;
                    _renderer.ClearCaptureTexture();
                }
                _user.Draw(Capture, UserMode.Heavy);
            }

            if (t > 13f)
            {
                _message.SetAlpha(0f);
                _story.SetMode(Mode.Scales);
            }
        }

        void ScalesScene(float t, float dt)
        {
            if (t < 0.1f)
            {
                Clear();
                _message.SetAlpha(0f);
            }

            if (t >= 0.1f && t < 8f)
            {
                Fade(0.15f);
                _scales.ShowDiagram(true);
                _scales.StartFrom(Scales.FeatherStart.Middle);
                _scales.Update(Scene, dt, _clock);
                _scales.FadeIn(dt);
                _message.Countdown(Scene, 8, t);
            }

            if (t >= 8f && t < 10.5f)
            {
                Clear();
                if (t < 9.5f) _message.FadeIn(8f, dt);
                else _message.FadeOut(8f, dt);
                _message.Say(Scene, "It's not time to die");
            }

            if (t > 10.5f)
            {
                _message.SetAlpha(0f);
                _story.SetMode(Mode.Wisdom);
            }
        }

        void WisdomScene(float t, float dt)
        {
            Clear();
            if (t < 0.1f)
            {
                _message.SetAlpha(0f);
                _wisdom.GetQuote(_scales.Feather);
            }

            if (t >= 0.1f && t < 5f)
            {
                if (t < 4f) _message.FadeIn(8f, dt);
                else _message.FadeOut(8f, dt);
                _message.Say(Scene, "Sebayt");
                _message.Subtitle(Scene, "Wisdom will guide your life");
            }

            if (t >= 5f && t < 5.1f) _message.SetAlpha(0f);

            if (t >= 5.2f && t < 40f)
            {
                _wisdom.ShowCard(Scene, _renderer.CaptureRT, _renderer.CaptureSize);
                _wisdom.FadeIn(8f, dt);
                if (t > 10f && _pointer.TakeClicks().Length > 0)
                {
                    _story.SetMode(Mode.Outro);
                    return;
                }
            }

            if (t >= 40f && t < 42f)
            {
                _wisdom.ShowCard(Scene, _renderer.CaptureRT, _renderer.CaptureSize);
                _wisdom.FadeOut(8f, dt);
            }

            if (t > 42f)
            {
                _message.SetAlpha(0f);
                _story.SetMode(Mode.Outro);
            }
        }

        void Outro(float t, float dt)
        {
            Clear();
            if (t < 0.1f) _message.SetAlpha(0f);

            if (t >= 0.1f && t < 6f)
            {
                if (t < 3f) _message.FadeIn(4f, dt);
                else
                {
                    _message.FadeOut(6f, dt);
                    _music.FadeOut(dt);
                }
                _message.Say(Scene, "Ankhek!");
                _message.Subtitle(Scene, "May you live");
            }

            if (t > 6f)
            {
                _music.End();
                _message.SetAlpha(255f);
                _message.Subtitle(Scene, "Touch the water to live again");
                if (_pointer.TakeClicks().Length > 0) _onRestart();
            }
        }
    }
}
