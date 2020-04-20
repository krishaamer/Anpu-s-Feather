/*

  QA: Yes / No Questions for the User
  
*/

class QA {
  
  // Shared
  String answer;
  int strokeAlpha, fillAlpha;
  
  // Data
  ArrayList<PVector> skeleton_points;
  float skeletonRatio = 200.0 / 600.0;
  
  // No
  int NO_button_H = 250;
  int NO_button_W = 250;
  int NO_button_X;
  int NO_button_Y;
  boolean NO_button_inside = false;
  
  // Yes
  int YES_button_W = 250;
  int YES_button_H = 250;
  int YES_button_X;
  int YES_button_Y;
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
    
      // Translate Points - How to get this right???
      
      int capture_w = 640; // 1280; // 640;
      int capture_h = 480; // 1024; // 480;
      
      /*
      float left_x = map(skeleton_points.get(4).x, 0, capture_w, 0, width) / skeletonRatio / 1000;
      float left_y = map(skeleton_points.get(4).y, 0, capture_h, 0, height) / -skeletonRatio / 1000;
      
      float right_x = map(skeleton_points.get(7).x, 0, capture_w, 0, width) / skeletonRatio / 1000;
      float right_y = map(skeleton_points.get(7).y, 0, capture_h, 0, height) / -skeletonRatio / 1000;
      */
      
 
      float left_x = skeleton_points.get(4).x;
      float left_y = skeleton_points.get(4).y;
      float right_x = skeleton_points.get(7).x;
      float right_y = skeleton_points.get(7).y;
      
      left_x = skeleton_points.get(4).x + width / 2;
      left_y = skeleton_points.get(4).y + height / 2;
      
      right_x = skeleton_points.get(7).x + width / 2;
      right_y = skeleton_points.get(7).y + height / 2;
      
      /*
      float left_x = skeleton_points.get(4).x * 2.4;
      float left_y = skeleton_points.get(4).y * -0.6;
      float right_x = skeleton_points.get(7).x * 2.4;
      float right_y = skeleton_points.get(7).y * -0.6;
      */
            
      
      // Yes Button - Right Hand
      if (right_x > YES_button_X && right_x < YES_button_X + YES_button_W && right_y > YES_button_Y && right_y < YES_button_Y + YES_button_H) {
        //decide("YES");
        //println("Gesture Right Hand: YES", right_x, right_y);
        
        //println("Right hand YES INSIDE: ", YES_button_X, YES_button_X + YES_button_W, YES_button_Y, YES_button_Y + YES_button_H, right_x, right_y);
        
      } else {
        
        //println("Right hand YES OUTSIDE: ", YES_button_X, YES_button_X + YES_button_W, YES_button_Y, YES_button_Y + YES_button_H, right_x, right_y);
      }
      
      // No Button - Right Hand
      if (right_x > NO_button_X && right_x < NO_button_X + NO_button_W && right_y > NO_button_Y && right_y < NO_button_Y + NO_button_H) {
        //decide("NO");
        //println("Gesture Right Hand: NO", right_x, right_y);
        
        //NO_button_inside = false;
        
        //println("Right hand NO INSIDE: ", NO_button_X, NO_button_X + NO_button_W, NO_button_Y, NO_button_Y + NO_button_H, right_x, right_y);

      } else {
        
        //println("Right hand NO OUTSIDE: ", NO_button_X, NO_button_X + NO_button_W, NO_button_Y, NO_button_Y + NO_button_H, right_x, right_y);
      }
      
      // Yes Button - Left Hand
      if (left_x > YES_button_X && left_x < YES_button_X + YES_button_W && left_y > YES_button_Y && left_y < YES_button_Y + YES_button_H) {
        //decide("YES");
        println("Gesture Left Hand: YES", left_x, left_y);
      }
      
      // No Button - Left Hand
      if (left_x > NO_button_X && left_x < NO_button_X + NO_button_W && left_y > NO_button_Y && left_y < NO_button_Y + NO_button_H) {
        //decide("NO");
        println("Gesture Left Hand: NO", left_x, left_y);
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
