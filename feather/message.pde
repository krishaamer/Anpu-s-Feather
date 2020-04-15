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
  boolean hasRun = false;
  float alpha = 0;
  float speed = 5;
  int x, y;
  boolean finished;
  
  Message () {
    
  }
  
  void fadeIn () {
    
    if (alpha < 255) {  
      alpha++;
    } else {
      if (!hasRun) {
        finished = true;
        hasRun = true;
      }
    }
  }
  
  boolean isFinished() {
    return finished;
  }
  
  void reset () {
    finished = false;
  }
  
  void fadeOut () {
    
    if (alpha > 0) {
      
      alpha--;
    }
  }
  
  void fadeInOut () {
    
    /* 
      Current time (millis) is larger than 
      animation length (interval) + previous time (timer)
      so should reset time and animation In/Out direction
    */
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
