class Paint{
  
  PVector location;
  PVector velocity;
  float size;
  float alpha;
  float yOff;
  
  Paint(float xPos,float yPos){
    this.location = new PVector(xPos,yPos);
    this.velocity = new PVector(0,0.01);
    this.alpha = 50;
    this.size = 20;  
  }
  
  void update(){
    this.location.add(this.velocity);
    this.alpha -= 0.01 * noise(yOff);
    this.size-= -0.1 * noise(yOff);
  }
    
  void show(){
    noStroke() ;
    fill(map(this.alpha,50,0,240,80),70, 100 ,this.alpha);
    circle(this.location.x, this.location.y, this.size);
  }
}
