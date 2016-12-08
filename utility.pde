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