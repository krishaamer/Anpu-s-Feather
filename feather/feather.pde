/*****
  
  Anpu's Feather.
  An interactive experience inviting you to think about your life before death.

  Created by Lei Lin and Kris Haamer at NCKU ICID Digital Design class.
  Tainan, Taiwan 
  April, 2020
  
  --------------
  
  HOW TO USE? ** FOR TESTING **:
  Keyboard shortcuts will be replaced by user interaction
  -- Use keys 1 and 2 to switch between "Heavy Heart" and "Light Heart" modes
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
Scales scales = new Scales();
User user = new User(parser.getPoints(), scales);
Output output = new Output(parser.getPoints());
Draw draw = new Draw();
QA qa = new QA();
float t=0;
float v=3;
float xn1=0;
float xn2=0;
float yn1=0;
float yn2=0;
float feathery=-300;
float easingy = 0.01; 
void setup() {
  
  size(1000, 1000, P3D);
  frameRate(24);
  
  if (is_live) {
    
    // Live Source
    kinect = new KinectPV2(this);
    parser.liveInit(kinect);
    
  } else {
    
    // File Source
    parser.loadFile("wave1.txt"); // Default file to be loaded
  }
  
  user.setUserMode(story.mode()); // Set default mode on init
}

void draw() {
    
  if (story.mode() == "heavy") {
   
    if (story.time() > 0 && story.time() < 3.7) {
      
      background(0);
      message.say("Welcome!");
      message.fadeInOut();
      nile.update();
    }
    
    if (story.time() > 3.7 && story.time() < 8) {
      
      background(0);
      message.say("You have reached the entrance");
      message.fadeInOut();
      nile.update();
    }
    
    if (story.time() > 8 && story.time() < 18) {
      
      background(0);
      message.say("I have been waiting for You");
      message.fadeInOut();
      nile.update();
      nile.fadeOut();
      anubis.update();
      anubis.fadeIn();
    }
    
    if (story.time() > 18 && story.time() < 23) {
      
      background(0);
      anubis.update();
      anubis.fadeOut();
      
    }
    
    if (story.time() > 23 && story.time() < 30) {
      
      message.fadeInOut();
      message.say("How have you lived your life?");
    }
    
    if (story.time() > 30 && story.time() < 39) {
      
      background(0);
      message.fadeIn();
      message.say("The feather is a measure of your heart");
      scales.update();
      scales.fadeIn();
    }
    
    if (story.time() > 39) {
      
      parser.read_data();
      if (parser.isStreaming()) {
        draw.handleDrawing(user);
        // if (is_live) { output.writeFile(); }
      }
      
      nile.update();
      nile.fadeIn();
      
      anubis.update();
      anubis.fadeIn();
    }
    
  }
  
  if (story.mode() == "light") {
    
    message.say("How heavy is your heart?");
    message.fadeInOut();
    
    parser.read_data();
    if (parser.isStreaming()) {
      
      draw.handleDrawing(user);
      
      /*
      if (is_live) {
        output.writeFile();
      }
      */
    }
  }
  
  helper.update();
  story.update();
  
  // Update mode
  user.setUserMode(story.mode());
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
