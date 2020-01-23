import oscP5.*;
import netP5.*;

OscP5 goose;
NetAddress gHost;
int pNum=4;



//declaration des variables

//dés
int[] dice = new int[2];
int diceTotal;

//nombre de cases
int mapSize;

//position joueurs
int [] posJ = new int[4];

//premier tour
boolean firstTurn = true;

//regles speciales

//cases
cases [] cases = new cases[64];


int [] posX = new int [cases.length];



int decalage = 0;
int caseWidth = 24;

//pions et leur position
Pion [] pion = new Pion[4];

float avance = 0;
float [] avanceY = new float[4];
int [] posDepart = new int[4];
int [] posY = new int [4];
int aP = 0;


int casePion = 1;
 int [] casesJeu = new int[cases.length];
 int ajoutPosPion = 0;
boolean fautIlAvancer = false;
 
 boolean canClick = true;
 boolean reset = false;
 int tempPos = 0;
 boolean eviterRegleOie = true;
 int []  hotelTurnCount= new int [4];
 boolean reculerVers30 = false;
 
 PImage [] oie = new PImage[4];
 PImage imgOie;
boolean [] walk = new boolean [4];
int checkWalk = 0;

//backgrounds
PImage bg1;
PImage fg1;
PImage helice;
PImage [] tree = new PImage[8];
PImage enseigne;

int tourne = 0;
int windForce = 1;
int windChange = 1;
int changeTree = 0;

int nombreJ;

boolean tourFini = true;
boolean showText = false;




void setup() {
  size(1600,600);
  
  // pour le mode multijoueur en ligne (non fonctionnel actuellement)
  goose= new OscP5(this,1212);
  gHost = new NetAddress("172.22.119.143",1212);
  goose.plug(this, "countJ", "/countJ");
  
  
  diceTotal = 0;
  mapSize = 63;
  frameRate(240);
  //calculJeu();
 
  //charge les images du décor
  for (int i=0; i < oie.length; i++) {
    oie[i] = loadImage("ressources/oie" +(i+1) +".png");
  };
  imgOie = loadImage("ressources/oie1.png");
  bg1 = loadImage("ressources/décor_3_big.png");
  fg1 = loadImage("ressources/décor_1er_plan2.png");
  helice = loadImage("ressources/helice.png");
  enseigne = loadImage("ressources/enseigne.png");
  for (int i=0; i < tree.length; i++) {
    tree[i] = loadImage("ressources/tree_fg" +(i+1) +".png");
  };

  
  for (int i = 0; i < cases.length; i++) {
    cases[i] = new cases();
    posX[i] += 50 + decalage;
    decalage += caseWidth;
  };
  for (int i = 0; i < 4; i++) {
    pion[i] = new Pion();
    posDepart[i] = posX[0];
    walk[i] = false;
    avanceY[i] = 0;
    posY[i] = round(height /1.7);
    posY[i] += i*24;
    hotelTurnCount[i] = 0;
  };
  
};


void draw() {

      
        
    rectMode(CENTER);    
    drawBackground();
    dessinerCasesSpe();
    players();
    drawForeground();
    drawTree();
    positionText();
    drawHelice();
    wind();
    windForce();
    
    
    
  };
  
  //dessine le fond
  void drawBackground() {
    background(bg1);
  };
  
  void drawForeground() {
    image(fg1,0,0);
  };
  
  void drawTree() {
    if (windForce <5) {
      if (frameCount%50==0) {
        if (changeTree > 0) {
          changeTree--;
        };
      };
      image(tree[changeTree],0,0);
    }
    else if (windForce >=5 ) {
    image(tree[changeTree],0,0);
    if (frameCount%(65-((windForce/2)*10))==0) {
      if (changeTree <7) {
        changeTree +=1;
      }
      else {
        if (round(random(1,3)) > round(random(1,3))) {
          changeTree = round(random(5,6));
        }
        else{
        changeTree = 0;
        };
      };
    };
  }
  };
  
  
  //dessine les cases
  void dessinerCasesSpe() {
    for (int i = 0; i < cases.length; i++) {
    if (i%9 ==0 && i > 8 && i < 55) {
      fill(0,100,200);
    }
    else if (i ==19) {
      fill(200,20,100);
    }
    else if (i == 3) {
      fill(60,180,20);
    }
    else if (i == 42) {
      fill(112, 114, 144);
    }
    else if (i == 52) {
      fill(93, 94, 104);
    }
    else if (i == 58) {
      fill (223, 222, 217);
    }
    else {
      fill(62, 64, 71);
    };
    //cases[i].show(posX[i],round(height/1.5),caseWidth,160);
  };
  
  
  
};


