import java.util.Map;


class BodyPart extends PShape {
  
  PApplet p5;
  DrawnFigure figParent;
  
  PShape lshape;

  // Its location (relative to parent)
  float x; // x position of limb start 
  float y; // y position of limb start
  char side; // L, R
  int lineThickness;
  int arcRadius;
  
  /* 
  will have some other properties relating to positioning,
  attitude, etc.
  */
    
}


class Eye extends BodyPart {
  
  ArrayList<PVector> eyeVecs = new ArrayList<PVector>(); 
  HashMap<String,float[]> expressMap = new HashMap<String,float[]>() {{
     put("neutral_right", new float[] { PConstants.PI, PConstants.PI+PConstants.QUARTER_PI });
     put("neutral_left", new float[] { PConstants.PI, PConstants.PI+PConstants.QUARTER_PI });
  }};
  float[] expressionRads = new float[2];
  
  
  Eye(PApplet p5ref, DrawnFigure parentFig, char sideLR, float posX, float posY, String expression) {
    super();
    p5 = p5ref;
    figParent = parentFig;
    side = sideLR;
    x = posX;
    y = posY; 
    lineThickness = 5;    
    arcRadius = 30; 
    expressionRads = expressMap.get(expression);
    //println("Expression was "+expression+" and expressRads vals are:"+expressionRads[0]+","+expressionRads[1]);
    // can probably do away with an ArrayList here but keep for now
    //eyeVecs.add(new PVector(parentFig.centerV.x + offset, parentFig.centerV.y));
  }

  //void setShapeVecs() {}
  
  void display() {
      //setShapeVecs();
      lshape = p5.createShape(ARC, x, y, arcRadius, arcRadius, expressionRads[0], expressionRads[1], OPEN);
      lshape.setStroke(239);
      lshape.setStrokeWeight(lineThickness);
  } 
  
  void update() {}  
  
}


class Limb extends BodyPart {
  // ideally would extend PShape
  
  //its vectors
  ArrayList<PVector> limbVecs = new ArrayList<PVector>();  
  PVector startPoint, leftStartPoint, rightStartPoint;
  //float[][] leftStartOffsets;
  //float[][] rightStartOffsets;
  
  Limb(PApplet p5ref, DrawnFigure parentFig, char sideLR, float posX, float posY) {
      super();
      p5 = p5ref;
      figParent = parentFig;
      side = sideLR;
      x = posX;
      y = posY;    
      
  }
  
  // have to define this as empty function so that renderWithShape can then go find
  // the override version in the subclass
  void setShapeVecs() {}
  
  void display() {
      setShapeVecs();
      lshape = p5.createShape();
      lshape.beginShape(PConstants.QUAD_STRIP);
      lshape.stroke(239);
      lshape.fill(0);
      lshape.strokeWeight(lineThickness);
      for (int i=0;i<limbVecs.size();i++) {
        println("Adding vertices to limb");
        PVector vect = limbVecs.get(i);
        lshape.vertex(vect.x, vect.y);
      }
      lshape.endShape(PConstants.OPEN);   
  } 
  
  void update() {}
  
}


class Arm extends Limb {
  
  int lineThickness = 7;
  float[][] leftStartOffsets = { {0.0, 35.0, 45.0}, {20.0, 65.0, 55.0} };
  float[][] rightStartOffsets = { {0.0, 20.0, 30.0}, {0.0, 30.0, 20.0} };
  
  Arm(PApplet p5ref, DrawnFigure parentFig, char sideLR, float posX, float posY) {
     super(p5ref, parentFig, sideLR, posX, posY);
  }     
  
  // wasn't able to do this in the superclass.... :(
  void setShapeVecs() {
    /* when doing the below in the Limb constructor wasn't getting
      the subclasses' overrides of leftStartOffsets, rightStartOffsets
    */
    
      float[][] startOffsets = new float[3][3];
           
      switch(side) {
        case 'L':
          println("using leftStartOffsets as startOffsets");
          startOffsets = arrayCopyMultiDim(leftStartOffsets, startOffsets);
          break;
       
        case 'R':
          println("using rightStartOffsets as startOffsets");
          startOffsets = arrayCopyMultiDim(rightStartOffsets, startOffsets);
          break;
      }
          
      PVector vec1, vec2, vec3;
      vec1 = new PVector(x + startOffsets[0][0], y + startOffsets[1][0]);
      vec2 = new PVector(x + startOffsets[0][1], y + startOffsets[1][1]);
      vec3 = new PVector(x + startOffsets[0][2], y + startOffsets[1][2]);
      limbVecs.add(vec1);
      limbVecs.add(vec2);
      limbVecs.add(vec3);    
      println("vec1 is x,y: "+vec1.x + ","+vec1.y);
      println("vec2 is x,y: "+vec2.x + ","+vec2.y);
      println("vec3 is x,y: "+vec3.x + ","+vec3.y);
    
  }  
}


class Leg extends Limb {
  
  int lineThickness = 5;
  float[][] leftStartOffsets = { {-10.0, -13.0, 0}, {0.0, 80.0, 80.0} };
  float[][] rightStartOffsets = { {10.0, 13.0, 26.0}, {0.0, 80.0, 80.0} };
  
  Leg(PApplet p5ref, DrawnFigure parentFig, char sideLR, float posX, float posY) {
     super(p5ref, parentFig, sideLR, posX, posY);
  }  
  
  // wasn't able to do this in the superclass.... :(
  void setShapeVecs() {
    /* when doing the below in the Limb constructor wasn't getting
      the subclasses' overrides of leftStartOffsets, rightStartOffsets
    */
    
      float[][] startOffsets = new float[3][3];
            
      switch(side) {
        case 'L':
          //println("using leftStartOffsets as startOffsets");
          startOffsets = arrayCopyMultiDim(leftStartOffsets, startOffsets);
          break;
       
        case 'R':
          //println("using rightStartOffsets as startOffsets");
          startOffsets = arrayCopyMultiDim(rightStartOffsets, startOffsets);
          break;
      }
          
      PVector vec1, vec2, vec3;
      vec1 = new PVector(x + startOffsets[0][0], y + startOffsets[1][0]);
      vec2 = new PVector(x + startOffsets[0][1], y + startOffsets[1][1]);
      vec3 = new PVector(x + startOffsets[0][2], y + startOffsets[1][2]);
      limbVecs.add(vec1);
      limbVecs.add(vec2);
      limbVecs.add(vec3);    
      //println("vec1 is x,y: "+vec1.x + ","+vec1.y);
      //println("vec2 is x,y: "+vec2.x + ","+vec2.y);
      //println("vec3 is x,y: "+vec3.x + ","+vec3.y);
    
  }    
}
  