

class DrawnFigure extends PShape {
  
  // reference the Processing applet
  PApplet p5;

  // parts of figure in group
  PShape gp;
  PShape body;
  Arm leftArm;
  Arm rightArm;
  Leg leftLeg;
  Leg rightLeg;
  PShape leftEye;
  PShape rightEye;
  ArrayList<PVector> bodyVects = new ArrayList<PVector>();
  ArrayList<DrawnFigure> drawnFigures;
  
  // Its location
  float x;
  float y;
  
  // Its L,R, Top, Bottom bounds
  PVector topV;
  PVector bottomV;
  PVector leftestV;
  PVector rightestV;
  PVector centerV;

  
  // when it was added
  int added_time;
  
  // has body parts
  boolean has_limbs = false;
  boolean has_eyes = false;
  
  DrawnFigure(PApplet p5ref) {
    super();
    p5 = p5ref;
    added_time = p5.millis();
    x = p5.mouseX;
    y = p5.mouseY; 
    gp = p5.createShape(PConstants.GROUP);
    body = p5.createShape();
    body.beginShape(PConstants.QUAD_STRIP);
    body.stroke(239);
    body.strokeWeight(10);
    body.fill(100);
  }

  void draw_listen() {
    // as a line is made with the pen, show a line and record vertices
    // as Vectors for body shape    
    
    PVector vect = new PVector(p5.mouseX, p5.mouseY); //<>// //<>//
    body.vertex(vect.x, vect.y);
    bodyVects.add(vect);
    
    // trace the outline so we can see what we are doing    
    p5.line(p5.pmouseX, p5.pmouseY, p5.mouseX, p5.mouseY);
    // after creation, get rid of this line
  }
  
  
  void draw_complete() {
    // complete the body shape
    body.endShape(PConstants.CLOSE);
    gp.addChild(body);
    p5.shape(gp);
    drawnFigures.add(this);
    
    get_bounds_vecs();
    p5.clear(); // clear the draw line, DrawnFigures will get displayed again
  }
   //<>//
  void get_bounds_vecs() {
    topV = body.getVertex(0); //<>//
    bottomV = body.getVertex(0);
    leftestV = body.getVertex(0);
    rightestV = body.getVertex(0);
    centerV = new PVector();
    
    for (int j=0; j< body.getVertexCount(); j++) {
      PVector v = body.getVertex(j);
      if (v.y > bottomV.y) bottomV = body.getVertex(j);
      if (v.x < leftestV.x) leftestV = body.getVertex(j);
      if (v.x > rightestV.x) rightestV = body.getVertex(j);
      if (v.y < topV.y) topV = body.getVertex(j);
    }
    centerV.x = (rightestV.x - leftestV.x)/2 + leftestV.x;
    centerV.y = (bottomV.y - topV.y)/2 + topV.y;

  }
  
  void update() {
    int now_ms = p5.millis();
    if (now_ms - added_time > 3000) {
      if (has_limbs == false) add_limbs();
    }
    if (now_ms - added_time > 4000) {
      if (has_eyes == false) add_eyes();
    }
    
    //if (has_eyes && has_limbs) {
      
      if (x < p5.width) {   
        gp.translate(1,0);
        x+=1;
        //println(x);
      }
    //}
  
}

  void display() {
    // redisplay the DrawnFigure
    p5.shape(gp);
    if (has_limbs) {
      leftArm.display();
      rightArm.display();
      leftLeg.display();
      rightLeg.display();
    }
  }
  
  void add_limbs() {
    add_arms();
    add_legs();
    has_limbs = true;
  }
  
  void add_arms() {
    leftArm = new Arm(p5, this, 'L', centerV.x, centerV.y + 20);
    rightArm = new Arm(p5, this, 'R', rightestV.x, rightestV.y);
    leftArm.renderWithShape();
    rightArm.renderWithShape();
    gp.addChild(leftArm.shape);
    gp.addChild(rightArm.shape);
    println("leftArm:"+leftArm.shape);
    //println("leftArm:"+leftArm.shape);
    
  }
  
  void add_legs() {
    leftLeg = new Leg(p5, this, 'L', bottomV.x-10, bottomV.y);
    rightLeg = new Leg(p5, this, 'R', bottomV.x+10, bottomV.y);
    leftLeg.renderWithShape();
    rightLeg.renderWithShape();
    gp.addChild(leftLeg.shape);
    gp.addChild(rightLeg.shape);
  }
  
  void add_eyes() {
    PVector eyesV = new PVector();    
    
    eyesV.x = p5.constrain(rightestV.x -20, leftestV.x + 5, rightestV.x - 20);
    eyesV.y = centerV.y - 5;

    p5.pushStyle();
    p5.strokeWeight(3);
    p5.noFill();
    
    p5.arc(eyesV.x - 5, eyesV.y, 20, 20, PI, PI+QUARTER_PI);
    p5.arc(eyesV.x + 5, eyesV.y, 20, 20, PI, PI+QUARTER_PI);
    p5.popStyle();
    has_eyes = true;
  }
  

}