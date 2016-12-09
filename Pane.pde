
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
  
  PVector getLastDrawnFigureEndPos() {
    try {
      DrawnFigure lastFigInPane = paneFigs.get(paneFigs.size()-1);
      return new PVector(lastFigInPane.rightestV.x, lastFigInPane.bottomV.y);
    }
    catch (ArrayIndexOutOfBoundsException e) {
      println("caught out of bounds in getLastDrawnFigurePos()");
      return new PVector(0,0);
    }
  }
  
  
}