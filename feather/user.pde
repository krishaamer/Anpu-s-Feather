/*

 Draw the user
 -- User with Light Heart
 -- User with Heavy Heart
 
 Reference:
 https://www.openprocessing.org/sketch/866735
 
 By Lei Lin
 
 */

class User {

  // Data
  ArrayList<PVector> skeleton_points;
  Boolean runOnce = false;
  String mode;
  int strokeAlpha, fillAlpha;
  PGraphics graphics;
  Boolean shouldCapture = false;

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
  int num2 = 5000;
  float[]vx = new float[num2];
  float[]vy = new float[num2];
  float[]xpos2 = new float[num2];
  float[]ypos2 = new float[num2];
  float[]ax = new float[num2];
  float[]ay = new float[num2];
  /* END Light */

  User (ArrayList<PVector> sp) {

    skeleton_points = sp;
  }

  void addLib (PGraphics pg) {

    graphics = pg;
  }

  void setMode (String m) {

    mode = m;
  }

  void update() {

    if (mode == "light") {

      // Light
      fill(255, 255, 255, fillAlpha);
      pushMatrix();
      resetMatrix(); 
      translate(0, 0, -300);
      draw_user_light();
      popMatrix();
    } else if (mode == "heavy") { 

      // Heavy
      background(0);
      strokeWeight(2);
      fill(0, 0, 0, fillAlpha);
      pushMatrix();
      resetMatrix(); 
      translate(0, 120, -300);
      scale(0.4);
      draw_user_heavy();
      popMatrix();
    } else if (mode == "questions") { 

      // Hands
      background(0);
      strokeWeight(2);
      fill(0, 0, 0, fillAlpha);
      pushMatrix();
      resetMatrix();
      translate(0, 0, -300);
      scale(0.5);
      draw_user_hands();
      popMatrix();
    }
  }

  void fadeIn () {

    if (fillAlpha < 255) { 
      fillAlpha++;
    }

    if (strokeAlpha < 255) { 
      strokeAlpha++;
    }
  }

  void fadeOut () {

    if (fillAlpha > 0) { 
      fillAlpha--;
    }

    if (strokeAlpha > 0) { 
      strokeAlpha--;
    }
  }

  void startCapture () {

    shouldCapture = true;
    println("User beginDraw");
  }

  void endCapture () {

    shouldCapture = false;
    println("User endDraw");
  }

