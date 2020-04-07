void draw_skeleton() {
  
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
