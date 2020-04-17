/*

  The Textual Messages UI
  
  References:
  - https://forum.processing.org/two/discussion/12935/text-fade-in-out-with-millis
  - https://www.youtube.com/watch?v=4DnPb1iT2Hk
  -
*/

class Message {
  
  /* Shared */
  boolean hasRun = false;
  boolean finished = false;
  float alpha = 0;
  
  /* In-Out */
  float timer = millis();
  float interval = 1000.0f;
  
  /* In and Out */
  int x, y;
  
  Message () {
    
  }
  
  void setAlpha (int a) {
    
    alpha = a;
  }
  
  void fadeIn (float speed) {
    
    if (alpha < 255) {  
        
        // Alpha is smaller than 255
        alpha += speed;
        
      } else {
        
        // Reset to 255 if larger
        if (alpha > 255) {
          alpha = 255;
        }
    }
  }
  
  void fadeOut (float speed) {
    
    if (alpha > 0) {
      
      // Alpha is bigger than 0
      alpha -= speed;
      
    } else {
      
      // Reset to 0 if smaller
      if (alpha < 0) {
        alpha = 0;
      }
    }
  }

  void say (String msg) {
    
    x = width / 2;
    y = height / 2;
    
    textSize(40);
    rectMode(CENTER);
    textAlign(CENTER);
    fill (255, 255, 255, alpha);
    text(msg, x, y); 
  }
  
  void subtitle (String msg) {
    
    x = width / 2;
    y = height / 2 + 40;
    
    textSize(20);
    rectMode(CENTER);
    textAlign(CENTER);
    fill (255, 255, 255, alpha);
    text(msg, x, y); 
  }
  
}
