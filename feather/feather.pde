/*

  Reference (Jerome Herr), for the entire loop:
  https://www.openprocessing.org/sketch/150832
  
  By us:
  Changed to 3D, created separate characters, speed, colors
*/

// input_file contain the matrix and skeleton data.
String input_file = "wave.txt";

float diameter=10;
int num = 5;
float[] x = new float[num];
float[] y = new float[num];
float[] z = new float[num];
float[] x2 = new float[num];
float[] y2 = new float[num];
float[] z2 = new float[num];
float[]radians=new float[num];
float x1;
float y1;
float exponent=4;

// Show structures in draw_start_structure for the first start_time_position seconds and in draw_end_structure after end_time_position seconds.
double start_time_position = 8.5;
double end_time_position = 115;
int init_time_in_millis = -1;
float sphere_size = 0;

// 0: head, 1: neck, 2: left_shoulder, 3: left_elbow, 4: left_hand
// 5: right_shoulder, 6: right_elbow, 7: right_hand, 8: torso, 9: left_hip
// 10: left_knee, 11: left_foot, 12: right_hip, 13: right_knee, 14: right_foot
// 15: spine_mid, 16: spine_shoulder
ArrayList<PVector> skeleton_points = new ArrayList<PVector>();

void setup() {
  
  size(800, 800, P3D);
  strokeWeight(2);
  a_gap = width / a_columns;
  r_gap = width / r_columns;
  
  reader = createReader(input_file);
  frameRate(27);
}

void draw() {

  read_data();
  welcome();
  makeRiver();
  makeAnubis();
}
