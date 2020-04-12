/*

  Draw
  Draw on the screen
  
*/

class Draw {
  
  int init_time_in_millis = -1;
  double start_time_position = 8.5; // Show structures in draw_start_structure for the first start_time_position seconds
  double end_time_position = 20; // Show structures in draw_end_structure after end_time_position seconds
  
  Draw () {
    
  }
  
  void reset_time () {
    
    // Initial timer for model drawing
    if (init_time_in_millis == -1) {
      init_time_in_millis = millis();
    }
  }
  
  void handleDrawing (User user, String mode) {
    
    double second = (millis() - init_time_in_millis) / 1000.0;
    
    // Sequence
    if (second < start_time_position) {
     
     user.draw_start_structure(mode);
      
    } else if (second >= start_time_position && second < end_time_position) {
      
      user.draw_structure(mode);
      
    } else if (second > end_time_position) {
      
      user.draw_end_structure(mode);
    }
    
    //showFrameRate();
  }
  
  void showFrameRate () {
    
    fill(255, 0, 0);
    textSize(20);
    text(frameRate, 60, 60);
  }
}
