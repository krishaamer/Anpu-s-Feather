/*

  Output
  Create some sort of output
  
  References:
  -- Live file from ICID
  
*/

class Output {
  
  PrintWriter output;
  ArrayList<PVector> skeleton_points;
  String studentName = "Feather";
  String wisdom_card_name;
  int sec = second();  // Values from 0 - 59
  int min = minute();  // Values from 0 - 59
  int hr = hour();    // Values from 0 - 23
  int da = day();    // Values from 1 - 31
  int mon = month();  // Values from 1 - 12
  int ye = year();   // 2003, 2004, 2005, etc.
  boolean is_initiated = false;
  boolean already_saved = false;
  boolean should_save = false;
  
  Output (ArrayList<PVector> sp, Boolean ss) {
    
    skeleton_points = sp;
    should_save = ss;
  }
  
  void init () {
    
    if (!is_initiated) {
      
      // Create a new file in the sketch directory
      String filename = "sceleton" + ye + "_" + mon + "_" + da + "_" + hr + "_" + min + "_" + studentName + ".txt";
      //println("init file", filename);
      output = createWriter(filename); 
      is_initiated = true;
    }
  }
  
  void writeFile () {
   
    for (int j = 0; j < 17; j++){ 
      
      output.print(skeleton_points.get(j).x + "," + skeleton_points.get(j).y + "," + skeleton_points.get(j).z + ",");
    }
    output.flush();
  }
  
  void saveImage () {
    
    if (should_save) {
      if (!already_saved) {
        
        wisdom_card_name = "card_" + ye + "_" + mon + "_" + da + "_" + hr + "_" + min + "_" + sec;
        saveFrame("wisdom/" + wisdom_card_name + ".png");
        already_saved = true;
      }
    }
  }
  
  void exitFile () {
    
    output.flush(); // Writes the remaining data to the file
    output.close();
    exit();
  }
  
  // Keyboard Shortcuts
  void enableKeys () {

    // FileWriter - Flush Memory and Exit File
    if (key == 'q' || key == 'Q') {
      
      exitFile();
    }
  }
}
