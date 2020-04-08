/*

  Reference (Jerome Herr), for the entire loop:
  https://www.openprocessing.org/sketch/150832
  
  By us:
  Changed to 3D, created separate characters, speed, colors
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
