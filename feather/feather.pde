/*

  Reference (Jerome Herr), for the entire loop:
  https://www.openprocessing.org/sketch/150832
  
  By us:
  Changed to 3D, created separate characters, speed, colors
*/

// input_file contain the matrix and skeleton data.
String input_file = "wave.txt";
BufferedReader reader;

River nile = new River();
Deity anubis = new Deity();
Message alert = new Message();
Parser parser = new Parser();

// 0: head, 1: neck, 2: left_shoulder, 3: left_elbow, 4: left_hand
// 5: right_shoulder, 6: right_elbow, 7: right_hand, 8: torso, 9: left_hip
// 10: left_knee, 11: left_foot, 12: right_hip, 13: right_knee, 14: right_foot
// 15: spine_mid, 16: spine_shoulder
ArrayList<PVector> skeleton_points = new ArrayList<PVector>();

void setup() {
  
  size(800, 800, P3D);
  strokeWeight(2);
 
  reader = createReader(input_file);
  frameRate(27);
}

void draw() {

  parser.read_data(reader);
  alert.say("Welcome");
  //alert.say("You have reached the entrance");
  nile.update();
  anubis.update();
}
