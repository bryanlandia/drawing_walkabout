float[][] arrayCopyMultiDim (float[][] src, float[][]dest) {
  for (int i = 0; i < src.length; i++) {
    System.arraycopy(src[i], 0, dest[i], 0, src[0].length);
  }
  return dest;
}

float mapGlobalToDrawCanvas(float globalCoord, char xy) {  
  float drawCoord = map(globalCoord, 
             0, xy == 'x' ? width : height, 
             0, xy == 'x' ? drawg.width : drawg.height);
  println("mapped globalCoord ("+xy+")" +globalCoord+" to drawg coord "+drawCoord);
  return drawCoord;
}

float mapDrawCanvasToGlobal(float drawCoord, char xy) {
  return map(drawCoord, 
             0, xy == 'x' ? drawg.width: drawg.height,
             0, xy == 'x' ? width: height);
}