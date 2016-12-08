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


class Eye extends BodyPart {
  
  ArrayList<PVector> eyeVecs = new ArrayList<PVector>(); 
  HashMap<String,float[]> expressMap = new HashMap<String,float[]>() {{
     put("neutral_right", new float[] { PConstants.PI, PConstants.PI+PConstants.QUARTER_PI });
     put("neutral_left", new float[] { PConstants.PI, PConstants.PI+PConstants.QUARTER_PI });
  }};
  float[] expressionRads = new float[2];
  
  
  Eye(PApplet p5ref, DrawnFigure figParent, String sideLR, float posX, float posY, String expression) {
    super();
    p5 = p5ref;
    parentFig = figParent;
    side = sideLR;
    x = posX;
    y = posY; 
    lineThickness = 6;
    arcRadius = 50; 
    expressionRads = expressMap.get(expression);
    //println("Expression was "+expression+" and expressRads vals are:"+expressionRads[0]+","+expressionRads[1]);
    // can probably do away with an ArrayList here but keep for now
    //eyeVecs.add(new PVector(parentFig.centerV.x + offset, parentFig.centerV.y));
  }

  //void setShapeVecs() {}
  
  void display() {
      //setShapeVecs();
      limbshape = p5.createShape(ARC, x, y, arcRadius, arcRadius, expressionRads[0], expressionRads[1], OPEN);
      limbshape.setStroke(white);
      limbshape.setStrokeWeight(lineThickness);
  } 
  
  void update() {}  
  
}


class Limb extends BodyPart {
  // ideally would extend PShape
  
  //its vectors
  ArrayList<PVector> limbVecs = new ArrayList<PVector>();  
  PVector startPoint, leftStartPoint, rightStartPoint;
  String dirAndSide; // combination of figure.direction and figure.side
  
  Limb(PApplet p5ref, DrawnFigure figParent, String sideLR, float posX, float posY) {
      super();
      p5 = p5ref;
      parentFig = figParent;
      side = sideLR;
      dirAndSide = parentFig.direction + side; //e.g, "rightL", "rightR", "upR", "upL"
      x = posX;
      y = posY;    
      
  }
  
  // have to define this as empty function so that renderWithShape can then go find
  // the override version in the subclass
  void setShapeVecs() {}
  
  void display() {
      setShapeVecs();
      limbshape = p5.createShape();
      limbshape.beginShape(PConstants.QUAD_STRIP);
      limbshape.stroke(white);
      limbshape.fill(0);
      limbshape.strokeWeight(lineThickness);
      for (int i=0;i<limbVecs.size();i++) {
        //println("Adding vertices to limb");
        PVector vect = limbVecs.get(i);
        limbshape.vertex(vect.x, vect.y);
      }
      limbshape.endShape(PConstants.OPEN);   
  } 
  
  void update() {}
        
}


class Arm extends Limb {
  
  PVector dirRStartOffsetL, dirRStartOffsetR;
  PVector dirLStartOffsetL, dirLStartOffsetR;
  HashMap<String,PVector> dirSideOffsetVec = new HashMap<String,PVector>();
  
  
  Arm(PApplet p5ref, DrawnFigure figParent, String sideLR, float posX, float posY) {
     super(p5ref, figParent, sideLR, posX, posY);
    
    // arm shape positions based on side and direction of fig
    dirSideOffsetVec.put("rightL", new PVector(figParent.bodyWidth, figParent.bodyHeight/2));
    dirSideOffsetVec.put("rightR", new PVector(figParent.bodyWidth/2, figParent.bodyHeight/2));
  
    dirSideOffsetVec.put("leftL", new PVector(figParent.bodyWidth/2, figParent.bodyHeight/2));
    dirSideOffsetVec.put("leftR", new PVector(0, figParent.bodyHeight/2));
    
    dirSideOffsetVec.put("upL", new PVector(0, figParent.bodyHeight/2));
    dirSideOffsetVec.put("upR", new PVector(figParent.bodyWidth, figParent.bodyHeight/2));
    
    //down can be like up but will be rotated differently
    dirSideOffsetVec.put("downL", dirSideOffsetVec.get("upL"));
    dirSideOffsetVec.put("downR", dirSideOffsetVec.get("upR"));
    
  }     
  
  // wasn't able to do this in the superclass.... :(
  void setShapeVecs() {
    /* when doing the below in the Limb constructor wasn't getting
      the subclasses' overrides of leftStartOffsets, rightStartOffsets
    */
    
      PVector startOffset = dirSideOffsetVec.get(dirAndSide);               
      PVector vec1;
      vec1 = new PVector(x + startOffset.x, y + startOffset.y);
      limbVecs.add(vec1);   
  }  
  
  void display() {
    setShapeVecs();
    limbshape = createShape(p5, armShape);
    limbshape.setVisible(false);
    limbshape.translate(limbVecs.get(0).x, limbVecs.get(0).y);
    limbshape.scale(1.25);
    limbshape.disableStyle();
    limbshape.rotate(parentFig.rotation); //rotate for correction direction
    if (parentFig.armsMirrorY) limbshape.scale(1, -1); // transform for correct direction
    //limbshape.rotate(radians(random(-15,15))); // add some randomness    
    //p5.pushStyle();
    p5.shape(limbshape);
    limbshape.setVisible(true);
    //p5.popStyle();
  }
    
}


class Leg extends Limb {
  
  int lineThickness = 5;
  float[][] leftStartOffsets = { {-10.0, -13.0, 0}, {0.0, 80.0, 80.0} };
  float[][] rightStartOffsets = { {10.0, 13.0, 26.0}, {0.0, 80.0, 80.0} };
  
  Leg(PApplet p5ref, DrawnFigure parentFig, String sideLR, float posX, float posY) {
     super(p5ref, parentFig, sideLR, posX, posY);
  }  
  
  // wasn't able to do this in the superclass.... :(
  void setShapeVecs() {
    /* when doing the below in the Limb constructor wasn't getting
      the subclasses' overrides of leftStartOffsets, rightStartOffsets
    */
    
      float[][] startOffsets = new float[3][3];
            
      switch(side) {
        case "L":
          //println("using leftStartOffsets as startOffsets");
          startOffsets = arrayCopyMultiDim(leftStartOffsets, startOffsets);
          break;
       
        case "R":
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
  