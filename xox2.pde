Board myBoard = new Board();
ArrayList<Ai[]> ais = new ArrayList<Ai[]>();

int delay = 1;

float stepSize = 0.005;

int generation = 0;
int drawGen = 0;
int ingen = 0;

int graphMem = 100000;

int HSBS = 220;
int HSBB = 255;

int aiPerGen = 128; //This is number to mess around with, maybe make it lower

int roundNumber = 0; 

boolean fightmeirl = false;

int turn = 0;
int numberOfGames = 0;

int gensRemembered = 64;

float graphScale = 256; 

color orangeCol = color(255, 179, 102);
color blueCol = color(102, 204, 255);

boolean init = true;
boolean spamGames = false;

boolean purge = false;

float spamAmount = 0.05;

int lastPlay = 0;

int roundsPerFrame = 1;

int initCount = 0;

TypeGraph graf = new TypeGraph();

boolean superRee = false;

winsGraph winGraf;

boolean startScreen = true;

int AiGap = 1;

int gamesThisGen = 0;

int aiGap = 1;

int currentAi1 = 0;
int currentAi2 = 1;

int bestOfLastGen = 0;

int gamesWithThisAi = 0;

int currentAi1wins = 0;
int currentAi2wins = 0;

boolean rematch = false;

int playingOnBlue = 0;
int playingOnRed = 1;

void setup() {
  size(1024, 512);
  background(0);
  myBoard.blank();
  frameRate(9999);
  winGraf = new winsGraph();
}

void mouseReleased() {
  if (!startScreen) {
  if (!fightmeirl) {
    spamGames = !spamGames;
    fill(0);
    noStroke();
    rect(0,0,511,height - graphScale-1);
    stroke(255);
    line(512, 0, 512, height - graphScale-1);
  } else {
    graf.drawGraph(0, height-graphScale, width, graphScale, true);
    if ((mouseX<32*4) && (mouseY<32*4)) {
      int tilex = floor(mouseX/32);
      int tiley = floor(mouseY/32);
      myBoard.tiles[0][tilex + tiley*4] = false;
      myBoard.tiles[1][tilex + tiley*4] = true;
      myBoard.tiles[2][tilex + tiley*4] = false;
      ais.get(generation-1)[bestOfLastGen].myBoardLayer = 2;
      int tile = ais.get(generation-1)[bestOfLastGen].makeAPLAY(myBoard);
      myBoard.tiles[0][tile] = false;
      myBoard.tiles[2][tile] = true;
    }
  }
  } else {
    int breakAbility = 0;
    for (int i = 0; i<5; i++) if (mouseX+16 > width/2 + ((2 - float(i))*128)) breakAbility++;
    println(breakAbility);
    aiPerGen = round(pow(2, 3+breakAbility));
    println(aiPerGen);
    startScreen = false;
  }
}

void draw() {
  if (startScreen==true) {stat();} else {men();}
}

void stat() {
  fill(255);
  background(0);
  textAlign(CENTER, BOTTOM);
  textSize(40);
  text("How badly do you want to melt your computer?", width/2, height/2 - 16);
  stroke(255);
  line(0, height/2, width, height/2);
  textSize(24);
  textAlign(CENTER, TOP);
  for (int i = 0; i<5; i++) {
    fill(0);
    float centerX = width/2 + ((2 - float(i))*128);
    if (mouseX>centerX-24) fill(255);
    float centerY = height/2 + 32;
    star(centerX, centerY, 16, 24, 6); 
  }
}

