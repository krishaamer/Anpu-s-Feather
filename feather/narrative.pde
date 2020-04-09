/*

  Narrative: Control the whole narrative sequence of the experience
*/

class Narrative {
  
  String mode = "light";
  
  Narrative () {
    
  }
  
  void update () {
    
  }
  
  String getMode () {
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
