import processing.video.*;
//import gab.opencv.*;

/*

TODO:
remove arms and legs who needs em
allow continuation of shape, connected by a little line, with a slight pause
otherwise make a new shape
so on mouseup don't necessarily complete the drawing

logic for where the text pieces go
mark out the panes (they aren't evenly dispersed)
- maybe just have an overlay of black where the wood is



attract screen in lower right pane "SIGN GUESTBOOK"?  or could just do it on the 
page itself.
trace my journal pages from SFPC


*/


boolean enableVideo=false;
boolean traceCoords=false;
boolean flipHoriz = false; //doesn't work plus probably can do with projector

int drawingHeightMin = 200;
int drawingWidthMin = 200;

String cameraName;
Capture drawCam;

import codeanticode.tablet.*;

//Tablet tablet;
//int penPress = 50; // pressure sensitivity of tablet pen

ArrayList<DrawnFigure> drawnFigures;
ArrayList<Pane> panes;

int numPanes=9;
int paneHoldsFigs=6;
float figsInPaneSpaceBuffer = -100; //add that onto x, negative to y to leave space between

DrawnFigure currentfig;

float figSpeedMin = 1;
float figSpeedMax = 2;
float arrivalThreshold = 10; //close enough for move() operations

// create a separate graphics context for drawing 
// we only use mousex, mousey within that context for tracking
// the tablet and rendering the drawn line()s
int bgColor = 0;
int drawbgColor = 0; //16
color white = color(255); //239;
color black = color(0);
color gray = color(130);

PVector drawgZeroZero;
int drawgRealScaleX = 800;
int drawgRealScaleY = 400;
int drawgScreenScaleX = 1600;
int drawgScreenScaleY = 800;

FloatDict directionsDict;

int skinDelay = 1000; //ms til we try adding the skin from video.

int mouseUpCompleteDelay = 800; //1000
int lastMouseUpTime, lastMouseDownTime, lastDrawTime;

void setup() {
  size(1300, 880);
  //frameRate(120);
  background(bgColor);
  stroke(white);  
  fill(white);
  strokeJoin(ROUND);
  smooth(8);
  
  lastMouseUpTime = millis(); //dummy one to start off

  //tablet = new Tablet(this);  // not working on RPi
  drawnFigures = new ArrayList<DrawnFigure>();
  panes = new ArrayList<Pane>();
  
  //make panes
  for (int i=0;i<numPanes;i++) {
     Pane pane = new Pane((i%3)*(width/3), floor(i/3)*(height/3),
                          width/3, height/3);
     panes.add(pane);
     pane.name = "Pane"+panes.indexOf(pane);
  }
  
  //String[] cameras = Capture.list(); // on my MacBook Pro creates NullPointerException!
  //printArray(cameras);
  if (enableVideo) {
    //String cameraName = "USB Camera-B4.09.24.1"; // PS3eye in USB port
    //String cameraName = "USB Camera_B4_09_24_1"; // PS3eye in USB port
    //String cameraName = "FaceTime HD Camera (Built-in)"; // built-in
    //String cameraName = "USB Video Class Video"; // built-in
    cameraName = "/dev/video0"; //RaspberryPi PS3eye
    drawCam = new Capture(this, 640, 480, cameraName, 15); //this is fewest fps possible w/cam  
    drawCam.start();
    
  }
}


void draw() {
  background(bgColor);

  //flip the whole sketch horizontally for projector
  if (flipHoriz) {
    pushMatrix();
    scale(-1,1);
    translate(width,0);
    mouseX = width-mouseX;
  }
  
  if (currentfig != null) {
    currentfig.draw_listen();    

  }
  for (int i = 0; i < drawnFigures.size(); i++) {
    drawnFigures.get(i).update();
    drawnFigures.get(i).display();
  }
  for (int i = 0; i < panes.size()-2; i++) {
    //panes.get(i).update();
    panes.get(i).display();
  }  
  
  //flip the whole sketch horizontally for projector
  if (flipHoriz) {
    popMatrix();
    mouseX = width-mouseX;
  }
  
  
 
}

void mousePressed() {
  // start DrawnFigure
  println("mousePressed"); 
  println("millis is:"+millis());
  println("lastMouseEventTime was:"+lastMouseUpTime);
  lastMouseDownTime = millis();

  if (millis() - lastMouseUpTime >= mouseUpCompleteDelay && currentfig == null) {
    // only start a new DrawnFigure if we've waited for delay
    // otherwise we are still drawing the old one (maybe crossing a "t")
    DrawnFigure fig = new DrawnFigure(this);
    currentfig = fig;
  }

  //if (enableVideo) {drawCam.start();}  would prefer to start() here, but causes rendering issues
}


void mouseReleased() {
 // this should really be implemented with MouseListener on the DrawnFigure class
 // finish DrawnFigure 
 // set a value and then delay a bit before deciding whether
 // to really complete the current figure
 println("mouseReleased");
 println("millis is:"+millis());
 println("lastMouseUpTime was:"+lastMouseUpTime);

 //if (millis() - lastMouseEventTime >= mouseUpCompleteDelay) {         
     //currentfig.draw_complete();   
     //currentfig = null;
     lastMouseUpTime = millis();

 //}
}


void keyPressed() {
  if (key == 'c' || key == 'C') {
      background(16);
      drawnFigures.clear();
      for (int i = 0; i < panes.size()-2; i++) {
        //panes.get(i).update();
        panes.get(i).clear();
      }
    } 
  }