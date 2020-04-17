/*

  Narrative: Control the whole narrative sequence of the experience
  
*/

class Narrative {
  
  String mode;
 
  int startTime = millis();
  double sceneTime = 0;

  Narrative () {
    
  }
  
  void resetTimeOnce () {
    
  }
  
  void update () {
    
    sceneTime = (millis() - startTime) / 1000.0;
  }
  
  void resetTime () {

      sceneTime = 0;
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
      
      resetTime();
      setMode("intro");
    }
      
    // 2
    if (keyCode == 50) {
      
      resetTime();
      setMode("questions");
    }
    
    // 3
    if (keyCode == 51) {
      
      resetTime();
      setMode("scales");
    }
    
    // 4
    if (keyCode == 52) {
      
      resetTime();
      setMode("heavy");
    }
    
    // 5
    if (keyCode == 53) {
      
      resetTime();
      setMode("light");
    }
    
    // R
    if (key == 'r' || key == 'R') {
      
      resetTime();
    }
  }
}