//affiche les joueurs
void players() {
  fill(0);
  
  for (int i = 0; i < pNum; i++) {
    
    if (walk[i] == true) {
      pion[i].show(oie[checkWalk],posDepart[i],posY[i]+avanceY[i]);
      if (frameCount%40==0) {
      if (checkWalk <3) {
        checkWalk +=1;
      }
      else {
        checkWalk = 0;
      };
      };
    }
    else {
      pion[i].show(imgOie,posDepart[i],posY[i]+avanceY[i]);
    };
    
 };
  
  fill(83, 236, 222);
  if (fautIlAvancer == true) {
    avancerPion(ajoutPosPion);
    avancerY();
  };
  
  laby();
  resetGame();
};


//génère les changements à appliquer au vent aléatoiremet
void wind() {
  if (frameCount%400 ==0) {
    if (round(random(1,2)) == round(random(1,2))) {
      windChange = round(random(2,8));
    };
  };
};

//génère un vent de force aléatoire
void windForce() {
  if (frameCount%40==0) {
  if (windForce < windChange) {
    windForce ++;
  }
  else if (windForce > windChange) {
    windForce--;
  };
  };
};

//dessine et fait tourner l'hélice selon la vitesse du vent
void drawHelice() {
  imageMode(CENTER);
  translate(810, height-145);
  rotate(tourne*TWO_PI/360);
  image(helice,0,0);
  imageMode(CORNER);
  if (frameCount%6 == 0) {
    tourne+=windForce;
  };
};

void turnStartMsg() {
  println(" ");
  println("/******************************************************/");
  println("c'est au tour de joueur " + aP + " cliquez sur la souris pour avancer");
  println("/******************************************************/");
  println(" ");
};


void mouseClicked() {

      if (hotelTurnCount[aP] == 0) {
        turnStartMsg();
        if (canClick == true) {
          tourDeJeu();
        };
      }
      else {
        hotelTurnCount[aP]-=1;
        print("tour du joueur no " + aP + " passé");
        playerTurn();
      };
};


//lance deux dés (nombre entier aléatoires entre 1 et 6) et calcule sur quelle case le joueur actuel doit se rendre en prenant en compte les règles spéciales
//et cases spéciales du jeu de l'oie (reste puit et prison à implementer ainsi que règles spéciales si le joueur fait certains lancés de dé tour un)

void tourDeJeu() {
  showText = false;
  println("un");
  canClick = false;
  for (int i = 0; i < dice.length; i++) {
    dice[i] = constrain(ceil(random(6)),1,6);
    dice[i] = constrain(ceil(random(6)),1,6);
    //dice[0] = 58;
    //dice[1]=0;
      diceTotal += dice[i];
  };
  if (firstTurn == true && dice[0] == 4 && dice[1] == 5) {
    eviterRegleOie = false;
    firstTurn = false;
    tempPos = posJ[aP];
    posJ[aP] = 53;
    ajoutPosPion = 53 - tempPos;
    println(posJ[aP]);
    diceTotal = 0;
    
  }
  else if (posJ[aP] + diceTotal > 63) {
    println(diceTotal);
    println(posJ[aP]);
    ajoutPosPion = posJ[aP];
    posJ[aP] = mapSize-((posJ[aP]+diceTotal) - mapSize);
    
    if (ajoutPosPion > posJ[aP] && ajoutPosPion + diceTotal < 63) {
      ajoutPosPion = ajoutPosPion - posJ[aP];
      println("ajoutPosPion pos " + ajoutPosPion);
    }
    else {
      ajoutPosPion = (ajoutPosPion - posJ[aP]) - ((ajoutPosPion - posJ[aP])*2);
      println("ajoutPosPion neg " + ajoutPosPion);
    };
    
    println("pos joueur CONDITION =" + posJ[aP] + "   ");
    diceTotal = 0;
    firstTurn = false;
  }
  else {
    posJ[aP] += diceTotal;
    
    ajoutPosPion = diceTotal;
    
    diceTotal = 0; 
    println("pos joueur =" + posJ[aP] + "   ");
    firstTurn = false; 
  };
  println(ajoutPosPion);
  fautIlAvancer = true;
  showText = true;
}

