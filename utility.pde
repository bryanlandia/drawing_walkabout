float[][] arrayCopyMultiDim (float[][] src, float[][]dest) {
  for (int i = 0; i < src.length; i++) {
    System.arraycopy(src[i], 0, dest[i], 0, src[0].length);
  }
  return dest;
}

void removeDrawnFigure(DrawnFigure fig) {
  fig = null;
  try {
    drawnFigures.remove(drawnFigures.indexOf(fig));
  } catch (ArrayIndexOutOfBoundsException e) { 
        // might not have been added  yet
        // do nothing
     println(e);
  }
  println("Removed DrawnFigure ") ;//+ (String)fig.body); how to cast to String?
}

Pane findFreePane() {
 Pane firstPane = panes.get(0); //stuff it into the first one if no space
 for (int i=0; i<panes.size(); i++) {
   Pane pane = panes.get(i);
   if (pane.paneFigs.size() < pane.space) {
     return pane; 
   }  
 }
  return firstPane;
}