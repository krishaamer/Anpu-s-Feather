using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;

namespace AnpusFeather
{
    /*
      Owns persistent scene/capture render targets and flushes DrawCanvas batches.
    */
    [RequireComponent(typeof(Camera))]
    public sealed class GameRenderer : MonoBehaviour
    {
        public const int CaptureW = 1600;
        public const int CaptureH = 900;

        public DrawCanvas Scene { get; } = new DrawCanvas();
        public DrawCanvas Capture { get; } = new DrawCanvas();

        public RenderTexture SceneRT { get; private set; }
        public RenderTexture CaptureRT { get; private set; }
        public Vector2 CaptureSize => new Vector2(CaptureW, CaptureH);

        Material _colorMat;
        Material _colorAddMat;
        Material _texturedMat;
        Material _pointAddMat;
        Mesh _mesh;
        readonly List<Vector3> _positions = new List<Vector3>();
        readonly List<Vector2> _uvs = new List<Vector2>();
        readonly List<Color> _colors = new List<Color>();
        readonly List<int> _triangles = new List<int>();

        Camera _camera;

        void Awake()
        {
            _camera = GetComponent<Camera>();
            _camera.clearFlags = CameraClearFlags.SolidColor;
            _camera.backgroundColor = Color.black;
            _camera.orthographic = true;
            _camera.enabled = false;

            var shader = Shader.Find("AnpusFeather/AnpuUnlit");
            if (shader == null)
                shader = Shader.Find("Sprites/Default");

            _colorMat = new Material(shader);
            _colorAddMat = new Material(shader);
            _texturedMat = new Material(shader);
            _pointAddMat = new Material(shader);
            _pointAddMat.EnableKeyword("_POINT_ON");

            _mesh = new Mesh { name = "AnpuCanvasMesh" };
            _mesh.MarkDynamic();
            CaptureRT = CreateTarget(CaptureW, CaptureH, clear: true);
            ResizeSceneRT(Screen.width, Screen.height);
        }

        void OnDestroy()
        {
            if (SceneRT != null) SceneRT.Release();
            if (CaptureRT != null) CaptureRT.Release();
        }

        void LateUpdate()
        {
            Flush();
        }

        public void ResizeSceneRT(int pixelW, int pixelH)
        {
            pixelW = Mathf.Max(1, pixelW);
            pixelH = Mathf.Max(1, pixelH);
            if (SceneRT != null && SceneRT.width == pixelW && SceneRT.height == pixelH) return;
            if (SceneRT != null) SceneRT.Release();
            SceneRT = CreateTarget(pixelW, pixelH, clear: true);
        }

        static RenderTexture CreateTarget(int width, int height, bool clear)
        {
            var rt = new RenderTexture(width, height, 0, RenderTextureFormat.ARGB32)
            {
                filterMode = FilterMode.Bilinear,
                wrapMode = TextureWrapMode.Clamp
            };
            rt.Create();
            if (clear) ClearTarget(rt);
            return rt;
        }

        static void ClearTarget(RenderTexture rt)
        {
            var prev = RenderTexture.active;
            RenderTexture.active = rt;
            GL.Clear(true, true, Color.black);
            RenderTexture.active = prev;
        }

        public void ClearCaptureTexture() => ClearTarget(CaptureRT);

        public Texture2D ReadCaptureTexture()
        {
            var prev = RenderTexture.active;
            RenderTexture.active = CaptureRT;
            var tex = new Texture2D(CaptureW, CaptureH, TextureFormat.RGBA32, false);
            tex.ReadPixels(new Rect(0, 0, CaptureW, CaptureH), 0, 0);
            tex.Apply();
            RenderTexture.active = prev;
            return tex;
        }

        public void Flush()
        {
            FlushCanvas(Capture, CaptureRT, stretch: true);
            FlushCanvas(Scene, SceneRT, stretch: false);
        }

        void FlushCanvas(DrawCanvas canvas, RenderTexture target, bool stretch)
        {
            if (canvas.IsEmpty || target == null) return;

            // Load (don't clear) so particle trails and fade washes persist.
            var prev = RenderTexture.active;
            RenderTexture.active = target;

            GL.PushMatrix();
            GL.LoadIdentity();
            if (stretch)
            {
                GL.Viewport(new Rect(0f, 0f, target.width, target.height));
                GL.LoadProjectionMatrix(Matrix4x4.Ortho(0f, World.W, World.H, 0f, -1f, 1f));
            }
            else
            {
                float scale = Mathf.Min(target.width / World.W, target.height / World.H);
                float offX = (target.width - World.W * scale) * 0.5f;
                float offY = (target.height - World.H * scale) * 0.5f;
                GL.Viewport(new Rect(offX, offY, World.W * scale, World.H * scale));
                GL.LoadProjectionMatrix(Matrix4x4.Ortho(0f, World.W, World.H, 0f, -1f, 1f));
            }

            foreach (var cmd in canvas.Commands)
                DrawCommand(canvas, cmd);

            GL.PopMatrix();
            RenderTexture.active = prev;
        }

        void DrawCommand(DrawCanvas canvas, DrawCommand cmd)
        {
            _positions.Clear();
            _uvs.Clear();
            _colors.Clear();
            _triangles.Clear();

            for (int i = 0; i < cmd.Count; i++)
            {
                var v = canvas.Vertices[cmd.Start + i];
                _positions.Add(v.Position);
                _uvs.Add(v.Uv);
                _colors.Add(v.Color);
            }

            for (int i = 0; i + 2 < cmd.Count; i += 3)
            {
                _triangles.Add(i);
                _triangles.Add(i + 1);
                _triangles.Add(i + 2);
            }

            _mesh.Clear();
            _mesh.SetVertices(_positions);
            _mesh.SetUVs(0, _uvs);
            _mesh.SetColors(_colors);
            _mesh.SetTriangles(_triangles, 0, true);

            Material mat = PickMaterial(cmd);
            if (cmd.Texture != null) mat.mainTexture = cmd.Texture;
            else mat.mainTexture = Texture2D.whiteTexture;

            mat.SetPass(cmd.BlendAdd ? 1 : 0);
            Graphics.DrawMeshNow(_mesh, Matrix4x4.identity);
        }

        Material PickMaterial(DrawCommand cmd)
        {
            if (cmd.Pipe == DrawPipe.Point) return _pointAddMat;
            if (cmd.Pipe == DrawPipe.Textured) return _texturedMat;
            return cmd.BlendAdd ? _colorAddMat : _colorMat;
        }

        public void PresentGUI()
        {
            if (SceneRT == null) return;
            // Negative height flips the RT: we draw Y-down into it, GUI expects V-up.
            GUI.DrawTexture(new Rect(0f, Screen.height, Screen.width, -Screen.height), SceneRT);
        }
    }
}
