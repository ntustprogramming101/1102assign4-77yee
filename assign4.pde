PImage title, gameover, startNormal, startHovered, restartNormal, restartHovered;
PImage groundhogIdle, groundhogLeft, groundhogRight, groundhogDown;
PImage bg, life, cabbage, stone1, stone2, soilEmpty;
PImage soldier;
PImage soil0, soil1, soil2, soil3, soil4, soil5;
PImage[][] soils, stones;

final int GAME_START = 0, GAME_RUN = 1, GAME_OVER = 2;
int gameState = 0;

final int GRASS_HEIGHT = 15;
final int SOIL_COL_COUNT = 8;
final int SOIL_ROW_COUNT = 24;
final int SOIL_SIZE = 80;

int[][] soilHealth;

final int START_BUTTON_WIDTH = 144;
final int START_BUTTON_HEIGHT = 60;
final int START_BUTTON_X = 248;
final int START_BUTTON_Y = 360;

float[] cabbageX, cabbageY, soldierX, soldierY;
float soldierSpeed = 2f;

float playerX, playerY;
int playerCol, playerRow;
final float PLAYER_INIT_X = 4 * SOIL_SIZE;
final float PLAYER_INIT_Y = - SOIL_SIZE;
boolean leftState = false;
boolean rightState = false;
boolean downState = false;
int playerHealth = 2;
final int PLAYER_MAX_HEALTH = 5;
int playerMoveDirection = 0;
int playerMoveTimer = 0;
int playerMoveDuration = 15;

boolean demoMode = false;


void initPlayer(){
  playerX = PLAYER_INIT_X;
  playerY = PLAYER_INIT_Y;
  playerCol = (int) (playerX / SOIL_SIZE);
  playerRow = (int) (playerY / SOIL_SIZE);
  playerMoveTimer = 0;
}
  
void initSoil(){
  soilHealth = new int[SOIL_COL_COUNT][SOIL_ROW_COUNT];
  for(int i = 0; i < soilHealth.length; i++){
    for (int j = 0; j < soilHealth[i].length; j++) {
       // 0: no soil, 15: soil only, 30: 1 stone, 45: 2 stones
      soilHealth[i][j] = 15;
    }
  }
  for(int i=0;i<8;i++){//layer1 to 8
      soilHealth[i][i]+=15;
  }
  for(int i=0;i<8;i++){//layer9-16
    for(int j=8;j<16;j++){
      if(j==8 || j==11||j==12||j==15){
        if(i==1 || i==2||i==5||i==6){
          soilHealth[i][j]+=15;
        }
      }else{
        if(i==0 || i==3||i==4||i==7){
          soilHealth[i][j]+=15;
        }
      }
    }
  }
  for(int i=0;i<8;i++){//layer17-24
    for(int j=16;j<24;j++){
      if(i+j==17||i+j==18||i+j==20||i+j==21||i+j==23||i+j==24||i+j==26||i+j==27||i+j==29||i+j==30){
        soilHealth[i][j]+=15;
        if(i+j==18||i+j==21||i+j==24||i+j==27||i+j==30){
        soilHealth[i][j]+=15;
        }
      }
    }
  }
  
  //dig out the soil
  for(int j=1;j<24;j++){
    int pos=-1;
    for(int i=0;i<floor(random(1,3));i++){
      int poS=floor(random(0,8));
      while(poS==pos){
        poS=floor(random(0,8));
      }
      soilHealth[poS][j]=0;
      pos=poS;
    }
  }
}

void initSoldier(){
  soldierX = new float[6];
  soldierY = new float[6];
  for(int i=0;i<6;i++){
    soldierX[i]=random(0,8);
    soldierY[i]=4*i+floor(random(0,4));
  }
}

void initCabbage(){
  cabbageX = new float[6];
  cabbageY = new float[6];
  for(int i=0;i<6;i++){
    cabbageX[i]=floor(random(0,8));
    cabbageY[i]=4*i+floor(random(0,4));
  }  
}

  
  
