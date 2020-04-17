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
  frameRate(24);
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
  
  // What the mode?
  //println(story.mode(), story.time());
  
  if (story.mode() == "scales") {
    scales ();
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

  // Should reset time one, right?
  //story.resetTime();
  
  background(0);
  println(story.time());
  
  if (story.time() > 0 && story.time() < 4) {
      
      message.say("Welcome!");
      message.fadeIn(9);
      
      nile.update();
    }
    
    if (story.time() > 4 && story.time() < 5) {
      
      message.setAlpha(0);
      nile.update();
    }
    
    if (story.time() > 5 && story.time() < 8) {
      
      message.say("You have found me");
      message.fadeIn(10);
 
      nile.update();
    }
    
    if (story.time() > 8 && story.time() < 9) {
  
      message.setAlpha(0);
      nile.update();
    }
    
    if (story.time() > 9 && story.time() < 18) {
      
      message.say("I have been waiting for You");
      message.fadeIn(8);
      
      nile.update();
      nile.fadeOut();
      
      anubis.update();
      anubis.fadeIn();
    }
    
    if (story.time() > 18 && story.time() < 23) {
      
      message.setAlpha(0);
      anubis.update();
      anubis.fadeOut();
    }
    
    if (story.time() > 23 && story.time() < 29) {
      
      message.say("How have you lived your life?");
      message.fadeIn(8);
    }
    
    if (story.time() > 29 && story.time() < 30) {
      
      message.setAlpha(0);
    }
    
    if (story.time() > 30 && story.time() < 39) {
      
      message.fadeIn(8);
      message.say("The feather is a measure of your heart");
      
      parser.read_data();
      if (parser.isStreaming()) {
        scales.update();
        scales.fadeIn();
      }
    }
    
    if (story.time() > 39 && story.time() < 40) {
      
      message.setAlpha(0);
      
      parser.read_data();
      if (parser.isStreaming()) {
        scales.update();
        scales.fadeIn();
      }
    }
    
    if (story.time() > 40) {
      
      parser.read_data();
      if (parser.isStreaming()) {
        
        user.update();
        scales.update();
        // if (is_live) { output.writeFile(); }
      }
      
      nile.update();
      nile.fadeIn();
      
      anubis.update();
      anubis.fadeIn();
   }
}

void scales () {
  
  if (story.time() > 0) {
    
    background(0);
   
    parser.read_data();
    if (parser.isStreaming()) {
      
      user.update();
      scales.update();
      scales.fadeIn();
      
      message.addBackground();
      message.fadeIn(10);
      message.say("The feather is a measure of your heart");  
      
      if (message.isFinished()) {
        
        println("message 1 finished");
        
        //message.reset();
        //message.fadeOut(10);
        
        message.addBackground();
        message.fadeIn(10);
        message.say("Move your body");  
        
      }
    }
  }
}

void light () {
  
  if (story.time() > 0 && story.time() < 1000) {
    
    parser.read_data();
    if (parser.isStreaming()) {
      
      user.update();
      
      blendMode(BLEND);
      message.addBackground();
      message.fadeIn(1);  
      message.say("How heavy is your heart?");
      
    }
    
  }
}

void heavy () {
  
  if (story.time() > 0 && story.time() < 1000) {
 
    background(0);
    blendMode(BLEND);
    message.addBackground();
    message.fadeIn(1);
    message.say("Have you cried this week?");
    
    qa.ask();
    
    if (qa.answer() == "YES") {
      story.setMode("light");
    }
    
    if (qa.answer() == "NO") {
      story.setMode("heavy");
    }
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
