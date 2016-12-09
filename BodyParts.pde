import java.util.Map;


class BodyPart extends PShape {
  
  PApplet p5;
  DrawnFigure parentFig;
  
  PShape limbshape;

  // Its location (relative to parent)
  float x; // x position of limb start 
  float y; // y position of limb start
  String side; // L, R
  int lineThickness;
  int arcRadius;
  
  /* 
  will have some other properties relating to positioning,
  attitude, etc.
  */
    
}