/*

 Draw the user
 -- User with Light Heart
 -- User with Heavy Heart
 
 Reference:
 https://www.openprocessing.org/sketch/866735
 
 By Lei Lin

*/

class User {

  ArrayList<PVector> skeleton_points;
  Boolean runOnce = false;
  String userMode;
  int strokeAlpha, fillAlpha;
  int init_time_in_millis = -1;
  double start_time_position = 8; // Show structures in draw_start_structure for the first start_time_position seconds
  double end_time_position = 12; // Show structures in draw_end_structure after end_time_position seconds

  Scales scales;

  /* Light */
  int num = 15;
  float[] x = new float[num];
  float[] y = new float[num];
  float[] z = new float[num];
  float[] x2 = new float[num];
  float[] y2 = new float[num];
  float[] z2 = new float[num];
  float[]radians = new float[num];
  float x1;
  float y1;
  float exponent = 4;
  int num2 = 1500;
  float[]vx = new float[num2];
  float[]vy = new float[num2];
  float[]xpos2 = new float[num2];
  float[]ypos2 = new float[num2];
  float[]ax = new float[num2];
  float[]ay = new float[num2];
  /* END Light */
  
  /* Heavy */
  float t = 0;
  float v = 3;
  float xn1 = 0;
  float xn2 = 0;
  float yn1 = 0;
  float yn2 = 0;
  float feathery = -300;
  float easingy = 0.01; 
  /* END Heavy */

  Helper dummy = new Helper();
  User (ArrayList<PVector> sp, Scales sc) {

    skeleton_points = sp;
    scales = sc;
  }

  void setUserMode (String mode) {

    userMode = mode;
  }

  void handleDrawing () {

    double second = (millis() - init_time_in_millis) / 1000.0;

    // Sequence
    if (second < start_time_position) {

      //println("sequence start");
      draw_start_structure();
    } else if (second >= start_time_position && second < end_time_position) {

      //println("sequence middle");
      draw_structure();
    } else if (second > end_time_position) {

      //println("sequence end");
      draw_end_structure();
    }

    dummy.showFrameRate();
  }

  void draw_structure() {

    if (userMode == "light") {

      // Light
      //background(0, 0, 0, 255);
      fill(0, 0, 0, fillAlpha);
      rect(0, 0, width, height);
      fill(255, fillAlpha);
      ellipseMode(500);
      pushMatrix();
      resetMatrix(); 
      translate(0, 0, -600);
      ellipseMode(500); 
      blendMode(ADD);
      draw_structure_light();
      popMatrix();
      
    } else { 

      // Heavy
      background(0);
      strokeWeight(2);
      fill(0, 0, 0, fillAlpha);
      pushMatrix();
      resetMatrix(); 
      translate(0, 120, -300);
      scale(0.4);
      draw_structure_heavy();
      popMatrix();
    }
  }

  void fadeOut () {

    if (fillAlpha > 0) { 
      fillAlpha--;
    }

    if (strokeAlpha > 0) { 
      strokeAlpha--;
    }

    println(fillAlpha);
  }

  void draw_structure_light () {

    if (!runOnce) {

      background(0);
      for (int i =0; i< num2; i++) {
        xpos2[i] = random(-500, 500);
        ypos2[i] = random(-500, 500);
        vx[i] = 0;
        vy[i] = 0;
        ax[i] = 0;
        ay[i] = 0;
      }

      runOnce = true;
    }

    x2[0] = skeleton_points.get(7).x;
    y2[0] = skeleton_points.get(7).y;
    z2[0] = skeleton_points.get(7).z;
    for (int i = num - 1; i > 0; i--) {
      x2[i] = x2[i-1];
      y2[i] = y2[i-1];
      z2[i] = z2[i-1];
    }

    float magnetism = 40.0; // Made the pull from the mouse key and automatic lines connect faster by adding 10 
    float radius = 1 ;
    float principle = 0.95; // assigned to a different variable

    for (int i=0; i < num2; i++) {

      float distance = dist(skeleton_points.get(4).x, skeleton_points.get(4).y, xpos2[i], ypos2[i]);
      float distance2 = dist(skeleton_points.get(7).x, skeleton_points.get(7).y, xpos2[i], ypos2[i]);
      float distance3 = dist(skeleton_points.get(14).x, skeleton_points.get(14).y, xpos2[i], ypos2[i]);
      float distance4 = dist(skeleton_points.get(11).x, skeleton_points.get(11).y, xpos2[i], ypos2[i]);

      if (distance > 50) { 
        ax[i] = magnetism * (skeleton_points.get(4).x - xpos2[i]) / (distance * distance); 
        ay[i] = magnetism * (skeleton_points.get(4).y - ypos2[i]) / (distance * distance);
      }

      if (distance < 50 || distance < distance2 & distance < distance3 & distance < distance4) {  
        ax[i] = magnetism * (skeleton_points.get(7).x - xpos2[i]) / (distance * distance); 
        ay[i] = magnetism * (skeleton_points.get(7).y - ypos2[i]) / (distance * distance);
      }

      if (distance2 < 50 || distance2 < distance & distance2 < distance3 & distance2 < distance4) {  
        ax[i] = magnetism * (skeleton_points.get(14).x - xpos2[i]) / (distance * distance); 
        ay[i] = magnetism * (skeleton_points.get(14).y - ypos2[i]) / (distance * distance);
      }

      if (distance3 < 50 || distance3 < distance & distance3 < distance4 & distance3 < distance2) {  
        ax[i] = magnetism * (skeleton_points.get(11).x - xpos2[i]) / (distance * distance); 
        ay[i] = magnetism * (skeleton_points.get(11).y - ypos2[i]) / (distance * distance);
      }

      if (distance4 < 50 || distance4 < distance & distance4 < distance2 & distance4 < distance3) {  
        ax[i] = magnetism * (skeleton_points.get(4).x - xpos2[i]) / (distance * distance); 
        ay[i] = magnetism * (skeleton_points.get(4).y - ypos2[i]) / (distance * distance);
      }

      vx[i] += ax[i];
      vy[i] += ay[i];

      vx[i] = vx[i]*principle; //changed to principle in order to show the variables assigned to it remains the same as long as it's represented to something
      vy[i] = vy[i]*principle;

      xpos2[i] += vx[i];
      ypos2[i] += vy[i];

      float sokudo = dist(0, 0, vx[i], vy[i]);
      float r = map(sokudo, 0, 5, 0, 255);
      float g = map(sokudo, 0, 5, 64, 255);
      float b = map(sokudo, 0, 5, 128, 255);

      noStroke(); 
      fill(r, g, b, 32);
      ellipse(xpos2[i], ypos2[i], 1, radius); //Added a numeral in place of radius to make a highlighted circle start as soon as it starts if the person chooses to not move their mouse
      fill(r, g, b, 10);
    }

    // Draw circles for joints.
    for (int i = 0; i < 17; i++) {

      pushMatrix();
      translate(skeleton_points.get(i).x, skeleton_points.get(i).y, skeleton_points.get(i).z);
      sphere(4);
      popMatrix();
    }
  }

