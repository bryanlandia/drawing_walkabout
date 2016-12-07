

class DrawnFigure extends PShape {
  
  // reference the Processing applet
  PApplet p5;

  PImage skin;

  // parts of figure in group
  PShape gp;
  PShape body;
  Arm leftArm;
  Arm rightArm;
  Leg leftLeg;
  Leg rightLeg;
  Eye leftEye;
  Eye rightEye;
  ArrayList<PVector> bodyVects = new ArrayList<PVector>();
  
  ArrayList<DrawnFigure> drawnFigures;
  
  // Its location
  float x;
  float y;
  
  // Its location relative to drawing PGraphics
  float drawx;
  float drawy;
  
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
  boolean has_skin = false;
  
  PGraphics maskCanvas;
  PImage maskImage;

  
  DrawnFigure(PApplet p5ref) {
    super();
    p5 = p5ref;
    added_time = p5.millis();
    x = p5.mouseX;
    y = p5.mouseY; 
    drawx = 0;
    drawy = 0;
    gp = p5.createShape(PConstants.GROUP);
    gp.beginShape();
    body = p5.createShape();
    body.beginShape();
    //body.texture(skin);
    body.stroke(239);
    body.strokeWeight(10);
    body.fill(100);
    
    // start listening for drawing as soon as we initialize 
    drawg.beginDraw();    
    drawg.background(drawbgColor); // TMP
    
    // make an additional canvas from which to generate the 
    // video image masking img
    maskCanvas = createGraphics(600, 600, P2D);

  } //<>//

  void draw_listen() {
    // trace the outline so we can see what we are doing
    // as a line is made with the pen, show a line and record vertices
    // as Vectors for body shape    
    maskCanvas.beginDraw();
    maskCanvas.beginShape();
    maskCanvas.noStroke();
    maskCanvas.fill(255);
    maskCanvas.background(0);
    
    PVector vect = new PVector(p5.mouseX, p5.mouseY);
    body.vertex(vect.x, vect.y);
    bodyVects.add(vect);
    maskCanvas.vertex(vect.x, vect.y);

    // draw to a separate PGraphics 'canvas' to restrict the drawn objects
    // to the bottom right corner of the sketch but still use mouse coords from the pen
       
    // translate coords to display only within the drawing PGraphic area
    float[] lineCoords = { mapGlobalToDrawCanvas(p5.pmouseX), 
                           mapGlobalToDrawCanvas(p5.pmouseY), 
                           mapGlobalToDrawCanvas(p5.mouseX), 
                           mapGlobalToDrawCanvas(p5.mouseY) 
                         };
    drawg.line(lineCoords[0], lineCoords[1], lineCoords[2], lineCoords[3]);
    drawg.endDraw();
    p5.image(pdrawg, p5.width - drawg.width, p5.height - drawg.height);
    p5.image(drawg, p5.width - drawg.width, p5.height - drawg.height);
    
    // set contents of pdrawg to current drawg
    pdrawg.beginDraw();
    pdrawg.background(drawbgColor);
    pdrawg.endDraw();
    pdrawg.image(drawg, p5.width - drawg.width, p5.height - drawg.height);
    
    // after DrawnFigure creation, get rid of this line //<>//
    //canvas = createGraphics(imgW, imgH, P2D);
  } //<>//
  
  void draw_complete() {
    // complete the body shape
    body.endShape(PConstants.CLOSE);     
    gp.addChild(body);
    p5.shape(gp);
    drawnFigures.add(this);    
    get_bounds_vecs();
    
    // make a masking image from our mask canvas
    maskCanvas.endShape(PConstants.CLOSE);
    maskCanvas.endDraw();
    maskImage = maskCanvas.get();
    
    p5.background(bgColor); // clear the draw line, DrawnFigures will get displayed again
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
    if (now_ms - added_time > limbsDelay) {
      if (has_limbs == false) add_limbs();
    }
    if (now_ms - added_time > eyesDelay) {
      if (has_eyes == false) add_eyes();
    }
    
    if (now_ms - added_time > skinDelay ) {
      //if (has_skin == false && enableVideo == true) add_skin();
      if (has_skin == false) add_skin();
    }
    
    if (has_eyes && has_limbs) {     
      if (x < p5.width) {   
        //gp.translate(1,0);
        //x+=1;
        //println(x);
      }
    } 
}

  void display() {
    // redisplay the DrawnFigure
    p5.shape(gp);
  }
  
  void add_limbs() {
    add_arms();
    add_legs();
    has_limbs = true;
  }
  
  void add_arms() {
    leftArm = new Arm(p5, this, 'L', centerV.x, centerV.y + 20);
    rightArm = new Arm(p5, this, 'R', rightestV.x, rightestV.y);
    leftArm.display();
    rightArm.display();
    gp.addChild(leftArm.lshape);
    gp.addChild(rightArm.lshape);
  }
  
  void add_legs() {
    leftLeg = new Leg(p5, this, 'L', bottomV.x-10, bottomV.y);
    rightLeg = new Leg(p5, this, 'R', bottomV.x+10, bottomV.y);
    leftLeg.display();
    rightLeg.display();
    gp.addChild(leftLeg.lshape);
    gp.addChild(rightLeg.lshape);
  }
  
  void add_eyes() {
    //PVector eyesV = new PVector();    
    leftEye = new Eye(p5, this, 'L', rightestV.x - 30, centerV.y + 5, "neutral_right"); 
    rightEye = new Eye(p5, this, 'R', rightestV.x - 20 , centerV.y + 5, "neutral_right");
    
    //eyesV.x = p5.constrain(rightestV.x -20, leftestV.x + 5, rightestV.x - 20);
    leftEye.display();
    rightEye.display();
    gp.addChild(leftEye.lshape);
    gp.addChild(rightEye.lshape);
    has_eyes = true;
  }
  
  void add_skin() {
    println("adding skin");
    if (enableVideo) {
      drawCam.read(); //<>//
      drawCam.loadPixels();
      skin = drawCam.get();
    }
    else {
      skin = loadImage("testtexture.jpeg");
    }
    // TODO:  these need to travel with the shape
    p5.image(skin, x, y);
    skin.mask(maskImage);
    
    //body.setTexture(skin);
    //body.setTextureMode(PConstants.NORMAL);
    has_skin = true;  
  }
  

}