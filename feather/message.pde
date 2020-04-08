/*

  The Textual Messages UI
  
  References:
  - https://forum.processing.org/two/discussion/12935/text-fade-in-out-with-millis
  - https://www.youtube.com/watch?v=4DnPb1iT2Hk
  -
*/

class Message {
  
  float timer = millis();
  float interval = 1000.0f;
  float alpha = 0;
  float speed = 10;
  
  Message () {
    
  }
  
  void fadeIn () {
    
    if (alpha < 255) {
      
      alpha++;
    }
  }
  
  void fadeOut () {
    
    if (alpha > 0) {
      
      alpha--;
    }
  }
  
  void fadeInOut () {
    
    if (millis() > interval + timer) {
      
      // Reset Timer
      timer = millis();
      speed *= -1;
    }
    
    alpha -= speed;
  }

  void say (String msg) {
    
    textSize(40);
    rectMode(CORNER);
    textAlign(CENTER);
    smooth(); 
 
    fill (255, 255, 255, alpha);
    text(msg, width / 2, height / 2); 
  }
}
