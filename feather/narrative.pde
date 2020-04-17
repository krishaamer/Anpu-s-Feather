/*

  Narrative: Control the whole narrative sequence of the experience
  
*/

class Narrative {
  
  String mode;
 
  int startTime = millis();
  double sceneTime = -1;

  Narrative () {
    
  }
  
  void update () {
    
    sceneTime = (millis() - startTime) / 1000.0;
  }
  
  void resetTime () {

      sceneTime = -1;
      startTime = millis();
  }

  double time () {
    
    return sceneTime;
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
    
    // 4
    if (keyCode == 52) {
      
      setMode("scales");
    }
    
    // 5
    if (keyCode == 53) {
      
      resetTime();
    }
  }
}
