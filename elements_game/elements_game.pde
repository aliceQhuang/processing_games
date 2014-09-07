// File Details

// TO DO: implement bullet collision
import java.util.Iterator;

// Define initial variable ******
int groundLevel = 400;
float gravity = 0.2;
Person player;
Person enemy;

//SolidObject player;
// ******************************

// Solid Object class *****
static class SolidObject {
  private static ArrayList instances = new ArrayList<SolidObject>();
  float xPos, yPos, width, height, xSpeed, ySpeed;
  String name;
  
  public SolidObject createSolidObject (String id, float x, float y, float w, float h, float xSpd, float ySpd){
    SolidObject so = new SolidObject();
    name = id;
    xPos = x;
    yPos = y;
    xSpeed = xSpd;
    ySpeed = ySpd;
    width = w;
    height = h;
    
    so.name = id;
    so.xPos = x;
    so.yPos = y;
    so.xSpeed = xSpd;
    so.ySpeed = ySpd;
    so.width = w;
    so.height = h;
    instances.add(so);
    
    return so;
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
  float health;
  boolean isJumping;
  ArrayList<Projectile> attacksFired;
  
  Person(String id, float w, float h, float x, float y, float hp) {
    createSolidObject(id, x, y, w, h, 0, 0);
    health = hp;
    isJumping = true;
    attacksFired = new ArrayList<Projectile>();
  }

  void attack() {
    Projectile attackFired = new Projectile(player.getInstances().get(0).xPos, player.getInstances().get(0).yPos, 10, 0, 10); // see projectile constructor
    System.out.println("attack function");
    //System.out.println(String.format("Player is at X: %s Y: %s\nNew Projectile is at X: %s, Y: %s", player.xPos, player.yPos, xPos, yPos));
    attacksFired.add(attackFired);
    for (int i=0; i < player.getInstances().size(); i++){    
      System.out.println(String.format("%s: X: %s, Y: %s, xSpd: %s, ySpd: %s", player.getInstances().get(i).name, player.getInstances().get(i).getX(), player.getInstances().get(i).getY(), player.getInstances().get(i).xSpeed, player.getInstances().get(i).ySpeed));
    }
  }
  
}
// ******************

// Projectile class ******
// Projectile: x-position, y-position, x-speed, y-speed, damage
class Projectile extends SolidObject {

  float damage;
  
  Projectile(float x, float y, float xSpd, float ySpd, float dam) {
    createSolidObject("Projectile", x, y, 10, 10, xSpd, ySpd);
    damage = dam;
  }
}
// ***********************

void setup() {
  size(800, 600);

  // Graphics formatting
  smooth();

  // Players
  player = new Person("Player", 30, 30, 400, 100, 100);
  //player = player.getInstances().get(0);
  enemy = new Person("Enemy", 30, 30, 600, 100, 50);
}

void draw() {
  background(204);
  
  // Ground
  line(0, groundLevel+player.height, width, groundLevel+player.height);
  
//  // Player, TO DO: add image to the person class
//  rect(player.getX(), player.getY(), player.width, player.height);
//  fill(0);
//  textSize(18);
//  textAlign(RIGHT);
//  text(String.format("Health: %s", player.health), width-110, 20);
  
//  // Attacks Fired
//  fill(255,0,0);
//  Person p = (Person) player;
//  for (int i = 0; i < p.attacksFired.size(); i++){
//    rect(p.attacksFired.get(i).getX(), p.attacksFired.get(i).getY(), 10, 10);
//  }
//  
//  // !!! For testing purposes !!!
//  text(p.attacksFired.size(), 0, 20);
//  
//  // Enemy
//  rect(enemy.xPos, enemy.yPos, enemy.width, enemy.height);
//  fill(0);
//  textSize(18);
//  text(String.format("Enemy Health: %s" , enemy.health), width-200, 500);
  
  for (SolidObject so : player.getInstances()) {
    if (so.name == "Player"){
      rect(so.xPos, so.yPos, player.width, player.height);
    }
    else if (so.name == "Enemy"){
      rect(so.xPos, so.yPos, player.width, player.height);
    }
    else if (so.name == "Projectile"){
      rect(so.xPos, so.yPos, 10, 10);
    }
  }
  
  update();
}

void update(){
  
//  // Player Updates
//  player.ySpeed += gravity;
//  player.yPos += player.ySpeed;
//  
//  player.xPos += player.xSpeed;
//  
//  if (player.yPos >= groundLevel){
//    player.yPos = groundLevel;
//    player.ySpeed = 0;
//    player.isJumping = false;
//  }
//  
//  if (player.xPos <= 0) {
//    player.xPos = 0;
//  }
//  if (player.xPos >= width-player.width){
//    player.xPos = width-player.width;
//  }
  
//  // Enemy Updates
//  enemy.ySpeed += gravity;
//  enemy.yPos += enemy.ySpeed;
//  
//  if (enemy.yPos >= groundLevel){
//    enemy.yPos = groundLevel;
//    enemy.ySpeed = 0;
//  }
  
//  Person p = (Person) player;
//  // Attacks Fired
//  for (int i = 0; i < p.attacksFired.size(); i++){
//    
//    ArrayList<Projectile> temp = p.attacksFired;
//    temp.get(i).xPos += temp.get(i).xSpeed;
//    
//    if (temp.get(i).xPos >= width) {
//      p.getInstances().remove(temp.get(i));
//      temp.remove(temp.get(i));
//      
//    }
//  }
  
  // All SolidObjects
  Iterator<SolidObject> iter = player.getInstances().iterator();
  while (iter.hasNext()) {
    SolidObject so = iter.next();
    
    if (so.name == "Player" || so.name == "Enemy"){      
      so.ySpeed += gravity;
      so.yPos += so.ySpeed;
      
      so.xPos += so.xSpeed;
      
      if (so.yPos >= groundLevel){
        so.yPos = groundLevel;
        so.ySpeed = 0;
        if (so.name == "Player"){
          player.isJumping = false;
        }
      }
      
     
  
      if (so.xPos <= 0) {
        so.xPos = 0;
      }
      if (so.xPos >= width-player.width){
        so.xPos = width-player.width;
      }
    }
    
    
    else if (so.name == "Projectile"){
      
      //so.yPos += so.ySpeed;
      so.xPos += so.xSpeed;
      
      if (so.xPos >= width) {
        iter.remove();
      }
    
    }

  }
  
  
}

void keyPressed() {
  
  SolidObject p = player.getInstances().get(0);
  // jump if not already jumping
  if (key == 'w' && !player.isJumping){ 
    p.ySpeed = -6; 
    player.isJumping = true;
    System.out.println("Jumped");
  } 
  else if (key == 'd') { 
    p.xSpeed = 5; 
  }
  else if (key == 'a') { 
    p.xSpeed = -5; 
  }
  else if (key == ' ') {
    player.attack();
  }
}

void keyReleased(){
  SolidObject p = player.getInstances().get(0);
  if (key == 'd' || key == 'a'){
    p.xSpeed = 0; 
  }
}

void createRock(float x, float y, float hp){
  
}
