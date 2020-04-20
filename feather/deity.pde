/*

  The Deity (Anubis) Character
  
  Reference (Jerome Herr), for the entire loop:
  https://www.openprocessing.org/sketch/150832
  
  By us:
  Changed to 3D, created separate characters, speed, colors
*/

class Deity {

  float gap, theta, theta2, alpha, speed;
  int cols, rows, strokeAlpha, fillAlpha, featureStrokeAlpha, featureFillAlpha;;
  String feature;

  color[] colors = {
    #000000, 
    #333333, 
    #555555, 
    #444444,
  };
  
  Deity () {
    
    cols = 15;
    rows = 25;
    alpha = 0;
    speed = .05;
    strokeAlpha = 0;
    fillAlpha = 0;
    featureStrokeAlpha = 0;
    featureFillAlpha = 0;
  }
  
  void option (String f) {
    
    feature = f;
  }
  
  void update() {
    
    gap = width / cols;
    theta2 = PI / 12;
  
    pushMatrix();
    rotateX(PI / 12.0);
    rotateY(PI / 49.0);
    rotateZ(PI / 48.0);
    translate(100, -800, -1500);
    
    mouthAndEyes(false); 
    
    if (feature == "redEyes") {
      mouthAndEyes(true); 
    }
    
    for (int j = 0; j < rows; j++) {
      
      stroke(colors[j % colors.length], strokeAlpha);
      fill(colors[j % colors.length], fillAlpha);
      
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
    
    theta -= speed;
    popMatrix();
  }
  
  void mouthAndEyes (boolean redEyes) {
    
    stroke (255, 255, 255, strokeAlpha);
    fill (255, 255, 255, fillAlpha);
    
    if (redEyes) {
      
      stroke (255, 0, 0, featureStrokeAlpha);
      fill (255, 0, 0, featureFillAlpha);
    }
    
    // Eyes
    ellipse(500, 300, 55, 55);
    ellipse(300, 300, 55, 55);
    
    // Mouth
    fill (255, 255, 255, fillAlpha);
    ellipse(400, 700, 200, 100);
  }
  
  void nameTag () {
    
    fill(#444444);
    textSize(50);
    text("Anubis", 10, 30);
    fill(#ffffff);
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
  
  void featureFadeIn () {
    
    if (featureFillAlpha < 255) { 
      featureFillAlpha++; 
    }
    
    if (featureStrokeAlpha < 255) { 
      featureStrokeAlpha++; 
    }
  }
  
  void featureFadeOut () {
    
    if (featureFillAlpha > 0) { 
      featureFillAlpha--; 
    }
    
    if (featureStrokeAlpha > 0) { 
      featureStrokeAlpha--; 
    }
  }
}
