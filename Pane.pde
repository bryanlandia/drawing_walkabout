
class Pane {
  
  /*  
  describes a region of the sketch corresponding with the 
  window pane on which it will be projected.
  it can serve as a destination for figure movement. 
  its characteristics determine some figure behaviors. 
  a pane has a carrying capacity of figures.  
  carrying capacity is affected by:
  
  
  
  */
  
  float x, y;
  float width, height;
  ArrayList<DrawnFigure> paneFigs;
  int space;
  
  
  Pane(float posX, float posY, float w, float h) {
    space = paneHoldsFigs;
    x = posX;
    y = posY;
    width = w;
    height = h;
    paneFigs = new ArrayList<DrawnFigure>();
    
  }
  
}