void men() {
    if (init) {
    for (int i = 0; i < 2; i++) {
    background(0);
    addAndRandomiseAgennyBoi(false);
    if (initCount > gensRemembered) init = false;
    initCount++;
    myBoard.blank();
    textAlign(CENTER, BOTTOM);
    textSize(128);
    text("loading: " + (100*initCount/gensRemembered) + "%", width/2, height/2 - 16);
    stroke(255);
    line(0, height/2, width, height/2);
    textSize(24);
    textAlign(CENTER, TOP);
    if (aiPerGen == 8) text("I dont even know if it'll work with such limited rescources", width/2, height/2+16);
    if (aiPerGen == 16) text("Coward", width/2, height/2+16);
    if (aiPerGen == 32) text("Boring", width/2, height/2+16);
    if (aiPerGen == 64) text("Respectable.", width/2, height/2+16);
    if (aiPerGen == 128) text("I hope you enjoyed your ram and cpu while they lasted.", width/2, height/2+16);
    if (aiPerGen == 256) text("Oh. Can I get a rip in the chat for your computer?", width/2, height/2+16);
    if (initCount > gensRemembered) {
      background(0);
      noStroke();
      graf.upDate();
      graf.drawGraph(0, height-graphScale, width, graphScale, true);
    }
    }
  } else {
  
  //draw some ui
  if (spamGames) {pround(); roundsPerFrame = min(round(aiPerGen*aiPerGen*8*spamAmount), 256);} else {
    roundsPerFrame = 1;
  }
  if (!superRee) {
  fill(0);
  noStroke();
  rect(0,0,511,height - graphScale-1);
  stroke(255);
  line(32*4, 0, 32*4, 32*4);
  line(0, height - graphScale-1, width, height - graphScale-1);
  line(512, 0, 512, height - graphScale-1);
  fill(orangeCol);
  rect(-1, 32*4, 32*4+1,32);
  fill(blueCol);
  rect(-1, 32*5, 32*4+1,32);
  noStroke();
  textAlign(LEFT, TOP);
  textSize(32);
  fill(255);
  colorMode(HSB);
  if (fightmeirl) text("YOO", 0, 32*4); else {
    fill(ais.get(generation)[currentAi1].red, HSBS, HSBB);
    triangle(-1, 32*4, -1, 32*5, 32*3, 32*4.5);
  }
  fill(ais.get(generation)[currentAi2].red, HSBS, HSBB);
  triangle(-1, 32*5, -1, 32*6, 32*3, 32*5.5);
  colorMode(RGB);
  if (!spamGames) stroke(255);
  displayBoard(myBoard, 0, 0, 32);
  noStroke();
  textSize(72);
  fill(255);
  text("Generation ", 32*4, 0);
  textSize(128);
  text(drawGen, 32*4, 72);
  noStroke();
  }
  //play
  if (!fightmeirl) {
  for (int i = 0; i<roundsPerFrame; i++) {
  if (spamGames) pround();
  if (roundNumber>16) gameDone(-2, -2);
  
  //check win + pick new ais.
  if (checkWin(myBoard) == 0) {} else {
    int winner = checkWin(myBoard);
    int winnerIndex = 0;
    int loserIndex = 0;
    if (winner == 1) {winnerIndex = currentAi1; loserIndex = currentAi2;}
    if (winner == 2) {winnerIndex = currentAi2; loserIndex = currentAi1;}
    gameDone(winnerIndex, loserIndex);
  }
  }
  } else {
    
  }
}
}

void pround() {
  turn = abs(turn-1);
  int tile = 0;
  if (turn == 0) {
    tile = ais.get(generation)[currentAi1].makeAPLAY(myBoard);
    myBoard.tiles[0][tile] = false;
    myBoard.tiles[1][tile] = true;
  } else {
    tile = ais.get(generation)[currentAi2].makeAPLAY(myBoard);
    myBoard.tiles[0][tile] = false;
    myBoard.tiles[2][tile] = true;
  }
  lastPlay = tile;
  roundNumber++;
}

void addAndRandomiseAgennyBoi(boolean random) {
  ais.add(new Ai[aiPerGen]); 
  for (int j = 0; j<aiPerGen; j++) {
    ais.get(ais.size()-1)[j] = new Ai();
    ais.get(ais.size()-1)[j].initialise(random);
    ais.get(ais.size()-1)[j].position = j;
  }
}

