// Author: Alice Huang

// File details
// indents = 2 spaces


// Define initial variables *****

// Position variables
float playerX, playerY;
float blockX, blockY; // block coordinates for bottomBlock

// Physics variables
float gravity;
float playerVerticalVelocity, playerHorizontalVelocity;
float friendVerticalVelocity, friendHorizontalVelocity;
float blockSpeed = 5;

// Boolean variables
boolean playerAlive = false;

// Game structures
PImage gameBackground1, gameBackground2;
PImage player;
PVector bottomBlock;
PVector topBlock;
int blockWidth = 50;
int squeezeSpace = 300;
float background1Pos, background2Pos; 

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
  size(800, 450);
  gameBackground1 = loadImage("adventure_time_background_resized.jpg");
  gameBackground2 = loadImage("adventure_time_background_resized_flipped.jpg");
 
  background1Pos = 0;
  background2Pos = 800;
  
  playerX = width/2;
  playerY = height/2;
  gravity = 0.3;
  playerVerticalVelocity = 0;
  playerHorizontalVelocity = 0;
  
  friendVerticalVelocity = 0;
  friendHorizontalVelocity = 0;
  
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
  image(gameBackground1, background1Pos, 0); // TO DO: change the color of the background to a pretty picture
  image(gameBackground2, background2Pos, 0);
  noStroke();
  fill(200, 50, 50, 200);
  
  // SCREEN 1: Start screen
  if (numPlayers == 0) {
    textFont(font);
    textAlign(CENTER);
    text("How many players do you have in your game?", width/2, height/2);
    player = loadImage("lsp_transparent.png");
    player.resize(80, 80);
    
    friend = loadImage("jake_transparent.png");
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
    playerX += playerHorizontalVelocity;
    updateSinglePlayerMode();
  }
  
  // SCREEN 2b: Double player mode
  else if (playerAlive && friendAlive) {
    image(player, playerX-40, playerY-40);
    //ellipse(playerX, playerY, 20, 20);
    playerVerticalVelocity += gravity;
    playerY += playerVerticalVelocity;
    playerX += playerHorizontalVelocity;
    
    image(friend, friendX-40, friendY-40);
    friendVerticalVelocity += gravity;
    friendY += friendVerticalVelocity;
    friendX += friendHorizontalVelocity;
    
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
  
  bottomBlock.x -= blockSpeed; // make faster depending on level
  topBlock.x    -= blockSpeed; // HARD CODE A VARIABLE LATER
  
  if (bottomBlock.x < 0) {
    bottomBlock.x = width;
    bottomBlock.y = random(squeezeSpace, height);
    topBlock.x = width;
    topBlock.y = 0;
  }
  
  // Scroll background
  background1Pos -= blockSpeed;
  background2Pos -= blockSpeed;
  if (background1Pos <= -800){
    background1Pos = 800;
  }
  if (background2Pos <= -800){
    background2Pos = 800;
  }
  
  checkPlayerCollision();
  
}

void updateDoublePlayerMode() {
  updateSinglePlayerMode();
  
  if (friendY > height || friendY+30 < 0) {
    friendAlive = false;
  }
  
  checkFriendCollision();
}

void checkPlayerCollision() {
  if ((playerX >= bottomBlock.x && playerX <= bottomBlock.x + blockWidth &&
       playerY >= bottomBlock.y && playerY <= height) ||
      (playerX >= topBlock.x    && playerX <= topBlock.x + blockWidth &&
       playerY >= 0             && playerY <= bottomBlock.y - squeezeSpace)) {
    playerAlive = false;
  }
}

void checkFriendCollision() {
  if ((friendX >= bottomBlock.x && friendX <= bottomBlock.x + blockWidth &&
       friendY >= bottomBlock.y && friendY <= height) ||
      (friendX >= topBlock.x    && friendX <= topBlock.x + blockWidth &&
       friendY >= 0             && friendY <= bottomBlock.y - squeezeSpace)) {
    friendAlive = false;
  }
  
  if (Math.abs(friendX-playerX) <= 80 && Math.abs(friendY-playerY) <= 80) {
    if (playerY >= friendY){
      playerY = playerY + ((80 - (playerY-friendY))/2);
      friendY = friendY - ((80 - (playerY-friendY))/2);
    }
    else if (playerY < friendY){
      playerY = playerY - ((80 - (friendY-playerY))/2);
      friendY = friendY + ((80 - (friendY-playerY))/2);
    }
    
    friendVerticalVelocity *= -1;
    friendHorizontalVelocity *= -1;
    playerVerticalVelocity *= -1;
    playerHorizontalVelocity *= -1;
    
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
  else if (key == 'w'){
    playerJump();
  }
  else if (key == 'a'){
    playerMoveL();
  }
  else if (key == 'd'){
    playerMoveR();
  }
  else if (key == 'o') {
    friendJump();
  }
  else if (key == 'k'){
    friendMoveL();
  }
  else if (key ==';') {
    friendMoveR();
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

void playerMoveL(){
  playerHorizontalVelocity = -7;
}

void playerMoveR(){
  playerHorizontalVelocity = 7;
}
  
void friendJump() {
  if (friendY >=0) {
    friendVerticalVelocity = -7;
  }
}

void friendMoveL(){
  friendHorizontalVelocity = -7;
}

void friendMoveR(){
  friendHorizontalVelocity = 7;
}

void keyReleased(){
  if (key == 'a' || key == 'd'){
    playerHorizontalVelocity = 0; 
  }
  
  if (key == 'k' || key == ';'){
    friendHorizontalVelocity = 0;
  }
}

// ***************************