  void draw_user_light () {

    if (shouldCapture) {
      graphics.beginDraw();
    }

    if (!runOnce) {

      //background(0);
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

    float magnetism = 30.0; // Made the pull from the mouse key and automatic lines connect faster by adding 10 
    float radius = 1;
    float principle = 0.95;

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
      fill(r, g, b, 60);
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

    if (shouldCapture) {
      graphics.endDraw();
    }
  }

  void draw_user_heavy () {

    if (shouldCapture) {
      graphics.beginDraw();
    }
    float distm = 0;
    float x1 = (skeleton_points.get(4).x+skeleton_points.get(3).x)/2+distm;
    float x2 = (skeleton_points.get(3).x+skeleton_points.get(2).x)/2+distm;
    float x3 = (skeleton_points.get(2).x+skeleton_points.get(0).x)/2+distm;
    float x4 = (skeleton_points.get(6).x+skeleton_points.get(7).x)/2+distm;
    float x5 = (skeleton_points.get(5).x+skeleton_points.get(6).x)/2+distm;
    float x6 = (skeleton_points.get(0).x+skeleton_points.get(5).x)/2+distm;
    float xleft;
    float xleft2;
    float xleft3;
    float xright;
    float xright2;
    float xright3;
    float y7 = skeleton_points.get(0).y - 30+distm;
    float y8 = y7 + 20+distm;
    float y9 = ((y7 + y8) / 2)+distm;
    float y10 = (skeleton_points.get(4).y + y8) / 2+distm;
    float y11 = (skeleton_points.get(7).y + y8) / 2+distm;
    float y12 = (skeleton_points.get(4).y + y10) / 2+distm;
    float y13 = (y7 + y10) / 2;
    float y14 = skeleton_points.get(15).y + (skeleton_points.get(15).y - (skeleton_points.get(16).y + 20))+distm;

      xleft = skeleton_points.get(10).x - 400+distm;
      xleft2 = skeleton_points.get(10).x - 300+distm;
      xleft3 = skeleton_points.get(10).x - 200+distm;

      xright = skeleton_points.get(13).x + 400+distm;
      xright2 = skeleton_points.get(13).x + 300+distm;
      xright3 = skeleton_points.get(13).x + 200+distm;


    noFill();
    stroke(255);
    strokeWeight(10);
    ellipse(skeleton_points.get(4).x+distm, skeleton_points.get(4).y+distm, 120, 120);
    ellipse(skeleton_points.get(7).x+distm, skeleton_points.get(7).y+distm, 120, 120);
    stroke(255, 210);
    ellipse(x1, y12, 120, 120);
    ellipse(x4, y12, 120, 120);
    stroke(255, 180);
    ellipse(skeleton_points.get(3).x+distm, y10, 120, 120);
    ellipse(skeleton_points.get(6).x+distm, y11, 120, 120);
    stroke(255, 150);
    ellipse(x2, y13, 120, 120);
    ellipse(x5, y13, 120, 120);
    stroke(255, 120);
    ellipse(skeleton_points.get(2).x+distm, y7, 120, 120);
    ellipse(skeleton_points.get(5).x+distm, y7, 120, 120);
    stroke(255, 90);
    ellipse(skeleton_points.get(0).x+distm, skeleton_points.get(0).y, 120, 120);
    stroke(255, 210);
    bezier(skeleton_points.get(8).x+distm, skeleton_points.get(8).y, skeleton_points.get(8).z, 
      xleft, skeleton_points.get(10).y-350, skeleton_points.get(9).z, 
      skeleton_points.get(11).x+distm, skeleton_points.get(11).y, skeleton_points.get(11).z, 
      skeleton_points.get(11).x+distm, skeleton_points.get(11).y, skeleton_points.get(11).z);
    bezier(skeleton_points.get(8).x+distm, skeleton_points.get(8).y, skeleton_points.get(8).z, 
      xright, skeleton_points.get(13).y-350, skeleton_points.get(13).z, 
      skeleton_points.get(14).x+distm, skeleton_points.get(14).y, skeleton_points.get(14).z, 
      skeleton_points.get(14).x+distm, skeleton_points.get(14).y, skeleton_points.get(14).z);
    stroke(255, 170);
    bezier(skeleton_points.get(8).x+distm, skeleton_points.get(8).y, skeleton_points.get(8).z, 
      xleft2, skeleton_points.get(10).y-280, skeleton_points.get(9).z, 
      skeleton_points.get(11).x+distm, skeleton_points.get(11).y, skeleton_points.get(11).z, 
      skeleton_points.get(11).x+distm, skeleton_points.get(11).y, skeleton_points.get(11).z);
    bezier(skeleton_points.get(8).x+distm, skeleton_points.get(8).y, skeleton_points.get(8).z, 
      xright2, skeleton_points.get(13).y-280, skeleton_points.get(13).z, 
      skeleton_points.get(14).x+distm, skeleton_points.get(14).y, skeleton_points.get(14).z, 
      skeleton_points.get(14).x+distm, skeleton_points.get(14).y, skeleton_points.get(14).z);
    stroke(255, 190);
    bezier(skeleton_points.get(8).x+distm, skeleton_points.get(8).y, skeleton_points.get(8).z, 
      xleft3, skeleton_points.get(10).y-200, skeleton_points.get(9).z, 
      skeleton_points.get(11).x+distm, skeleton_points.get(11).y, skeleton_points.get(11).z, 
      skeleton_points.get(11).x+distm, skeleton_points.get(11).y, skeleton_points.get(11).z);
    bezier(skeleton_points.get(8).x+distm, skeleton_points.get(8).y, skeleton_points.get(8).z, 
      xright3, skeleton_points.get(13).y-200, skeleton_points.get(13).z, 
      skeleton_points.get(14).x+distm, skeleton_points.get(14).y, skeleton_points.get(14).z, 
      skeleton_points.get(14).x+distm, skeleton_points.get(14).y, skeleton_points.get(14).z);
    stroke(255, 70);
    ellipse(x3, y9, 120, 120);
    ellipse(x6, y9, 120, 120);
    ellipse(skeleton_points.get(16).x+40+distm, skeleton_points.get(16).y+20, 120, 120);
    ellipse(skeleton_points.get(16).x-40+distm, skeleton_points.get(16).y+20, 120, 120);
    ellipse(skeleton_points.get(16).x+40+distm, skeleton_points.get(15).y, 120, 120);
    ellipse(skeleton_points.get(16).x-40+distm, skeleton_points.get(15).y, 120, 120);
    ellipse(skeleton_points.get(15).x+40+distm, y14, 120, 120);
    ellipse(skeleton_points.get(15).x-40+distm, y14, 120, 120);
    if (shouldCapture) {
      graphics.endDraw();
    }
  }

  void draw_user_hands () {

    noFill();
    stroke(255);
    strokeWeight(10);

    // Left Hand
    ellipse(skeleton_points.get(4).x, skeleton_points.get(4).y, 20, 20);

    // Right Hand
    ellipse(skeleton_points.get(7).x, skeleton_points.get(7).y, 20, 20);
  }
}
