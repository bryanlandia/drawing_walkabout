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

class Head extends BodyPart {
  
  String direction;
  PShape headShape;
  
  Head(PApplet p5ref, DrawnFigure figParent, float posX, float posY) {
    p5 = p5ref;
    parentFig = figParent;
    x = posX;
    y = posY;
  }
  
  void update() {
  }
  
  void display() {
    float headW = constrain(parentFig.bodyWidth / 3, 20, 50);
    float headH = headW;
    headShape = p5.createShape(GROUP);
    PShape faceShape = p5.createShape(ELLIPSE, x, y, headW, headH);
    faceShape.setStroke(white);
    faceShape.setStrokeWeight(7);
    faceShape.setFill(gray);
    PShape strokeShape = p5.createShape(ELLIPSE, x, y, headW-7, headH-7); //7 is strokeWeight
    faceShape.setStroke(black);
    faceShape.setStrokeWeight(1);
    noFill();
    //faceShape.noFill();
    headShape.addChild(faceShape);
    headShape.addChild(strokeShape);    
  }
  
}


class Eye extends BodyPart {
  
  ArrayList<PVector> eyeVecs = new ArrayList<PVector>(); 
  HashMap<String,float[]> expressMap = new HashMap<String,float[]>() {{
     put("neutral_right", new float[] { PConstants.PI, PConstants.PI+(0.5*PConstants.QUARTER_PI) });
     put("neutral_left", new float[] { PConstants.PI, PConstants.PI+(0.5*PConstants.QUARTER_PI) });
  }};
  float[] expressionRads = new float[2];
  
  Eye(PApplet p5ref, DrawnFigure figParent, String sideLR, float posX, float posY) {
    this(p5ref, figParent, sideLR, posX, posY, "neutral_left");
  }
  
  Eye(PApplet p5ref, DrawnFigure figParent, String sideLR, float posX, float posY, String expression) {
    super();
    p5 = p5ref;
    parentFig = figParent;
    side = sideLR;
    x = posX;
    y = posY; 
    lineThickness = 2;
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
      limbshape.setStroke(black);
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
  
    //dirSideOffsetVec.put("leftL", new PVector(figParent.bodyWidth/2, figParent.bodyHeight/2));
    dirSideOffsetVec.put("leftL", new PVector(0,10));
    //dirSideOffsetVec.put("leftR", new PVector(0, figParent.bodyHeight/2));
    dirSideOffsetVec.put("leftR", new PVector(-15, 10));
    
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
    limbshape.scale(0.4);
    //limbshape.disableStyle();
    limbshape.setFill(white);
    limbshape.setStroke(black);
    limbshape.rotate( side =="R" ? -1 * parentFig.rotation: parentFig.rotation); //rotate for correction direction
    //if (parentFig.armsMirrorY) limbshape.scale(-1,1); // transform for correct direction
    if (side=="R") limbshape.scale(-1,1); // transform for correct direction
    limbshape.rotate(radians(random(-5,5))); // add some randomness    
    //p5.pushStyle();
    p5.shape(limbshape);
    limbshape.setVisible(true);
    //p5.popStyle();
  }
    
}


class Leg extends Limb {
  PVector dirRStartOffsetL, dirRStartOffsetR;
  PVector dirLStartOffsetL, dirLStartOffsetR;
  HashMap<String,PVector> dirSideOffsetVec = new HashMap<String,PVector>();
  
  
  Leg(PApplet p5ref, DrawnFigure figParent, String sideLR, float posX, float posY) {
     super(p5ref, figParent, sideLR, posX, posY);
    
    // arm shape positions based on side and direction of fig
    dirSideOffsetVec.put("rightL", new PVector(figParent.bodyWidth, figParent.bodyHeight/2));
    dirSideOffsetVec.put("rightR", new PVector(figParent.bodyWidth/2, figParent.bodyHeight/2));
  
    //dirSideOffsetVec.put("leftL", new PVector(figParent.bodyWidth/2, figParent.bodyHeight/2));
    dirSideOffsetVec.put("leftL", new PVector(20,-10));
    //dirSideOffsetVec.put("leftR", new PVector(0, figParent.bodyHeight/2));
    dirSideOffsetVec.put("leftR", new PVector(-20, -10));
    
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
    limbshape = createShape(p5, legShape);
    limbshape.setVisible(false);
    limbshape.translate(limbVecs.get(0).x, limbVecs.get(0).y);
    limbshape.scale(0.7);
    //limbshape.disableStyle();
    limbshape.setFill(white);
    limbshape.setStroke(black);
    //limbshape.rotate( side =="R" ? -1 * parentFig.rotation: parentFig.rotation); //rotate for correction direction
    //if (parentFig.armsMirrorY) limbshape.scale(-1,1); // transform for correct direction
    if (side=="R") limbshape.scale(-1,1); // transform for correct direction
    limbshape.rotate(radians(random(-5,5))); // add some randomness    
    //p5.pushStyle();
    p5.shape(limbshape);
    limbshape.setVisible(true);
    //p5.popStyle(); 
  }    
}
  