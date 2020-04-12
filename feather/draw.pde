/*

  Draw
  Draw on the screen
  
*/

class Draw {
  
  int init_time_in_millis = -1;
  double start_time_position = 8; // Show structures in draw_start_structure for the first start_time_position seconds
  double end_time_position = 12; // Show structures in draw_end_structure after end_time_position seconds
  
  Draw () {
    
  }
  
  void handleDrawing (User user) {
    
    double second = (millis() - init_time_in_millis) / 1000.0;
    
    //println(second);
    
    // Sequence
    if (second < start_time_position) {
     
     //println("sequence start");
     user.draw_start_structure();
      
    } else if (second >= start_time_position && second < end_time_position) {
      
      //println("sequence middle");
      user.draw_structure();
      
    } else if (second > end_time_position) {
      
      //println("sequence end");
      user.draw_end_structure();
    }
    
    showFrameRate();
  }
  
  void showFrameRate () {
    
    fill(255, 0, 0);
    textSize(20);
    text(frameRate, 60, 60);
  }
}
