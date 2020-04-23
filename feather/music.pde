/*

  Music: Control the soundtrack
  
  Reference:
  -- Copyright Free music "Anubis" by Lucha and R3VXS: https://www.youtube.com/watch?v=HrszBzkxtCM
  
*/

class Music {
  
  SoundFile sound;
  float volume = 1.0;
  
  Music () {
    
  }
  
  void load (SoundFile sf) {
    
    sound = sf;
  }
  
  void play () {
 
    if (!sound.isPlaying()) {
      
      // Reset volume
      volume = 1.0;
      
      // Play
      sound.amp(volume);
      sound.play();
    }
  }
  
  void fadeOut () {

    if (sound.isPlaying() && volume > 0) { 
      
      volume -= 0.05;
      sound.amp(volume);
    }
  }
  
  void end () {
   
    if (sound.isPlaying()) {
      sound.stop();
    }
  }
}
