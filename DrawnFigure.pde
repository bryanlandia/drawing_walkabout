
class DrawnFigure extends PShape {
  
  // reference the Processing applet
  PApplet p5;

  PGraphics drawg;
  PGraphics pdrawg;
  PImage skin;
  boolean havepdrawg = false;

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
  
  // Its location
  float x;
  float y;
  float startx;
  float starty;
  
  // Its direction
  String direction;
  float rotation = 0;
  boolean armsMirrorY = false; //direction left requires Y mirroring 
  
  // Its L, R, Top, Bottom bounds
  PVector topV;
  PVector bottomV;
  PVector leftestV;
  PVector rightestV;
  PVector centerV;
  
  // accurate width, height based on bounds of body
  float bodyWidth, bodyHeight;
  
  // when it was added
  int added_time;
    
  // has body parts
  boolean has_limbs = false;
  boolean has_eyes = false;
  boolean has_skin = false;
  
  // for masking the video grab image inside the shape
  PGraphics maskCanvas;
  PImage maskImage;
  
  
  DrawnFigure(PApplet p5ref) {
    this(p5ref, "left");  // default is left
  }
   
  DrawnFigure(PApplet p5ref, String dir) {
    super();
    p5 = p5ref;
    added_time = p5.millis();
    
    drawg = createGraphics(400,400);
    pdrawg = createGraphics(400,400);
    drawgZeroZero = new PVector(p5.width - drawg.width, p5.height - drawg.height);
    
    direction = dir;
    rotation = directionsDict.get(direction);
    armsMirrorY = (dir == "left") ? true : false;
    
    x = mapGlobalToDrawCanvas(p5.mouseX, 'x') + drawgZeroZero.x;
    y = mapGlobalToDrawCanvas(p5.mouseY, 'y') + drawgZeroZero.y; 
    startx = x;
    starty = y;

    // make an additional canvas from which to generate the 
    // video image masking img
    maskCanvas = createGraphics(640, 480); //needs to match drawcam capture size
    maskCanvas.beginDraw();
    maskCanvas.background(0);
    maskCanvas.stroke(0);
    maskCanvas.strokeWeight(10);
    maskCanvas.fill(255); //needs to be real 255 white 
    maskCanvas.beginShape();

    gp = p5.createShape(PConstants.GROUP); //<>//
    body = p5.createShape();
    if (body == null) removeDrawnFigure(this); 
    body.beginShape(); //<>//
    body.stroke(white);
    body.strokeWeight(10);
    body.noFill();    
  }
  
  void init_drawg() {
    drawg.beginDraw();    
    drawg.background(drawbgColor); // TMP  
    drawg.stroke(white);
    drawg.strokeWeight(5);
  }

  void draw_listen() {
    // trace the outline so we can see what we are doing
    // as a line is made with the pen, show a line and record vertices
    // as Vectors for body shape    
    
    PVector vect = new PVector(mapGlobalToDrawCanvas(p5.mouseX, 'x'),
                               mapGlobalToDrawCanvas(p5.mouseY, 'y'));
    body.vertex(vect.x, vect.y);
    bodyVects.add(vect);   

    maskCanvas.vertex(vect.x, vect.y);
    
    // draw to a separate PGraphics 'canvas' to restrict the drawn objects
    // to the bottom right corner of the sketch but still use mouse coords from the pen //<>//
        //<>//
    // translate coords to display only within the drawing PGraphic area //<>//
    float[] lineCoords = { mapGlobalToDrawCanvas(p5.pmouseX, 'x'),  //<>//
                           mapGlobalToDrawCanvas(p5.pmouseY, 'y'), 
                           mapGlobalToDrawCanvas(p5.mouseX, 'x'), 
                           mapGlobalToDrawCanvas(p5.mouseY, 'y') 
                         };

    ////printArray(lineCoords);
    p5.image(drawg, drawgZeroZero.x, drawgZeroZero.y);
    
    init_drawg(); //start over in the main draw canvas
    
    if (havepdrawg) drawg.image(pdrawg.get(), 0, 0);
    
    drawg.line(lineCoords[0], lineCoords[1], lineCoords[2], lineCoords[3]);
    drawg.endDraw();
    p5.image(pdrawg, drawgZeroZero.x, drawgZeroZero.y); //<>//
    
    // set contents of pdrawg to current drawg     //<>// //<>//
    pdrawg.beginDraw();
    pdrawg.image(drawg.get(), 0, 0); //<>//
    pdrawg.endDraw();
    havepdrawg = true;
  }
  
