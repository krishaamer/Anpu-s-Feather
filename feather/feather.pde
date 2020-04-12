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
Parser parser = new Parser();
Narrative narrative = new Narrative();
Message message = new Message();
River nile = new River();
Deity anubis = new Deity();
Helper helper = new Helper();
Scales scales = new Scales();
User user = new User(parser.getPoints());
Output output = new Output(parser.getPoints());
Draw draw = new Draw();

void setup() {
  
  size(800, 800, P3D);
  frameRate(30);
  
  if (is_live) {
    
    // Live Source
    kinect = new KinectPV2(this);
    parser.liveInit(kinect);
    
  } else {
    
    // File Source
    parser.loadFile("wave1.txt"); // Default file to be loaded
  }
  
  draw.setUserMode(narrative.getMode()); // Set default mode on init
}

void draw() {

  parser.read_data();
  if (parser.isStreaming()) {
    
    draw.reset_time();
    draw.handleDrawing(user);
    
    if (is_live) {
      output.writeFile();
    }
  }
  
  //message.say("Welcome");
  //message.fadeInOut();
  
  if (narrative.getMode() == "heavy") {
    
    message.say("Welcome! \n You have reached the entrance");
    message.fadeInOut();
  
    nile.update();
    nile.fadeOut();
    
    anubis.update();
    anubis.fadeOut();
    
    scales.display();
  }
  
  if (narrative.getMode() == "light") {
    
    message.say("How heavy is your heart?");
    message.fadeInOut();
  }
  
  
  helper.update();
  narrative.update();
  
  // Update mode
  draw.setUserMode(narrative.getMode());
}

void keyReleased () {
    
  parser.enableKeys();
  output.enableKeys();
  helper.toggleBox();
  helper.toggleDummy(parser);
  narrative.toggleMode();
}
