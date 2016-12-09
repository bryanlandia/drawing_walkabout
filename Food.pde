
class Food extends PShape {
  
  // a Food is created from a failed DrawnFigure
  // when it is not viable
  
  PApplet p5;
  PShape foodShape;
  DrawnFigure fig;
  float x;
  float y;

  Food(PApplet p5ref, DrawnFigure figref) {
    p5 = p5ref;
    fig = figref;
    x = p5.mouseX;
    y = p5.mouseY;
    println("gp had "+fig.gp.getChildCount()+" children");
    foodShape= p5.createShape(GROUP);
    foodShape.addChild(fig.gp.getChild(0));    
    foodShape.getChild(0).setFill(gray);
    foodShape.getChild(0).setStroke(white);
    foodShape.getChild(0).setStrokeWeight(2);
    println("created a Food with width:"+foodShape.getChild(0).width+" at ("+x+","+y+")");
    display();
  }
  
  void update(){}
  
  void display(){    
    p5.shape(foodShape, x, y);
  };
  
  
}