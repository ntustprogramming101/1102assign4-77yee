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

float[] cabbageX= new float[6], cabbageY= new float[6];
float[] soldierX, soldierY;
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

float [] soldierPositionX;
float [] soldierPositionY;
int [] soilEmptyPo=new int [24] ;;
int [] soilEmptyPo2=new int [24] ;;

boolean demoMode = false;

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
  stone1 = loadImage("img/stone1.png");
  stone2 = loadImage("img/stone2.png");
  // 0: no soil, 15: soil only, 30: 1 stone, 45: 2 stones
  
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
  playerX = PLAYER_INIT_X;
  playerY = PLAYER_INIT_Y;
  playerCol = (int) (playerX / SOIL_SIZE);
  playerRow = (int) (playerY / SOIL_SIZE);
  playerMoveTimer = 0;
  playerHealth = 2;

  // Initialize soilHealth
 soilHealth = new int[SOIL_COL_COUNT][SOIL_ROW_COUNT];
  for(int i = 0; i < soilHealth.length; i++){
    for (int j = 0; j < soilHealth[i].length; j++) {
       // 0: no soil, 15: soil only, 30: 1 stone, 45: 2 stones
      soilHealth[i][j] = 15;
    }
  }
  for(int i=0;i<8;i++){//1-8
      soilHealth[i][i]+=15;
  }
  for(int i=0;i<8;i++){//9-16
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

  // Initialize soidiers and their position
  soldierX = new float [6];
  soldierY = new float [6];
  soldierPositionX = new float [6];
  soldierPositionY = new float [6];
  //X
     for(int i=0 ; i<6 ;i++){
     soldierX[i] = floor(random(0,8));
     for(int j=0; j<i; j++){
       do{       
        soldierX[i] = floor(random(0,8));
       }while(soldierX[i]==soldierX[j]);     
     }
     soldierPositionX[i] = soldierX[i]*80;
     }
  //Y
     for(int i=0 ; i<6 ;i++){
     soldierY[i] = floor(random(0+(i*4),4+(4*i)));
     soldierPositionY[i] = soldierY[i]*80;
     }
     
    // Initialize cabbages and their position
    for(int c=0 ; c<6 ;c++){
     cabbageX[c] = (floor(random(0,8))*SOIL_SIZE);
     }
    for(int c=0 ; c<6 ;c++){
     cabbageY[c] = (floor(random(0,4))*SOIL_SIZE)+4*SOIL_SIZE*c;
     }
     
     
       for(int j=1; j<24; j++){
        soilEmptyPo[j]=floor(random(0,8));
        soilEmptyPo2[j]=floor(random(0,8)); 
        soilHealth[soilEmptyPo[j]][j] =0;
        soilHealth[soilEmptyPo2[j]][j] =0;    
      } 
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

    case GAME_RUN: 
    // Background
    image(bg, 0, 0);

    // Sun
      stroke(255,255,0);
      strokeWeight(5);
      fill(253,184,19);
      ellipse(590,50,120,120);

    //Move 
    pushMatrix();
    translate(0, max(SOIL_SIZE * -18, SOIL_SIZE * 1 - playerY));

    // Ground

    fill(124, 204, 25);
    noStroke();
    rect(0, -GRASS_HEIGHT, width, GRASS_HEIGHT);

    // Soil
         for(int i=0; i<8; i++){
           for(int j=0; j<24; j++){
            int  areaIndex = floor(j/ 4);                           
             if(soilHealth[i][j]>0 && soilHealth[i][j]<=15 ){
             image(soils[areaIndex][floor((soilHealth[i][j]-1)/3)], i * SOIL_SIZE, j * SOIL_SIZE);
            }
            else if(soilHealth[i][j]>15 && soilHealth[i][j]<=30 ){
             image(soils[areaIndex][4], i * SOIL_SIZE, j * SOIL_SIZE); 
             image(stones[0][floor((soilHealth[i][j]-16)/3)], i * SOIL_SIZE, j * SOIL_SIZE);
             
            }
            else if(soilHealth[i][j]>30 && soilHealth[i][j]<=45 ){
             image(soils[areaIndex][4], i * SOIL_SIZE, j * SOIL_SIZE); 
             image(stones[1][floor((soilHealth[i][j]-31)/3)], i * SOIL_SIZE, j * SOIL_SIZE);
             image(stones[0][4], i * SOIL_SIZE, j * SOIL_SIZE);
                          
            }
            
           else{
           image(soilEmpty, i * SOIL_SIZE, j * SOIL_SIZE);
           }  
           }
         }
    
    
               //soilHealth.length == 8;
      for (int i = 1; i < 24; i++) {     //soilHealth[i].length == 24;
        image(soilEmpty,soilEmptyPo[i]*80, i*80,80,80);
        image(soilEmpty,soilEmptyPo2[i]*80, i*80,80,80);
        }
    
    // Cabbages
      for(int c=0; c<6; c++){
          image(cabbage,cabbageX[c],cabbageY[c]);
          if(playerHealth<5){
            if(round(playerX)<cabbageX[c] +SOIL_SIZE && round(playerX) + SOIL_SIZE>cabbageX[c] &&
               round(playerY) < cabbageY[c] + SOIL_SIZE && round(playerY)+ SOIL_SIZE > cabbageY[c])
               {  
                 cabbageX[c]=-100;
                 cabbageY[c]=-100;               
                 playerHealth++;
                 
             } 
          }
          
          
      }
    // soildier
          for(int i=0; i<6; i++){
            image(soldier,soldierPositionX[i],soldierPositionY[i]);
            soldierPositionX[i] += soldierSpeed;
              if(soldierPositionX[i]>width){
              soldierPositionX[i]=-80;
              }
          if(round(playerX)<soldierPositionX[i] +80 && round(playerX) + 80>soldierPositionX[i] &&
               round(playerY) < soldierPositionY[i] + 80 && round(playerY)+ 80 > soldierPositionY[i])
               {  
                
                // Initialize player
                playerX = PLAYER_INIT_X;
                playerY = PLAYER_INIT_Y;
                playerCol = (int) (playerX / SOIL_SIZE);
                playerRow = (int) (playerY / SOIL_SIZE);
                playerMoveTimer = 0;
                playerHealth --;
                soilHealth[4][0]=15;
             }
      }
      
    // > Remember to check if playerHealth is smaller than PLAYER_MAX_HEALTH!

    // Groundhog

    PImage groundhogDisplay = groundhogIdle;

    // If player is not moving, we have to decide what player has to do next
    if(playerMoveTimer == 0){

      // HINT:
      // You can use playerCol and playerRow to get which soil player is currently on

      // Check if "player is NOT at the bottom AND the soil under the player is empty"
      // > If so, then force moving down by setting playerMoveDirection and playerMoveTimer (see downState part below for example)
      // > Else then determine player's action based on input state

      if(leftState){

        groundhogDisplay = groundhogLeft;

        // Check left boundary
        if(playerCol > 0){

          // HINT:
          // Check if "player is NOT above the ground AND there's soil on the left"
          // > If so, dig it and decrease its health
          // > Else then start moving (set playerMoveDirection and playerMoveTimer)

          playerMoveDirection = LEFT;
         if(playerY>-80){
            int  nowPoX = int(playerX)/80 ;
            int  nowPoY = int(playerY)/80 ;          
            if(soilHealth[nowPoX-1][nowPoY]>0){
              soilHealth[nowPoX-1][nowPoY]--;
              }
            if(soilHealth[nowPoX-1][nowPoY]<=0){
            playerMoveTimer = playerMoveDuration;
            }
            
          } else{
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

          playerMoveDirection = RIGHT;
          if(playerY>-80){
            int  nowPoX = int(playerX)/80 ;
            int  nowPoY = int(playerY)/80 ;
              if(soilHealth[nowPoX+1][nowPoY]>0){
                soilHealth[nowPoX+1][nowPoY]--;
              }
              if(soilHealth[nowPoX+1][nowPoY]<=0){
              playerMoveTimer = playerMoveDuration;
              }
              
              } else{
            playerMoveTimer = playerMoveDuration;
          }
        }

      }else if(downState){

        groundhogDisplay = groundhogDown;

        if(playerRow < SOIL_ROW_COUNT - 1){

          playerMoveDirection = DOWN;
          int  nowPoX = int(playerX)/80 ;
          int  nowPoY = int(playerY)/80 ;         
          if(soilHealth[nowPoX][nowPoY+1]>0){
            soilHealth[nowPoX][nowPoY+1]--;
          }
          if(soilHealth[nowPoX][nowPoY+1]<=0){
          playerMoveTimer = playerMoveDuration;
          }
          

        }
      }
      if(playerRow < SOIL_ROW_COUNT - 1){
          int  nowPoX = int(playerX)/80 ;
          int  nowPoY = int(playerY)/80 ; 
          if(soilHealth[nowPoX][nowPoY+1]==0){
            playerMoveDirection = DOWN;
          playerMoveTimer = playerMoveDuration;
         }
      }

    }

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

    image(groundhogDisplay, playerX, playerY);

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
    if(playerHealth>=5){
       playerHealth = 5;
    }
    for(int i = 0; i<playerHealth; i++){
     
      image(life,10+i*70,10); 
    }
    if(playerHealth == 0){
      gameState = GAME_OVER;
      }
      
    break;


    case GAME_OVER: // Gameover Screen
    image(gameover, 0, 0);
    //println("WTF");
    if(START_BUTTON_X + START_BUTTON_WIDTH > mouseX
      && START_BUTTON_X < mouseX
      && START_BUTTON_Y + START_BUTTON_HEIGHT > mouseY
      && START_BUTTON_Y < mouseY) {

      image(restartHovered, START_BUTTON_X, START_BUTTON_Y);
      if(mousePressed){
        gameState = GAME_RUN;
        mousePressed = false;
        // Initialize player
        playerX = PLAYER_INIT_X;
        playerY = PLAYER_INIT_Y;
        playerCol = (int) (playerX / SOIL_SIZE);
        playerRow = (int) (playerY / SOIL_SIZE);
        playerMoveTimer = 0;
        playerHealth = 2;

        // Initialize soilHealth
        soilHealth = new int[SOIL_COL_COUNT][SOIL_ROW_COUNT];
        for(int i = 0; i < soilHealth.length; i++){
          for (int j = 0; j < soilHealth[i].length; j++) {
             // 0: no soil, 15: soil only, 30: 1 stone, 45: 2 stones
            soilHealth[i][j] = 15;
          }
        }

        // Initialize soidiers and their position
           for(int i=0 ; i<6 ;i++){
           soldierX[i] = floor(random(0,8));
           soldierPositionX[i] = soldierX[i]*80;
           }
           for(int i=0 ; i<6 ;i++){
           soldierY[i] = floor(random(0+(i*4),4+(4*i)));
           soldierPositionY[i] = soldierY[i]*80;
           }
          // Initialize cabbages and their position
          for(int i=0 ; i<6 ;i++){
           cabbageX[i] = floor(random(0,8));
           }
          for(int i=0 ; i<6 ;i++){
           cabbageY[i] = floor(random(0+(i*4),4+(4*i)));
           }
        // Initialize soilHealth     
      //soilHealth = new int[SOIL_COL_COUNT][SOIL_ROW_COUNT];
      for(int i = 0; i < soilHealth.length; i++){
      for (int j = 0; j < soilHealth[i].length; j++) {
       // 0: no soil, 15: soil only, 30: 1 stone, 45: 2 stones
         soilHealth[i][j] = 15;    
          if(j<8 && j>=0){       //1-8
              if(i==j){
                soilHealth[i][j] += 15;              
              }
          }                        //1-8.
          
          else if(j>=8 && j<16){  //9-16.
         
          if(j%4==0){
            if(i%4 == 1){
                   soilHealth[i][j] += 15;
                 }
                  if(i%4 == 2){
                   soilHealth[i][j] += 15;
                 }
          }
          else if(j%4 == 1){
                 if(i%4 == 0){
                   soilHealth[i][j] += 15;
                 }
               if(i%4 == 3){
                soilHealth[i][j] += 15;
               }             
           }
             else if(j%4 == 2){
             if(i%4 == 0){
              soilHealth[i][j] += 15;
             }
             if(i%4 == 3){
              soilHealth[i][j] += 15;
             }             
           }
           else if(j%4 == 3){
             if(i%4 == 1){
               soilHealth[i][j] += 15;
             }
                if(i%4 == 2){
                 soilHealth[i][j] += 15;
               }             
           } 
          
         }
           
            else if(j>=16 && j<24){
            if(i+j==17||i+j==18||i+j==20||i+j==21     //17-24
                    ||i+j==23||i+j==24||i+j==26||i+j==27
                    ||i+j==29||i+j==30){
                    soilHealth[i][j] += 15;
                    if(i+j==18||i+j==21||i+j==24||i+j==27||i+j==30){
                    soilHealth[i][j] += 15;
                    }
                }            
            }        
         }     
     }
     for(int j=1; j<24; j++){
        soilEmptyPo[j]=floor(random(0,8));
        soilEmptyPo2[j]=floor(random(0,8)); 
        //print(soilEmptyPo[j]);
        //print(soilEmptyPo2[j]);
        soilHealth[soilEmptyPo[j]][j] =0;
        soilHealth[soilEmptyPo2[j]][j] =0;
  }
          }  
      
  
      
}
    else{

      image(restartNormal, START_BUTTON_X, START_BUTTON_Y);

    }
        // setup();   
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