void positionText() {
  if (showText == true) {
    println("text");
    textSize(24);
    fill(0);
    imageMode(CENTER);
    image(enseigne,width/2,34,440,70);
    imageMode(CORNER);
    //rect(width/2,40,440,50);
    fill(78, 70, 55);
    text("joueur " + (aP+1) + " est arrivé sur la case " + posJ[aP], width/2-176, 50);
  };
};

//remet le jeu à 0 quand un joueur gagne
void resetGame() {
  if (reset == true) {
  reset = false;
  avance = 0;
  for (int i=0; i <pNum;i++) {
  posJ[i] = 0;
  avanceY[i] = 0;
  posDepart[i] = posX[0];
  };
  ajoutPosPion = 0;
  };
};

//vérifie si un joueur est sur une case spéciale
void testCase() {
  tourFini = true;
  if(posJ[aP] == 63) {
          println("fini");
          reset = true;
          
        }
        else if (posJ[aP]%9 == 0 && posJ[aP] >8 && posJ[aP]<55 && eviterRegleOie ==true) {
          println("case oies");
          tourFini = false;
          casesOies();
        }
        else if(posJ[aP] ==19) {
          println("hotel");
          hotelTurnCount[aP] = 2;
        }
        else if(posJ[aP]==3) {
          println("puit");
        }
        else if(posJ[aP]==42) {
          println("labyrinthe");
          posJ[aP] =32;
          tourFini = false;
          reculerVers30 = true;
        }
        else if(posJ[aP] == 52) {
          println("prison");
        }
        else if(posJ[aP] == 58) {
          println("tete de mort");
          reset = true;
          resetGame();
        };
        eviterRegleOie = true;
};

//envoie le joueur sur la case 30 si il tombe sur la case labyrinthe
void laby() {
  if (reculerVers30 == true) {
      if (avance > caseWidth*-12) {
        if (frameCount%2 == 0) {
          walk[aP] = true;
          posDepart[aP]-=1;
          avance-=1;
          println("recule");
        };
      }
    else{
      reculerVers30 = false;
      posJ[aP]=30;
      avance=0;
      walk[aP]=false;
      tourFini = true;
      playerTurn();
    };
  };
};

void casesOies() {
  posJ[aP]+= ajoutPosPion;
  fautIlAvancer = true;
  avancerPion(ajoutPosPion);
  print(posJ[aP]);
};

void avancerY() {
  if (posDepart[aP] > 390 && posDepart[aP] < 490) {
    avanceY[aP]-=0.15;
  }
  else if (posDepart[aP] > 510 && posDepart[aP] < 650) {
    avanceY[aP]+=0.1;
  };
};

void avancerPion(int a) {
  walk[aP] = true;
  if (a != 0) {
    if (a > 0) {
      casePion += a;
      if (frameCount%2 == 0) {
        if (avance < caseWidth*a) {
          posDepart[aP] +=1;
          avance+=1;
        }
        else {
          avance = 0;
          fautIlAvancer = false;
          canClick = true;
          testCase();
          walk[aP] = false;
          playerTurn();
        };
      
      };
    };
   if (a < 0) {
     casePion -= a;
     if (frameCount%2 ==0) {
        if (avance > caseWidth*a) {
          avance-=1;
          posDepart[aP] -=1;
        }
        else {
          avance = 0;
          fautIlAvancer = false;
          canClick = true;
          testCase();
          walk[aP] = false;
          playerTurn();
        };
     };
   };
    
  }
  else {
    avance = 0;
    fautIlAvancer = false;
    canClick = true;
    walk[aP] = false;
    playerTurn();
  };
};

void playerTurn() {
  if (tourFini == true) {
    if (aP < pNum-1){
                aP++;
              }
              else {
                aP = 0;
              };
  }
};