void gameDone(int winnerIndex, int loserIndex) {
   /* used in a tad instead
   ais.get(((generation+1) % gensRemembered))[winnerIndex] = ais.get(generation)[winnerIndex];
   ais.get(((generation+1) % gensRemembered))[loserIndex] = ais.get(generation)[winnerIndex];
   ais.get(((generation+1) % gensRemembered))[loserIndex].evolve();
   */
   roundNumber = 0;
   turn = int((gamesWithThisAi > aiPerGen));
   // A S S I G N N E W A I S
   if (gamesThisGen >= aiPerGen-1) {
     float[][] aiWinForAi = new float[aiPerGen][2];
     for (int i = 0; i<aiWinForAi.length; i++) {
       aiWinForAi[i][1] = 0;
       aiWinForAi[i][0] = i;
     }
     for (int i = 0; i<aiWinForAi.length; i++) {
         aiWinForAi[i][0] = ais.get(generation)[i].wins;
         aiWinForAi[i][1] = i;
     }
     //for (int i = 0; i<aiWinForAi.length; i++) println(aiWinForAi[i][1]+","+aiWinForAi[i][0]);
     for (int i = 0; i<aiWinForAi.length; i++) {
       int maxWinsIndex = i;
       for (int j = i; j<aiWinForAi.length; j++) {
         if (aiWinForAi[j][0] < aiWinForAi[maxWinsIndex][0]) maxWinsIndex = j;
       }
       float temp0 = aiWinForAi[i][0];   
       float temp1 = aiWinForAi[i][1];   
       aiWinForAi[i][0] = aiWinForAi[maxWinsIndex][0];
       aiWinForAi[i][1] = aiWinForAi[maxWinsIndex][1];
       aiWinForAi[maxWinsIndex][0] = temp0;
       aiWinForAi[maxWinsIndex][1] = temp1;
     }
     //for (int i = 0; i<aiWinForAi.length; i++) println(aiWinForAi[i][1]+","+aiWinForAi[i][0]);
     //for (int i = 0; i<aiPerGen; i++) if (aiWinForAi[i][1] >= 0) aiWinForAi[i][0] = ais.get(generation)[aiWinForAi[i][1]].wins;
     //println("---");
     //for (int i = 0; i<aiPerGen; i++) println(aiWinForAi[i][0]);
     winGraf.update(aiWinForAi);
     bestOfLastGen = int(aiWinForAi[aiPerGen-1][1]);
     for (int i = 0; i<round(aiPerGen/4); i++) {
       //bottom Gets replaced with top (top stays)
       replaceAiWithAdifferentAi(ais.get(((generation+1) % gensRemembered))[int(aiWinForAi[i][1])], ais.get(generation)[int(aiWinForAi[i+aiPerGen-round(aiPerGen/4)][1])]);
       //top Stays (bottom evolves)
       //ais.get(generation)[int(aiWinForAi[i+aiPerGen-round(aiPerGen/4)][1])].takeSteps();
       ais.get(generation)[int(aiWinForAi[i+aiPerGen-round(aiPerGen/4)][1])].evolve();
       replaceAiWithAdifferentAi(ais.get(((generation+1) % gensRemembered))[int(aiWinForAi[i+aiPerGen-round(aiPerGen/4)][1])], ais.get(generation)[int(aiWinForAi[i+aiPerGen-round(aiPerGen/4)][1])]);
       //topMiddle stays but evolves 
       ais.get((generation))[int(aiWinForAi[i+2*round(aiPerGen/4)][1])].evolve();
       replaceAiWithAdifferentAi(ais.get(((generation+1) % gensRemembered))[int(aiWinForAi[i+2*round(aiPerGen/4)][1])], ais.get(generation)[int(aiWinForAi[i+2*round(aiPerGen/4)][1])]);
       //bottomMiddle -s-t-a-y-s-b-u-t-e-v-o-l-v-e-s- gets randomed
       //ais.get((generation))[int(aiWinForAi[i+round(aiPerGen/4)][1])].takeSteps();
       //ais.get(generation)[int(aiWinForAi[i+round(aiPerGen/4)][1])].evolve();
       ais.get(((generation+1) % gensRemembered))[int(aiWinForAi[i+round(aiPerGen/4)][1])].initialise(true);
       //replaceAiWithAdifferentAi(ais.get(((generation+1) % gensRemembered))[int(aiWinForAi[i+round(aiPerGen/4)][1])], ais.get(generation)[int(aiWinForAi[i+round(aiPerGen/4)][1])]);
     }
     if (purge) {
       int ran1 = round(random(aiPerGen));
       int ran2 = round(random(aiPerGen));
       
       for (int i = min(ran1,ran2); i<max(ran1,ran2); i++) {
        ais.get((generation) % gensRemembered)[i].initialise(true);
        ais.get((generation+1) % gensRemembered)[i].initialise(true);
       }
     }

     //if (random(50) > 49) purge = !purge;
     if (((drawGen % 100) == 1) && (drawGen > 1)) {
         String[] brainString = new String[ais.get(generation-1)[bestOfLastGen].layers];
         for (int i = 1; i<brainString.length; i++) {
           brainString[i] = "";
           for (int j = 0; j<ais.get(generation-1)[bestOfLastGen].Axons.get(i).length; j++) {
             //brainString[i]
           }
         }
     }
     aiGap = round(random(1, aiPerGen/2));
     graf.upDate();
     if (!superRee) graf.drawGraph(0, height-graphScale, width, graphScale, true);
     generation = ((generation+1) % gensRemembered);
     if (!superRee) winGraf.display(512, 0, width-512, height - graphScale-1);
     drawGen++;
     //if (round(random(0,10)) == 1) {AiGap=ceil(random(0, 32));} else AiGap=1;
     AiGap=-AiGap;
     currentAi1 = 0;
     ais.get(generation)[currentAi1].myBoardLayer = 1;
     currentAi2 = 0;
     ais.get(generation)[currentAi2].myBoardLayer = 2;
     gamesThisGen=0;
     
   } else if (rematch) {
       ais.get(generation)[currentAi1].wins = currentAi1wins;
       currentAi1wins = 0;
       currentAi2wins = 0;
       rematch = false;
       currentAi1++;
       ais.get(generation)[currentAi1].myBoardLayer = 1;
       currentAi2 = 0;
       gamesThisGen++;
       gamesWithThisAi = 0;
     } else {
     if (gamesWithThisAi >= ((aiPerGen/aiGap)-1)*2) {rematch = true;} else {
     currentAi2 = (currentAi2 + aiGap) % aiPerGen;
     gamesWithThisAi++;
     ais.get(generation)[currentAi2].myBoardLayer = 2;
     if (winnerIndex == currentAi1) {
       currentAi1wins++;
       ais.get(generation)[currentAi1].probSteps[lastPlay] += stepSize*1/2;
       for (int i = 0; i<ais.get(generation)[currentAi1].probSteps.length; i++) if (!(i == lastPlay)) ais.get(generation)[currentAi1].probSteps[i] -= stepSize*1/32;
     } else {
       if (gamesWithThisAi > aiPerGen) {currentAi1wins-=0.25;}
       ais.get(generation)[currentAi1].probSteps[lastPlay] += stepSize*1/2;
       for (int i = 0; i<ais.get(generation)[currentAi1].probSteps.length; i++) if (!(i == lastPlay)) ais.get(generation)[currentAi1].probSteps[i] -= stepSize*1/32;
     }
     } 
   }
   myBoard.blank();
   

}

