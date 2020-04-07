String input_skeleton = "";
BufferedReader reader;

void read_skeleton() {
  
  String[] pieces = split(input_skeleton, ",");
  for (int i = 0; i < 17*3; i+=3) {
    skeleton_points.add(new PVector(Float.parseFloat(pieces[i]), 
      Float.parseFloat(pieces[i+1]), 
      Float.parseFloat(pieces[i+2])));
  }
}

void read_data() {
  
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
      draw_skeleton();

      double second = (millis() - init_time_in_millis) / 1000.0;
      //Create sequence ***
      if (second < start_time_position) {
        draw_start_structure();
      } else if (second >= start_time_position && second < end_time_position) {
        draw_structure();  //for Students
      } else if (second > end_time_position) {
        draw_end_structure();
      }
      popMatrix();

      // Draw box.
      pushMatrix();
       resetMatrix();
       translate(0, 0, -600);
       draw_box();
       popMatrix();
    } else {
      noLoop();
    }
    
  } catch(IOException e) { }

}
