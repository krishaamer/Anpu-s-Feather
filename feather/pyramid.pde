/*

  Pyramid: Control background imagery
  
  
*/

class Pyramid {
  
  int tintAlpha;
  HashMap<String,PImage> media;
  
  Pyramid (HashMap<String,PImage> m) {
    
    media = m;
  }
  
  void showAlt () {
    
    tint(255, 255, 255, tintAlpha);
    
    imageMode(CENTER);
    image(media.get("pyramid3"), width / 2, height - 400);
  }
  
  void show () {
    
    tint(255, 255, 255, tintAlpha);

    imageMode(CORNER);
    image(media.get("pyramid0"), width - 800, 0);
    image(media.get("pyramid2"), 0, 0);
    
    imageMode(CENTER);
    if (frameCount % 30 < 15){

      image(media.get("anubis1"), width / 2, height / 2 - 100);
    
    } else {
  
      image(media.get("anubis2"), width / 2, height / 2 - 100);
    }
  }
  
  void setAlpha (int a) {
    tintAlpha = a;
  }
  
  void fadeIn () {

    if (tintAlpha < 255) { 
      tintAlpha += 5;
    }
  }

  void fadeOut () {

    if (tintAlpha > 0) { 
      tintAlpha -= 10;
    }
  }
}
