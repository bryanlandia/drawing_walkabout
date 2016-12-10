
class Pane {
  
  /*  
  describes a region of the sketch corresponding with the 
  window pane on which it will be projected.  
  */
  
  float x, y;
  float width, height;
  ArrayList<DrawnFigure> paneFigs;
  int spaces;
  String name;
  
  
  Pane(float posX, float posY, float w, float h) {
    spaces = paneHoldsFigs; //paneXSpots * paneYSpots;
    x = posX;
    y = posY;
    width = w;
    height = h;
    paneFigs = new ArrayList<DrawnFigure>();
    
  }
  
  void display() {
    
    //debug
    //pushStyle();
    //for (int i=0;i<paneFigs.size();i++) {
    //  stroke(white);
    //  strokeWeight(1);
    //  line(x+(width/2),y,paneFigs.get(i).x, paneFigs.get(i).y);
    //  textSize(32);
    //  text(i,10,10);
    //}
    
    //popStyle();
    
    //end debug
    
    pushStyle();
    stroke(black);
    strokeWeight(20);
    noFill();
    rect(x, y, width, height);
    popStyle();
  }
  
  void clear() {
    paneFigs.clear();
  }
  
  PVector getLastDrawnFigureEndPos() {
    try {
      DrawnFigure lastFigInPane = paneFigs.get(paneFigs.size()-1);
      return new PVector(lastFigInPane.rightestV.x, lastFigInPane.bottomV.y).add(figsInPaneSpaceBuffer,-figsInPaneSpaceBuffer).add(x,y);
    }
    catch (ArrayIndexOutOfBoundsException e) {
      println("caught out of bounds in getLastDrawnFigurePos()");
      return new PVector(x,y);
    }
  }
  
  
}