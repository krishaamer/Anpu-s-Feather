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
  int min = minute();  // Values from 0 - 59
  int hr = hour();    // Values from 0 - 23
  int da = day();    // Values from 1 - 31
  int mon = month();  // Values from 1 - 12
  int ye = year();   // 2003, 2004, 2005, etc.
  boolean is_initiated = false;
  
  Output (ArrayList<PVector> sp) {
    
    skeleton_points = sp;
    init();
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
    
    //for Students. When you are ready to record your video. ***
    saveFrame("output/frame-######.png");
  }
  
  void exitFile () {
    
    output.flush(); // Writes the remaining data to the file
    output.close();
    exit();
  }
}
