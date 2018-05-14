int[][] leboard = new int[16][17];
int turn = 0;
String[] lines;
float learningRate = 0.001;

int turnBack = 0;

int correct = 0;

boolean teachC3PO = false;

color ai1 = color(195, 49, 73);
color ai2 = color(168, 194, 86);

int lrMulti = 10;

boolean mousePressedB = false;
boolean learnFromAi = false;
boolean xoxoLearn = false;
boolean uvai = false;

PrintWriter games;

Network theOdds = new Network(49, 50, 1, 4, 1);
Network AI1 = new Network(49, 32, 16, 5, 1);
Network AI2 = new Network(49, 32, 16, 5, 1);

int correctAI = 0;
int correctAItotes = 0;

PFont font;

void setup() {
  frameRate(9001);
  size(256, 368);
  for (int i = 0; i<16; i++) for (int j = 0; j<17; j++) leboard[i][j] = 0;
  lines = loadStrings("games.txt");
  games = createWriter("gamesAi.txt");
  font = loadFont("CenturyGothic-BoldItalic-48.vlw");
}

void draw() {
  textFont(font);
  background(0);
  drawBoard(0, 0, 128, 128);
  fill(222, 239, 183);
  rect(0, 128, 128, 32+16);
  fill(152, 223, 175);
  stroke(222, 239, 183);
  if (teachC3PO) rect(1, 128 + 1, 128*(turnBack+1)/16 -2, 32+16 - 2);
  stroke(0);
  if (hitbox(0, 128, 128, 32+16, 3, false, color(0))) {
    teachC3PO = !teachC3PO;
    turnBack = floor(16 * mouseX/128);
  }
  if (!teachC3PO) {fill(#4E598C);} else {fill(255);}
  textAlign(CENTER, CENTER);
  textSize(38);
  text("CP30", 64, 128 + (32+16)/2);
  if (teachC3PO) trainTheOdds(learningRate);
  fill(255);
  if (teachC3PO) text(correct/20+"%", 128+40, 128 + (32+16)/2);
  
  fill(#222222);
  rect(128, 128 + 48*2, 128, 48);
  fill(#414288);
  noStroke();
  rect(128+4, 128+4 + 48*2, (128-8)*(float(lrMulti)/10), 48-8);
  stroke(0);
  fill(#E3E4DB);
  textSize(18);
  text(str(learningRate), 128 + (128-8)/2, 128 + 48*2 + 48/2);
  if (hitbox(128, 128 + 48*2, 128, 48, 2, false, color(0))) {
    lrMulti = round(10 * (float(mouseX)-128)/128);
    learningRate = pow(10, -(10-lrMulti));
  }
  
  float aio = round(getOdds()*100);
  textSize(28);
  fill(ai1);
  text(int(aio) + "%", 128 + 34, 16);
  fill(ai2);
  text(100 - int(aio) + "%", 128 + 64+32, 16);
  
  fill(95, 180, 156);
  rect(0, 128+32+16, 128, 32+16);
  if (hitbox(0, 128+32+16, 128, 32+16, 3, false, color(0))) {
    xoxoLearn = !xoxoLearn;
    turn = 0;
    for (int i = 0; i<16; i++) leboard[i][0] = 0;
  }
  if (xoxoLearn) {fill(255);} else {fill(65, 66, 136);}
  textSize(38);
  text("xoxo", 64, 128+32+16 + (32+16)/2);
  correctAI = 0;
  correctAItotes = 0;
  if (xoxoLearn) for (int i = 0; i<1000; i++) aiPlayAndLearn(learningRate*turn);
  //if (xoxoLearn) text(round(100 * correctAI/( float(correctAItotes)))+"%", 128+40, 128+32+16 + (32+16)/2);
  
  fill(152, 223, 175);
  rect(0, 128+32+16+32+16, 128, 32+16);
  if (hitbox(0, 128+32+16+32+16, 128, 32+16, 3, false, color(0))) {
    learnFromAi = !learnFromAi;
  }
  if (learnFromAi) {fill(255);} else {fill(65, 66, 136);}
  textSize(32);
  text("improv", 64, 128+32+16+32+16 + (32+16)/2);
  if (learnFromAi) {
    lines = loadStrings("gamesAi.txt");
  } else lines = loadStrings("games.txt");
  
  fill(#222222);
  rect(0, 128+32+16+32+16+32+16, 128, 32+16);
  if (hitbox(0, 128+32+16+32+16+32+16, 128, 32+16, 3, false, color(0))) {
    uvai = !uvai;
  }
  if (uvai) {
    fill(#E3E4DB);
    text("u vs. ai", 64, 128+32+16+32+16+32+16 + (32+16)/2);
  } else {
    fill(#7E78D2);
    text("u vs. u", 64, 128+32+16+32+16+32+16 + (32+16)/2);
  }
  textSize(32);
  
  if (learnFromAi) {
    lines = loadStrings("gamesAi.txt");
  } else lines = loadStrings("games.txt");
  
  fill(#deefb7);
  rect(0, 128+32+16+32+16+32+16+32+16, (128)/2, 32+16);
  if (hitbox(0, 128+32+16+32+16+32+16+32+16, (128)/2, 32+16, 3, false, color(0))) {
    theOdds.export("c3po.txt");
  }
  fill(#98dfaf);
  rect((128)/2, 128+32+16+32+16+32+16+32+16, (128)/2, 32+16);
  if (hitbox((128)/2, 128+32+16+32+16+32+16+32+16, (128)/2, 32+16, 3, false, color(0))) {
    AI1.export("AI1.txt");
    AI2.export("AI2.txt");
  }
  textSize(18);
  fill(#37393A);
  text("export", (128)/4, 128+32+16+32+16+32+16+32+16 + 0.25*(32+16));
  text("export", (128)/4 + (128)/2, 128+32+16+32+16+32+16+32+16 + 0.25*(32+16));
  textSize(22);
  text("C3PO", (128)/4, 128+32+16+32+16+32+16+32+16 + 0.65*(32+16));
  text("xoxo", (128)/4 + (128)/2, 128+32+16+32+16+32+16+32+16 + 0.65*(32+16));
  
  fill(#414288);
  rect(2*(128)/2, 128+32+16+32+16+32+16+32+16, (128)/2, 32+16);
  if (hitbox(2*(128)/2, 128+32+16+32+16+32+16+32+16, (128)/2, 32+16, 3, false, color(0))) {
    theOdds.importNet("c3po.txt");
  }
  fill(#64B6AC);
  rect(3*(128)/2, 128+32+16+32+16+32+16+32+16, (128)/2, 32+16);
  if (hitbox(3*(128)/2, 128+32+16+32+16+32+16+32+16, (128)/2, 32+16, 3, false, color(0))) {
    AI1.importNet("AI1.txt");
    AI2.importNet("AI2.txt");
  }
  
  textSize(18);
  fill(#E3E4DB);
  text("import", (128)/4 + 2*(128)/2, 128+32+16+32+16+32+16+32+16 + 0.25*(32+16));
  text("import", (128)/4 + 3*(128)/2, 128+32+16+32+16+32+16+32+16 + 0.25*(32+16));
  textSize(22);
  text("C3PO", (128)/4 + 2*(128)/2, 128+32+16+32+16+32+16+32+16 + 0.65*(32+16));
  text("xoxo", (128)/4 + 3*(128)/2, 128+32+16+32+16+32+16+32+16 + 0.65*(32+16));
  
  mousePressedB = mousePressed;
}

void export(int winner) {
  String str = str(winner)+"|";
  for (int j = 0; j<turn; j++) {
    for (int i = 0; i<16; i++) str = str+leboard[i][j];
    str = str+",";
  }
  games.println(str);
  games.flush();
}

void drawBoard(float x, float y, float wid, float hei) {
  for (int i = 0; i<16; i++) {
    if (leboard[i][turn] == 0) fill(255, 255, 255);
    if (leboard[i][turn] == 1) fill(ai1);
    if (leboard[i][turn] == 2) fill(ai2);
    rect(x+ (i % 4)*(wid/4), y+ floor(i/4)*(hei/4), (wid/4), (hei/4) );
  }
}

float getOdds() {
  double[] board = new double[49];
  for (int j = 0; j<16; j++) {
      double z = (double) float(leboard[j][turn]);
      if (z==0) {
        board[j] = 1;
        board[j+16] = 0;
        board[j+32] = 0;
      }
      if (z==1) {
        board[j] = 0;
        board[j+16] = 1;
        board[j+32] = 0;
      }
      if (z==2) {
        board[j] = 0;
        board[j+16] = 0;
        board[j+32] = 1;
      }
  }
  board[48] = turn;
  return (float) theOdds.think(board)[0];
}

void mousePressed() {
  if (mouseButton == LEFT) {
  int x = floor((mouseX)/32);
  int y = floor((mouseY)/32);
  if (x >= 0 && x<4 && y >= 0 && y<4) {
  if (leboard[x+y*4][turn] == 0) {
    for (int i = 0; i<16; i++) leboard[i][turn+1] = leboard[i][turn];
    leboard[x+y*4][turn+1] = (turn % 2) + 1;
    turn++;
    
    if (uvai) {
    double[] board = new double[49];
    for (int j = 0; j<16; j++) {
        double z = (double) float(leboard[j][turn]);
        if (z==0) {
          board[j] = 1;
          board[j+16] = 0;
          board[j+32] = 0;
        }
        if (z==1) {
          board[j] = 0;
          board[j+16] = 1;
          board[j+32] = 0;
        }
        if (z==2) {
          board[j] = 0;
          board[j+16] = 0;
          board[j+32] = 1;
        }
    }
    board[48] = turn;
    double[] ans = new double[16];
    if ((turn % 2)==1) ans = AI1.think(board);
    if ((turn % 2)==0) ans = AI2.think(board);
    float mix = 0;
    int index = 0;
    for (int i = 0; i<16; i++) {
      if (mix < ans[i] && leboard[i][turn] == 0) {
        mix = (float) ans[i];
        index = i;
      }
    }
    for (int i = 0; i<16; i++) leboard[i][turn+1] = leboard[i][turn];
    leboard[index][turn+1] = 2;
    turn++;
  }
    
  }
  }
  if ((checkWin() > 0) || (turn>=16)) {
    for (int i = 0; i<16; i++) for (int j = 0; j<17; j++) leboard[i][j] = 0;
    turn = 0;
  }
  
  } else {
    turnBack = floor(16*mouseX/ width);
    println(turnBack);
  }
  
  
}


int checkWin() {
  int[][][] board = new int[4][4][3]; //x, y, white, oragne, blue
  for (int i = 0; i<16; i++) {
    if (leboard[i][turn] == 0) {board[i % 4][floor(i/4)][0] = 1;} else {board[i % 4][floor(i/4)][0] = 0;}
    if (leboard[i][turn] == 1) {board[i % 4][floor(i/4)][1] = 1;} else {board[i % 4][floor(i/4)][1] = 0;}
    if (leboard[i][turn] == 2) {board[i % 4][floor(i/4)][2] = 1;} else {board[i % 4][floor(i/4)][2] = 0;}
  }
  int winner = 0;
  for (int winTurn = 1; winTurn<3; winTurn++) {
    if ((board[0][0][winTurn]+board[1][1][winTurn]+board[2][2][winTurn]+board[3][3][winTurn])==4) winner = winTurn;
    if ((board[0][3][winTurn]+board[1][2][winTurn]+board[2][1][winTurn]+board[3][0][winTurn])==4) winner = winTurn;
    
    for (int i = 0; i<4; i++) {
    if ((board[i][0][winTurn]+board[i][1][winTurn]+board[i][2][winTurn]+board[i][3][winTurn])==4) winner = winTurn;
    if ((board[0][i][winTurn]+board[1][i][winTurn]+board[2][i][winTurn]+board[3][i][winTurn])==4) winner = winTurn;
    }
    
    for (int i = 0; i<3; i++) {
    if ((board[i][0][winTurn]+board[i][1][winTurn]+board[i+1][2][winTurn]+board[i+1][3][winTurn])==4) winner = winTurn;
    if ((board[0][i][winTurn]+board[1][i][winTurn]+board[2][i+1][winTurn]+board[3][i+1][winTurn])==4) winner = winTurn;
    if ((board[i][3][winTurn]+board[i][2][winTurn]+board[i+1][1][winTurn]+board[i+1][0][winTurn])==4) winner = winTurn;
    if ((board[3][i][winTurn]+board[2][i][winTurn]+board[1][i+1][winTurn]+board[0][i+1][winTurn])==4) winner = winTurn;
    }
    
    for (int i = 0; i<2; i++) {
    if ((board[i][0][winTurn]+board[i+1][1][winTurn]+board[i+1][2][winTurn]+board[i+2][3][winTurn])==4) winner = winTurn;
    if ((board[0][i][winTurn]+board[1][i+1][winTurn]+board[2][i+1][winTurn]+board[3][i+2][winTurn])==4) winner = winTurn;
    
    if ((board[i][3][winTurn]+board[i+1][2][winTurn]+board[i+1][1][winTurn]+board[i+2][0][winTurn])==4) winner = winTurn;
    if ((board[3][i][winTurn]+board[2][i+1][winTurn]+board[1][i+1][winTurn]+board[0][i+2][winTurn])==4) winner = winTurn;
    }
  }
  return winner; //0 = none, 1 = orange, 2 = blue
}

int sign(float x) {
if (x>0) {return 1;} else {return -1;}
}

void aiPlayAndLearn(float LR) {
  if (turn < 16 && (checkWin() == 0)) {
    correctAItotes++;
    double[] board = new double[49];
    for (int j = 0; j<16; j++) {
        double z = (double) float(leboard[j][turn]);
        if (z==0) {
          board[j] = 1;
          board[j+16] = 0;
          board[j+32] = 0;
        }
        if (z==1) {
          board[j] = 0;
          board[j+16] = int((turn % 2 == 1));
          board[j+32] = int(!(turn % 2 == 1));
        }
        if (z==2) {
          board[j] = 0;
          board[j+16] = int(!(turn % 2 == 1));
          board[j+32] = int((turn % 2 == 1));
        }
    }
    board[48] = turn;
    double[] ans = new double[16];
    turn++;
    for (int i = 0; i<16; i++) {
      for (int j = 0; j<16; j++) leboard[j][turn] = leboard[j][turn-1];
      if (leboard[i][turn] == 0) {
        leboard[i][turn] = (turn % 2 + 1);
        ans[i] = abs((1 - (turn % 2)) - getOdds());
      } else ans[i] = 0.5;
    }
    
    turn--;
    if ((turn % 2)==1) AI1.learn(board, ans, LR);
    if ((turn % 2)==0) AI2.learn(board, ans, LR);
    
    ans = new double[16];
    
    for (int i = 0; i<16; i++) {
      if ((turn % 2)==1) ans[i] = AI1.think(board)[i];
      if ((turn % 2)==0) ans[i] = AI2.think(board)[i];
    }
    
    float max = 0;
    int maxIndex = 0;
    for (int i = 0; i<16; i++) {
      if (max < ans[i] && leboard[i][turn] == 0) {
        max = (float) ans[i];
        maxIndex = i;
      }
    }
    
    for (int i = 0; i<16; i++) leboard[i][turn+1] = leboard[i][turn];
    
    
  } else {
    if (learnFromAi) export(checkWin());
    turn = 0;
    for (int i = 0; i<16; i++) leboard[i][0] = 0;
  }
}

void trainTheOdds(float LR) {
  correct = 0;
  for (int i = 0; i<2000; i++) {
    String[] game = split(lines[floor(random(lines.length))], '|');
    double[] winner = new double[2];
    winner[0] = (double) float(int(game[0].equals("1")));
    winner[1] = (double) float(int(game[0].equals("2")));
    //println(winner[0]);
    String[] turns = split(game[1], ',');
    int turny = floor(max(random(turns.length-1), turns.length-(turnBack+2)));
    String[] boardStr = new String[16];
    //println(turns[turny]);
    for (int j = 0; j < 16; j++) {
      //println(j);
      boardStr[j] = str(turns[turny].charAt(j));
    }
    double[] board = new double[49];
    for (int j = 0; j<16; j++) {
      double x = float(int(boardStr[j]));
      if (x==0) {
        board[j] = 1;
        board[j+16] = 0;
        board[j+32] = 0;
      }
      if (x==1) {
        board[j] = 0;
        board[j+16] = 1;
        board[j+32] = 0;
      }
      if (x==2) {
        board[j] = 0;
        board[j+16] = 0;
        board[j+32] = 1;
      }
    }
    board[48] = turny;
    theOdds.learn(board, winner, LR);
    //printArray(theOdds.think(board));
    float x = (float) theOdds.think(board)[0];
    float y = 0.5;//(float) theOdds.think(board)[1];
    if ((round((float) winner[0]) > 0)) if (x > y) {correct++;}
    if ((round((float) winner[1]) > 0)) if (x < y) {correct++;}
  }
  
}

boolean hitbox(float x, float y, float Width, float Height, int CT, boolean box, color colour) /*0 = doest need to be clicked, 1 = pressed, 2 = doesnt matter, 3 = released */ {
  if ( (CT == 0) || ((CT == 1) && (!mousePressedB) && (mousePressed)) || ((CT == 2) && (mousePressed)) || ((CT == 3) && (mousePressedB) && (!mousePressed))) {
    if ((mouseX > x) && (mouseY > y) && (mouseX < x+Width) && (mouseY < y+Height)) {
      if (box) {
        fill(colour);
        rect(x, y, Width, Height);
      }
      return true;
    } else return false;
  } else return false;
}
