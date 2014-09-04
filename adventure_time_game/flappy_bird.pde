// File details
// indents = 2 spaces

// Define initial variables *****

// Position variables
float player_x, player_y;
float block_x, block_y; // block coordinates for bottom_block

// Physics variables
float gravity;
float vertical_velocity;

// Boolean variables
boolean player_alive;

// Game structures
PImage player;
PVector bottom_block_point;
PVector top_block_point;
int block_width = 50;
int squeeze_space = 100;

// Game details
PFont font = createFont("Arial", 30); // TO DO: change to prettier font

// ******************************

// TO DO: add scoring, fix the replay, high score shit, shoot lazer beans, grow bigger and smaller

// Game setup
void setup() {
  size(800, 600);
  player = loadImage("lsp.png");
  player.resize(75, 75);
  player_x = width/2;
  player_y = height/2;
  gravity = 0.3;
  vertical_velocity = 0;
  
  player_alive = true;
  
  block_x = width;
  block_y = random(squeeze_space, height);
  
  bottom_block_point = new PVector(block_x, block_y);
  top_block_point    = new PVector(block_x, 0); 
}
  
void draw() {
  background(102, 217, 239); // TO DO: change the color of the background to a pretty picture
  if (player_alive) {
    if (player_y <= 0){
      player_y = 25;
    }
    image(player, player_x, player_y);
    ellipse(player_x, player_y, 20, 20);
    rect(bottom_block_point.x, bottom_block_point.y, block_width, height-bottom_block_point.y);
    rect(top_block_point.x, top_block_point.y, block_width, bottom_block_point.y-squeeze_space);
    noStroke();
    fill(200, 50, 50, 200);
    vertical_velocity += gravity;
    player_y += vertical_velocity;
    update();
  }
  else {
    fill(0, 0, 0); // TO DO: change color
    textFont(font);
    textAlign(CENTER);
    text("GAME OVER", width/2, height/2);
    text("Do you want to play again? (y/n)", width/2, height/2+50);
  }
}

void update() {
  if (player_y > height) {
    player_alive = false;
  }
  
  bottom_block_point.x -= 5; // make faster depending on level
  top_block_point.x    -= 5; // HARD CODE A VARIABLE LATER
  
  if (bottom_block_point.x < 0) {
    bottom_block_point.x = width;
    bottom_block_point.y = random(squeeze_space, height);
    top_block_point.x = width;
    top_block_point.y = 0;
  }
  
  check_collision();
  
}

void check_collision() {
  if ((player_x >= bottom_block_point.x && player_x <= bottom_block_point.x + block_width &&
       player_y >= bottom_block_point.y && player_y <= height) ||
      (player_x >= top_block_point.x    && player_x <= top_block_point.x + block_width &&
       player_y >= 0                    && player_y <= bottom_block_point.y - squeeze_space)) {
    player_alive = false;
  }
}  

void jump() {
  if (player_y >=0) {
    vertical_velocity = -7;
  }
}

void keyPressed() {
  if (key == 'y') {
    player_alive = true;
    setup();
  }
  else {
    jump();
  }
}
