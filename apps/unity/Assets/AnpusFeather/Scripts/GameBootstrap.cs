using System.Collections;
using System.IO;
using UnityEngine;

#if UNITY_EDITOR
using UnityEditor;
#endif

namespace AnpusFeather
{
    /*
      App shell — wires renderer, input, audio and Experience together.
    */
    public sealed class GameBootstrap : MonoBehaviour
    {
        public enum Phase
        {
            Title,
            Playing
        }

        static readonly Color Parchment = new Color(232f / 255f, 220f / 255f, 192f / 255f);
        static readonly Color Dim = new Color(179f / 255f, 168f / 255f, 136f / 255f);

        Phase _phase = Phase.Title;
        bool _portrait;

        GameRenderer _renderer;
        AssetStore _store;
        Pointer _pointer;
        Music _music;
        Experience _experience;
        AudioSource _audioSource;
        GUIStyle _titleStyle;
        GUIStyle _bodyStyle;
        GUIStyle _buttonStyle;

        void Awake()
        {
            _renderer = GetComponent<GameRenderer>();
            if (_renderer == null) _renderer = gameObject.AddComponent<GameRenderer>();

            _audioSource = GetComponent<AudioSource>();
            if (_audioSource == null) _audioSource = gameObject.AddComponent<AudioSource>();

            _store = new AssetStore();
            _pointer = new Pointer();
            _music = new Music();
            _music.Attach(_audioSource);
            StartCoroutine(_music.Load(_store.MusicPath));
        }

        void Update()
        {
            World.SetViewport(Screen.width, Screen.height);
            _renderer.ResizeSceneRT(Screen.width, Screen.height);

            bool portrait = World.IsPortrait(Screen.width, Screen.height);
            if (_portrait != portrait) _portrait = portrait;

            if (_phase != Phase.Playing) return;

            float dt = Mathf.Min(Time.deltaTime, 0.1f);
            _renderer.Scene.Reset();
            _renderer.Capture.Reset();

            UpdatePointer();
            _experience?.Update(dt);
        }

        void UpdatePointer()
        {
            if (!TryScreenToWorld(Input.mousePosition, out float wx, out float wy)) return;
            if (Input.GetMouseButtonDown(0)) _pointer.Down(wx, wy);
            else _pointer.Moved(wx, wy);
        }

        bool TryScreenToWorld(Vector3 screenPos, out float wx, out float wy)
        {
            float pixelW = Screen.width;
            float pixelH = Screen.height;
            float scale = Mathf.Min(pixelW / World.W, pixelH / World.H);
            float offX = (pixelW - World.W * scale) * 0.5f;
            float offY = (pixelH - World.H * scale) * 0.5f;
            wx = (screenPos.x - offX) / scale;
            wy = (pixelH - screenPos.y - offY) / scale;
            return true;
        }

        void OnGUI()
        {
            EnsureStyles();
            _renderer.PresentGUI();

            if (_phase == Phase.Title) DrawTitleOverlay();
            else
            {
                if (_experience != null && _experience.ShowSave) DrawSaveButton();
                HandleKeyboard();
            }

            if (_portrait) DrawPortraitOverlay();
        }

        void EnsureStyles()
        {
            if (_titleStyle != null) return;
            _titleStyle = new GUIStyle(GUI.skin.label)
            {
                fontSize = 44,
                alignment = TextAnchor.MiddleCenter,
                normal = { textColor = Parchment }
            };
            _bodyStyle = new GUIStyle(GUI.skin.label)
            {
                fontSize = 17,
                alignment = TextAnchor.MiddleCenter,
                wordWrap = true,
                normal = { textColor = Dim }
            };
            _buttonStyle = new GUIStyle(GUI.skin.button)
            {
                fontSize = 20,
                normal = { textColor = Parchment }
            };
        }

