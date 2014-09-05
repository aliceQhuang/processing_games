// Author: Alice Huang

// File details
// indents = 2 spaces


// Define initial variables *****

// Position variables
float player_x, player_y;
float block_x, block_y; // block coordinates for bottom_block

// Physics variables
float gravity;
float player_vertical_velocity;
float friend_vertical_velocity;

// Boolean variables
boolean player_alive = false;

// Game structures
PImage game_background;
PImage player;
PVector bottom_block_point;
PVector top_block_point;
int block_width = 50;
int squeeze_space = 100;

// Game details
PFont font = createFont("Arial", 30); // TO DO: change to prettier font

// Double player definitions
int number_of_players = 0;
PImage friend;
float friend_x, friend_y;
boolean friend_alive = false;

// ******************************


// TO DO: add scoring, fix the replay, high score shit, shoot lazer beans, grow bigger and smaller, 
// second player, multiple columns on the screen


// Game setup *****
void setup() {
  size(800, 600);
  game_background = loadImage("candy_kingdom_cropped.jpg");
 
  player_x = width/2;
  player_y = height/2;
  gravity = 0.3;
  player_vertical_velocity = 0;
  friend_vertical_velocity = 0;
  
  block_x = width;
  block_y = random(squeeze_space, height);
  
  bottom_block_point = new PVector(block_x, block_y);
  top_block_point    = new PVector(block_x, 0); 
  
  
    player_y = height/2 - 100;
    
    friend_x = width/2;
    friend_y = height/2 + 100;
  
}
// ****************


// Draw functions *****
void draw() {
  background(game_background); // TO DO: change the color of the background to a pretty picture
  noStroke();
  fill(200, 50, 50, 200);
  
  // SCREEN 1: Start screen
  if (number_of_players == 0) {
    textFont(font);
    textAlign(CENTER);
    text("How many players do you have in your game?", width/2, height/2);
    player = loadImage("lsp_transparent.png");
    player.resize(80, 80);
    
    friend = loadImage("lsp_transparent.png");
    friend.resize(80, 80);
   
  }
  
  // SCREEN 2a: Single player mode
  else if (player_alive && number_of_players == 1) {
    image(player, player_x-40, player_y-40);
    //ellipse(player_x, player_y, 20, 20);
    rect(bottom_block_point.x, bottom_block_point.y, block_width, height-bottom_block_point.y);
    rect(top_block_point.x, top_block_point.y, block_width, bottom_block_point.y-squeeze_space);
    player_vertical_velocity += gravity;
    player_y += player_vertical_velocity;
    update_single_player_mode();
  }
  
  // SCREEN 2b: Double player mode
  else if (player_alive && friend_alive) {
    image(player, player_x-40, player_y-40);
    //ellipse(player_x, player_y, 20, 20);
    player_vertical_velocity += gravity;
    player_y += player_vertical_velocity;
    
    image(friend, friend_x-40, friend_y-40);
    friend_vertical_velocity += gravity;
    friend_y += friend_vertical_velocity;
    
    rect(bottom_block_point.x, bottom_block_point.y, block_width, height-bottom_block_point.y);
    rect(top_block_point.x, top_block_point.y, block_width, bottom_block_point.y-squeeze_space);
    
    update_double_player_mode();
    
    
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
  String player_mode_string = String.format("Player mode: %d", number_of_players);
  text(player_mode_string, width - 30, 30);
}
// ********************


// Update functions *****
void update_single_player_mode() {
  if (player_y > height || player_y+30 < 0) {
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
  
  check_player_collision();
  
}

void update_double_player_mode() {
  update_single_player_mode();
  
  check_friend_collision();
}

void check_player_collision() {
  if ((player_x >= bottom_block_point.x && player_x <= bottom_block_point.x + block_width &&
       player_y >= bottom_block_point.y && player_y <= height) ||
      (player_x >= top_block_point.x    && player_x <= top_block_point.x + block_width &&
       player_y >= 0                    && player_y <= bottom_block_point.y - squeeze_space)) {
    player_alive = false;
  }
}

void check_friend_collision() {
  if ((friend_x >= bottom_block_point.x && friend_x <= bottom_block_point.x + block_width &&
       friend_y >= bottom_block_point.y && friend_y <= height) ||
      (friend_x >= top_block_point.x    && friend_x <= top_block_point.x + block_width &&
       friend_y >= 0                    && friend_y <= bottom_block_point.y - squeeze_space)) {
    friend_alive = false;
  }
}
// **********************


// Key pressed functions *****
void keyPressed() {
  // SCREEN 1
  if (key == '1') {
    number_of_players = 1;
    player_alive = true;
  }
  else if (key == '2') {
    number_of_players = 2;
    player_alive = true;
    friend_alive = true;
  }
  
  // SCREEN 2a
  else if (key == 'a'){
    player_jump();
  }
  else if (key == 'l') {
    friend_jump();
  }
  
  // SCREEN 2b
  
  // Screen 3
  else if (key == 'y') {
    player_alive = true;
    number_of_players = 0;
    setup();
  }
}

void player_jump() {
  if (player_y >=0) {
    player_vertical_velocity = -7;
  }
}
  
void friend_jump() {
  if (friend_y >=0) {
    friend_vertical_velocity = -7;
  }
}
// ***************************
