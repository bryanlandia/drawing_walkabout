

class DrawnFigure {
  
  // reference the Processing applet
  PApplet p5;

  // parts of figure in group
  PShape gp;
  PShape body;
  PShape armL;
  PShape armR;
  PShape legL;
  PShape legR;
  PShape eyeL;
  PShape eyeR;
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
  
  // body parts
  boolean has_limbs = false;
  boolean has_eyes = false;
  
  DrawnFigure(PApplet p5ref) {
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
    
    PVector vert = new PVector(p5.mouseX, p5.mouseY); //<>//
    body.vertex(vert.x, vert.y);
    bodyVects.add(vert);
    
    // trace the outline so we can see what we are doing    
    p5.line(p5.pmouseX, p5.pmouseY, p5.mouseX, p5.mouseY);
  }
  
  
  void draw_complete() {
    // complete the body shape
    body.endShape(PConstants.CLOSE);
    gp.addChild(body);
    p5.shape(gp);
    drawnFigures.add(this);
    
    get_bounds_vecs();
  }
  
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
    //  if (x < p5.width) { 
    //    x += 1;
    //  }
    //}
  
}
  
  void add_limbs() {
    add_arms();
    add_legs();
    has_limbs = true;
  }
  
  void add_arms() {   
    // these need to be child shapes
    p5.pushStyle();
    p5.strokeWeight(7);
    p5.line(centerV.x, centerV.y + 20, centerV.x+35, centerV.y+65);
    p5.line(centerV.x + 35, centerV.y + 65, centerV.x+45, centerV.y+50); // hand
    p5.strokeWeight(6);
    p5.line(rightestV.x, rightestV.y, rightestV.x+20, rightestV.y+30);
    p5.line(rightestV.x+20, rightestV.y+30, rightestV.x+30, rightestV.y+20); //hand
    p5.popStyle();
  }
  
  void add_legs() {
    p5.pushStyle();
    p5.strokeWeight(5);
    // TODO: should really look (anti/)clockwise around the vectors from bottom
    p5.line(bottomV.x-10, bottomV.y, bottomV.x-13, bottomV.y+80);
    p5.line(bottomV.x-13, bottomV.y+80, bottomV.x, bottomV.y+80); //foot 
    p5.line(bottomV.x+10, bottomV.y, bottomV.x+13, bottomV.y+80);
    p5.line(bottomV.x+13, bottomV.y+80, bottomV.x+26, bottomV.y+80); //foot
    p5.popStyle();
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