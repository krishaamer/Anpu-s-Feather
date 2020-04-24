/*

 Scales: Calculate the weight of the heart
 
 */

class Scales {

  // Data
  ArrayList<PVector> skeleton_points;
  HashMap<String,PImage> media;
  int tintAlpha;
  float t = 0;
  float v = 3;
  float xn1 = 0;
  float xn2 = 0;
  float yn1 = 0;
  float yn2 = 0;
  float feather_y = -300;
  float easing_y = 0.01;
  float xdist1, xdist2, ydist1, ydist2, avdist, val1, val2;
  String startFrom;
  boolean showDiagram = true;

  Scales (ArrayList<PVector> sp, HashMap<String,PImage> m) {

    skeleton_points = sp;
    media = m;
  }
  
  void showDiagram (Boolean sd) {
    
    showDiagram = sd;
  }
  
  void startFrom (String t) {
    
    startFrom = t;
  }
  
  float getFeatherY () {
    
    return feather_y;
  }

  void calculateFeatherWeight () {

    xdist1 = abs(skeleton_points.get(4).x - xn1);
    xn1 = skeleton_points.get(4).x;
    xdist2 = abs(skeleton_points.get(7).x - xn2);
    xn2 = skeleton_points.get(7).x;
    ydist1 = abs(skeleton_points.get(4).y - yn1);
    yn1 = skeleton_points.get(4).y;
    ydist2 = abs(skeleton_points.get(7).y - yn2);
    yn2 = skeleton_points.get(7).y;
    avdist = (xdist1 + xdist2 + ydist1 + ydist2) / 4;
    val1 = map(-avdist, -30, 0, -300, 500);
    val2 = val1;
    
    noStroke();
    fill(0, 20);
    rectMode(CENTER);
    rect(width / 2, feather_y + 400, 600, 800);
    
    if (val2 == 100) {
      
      val2 = random(100, 300);
    }
    
    if (val2 < 0) {
      
      val2 = random(-480, -100);
    }
    
    if (abs(val2 - feather_y) > 100) {
      
      feather_y += (val2 - feather_y) * easing_y;
       
    } else {      
      
      t = t + 0.2; 
      feather_y = feather_y + sin(t) * 5;
    }
    
    imageMode(CENTER);
    
    if (startFrom == "top") {
      
      image(media.get("feather"), width / 2, feather_y);
      
    } else {
      
      image(media.get("feather"), width / 2, feather_y + height / 2);
    }
    
    if (showDiagram) {
      drawDiagram();
    }
    
  }
  
  void drawDiagram () {
    
    if (frameCount % 20 < 10) {
        
        fill(0);
        noStroke();
        rectMode(CENTER);
        rect(width / 2 + 500, height / 2 + 300, 300, 300);
        
        imageMode(CENTER);
        image(media.get("diagram1"), width / 2 + 500, height / 2 + 300); 
        
        imageMode(CORNER);
        image(media.get("scale"), -50, -100);
        
     } else {
         
        fill(0);
        noStroke();
        
        rectMode(CENTER);
        rect(width / 2 + 500, height / 2 + 300, 300, 300);
        
        imageMode(CENTER);
        image(media.get("diagram2"), width / 2 + 500, height / 2 + 300);
        
        imageMode(CORNER);
        image(media.get("scale"), -50, -100);
    }
  }

  void update() {
    
     pushMatrix();
     translate(0, 0, -200);
     tint(255, 255, 255, tintAlpha);
     calculateFeatherWeight();
     popMatrix();
  }

  void fadeIn () {

    if (tintAlpha < 255) { 
      tintAlpha++;
    }
  }

  void fadeOut () {

    if (tintAlpha > 0) { 
      tintAlpha--;
    }
  }
}
