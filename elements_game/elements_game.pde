// File Details

// TO DO: implement bullet collision

// Define initial variable ******
int groundLevel = 400;
float gravity = 0.2;
Person player;
Person enemy;
// ******************************

// Solid Object class *****
static class SolidObject {
  private static ArrayList instances = new ArrayList<SolidObject>();
  float xPos, yPos;
  
  public void createSolidObject (float x, float y){
    SolidObject so = new SolidObject();
    xPos = x;
    yPos = y;
    so.xPos = x;
    so.yPos = y;
    instances.add(so);
  }
  
  private SolidObject (){
  }
  
  public static ArrayList<SolidObject> getInstances() {
    return instances;
  }
  
  public float getX(){
    return xPos;
  }
  
  public float getY(){
    return yPos;
  }
}

// Person class *****
// Person: width, height, x-position, y-position, health
class Person extends SolidObject {
  float width, height, xSpeed, ySpeed, health;
  boolean isJumping;
  ArrayList<Projectile> attacksFired;
  
  Person(float w, float h, float x, float y, float hp) {
    createSolidObject(x, y);
    width = w;
    height = h;
    health = hp;
    xSpeed = 0;
    ySpeed = 0;
    isJumping = true;
    attacksFired = new ArrayList<Projectile>();
  }

  void attack() {
    Projectile attackFired = new Projectile(super.getX(), super.getY(), 10, 0, 10); // see projectile constructor
    System.out.println("shoot function");
    System.out.println(super.getY());
    System.out.println(attackFired.yPos);
    attacksFired.add(attackFired);
    System.out.println(attacksFired.size());
    System.out.println(attackFired.getY());
  }
  
}
// ******************

// Projectile class ******
// Projectile: x-position, y-position, x-speed, y-speed, damage
class Projectile extends SolidObject {
  Person projector;
  float xSpeed, ySpeed, damage;
  
  Projectile(float x, float y, float xSpd, float ySpd, float dam) {
    createSolidObject(x, y);
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
  rect(player.getX(), player.getY(), player.width, player.height);
  fill(0);
  textSize(18);
  textAlign(RIGHT);
  text(String.format("Health: %s", player.health), width-110, 20);
  
  // Attacks Fired
  fill(255,0,0);
  for (int i = 0; i < player.attacksFired.size(); i++){
//    System.out.println("Draw function");
//    System.out.println(player.attacksFired.get(i).getY());
    rect(player.attacksFired.get(i).getX(), player.attacksFired.get(i).getY(), 10, 10);
  }
  
  // !!! For testing purposes !!!
  text(player.attacksFired.size(), 0, 20);
  
  // Enemy
  //rect(enemy.xPos, enemy.yPos, enemy.width, enemy.height);
  //fill(0);
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
    player.attack();
  }
}

void keyReleased(){
  if (key == 'd' || key == 'a'){
    player.xSpeed = 0; 
  }
}

void createRock(float x, float y, float hp){
  
}
