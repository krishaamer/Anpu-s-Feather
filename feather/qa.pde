/*

  QA: Yes / No Questions for the User
  
*/

class QA {
  
  // Shared
  String answer;
  int strokeAlpha, fillAlpha;
  
  // Data
  ArrayList<PVector> skeleton_points;
  
  // No
  int NO_button_H = 350;
  int NO_button_W = 350;
  int NO_button_X;
  int NO_button_Y;
  int NO_button_Z_MIN = -900;
  int NO_button_Z_MAX = 5900;
  boolean NO_button_inside = false;
  
  // Yes
  int YES_button_W = 350;
  int YES_button_H = 350;
  int YES_button_X;
  int YES_button_Y;
  int YES_button_Z_MIN = -900;
  int YES_button_Z_MAX = 900;
  boolean YES_button_inside = false;
  
  QA (ArrayList<PVector> sp) {
    
    skeleton_points = sp;
    strokeAlpha = 0;
    fillAlpha = 0;
  }
  
  String answer () {
    
    return answer;
  }
  
  void answerReset () {
    
    answer = "";
  }
  
  void ask () {
    
    createNoButton();
    createYesButton();
  }
  
  void createNoButton () {

    // Position
    NO_button_X = 20;
    NO_button_Y = 20;
    
    // Button
    noStroke();
    
    rectMode(CORNER);
    fill(255, 0, 0, fillAlpha);
    rect(NO_button_X, NO_button_Y, NO_button_W, NO_button_H);
    
    fill(255, 255, 255, fillAlpha);
    textSize(60);
    text("NO", NO_button_X + NO_button_W / 2, NO_button_Y + NO_button_H / 2);
  }
  
  void createYesButton () {
    
    // Need to set button X pos here to have correct screen width value
    YES_button_X = width - YES_button_W - 20;
    YES_button_Y = 20;
   
    // Button
    noStroke();
    
    rectMode(CORNER);
    fill(0, 0, 255, fillAlpha);
    rect(YES_button_X, YES_button_Y, YES_button_W, YES_button_H);
    
    fill(255, 255, 255, fillAlpha);
    textSize(60);
    text("YES", YES_button_X + YES_button_W / 2, YES_button_Y + YES_button_H / 2);
  }
  
  void decide (String d) {
    
    if (d == "YES") {
     
      YES_button_inside = true;
      answer = "YES";
    }
    
    if (d == "NO") {
      
      NO_button_inside = true;
      answer = "NO";
    }
  }
  
  void enableButtons () {
   
      // Yes Button
      if (mouseX > YES_button_X && mouseX < YES_button_X + YES_button_W && mouseY > YES_button_Y && mouseY < YES_button_Y + YES_button_H) {
        decide("YES");
        println("Mouse: YES");
      }
      
      // No Button
      if (mouseX > NO_button_X && mouseX < NO_button_X + NO_button_W && mouseY > NO_button_Y && mouseY < NO_button_Y + NO_button_H) {
        decide("NO");
        println("Mouse: NO");
      }
  }
  
  void enableGestures () {
    
      float left_x = skeleton_points.get(4).x + width / 2;
      float left_y = skeleton_points.get(4).y + height / 2;
      float left_z = skeleton_points.get(4).z;
      
      float right_x = skeleton_points.get(7).x + width / 2;
      float right_y = skeleton_points.get(7).y + height / 2;
      float right_z = skeleton_points.get(7).z;
      
      // Yes Button - Right Hand
      if (
          right_x > YES_button_X && 
          right_x < YES_button_X + YES_button_W && 
          right_y > YES_button_Y && 
          right_y < YES_button_Y + YES_button_H &&
          right_z > YES_button_Z_MIN &&
          right_z < YES_button_Z_MAX
      ) {
        decide("YES");
      } 
      
      // No Button - Right Hand
      if (
        right_x > NO_button_X && 
        right_x < NO_button_X + NO_button_W && 
        right_y > NO_button_Y && 
        right_y < NO_button_Y + NO_button_H &&
        right_z > NO_button_Z_MIN &&
        right_z < NO_button_Z_MAX
      ) {
        decide("NO");
      }
      
      // Yes Button - Left Hand
      if (
        left_x > YES_button_X && 
        left_x < YES_button_X + YES_button_W && 
        left_y > YES_button_Y && 
        left_y < YES_button_Y + YES_button_H &&
        left_z > YES_button_Z_MIN &&
        left_z < YES_button_Z_MAX
      ) {
        decide("YES");
      }
      
      // No Button - Left Hand
      if (
        left_x > NO_button_X && 
        left_x < NO_button_X + NO_button_W && 
        left_y > NO_button_Y && 
        left_y < NO_button_Y + NO_button_H &&
        left_z > NO_button_Z_MIN &&
        left_z < NO_button_Z_MAX
      ) {
        decide("NO");
      }
  }
  
  void fadeIn () {
    
    if (fillAlpha < 255) { 
      fillAlpha++; 
    }
    
    if (strokeAlpha < 255) { 
      strokeAlpha++; 
    }
  }
  
  void fadeOut () {
    
    if (fillAlpha > 0) { 
      fillAlpha--; 
    }
    
    if (strokeAlpha > 0) { 
      strokeAlpha--; 
    }
  }
  
}
