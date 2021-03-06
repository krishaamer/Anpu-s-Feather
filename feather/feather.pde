/*****
  
  Anpu's Feather.
  An interactive experience inviting you to think about your life before death.
  Created by Lei Lin and Kris Haamer at NCKU ICID Digital Design class.
  
  Tainan, Taiwan 
  April, 2020
  
  --------------
  HOW TO USE? ** FOR END USER **:
  -- 1) Answer Anpu's question (YES or NO)
  -- 2) Show the heavyness of your heart by moving your body
  -- 3) Show the business of your life by moving the feather
  -- 4) Receive the wisdom card
  
  --------------
  HOW TO USE? ** FOR TESTING **:
  Keyboard shortcuts will be replaced by user interaction
  -- Use keys 1-7 to switch between "Intro", "Questions", "Scales", "Heavy Heart", "Light Heart", "Wisdom Cards", and "Outro" modes
  -- Use keys B and D for toggling the 3D Perspective Box and Sceleton Dummy
  -- Use LEFT and RIGHT arrow keys to rotate between movements
  -- Use key R to reset scene time to 0
  
  --------------
  DEV HISTORY:
  -- https://github.com/krishaamer/Anpu-s-Feather
  
*****/

// Libs
import processing.sound.*;
import KinectPV2.KJoint;
import KinectPV2.*;

// Flags
boolean is_live = false;
boolean play_music = true;
boolean save_output = true;
boolean enable_mouse_interaction = true;

// Init
KinectPV2 kinect;
SoundFile soundFile;
PGraphics graphics;
HashMap<String,PImage> media = new HashMap<String,PImage>();
PFont nileFont;

Helper helper = new Helper();
Parser parser = new Parser(helper);
Narrative story = new Narrative();
Message message = new Message();
Music music = new Music();
River nile = new River();
Deity anubis = new Deity();
User user = new User(parser.getPoints());
Scales scales = new Scales(parser.getPoints(), media);
Output output = new Output(parser.getPoints(), save_output);
QA qa = new QA(parser.getPoints());
Wisdom wisdom = new Wisdom(parser.getPoints(), media);
Pyramid pyramid = new Pyramid(media);

void setup() {
  
  // Canvas Size
  //size(1280, 900, P3D);
  fullScreen(P3D);
  
  background(0);
  frameRate(27);
  smooth(8);
  
  // Preload Images
  media.put("pyramid0", loadImage("pyramid0.png"));
  media.put("pyramid1", loadImage("pyramid1.png"));
  media.put("pyramid2", loadImage("pyramid2.png"));
  media.put("pyramid3", loadImage("pyramid3.png"));
  media.put("anubis1", loadImage("anubis1.png"));
  media.put("anubis2", loadImage("anubis2.png"));
  media.put("feather", loadImage("feather.png"));
  media.put("scale", loadImage("scale.png"));
  media.put("diagram1", loadImage("diagram1.png"));
  media.put("diagram2", loadImage("diagram2.png"));
  media.put("card", loadImage("wisdom_card_bg.png"));
  
  // Preload font
  nileFont = loadFont("AlNile-Bold-60.vlw");
  textFont(nileFont);
  
  // Play music?
  if (play_music) {
    soundFile = new SoundFile(this, "anpu.wav");
    music.load(soundFile);
    music.play();
  }
  
  // Record user
  graphics = createGraphics(width, height, P3D);
  wisdom.addLib(graphics);
  user.addLib(graphics);
  
  // Is live?
  if (is_live) {
    
    // Live Source
    kinect = new KinectPV2(this);
    parser.liveInit(kinect);
    
  } else {
    
    // File Source
    parser.loadFile("wave1.txt"); // Default file to be loaded
  }
  
  story.setMode("intro"); // Set default story mode on init
  user.setMode(story.mode()); // Set default mode on init
}

void draw() {

  // Shared
  helper.update();
  story.update();
  user.setMode(story.mode());

  // What's the story mode?
  //println(story.mode(), story.time());
  
  if (story.mode() == "scales") {
    scales ();
  }
  
  if (story.mode() == "questions") {
    questions ();
  }
    
  if (story.mode() == "intro") {
    intro ();
  }
   
  if (story.mode() == "heavy") {
     heavy ();
  }
  
  if (story.mode() == "light") {
    light ();
  }
  
  if (story.mode() == "wisdom") {
    wisdom ();
  }
  
  if (story.mode() == "outro") {
    outro ();
  }
}

void keyReleased () {  
  parser.enableKeys();
  helper.toggleBox();
  helper.toggleDummy(parser);
  story.toggleMode();
  output.enableKeys();
}

void mouseClicked() {
   
  if (enable_mouse_interaction && story.mode() == "questions") {
    qa.enableButtons();
  }
}
