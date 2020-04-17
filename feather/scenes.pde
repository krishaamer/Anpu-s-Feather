void intro () {

    background(0);
    if (story.time() > 0 && story.time() < 2.5) {
      
      message.say("Em heset net Anpu!");
      message.subtitle("Praise the God");
      message.fadeIn(10);
      
      nile.update();
    }
    
    if (story.time() > 2.5 && story.time() < 3.5) {
      
      message.say("Em heset net Anpu!");
      message.subtitle("Praise the God");
      message.fadeOut(10);
      
      nile.update();
    }
    
    if (story.time() > 3.5 && story.time() < 3.6) {
      
      message.setAlpha(0);
      nile.update();
    }
    
    if (story.time() > 3.6 && story.time() < 7) {
      
      message.say("I have been waiting for You");
      message.fadeIn(8);
      
      nile.update();
      nile.fadeOut();
      
      anubis.update();
      anubis.fadeIn();
    }
    
    if (story.time() > 4 && story.time() < 4.6) {
      anubis.option("redEyes");
    }
    
    if (story.time() > 7 && story.time() < 8.9) {
      
      message.say("I have been waiting for You");
      message.fadeOut(10);
      
      nile.update();
      nile.fadeOut();
      
      anubis.option("whiteEyes");
      anubis.update();
      anubis.fadeIn();
    }
    
    if (story.time() > 8.9 && story.time() < 9) {

      nile.update();
      nile.fadeOut();
      
      anubis.update();
      anubis.fadeOut();
      
      message.setAlpha(0);
    }
    
    if (story.time() > 9 && story.time() < 13) {
      
      nile.update();
      nile.fadeOut();
      
      anubis.update();
      anubis.fadeOut();

      message.say("How heavy is your heart?");
      message.fadeIn(8);
      
      parser.read_data();
      if (parser.isStreaming()) {
        scales.update();
        scales.fadeIn();
      }
    }
    
    if (story.time() > 13 && story.time() < 15) {
      
      message.say("How heavy is your heart?");
      message.fadeOut(8);
      
      parser.read_data();
      if (parser.isStreaming()) {
        scales.update();
        scales.fadeOut();
      }
    }
    
    if (story.time() > 15) {
      
      message.setAlpha(0);
      story.setMode("questions");
      story.resetTime();
    }
}

void questions () {
  
  background(0);
  
  if (story.time() > 0 && story.time() < 0.1) {
    
    qa.answerReset();
    message.setAlpha(0);
  }
  
  if (story.time() > 0.1 && story.time() < 3) {
      
    message.say("Have you cried this week?");
    message.fadeIn(8);
  }
  
  if (story.time() > 1) {
    
    parser.read_data();
    if (parser.isStreaming()) {
      
      qa.enableGestures();
      
      user.update();
      user.fadeIn();
    }
    
    message.say("Have you cried this week?");
    message.fadeOut(8);
      
    qa.ask();
    qa.fadeIn();
    
    if (qa.answer() == "YES") {
      
      message.setAlpha(0);
      story.resetTime();
      story.setMode("light");
    }
    
    if (qa.answer() == "NO") {
      
      message.setAlpha(0);
      story.resetTime();
      story.setMode("heavy");
    }
  }
}

void scales () {
  
  if (story.time() > 0 && story.time() < 0.1) {
    
     background(0);
     message.setAlpha(0);
  }
  
  if (story.time() > 0.1 && story.time() < 5) {
     
    parser.read_data();
    if (parser.isStreaming()) {

      scales.update();
      scales.fadeIn();
      
      message.countdown(6, story.time());
    }
  }
  
  if (story.time() > 5 && story.time() < 7) {
     
    parser.read_data();
    if (parser.isStreaming()) {
      
      scales.update();
      scales.fadeOut();
      
      message.countdown(6, story.time());
    }
    
    message.say("You have passed the test");
    message.fadeIn(8);
  }

  if (story.time() > 7 && story.time() < 10) {
    
    parser.read_data();
    if (parser.isStreaming()) {
      
      scales.update();
      scales.fadeOut();
    }
     
    message.say("You have passed the test");
    message.fadeOut(8);
  }
  
  // Go to next mode
  if (story.time() > 10) {
   
      message.setAlpha(0);
      story.resetTime();
      story.setMode("wisdom");
  }
}

