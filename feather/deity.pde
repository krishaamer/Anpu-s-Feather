/*

  The Deity (Anubis) Character
*/

class Deity {

  float gap, theta, theta2;
  int cols = 15;
  int rows = 15; 
  color[] colors = {
    #000000, 
    #333333, 
    #555555, 
    #444444,
  };
  
  Deity () {
    
  }
  
  void update() {
    
    gap = width / cols;
  
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
    float theta2 = PI / 12;
    
    for (int j = 0; j < rows; j++) {
      
      stroke(colors[j % colors.length], 220);
      fill(colors[j % colors.length], 170);
      
      theta2 += (TWO_PI / 6);
      
      float offSetY = map(sin(theta2), -1, 1, 0, TWO_PI);
      
      for (int i = 0; i < cols; i++) { 
        
        float offSetX = (TWO_PI / rows * i);
        float x = (.5 + i) * gap;
        float y = (.5 + j) * gap;
  
        float sz = map(sin(theta + offSetX + offSetY), -1, 1, 5, gap * 1.5);
        ellipse(x, y, sz, sz);
      }
      
    }
    theta -= .05;
    popMatrix();
  }
  
}
