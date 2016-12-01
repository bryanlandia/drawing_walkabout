//import gab.opencv.*;
//import processing.video.*;
//Capture cam;

import codeanticode.tablet.*;

Tablet tablet;
int penPress = 50; // pressure sensitivity of tablet pen

ArrayList<DrawnFigure> drawnFigures;
DrawnFigure currentfig;

boolean makingShape = false;
boolean haveShape = false;


void setup() {
  size(800, 600);
  background(16);
  stroke(239);  
  strokeJoin(ROUND);
  tablet = new Tablet(this);
  drawnFigures = new ArrayList<DrawnFigure>();
}


void draw() {
  if (currentfig != null) currentfig.draw_listen();
  for (int i = 0; i < drawnFigures.size(); i++) {
    //drawnFigures.get(i).update();
  }
  
}


void mousePressed() {
  // start DrawnFigure
  DrawnFigure fig = new DrawnFigure(this); //<>//
  currentfig = fig;  
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
      haveShape = false;
    } 
  }