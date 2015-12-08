class Ball {
  
  float x, y;
  float diameter;
  int id;
  float hue; 
  String stateName;
  String Abr;
  float endX;
  float endY;
 
  Ball(float x, float y, float din, int idin, float colHue, String stateAbr, String state) {
    x = x;
    y = y;
    endX = x;
    endY = y;
    diameter = din;
    id = idin;
    hue = colHue;
    stateName = state;
    Abr = stateAbr;
  } 
  
  void display() {
    fill(hue,200,200,122.5);
    noStroke();
        
    x = x + (endX - x) * damping;
    y = y + (endY - y) * damping;
    
    ellipse(x, y, diameter, diameter);
    fill(255);
    textAlign(CENTER,CENTER);
    text(Abr, x,y);
    
  }
  
   void position(float x, float y)
   {
     endX = x;
     endY = y;
     
     println(endX);
   }

  
}
