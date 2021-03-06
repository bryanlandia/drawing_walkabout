//import java.awt.*;
//import java.awt.event.*;


class DrawnFigure extends PShape {
//implements MouseListener {
  
  // reference the Processing applet
  PApplet p5;

  PGraphics drawg;
  PGraphics pdrawg;
  PImage skin;
  boolean havepdrawg = false;

  // parts of figure in group
  PShape gp;
  PShape body;
  
  ArrayList<PVector> bodyVects = new ArrayList<PVector>();
  
  // Its location
  float x;
  float y;
  float startx;
  float starty;
  
  // Its destination, TBD by rules
  PVector destination;
  Pane pane;
  
  // how fast it can move toward destination
  float speed;
  
  // Its direction (which was shape is facing)
  String direction;
  float rotation = 0;
  
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
    
    speed = random(figSpeedMin, figSpeedMax);
    
    drawg = createGraphics(drawgRealScaleX, drawgRealScaleY);
    pdrawg = createGraphics(drawgRealScaleX, drawgRealScaleY);
    //drawgZeroZero = new PVector(p5.width - drawg.width, p5.height - drawg.height);
    drawgZeroZero = new PVector(0, p5.height - drawgRealScaleY);
    
    direction = dir;
    //rotation = directionsDict.get(direction); not sure if we will use this
    
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
    maskCanvas.strokeWeight(7);
    maskCanvas.fill(255); //needs to be real 255 white 
    maskCanvas.beginShape();