  void draw_complete() {
    // complete the body shape
    body.endShape(PConstants.CLOSE);  
    
    get_bounds_vecs();
    bodyHeight = bottomV.y - topV.y;
    bodyWidth = rightestV.x - leftestV.x;
    if (isViableFigure() == false) {
      removeDrawnFigure(this);
      return;
    }
    
    gp.addChild(body);
    // now draw it within the corner of the drawing canvas
    p5.shape(gp, drawgZeroZero.x, drawgZeroZero.y);
    drawnFigures.add(this);    
    
    //remove refs for garbage collector
    drawg = null;
    pdrawg = null;
    
    maskCanvas.endShape();
    maskCanvas.endDraw();
    maskImage = maskCanvas.get();
    maskCanvas = null;
  }


  void get_bounds_vecs() {
    //not sure why yet but sometimes body isn't available.
    try {
      topV = body.getVertex(0);
      bottomV = body.getVertex(0);
      leftestV = body.getVertex(0);
      rightestV = body.getVertex(0);
      centerV = new PVector();
    } catch (NullPointerException e) {
      // wait and try again?
      println("\n\nCaught NullPointerException in get_bounds_vecs");
      //delay(100);
      removeDrawnFigure(this);
      return;
    }
    
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
    
    //if (has_eyes && has_limbs && has_skin) move();
  }
  
  void move() {   
      // TODO: this will turn into much more complex
      // movement behavior
      
      if (x < p5.width) {   
        gp.translate(1,0);
        x+=1;
               
        //println(x);
      } 
}

  void display() {
    // redisplay the DrawnFigure and masked image
    float diffx = x - startx;
    float diffy = y - starty;
    if (has_skin) {
      p5.image(skin, drawgZeroZero.x + diffx, drawgZeroZero.y + diffy);
    }
    p5.shape(gp, drawgZeroZero.x, drawgZeroZero.y);
  }
  
  void add_limbs() {
    add_arms();
    add_legs();
    has_limbs = true;
  }
  
  void add_arms() {
    leftArm = new Arm(p5, this, "L", leftestV.x, topV.y);
    rightArm = new Arm(p5, this, "R", leftestV.x, topV.y);
    leftArm.display();
    rightArm.display();
    gp.addChild(leftArm.lshape);
    gp.addChild(rightArm.lshape);
  }
  
  void add_legs() {
    leftLeg = new Leg(p5, this, "L", bottomV.x-10, bottomV.y);
    rightLeg = new Leg(p5, this, "R", bottomV.x+10, bottomV.y);
    leftLeg.display();
    rightLeg.display();
    gp.addChild(leftLeg.lshape);
    gp.addChild(rightLeg.lshape);
  }
  
  void add_eyes() {
    //PVector eyesV = new PVector();    
    leftEye = new Eye(p5, this, "L", rightestV.x - 30, centerV.y + 5, "neutral_right"); 
    rightEye = new Eye(p5, this, "R", rightestV.x - 20 , centerV.y + 5, "neutral_right");
    
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
      //println("adding video skin");
      drawCam.read();
      skin = drawCam.get();
      drawCam.stop();
      // TODO: maybe resize to be same size as shape
      // before masking
    }
    else {
      skin = loadImage("testtexture.jpeg");
    }
    println("maskImage width:"+maskImage.width);
    //p5.image(maskCanvas, 100, 100);
    skin.mask(maskImage);
    p5.image(skin, drawgZeroZero.x, drawgZeroZero.y);
    //p5.image(maskImage, x, y);
    has_skin = true;  
  }
  
  boolean isViableFigure() {
    // if the size of the drawn body shape is too small, signal
    // to destroy the DrawnFigure
    if (bodyHeight < drawingHeightMin || bodyWidth < drawingWidthMin) {
      return false;
    } else return true;
    
  }
  

  /* 
  // UTILITY FUNCTIONS
  */
  
  float mapGlobalToDrawCanvas(float globalCoord, char xy) {  
    float drawCoord = map(globalCoord, 
               0, xy == 'x' ? p5.width : p5.height, 
               0, xy == 'x' ? drawg.width : drawg.height);
    if (traceCoords) println("mapped globalCoord ("+xy+")" +globalCoord+" to drawg coord "+drawCoord);
    return drawCoord;
  }
  
  float mapDrawCanvasToGlobal(float drawCoord, char xy) {
    return map(drawCoord, 
               0, xy == 'x' ? drawg.width: drawg.height,
               0, xy == 'x' ? p5.width: p5.height);
  }  
  

}