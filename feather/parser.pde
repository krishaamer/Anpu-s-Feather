/*

  Parser: import the movement data from a file OR from live Kinect source
  
  References:
  -- Live file from ICID
  
*/

class Parser {
  
  // Shared
  ArrayList<PVector> skeleton_points = new ArrayList<PVector>();
  String userMode;

  // File Source
  BufferedReader reader;
  String input_skeleton;
  boolean is_file_loaded = false;
  int fileIndex;
  String[] filenames;
  String currentFileName;
  
  // Live Source
  float skeletonRatio = 200.0 / 600.0; // The ratio for skeleton 3D position
  boolean is_live;
  boolean live_initiated;
  
  // Tools
  Helper helper = new Helper();
  Output output = new Output(skeleton_points);
  User user = new User(skeleton_points);
  Draw draw = new Draw();
  
  Parser () {
    
  }
  
  ArrayList<PVector> getPoints () {

    return skeleton_points;
  }
  
  void setUserMode (String mode) {
    
    userMode = mode;
  }
  
  // Load Kinect
  void liveInit (KinectPV2 kinect) {
    
    if (!live_initiated) {
      
      // Init Kinect
      kinect.enableSkeleton3DMap(true); //enable 3d with (x,y,z) position, unit meter
      kinect.init();
    }
  }
  
  // Load File
  void loadFile (String input_file) {
    
    // Get All Files List
    String path = sketchPath() + "/data";
    filenames = helper.listTextFiles(path);
    
    // Load Default File
    if (!is_file_loaded) {
      
      reader = createReader(input_file);
      is_file_loaded = true;
      currentFileName = input_file;
    }
  }
  
  // Keyboard Shortcuts
  void enableKeys () {
    
    // Switch between Skeletons - Right Arrow key
    if (keyCode == RIGHT) {
      
      if (fileIndex < filenames.length - 1) {
        
        fileIndex++;
        
      } else {
        
        fileIndex = 0;
      }
      
      is_file_loaded = false;
      currentFileName = filenames[fileIndex];
      loadFile(currentFileName);
      println(fileIndex, currentFileName);
    }
      
    // Switch between Skeletons - Left Arrow key
    if (keyCode == LEFT) {
      
      if (fileIndex > 0) {
        
        fileIndex--;
        
      } else {
        
        fileIndex = filenames.length - 1;
      }
      
      is_file_loaded = false;
      currentFileName = filenames[fileIndex];
      loadFile(currentFileName);
      println(fileIndex, currentFileName);
    }
    
    // FileWriter - Flush Memory and Exit File
    if (key == 'q' || key == 'Q') {
      
      output.exitFile();
    }
  }
  
  // Switch
  void read_data () {
    
    if (is_live) {
      read_data_live();
    } else {
      read_data_file();
    } 
  }
  
  // Pre-Recorded Data (File)
  void read_data_file() {
    
    try {
      
      // Read box rotation matrix and skeleton position from file
      String input_line;
      if ((input_line = reader.readLine()) != null) {  
        
        input_skeleton = input_line.substring(0);
        skeleton_points.clear();
        update_skeleton_file();
        draw.reset_time();
        draw.handleDrawing(user, userMode);
        output.writeFile();
         
      } else {

        // Restart
        is_file_loaded = false;
        loadFile(currentFileName);
        println("EOF, load file again", currentFileName);
      }
      
    } catch(IOException e) { }
  
  }
  
  // Live Data (Kinect)
  void read_data_live () {
    
    draw.reset_time();
          
    // Translate the skeleton to the center 
    //pushMatrix();
    //translate(width / 2, height / 2, -200);
    
    // Data from Kinect
    ArrayList<KSkeleton> skeletonArray =  kinect.getSkeleton3d();
    for (int i = 0; i < skeletonArray.size(); i++) {
      
      KSkeleton skeleton = (KSkeleton) skeletonArray.get(i);
      if (skeleton.isTracked()) {
        
        KJoint[] joints = skeleton.getJoints();
        update_skeleton_live(joints); 
        draw.handleDrawing(user, userMode);
        output.writeFile();
      }
    }
    //popMatrix();
  }
  
  // Update Skeleton Joint Vectors from File
  void update_skeleton_file() {
    
    String[] pieces = split(input_skeleton, ",");
    for (int i = 0; i < 17*3; i+=3) {
      
      skeleton_points.add(
        new PVector(Float.parseFloat(pieces[i]), 
        Float.parseFloat(pieces[i+1]), 
        Float.parseFloat(pieces[i+2]))
      );
    }
  }
  
  // Update Skeleton Joint Vectors from Kinect
  void update_skeleton_live(KJoint[] joints) {
    
    // Clear
    skeleton_points.clear();
    
    // Add
    skeleton_points.add(get_joint_vector(joints, KinectPV2.JointType_Head));
    skeleton_points.add(get_joint_vector(joints, KinectPV2.JointType_Neck));
    skeleton_points.add(get_joint_vector(joints, KinectPV2.JointType_ShoulderLeft));
    skeleton_points.add(get_joint_vector(joints, KinectPV2.JointType_ElbowLeft));
    skeleton_points.add(get_joint_vector(joints, KinectPV2.JointType_HandLeft));
    skeleton_points.add(get_joint_vector(joints, KinectPV2.JointType_ShoulderRight));
    skeleton_points.add(get_joint_vector(joints, KinectPV2.JointType_ElbowRight));
    skeleton_points.add(get_joint_vector(joints, KinectPV2.JointType_HandRight));
    skeleton_points.add(get_joint_vector(joints, KinectPV2.JointType_SpineBase));
    skeleton_points.add(get_joint_vector(joints, KinectPV2.JointType_HipLeft));
    skeleton_points.add(get_joint_vector(joints, KinectPV2.JointType_KneeLeft));
    skeleton_points.add(get_joint_vector(joints, KinectPV2.JointType_FootLeft));
    skeleton_points.add(get_joint_vector(joints, KinectPV2.JointType_HipRight));
    skeleton_points.add(get_joint_vector(joints, KinectPV2.JointType_KneeRight));
    skeleton_points.add(get_joint_vector(joints, KinectPV2.JointType_FootRight));
    skeleton_points.add(get_joint_vector(joints, KinectPV2.JointType_SpineMid));
    skeleton_points.add(get_joint_vector(joints, KinectPV2.JointType_SpineShoulder));    
  }
  
  // Calculate Vector
  PVector get_joint_vector(KJoint[] joints, int jointType){
    
    return new PVector(joints[jointType].getX() * 1000 * skeletonRatio, -joints[jointType].getY() * 1000 * skeletonRatio, (joints[jointType].getZ() - 2.4) * 1000 * skeletonRatio);
  }
}
