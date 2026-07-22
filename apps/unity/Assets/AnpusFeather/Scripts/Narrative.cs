namespace AnpusFeather
{
    /// Controls the sequence of scenes — the port of narrative.pde.
    public enum Mode
    {
        Intro,
        Questions,
        Light,
        Heavy,
        Scales,
        Wisdom,
        Outro
    }

    public sealed class Narrative
    {
        public Mode CurrentMode { get; private set; } = Mode.Intro;
        float _sceneTime;

        public void Update(float dt) => _sceneTime += dt;
        public float Time => _sceneTime;

        public void SetMode(Mode mode)
        {
            CurrentMode = mode;
            _sceneTime = 0f;
        }

        public void ResetTime() => _sceneTime = 0f;
    }
}
