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
  int NO_button_H = 200;
  int NO_button_W = 200;
  int NO_button_X;
  int NO_button_Y;
  boolean NO_button_inside = false;
  
  // Yes
  int YES_button_W = 200;
  int YES_button_H = 200;
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
    textSize(30);
    text("NO", NO_button_X + 50, NO_button_Y + 40);
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
    textSize(30);
    text("YES", YES_button_X + 50, YES_button_Y + 40);
  }
  
  void enableButtons () {
   
      // Yes Button
      if (mouseX > YES_button_X && mouseX < YES_button_X + YES_button_W && mouseY > YES_button_Y && mouseY < YES_button_Y + YES_button_H) {
        
        YES_button_inside = true;
        
        // Update answer
        answer = "YES";
        println("Mouse: YES");
      }
      
      // No Button
      if (mouseX > NO_button_X && mouseX < NO_button_X + NO_button_W && mouseY > NO_button_Y && mouseY < NO_button_Y + NO_button_H) {
        
        NO_button_inside = true;
        
        // Update answer
        answer = "NO";
        println("Mouse: NO");
      }
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
    
    println("Gesture: ", d);
  }
  
  void enableGestures () {
    
      // Translate Points - How to get this right???
      float left_hand_x = skeleton_points.get(4).x * 2.4;
      float left_hand_y = skeleton_points.get(4).y * -0.6;
      float right_hand_x = skeleton_points.get(7).x * 2.4;
      float right_hand_y = skeleton_points.get(7).y * -0.6;
    
      println("Right hand: ", YES_button_X, YES_button_X + YES_button_W, right_hand_x, YES_button_Y, YES_button_Y + YES_button_H, right_hand_y);
      
      // Yes Button - Right Hand
      if (right_hand_x > YES_button_X && right_hand_x < YES_button_X + YES_button_W && right_hand_y > YES_button_Y && right_hand_y < YES_button_Y + YES_button_H) {
        decide("YES");
      }
      
      // Yes Button - Left Hand
      if (left_hand_x > YES_button_X && left_hand_x < YES_button_X + YES_button_W && left_hand_y > YES_button_Y && left_hand_y < YES_button_Y + YES_button_H) {
        decide("YES");
      }
      
      // No Button - Right Hand
      if (right_hand_x > NO_button_X && right_hand_x < NO_button_X + NO_button_W && right_hand_y > NO_button_Y && right_hand_y < NO_button_Y + NO_button_H) {
        decide("NO");
      }
      
      // No Button - Left Hand
      if (left_hand_x > NO_button_X && left_hand_x < NO_button_X + NO_button_W && left_hand_y > NO_button_Y && left_hand_y < NO_button_Y + NO_button_H) {
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
