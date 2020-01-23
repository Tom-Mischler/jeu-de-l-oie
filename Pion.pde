public class Pion {
  float w = 18*1.9;
  float h = 18*2.5;
  
  public Pion() {
    
  };
  
  void show(PImage tImg,float tX,float tY) {
    image(tImg,tX-16,tY,w,h);
    //rect(tx,ty,wh,wh);
  };
};
