import websockets.*;
import org.openkinect.freenect.*;
import org.openkinect.processing.*;

WebsocketClient wsc;
KinectTracker tracker;
Kinect kinect;

ArrayList<Paint> paintdrops = new ArrayList<Paint>();
 
void setup() {
  size(displayWidth, displayHeight);
  background(#010812);
  colorMode(HSB,360,100,100);
  
  kinect = new Kinect(this);
  tracker = new KinectTracker();
  wsc= new WebsocketClient(this, "ws://coco-sketch.herokuapp.com");
}
 
void draw() {
  tracker.track();
  tracker.displayShadow();
  
  PVector location = tracker.getPos();
  float xMapped = map(location.x, 0, 640, 0, displayWidth);
  float yMapped = map(location.y, 0, 480, 0, displayHeight);
  wsc.sendMessage(xMapped + "-" + yMapped);
  
  addPaintDrop(xMapped, yMapped);
  drawPaintDrop();
}

void addPaintDrop(float x, float y){
  paintdrops.add(new Paint(x, y));
}

void drawPaintDrop(){
  for(int i = 0; i < paintdrops.size(); i++) {
    paintdrops.get(i).update();
    paintdrops.get(i).show() ;
    if(paintdrops.get(i).alpha<10){
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
