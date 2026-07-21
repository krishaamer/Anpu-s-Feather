/*

  The River Character
  
  Reference (Jerome Herr), for the entire loop:
  https://www.openprocessing.org/sketch/150832
  
  By us:
  Changed to 3D, created separate characters, speed, colors
*/

class River {
  
  float gap, theta, theta2, speed;
  int cols, rows, strokeAlpha, fillAlpha;

  color[] colors = {
    #83A0FF, 
    #5173DF, 
    #194DF4, 
    #0A34BC,
  };
  
  River () {

    cols = 25;
    rows = 45;
    speed = .0223;
    strokeAlpha = 220;
    fillAlpha = 170;
  }

  void update() {
  
    gap = width / cols;

    pushMatrix();
    rotateX(PI / 2);
    rotateY(PI / 1);
    rotateZ(PI / 1);
    translate(0, -500, 780);
    
    float theta2 = PI / 6;
    for (int j = 0; j < rows; j++) {
      
      stroke(colors[j % colors.length], strokeAlpha);
      fill(colors[j % colors.length], fillAlpha);
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
  
  void fadeIn () {
    
    if (fillAlpha < 255) { 
      fillAlpha++; 
    }
    
    if (strokeAlpha < 255) { 
      strokeAlpha++; 
    }
  }
  
  void fadeOut () {
    
    if (fillAlpha > 0) { 
      fillAlpha--; 
    }
    
    if (strokeAlpha > 0) { 
      strokeAlpha--; 
    }
  }
}
