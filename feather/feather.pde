/*
  
  Anpu's Feather.
  An interactive experience inviting you to think about your life before death.
  
  Created by Lei Lin and Kris Haamer at NCKU ICID Digital Design class.
  Tainan, Taiwan 
  April, 2020
*/

Parser parser = new Parser();
Message message = new Message();
River nile = new River();
Deity anubis = new Deity();
//UI ui = new UI();

void setup() {
  
  size(800, 800, P3D);
  frameRate(30);
  strokeWeight(2);
  
  parser.load_file("wave.txt");
}

void draw() {
 
  parser.read_data();
  
  message.say("Welcome");
  message.fadeInOut();
  
  /*
  message.fadeOut();
  message.say("You have reached the entrance");
  message.fadeIn();
  */
  
  nile.update();
  nile.fadeOut();
  
  anubis.update();
  anubis.fadeOut();
  
  /*
  // Draw box for reference
  pushMatrix();
  resetMatrix();
  translate(0, 0, -600);
  ui.draw_box();
  popMatrix();
  */
}