class Ai {
  float [] probSteps = new float[16];
  int myBoardLayer = 1;
  int axonPerLayer = 64;
  float wins = 0;
  int position = 0;
  int layers = 3;  
  ArrayList<Axon[]> Axons = new ArrayList<Axon[]>(0); 
  float red = random(360);
  float green = random(255);
  float blue = random(255);
  float mute = random(0.1);
  void initialise(boolean random) {
    for (int i = 0; i<probSteps.length; i++) probSteps[i] = 0;
    red = random(360);
    green = random(255);
    blue = random(255);
    mute = random(0.08, 0.12);
    Axons.add(new Axon[48]);
    for (int i = 0; i<48; i++) Axons.get(0)[i] = new Axon();
    for (int i = 1; i<layers; i++) {
      if (i == (layers-1)) {Axons.add(new Axon[16]);} else if (i == (0)) {Axons.add(new Axon[48]);} else {Axons.add(new Axon[axonPerLayer]);}
      for (int j = 0; j<Axons.get(i).length; j++) {
        Axons.get(i)[j] = new Axon();
        Axons.get(i)[j].inputWeights = new float[Axons.get(i-1).length];
        Axons.get(i)[j].value = 0;
        for (int k = 0; k<Axons.get(i-1).length; k++) {
          Axons.get(i)[j].inputWeights[k] = (random(2)-1)*int(random);
          Axons.get(i)[j].bias = 0;//(random(2)-1)*int(random);
          //Axons.get(i)[j].inputs[k][0] = k;
          //Axons.get(i)[j].inputs[k][1] = i-1;
        }
      }
    }
  }
  
