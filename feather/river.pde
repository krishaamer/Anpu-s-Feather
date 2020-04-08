/*

  The River Character
  
  Reference (Jerome Herr), for the entire loop:
  https://www.openprocessing.org/sketch/150832
  
  By us:
  Changed to 3D, created separate characters, speed, colors
*/

class River {
  
  float gap, theta, theta2;
  int cols, rows;
  
  float speed = .0223;
  
  color[] colors = {
    #83A0FF, 
    #5173DF, 
    #194DF4, 
    #0A34BC,
  };
  
  River () {
    
    cols = 25;
    rows = 35;
  }

  void update() {
    
    gap = width / cols;
  
    pushMatrix();
    rotateX(PI / 2);
    rotateY(PI / 1);
    rotateZ(PI / 1);
    translate(0, -500, 800);
    
    
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
    
    theta -= speed;
    popMatrix();
  }
  
}
