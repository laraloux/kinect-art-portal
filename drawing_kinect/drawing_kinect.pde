import org.openkinect.freenect2.*;
import websockets.*;
import org.openkinect.freenect.*;
import org.openkinect.processing.*;

WebsocketClient wsc;
KinectTracker tracker;
Kinect kinect;

ArrayList<Paint> paintdrops = new ArrayList<Paint>();
 
void setup() {
  size(displayWidth, displayHeight);
  background(#041E2E);
  colorMode(HSB,360,100,100);
  
  kinect = new Kinect(this);
  tracker = new KinectTracker();
  wsc= new WebsocketClient(this, "ws://coco-sketch.herokuapp.com");
}
 
void draw() {
  tracker.track();
  tracker.display();
  PVector location = tracker.getLerpedPos();
  float xMapped = map(location.x, 0, 640, 0, displayWidth);
  float yMapped = map(location.y, 0, 480, 0, displayHeight);
  wsc.sendMessage(xMapped + "-" + yMapped);
  addPaintDrop(xMapped, yMapped);

  //wsc.sendMessage(mouseX + "-" + mouseY);
  //addPaintDrop(mouseX, mouseY); 
  drawPaintDrop();
}

void addPaintDrop(float x, float y){
  paintdrops.add(new Paint(x, y));
}

void drawPaintDrop(){
  for(int i = 0; i < paintdrops.size(); i++) {
    paintdrops.get(i).update();
    paintdrops.get(i).show() ;
    if(paintdrops.get(i).size>100){
      paintdrops.remove(i);
    }
  }
}

void webSocketEvent(String msg){
  String[] positions = msg.split("-");
  int x = parseInt(positions[0]);
  int y = parseInt(positions[1]);
  addPaintDrop(x,y);
}

void keyPressed() {
  int t = tracker.getThreshold();
  if (key == CODED) {
    if (keyCode == UP) {
      t+=5;
      tracker.setThreshold(t);
      println(t);
    } else if (keyCode == DOWN) {
      t-=5;
      tracker.setThreshold(t);
      println(t);
    }
  }
}
