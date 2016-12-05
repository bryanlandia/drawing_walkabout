//import gab.opencv.*;
//import processing.video.*;
//Capture cam;

import codeanticode.tablet.*;

Tablet tablet;
int penPress = 50; // pressure sensitivity of tablet pen

ArrayList<DrawnFigure> drawnFigures;
DrawnFigure currentfig;

void setup() {
  size(1000, 1000);
  background(16);
  stroke(239);  
  strokeJoin(ROUND);
  smooth(8);
  //noSmooth();
  tablet = new Tablet(this);
  drawnFigures = new ArrayList<DrawnFigure>();
  
  // create a separate graphics context for drawing 
  // we only use mousex, mousey within that context for tracking
  // the tablet and rendering the drawn line()s
  //drawg = createGraphics(40, 40);
}


void draw() {
  clear();
  if (currentfig != null) currentfig.draw_listen();
  for (int i = 0; i < drawnFigures.size(); i++) {
    drawnFigures.get(i).update();
    drawnFigures.get(i).display();
  }
  
}


void mousePressed() {
  // start DrawnFigure
  DrawnFigure fig = new DrawnFigure(this);
  fig.drawnFigures = drawnFigures;
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
    } 
  }