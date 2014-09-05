// Author: Alice Huang

// File details
// indents = 2 spaces


// Define initial variables *****

// Position variables
float playerX, playerY;
float blockX, blockY; // block coordinates for bottomBlock

// Physics variables
float gravity;
float playerVerticalVelocity;
float friendVerticalVelocity;

// Boolean variables
boolean playerAlive = false;

// Game structures
PImage gameBackground;
PImage player;
PVector bottomBlock;
PVector topBlock;
int blockWidth = 50;
int squeezeSpace = 100;

// Game details
PFont font = createFont("Arial", 30); // TO DO: change to prettier font

// Double player definitions
int numPlayers = 0;
PImage friend;
float friendX, friendY;
boolean friendAlive = false;

// ******************************


// TO DO: add scoring, fix the replay, high score shit, shoot lazer beans, grow bigger and smaller, 
// second player, multiple columns on the screen


// Game setup *****
void setup() {
  size(800, 600);
  gameBackground = loadImage("candy_kingdom_cropped.jpg");
 
  playerX = width/2;
  playerY = height/2;
  gravity = 0.3;
  playerVerticalVelocity = 0;
  friendVerticalVelocity = 0;
  
  blockX = width;
  blockY = random(squeezeSpace, height);
  
  bottomBlock = new PVector(blockX, blockY);
  topBlock    = new PVector(blockX, 0); 
  
  
    playerY = height/2 - 100;
    
    friendX = width/2;
    friendY = height/2 + 100;
  
}
// ****************


// Draw functions *****
void draw() {
  background(gameBackground); // TO DO: change the color of the background to a pretty picture
  noStroke();
  fill(200, 50, 50, 200);
  
  // SCREEN 1: Start screen
  if (numPlayers == 0) {
    textFont(font);
    textAlign(CENTER);
    text("How many players do you have in your game?", width/2, height/2);
    player = loadImage("lsp_transparent.png");
    player.resize(80, 80);
    
    friend = loadImage("lsp_transparent.png");
    friend.resize(80, 80);
   
  }
  
  // SCREEN 2a: Single player mode
  else if (playerAlive && numPlayers == 1) {
    image(player, playerX-40, playerY-40);
    //ellipse(playerX, playerY, 20, 20);
    rect(bottomBlock.x, bottomBlock.y, blockWidth, height-bottomBlock.y);
    rect(topBlock.x, topBlock.y, blockWidth, bottomBlock.y-squeezeSpace);
    playerVerticalVelocity += gravity;
    playerY += playerVerticalVelocity;
    updateSinglePlayerMode();
  }
  
  // SCREEN 2b: Double player mode
  else if (playerAlive && friendAlive) {
    image(player, playerX-40, playerY-40);
    //ellipse(playerX, playerY, 20, 20);
    playerVerticalVelocity += gravity;
    playerY += playerVerticalVelocity;
    
    image(friend, friendX-40, friendY-40);
    friendVerticalVelocity += gravity;
    friendY += friendVerticalVelocity;
    
    rect(bottomBlock.x, bottomBlock.y, blockWidth, height-bottomBlock.y);
    rect(topBlock.x, topBlock.y, blockWidth, bottomBlock.y-squeezeSpace);
    
    updateDoublePlayerMode();
    
    
  }
  
  // SCREEN 3: Finish screen
  else {
    textFont(font);
    textAlign(CENTER);
    text("GAME OVER", width/2, height/2);
    text("Do you want to play again? (y/n)", width/2, height/2+50);
  }
  
  textFont(font);
  textAlign(RIGHT);
  String playerModeString = String.format("Player mode: %d", numPlayers);
  text(playerModeString, width - 30, 30);
}
// ********************


// Update functions *****
void updateSinglePlayerMode() {
  if (playerY > height || playerY+30 < 0) {
    playerAlive = false;
  }
  
  bottomBlock.x -= 5; // make faster depending on level
  topBlock.x    -= 5; // HARD CODE A VARIABLE LATER
  
  if (bottomBlock.x < 0) {
    bottomBlock.x = width;
    bottomBlock.y = random(squeezeSpace, height);
    topBlock.x = width;
    topBlock.y = 0;
  }
  
  checkPlayerCollision();
  
}

void updateDoublePlayerMode() {
  updateSinglePlayerMode();
  
  checkFriendCollision();
}

void checkPlayerCollision() {
  if ((playerX >= bottomBlock.x && playerX <= bottomBlock.x + blockWidth &&
       playerY >= bottomBlock.y && playerY <= height) ||
      (playerX >= topBlock.x    && playerX <= topBlock.x + blockWidth &&
       playerY >= 0                    && playerY <= bottomBlock.y - squeezeSpace)) {
    playerAlive = false;
  }
}

void checkFriendCollision() {
  if ((friendX >= bottomBlock.x && friendX <= bottomBlock.x + blockWidth &&
       friendY >= bottomBlock.y && friendY <= height) ||
      (friendX >= topBlock.x    && friendX <= topBlock.x + blockWidth &&
       friendY >= 0                    && friendY <= bottomBlock.y - squeezeSpace)) {
    friendAlive = false;
  }
}
// **********************


// Key pressed functions *****
void keyPressed() {
  // SCREEN 1
  if (key == '1') {
    numPlayers = 1;
    playerAlive = true;
  }
  else if (key == '2') {
    numPlayers = 2;
    playerAlive = true;
    friendAlive = true;
  }
  
  // SCREEN 2a
  else if (key == 'a'){
    playerJump();
  }
  else if (key == 'l') {
    friendJump();
  }
  
  // SCREEN 2b
  
  // Screen 3
  else if (key == 'y') {
    playerAlive = true;
    numPlayers = 0;
    setup();
  }
}

void playerJump() {
  if (playerY >=0) {
    playerVerticalVelocity = -7;
  }
}
  
void friendJump() {
  if (friendY >=0) {
    friendVerticalVelocity = -7;
  }
}
// ***************************
