class Parser {

  String input_skeleton = "";
  double start_time_position = 8.5; // Show structures in draw_start_structure for the first start_time_position seconds
  double end_time_position = 115; // Show structures in draw_end_structure after end_time_position seconds.
  int init_time_in_millis = -1;

  UI ui = new UI();
  User user = new User();
  
  Parser () {
    
  }
  
  void read_skeleton() {
    
    String[] pieces = split(input_skeleton, ",");
    for (int i = 0; i < 17*3; i+=3) {
      skeleton_points.add(new PVector(Float.parseFloat(pieces[i]), 
        Float.parseFloat(pieces[i+1]), 
        Float.parseFloat(pieces[i+2])));
    }
  }
  
  void read_data(BufferedReader reader) {
    
    try {
      
      // read box rotation marix and skeleton position from file.
      String input_line;
      if ((input_line = reader.readLine()) != null) {   
        input_skeleton = input_line.substring(0);
        skeleton_points.clear();    //clear up arraylist 
        read_skeleton();
        if (init_time_in_millis == -1) {
          init_time_in_millis = millis();
        }
  
        // Draw skeleton.
        pushMatrix();
        resetMatrix(); 
        translate(0, 0, -600);
        user.draw_skeleton();
  
        double second = (millis() - init_time_in_millis) / 1000.0;
        //Create sequence ***
        if (second < start_time_position) {
          
          user.draw_start_structure();
          
        } else if (second >= start_time_position && second < end_time_position) {
          
          user.draw_structure();  //for Students
          
        } else if (second > end_time_position) {
          
          user.draw_end_structure();
        }
        popMatrix();
  
        // Draw box.
        pushMatrix();
        resetMatrix();
        translate(0, 0, -600);
        ui.draw_box();
        popMatrix();
         
      } else {
        
        noLoop();
      }
      
    } catch(IOException e) { }
  
  }
  
}
