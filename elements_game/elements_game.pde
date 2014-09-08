// File Details

// TO DO: Terrain creation/destruction, merge player/enemy code together (currently lots of duplicate code)
import java.util.Iterator;
import java.awt.Rectangle;

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
  float xPos, yPos, width, height, xSpeed, ySpeed, health;
  String name;
  
  public SolidObject createSolidObject (String id, float x, float y, float w, float h, float xSpd, float ySpd, float hp){
    SolidObject so = new SolidObject();
    name = id;
    xPos = x;
    yPos = y;
    xSpeed = xSpd;
    ySpeed = ySpd;
    width = w;
    height = h;
    health = hp;
    
    so.name = id;
    so.xPos = x;
    so.yPos = y;
    so.xSpeed = xSpd;
    so.ySpeed = ySpd;
    so.width = w;
    so.height = h;
    so.health = hp;
    
    instances.add(so);
    
    return so;
  }
  
  public Projectile createProjectile (String id, float x, float y, float w, float h, float xSpd, float ySpd, float hp, float dam){
    Projectile p = new Projectile();
    
    p.name = id;
    p.xPos = x;
    p.yPos = y;
    p.xSpeed = xSpd;
    p.ySpeed = ySpd;
    p.width = w;
    p.height = h;
    p.health = hp;
    p.damage = dam;
    
    SolidObject so = (SolidObject) p;
    instances.add(p);
    
    return p;
  }
  
  SolidObject createGround(String id, float x, float y, float w, float h, float xSpd, float ySpd, float hp){
    SolidObject so = new SolidObject();
    name = id;
    xPos = x;
    yPos = y;
    xSpeed = xSpd;
    ySpeed = ySpd;
    width = w;
    height = h;
    health = hp;
    
    so.name = id;
    so.xPos = x;
    so.yPos = y;
    so.xSpeed = xSpd;
    so.ySpeed = ySpd;
    so.width = w;
    so.height = h;
    so.health = hp;
    
    instances.add(so);
    
    return so;
  }

  void createWall(){
  }  
  

  
  private SolidObject (){
  }
  
  public static ArrayList<SolidObject> getInstances() {
    return instances;
  }
}

// Person class *****
// Person: width, height, x-position, y-position, health
class Person extends SolidObject {
  boolean isJumping;
  ArrayList<Projectile> attacksFired;
  
  Person(String id, float x, float y, float w, float h, float xSpd, float ySpd, float hp) {
    createSolidObject(id, x, y, w, h, xSpd, ySpd, hp);
    isJumping = true;
    attacksFired = new ArrayList<Projectile>();
  }

  void attack() {
    Projectile attackFired = createProjectile("Projectile", getInstances().get(0).xPos + player.width + 5, getInstances().get(0).yPos, 10f, 10f, 15f, 0f, 0f, 10f); 
    attacksFired.add(attackFired);
    
    // Debugging
//    System.out.println("attack function");
//    for (int i=0; i < player.getInstances().size(); i++){    
//      System.out.println(String.format("%s: X: %s, Y: %s, xSpd: %s, ySpd: %s", player.getInstances().get(i).name, player.getInstances().get(i).getX(), player.getInstances().get(i).getY(), player.getInstances().get(i).xSpeed, player.getInstances().get(i).ySpeed));
//    }
  }
  
}
// ******************

// Projectile class ******
// Projectile: x-position, y-position, x-speed, y-speed, damage
static class Projectile extends SolidObject {

  float damage;
  private Projectile() {
  }
}
// ***********************

void setup() {
  size(800, 600);

  // Graphics formatting
  smooth();

  // Players
  player = new Person("Player", 0, 100, 30, 30, 0, 0, 100);
  enemy = new Person("Enemy", 600000, 100000, 0, 0, 0, 0, 50);
  
  player.createGround("Ground", 0, 400, 30, 30, 0, 0, 100000);
}

void draw() {
  background(0,0,255);
 
  // Old Ground Logic
  // line(0, groundLevel+player.height, width, groundLevel+player.height);
  
  // !!! For testing purposes !!!
  fill(0,255,0);
  text(player.attacksFired.size(), 0, 20);
  text(String.format("Health: %s", player.health), width-110, 20);
  text(String.format("Enemy Health: %s" , enemy.health), width-200, 500);
  
  for (SolidObject so : player.getInstances()) {
    if (so.name == "Ground") {
      fill(255,255,255);
      rect(so.xPos, so.yPos, so.width, so.height);
    }
    else if (so.name == "Player"){
      fill(255,0,0);
      rect(so.xPos, so.yPos, player.width, player.height);
    }
    else if (so.name == "Enemy"){
//      fill(255,0,0);
//      rect(so.xPos, so.yPos, player.width, player.height);
    }
    else if (so.name == "Projectile"){
      fill(255,255,255);
      rect(so.xPos, so.yPos, so.width, so.height);
    }
    
  }
  
  update();
}