  void takeSteps() {
    //float[] probSteps2 = new float[Axons.get(layers-2).length];
    //for (int j = 0; j<probSteps2.length; j++) probSteps2[j] = 0;
    for (int j = 0; j<Axons.get(layers-1).length; j++) {
      for (int k = 0; k<Axons.get(layers-1)[j].inputWeights.length; k++) {
        Axons.get(layers-1)[j].inputWeights[k]+=float(Axons.get(layers-1)[j].increaseOrDecrease)*stepSize;
        Axons.get(layers-2)[j].increaseOrDecrease+=sign(Axons.get(layers-1)[j].increaseOrDecrease);
        //probSteps2[k]+=sign(Axons.get(layers-1)[j].inputWeights[j]);
      }
    } /*
    for (int j = 0; j<Axons.get(layers-2).length; j++) {
      for (int k = 0; k<Axons.get(layers-2)[j].inputWeights.length; k++) {
        Axons.get(layers-2)[j].inputWeights[k]+=float(Axons.get(layers-2)[j].increaseOrDecrease)*stepSize;
        Axons.get(layers-3)[j].increaseOrDecrease+=sign(Axons.get(layers-2)[j].increaseOrDecrease);
        //probSteps2[k]+=sign(Axons.get(layers-1)[j].inputWeights[j]);
      }
    }*/
    
    /*
    for (int i = layers-2; i>0; i--) {
      for (int j = 0; j<Axons.get(i).length; j++) {
      for (int k = 0; k<Axons.get(i)[j].inputWeights.length; k++) {
        Axons.get(layers)[j].inputWeights[k]+=probSteps2[k];
      }
    }
    }*/
  }
  
  void evolve() {
    red = (mute*10 + red) % 360;
    if (red<=0) red = 360+red;
    green += sign(random(-1, 1))*2;
    blue += sign(random(-1, 1))*2;
    mute += random(-0.1, 0.1);
    for (int i = 1; i<layers; i++) {
      for (int j = 0; j<Axons.get(i).length; j++) {
        //Axons.get(i)[j].bias += random(-mute, mute);
        for (int k = 0; k<Axons.get(i)[j].inputWeights.length; k++) {
            Axons.get(i)[j].inputWeights[k] += random(-mute, mute)*Axons.get(i)[j].usedSinceEvolution;
        }
        Axons.get(i)[j].value = 0;
        Axons.get(i)[j].usedSinceEvolution = 0;
      }
    }
  }
  

  
  
