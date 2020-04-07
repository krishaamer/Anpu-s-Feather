/*

  The River Character
*/

float r_gap, r_theta, r_theta2;
int r_columns = 15;
int r_rows = r_columns;
color[] paletteRiver = {
  #83A0FF, #5173DF, #194DF4, #0A34BC
};

void makeRiver() {

  pushMatrix();
  rotateX(PI / 3.0);
  rotateY(PI / 19.0);
  rotateZ(PI / 18.0);
  translate(200, 200, -400);
  fill(#83A0FF);
  textSize(50);
  text("River Nile", 10, 30);
  float r_theta2 = PI / 6;
  for (int j = 0; j < r_rows; j++) {
    
    stroke(paletteRiver[j % paletteRiver.length], 220);
    fill(paletteRiver[j % paletteRiver.length], 170);
    r_theta2 += (TWO_PI / 36);
    
    float offSetY = map(sin(r_theta2), -1, 1, 0, TWO_PI);
    for (int i = 0; i < r_columns; i++) { 
      
      float offSetX = (TWO_PI / r_rows * i);
      float x = (.5 + i) * r_gap;
      float y = (.5 + j) * r_gap;

      float sz = map(sin(r_theta + offSetX + offSetY), -1, 1, 5, r_gap * 1.5);
      ellipse(x, y, sz, sz);
    }
    
  }
  r_theta -= .0523;
  popMatrix();
}
