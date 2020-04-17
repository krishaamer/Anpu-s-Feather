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
import KinectPV2.KJoint;
import KinectPV2.*;
KinectPV2 kinect;
boolean is_live = false;

// Init
Helper helper = new Helper();
Parser parser = new Parser(helper);
Narrative story = new Narrative();
Message message = new Message();
River nile = new River();
Deity anubis = new Deity();
User user = new User(parser.getPoints(), helper);
Scales scales = new Scales(parser.getPoints(), helper);
Output output = new Output(parser.getPoints());
QA qa = new QA();

void setup() {
  
  size(800, 800, P3D);
  frameRate(25);
  smooth(8);
  
  if (is_live) {
    
    // Live Source
    kinect = new KinectPV2(this);
    parser.liveInit(kinect);
    
  } else {
    
    // File Source
    parser.loadFile("wave1.txt"); // Default file to be loaded
  }
  
  story.setMode("intro"); // Set default story mode on init
  user.setUserMode(story.mode()); // Set default mode on init
}

void draw() {
  
  // Shared
  helper.update();
  story.update();
  user.setUserMode(story.mode()); // Update mode
  println(story.time());
  
  // What's the mode?
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
}

void intro () {

    background(0);
    if (story.time() > 0 && story.time() < 1.9) {
      
      message.say("Welcome!");
      message.fadeIn(10);
      
      nile.update();
    }
    
    if (story.time() > 1.9 && story.time() < 2.9) {
      
      message.say("Welcome!");
      message.fadeOut(10);
      
      nile.update();
    }
    
    if (story.time() > 2.9 && story.time() < 3) {
      
      message.setAlpha(0);
      nile.update();
    }
    
    if (story.time() > 3 && story.time() < 7) {
      
      message.say("I have been waiting for You");
      message.fadeIn(8);
      
      nile.update();
      nile.fadeOut();
      
      anubis.update();
      anubis.fadeIn();
    }
    
    if (story.time() > 7 && story.time() < 8.9) {
      
      message.say("I have been waiting for You");
      message.fadeOut(10);
      
      nile.update();
      nile.fadeOut();
      
      anubis.update();
      anubis.fadeIn();
    }
    
    if (story.time() > 8.9 && story.time() < 9) {

      nile.update();
      nile.fadeOut();
      
      anubis.update();
      anubis.fadeOut();
      
      message.setAlpha(0);
    }
    
    if (story.time() > 9 && story.time() < 13) {
      
      nile.update();
      nile.fadeOut();
      
      anubis.update();
      anubis.fadeOut();

      message.say("How heavy is your heart?");
      message.fadeIn(8);
      
      parser.read_data();
      if (parser.isStreaming()) {
        scales.update();
        scales.fadeIn();
      }
    }
    
    if (story.time() > 13 && story.time() < 15) {
      
      message.say("How heavy is your heart?");
      message.fadeOut(8);
      
      parser.read_data();
      if (parser.isStreaming()) {
        scales.update();
        scales.fadeOut();
      }
    }
    
    if (story.time() > 15) {
      
      message.setAlpha(0);
      story.setMode("questions");
      story.resetTime();
    }
}

void questions () {
  
  background(0);
  
  if (story.time() > 0 && story.time() < 0.1) {
    
    qa.answerReset();
    message.setAlpha(0);
  }
  
  if (story.time() > 0.1 && story.time() < 3) {
      
    message.say("Have you cried this week?");
    message.fadeIn(8);
  }
  
  if (story.time() > 3) {
    
    message.say("Have you cried this week?");
    message.fadeOut(8);
      
    qa.ask();
    qa.fadeIn();
    
    if (qa.answer() == "YES") {
      
      message.setAlpha(0);
      story.resetTime();
      story.setMode("light");
      
    }
    
    if (qa.answer() == "NO") {
      
      message.setAlpha(0);
      story.resetTime();
      story.setMode("heavy");
    }
  }
}

void scales () {
  
  user.resetBG();
  parser.read_data();
  if (parser.isStreaming()) {
    scales.update();
    scales.fadeIn();
  }
}

void light () {
  
  if (story.time() > 0 && story.time() < 0.1) {
    
     background(0);
     message.setAlpha(0);
  }
  
  if (story.time() > 0.1 && story.time() < 2.9) {
     
    message.say("Your heart seems light");
    message.fadeIn(5);
  }
  
  if (story.time() > 2.9 && story.time() < 4) {
     
    message.say("Your heart seems light");
    message.fadeOut(8);
  }
  
  if (story.time() > 4) {
    
    blendMode(ADD);
    parser.read_data();
    if (parser.isStreaming()) {
      user.update();
    }
  }
}

void heavy () {
  
  if (story.time() > 0 && story.time() < 0.1) {
    
     background(0);
     message.setAlpha(0);
  }
  
  if (story.time() > 0.1 && story.time() < 1.5) {
   
    background(0);
    message.say("Your heart must be heavy");
    message.fadeIn(10);
  }
  
  if (story.time() > 1.5 && story.time() < 3) {
    
    background(0);
    message.say("Your heart must be heavy");
    message.fadeOut(8);
  }
  
  if (story.time() > 3 && story.time() < 8) {
   
    parser.read_data();
    if (parser.isStreaming()) {
      user.update();
      user.fadeIn();
    }
  }
  
  if (story.time() > 8) {
   
      message.setAlpha(0);
      story.resetTime();
      story.setMode("scales");
  }
  
  // Messages on top of the Model
  if (story.time() > 3 && story.time() < 3.1) {
    
     message.setAlpha(0);
  }
  
  if (story.time() > 3.1 && story.time() < 5) {
    
    message.say("Show me");
    message.fadeIn(8);
  }
  
  if (story.time() > 5 && story.time() < 6) {
    
    message.say("Show me");
    message.fadeOut(8);
  }
  
}

void keyReleased () {
  
  parser.enableKeys();
  helper.toggleBox();
  helper.toggleDummy(parser);
  story.toggleMode();
  output.enableKeys();
}

void mousePressed() {
  
  qa.enableButtons();
}
