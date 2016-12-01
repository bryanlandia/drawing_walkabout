//import gab.opencv.*;
import codeanticode.tablet.*;
//import processing.video.*;

//Capture cam;
Tablet tablet;
PShape s;
ArrayList<PVector> sVects = new ArrayList<PVector>(); 
ArrayList<PShape> shapes = new ArrayList<PShape>(); 
boolean makingShape = false;
boolean haveShape = false;
int penPress = 50; // pressure sensitivity of tablet pen

//int startX;
//int startY;
//int endX;
//int endY;
//int ctrStX;
//int ctrStY;
//int ctrEndX;
//int ctrEndY;
//int startHandleIncr = 15;
//int endHandleIncr = 15;

void setup() {
  size(800, 600);
  background(16);
  stroke(239);  
  tablet = new Tablet(this);
  strokeJoin(ROUND);
  //String[] cameras = Capture.list();
  
  //if (cameras.length == 0) {
  //  for (int i = 0; i < cameras.length; i++) {
  //      println(cameras[i]);
  //    }
  //} else println("no cameras");
  //cam = new Capture(this, width, height, "FaceTime HD Camera (Built-in)", 30);
}


void draw() {
  //noStroke();
  //println(cam.available());
  //if (cam.available() == true) {
  //  cam.read();
  //  image(cam, 0, 0);
  //}
  
  
  if (haveShape == true) {
   //for (int i = 0; i < s.getVertexCount(); i++) {
   //     PVector v = s.getVertex(i);
   //     s.setVertex(i, v.x + i, v.y + i );
   // }
   // shape(s);
  }
  
  int i = 0;
  //for (int i = 0; i < shapes.size(); i++) {
  if (shapes.size() > 0) {  
    PShape p = shapes.get(i);
    int newColorR = floor(map(p.getVertexX(0), 0, width, 0, 255));  
    p.setFill(color(newColorR, 0, 0));
    //p.translate(5,5);
    PVector lowestV = p.getVertex(0);
    PVector leftestV = p.getVertex(0);
    PVector rightestV = p.getVertex(0);
    PVector highestV = p.getVertex(0);
    for (int j=0; j< p.getVertexCount(); j++) {
      if (p.getVertex(j).y > lowestV.y) lowestV = p.getVertex(j);
      if (p.getVertex(j).x < leftestV.x) leftestV = p.getVertex(j);
      if (p.getVertex(j).x > rightestV.x) rightestV = p.getVertex(j);
      if (p.getVertex(j).y < highestV.y) highestV = p.getVertex(j);
    }
    
    shape(p);
    
    PVector centerV = new PVector();
    centerV.x = (rightestV.x - leftestV.x)/2 + leftestV.x;
    centerV.y = (lowestV.y - highestV.y)/2 + highestV.y;
    stroke(100, 239, 16);
    ellipse(centerV.x -14, centerV.y, 10, 10);
    ellipse(centerV.x +14, centerV.y, 10, 10);
    
    
    pushStyle();
    strokeWeight(5);
    line(lowestV.x-10, lowestV.y, lowestV.x-10, lowestV.y+50);
    line(lowestV.x+10, lowestV.y, lowestV.x+10, lowestV.y+50);
    line(leftestV.x, leftestV.y, leftestV.x-20, leftestV.y+10);
    line(rightestV.x, rightestV.y, rightestV.x+20, rightestV.y+10);
    popStyle();
    
    shapes.remove(i);
    
  
    
  }
      
  if (mousePressed) {
    stroke(239);   
    if (makingShape == false) {
        //haveShape = false;
        s = createShape();
        //s.beginShape(QUAD_STRIP);
        s.beginShape(TRIANGLE_FAN);
        s.stroke(255);
        s.strokeWeight(penPress * tablet.getPressure());

        s.fill(floor(map(tablet.getPressure(), 0, 1, 0, 255)));
        makingShape = true;
        //println("starting Shape s");
    }

    //s.strokeWeight(10);
    PVector vert = new PVector(mouseX, mouseY);
    s.vertex(vert.x, vert.y);
    sVects.add(vert);
    
    // trace the outline so we can see what we are doing
    strokeWeight(penPress * tablet.getPressure());
    line(pmouseX, pmouseY, mouseX, mouseY);
    //println(sVects.size());
    //println(sVects.get(sVects.size()-1));
    
    //startX = pmouseX;
    //startY = pmouseY;
    //ctrStX = startX + startHandleIncr;  
    //ctrStY = startY + startHandleIncr;
    //endX = mouseX;
    //endY = mouseY;
    //ctrEndX = endX + endHandleIncr;
    //ctrEndY = endY + endHandleIncr;
    //line = bezier(startX, startY, ctrStX, ctrStY, endX, endY, ctrEndX, ctrEndY);  
  }
  else {
    //if (mousePressed == false) {
      if (makingShape == true) {
        //println("ending Shape");
        s.endShape(CLOSE);
        //background(0);
        
        shape(s);
        sVects.clear();
        shapes.add(s);
        makingShape = false;
        haveShape = true;
      }
    //}
  }
  
  if (keyPressed) {
    if (key == 'c' || key == 'C') {
      background(16);
      shapes.clear();
      haveShape = false;
    } 
  }

}