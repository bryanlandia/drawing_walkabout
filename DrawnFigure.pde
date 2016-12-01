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
  
  // Its location
  float x;
  float y;
  
  DrawnFigure(PApplet p5ref) {
    p5 = p5ref;
    x = p5.mouseX;
    y = p5.mouseY; 
    gp = p5.createShape(PConstants.GROUP);
    body = p5.createShape();
    body.beginShape(PConstants.QUAD_STRIP);
    body.stroke(239);
    body.strokeWeight(p5.penPress * p5.tablet.getPressure());
    body.fill(floor(map(p5.tablet.getPressure(), 0, 1, 0, 255)));
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
    body.endShape();
    gp.addChild(body);
    p5.shape(gp);  
    //p5.drawnFigures.add(gp);
  }
  

}