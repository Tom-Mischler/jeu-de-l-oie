public class slider {
  
  int x;
  int y;
  int w;
  int h;
  int start;
  float plusMoins;
  
  public void show(int Tx,int Ty,int Tw,int Th,int Tstart) {
    x = Tx;
    y = Ty;
    w = Tw;
    h = Th;
    start = constrain(round(Tstart + plusMoins),1,4);
    fill(100);
    rect(x,y,w,h);
    fill(0);
    rect(x,y,h,h);
    rect(x+w-h,y,h,h);
    fill(255);
    textSize(28);
    text(start,(x+(w/2)-30),y+30);
  };
  
  
  public void changeValue(){
    if (mouseX > x && mouseX < (x+w)-(w-h) && mouseY > y && mouseY < (y+h)) {
      if (mousePressed == true) {
        if (start >0) {
          plusMoins +=1;
        };
      };
    };
    if (mouseX > (x+w)-h && mouseX < x+w && mouseY > y && mouseY < (y+h)) {
      if (mousePressed == true) {
        if (start < 255) {
            plusMoins -=1;
          };
      };
    };
  };
  
  public void changeColor(int a) {
    start = 0;
    plusMoins =a;
  };

  
  
};
