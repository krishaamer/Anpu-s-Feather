/*

  Draw
  Draw on the screen
  
*/

class Draw {
  
  int init_time_in_millis = -1;
  double start_time_position = 8; // Show structures in draw_start_structure for the first start_time_position seconds
  double end_time_position = 12; // Show structures in draw_end_structure after end_time_position seconds
  String userMode;
  
  Draw () {
    
  }
  
  void setUserMode (String mode) {
    
    userMode = mode;
  }
  
  void reset_time () {
    
    // Initial timer for model drawing
    if (init_time_in_millis == -1) {
      init_time_in_millis = millis();
    }
  }
  
  void handleDrawing (User user) {
    
    double second = (millis() - init_time_in_millis) / 1000.0;
    
    // Sequence
    if (second < start_time_position) {
     
     //println("sequence start");
     user.draw_start_structure(userMode);
      
    } else if (second >= start_time_position && second < end_time_position) {
      
      //println("sequence middle");
      user.draw_structure(userMode);
      
    } else if (second > end_time_position) {
      
      //println("sequence end");
      user.draw_end_structure(userMode);
    }
    
    //showFrameRate();
  }
  
  void showFrameRate () {
    
    fill(255, 0, 0);
    textSize(20);
    text(frameRate, 60, 60);
  }
}
