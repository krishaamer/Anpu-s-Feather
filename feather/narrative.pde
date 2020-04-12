/*

  Narrative: Control the whole narrative sequence of the experience
  
*/

class Narrative {
  
  String mode = "heavy";
  int init_time_in_millis = -1;
  
  Narrative () {
    
  }
  
  void update () {
    
  }
  
  // Return seconds
  double time () {
    
    return (millis() - init_time_in_millis) / 1000.0;
  }
  
  String mode () {
    
    return mode;
  }
  
  /**
    Switch between modes for testing .
    To be replaced with user interaction
    and narrative cues.
  **/
  void toggleMode () {
    
    // 1
    if (keyCode == 49) {
      
      mode = "heavy";
    }
      
    // 2
    if (keyCode == 50) {
      
      mode = "light";
    }
  }
 
}
