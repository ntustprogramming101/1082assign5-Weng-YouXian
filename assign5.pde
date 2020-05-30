final int GAME_START = 0, GAME_RUN = 1, GAME_OVER = 2;
int gameState = 0;

final int GRASS_HEIGHT = 15;
final int START_BUTTON_W = 144;
final int START_BUTTON_H = 60;
final int START_BUTTON_X = 248;
final int START_BUTTON_Y = 360;

PImage title, gameover, startNormal, startHovered, restartNormal, restartHovered;
PImage bg,life,stone1,stone2;
PImage [] imgsoil;int [] soilY ;int soilX;
final int SOIL_SIZE=80;
//groundhog declare
PImage groundhogDownImg,groundhogIdleImg,groundhogLeftImg,groundhogRightImg;
float  playerX,playerY;int groundhogW=80;
float groundhogLastX, groundhogLastY;
int groundhogMoveTime = 250;//move to next grid need 0.25s
int actionFrame; //groundhog's moving frame 
float lastTime; //time when the groundhog finished moving

int stroll,strollLast;

boolean downState = false;
boolean leftState = false;
boolean rightState = false;
//life declare
int lifeX=10,lifeY=10,lifeW=51,lifeSpace=20;

// For debug function; DO NOT edit or remove this!
int playerHealthMax = 2;
boolean demoMode = false;

PImage cabbage,soilEmpty;
PImage soldier;
PImage soil0, soil1, soil2, soil3, soil4, soil5;
PImage[][] soils, stones;

final int SOIL_COL_COUNT = 8;
final int SOIL_ROW_COUNT = 24;

int[][] soilHealth;
int [] xEmpty1 = new int [SOIL_ROW_COUNT];
int [] xEmpty2 = new int [SOIL_ROW_COUNT];


float[] cabbageX=new float [6];
float[] cabbageY=new float [6];
float[] soldierX=new float [6];
float[] soldierY=new float [6];
float[] soldierSpeed = new float [6];

int playerCol, playerRow;
final float PLAYER_INIT_X = 4 * SOIL_SIZE;
final float PLAYER_INIT_Y = - SOIL_SIZE;

final int PLAYER_MAX_HEALTH = 5;
int playerMoveDirection = 0;
int playerMoveTimer = 0;
int playerMoveDuration = 15;

void setup() {
  stone1=loadImage("img1/stone1.png");
  stone2=loadImage("img1/stone2.png");
  // soil setup
  imgsoil = new PImage[6];
  soilY = new int [4];
  for (int i=0; i<6; i++){
    imgsoil[i] = loadImage("img1/soil"+i+".png");
  }
  playerHealthMax=5;
  
  //groundhog
  playerX=SOIL_SIZE*4;
  playerY=SOIL_SIZE; 
  frameRate(60);
  lastTime = millis(); // save lastest time call the millis();
  stroll=0;
  
  size(640, 480, P2D);
  bg = loadImage("img/bg.jpg");
  title = loadImage("img/title.jpg");
  gameover = loadImage("img/gameover.jpg");
  startNormal = loadImage("img/startNormal.png");
  startHovered = loadImage("img/startHovered.png");
  restartNormal = loadImage("img/restartNormal.png");
  restartHovered = loadImage("img/restartHovered.png");
  groundhogIdleImg = loadImage("img/groundhogIdle.png");
  groundhogLeftImg = loadImage("img/groundhogLeft.png");
  groundhogRightImg = loadImage("img/groundhogRight.png");
  groundhogDownImg = loadImage("img/groundhogDown.png");
  life = loadImage("img/life.png");
  soldier = loadImage("img/soldier.png");
  cabbage = loadImage("img/cabbage.png");

  soilEmpty = loadImage("img/soils/soilEmpty.png");

  // Load soil images used in assign3 if you don't plan to finish requirement #6
  soil0 = loadImage("img/soil0.png");
  soil1 = loadImage("img/soil1.png");
  soil2 = loadImage("img/soil2.png");
  soil3 = loadImage("img/soil3.png");
  soil4 = loadImage("img/soil4.png");
  soil5 = loadImage("img/soil5.png");

  //Load PImage[][] soils
  soils = new PImage[6][5];
  for(int i = 0; i < soils.length; i++){
    for(int j = 0; j < soils[i].length; j++){
      soils[i][j] = loadImage("img/soils/soil" + i + "/soil" + i + "_" + j + ".png");
    }
  }

  // Load PImage[][] stones
  stones = new PImage[2][5];
  for(int i = 0; i < stones.length; i++){
    for(int j = 0; j < stones[i].length; j++){
      stones[i][j] = loadImage("img/stones/stone" + i + "/stone" + i + "_" + j + ".png");
    }
  }

  // Initialize player
  playerX = PLAYER_INIT_X;
  playerY = PLAYER_INIT_Y;
  playerCol = (int) (playerX / SOIL_SIZE);
  playerRow = (int) (playerY / SOIL_SIZE);
  playerMoveTimer = 0;
  playerHealthMax = 2;

  // Initialize soilHealth
  soilHealth = new int[SOIL_COL_COUNT][SOIL_ROW_COUNT];
  for(int i = 0; i < soilHealth.length; i++){
    for (int j = 0; j < soilHealth[i].length; j++) {
       // 0: no soil, 15: soil only, 30: 1 stone, 45: 2 stones
      soilHealth[i][j] = 15;
    }
  }
  // Initialize empty
  for (int i = 0; i<xEmpty1.length; i++){
    xEmpty1[i]=floor(random(0,8));
    xEmpty2[i]=floor(random(0,8));
  }
  // Initialize soidiers and their position
  for (int i =0;i<soldierX.length;i++){
      soldierX[i]=floor(random(0,8));
  }
  for (int j =0;j<soldierY.length;j++){
    soldierY[j]=floor(random(0,4));
  }
  for (int k=0;k<soldierSpeed.length;k++){
    soldierSpeed[k]=0;
  }
  // Initialize cabbages and their position
  for (int i =0;i<cabbageX.length;i++){
      cabbageX[i]=floor(random(0,8));
  }
  for (int j =0;j<cabbageY.length;j++){
    cabbageY[j]=floor(random(0,4));
  }
}


