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
    
    if (story.time() > 4 && story.time() < 5.5) {
      anubis.option("redEyes");
      anubis.featureFadeIn();
    }
    
    if (story.time() > 5.5 && story.time() < 7) {
      anubis.option("redEyes");
      anubis.featureFadeOut();
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
        
        scales.startFrom("top");
        scales.update();
        scales.fadeIn();
      }
    }
    
    if (story.time() > 13 && story.time() < 16) {
      
      message.say("How heavy is your heart?");
      message.fadeOut(8);
      
      parser.read_data();
      if (parser.isStreaming()) {
        
        scales.startFrom("middle");
        scales.update();
        scales.fadeOut();
      }
    }
    
    if (story.time() > 16) {
      
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
  
  if (story.time() > 0.1 && story.time() < 7) {
     
    blendMode(BLEND);
    parser.read_data();
    if (parser.isStreaming()) {

      scales.update();
      scales.fadeIn();
      message.countdown(7, story.time());
    }
  }
  
  // Messages on top of the Model  
  if (story.time() > 7 && story.time() < 8) {
    
    background(0);
    message.say("You have passed the test");
    message.fadeIn(8);
  }
  
  if (story.time() > 8 && story.time() < 9) {
    
    message.say("You have passed the test");
    message.fadeOut(8);
  }
  
  // Go to next mode
  if (story.time() > 8) {
   
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
     
    background(0);
    message.alert("YES", false);
  }
  
  if (story.time() > 0.5 && story.time() < 2) {
    
    background(0);
    message.say("Your heart seems light");
    message.fadeIn(8);
  }
  
  if (story.time() > 2 && story.time() < 3) {
     
    background(0);
    message.say("Your heart seems light");
    message.fadeOut(8);
  }
  
  if (story.time() > 3 && story.time() < 3.1) {
    
     background(0);
     message.setAlpha(0);
  }
  
  if (story.time() > 3.2 && story.time() < 4) {
    
    background(0);
    message.say("Show me");
    message.fadeIn(30);
  }
  
  if (story.time() > 4 && story.time() < 4.9) {
    
    background(0);
    message.say("Show me");
    message.fadeOut(30);
  }
    
  if (story.time() > 4.9 && story.time() < 5) {
    
     message.setAlpha(0);
  }
  
  if (story.time() > 0.1 && story.time() < 19.9) {
    
    blendMode(ADD);
    parser.read_data();
    if (parser.isStreaming()) {
      user.update();
      user.fadeIn();
    }
  }
  
  // Capture image at the end of scene
  if (story.time() > 5 && story.time() < 20) {
    
    user.startCapture();
  }
  
  // Go to next mode
  if (story.time() > 20) {
   
      user.endCapture();
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
  
  if (story.time() > 3 && story.time() < 13) {
   
    blendMode(BLEND);
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
  
  // Capture image at the end of scene
  if (story.time() > 6 && story.time() < 13) {
    
    wisdom.startCapture();
  }
  
  // Go to next mode
  if (story.time() > 13) {
   
      wisdom.endCapture();
      message.setAlpha(0);
      story.resetTime();
      story.setMode("scales");
  }
}

void wisdom () {
  
  // Get Data
  String wisdomQuote = wisdom.getQuote();
  
  // Reset
  if (story.time() > 0 && story.time() < 0.1) {
    
     background(0);
     message.setAlpha(0);
  }
  
  // Begin scene
  if (story.time() > 0.1 && story.time() < 3) {
    
    background(0);
    message.say("Sebayt");
    message.subtitle("Wisdom will guide you");
    message.fadeIn(8);
  }

  if (story.time() > 3 && story.time() < 4) {
     
    background(0);
    message.say("Sebayt");
    message.subtitle("Wisdom will guide you");
    message.fadeOut(8);
  }
  
  if (story.time() > 4 && story.time() < 4.1) {
     
    background(0);
    message.setAlpha(0);
  }

  if (story.time() > 4.2 && story.time() < 13) {
     
    background(0);
    wisdom.showCard();
    wisdom.fadeIn(8);
  }

  if (story.time() > 13 && story.time() < 15) {
     
    background(0);
    wisdom.showCard();
    wisdom.fadeOut(8);
  }

  // End
  if (story.time() > 15) {
   
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
    
    background(0);
    message.say("Ankhek!");
    message.subtitle("May you live");
    message.fadeIn(4);
  }

  if (story.time() > 3 && story.time() < 6) {
    
    background(0);
    message.say("Ankhek!");
    message.subtitle("May you live");
    message.fadeOut(6);
  }
  
  // The End
  if (story.time() > 6) {
   
      println("The end");
      background(0);
      message.setAlpha(0);
  }
}
