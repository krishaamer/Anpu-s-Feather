/*
  
  Anpu's Feather.
  An interactive experience inviting you to think about your life before death.
  
  Created by Lei Lin and Kris Haamer at NCKU ICID Digital Design class.
  Tainan, Taiwan 
  April, 2020
*/

River nile = new River();
Deity anubis = new Deity();
Message alert = new Message();
Parser parser = new Parser();

void setup() {
  
  size(800, 800, P3D);
  strokeWeight(2);
  frameRate(27);
  
  parser.load_file("wave.txt");
}

void draw() {

  parser.read_data();
  alert.say("Welcome");
  //alert.say("You have reached the entrance");
  nile.update();
  anubis.update();
}