  void draw_structure_heavy () {

    //float xpos = skeleton_points.get(9).x;
    //float xposend = skeleton_points.get(0).x;
    //float distx = xpos - xposend;
    //float ypos = skeleton_points.get(9).y;
    //float yposend = skeleton_points.get(0).y;
    //float disty = ypos - yposend;
    //float step = 0.1;  
    //float pct = 0.0; 

    float x1 = (skeleton_points.get(4).x+skeleton_points.get(3).x)/2;
    float x2 = (skeleton_points.get(3).x+skeleton_points.get(2).x)/2;
    float x3 = (skeleton_points.get(2).x+skeleton_points.get(0).x)/2;
    float x4 = (skeleton_points.get(6).x+skeleton_points.get(7).x)/2;
    float x5 = (skeleton_points.get(5).x+skeleton_points.get(6).x)/2;
    float x6 = (skeleton_points.get(0).x+skeleton_points.get(5).x)/2;
    float xleft;
    float xleft2;
    float xleft3;
    float xright;
    float xright2;
    float xright3;
    float y7 = skeleton_points.get(0).y - 30;
    float y8 = y7 + 20;
    float y9 = (y7 + y8) / 2;
    float y10 = (skeleton_points.get(4).y + y8) / 2;
    float y11 = (skeleton_points.get(7).y + y8) / 2;
    float y12 = (skeleton_points.get(4).y + y10) / 2;
    float y13 = (y7 + y10) / 2;
    float y14 = skeleton_points.get(15).y + (skeleton_points.get(15).y - (skeleton_points.get(16).y + 20));

    if (skeleton_points.get(10).x <= skeleton_points.get(9).x) {

      xleft = skeleton_points.get(10).x - 400;
      xleft2 = skeleton_points.get(10).x - 300;
      xleft3 = skeleton_points.get(10).x - 200;
    } else {

      xleft = skeleton_points.get(10).x + 400;
      xleft2 = skeleton_points.get(10).x + 300;
      xleft3 = skeleton_points.get(10).x + 200;
    }

    if (skeleton_points.get(13).x >= skeleton_points.get(12).x) {

      xright = skeleton_points.get(13).x + 400;
      xright2 = skeleton_points.get(13).x + 300;
      xright3 = skeleton_points.get(13).x + 200;
    } else {

      xright = skeleton_points.get(13).x - 400;
      xright2 = skeleton_points.get(13).x - 300;
      xright3 = skeleton_points.get(13).x - 200;
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
    
    setfeather();
  }

  void setfeather() {

    fill(0);
    noStroke();
    rect(-500, -500, 200, 1000);

    PImage img;
    float xdist1 = abs(skeleton_points.get(4).x - xn1);
    xn1 = skeleton_points.get(4).x;

    float xdist2 = abs(skeleton_points.get(7).x - xn2);
    xn2 = skeleton_points.get(7).x;

    float ydist1 = abs(skeleton_points.get(4).y - yn1);
    yn1 = skeleton_points.get(4).y;

    float ydist2 = abs(skeleton_points.get(7).y - yn2);
    yn2 = skeleton_points.get(7).y;

    float avdist = (xdist1 + xdist2 + ydist1 + ydist2) / 4;
    float val1 = map(-avdist, -30, 0, -500, 100);
    float val2 = val1;

    if (val2 == 100) {
      val2 = random(100, 300);
    }
    
    if (val2 < 0) {
      val2 = random(-480, -100);
    }
    
    println(val2);

    if (abs(val2 - feathery) > 100) {

      feathery += (val2 - feathery) * easingy;
      
    } else {   
      
      t = t+0.2; 
      feathery=feathery+sin(t)*5;
    }
    
    img = loadImage("feathertiny.png");
    tint(255, 255, 255);
    image(img, -400, feathery);
  }

  void draw_start_structure() {

    draw_structure();
  }

  void draw_end_structure() {

    draw_structure();
  }
}
