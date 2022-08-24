class KinectTracker {
  int threshold = 875;
  int[] depth;
  PVector location;
  PImage image;

  KinectTracker() {
    kinect.initDepth();
    kinect.enableMirror(true);

    image = createImage(kinect.width, kinect.height, RGB);
    location = new PVector(0, 0);
  }

  void track() {
    depth = kinect.getRawDepth();
    if (depth == null) return;

    float sumX = 0;
    float sumY = 0;
    float totalPixels = 0;

    for (int x = 0; x < kinect.width; x++) {
      for (int y = 0; y < kinect.height; y++) {
        
        int offset =  x + y * kinect.width;
        int rawDepth = depth[offset];

        if (rawDepth < threshold) {
          sumX += x;
          sumY += y;
          totalPixels++;
        }
      }
    }
    
    if (totalPixels != 0) {
      location = new PVector(sumX/totalPixels, sumY/totalPixels);
    }
  }

  PVector getPos() {
    return location;
  }

  void displayShadow() {
    image.loadPixels();
    for (int x = 0; x < kinect.width; x++) {
      for (int y = 0; y < kinect.height; y++) {
        
        int offset = x + y * kinect.width;
        int rawDepth = depth[offset];
        int pix = x + y * image.width;
        
        if (rawDepth < threshold) {
          image.pixels[pix] = color(#091524);
        } else {
            image.pixels[pix] = color(#010812);
        }
      }
    }
    
    image.updatePixels();
    image(image, 0, 0,displayWidth, displayHeight);
  }
}
