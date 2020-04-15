/*

  Narrative: Control the whole narrative sequence of the experience
  
*/

class Narrative {
  
  String mode;
  int init_time = -1;
  double seconds;
  
  Narrative () {
    
  }
  
  void update () {
    
    seconds = (millis() - init_time) / 1000.0;
  }
  
  void resetTime () {

    seconds = init_time;
  }

  double time () {

    return seconds;
  }
  
  String mode () {
    
    return mode;
  }
  
  void setMode(String m) {
    
    resetTime();
    mode = m;
  }
  
  /**
    Switch between modes for testing .
    To be replaced with user interaction
    and narrative cues.
  **/
  void toggleMode () {
    
    // What keycode?
    //println("keycode", keyCode);
    
    // 1
    if (keyCode == 49) {
      
      setMode("intro");
    }
      
    // 2
    if (keyCode == 50) {
      
      setMode("light");
    }
    
    // 3
    if (keyCode == 51) {
      
      setMode("heavy");
    }
  }
}