  int makeAPLAY(Board lebord) {
    int choice = 0;
    while ((myBoard.tiles[0][choice] == false) && (choice<15)) choice++;
    for (int i = 0; i<16; i++) {
      Axons.get(0)[i].value = int(lebord.tiles[0][i % 16]);
    }
    for (int i = 16; i<32; i++) {
      Axons.get(0)[i].value = int(lebord.tiles[myBoardLayer][i % 16]);
    }
    for (int i = 32; i<48; i++) {
      Axons.get(0)[i].value = int(lebord.tiles[abs(myBoardLayer-1)][i % 16]);
    }
    for (int i = 1; i<layers; i++) {
      for (int j = 0; j<Axons.get(i).length; j++) {
        Axons.get(i)[j].value = Axons.get(i)[j].bias;
        for (int k = 0; k<Axons.get(i-1).length; k++) {
          Axons.get(i)[j].value += Axons.get(i)[j].inputWeights[k]*Axons.get(i-1)[k].value;
          Axons.get(i)[j].usedSinceEvolution += 0.01;
        }
        Axons.get(i)[j].value = 1/(1+pow( 2.71828182846, -Axons.get(i)[j].value));
      }
    }
    for (int i  = 0; i < 16; i++) if (Axons.get(layers-1)[i].value > Axons.get(layers-1)[choice].value) if (myBoard.tiles[0][i]) {choice = i;}
    return choice;
  }
}

class Axon {
  int increaseOrDecrease = 0;
  float[] inputWeights = new float[48];
  float bias;
  int[][] inputs = new int[48][2];
  float value;
  float usedSinceEvolution = 0;
  int layer;
}

class Board {
  boolean[][] tiles = new boolean[3][16];
  void blank() {
    for (int i = 0; i < 16; i++) tiles[0][i] = true;
    for (int i = 0; i < 16; i++) tiles[1][i] = false;
    for (int i = 0; i < 16; i++) tiles[2][i] = false;
  }
}

void displayBoard(Board dispBoard, float x, float y, float squareSize) {
  colorMode(RGB);
  fill(200);
  for (int i = 0; i < 16; i++) if (dispBoard.tiles[0][i]) rect(x + (i % 4)*squareSize,y + floor(i/4)*squareSize, squareSize, squareSize);
  fill(blueCol);
  for (int i = 0; i < 16; i++) if (dispBoard.tiles[1][i]) rect(x + (i % 4)*squareSize,y + floor(i/4)*squareSize, squareSize, squareSize);
  fill(orangeCol);
  for (int i = 0; i < 16; i++) if (dispBoard.tiles[2][i]) rect(x + (i % 4)*squareSize,y + floor(i/4)*squareSize, squareSize, squareSize);
}

