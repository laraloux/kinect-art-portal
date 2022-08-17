class KinectTracker {
  int threshold = 875;
  PVector loc;
  PVector lerpedLoc;
  int[] depth;
  PImage display;
   
  KinectTracker() {
    kinect.initDepth();
    kinect.enableMirror(true);
    
    display = createImage(kinect.width, kinect.height, RGB);
    
    loc = new PVector(0, 0);
    lerpedLoc = new PVector(0, 0);
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
      loc = new PVector(sumX/totalPixels, sumY/totalPixels);
    }

    lerpedLoc.x = PApplet.lerp(lerpedLoc.x, loc.x, 0.3f);
    lerpedLoc.y = PApplet.lerp(lerpedLoc.y, loc.y, 0.3f);
  }

  PVector getLerpedPos() {
    return lerpedLoc;
  }

  PVector getPos() {
    return loc;
  }

  void display() {
  // PImage img = kinect.getDepthImage();
  //  if (depth == null || img == null) return;

    display.loadPixels();
    for (int x = 0; x < kinect.width; x++) {
      for (int y = 0; y < kinect.height; y++) {
        
        int offset = x + y * kinect.width;
        int rawDepth = depth[offset];
        int pix = x + y * display.width;
        
        if (rawDepth < threshold) {
          display.pixels[pix] = color(#07334D,30);
        } else {
            display.pixels[pix] = color(#041E2E);
        }
      }
    }
    
    display.updatePixels();
    image(display, 0, 0,displayWidth, displayHeight);
  }

  int getThreshold() {
    return threshold;
  }

  void setThreshold(int t) {
    threshold =  t;
  }
}