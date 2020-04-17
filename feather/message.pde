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
  
  boolean isFinished() {
    
    boolean f = finished;
    //finished = false;
    
    return f;
  }
  
  void resetFinished () {
    
    finished = false;
  }
  
  void resetRun () {
    
    hasRun = false;
  }
  
  void setAlpha (int a) {
    
    alpha = a;
  }
  
  void fadeIn (float speed) {
    
    if (alpha < 255) {  
        
        // Alpha is smaller than 255
        alpha += speed;
        //println ("fadeIn", alpha);
        
      } else {
        
        // Alpha is 255 or larger (reset to 255 if larger)
        if (alpha > 255) {
          alpha = 255;
        }
        
        // FadeIn Finished
        finished = true;

        // Run Once
        if (!hasRun) {
          hasRun = true;
        }
    }
  }
  
  void fadeOut (float speed) {
    
    if (alpha > 0) {
      
      alpha -= speed;
      //println ("fadeOut", alpha);
      
    } else {
      
      if (!hasRun) {
        
        alpha = 0;
        finished = true;
        hasRun = true;
      }
      
    }
  }
  
  void fadeInOut (int speed, int times) {
    
    /* 
      Current time (millis) is larger than 
      animation length (interval) + previous time (timer)
      so should reset time and animation In/Out direction
    */
    
    // int counter = 0;
    
    if (millis() > interval + timer) {
      
      // Reset
      timer = millis();
      
      // Switch In/Out
      speed *= -1;
    }
    
    // Fade output
    alpha -= speed;
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
  
  void addBackground() {
    
    x = width / 2;
    y = height / 2;
    
    noStroke();
    fill (0, 0, 0, alpha);
    rect (x, y, width, 80);
  }
}
