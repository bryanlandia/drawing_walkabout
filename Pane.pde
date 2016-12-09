
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
  ArrayList<Food> paneFoods = new ArrayList<Food>();
  float space;
  
}