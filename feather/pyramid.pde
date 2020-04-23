/*

  Pyramid: Control background imagery
  
  
*/

class Pyramid {
  
  HashMap<String,PImage> media;
  
  Pyramid (HashMap<String,PImage> m) {
    
    media = m;
  }
  
  void showAlt () {
    
    imageMode(CENTER);
    image(media.get("pyramid3"), width / 2, height - 400);
  }
  
  void show () {
    
    imageMode(CORNER);
    image(media.get("pyramid0"), width - 800, 0);
    imageMode(CORNER);
    image(media.get("pyramid2"), 0, 0);
    
    if (frameCount % 30 < 15){

      imageMode(CENTER);
      image(media.get("anubis1"), width / 2, height / 2 - 100);
    
    } else {
  
      imageMode(CENTER);
      image(media.get("anubis2"), width / 2, height / 2 - 100);
    }
  }
}
