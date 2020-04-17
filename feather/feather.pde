/*****
  
  Anpu's Feather.
  An interactive experience inviting you to think about your life before death.

  Created by Lei Lin and Kris Haamer at NCKU ICID Digital Design class.
  Tainan, Taiwan 
  April, 2020
  
  --------------
  
  HOW TO USE? ** FOR TESTING **:
  Keyboard shortcuts will be replaced by user interaction
  -- Use keys 1, 2, 3, 4 to switch between "Intro", "Scales", "Heavy Heart", and "Light Heart" modes
  -- Use keys B and D for toggling the 3D Perspective Box and Sceleton Dummy
  -- Use LEFT and RIGHT arrow keys to rotate between movements
  
  --------------
  
  TODO:
  -- Add scales (the feather) to weigh the heart
  -- Narrative fade-in and fade-out of different elements
  -- User interaction to control the sequence
  
*****/

// Live
import processing.sound.*;
import KinectPV2.KJoint;
import KinectPV2.*;

// Init
KinectPV2 kinect;
SoundFile soundFile;
boolean is_live = false;

Helper helper = new Helper();
Parser parser = new Parser(helper);
Narrative story = new Narrative();
Message message = new Message();
Music music = new Music();
River nile = new River();
Deity anubis = new Deity();
User user = new User(parser.getPoints(), helper);
Scales scales = new Scales(parser.getPoints(), helper);
Output output = new Output(parser.getPoints());
QA qa = new QA(parser.getPoints());

void setup() {
  
  size(800, 800, P3D);
  background(0);
  frameRate(25);
  smooth(8);
  
  soundFile = new SoundFile(this, "anpu.wav");
  music.play(soundFile);
  
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

void mouseMoved() {
   
  if (story.mode() == "questions") {
    qa.enableButtons();
  }
}