void update(){
  
  // All SolidObjects
  Iterator<SolidObject> iter = player.getInstances().iterator();
  while (iter.hasNext()) {
    SolidObject so = iter.next();
    
    if (so.name == "Player"){   
      // New Ground Logic ***************
      SolidObject objectTouched = checkCollision(so);
      
      // testing 
      if (objectTouched != null){
      System.out.println(String.format("%s", objectTouched.name)); }
      if (objectTouched != null && objectTouched.name == "Ground") {
        
               
        System.out.println(String.format("Grounded"));
        
        so.yPos = objectTouched.yPos - so.height;
        
        so.ySpeed = 0;
       
        player.isJumping = false;
        
       
      }
      // ********************************
      
      
      so.ySpeed += gravity;
      so.yPos += so.ySpeed;
      
      so.xPos += so.xSpeed;
      
      // Old Ground Logic ***************
//      if (so.yPos >= groundLevel){
//        so.yPos = groundLevel;
//        so.ySpeed = 0;
//        if (so.name == "Player"){
//          player.isJumping = false;
//        }
//      }
      // ********************************

      if (so.xPos <= 0) {
        so.xPos = 0;
      }
      if (so.xPos >= width-player.width){
        so.xPos = width-player.width;
      }
    }
    else if (so.name == "Enemy") {
      
      if (so.health == 0) {
        iter.remove();
        break;
      }
      enemy.health = so.health;
      
      checkCollision(so);   
      
      so.ySpeed += gravity;
      so.yPos += so.ySpeed;
      
      so.xPos += so.xSpeed;
      
      if (so.yPos >= groundLevel){
        so.yPos = groundLevel;
        so.ySpeed = 0;
      }

      if (so.xPos <= 0) {
        so.xPos = 0;
      }
      if (so.xPos >= width-player.width){
        so.xPos = width-player.width;
      }
    }
    
    
    else if (so.name == "Projectile"){
      
      Projectile temp = (Projectile) so;
      SolidObject objectHit = checkCollision(so);
      if (objectHit != null && objectHit.name == "Enemy") {
        
                
        System.out.println(String.format("HP Before: %s", objectHit.health));
        
        objectHit.health -= temp.damage;
        iter.remove();
        player.attacksFired.remove(0);

        System.out.println(String.format("Damage dealt: %s", temp.damage));
        System.out.println(String.format("HP After: %s", objectHit.health));
      }
      
      // so.ySpeed += gravity;
      so.yPos += so.ySpeed;
      so.xPos += so.xSpeed;
      
      if (so.xPos >= width) {
        iter.remove();
        player.attacksFired.remove(0);
      }
    
    }
  
  } // while loop
}

SolidObject checkCollision(SolidObject so1){
  
  Iterator<SolidObject> iter = player.getInstances().iterator();
  while (iter.hasNext()) {
    SolidObject so2 = iter.next();
      if (intersects(so1, so2)) { 

        return so2;
    }
  }
  return null;
}
boolean intersects(SolidObject so1, SolidObject so2) {
  if (so1 == so2){
    return false;
  }
  Rectangle r1 = new Rectangle((int)so1.xPos, (int)so1.yPos, (int)so1.width, (int)so1.height);
  Rectangle r2 = new Rectangle((int)so2.xPos, (int)so2.yPos, (int)so2.width, (int)so2.height);
  
  if (r1.intersects(r2)){
    //System.out.println("Collision detected");
    return true;
  }
 return false; 
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
    System.out.println("Shoot");
    
    System.out.println(String.format("xPos: %s", player.getInstances().get(0).xPos));
    System.out.println(String.format("yPos: %s", player.getInstances().get(0).yPos));
    System.out.println(String.format("W: %s", player.getInstances().get(0).width));
    System.out.println(String.format("H: %s", player.getInstances().get(0).height));
//    System.out.println(String.format("%s", player.getInstances().get(0).name));
//    System.out.println(String.format("%s", player.getInstances().get(1).name));
//    System.out.println(String.format("%s", player.getInstances().get(2).name));
//    System.out.println(String.format("%s", player.getInstances().get(3).name));
  }
}

void keyReleased(){
  SolidObject p = player.getInstances().get(0);
  if (key == 'd' || key == 'a'){
    p.xSpeed = 0; 
  }
}

// Not used ATM
public SolidObject findPlayer(){
  for (SolidObject so : player.getInstances()){
    if (so.name == "Player"){
      //Person p = (Person) so;
      return so;
    }
  }
  return null;
}

// Not used ATM
public SolidObject findEnemy(){
  for (SolidObject so : player.getInstances()){
    if (so.name == "Enemy"){
      Person p = (Person) so;
      return p;
    }
  }
  return null;
}
  
