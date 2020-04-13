/*

  QA: Yes / No Questions for the User
  
*/

class QA {
  
  // Shared
  
  
  
  // No
  int NO_button_H = 50;
  int NO_button_W = 100;
  int NO_button_X = 20;
  int NO_button_Y = 20;
  boolean NO_button_inside = false;
  
  // Yes
  int YES_button_W = 100;
  int YES_button_H = 50;
  int YES_button_X = 680;
  int YES_button_Y = 20;
  boolean YES_button_inside = false;
  
  QA () {
    
  }
  
  void ask () {
    
    createNoButton();
    createYesButton();
  }
  
  void createNoButton () {
    
    fill(255, 0, 0);
    rect(NO_button_X, NO_button_Y, NO_button_W, NO_button_H);
  }
  
  void createYesButton () {
    
    // Need to set button X pos here to have correct screen width value
    YES_button_X = width - YES_button_W - 20;
   
    // Button
    fill(0, 0, 255);
    rect(YES_button_X, YES_button_Y, YES_button_W, YES_button_H);
  }
  
  void enableButtons () {
   
      // Yes Button
      if (mouseX > YES_button_X && mouseX < YES_button_X + YES_button_W && mouseY > YES_button_Y && mouseY < YES_button_Y + YES_button_H) {
        
        YES_button_inside = true;
        println("YES");
      }
      
      // No Button
      if (mouseX > NO_button_X && mouseX < NO_button_X + NO_button_W && mouseY > NO_button_Y && mouseY < NO_button_Y + NO_button_H) {
        
        NO_button_inside = true;
        println("NO");
      }
  }
  
}