void light () {
  
  // Reset
  if (story.time() > 0 && story.time() < 0.1) {
    
     background(0);
     message.setAlpha(0);
  }
  
  // Begin scene
  if (story.time() > 0.1 && story.time() < 0.5) {
     
    message.alert("YES", false);
  }
  
  if (story.time() > 0.5 && story.time() < 2.9) {
    
    background(0);
    message.say("Your heart seems light");
    message.fadeIn(5);
  }
  
  if (story.time() > 2.9 && story.time() < 4) {
     
    message.say("Your heart seems light");
    message.fadeOut(8);
  }
  
  if (story.time() > 4 && story.time() < 14) {
    
    blendMode(ADD);
    parser.read_data();
    if (parser.isStreaming()) {
      user.update();
    }
  }
  
  // Go to next mode
  if (story.time() > 14) {
   
      message.setAlpha(0);
      story.resetTime();
      story.setMode("scales");
  }
}

void heavy () {
  
  // Reset
  if (story.time() > 0 && story.time() < 0.1) {
    
     background(0);
     message.setAlpha(0);
  }
  
  // Begin scene
  if (story.time() > 0.1 && story.time() < 0.5) {
     
    message.alert("NO", true);
  }
  
  if (story.time() > 0.5 && story.time() < 1.5) {
   
    background(0);
    message.say("Your heart must be heavy");
    message.fadeIn(10);
  }
  
  if (story.time() > 1.5 && story.time() < 3) {
    
    background(0);
    message.say("Your heart must be heavy");
    message.fadeOut(8);
  }
  
  if (story.time() > 3 && story.time() < 8) {
   
    parser.read_data();
    if (parser.isStreaming()) {
      user.update();
      user.fadeIn();
    }
  }
  
  // Messages on top of the Model
  if (story.time() > 3 && story.time() < 3.1) {
    
     message.setAlpha(0);
  }
  
  if (story.time() > 3.1 && story.time() < 5) {
    
    message.say("Show me");
    message.fadeIn(8);
  }
  
  if (story.time() > 5 && story.time() < 6) {
    
    message.say("Show me");
    message.fadeOut(8);
  }
  
  // Go to next mode
  if (story.time() > 8) {
   
      message.setAlpha(0);
      story.resetTime();
      story.setMode("scales");
  }
}

void wisdom () {
  
  // Reset
  if (story.time() > 0 && story.time() < 0.1) {
    
     background(0);
     message.setAlpha(0);
  }
  
  // Begin scene
  if (story.time() > 0.1 && story.time() < 3) {
     
    message.say("The Wisdom Card will guide you");
    message.fadeIn(8);
  }

  if (story.time() > 3 && story.time() < 5) {
     
    message.say("The Wisdom Card will guide you");
    message.fadeOut(8);
  }
  
  // End
  if (story.time() > 5) {
   
      message.setAlpha(0);
      story.resetTime();
      story.setMode("outro");
  }
}

void outro () {
  
  // Reset
  if (story.time() > 0 && story.time() < 0.1) {
    
     background(0);
     message.setAlpha(0);
  }
  
  // Begin scene
  if (story.time() > 0.1 && story.time() < 3) {
    
    message.say("Ankhek!");
    message.subtitle("May you live");
    message.fadeIn(4);
  }

  if (story.time() > 3 && story.time() < 5) {
     
    message.say("Ankhek!");
    message.subtitle("May you live");
    message.fadeOut(4);
  }
  
  // The End
  if (story.time() > 5) {
   
      println("The end");
      message.setAlpha(0);
  }
}
