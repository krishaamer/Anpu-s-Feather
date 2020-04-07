void draw_structure() {
  
  float xpos=skeleton_points.get(9).x;
  float xposend=skeleton_points.get(0).x;
  float distx=xpos - xposend;
  float ypos=skeleton_points.get(9).y;
  float yposend=skeleton_points.get(0).y;
  float disty=ypos - yposend;
  float step =0.1;  
  float pct = 0.0; 

  background (0);
  
  //for Students. Please only write your code there! ***
  /* Sphere example
     Shift the values to the right
    Add the new values to the beginning of the array
  */
  float x1=(skeleton_points.get(4).x+skeleton_points.get(3).x)/2;
  float x2=(skeleton_points.get(3).x+skeleton_points.get(2).x)/2;
  float x3=(skeleton_points.get(2).x+skeleton_points.get(0).x)/2;
  float x4=(skeleton_points.get(6).x+skeleton_points.get(7).x)/2;
  float x5=(skeleton_points.get(5).x+skeleton_points.get(6).x)/2;
  float x6=(skeleton_points.get(0).x+skeleton_points.get(5).x)/2;
  float xleft;
  float xleft2;
  float xleft3;
  float xright;
  float xright2;
  float xright3;
  float y7=skeleton_points.get(0).y-30;
  float y8=y7+20;
  float y9=(y7+y8)/2;
  float y10=(skeleton_points.get(4).y+y8)/2;
  float y11=(skeleton_points.get(7).y+y8)/2;
  float y12=(skeleton_points.get(4).y+y10)/2;
  float y13=(y7+y10)/2;
  float y14=skeleton_points.get(15).y+(skeleton_points.get(15).y-(skeleton_points.get(16).y+20));
  if (skeleton_points.get(10).x<=skeleton_points.get(9).x) {
    xleft=skeleton_points.get(10).x-400;
    xleft2=skeleton_points.get(10).x-300;
    xleft3=skeleton_points.get(10).x-200;
  }else{
    xleft=skeleton_points.get(10).x+400;
    xleft2=skeleton_points.get(10).x+300;
    xleft3=skeleton_points.get(10).x+200;
  }
    if (skeleton_points.get(13).x>=skeleton_points.get(12).x) {
    xright=skeleton_points.get(13).x+400;
    xright2=skeleton_points.get(13).x+300;
    xright3=skeleton_points.get(13).x+200;
  }else{
    xright=skeleton_points.get(13).x-400;
    xright2=skeleton_points.get(13).x-300;
    xright3=skeleton_points.get(13).x-200;
  }

  noFill();
  stroke(255);
  strokeWeight(10);
  ellipse(skeleton_points.get(4).x, skeleton_points.get(4).y, 120, 120);
  ellipse(skeleton_points.get(7).x, skeleton_points.get(7).y, 120, 120);
  stroke(255, 210);
  ellipse(x1, y12, 120, 120);
  ellipse(x4, y12, 120, 120);
  stroke(255, 180);
  ellipse(skeleton_points.get(3).x, y10, 120, 120);
  ellipse(skeleton_points.get(6).x, y11, 120, 120);
  stroke(255, 150);
  ellipse(x2, y13, 120, 120);
  ellipse(x5, y13, 120, 120);
  stroke(255, 120);
  ellipse(skeleton_points.get(2).x, y7, 120, 120);
  ellipse(skeleton_points.get(5).x, y7, 120, 120);
  stroke(255, 90);
  ellipse(skeleton_points.get(0).x, skeleton_points.get(0).y, 120, 120);
  stroke(255, 210);
  bezier(skeleton_points.get(8).x, skeleton_points.get(8).y, skeleton_points.get(8).z, 
    xleft, skeleton_points.get(10).y-350, skeleton_points.get(9).z, 
    skeleton_points.get(11).x, skeleton_points.get(11).y, skeleton_points.get(11).z, 
    skeleton_points.get(11).x, skeleton_points.get(11).y, skeleton_points.get(11).z);
  bezier(skeleton_points.get(8).x, skeleton_points.get(8).y, skeleton_points.get(8).z, 
    xright, skeleton_points.get(13).y-350, skeleton_points.get(13).z, 
    skeleton_points.get(14).x, skeleton_points.get(14).y, skeleton_points.get(14).z, 
    skeleton_points.get(14).x, skeleton_points.get(14).y, skeleton_points.get(14).z);
  stroke(255, 170);
  bezier(skeleton_points.get(8).x, skeleton_points.get(8).y, skeleton_points.get(8).z, 
    xleft2, skeleton_points.get(10).y-280, skeleton_points.get(9).z, 
    skeleton_points.get(11).x, skeleton_points.get(11).y, skeleton_points.get(11).z, 
    skeleton_points.get(11).x, skeleton_points.get(11).y, skeleton_points.get(11).z);
  bezier(skeleton_points.get(8).x, skeleton_points.get(8).y, skeleton_points.get(8).z, 
    xright2, skeleton_points.get(13).y-280, skeleton_points.get(13).z, 
    skeleton_points.get(14).x, skeleton_points.get(14).y, skeleton_points.get(14).z, 
    skeleton_points.get(14).x, skeleton_points.get(14).y, skeleton_points.get(14).z);
  stroke(255, 190);
  bezier(skeleton_points.get(8).x, skeleton_points.get(8).y, skeleton_points.get(8).z, 
    xleft3, skeleton_points.get(10).y-200, skeleton_points.get(9).z, 
    skeleton_points.get(11).x, skeleton_points.get(11).y, skeleton_points.get(11).z, 
    skeleton_points.get(11).x, skeleton_points.get(11).y, skeleton_points.get(11).z);
  bezier(skeleton_points.get(8).x, skeleton_points.get(8).y, skeleton_points.get(8).z, 
    xright3, skeleton_points.get(13).y-200, skeleton_points.get(13).z, 
    skeleton_points.get(14).x, skeleton_points.get(14).y, skeleton_points.get(14).z, 
    skeleton_points.get(14).x, skeleton_points.get(14).y, skeleton_points.get(14).z);
  stroke(255, 70);
  ellipse(x3, y9, 120, 120);
  ellipse(x6, y9, 120, 120);
  ellipse(skeleton_points.get(16).x+40, skeleton_points.get(16).y+20, 120, 120);
  ellipse(skeleton_points.get(16).x-40, skeleton_points.get(16).y+20, 120, 120);
  ellipse(skeleton_points.get(16).x+40, skeleton_points.get(15).y, 120, 120);
  ellipse(skeleton_points.get(16).x-40, skeleton_points.get(15).y, 120, 120);
  ellipse(skeleton_points.get(15).x+40, y14, 120, 120);
  ellipse(skeleton_points.get(15).x-40, y14, 120, 120);
}

void draw_start_structure() {
  
  draw_structure();
  sphere_size += 0.2;
}

void draw_end_structure() {
  
  draw_structure();
  if (sphere_size > 0) {
    sphere_size -= 0.2;
  }
}
