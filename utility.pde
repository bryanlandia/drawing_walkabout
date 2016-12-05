float[][] arrayCopyMultiDim (float[][] src, float[][]dest) {
  for (int i = 0; i < src.length; i++) {
    System.arraycopy(src[i], 0, dest[i], 0, src[0].length);
  }
  return dest;
}