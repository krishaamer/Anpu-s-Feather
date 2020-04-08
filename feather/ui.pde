/*

  Collection of UI elements
*/

class UI {
  
  UI () {
    
  }
  
  void draw_box() {
    
   PVector b1 = new PVector(-287, -287, -287);
   PVector b2 = new PVector(288, -287, -287);
   PVector b3 = new PVector(288, 288, -287);
   PVector b4 = new PVector(-287, 288, -287);
   PVector b5 = new PVector(-287, -287, 288);
   PVector b6 = new PVector(288, -287, 288);
   PVector b7 = new PVector(288, 288, 288);
   PVector b8 = new PVector(-287, 288, 288);
   
   stroke(255, 0, 0);
   strokeWeight(1);
   beginShape(LINES);
   vertex(b1.x, b1.y, b1.z);  
   vertex(b2.x, b2.y, b2.z);
   vertex(b3.x, b3.y, b3.z);  
   vertex(b2.x, b2.y, b2.z);
   vertex(b3.x, b3.y, b3.z);  
   vertex(b4.x, b4.y, b4.z);
   vertex(b1.x, b1.y, b1.z);  
   vertex(b4.x, b4.y, b4.z);
   vertex(b1.x, b1.y, b1.z);  
   vertex(b5.x, b5.y, b5.z);
   vertex(b6.x, b6.y, b6.z);  
   vertex(b2.x, b2.y, b2.z);
   vertex(b7.x, b7.y, b7.z);  
   vertex(b3.x, b3.y, b3.z);
   vertex(b8.x, b8.y, b8.z);  
   vertex(b4.x, b4.y, b4.z);
   vertex(b5.x, b5.y, b5.z);  
   vertex(b6.x, b6.y, b6.z);
   vertex(b7.x, b7.y, b7.z);  
   vertex(b6.x, b6.y, b6.z);
   vertex(b7.x, b7.y, b7.z);  
   vertex(b8.x, b8.y, b8.z);
   vertex(b5.x, b5.y, b5.z);  
   vertex(b8.x, b8.y, b8.z);
   endShape();
  
  }
  
}
