float[][] arrayCopyMultiDim (float[][] src, float[][]dest) {
  for (int i = 0; i < src.length; i++) {
    System.arraycopy(src[i], 0, dest[i], 0, src[0].length);
  }
  return dest;
}

void removeDrawnFigure(DrawnFigure fig) {
  try {
    drawnFigures.remove(drawnFigures.indexOf(fig));
    int paneIndex = panes.indexOf(fig.pane);
    Pane pane = panes.get(paneIndex);
    pane.paneFigs.remove(pane.paneFigs.indexOf(fig));
    fig = null;
  } catch (ArrayIndexOutOfBoundsException e) { 
        // might not have been added  yet
        // do nothing
     println(e);
  }
  println("Removed DrawnFigure ") ;//+ (String)fig.body); how to cast to String?
}

Pane findFreePane() {
 for (int i=0; i<panes.size()-2; i++) {
   println(panes.get(i).name + "holds "+panes.get(i).paneFigs.size() + "figs"); 
   if (panes.get(i).paneFigs.size() <= paneHoldsFigs) {
     return panes.get(i); 
   }  
 }
  return panes.get(0); //stuff it into the first one if no space
}