/*

 Scales: Calculate the weight of the heart
 
 */

class Scales {

  // Data
  ArrayList<PVector> skeleton_points;
  PImage img;
  int tintAlpha;
  PImage motion1;
  PImage motion2;
  PImage scale;
  float t=0;
  float v=3;
  float xn1=0;
  float xn2=0;
  float yn1=0;
  float yn2=0;
  float feathery=-300;
  float easingy = 0.01; 
  String startFrom;

  Scales (ArrayList<PVector> sp) {

    skeleton_points = sp;
  }
  
  void startFrom (String t) {
    
    startFrom = t;
  }

  void calculateFeatherWeight () {

    float xdist1=abs(skeleton_points.get(4).x-xn1);
    xn1=skeleton_points.get(4).x;
    float xdist2=abs(skeleton_points.get(7).x-xn2);
    xn2=skeleton_points.get(7).x;
    float ydist1=abs(skeleton_points.get(4).y-yn1);
    yn1=skeleton_points.get(4).y;
    float ydist2=abs(skeleton_points.get(7).y-yn2);
    yn2=skeleton_points.get(7).y;
    float avdist=(xdist1+xdist2+ydist1+ydist2)/4;
    float val1=map(-avdist, -30, 0, -300, 500);
    float val2=val1;


    if (val2 == 100) {
      
      val2 = random(100, 300);
    }
    
    if (val2 < 0) {
      
      val2 = random(-480, -100);
    }
    
    if (abs(val2 - feathery) > 100) {
      
      feathery +=(val2 - feathery) * easingy;
       
    } else {      
      
      t = t+0.2; 
      feathery = feathery + sin(t) * 5;
    }
    
    img = loadImage("feather_small.png");
    imageMode(CENTER);
    
    if (startFrom == "top") {
      image(img, width / 2, feathery);
    } else {
      image(img, width / 2, feathery + height / 2);
    }
    
    if(frameCount%20<10){
    fill(0);
    noStroke();
    rectMode(CENTER);
    rect(width / 2+500, height / 2+300,300,300);
    motion1 = loadImage("diagram1.png");
    imageMode(CENTER);
    image(motion1, width / 2+500, height / 2+300); 
    scale = loadImage("scale.png");
    imageMode(CORNER);
    image(scale, -50, -100);
    }else{
    fill(0);
    noStroke();
    rectMode(CENTER);
    rect(width / 2+500, height / 2+300,300,300);
    motion2 = loadImage("diagram2.png");
    imageMode(CENTER);
    image(motion2, width / 2+500, height / 2+300);
    scale = loadImage("scale.png");
    imageMode(CORNER);
    image(scale, -50, -100);
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
