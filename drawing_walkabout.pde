import processing.video.*;
//import gab.opencv.*;


boolean enableVideo=false;
boolean traceCoords=false;

int drawingHeightMin = 40;
int drawingWidthMin = 40;

String cameraName;
Capture drawCam;

import codeanticode.tablet.*;

//Tablet tablet;
//int penPress = 50; // pressure sensitivity of tablet pen

ArrayList<DrawnFigure> drawnFigures;
DrawnFigure currentfig;

float figSpeedMin = 1;
float figSpeedMax = 2;
float arrivalThreshold = 10; //close enough for move() operations

// create a separate graphics context for drawing 
// we only use mousex, mousey within that context for tracking
// the tablet and rendering the drawn line()s
int bgColor = 0;
int drawbgColor = 0; //16
color white = color(239);
color black = color(0);

int limbsDelay = 2000; //ms delay before adding features
int eyesDelay = 3000;
int skinDelay = 1000;

PVector drawgZeroZero;

//our SVG shapes. copied in bodyparts
PShape armShape;

FloatDict directionsDict;


void setup() {
  size(1300, 950);
  background(bgColor);
  stroke(white);  
  fill(white);
  strokeJoin(ROUND);
  smooth(8);
  //textureMode(NORMAL);
  
  // direction facing for DrawnFigures
  directionsDict = new FloatDict();
  directionsDict.set("right", 0);
  directionsDict.set("down", HALF_PI );//- radians(10));
  directionsDict.set("left", PI);
  directionsDict.set("up", PI + HALF_PI);// + radians(10));

  //noSmooth();
  //tablet = new Tablet(this);  // not working on RPi
  drawnFigures = new ArrayList<DrawnFigure>();
  
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
  
  //load our SVGs, 
  armShape = loadShape("arm_tendril0_sm.svg");
  armShape.setVisible(false); 
}


void draw() {
  background(bgColor);
  if (currentfig != null) {
    currentfig.draw_listen();    

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
  //if (enableVideo) {drawCam.start();}  would prefer to start() here, but causes rendering issues
}


void mouseReleased() {
 // finish DrawnFigure 
 currentfig.draw_complete();
 currentfig = null;
}


void keyPressed() {
  if (key == 'c' || key == 'C') {
      background(16);
      drawnFigures.clear();
    } 
  }