void setup() {
	size(640, 480, P2D);
	bg = loadImage("img/bg.jpg");
	title = loadImage("img/title.jpg");
	gameover = loadImage("img/gameover.jpg");
	startNormal = loadImage("img/startNormal.png");
	startHovered = loadImage("img/startHovered.png");
	restartNormal = loadImage("img/restartNormal.png");
	restartHovered = loadImage("img/restartHovered.png");
	groundhogIdle = loadImage("img/groundhogIdle.png");
	groundhogLeft = loadImage("img/groundhogLeft.png");
	groundhogRight = loadImage("img/groundhogRight.png");
	groundhogDown = loadImage("img/groundhogDown.png");
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

	// Load PImage[][] soils
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
	initPlayer();
	playerHealth = 2;

	// Initialize soilHealth
  initSoil();
  
	// Initialize soidiers and their position
  initSoldier();
  
	// Initialize cabbages and their position
  initCabbage();
  

}

void draw() {

	switch (gameState) {

		case GAME_START: // Start Screen
		image(title, 0, 0);
		if(START_BUTTON_X + START_BUTTON_WIDTH > mouseX
	    && START_BUTTON_X < mouseX
	    && START_BUTTON_Y + START_BUTTON_HEIGHT > mouseY
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

	    // CAREFUL!
	    // Because of how this translate value is calculated, the Y value of the ground level is actually 0
		pushMatrix();
		translate(0, max(SOIL_SIZE * -18, SOIL_SIZE * 1 - playerY));

		// Ground

		fill(124, 204, 25);
		noStroke();
		rect(0, -GRASS_HEIGHT, width, GRASS_HEIGHT);

		// Soil

		for(int i = 0; i < soilHealth.length; i++){
			for (int j = 0; j < soilHealth[i].length; j++) {

				// Change this part to show soil and stone images based on soilHealth value
				// NOTE: To avoid errors on webpage, you can either use floor(j / 4) or (int)(j / 4) to make sure it's an integer.
				//draw soil
        int areaIndex = floor(j / 4);
        int soilStat=0;
        if(soilHealth[i][j]==0){
          image(soilEmpty, i * SOIL_SIZE, j * SOIL_SIZE);
        }else{
          if(soilHealth[i][j]<=3){
            soilStat=0;
          }else if(soilHealth[i][j]<=6){
            soilStat=1;
          }else if(soilHealth[i][j]<=9){
            soilStat=2;
          }else if(soilHealth[i][j]<=12){
            soilStat=3;
          }else if(soilHealth[i][j]<=45){
            soilStat=4;
          }
				  image(soils[areaIndex][soilStat], i * SOIL_SIZE, j * SOIL_SIZE);
				}
        
        //draw stone
        int stoneStat=0;
        if(soilHealth[i][j]>=16){
          if(soilHealth[i][j]<=18){
            stoneStat=0;
          }else if(soilHealth[i][j]<=21){
            stoneStat=1;
          }else if(soilHealth[i][j]<=24){
            stoneStat=2;
          }else if(soilHealth[i][j]<=27){
            stoneStat=3;
          }else if(soilHealth[i][j]<=45){
            stoneStat=4;
          }
          image(stones[0][stoneStat], i * SOIL_SIZE, j * SOIL_SIZE);
        }    
        if(soilHealth[i][j]>=31){
          if(soilHealth[i][j]<=33){
            stoneStat=0;
          }else if(soilHealth[i][j]<=36){
            stoneStat=1;
          }else if(soilHealth[i][j]<=39){
            stoneStat=2;
          }else if(soilHealth[i][j]<=42){
            stoneStat=3;
          }else if(soilHealth[i][j]<=45){
            stoneStat=4;
          }
          image(stones[1][stoneStat], i * SOIL_SIZE, j * SOIL_SIZE);
        }    
			}
		}

		
		// Groundhog
    
		PImage groundhogDisplay = groundhogIdle;

		// If player is not moving, we have to decide what player has to do next
		if(playerMoveTimer == 0){

			// HINT:
			// You can use playerCol and playerRow to get which soil player is currently on
      if(playerRow < SOIL_ROW_COUNT - 1){
        if(soilHealth[playerCol][playerRow+1]==0){
  			// Check if "player is NOT at the bottom AND the soil under the player is empty"
  			// > If so, then force moving down by setting playerMoveDirection and playerMoveTimer (see downState part below for example)
  			  groundhogDisplay = groundhogDown;
          playerMoveDirection = DOWN;
          playerMoveTimer = playerMoveDuration;
        }
  
  
        // > Else then determine player's action based on input state     
			}
      if(leftState){

				groundhogDisplay = groundhogLeft;

				// Check left boundary
				if(playerCol > 0){

					// HINT:
					// Check if "player is NOT above the ground AND there's soil on the left"
					// > If so, dig it and decrease its health
					// > Else then start moving (set playerMoveDirection and playerMoveTimer)
          if(playerRow!=-1 && soilHealth[playerCol-1][playerRow]>0){
            soilHealth[playerCol-1][playerRow]-=1;
          }else{
					  playerMoveDirection = LEFT;
					  playerMoveTimer = playerMoveDuration;
          }

				}

			}else if(rightState){

				groundhogDisplay = groundhogRight;

				// Check right boundary
				if(playerCol < SOIL_COL_COUNT - 1){

					// HINT:
					// Check if "player is NOT above the ground AND there's soil on the right"
					// > If so, dig it and decrease its health
					// > Else then start moving (set playerMoveDirection and playerMoveTimer)
          if(playerRow!=-1 && soilHealth[playerCol+1][playerRow]>0){
            soilHealth[playerCol+1][playerRow]-=1;
          }else{
            playerMoveDirection = RIGHT;
            playerMoveTimer = playerMoveDuration;
          }
          
					

				}

			}else if(downState){

				groundhogDisplay = groundhogDown;

				// Check bottom boundary

				// HINT:
				// We have already checked "player is NOT at the bottom AND the soil under the player is empty",
				// and since we can only get here when the above statement is false,
				// we only have to check again if "player is NOT at the bottom" to make sure there won't be out-of-bound exception
				if(playerRow < SOIL_ROW_COUNT - 1){

					// > If so, dig it and decrease its health
          if(soilHealth[playerCol][playerRow+1]>0){
            soilHealth[playerCol][playerRow+1]-=1;
          }
					// For requirement #3:
					// Note that player never needs to move down as it will always fall automatically,
					// so the following 2 lines can be removed once you finish requirement #3

					


				}
			}

		}
    
    
    
      





		// If player is now moving?
		// (Separated if-else so player can actually move as soon as an action starts)
		// (I don't think you have to change any of these)

		if(playerMoveTimer > 0){

			playerMoveTimer --;
			switch(playerMoveDirection){

				case LEFT:
				groundhogDisplay = groundhogLeft;
				if(playerMoveTimer == 0){
					playerCol--;
					playerX = SOIL_SIZE * playerCol;
				}else{
					playerX = (float(playerMoveTimer) / playerMoveDuration + playerCol - 1) * SOIL_SIZE;
				}
				break;

				case RIGHT:
				groundhogDisplay = groundhogRight;
				if(playerMoveTimer == 0){
					playerCol++;
					playerX = SOIL_SIZE * playerCol;
				}else{
					playerX = (1f - float(playerMoveTimer) / playerMoveDuration + playerCol) * SOIL_SIZE;
				}
				break;

				case DOWN:
				groundhogDisplay = groundhogDown;
				if(playerMoveTimer == 0){
					playerRow++;
					playerY = SOIL_SIZE * playerRow;
				}else{
					playerY = (1f - float(playerMoveTimer) / playerMoveDuration + playerRow) * SOIL_SIZE;
				}
				break;
			}

		}
    
    // Cabbages
    // > Remember to check if playerHealth is smaller than PLAYER_MAX_HEALTH!
    for(int i=0;i<6;i++){
      image(cabbage, cabbageX[i] * SOIL_SIZE, cabbageY[i] * SOIL_SIZE);
      //cabbage collision detect
      if(playerX<cabbageX[i]*SOIL_SIZE+SOIL_SIZE && playerX+SOIL_SIZE>cabbageX[i]*SOIL_SIZE && playerY<cabbageY[i]*SOIL_SIZE+SOIL_SIZE && playerY+SOIL_SIZE>cabbageY[i]*SOIL_SIZE && playerHealth<PLAYER_MAX_HEALTH){
        cabbageX[i]=-100;
        playerHealth++;
      }
    }
    
    //draw groundhog
		image(groundhogDisplay, playerX, playerY);
    
		// Soldiers
		// > Remember to stop player's moving! (reset playerMoveTimer)
		// > Remember to recalculate playerCol/playerRow when you reset playerX/playerY!
		// > Remember to reset the soil under player's original position!
    
    for(int i=0;i<6;i++){
      image(soldier, soldierX[i] * SOIL_SIZE, soldierY[i] * SOIL_SIZE);
      //cabbage collision detect
      if(playerX<soldierX[i]*SOIL_SIZE+SOIL_SIZE && playerX+SOIL_SIZE>soldierX[i]*SOIL_SIZE && playerY<soldierY[i]*SOIL_SIZE+SOIL_SIZE && playerY+SOIL_SIZE>soldierY[i]*SOIL_SIZE){
        playerHealth--;
        soilHealth[4][0]=15;
        initPlayer();
      }
      soldierX[i]+=soldierSpeed/SOIL_SIZE;//Move Soldier
      soldierX[i]=(soldierX[i]+1)%9-1;
    }
    
    
		// Demo mode: Show the value of soilHealth on each soil
		// (DO NOT CHANGE THE CODE HERE!)

		if(demoMode){	

			fill(255);
			textSize(26);
			textAlign(LEFT, TOP);

			for(int i = 0; i < soilHealth.length; i++){
				for(int j = 0; j < soilHealth[i].length; j++){
					text(soilHealth[i][j], i * SOIL_SIZE, j * SOIL_SIZE);
				}
			}

		}

		popMatrix();

		// Health UI
    for(int i=0;i<playerHealth;i++)
    {
      image(life,10+i*70,10);
    }
    
    if(playerHealth==0){
      gameState=GAME_OVER;
    }

		break;

		case GAME_OVER: // Gameover Screen
		image(gameover, 0, 0);
		
		if(START_BUTTON_X + START_BUTTON_WIDTH > mouseX
	    && START_BUTTON_X < mouseX
	    && START_BUTTON_Y + START_BUTTON_HEIGHT > mouseY
	    && START_BUTTON_Y < mouseY) {

			image(restartHovered, START_BUTTON_X, START_BUTTON_Y);
			if(mousePressed){
				gameState = GAME_RUN;
				mousePressed = false;

				// Initialize player
				initPlayer();
				playerHealth = 2;

				// Initialize soilHealth
				initSoil();

				// Initialize soidiers and their position
        initSoldier();
        
        // Initialize cabbages and their position
        initCabbage();
				
				
			}

		}else{

			image(restartNormal, START_BUTTON_X, START_BUTTON_Y);

		}
		break;
		
	}
}

void keyPressed(){
	if(key==CODED){
		switch(keyCode){
			case LEFT:
			leftState = true;
			break;
			case RIGHT:
			rightState = true;
			break;
			case DOWN:
			downState = true;
			break;
		}
	}else{
		if(key=='b'){
			// Press B to toggle demo mode
			demoMode = !demoMode;
		}
	}
}

void keyReleased(){
	if(key==CODED){
		switch(keyCode){
			case LEFT:
			leftState = false;
			break;
			case RIGHT:
			rightState = false;
			break;
			case DOWN:
			downState = false;
			break;
		}
	}
}
