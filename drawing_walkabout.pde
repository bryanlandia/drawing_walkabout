import processing.video.*;
//import gab.opencv.*;


boolean enableVideo=false;
String cameraName;
Capture drawCam;


import codeanticode.tablet.*;

//Tablet tablet;
//int penPress = 50; // pressure sensitivity of tablet pen

ArrayList<DrawnFigure> drawnFigures;
DrawnFigure currentfig;

// create a separate graphics context for drawing 
// we only use mousex, mousey within that context for tracking
// the tablet and rendering the drawn line()s
PGraphics drawg;
PGraphics pdrawg;

int bgColor = 0;
int drawbgColor = 100; //16

int limbsDelay = 3000; //ms delay before adding features
int eyesDelay = 4000;
int skinDelay = 1000;


void setup() {
  size(1000, 1000, P2D);
  background(bgColor);
  stroke(239);  
  strokeJoin(ROUND);
  smooth(8);
  //textureMode(NORMAL);

  //noSmooth();
  //tablet = new Tablet(this);  // not working on RPi
  drawnFigures = new ArrayList<DrawnFigure>();
  drawg = createGraphics(600,600);
  pdrawg = createGraphics(600,600);
  
  //String[] cameras = Capture.list(); // on my MacBook Pro creates NullPointerException!
  //printArray(cameras);
  if (enableVideo) {
    //String cameraName = "USB Camera-B4.09.24.1"; // PS3eye in USB port
    //String cameraName = "USB Camera_B4_09_24_1"; // PS3eye in USB port
    //String cameraName = "FaceTime HD Camera (Built-in)"; // built-in
    //String cameraName = "USB Video Class Video"; // built-in
    cameraName = "/dev/video0"; //RaspberryPi PS3eye
    drawCam = new Capture(this, 320, 240, cameraName, 30); //this is fewest fps possible w/cam    
  }
 
}


void draw() {
  background(bgColor);
  if (currentfig != null) {
    currentfig.draw_listen();    
    if (enableVideo && drawCam.available()) {
        drawCam.start();
    }
  }
  for (int i = 0; i < drawnFigures.size(); i++) {
    drawnFigures.get(i).update();
    drawnFigures.get(i).display();
  }
  
}


void mousePressed() {
  // start DrawnFigure
  DrawnFigure fig = new DrawnFigure(this);
  currentfig = fig;
}


void mouseReleased() {
 // finish DrawnFigure 
 currentfig.draw_complete();
 if (enableVideo) drawCam.stop();
 currentfig = null;
}


void keyPressed() {
  if (key == 'c' || key == 'C') {
      background(16);
      drawnFigures.clear();
    } 
  }