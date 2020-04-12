/*

  Useful helper functions
  
*/

class Helper {
  
  boolean showBox;
  boolean showDummy;
  ArrayList<PVector> dummyPoints;
  
  Helper () {
    
  }
  
  void update() {
    
    if (showBox) {
      
      pushMatrix();
      resetMatrix();
      translate(0, 0, -600);
      drawBox();
      popMatrix();
    }
    
    if (showDummy) {
      
      pushMatrix();
      resetMatrix();
      translate(0, 200, -600);
      drawDummy(dummyPoints);
      popMatrix();
    }
  }
  
  /* 
    0: head
    1: neck
    2: left_shoulder
    3: left_elbow
    4: left_hand
    5: right_shoulder
    6: right_elbow
    7: right_hand
    8: torso
    9: left_hip
    10: left_knee
    11: left_foot
    12: right_hip
    13: right_knee
    14: right_foot
    15: spine_mid
    16: spine_shoulder
  */
  void drawDummy (ArrayList<PVector> skeleton_points) {
  
    // Draw circles for joints.
    for (int i = 0; i < 17; i++) {
      
      stroke(255, 0, 0);
      pushMatrix();
      translate(skeleton_points.get(i).x, skeleton_points.get(i).y, skeleton_points.get(i).z);
      sphere(4);
      popMatrix();
    }
  
    stroke(0, 255, 0);
  
    // Line 1: torso, spine_mid, spine_shoulder, neck, head
    line(skeleton_points.get(8).x, skeleton_points.get(8).y, skeleton_points.get(8).z, 
      skeleton_points.get(15).x, skeleton_points.get(15).y, skeleton_points.get(15).z);
    line(skeleton_points.get(15).x, skeleton_points.get(15).y, skeleton_points.get(15).z, 
      skeleton_points.get(16).x, skeleton_points.get(16).y, skeleton_points.get(16).z);
    line(skeleton_points.get(16).x, skeleton_points.get(16).y, skeleton_points.get(16).z, 
      skeleton_points.get(1).x, skeleton_points.get(1).y, skeleton_points.get(1).z);
    line(skeleton_points.get(1).x, skeleton_points.get(1).y, skeleton_points.get(1).z, 
      skeleton_points.get(0).x, skeleton_points.get(0).y, skeleton_points.get(0).z);
  
    // Line 2: spine_shoulder, right_shoulder, right_elbow, right_hand
    line(skeleton_points.get(16).x, skeleton_points.get(16).y, skeleton_points.get(16).z, 
      skeleton_points.get(5).x, skeleton_points.get(5).y, skeleton_points.get(5).z);
    line(skeleton_points.get(5).x, skeleton_points.get(5).y, skeleton_points.get(5).z, 
      skeleton_points.get(6).x, skeleton_points.get(6).y, skeleton_points.get(6).z);
    line(skeleton_points.get(6).x, skeleton_points.get(6).y, skeleton_points.get(6).z, 
      skeleton_points.get(7).x, skeleton_points.get(7).y, skeleton_points.get(7).z);
  
    // Line 3: torso, right_hip, right_knee, right_foot
    line(skeleton_points.get(8).x, skeleton_points.get(8).y, skeleton_points.get(8).z, 
      skeleton_points.get(12).x, skeleton_points.get(12).y, skeleton_points.get(12).z);
    line(skeleton_points.get(12).x, skeleton_points.get(12).y, skeleton_points.get(12).z, 
      skeleton_points.get(13).x, skeleton_points.get(13).y, skeleton_points.get(13).z);
    line(skeleton_points.get(13).x, skeleton_points.get(13).y, skeleton_points.get(13).z, 
      skeleton_points.get(14).x, skeleton_points.get(14).y, skeleton_points.get(14).z);
  
    // Line 4: spine_shoulder, left_shoulder, left_elbow, left_hand
    line(skeleton_points.get(16).x, skeleton_points.get(16).y, skeleton_points.get(16).z, 
      skeleton_points.get(2).x, skeleton_points.get(2).y, skeleton_points.get(2).z);
    line(skeleton_points.get(2).x, skeleton_points.get(2).y, skeleton_points.get(2).z, 
      skeleton_points.get(3).x, skeleton_points.get(3).y, skeleton_points.get(3).z);
    line(skeleton_points.get(3).x, skeleton_points.get(3).y, skeleton_points.get(3).z, 
      skeleton_points.get(4).x, skeleton_points.get(4).y, skeleton_points.get(4).z);
  
    // Line 5: torso, left_hip, left_knee, left_foot
    line(skeleton_points.get(8).x, skeleton_points.get(8).y, skeleton_points.get(8).z, 
      skeleton_points.get(9).x, skeleton_points.get(9).y, skeleton_points.get(9).z);
    line(skeleton_points.get(9).x, skeleton_points.get(9).y, skeleton_points.get(9).z, 
      skeleton_points.get(10).x, skeleton_points.get(10).y, skeleton_points.get(10).z);
    line(skeleton_points.get(10).x, skeleton_points.get(10).y, skeleton_points.get(10).z, 
      skeleton_points.get(11).x, skeleton_points.get(11).y, skeleton_points.get(11).z);
  } 
  
  // Draw box for reference
  void drawBox() {
    
     PVector b1 = new PVector(-287, -287, -287);
     PVector b2 = new PVector(288, -287, -287);
     PVector b3 = new PVector(288, 288, -287);
     PVector b4 = new PVector(-287, 288, -287);
     PVector b5 = new PVector(-287, -287, 288);
     PVector b6 = new PVector(288, -287, 288);
     PVector b7 = new PVector(288, 288, 288);
     PVector b8 = new PVector(-287, 288, 288);
     
     stroke(255, 0, 0);
     strokeWeight(1);
     beginShape(LINES);
     vertex(b1.x, b1.y, b1.z);  
     vertex(b2.x, b2.y, b2.z);
     vertex(b3.x, b3.y, b3.z);  
     vertex(b2.x, b2.y, b2.z);
     vertex(b3.x, b3.y, b3.z);  
     vertex(b4.x, b4.y, b4.z);
     vertex(b1.x, b1.y, b1.z);  
     vertex(b4.x, b4.y, b4.z);
     vertex(b1.x, b1.y, b1.z);  
     vertex(b5.x, b5.y, b5.z);
     vertex(b6.x, b6.y, b6.z);  
     vertex(b2.x, b2.y, b2.z);
     vertex(b7.x, b7.y, b7.z);  
     vertex(b3.x, b3.y, b3.z);
     vertex(b8.x, b8.y, b8.z);  
     vertex(b4.x, b4.y, b4.z);
     vertex(b5.x, b5.y, b5.z);  
     vertex(b6.x, b6.y, b6.z);
     vertex(b7.x, b7.y, b7.z);  
     vertex(b6.x, b6.y, b6.z);
     vertex(b7.x, b7.y, b7.z);  
     vertex(b8.x, b8.y, b8.z);
     vertex(b5.x, b5.y, b5.z);  
     vertex(b8.x, b8.y, b8.z);
     endShape();
  }
  
  void toggleBox () {

    if (key == 'b' || key == 'B') {
      showBox = !showBox;
    }
  }
  
  void toggleDummy (Parser parser) {
    
    dummyPoints = parser.getPoints();
    
    if (key == 'd' || key == 'D') {
      showDummy = !showDummy;
    }
  }
  
  /*
    Returns all the files in a directory as an array of Strings  
    Reference:
    https://processing.org/examples/directorylist.html
  */
  String[] listTextFiles(String dir) {
    
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
