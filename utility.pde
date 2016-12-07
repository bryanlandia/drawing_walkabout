float[][] arrayCopyMultiDim (float[][] src, float[][]dest) {
  for (int i = 0; i < src.length; i++) {
    System.arraycopy(src[i], 0, dest[i], 0, src[0].length);
  }
  return dest;
}

float mapGlobalToDrawCanvas(float globalCoord) {
  return map(globalCoord, 0, width, 0, drawg.width);
}

float mapDrawCanvasToGlobal(float drawCoord) {
  return map(drawCoord, 0, drawg.width, 0, width);
}