void draw() {
    
	switch (gameState) {

		case GAME_START: // Start Screen
		image(title, 0, 0);

		if(START_BUTTON_X + START_BUTTON_W > mouseX
	    && START_BUTTON_X < mouseX
	    && START_BUTTON_Y + START_BUTTON_H > mouseY
	    && START_BUTTON_Y < mouseY) {

			image(startHovered, START_BUTTON_X, START_BUTTON_Y);
			if(mousePressed){
				gameState = GAME_RUN;
				mousePressed = false;
			}

		}else{

			image(startNormal, START_BUTTON_X, START_BUTTON_Y);

		}
		break;
		case GAME_RUN: // In-Game

		// Background
		image(bg, 0, 0);

		// Sun
	    stroke(255,255,0);
	    strokeWeight(5);
	    fill(253,184,19);
	    ellipse(590,50,120,120);

		// Grass
		fill(124, 204, 25);
		noStroke();
		rect(0, 160 - GRASS_HEIGHT+stroll, width, GRASS_HEIGHT);
    // Soil&stones
    for(int i = 0; i < soilHealth.length; i++){  //soilHealth.length=8
      for (int j = 0; j < soilHealth[i].length; j++) {  //soilHealth[i].length=24
        // Change this part to show soil and stone images based on soilHealth value
        // NOTE: To avoid errors on webpage, you can either use floor(j / 4) or (int)(j / 4) to make sure it's an integer.
        int areaIndex = floor(j / 4);
        image(soils[areaIndex][4], i * SOIL_SIZE, (j+2) * SOIL_SIZE+stroll);
        // put on stones
        //layer 1-8
        if(i==j){
          soilHealth[i][j] = 30;
          //int areaIndex = floor(j / 4);
          image(stones[0][4],i * SOIL_SIZE, (j+2) * SOIL_SIZE+stroll);
        }
        //layer 9-16
        if (i%4==1||i%4==2){
          if (j%4==0||j%4==3){
            if (j>7&&j<16){
              soilHealth[i][j] = 30;
              image(stones[0][4],i * SOIL_SIZE, (j+2) * SOIL_SIZE+stroll);
            }
          }
        }
        if (i%4==3||i%4==0){
          if (j%4==1||j%4==2){
            if (j>7&&j<16){
              soilHealth[i][j] = 30;
              image(stones[0][4],i * SOIL_SIZE, (j+2) * SOIL_SIZE+stroll);
            }
          }
        }
        //layer 17-24
        if (j>15&&j<24){
          if(i%3==0){
            if(j%3!=0){
              image(stones[0][4],i * SOIL_SIZE, (j+2) * SOIL_SIZE+stroll);
              soilHealth[i][j] = 30;
              if(j%3==2){
                image(stones[1][4],i * SOIL_SIZE, (j+2) * SOIL_SIZE+stroll);
                soilHealth[i][j] = 45;
              }
            }
          }
          if(i%3==1){
            if(j%3!=2){
              image(stones[0][4],i * SOIL_SIZE, (j+2) * SOIL_SIZE+stroll);
              soilHealth[i][j] = 30;
              if(j%3==1){
                image(stones[1][4],i * SOIL_SIZE, (j+2) * SOIL_SIZE+stroll);
                soilHealth[i][j] = 45;
              }
            }
          }
          if(i%3==2){
            if(j%3!=1){
              image(stones[0][4],i * SOIL_SIZE, (j+2) * SOIL_SIZE+stroll);
              soilHealth[i][j] = 30;
              if(j%3==0){
                image(stones[1][4],i * SOIL_SIZE, (j+2) * SOIL_SIZE+stroll);
                soilHealth[i][j] = 45;
              }
            }
          } 
        }
      }
    }
    for(int i = 0; i < SOIL_ROW_COUNT; i++){ 
      for (int j = 0; j < SOIL_ROW_COUNT; j++) {
        //use array &random make soils empty
        if(i==j&&j!=0){
        image(soilEmpty, xEmpty1[i] * SOIL_SIZE, (j+2) * SOIL_SIZE+stroll);
        image(soilEmpty, xEmpty2[i] * SOIL_SIZE, (j+2) * SOIL_SIZE+stroll);
        soilHealth[xEmpty1[i]][j] = 0;
        soilHealth[xEmpty2[i]][j] = 0;
        } 
      }
    }
    // Cabbages
    // > Remember to check if playerHealth is smaller than PLAYER_MAX_HEALTH!
    for (int i =0;i<cabbageX.length;i++){
      for (int j =0;j<cabbageY.length;j++){
        if(i==j){
          image(cabbage,cabbageX[i] * SOIL_SIZE, (j*4+cabbageY[j]+2) * SOIL_SIZE+stroll);
          if(cabbageX[i] * SOIL_SIZE<playerX+groundhogW&&
          cabbageX[i] * SOIL_SIZE+SOIL_SIZE>playerX&&
          (j*4+cabbageY[j]+2) * SOIL_SIZE+stroll<playerY+groundhogW&&
          (j*4+cabbageY[j]+2) * SOIL_SIZE+stroll+SOIL_SIZE>playerY&&playerHealthMax<5){
            cabbageX[i]=-1;
            cabbageY[j]=-1;
            playerHealthMax+=1;
          }
        }
      }
    }    
		// Player
    //draw the groundhogDown image between 1-14 frames
      if (downState) {
        if (stroll>-((SOIL_ROW_COUNT-5)*SOIL_SIZE)){
           actionFrame++; //in 1s actionFrame=60
          if (actionFrame > 0 && actionFrame <15) {
            stroll -= SOIL_SIZE / 15.0;
            image(groundhogDownImg,playerX,playerY);
          } else {
            stroll = strollLast- SOIL_SIZE;
            downState = false;
          }
        }else{
          actionFrame++; //in 1s actionFrame=60
          if (actionFrame > 0 && actionFrame <15) {
            playerY += SOIL_SIZE / 15.0;
            image(groundhogDownImg,playerX,playerY);
          } else {
            playerY = groundhogLastY + SOIL_SIZE;
            downState = false;
          }
        }
      }
      //drop down if soilempty
       for(int i = 0; i < soilHealth.length; i++){ 
         for (int j = 0; j < soilHealth[i].length; j++){
           if (stroll>-((SOIL_ROW_COUNT-4)*SOIL_SIZE)){ 
            if (playerX/SOIL_SIZE==i&&(-stroll/SOIL_SIZE)==j){
              if (soilHealth[i][j]==0){
                stroll = stroll- SOIL_SIZE;
              }                     
            }
          }else{
            if (playerX/SOIL_SIZE==i&&((-stroll+playerY)/SOIL_SIZE)==j+1){
              if (soilHealth[i][j]==0){
                playerY = playerY + SOIL_SIZE;
              }                     
            } 
          }
        }
      }
      //draw the groundhogLeft image between 1-14 frames
      if (leftState) {
        actionFrame++;
        if (actionFrame > 0 && actionFrame <15) {
          playerX -= SOIL_SIZE / 15.0;
         image(groundhogLeftImg,playerX,playerY);
        } else {
          playerX= groundhogLastX - SOIL_SIZE;
          leftState = false;
        }
      }
      //draw the groundhogRight image between 1-14 frames
      if (rightState) {
        actionFrame++;
        if (actionFrame > 0 && actionFrame < 15) {
          playerX += SOIL_SIZE / 15.0;
          image(groundhogRightImg,playerX,playerY);
        } else {
          playerX = groundhogLastX + SOIL_SIZE;
          rightState = false;
        }
      }
      if(!downState&&!leftState&&!rightState){
        image(groundhogIdleImg,playerX,playerY);
      }
      //boundary detection
      if (playerX>=width-groundhogW){
        playerX=width-groundhogW;
      }
      if (playerX<=0){
        playerX=0;
      }
      if (playerY>height-groundhogW){
        playerY=height-groundhogW;
      }
      if (playerY<SOIL_SIZE){
        playerY=SOIL_SIZE;
      }
      // Demo mode: Show the value of soilHealth on each soil
      // (DO NOT CHANGE THE CODE HERE!)
  
      if(demoMode){  
        fill(255);
        textSize(26);
        textAlign(LEFT, TOP);
  
        for(int i = 0; i < soilHealth.length; i++){
          for(int j = 0; j < soilHealth[i].length; j++){
            text(soilHealth[i][j], i * SOIL_SIZE, (j+2) * SOIL_SIZE+stroll);
          }//sorry i change it to fit my code
        }
  
      }

    //soldier moving
    for (int i =0;i<soldierX.length;i++){
      for (int j =0;j<soldierY.length;j++){
        if(i==j){
          for (int k =0; k<soldierSpeed.length;k++){
            if(soldierSpeed[k]<width){
                soldierSpeed[k]++;
                image(soldier,soldierX[i] * SOIL_SIZE+soldierSpeed[k], (j*4+soldierY[j]+2) * SOIL_SIZE+stroll);
            }else{
              soldierSpeed[k]=-soldierX[i] * SOIL_SIZE-SOIL_SIZE;
            }                
                image(soldier,soldierX[i] * SOIL_SIZE+soldierSpeed[k], (j*4+soldierY[j]+2) * SOIL_SIZE+stroll);
                if(soldierX[i] * SOIL_SIZE+soldierSpeed[k]<playerX+groundhogW&&
                soldierX[i] * SOIL_SIZE+SOIL_SIZE+soldierSpeed[k]>playerX&&
                (j*4+soldierY[j]+2) * SOIL_SIZE+stroll<playerY+groundhogW&&
                (j*4+soldierY[j]+2) * SOIL_SIZE+stroll+SOIL_SIZE>playerY){
                  playerHealthMax-=1;
                  rightState = leftState = downState = false;
                  playerX = PLAYER_INIT_X;
                  playerY = PLAYER_INIT_Y;
                  stroll=0;
                  if (playerHealthMax==0){
                    gameState = 2;
                  }
                }

            }
          }
        }
      }

		// Health UI
    //life
    for(int i=0;i<playerHealthMax;i++){
      imageMode(CORNER);
      image(life,lifeX+(lifeW+lifeSpace)*i,lifeY);
    }

		break;

		case GAME_OVER: // Gameover Screen
		image(gameover, 0, 0);
		
		if(START_BUTTON_X + START_BUTTON_W > mouseX
	    && START_BUTTON_X < mouseX
	    && START_BUTTON_Y + START_BUTTON_H > mouseY
	    && START_BUTTON_Y < mouseY) {

			image(restartHovered, START_BUTTON_X, START_BUTTON_Y);
			if(mousePressed){
				gameState = GAME_RUN;
				mousePressed = false;
				// Remember to initialize the game here!

        // Initialize player
        playerX = PLAYER_INIT_X;
        playerY = PLAYER_INIT_Y;
        playerCol = (int) (playerX / SOIL_SIZE);
        playerRow = (int) (playerY / SOIL_SIZE);
        playerMoveTimer = 0;
        playerHealthMax = 2;

        // Initialize soilHealth
        soilHealth = new int[SOIL_COL_COUNT][SOIL_ROW_COUNT];
        for(int i = 0; i < soilHealth.length; i++){
          for (int j = 0; j < soilHealth[i].length; j++) {
             // 0: no soil, 15: soil only, 30: 1 stone, 45: 2 stones
            soilHealth[i][j] = 15;
          }
        }

        // Initialize soidiers and their position

        // Initialize cabbages and their position
        
      }
		}else{

			image(restartNormal, START_BUTTON_X, START_BUTTON_Y);

		}
		break;
		
	}
//    break;
    //// DO NOT REMOVE OR EDIT THE FOLLOWING 3 LINES *old one*
    //if (debugMode) {
    //    popMatrix();
    //}
}

void keyPressed(){
	// Add your moving input code here
  float newTime = millis(); //time when the groundhog started moving
  if (key == CODED){
    switch (keyCode) {
    case DOWN:
      if (newTime - lastTime > groundhogMoveTime) {
        downState = true;
        actionFrame = 0;
        groundhogLastY = playerY;
        strollLast=stroll;
        lastTime = newTime;
      }
      break;
    case LEFT:
      if (newTime - lastTime > groundhogMoveTime) {
        leftState = true;
        actionFrame = 0;
        groundhogLastX = playerX;
        lastTime = newTime;
      }
      break;
    case RIGHT:
      if (newTime - lastTime > groundhogMoveTime) {
        rightState = true;
        actionFrame = 0;
        groundhogLastX = playerX;
        lastTime = newTime;
      }
      break;
  }
  
 }else{
   if (key=='b'){
        // Press B to toggle demo mode
        demoMode = !demoMode;
   }
 }
}

void keyReleased(){
}
