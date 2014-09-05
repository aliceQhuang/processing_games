int groundLevel = 400;
float gravity = 0.2;
float playerX, playerY;
float playerWidth = 30, playerHeight = 30;
float ySpeed = 0;
float xSpeed = 0;
boolean isJumped = false;

int HEIGHT = 600, WIDTH = 800;

void setup(){
  size(WIDTH, HEIGHT);
  playerX = 400;
  playerY = 100;
}

void draw(){
  background(204);
  line(0, groundLevel+playerHeight, 800, groundLevel+playerHeight);
  rect(playerX,playerY,playerWidth,playerHeight);
  update();
}

void update(){
  ySpeed += gravity;
  playerY += ySpeed;
  
  playerX += xSpeed;
  
  if (playerY >= groundLevel){
    playerY = groundLevel;
    ySpeed = 0;
    isJumped = false;
  }
  
  if (playerX <= 0) {
    playerX = 0;
  }
  if (playerX >= WIDTH-playerWidth){
    playerX = WIDTH-playerWidth;
  }
}

void keyPressed() {
  switch (key){
    case('w'): if (!isJumped) { ySpeed = -6; isJumped = true;} break;
    case('d'): xSpeed = 5; break;
    case('a'): xSpeed = -5; break;
    default: break;
  }
}

void keyReleased(){
  switch (key){
    //case(' '): ySpeed = 0; break;
    case('d'): xSpeed = 0; break;
    case('a'): xSpeed = 0; break;
    default: break;
  }
}

void shoot(){
  
}

class Person {
  float xPos, yPos, xSpeed, ySpeed, health;
  
  Person(float x, float y, float hp){
    xPos = x;
    yPos = y;
    health = hp;
    xSpeed = 0;
    ySpeed = 0;
  }
}
class Projectile {
  Person shooter;
  float speed, damage;
}
  
