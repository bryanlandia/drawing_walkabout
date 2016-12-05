
class Limb {
  // ideally would extend PShape
 
  PApplet p5;
  DrawnFigure figParent;
  
  PShape shape;
  
  //its vectors
  ArrayList<PVector> limbVecs = new ArrayList<PVector>();
 
  // Its location (relative to parent)
  float x; // x position of limb start 
  float y; // y position of limb start
  char side; // L, R
  int lineThickness;
  /* 
  will have some other properties relating to positioning,
  attitude, etc.
  */
  
  PVector startPoint, leftStartPoint, rightStartPoint;
  float[][] leftStartOffsets = new float[3][3];
  float[][] rightStartOffsets = new float[3][3];       
  
  Limb(PApplet p5ref, DrawnFigure parentFig, char sideLR, float posX, float posY) {
      super();
      p5 = p5ref;
      figParent = parentFig;
      side = sideLR;
      x = posX;
      y = posY;    
      
      float[][] startOffsets = new float[3][3];
      
      switch(side) {
      case 'L':          
        startOffsets = leftStartOffsets;
     
      case 'R':
        startOffsets = rightStartOffsets;
      }
     
      PVector vec1, vec2, vec3;
      vec1 = new PVector(x + startOffsets[0][0], y + startOffsets[1][0]);
      vec2 = new PVector(x + startOffsets[0][1], y + startOffsets[1][1]);
      vec3 = new PVector(x + startOffsets[0][2], y + startOffsets[1][2]);
      limbVecs.add(vec1);
      limbVecs.add(vec2);
      limbVecs.add(vec3);    
  }
  
  void renderWithShape() {
      shape = p5.createShape();
      shape.beginShape();
      shape.stroke(239);
      shape.fill(255);
      shape.strokeWeight(lineThickness);
      for (int i=0;i<limbVecs.size();i++) {
        PVector vect = limbVecs.get(i);
        shape.vertex(vect.x, vect.y);
      }
      shape.endShape(CLOSE);    
  } 
  
  void update() {}
  
  void display() {
    p5.shape(shape);
  }

}


class Arm extends Limb {
  
  int lineThickness = 7;
  float[][] leftStartOffsets = { {0.0, 35.0, 45.0}, {20.0, 65.0, 55.0} };
  float[][] rightStartOffsets = { {0.0, 20.0, 30.0}, {0.0, 30.0, 20.0} };
  
  Arm(PApplet p5ref, DrawnFigure parentFig, char sideLR, float posX, float posY) {
     super(p5ref, parentFig, sideLR, posX, posY);
  }     
}

  
class Leg extends Limb {
  
  int lineThickness = 5;
  float[][] leftStartOffsets = { {-10.0, -13.0, 0}, {0.0, 80.0, 80.0} };
  float[][] rightStartOffsets = { {10.0, 13.0, 26.0}, {0.0, 80.0, 80.0} };
  
  Leg(PApplet p5ref, DrawnFigure parentFig, char sideLR, float posX, float posY) {
     super(p5ref, parentFig, sideLR, posX, posY);
  }  
}
  