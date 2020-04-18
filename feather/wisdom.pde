/*

  Wisdom: Storage wisdom sayings and generate wisdom cards
  
  Reference:
  -- Quotes from Sebayt pharaonic Egyptian wisdom literature: https://en.wikipedia.org/wiki/Sebayt
  -- The 1200 BC Ramesside view immortality of the writer: https://www.ucl.ac.uk/museums-static/digitalegypt/literature/authorspchb.html
  
*/

class Wisdom {
  
  /* State */
  float alpha = 0;
  Boolean hasRun = false;
  Boolean hasCaptured = false;
  
  /* Data */
  PGraphics graphics;
  String quote;
  String[] quotes = { 
    "If you would only accomplish this, becoming expert in writing: Those writers of knowledge from the time of events after the gods, those who foretold the future, their names have become fixed for eternity, though they are gone, they have completed their lifespan, and all their kin are forgotten.", 
    "They did not make for themselves a chapel of copper, or a stela for it of iron from the sky. They did not manage to leave heirs, from their children, to pronounce their names, but they have achieved heirs out of writings, out of the teachings in those.", 
    "They are given the book as ritual-priest, The writing-board as loving-son. Teachings are their chapels, the writing-rush their child, and the block of stone the wife. From great to small, (all) are given as his children, for the writer, he is their leader.",
    "The doors of their chapels are undone, Their ka-priests have gone. Their tombstones are smeared with mud, their tombs are forgotten, but their names are read out on their scrolls, written when they were young. Being remembered makes them, to the limits of eternity.",
    "Be a writer - put it in your heart, and your name is created by the same. Scrolls are more useful than tombstones, than building a solid enclosure. They act as chapels and chambers, by the desire of the one pronouncing their name. For sure there is most use in the cemetery for a name in the mouths of men.",
    "A man is dead, his corpse is in the ground: when all his family are laid in the earth, It is writing that lets him be remembered, in the mouth of the reciter of the formula. Scrolls are more useful than a built house, than chapels on the west, they are more perfect than palace towers, longer-lasting than a monument in a temple.",
    "Is there anyone here like Hordedef? Is there another like Imhotep? There is no family born for us like Neferty, and Khety their leader. Let me remind you of the name of Ptahemdjehuty Khakheperraseneb. Is there another like Ptahhotep? Kaires too?",
    "Those who knew how to foretell the future, What came from their mouths took place, and may be found in (their) phrasing. They are given the offspring of others as heirs as if their (own) children. They hid their powers from the whole land, to be read in (their) teachings. They are gone, their names might be forgotten, but writing lets them be remembered."
  };
  
  Wisdom () {
    
  }
  
  void addLib (PGraphics pg) {
    
    graphics = pg;
  }
  
  void startCapture () {
    
    graphics.beginDraw();
    //saveFrame("test/frame-######.png");
    println("beginDraw");
    
  }
  
  void endCapture () {
    
    graphics.endDraw();
    println("endDraw");
    hasCaptured = true;
  }
  
  void showCard () {
    
     pushMatrix();
     scale(0.5);
     //tint(0, 0, 0, alpha);
     image(graphics, width / 2, 50); 
     popMatrix();
    
     if (hasCaptured) {
       
       println("has captured");
       
     } else {
       
       println("missing wisdom capture data");
     }
  }
  
  String getQuote () {
    
    if (!hasRun) {
    
      hasRun = true;
      int i = int(random(quotes.length));
      quote = quotes[i];
    }
    
    return quote;
  }
  
  void setAlpha (int a) {
    
    alpha = a;
  }
  
  void fadeIn (float speed) {
    
    if (alpha < 255) {  
        
        // Alpha is smaller than 255
        alpha += speed;
        
      } else {
        
        // Reset to 255 if larger
        if (alpha > 255) {
          alpha = 255;
        }
    }
  }
  
  void fadeOut (float speed) {
    
    if (alpha > 0) {
      
      // Alpha is bigger than 0
      alpha -= speed;
      
    } else {
      
      // Reset to 0 if smaller
      if (alpha < 0) {
        alpha = 0;
      }
    }
  }
}
