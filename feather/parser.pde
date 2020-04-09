class Parser {

  BufferedReader reader;
  ArrayList<PVector> skeleton_points = new ArrayList<PVector>();
  String input_skeleton;
  double start_time_position = 8.5; // Show structures in draw_start_structure for the first start_time_position seconds
  double end_time_position = 115; // Show structures in draw_end_structure after end_time_position seconds
  int init_time_in_millis = -1;
  
  boolean is_file_loaded = false;
  int fileIndex;
  String[] filenames;
  String userMode;
  
  User user = new User(skeleton_points);
    
  Parser () {
    
  }
  
  ArrayList<PVector> getPoints () {

    return skeleton_points;
  }
  
  void setMode (String mode) {
    
    userMode = mode;
  }
  
  void getFiles () {
    
    String path = sketchPath() + "/data";
    filenames = listSceletons(path);
  }
  
  // Switch between sceletons
  void enableKeys () {
    
    // Right arrow key
    if (keyCode == RIGHT) {
      
      if (fileIndex < filenames.length - 1) {
        
        fileIndex++;
        
      } else {
        
        fileIndex = 0;
      }
      
      is_file_loaded = false;
      loadFile(filenames[fileIndex]);
      println(fileIndex, filenames[fileIndex]);
    }
      
    // Left arrow key
    if (keyCode == LEFT) {
      
      if (fileIndex > 0) {
        
        fileIndex--;
        
      } else {
        
        fileIndex = filenames.length-1;
      }
      
      is_file_loaded = false;
      loadFile(filenames[fileIndex]);
      println(fileIndex, filenames[fileIndex]);
    }
  }
  
  void loadFile (String input_file) {
    
    // Only load if flag false
    if (!is_file_loaded) {
      
      reader = createReader(input_file);
      is_file_loaded = true;
    }
  }
  
  void read_skeleton() {
    
    String[] pieces = split(input_skeleton, ",");
    for (int i = 0; i < 17*3; i+=3) {
      
      skeleton_points.add(
        new PVector(Float.parseFloat(pieces[i]), 
        Float.parseFloat(pieces[i+1]), 
        Float.parseFloat(pieces[i+2]))
      );
    }
  }
  
  void read_data() {
    
    try {
      
      // read box rotation marix and skeleton position from file.
      String input_line;
      if ((input_line = reader.readLine()) != null) {  
        
        input_skeleton = input_line.substring(0);
        skeleton_points.clear(); //clear up arraylist 
        read_skeleton();
        
        // Reset init time
        if (init_time_in_millis == -1) {
          init_time_in_millis = millis();
        }
  
        handleDrawing(init_time_in_millis);
         
      } else {
        
        noLoop();
      }
      
    } catch(IOException e) { }
  
  }
  
  void handleDrawing (float init_time_in_millis) {
    
    double second = (millis() - init_time_in_millis) / 1000.0;
    
    //Create sequence ***
    if (second < start_time_position) {
      
     user.draw_start_structure(userMode);
      
    } else if (second >= start_time_position && second < end_time_position) {
      
      user.draw_structure(userMode);
      
    } else if (second > end_time_position) {
      
      read_skeleton();
      user.draw_end_structure(userMode);
    }
  }
  
  /*
    Returns all the files in a directory as an array of Strings  
    Reference:
    https://processing.org/examples/directorylist.html
  */
  String[] listSceletons(String dir) {
    
    String[] namesClean = {};
      
    File file = new File(dir);
    if (file.isDirectory()) {
      
      // All files in the directory
      String namesRaw[] = file.list();

      // Only accept txt files
      for (String f : namesRaw) {

        int len = f.length();
        String ext = f.substring(len - 4, len);
        if (ext.equals(".txt")) {
          namesClean = append(namesClean, f);
        }
      }
      
      return namesClean;
      
    } else {
      
      // Not a directory
      return null;
    }
  }
}
