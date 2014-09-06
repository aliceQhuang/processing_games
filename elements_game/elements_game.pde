int groundLevel = 400;
float gravity = 0.2;
Person player;
Person enemy;

void setup(){
  size(800, 600);
  smooth();
  player = new Person(400, 100, 100, 30, 30);
  
  enemy = new Person(600, 100, 50, 30, 30);
}

void draw(){
  background(204);
  
  // ground
  line(0, groundLevel+player.height, width, groundLevel+player.height);
  
  // player, TO DO: add image
  rect(player.xPos, player.yPos, player.width, player.height);
  fill(0);
  textSize(18);
  text(String.format("Health: %s", player.health), width-110, 20);
  
  // bullets
  fill(255,0,0);
  for (int i = 0; i < player.projectiles.size(); i++){
    rect(player.projectiles.get(i).xPos, player.projectiles.get(i).yPos, 10, 10);
  }
  
  // testing
  text(player.projectiles.size(), 0, 20);
  
  // enemy
  rect(enemy.xPos, enemy.yPos, enemy.width, enemy.height);
  fill(0);
  textSize(18);
  text(String.format("Enemy Health: %s" , enemy.health), width-200, 500);
  
  update();
}

void update(){
  
  // player
  player.ySpeed += gravity;
  player.yPos += player.ySpeed;
  
  player.xPos += player.xSpeed;
  
  if (player.yPos >= groundLevel){
    player.yPos = groundLevel;
    player.ySpeed = 0;
    player.isJumped = false;
  }
  
  if (player.xPos <= 0) {
    player.xPos = 0;
  }
  if (player.xPos >= width-player.width){
    player.xPos = width-player.width;
  }
  
  // enemy
  enemy.ySpeed += gravity;
  enemy.yPos += enemy.ySpeed;
  
  if (enemy.yPos >= groundLevel){
    enemy.yPos = groundLevel;
    enemy.ySpeed = 0;
  }
  
  // bullets
  for (int i = 0; i < player.projectiles.size(); i++){
    
    ArrayList<Projectile> temp = player.projectiles;
    temp.get(i).xPos += temp.get(i).xSpeed;
    
    if (temp.get(i).xPos >= width) {
      temp.remove(player.projectiles.get(i));
    }
  }
  
}

void keyPressed() {
  
  // jump if not already jumping
  if (key == 'w' && !player.isJumped){ 
    player.ySpeed = -6; 
    player.isJumped = true;
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

class Person {
  float xPos, yPos, xSpeed, ySpeed, health, width, height;
  boolean isJumped;
  ArrayList<Projectile> projectiles;
  
  Person(float x, float y, float hp, float w, float h){
    xPos = x;
    yPos = y;
    width = w;
    height = h;
    health = hp;
    xSpeed = 0;
    ySpeed = 0;
    isJumped = true;
    projectiles = new ArrayList<Projectile>();
  }
  
  void shoot(){
    Projectile bullet = new Projectile( xPos, yPos, 10, 0, 10); // see projectile constructor
    projectiles.add(bullet);
  }
  
}
class Projectile {
  Person shooter;
  float xSpeed, ySpeed, damage;
  float xPos, yPos;
  
  Projectile( float x, float y, float xSpd, float ySpd, float dam ) {
    xPos = x;
    yPos = y;
    xSpeed = xSpd;
    ySpeed = ySpd;
    damage = dam;
  }
}

void createRock(float x, float y, float hp){
  
}
  