        void DrawTitleOverlay()
        {
            GUI.color = new Color(0f, 0f, 0f, 0.92f);
            GUI.DrawTexture(new Rect(0f, 0f, Screen.width, Screen.height), Texture2D.whiteTexture);
            GUI.color = Color.white;

            GUILayout.BeginArea(new Rect(0f, 0f, Screen.width, Screen.height));
            GUILayout.FlexibleSpace();
            GUILayout.BeginHorizontal();
            GUILayout.FlexibleSpace();
            GUILayout.BeginVertical(GUILayout.MaxWidth(560f));
            GUILayout.Label("Anpu\u2019s Feather", _titleStyle);
            GUILayout.Space(20f);
            GUILayout.Label(
                "You went on a trip on the Nile river before your death. You are welcomed by Anubis, who weighs your heart against the Feather of Truth. Move your finger to move your spirit. Sound on.",
                _bodyStyle);
            GUILayout.Space(20f);
            if (GUILayout.Button("Enter", _buttonStyle, GUILayout.Height(48f)))
                StartJourney();
            GUILayout.EndVertical();
            GUILayout.FlexibleSpace();
            GUILayout.EndHorizontal();
            GUILayout.FlexibleSpace();
            GUILayout.EndArea();
        }

        void DrawSaveButton()
        {
            const float w = 260f;
            const float h = 44f;
            var rect = new Rect(Screen.width - w - 20f, Screen.height - h - 20f, w, h);
            GUI.color = new Color(0f, 0f, 0f, 0.6f);
            GUI.DrawTexture(rect, Texture2D.whiteTexture);
            GUI.color = Color.white;
            if (GUI.Button(rect, "Save your wisdom card", _buttonStyle)) SaveCard();
        }

        void DrawPortraitOverlay()
        {
            GUI.color = new Color(0f, 0f, 0f, 0.92f);
            GUI.DrawTexture(new Rect(0f, 0f, Screen.width, Screen.height), Texture2D.whiteTexture);
            GUI.color = Color.white;
            GUILayout.BeginArea(new Rect(0f, 0f, Screen.width, Screen.height));
            GUILayout.FlexibleSpace();
            GUILayout.BeginHorizontal();
            GUILayout.FlexibleSpace();
            GUILayout.BeginVertical(GUILayout.MaxWidth(420f));
            GUILayout.Label("\U0001F4F1", new GUIStyle(_titleStyle) { fontSize = 54 });
            GUILayout.Space(16f);
            GUILayout.Label("Turn your device sideways \u2014 Anpu\u2019s Feather unfolds in landscape.", _bodyStyle);
            GUILayout.EndVertical();
            GUILayout.FlexibleSpace();
            GUILayout.EndHorizontal();
            GUILayout.FlexibleSpace();
            GUILayout.EndArea();
        }

        void HandleKeyboard()
        {
            foreach (char c in Input.inputString)
            {
                if (c == '\b' || c == '\n') continue;
                _experience?.OnKey(c.ToString());
            }

            if (Input.GetKeyDown(KeyCode.R)) _experience?.OnKey("R");
            if (Input.GetKeyDown(KeyCode.M)) _experience?.OnKey("M");
            if (Input.GetKeyDown(KeyCode.Alpha1)) _experience?.OnKey("1");
            if (Input.GetKeyDown(KeyCode.Alpha2)) _experience?.OnKey("2");
            if (Input.GetKeyDown(KeyCode.Alpha3)) _experience?.OnKey("3");
            if (Input.GetKeyDown(KeyCode.Alpha4)) _experience?.OnKey("4");
            if (Input.GetKeyDown(KeyCode.Alpha5)) _experience?.OnKey("5");
            if (Input.GetKeyDown(KeyCode.Alpha6)) _experience?.OnKey("6");
            if (Input.GetKeyDown(KeyCode.Alpha7)) _experience?.OnKey("7");
            if (Input.GetKeyDown(KeyCode.RightArrow)) _experience?.OnKey("ArrowRight");
            if (Input.GetKeyDown(KeyCode.LeftArrow)) _experience?.OnKey("ArrowLeft");
        }

        public void StartJourney()
        {
            _experience?.Stop();
            _experience = new Experience(_renderer, _store, _pointer, _music, StartJourney);
            _experience.Start();
            _phase = Phase.Playing;
        }

        void SaveCard()
        {
            Texture2D card = _experience?.ExportCardImage();
            if (card == null) return;

            string dir = Application.persistentDataPath;
            string path = Path.Combine(dir, "anpu-wisdom-card.png");
            Wisdom.SaveTexture(card, path);

#if UNITY_EDITOR
            EditorUtility.RevealInFinder(path);
#elif UNITY_STANDALONE
            Application.OpenURL("file://" + path);
#endif
        }
    }
}
