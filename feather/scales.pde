/*

  Scales: Calculate the weight of the heart
  
*/

class Scales {
  
  PImage img;
  int tintAlpha;
  
  Scales () {

  }
  
  void moveUp () {
    
  }
  
  void moveDown () {

  }
  
  void calculate_heaviness () {
    
    
  }
  
  void update() {
    
    pushMatrix();
    translate(mouseX, mouseY, -200);
    tint(255, 255, 255, tintAlpha);
    img = loadImage("feather_small.png");
    image(img, 0, 0);
    popMatrix();
  }
  
  void fadeIn () {
    
    if (tintAlpha < 255) { 
      tintAlpha++; 
    }
  }
  
  void fadeOut () {
    
    if (tintAlpha > 0) { 
      tintAlpha--; 
    }
  }
}