int checkWin(Board theboard) {
  int[][][] board = new int[4][4][3];
  for (int i = 0; i < 16; i++) for (int k = 0; k < 3; k++) board[i % 4][floor(i/4)][k] = int(theboard.tiles[k][i]);
  int winner = 0;
  for (int winTurn = 0; winTurn<2; winTurn++) {
    if ((board[0][0][winTurn+1]+board[1][1][winTurn+1]+board[2][2][winTurn+1]+board[3][3][winTurn+1])==4) winner = winTurn+1;
    if ((board[0][3][winTurn+1]+board[1][2][winTurn+1]+board[2][1][winTurn+1]+board[3][0][winTurn+1])==4) winner = winTurn+1;
    
    int i = 0;
    while (i<4) {
    if ((board[i][0][winTurn+1]+board[i][1][winTurn+1]+board[i][2][winTurn+1]+board[i][3][winTurn+1])==4) winner = winTurn+1;
    if ((board[0][i][winTurn+1]+board[1][i][winTurn+1]+board[2][i][winTurn+1]+board[3][i][winTurn+1])==4) winner = winTurn+1;
    i++;
    }
    
    i = 0;
    while (i<3) {
    if ((board[i][0][winTurn+1]+board[i][1][winTurn+1]+board[i+1][2][winTurn+1]+board[i+1][3][winTurn+1])==4) winner = winTurn+1;
    if ((board[0][i][winTurn+1]+board[1][i][winTurn+1]+board[2][i+1][winTurn+1]+board[3][i+1][winTurn+1])==4) winner = winTurn+1;
    if ((board[i][3][winTurn+1]+board[i][2][winTurn+1]+board[i+1][1][winTurn+1]+board[i+1][0][winTurn+1])==4) winner = winTurn+1;
    if ((board[3][i][winTurn+1]+board[2][i][winTurn+1]+board[1][i+1][winTurn+1]+board[0][i+1][winTurn+1])==4) winner = winTurn+1;
    i++;
    }
    
    i = 0;
    while (i<2) {
    if ((board[i][0][winTurn+1]+board[i+1][1][winTurn+1]+board[i+1][2][winTurn+1]+board[i+2][3][winTurn+1])==4) winner = winTurn+1;
    if ((board[0][i][winTurn+1]+board[1][i+1][winTurn+1]+board[2][i+1][winTurn+1]+board[3][i+2][winTurn+1])==4) winner = winTurn+1;
    
    if ((board[i][3][winTurn+1]+board[i+1][2][winTurn+1]+board[i+1][1][winTurn+1]+board[i+2][0][winTurn+1])==4) winner = winTurn+1;
    if ((board[3][i][winTurn+1]+board[2][i+1][winTurn+1]+board[1][i+1][winTurn+1]+board[0][i+2][winTurn+1])==4) winner = winTurn+1;
    i++;
    }
  }
  return winner;
}

void keyPressed() {
  if ((keyCode=='n') || (keyCode=='N')) pround(); //n for nutt
  if ((keyCode=='s') || (keyCode=='S')) {superRee = !superRee; background(0); text("re.", width/2, height/2);} //s for sped
  if ((keyCode=='r') || (keyCode=='R')) myBoard.blank(); //r for rekt
  if ((keyCode=='l') || (keyCode=='L')) {fightmeirl = !fightmeirl; myBoard.blank();} //l for LETS-GO!!
  if ((keyCode=='k') || (keyCode=='K')) { //k for killer keem star
    for (int i = round(aiPerGen/2); i<aiPerGen; i++) {
      ais.get((generation) % gensRemembered)[i].initialise(true);
      ais.get((generation+1) % gensRemembered)[i].initialise(true);
    }      
  }
}

int sign(float n) {
  if (n >= 0 ) return 1; else return - 1;
}

void replaceAiWithAdifferentAi(Ai Ai1, Ai Ai2) {
  for (int i = 0; i<Ai1.probSteps.length; i++) Ai1.probSteps[i] = 0;
  Ai1.position = Ai2.position;
  Ai1.mute = Ai2.mute;
  Ai1.red = Ai2.red;
  Ai1.green = Ai2.green;
  Ai1.blue = Ai2.blue;
  Ai1.layers = Ai2.layers;
  for (int i = 0; i<48; i++) replaceAxonWithAdifferentAxon(Ai1.Axons.get(0)[i], Ai2.Axons.get(0)[i]);
  for (int i = 1; i<Ai1.layers; i++) {
    for (int j = 0; j<Ai1.Axons.get(i).length; j++) {
      replaceAxonWithAdifferentAxon(Ai1.Axons.get(i)[j], Ai2.Axons.get(i)[j]);
    }
  }
}

void replaceAxonWithAdifferentAxon(Axon Axon1, Axon Axon2) {
  for (int i = 0; i<Axon2.inputWeights.length; i++) Axon1.inputWeights[i] = Axon2.inputWeights[i];
  Axon1.bias = Axon2.bias;
  Axon1.usedSinceEvolution = 0;
  Axon1.increaseOrDecrease = 0;
}

