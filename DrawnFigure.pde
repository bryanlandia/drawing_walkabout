

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
  
  //ArrayList<DrawnFigure> drawnFigures;
  
  // Its location
  float x;
  float y;
  float startx;
  float starty;
  
  // Its location relative to drawing PGraphics
  float drawx;
  float drawy;
  
  // Its L, R, Top, Bottom bounds
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
  
  // for masking the video grab image inside the shape
  PGraphics maskCanvas;
  PImage maskImage;

  
  DrawnFigure(PApplet p5ref) {
    super();
    p5 = p5ref;
    added_time = p5.millis();
    x = mapGlobalToDrawCanvas(p5.mouseX, 'x');
    y = mapGlobalToDrawCanvas(p5.mouseY, 'y'); 
    startx = x;
    starty = y;
    drawx = 0;
    drawy = 0;

    // make an additional canvas from which to generate the 
    // video image masking img
    maskCanvas = createGraphics(640, 480); //needs to match drawcam capture size
    maskCanvas.beginDraw();
    maskCanvas.background(0);
    maskCanvas.stroke(0);
    maskCanvas.strokeWeight(10);
    maskCanvas.fill(255); 
    maskCanvas.beginShape();

    gp = p5.createShape(PConstants.GROUP);
    body = p5.createShape();
    body.beginShape();
    body.stroke(255);
    body.strokeWeight(10);
    body.fill(255);

    drawg.beginDraw();    
    drawg.background(drawbgColor); // TMP  
    drawg.stroke(255);
    drawg.strokeWeight(10);
     //<>//
    pdrawg.beginDraw(); 
    //shouldn't need styles since it just gets drawg pixels as an image 
    
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
    // to the bottom right corner of the sketch but still use mouse coords from the pen
       
    // translate coords to display only within the drawing PGraphic area
    float[] lineCoords = { mapGlobalToDrawCanvas(p5.pmouseX, 'x'), 
                           mapGlobalToDrawCanvas(p5.pmouseY, 'y'), 
                           mapGlobalToDrawCanvas(p5.mouseX, 'x'), 
                           mapGlobalToDrawCanvas(p5.mouseY, 'y') 
                         };

    //printArray(lineCoords);
    drawg.image(pdrawg, 0, 0);
    drawg.line(lineCoords[0], lineCoords[1], lineCoords[2], lineCoords[3]);
    drawg.endDraw();
    //p5.image(pdrawg, p5.width - drawg.width, p5.height - drawg.height);
    
    // set contents of pdrawg to current drawg     //<>//
    pdrawg.image(drawg, 0, 0); //p5.width - drawg.width, p5.height - drawg.height); //<>//
    pdrawg.endDraw();
    
    p5.image(drawg, drawgZeroZero.x, drawgZeroZero.y);
    
    // after DrawnFigure creation, get rid of this line //<>//
  }
  
  void draw_complete() {
    // complete the body shape
    body.endShape(PConstants.CLOSE);     
    gp.addChild(body);
    // now draw it within the corner of the drawing canvas
    p5.shape(gp, drawgZeroZero.x, drawgZeroZero.y);
    drawnFigures.add(this);    
    get_bounds_vecs();
    
    drawg.endDraw(); //<>//
    pdrawg.endDraw();
     //<>//
    maskCanvas.endShape();
    maskCanvas.endDraw();
    maskImage = maskCanvas.get();
    maskCanvas = null;
    
    //p5.background(bgColor); // clear the draw line, DrawnFigures will get displayed again
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
    
    if (has_eyes && has_limbs && has_skin) {
      
      // TODO: this will turn into much more complex
      // movement behavior
      
      if (x < p5.width) {   
        gp.translate(1,0);
        x+=1;
        //println(x);
      }
    } 
}

  void display() {
    // redisplay the DrawnFigure and masked image
    //p5.shape(gp, x, y);
    //if (has_skin) {
    //  p5.image(skin, x, y);
    //}
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
      //println("adding video skin");
      drawCam.read();
      skin = drawCam.get();
      drawCam.stop();
      // TODO: will need to resize to be same size as shape
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
  

}