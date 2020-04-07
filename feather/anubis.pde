/*

  The Anubis Character
*/

float a_gap, a_theta, a_theta2;
int a_columns = 15;
int a_rows = a_columns;
color[] paletteAnubis = {
  #000000, #333333, #555555, #444444
};

void makeAnubis() {

  pushMatrix();
  rotateX(PI / 12.0);
  rotateY(PI / 49.0);
  rotateZ(PI / 48.0);
  translate(100, -800, -1500);
  fill(#444444);
  textSize(50);
  text("Anubis", 10, 30);
  fill(#ffffff);
  ellipse(500, 300, 55, 55);
  ellipse(300, 300, 55, 55);
  ellipse(400, 700, 200, 100);
  float a_theta2 = PI / 12;
  
  for (int j = 0; j < a_rows; j++) {
    
    stroke(paletteAnubis[j % paletteAnubis.length], 220);
    fill(paletteAnubis[j % paletteAnubis.length], 170);
    
    a_theta2 += (TWO_PI / 6);
    
    float offSetY = map(sin(a_theta2), -1, 1, 0, TWO_PI);
    
    for (int i = 0; i < a_columns; i++) { 
      
      float offSetX = (TWO_PI / a_rows * i);
      float x = (.5 + i) * a_gap;
      float y = (.5 + j) * a_gap;

      float sz = map(sin(a_theta + offSetX + offSetY), -1, 1, 5, a_gap * 1.5);
      ellipse(x, y, sz, sz);
    }
    
  }
  a_theta -= .05;
  popMatrix();
}
