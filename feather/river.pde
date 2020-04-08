/*

  The River Character
  
  Reference (Jerome Herr), for the entire loop:
  https://www.openprocessing.org/sketch/150832
  
  By us:
  Changed to 3D, created separate characters, speed, colors
*/

class River {
  
  float gap, theta, theta2;
  int cols = 15;
  int rows = 15;
  color[] colors = {
    #83A0FF, 
    #5173DF, 
    #194DF4, 
    #0A34BC,
  };
  
  River () {
    
  }

  void update() {
    
    gap = width / cols;
  
    pushMatrix();
    rotateX(PI / 3.0);
    rotateY(PI / 19.0);
    rotateZ(PI / 18.0);
    translate(200, 200, -400);
    fill(#83A0FF);
    textSize(50);
    text("River Nile", 10, 30);
    
    float theta2 = PI / 6;
    for (int j = 0; j < rows; j++) {
      
      stroke(colors[j % colors.length], 220);
      fill(colors[j % colors.length], 170);
      theta2 += (TWO_PI / 36);
      
      float offSetY = map(sin(theta2), -1, 1, 0, TWO_PI);
      for (int i = 0; i < cols; i++) { 
        
        float offSetX = (TWO_PI / rows * i);
        float x = (.5 + i) * gap;
        float y = (.5 + j) * gap;
  
        float sz = map(sin(theta + offSetX + offSetY), -1, 1, 5, gap * 1.5);
        ellipse(x, y, sz, sz);
      }
      
    }
    
    theta -= .0523;
    popMatrix();
  }
  
}
