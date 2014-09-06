// Define initial variable ******
int groundLevel = 400;
float gravity = 0.2;
Person player;
Person enemy;
// ******************************

// Person class *****
// Person: width, height, x-position, y-position, health
class Person {
  float width, height, xPos, yPos, xSpeed, ySpeed, health;
  boolean isJumping;
  ArrayList<Projectile> attacksFired;
  
  Person(float w, float h, float x, float y, float hp) {
    width = w;
    height = h;
    xPos = x;
    yPos = y;
    health = hp;
    xSpeed = 0;
    ySpeed = 0;
    isJumping = true;
    attacksFired = new ArrayList<Projectile>();
  }

  void shoot() {
    Projectile attackFired = new Projectile( xPos, yPos, 10, 0, 10); // see projectile constructor
    attacksFired.add(attackFired);
  }
  
}
// ******************

// Projectile class ******
// Projectile: x-position, y-position, x-speed, y-speed, damage
class Projectile {
  Person projector;
  float xPos, yPos, xSpeed, ySpeed, damage;
  
  Projectile(float x, float y, float xSpd, float ySpd, float dam) {
    xPos = x;
    yPos = y;
    xSpeed = xSpd;
    ySpeed = ySpd;
    damage = dam;
  }
}
// ***********************

void setup() {
  size(800, 600);

  // Graphics formatting
  smooth();

  // Players
  player = new Person(30, 30, 400, 100, 100);
  enemy = new Person(30, 30, 600, 100, 50);
}

void draw() {
  background(204);
  
  // Ground
  line(0, groundLevel+player.height, width, groundLevel+player.height);
  
  // Player, TO DO: add image to the person class
  rect(player.xPos, player.yPos, player.width, player.height);
  fill(0);
  textSize(18);
  textAlign(RIGHT);
  text(String.format("Health: %s", player.health), width-110, 20);
  
  // Attacks Fired
  fill(255,0,0);
  for (int i = 0; i < player.attacksFired.size(); i++){
    rect(player.attacksFired.get(i).xPos, player.attacksFired.get(i).yPos, 10, 10);
  }
  
  // !!! For testing purposes !!!
  text(player.attacksFired.size(), 0, 20);
  
  // Enemy
  rect(enemy.xPos, enemy.yPos, enemy.width, enemy.height);
  fill(0);
  textSize(18);
  text(String.format("Enemy Health: %s" , enemy.health), width-200, 500);
  
  update();
}

void update(){
  
  // Player Updates
  player.ySpeed += gravity;
  player.yPos += player.ySpeed;
  
  player.xPos += player.xSpeed;
  
  if (player.yPos >= groundLevel){
    player.yPos = groundLevel;
    player.ySpeed = 0;
    player.isJumping = false;
  }
  
  if (player.xPos <= 0) {
    player.xPos = 0;
  }
  if (player.xPos >= width-player.width){
    player.xPos = width-player.width;
  }
  
  // Enemy Updates
  enemy.ySpeed += gravity;
  enemy.yPos += enemy.ySpeed;
  
  if (enemy.yPos >= groundLevel){
    enemy.yPos = groundLevel;
    enemy.ySpeed = 0;
  }
  
  // Attacks Fired
  for (int i = 0; i < player.attacksFired.size(); i++){
    
    ArrayList<Projectile> temp = player.attacksFired;
    temp.get(i).xPos += temp.get(i).xSpeed;
    
    if (temp.get(i).xPos >= width) {
      temp.remove(player.attacksFired.get(i));
    }
  }
  
}

void keyPressed() {
  
  // jump if not already jumping
  if (key == 'w' && !player.isJumping){ 
    player.ySpeed = -6; 
    player.isJumping = true;
  } 
  else if (key == 'd') { 
    player.xSpeed = 5; 
  }
  else if (key == 'a') { 
    player.xSpeed = -5; 
  }
  else if (key == ' ') {
    player.shoot();
  }
}

void keyReleased(){
  if (key == 'd' || key == 'a'){
    player.xSpeed = 0; 
  }
}

void createRock(float x, float y, float hp){
  
}