    gp = p5.createShape(PConstants.GROUP); //<>//
    body = p5.createShape();
    if (body == null) removeDrawnFigure(this); 
    body.beginShape(); //<>//
    body.stroke(white);
    body.strokeWeight(2);
    body.fill(gray);         //<>//
  }
    
  void init_drawg() { //<>//
    drawg.beginDraw();    
    drawg.background(drawbgColor); // TMP  
    drawg.stroke(white);
    drawg.strokeWeight(2);
  }

  void draw_listen() {
    // trace the outline so we can see what we are doing
    // as a line is made with the pen, show a line and record vertices
    // as Vectors for body shape  
    
    // are we ready to complete the drawing?
    // if it's been longer than set delay since both last mouseReleased
    // and last mousePressed time, and there has been a mouseReleased
    // since creation, then complete
    int now = millis();
    if (now-lastMouseUpTime >= mouseUpCompleteDelay && 
        now-lastMouseDownTime >= mouseUpCompleteDelay &&
        lastMouseUpTime > added_time) {
      draw_complete();
      return;
    }
    
    lastDrawTime = millis();
       
    //if (mousePressed)
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
                         }; //<>//
 //<>// //<>//
    //p5.image(drawg, drawgZeroZero.x, drawgZeroZero.y, drawgScreenScaleX, drawgScreenScaleY); //<>//
    
    init_drawg(); //start over in the main draw canvas
    
    // draw it to screen way scaled up, but shifted over so drawer can see currently drawn line
    PVector drawnLengthVec =  new PVector(lineCoords[2]-lineCoords[0], lineCoords[3]-lineCoords[1]);
    //drawnLengthVec = drawnLengthVec.mult(drawgRealScaleX/drawgScreenScaleX);

    //println("got toScreenOffsetVec PVector of coords:"+drawnLengthVec.x+","+drawnLengthVec.y);
 
    if (havepdrawg) drawg.image(pdrawg.get(), 0,0);
  
    drawg.line(lineCoords[0], lineCoords[1], lineCoords[2], lineCoords[3]);
    drawg.endDraw();
    
    p5.image(pdrawg, drawgZeroZero.x, drawgZeroZero.y, drawgScreenScaleX, drawgScreenScaleY); //<>//
    
    // set contents of pdrawg to current drawg     //<>// //<>//
    // don't bother if we haven't moved this frame
    if (drawnLengthVec.x > 0 || drawnLengthVec.y > 0 ) {
      pdrawg.beginDraw();
      pdrawg.image(drawg.get(), -drawnLengthVec.x, -drawnLengthVec.y); //<>//
      //pdrawg.image(drawg.get(), 0,0);
      pdrawg.endDraw();
      havepdrawg = true;
    }
  } //<>//
  
  void draw_complete() { //<>//
    // complete the body shape
    body.endShape(PConstants.OPEN);   //<>//
    
    get_bounds_vecs();
    
    try {
      bodyHeight = bottomV.y - topV.y;
      bodyWidth = rightestV.x - leftestV.x;
    } catch (NullPointerException e) { //can hit these drawing too fast
      removeDrawnFigure(this);  
    }
    
    gp.addChild(body);

    // now draw it within the corner of the drawing canvas
    p5.shape(gp, drawgZeroZero.x, drawgZeroZero.y);
    drawnFigures.add(this);    
    
    //remove refs for garbage collector
    drawg = null;
    pdrawg = null;
    
    maskCanvas.endShape(PConstants.OPEN);
    maskCanvas.endDraw();
    maskImage = maskCanvas.get();
    maskCanvas = null;
    currentfig = null;
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
  
  void die() {
    removeDrawnFigure(this);
  }
    
  
  void update() {
    int now_ms = p5.millis();
    if (now_ms - added_time > dieSecs*1000 && drawnFigures.size() > 20) die(); //
    if (now_ms - added_time > skinDelay ) {
      //if (has_skin == false && enableVideo == true) add_skin();
      if (has_skin == false) {
        add_skin();
      }
      if (destination == null) {
        println("adding new destination");
        //int thisIndex = drawnFigures.indexOf(this);
        
        //get a destination based on Pane with free spaces
        if (pane == null) {
          Pane freePane = findFreePane(); 
          pane = freePane; // set it on the fig
          pane.paneFigs.add(this);
        }
        println("dest is in " + pane.name); 
        //destination = new PVector(freePane.x, freePane.y);
        // adjust by position of last fig in pane
        // should add that fig's width and height but use modulo
        // so it wraps around, or maybe constrain()
        destination = pane.getLastDrawnFigureEndPos(); 
        //add this fig to the Pane
        
        
        //try {
        //  PVector lastDestination = drawnFigures.get(thisIndex-1).destination;
        //  destination = lastDestination.add(width, height);
        //} catch (ArrayIndexOutOfBoundsException e) {
        //  println("out of bounds!!!"); // should just be the first one drawn
          
        //}
        //catch (NullPointerException e) {
        //  //destinations become null after arrival
        //  println("nullpointer!");
        //  destination = new PVector(drawnFigures.get(thisIndex-1).x, drawnFigures.get(thisIndex-1).y).add(width, height ); 
        //}
        println("orig destination is:"+destination);
      }
    }
    
    if (has_skin && destination != null) move();
  }
  
  void move() {       
      //if (x < p5.width) {
        //destination = new PVector(random(p5.width), random(p5.height));
        //float diffX = destination.x - x;
        //float diffY = destination.y - y;
        //println("destination is:("+destination.x+","+destination.y+")");
        PVector diffFromDest = PVector.sub(destination, new PVector(x,y)); // recalculating produces a smoothing
        //println("destination is:("+destination.x+","+destination.y+")");
        //println("distance from destination diffFromDest is:("+diffFromDest.x+","+diffFromDest.y+")");
        
        if (abs(diffFromDest.x) > arrivalThreshold && abs(diffFromDest.y) > arrivalThreshold) { 
          float moveX = (diffFromDest.x / speed) / random(150,250);
          float moveY = (diffFromDest.y / speed) / random(150,250);
          gp.translate(moveX, moveY);
          x+=moveX;
          y+=moveY;
        }
        else {
          if (random(0,1) < 0.2) {
            destination = null;
          } else {
            destination = destination.add(new PVector(random(-20,20),random(-20,20)));
          }
        }
               
        //println(x);
      //} 
}

  void display() {
    // redisplay the DrawnFigure and masked image
    float diffx = x - startx;
    float diffy = y - starty;
    p5.shape(gp, drawgZeroZero.x, drawgZeroZero.y);
    if (has_skin) {
      p5.image(skin, drawgZeroZero.x + diffx, drawgZeroZero.y + diffy);
    }
    
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
    //println("maskImage width:"+maskImage.width);
    skin.mask(maskImage);
    p5.image(skin, drawgZeroZero.x, drawgZeroZero.y);
    has_skin = true;  
  }
 

  /* 
  // UTILITY FUNCTIONS
  */
  
  float mapGlobalToDrawCanvas(float globalCoord, char xy) {  
    try {
      float drawCoord = map(globalCoord, 
               0, xy == 'x' ? p5.width : p5.height, 
               0, xy == 'x' ? drawg.width : drawg.height);
    if (traceCoords) println("mapped globalCoord ("+xy+")" +globalCoord+" to drawg coord "+drawCoord);
    return drawCoord;
    } catch (NullPointerException e) {
      println("NPE on drawg. returning 0");
      return 0;
    }
  }
  
  float mapDrawCanvasToGlobal(float drawCoord, char xy) {
    return map(drawCoord, 
               0, xy == 'x' ? drawg.width: drawg.height,
               0, xy == 'x' ? p5.width: p5.height);
  }  
  

}