class TypeGraph {
  ArrayList<color[]> cols = new ArrayList<color[]>(0);
  void upDate() {
    cols.add(new color[aiPerGen]);
    float[] tempcols = new float[aiPerGen];
    for (int i = 0; i<aiPerGen; i++) {
      //cols.get(cols.size()-1)[i] = color(ais.get(generation)[i].red, ais.get(generation)[i].green, ais.get(generation)[i].blue);
      tempcols[i] = ais.get(generation)[i].red % 360;
      //cols.get(cols.size()-1)[i] = color(ais.get(generation % gensRemembered)[ais.get(generation % gensRemembered)[i].position].red, ais.get(generation % gensRemembered)[ais.get(generation % gensRemembered)[i].position].green, ais.get(generation % gensRemembered)[ais.get(generation % gensRemembered)[i].position].blue);
    }
    tempcols = sort(tempcols);
    colorMode(HSB);
    for (int i = 0; i<aiPerGen; i++) cols.get(cols.size()-1)[i] = color(tempcols[i], HSBS, HSBB);
    colorMode(RGB);
    
  }
  void drawGraph(float x, float y, float wid, float hei, boolean Pos) {
    for (int ingen = 0; ingen < cols.size(); ingen+=max(round(cols.size()/wid),1)) {
      for (int i=0; i<aiPerGen; i++) {
        fill(cols.get(ingen)[i]);
        rect(map(ingen, 0, cols.size(), x, x+wid), map(i, 0, aiPerGen, y, y+hei), ceil(wid/cols.size()), ceil(hei/aiPerGen));
      }
    }
  }
}

class winsGraph {
  int noDataLines = 5;
  float genGap = 128;
  float maxWins = 0;
  ArrayList<float[]> wins = new ArrayList<float[]>(0);
  winsGraph() {
    wins.add(new float[11]);
    for (int i = 0; i<11; i++) wins.get(0)[i] = 0;
  }
  
  void update(float[][] aiWinForAi) {
    wins.add(new float[noDataLines]);
    for (int i = 0; i<noDataLines; i++) wins.get(wins.size()-1)[i] = aiWinForAi[floor(float(i)/(noDataLines-1) * float(aiPerGen-1))][0]*aiGap;
    maxWins = max(maxWins, round(wins.get(wins.size()-1)[noDataLines-1] * 1.25));
  }
  
  void display(float x, float y, float wid, float hei) {
    
    genGap = wid/6;
    fill(0);
    noStroke();
    rect(x,y,wid,hei);
    stroke(204, 0, 0);
    float noLines = 5;
    for (float i = 0; i<noLines; i++) line(x, y+(hei*(i/noLines)), x+wid, y+(hei*i/noLines));
    fill(204, 0, 0);
    textAlign(BOTTOM, LEFT);
    textSize(12);
    text(round(maxWins/1.2), x+1, y+(hei*(1/noLines)) -1);
    stroke(255);
    for (int i = 1; i<wins.size(); i += ceil(wins.size()/genGap) ) {
      for (int j = 0; j<noDataLines; j++) {
        line(x + (float(max(i-ceil(wins.size()/genGap), 0))/wins.size())*wid,-2+ y+hei - wins.get(max(i-ceil(wins.size()/genGap), 0))[j]*(hei/maxWins), x + (float(i)/wins.size())*wid,-2+ y+hei - wins.get(i)[j]*(hei/maxWins));
      }
    }
    line(x,y,x,hei);
  }
  
}

void star(float x, float y, float radius1, float radius2, int npoints) {
  float angle = TWO_PI / npoints;
  float halfAngle = angle/2.0;
  beginShape();
  for (float a = 0; a < TWO_PI; a += angle) {
    float sx = x + cos(a) * radius2;
    float sy = y + sin(a) * radius2;
    vertex(sx, sy);
    sx = x + cos(a+halfAngle) * radius1;
    sy = y + sin(a+halfAngle) * radius1;
    vertex(sx, sy);
  }
  endShape(CLOSE);
}
