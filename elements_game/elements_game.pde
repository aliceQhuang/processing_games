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
  
  void createTerrain(float x, float y, float w, float h, float xSpd, float ySpd, float hp){
    createGround("Ground", x, y, w, 2, xSpd, ySpd, hp);
    createWall("Wall", x, y+2, 2, h-4, xSpd, ySpd, hp);
    createWall("Wall", x + w - 2, y+2, 2, h-4, xSpd, ySpd, hp);
    createCeiling("Ceiling", x, y + h - 2, w, 2, xSpd, ySpd, hp);
  }
  
  SolidObject createGround(String id, float x, float y, float w, float h, float xSpd, float ySpd, float hp){
    SolidObject so = new SolidObject();
    
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

  SolidObject createWall(String id, float x, float y, float w, float h, float xSpd, float ySpd, float hp){
    SolidObject so = new SolidObject();
    
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
  
  SolidObject createCeiling(String id, float x, float y, float w, float h, float xSpd, float ySpd, float hp){
    SolidObject so = new SolidObject();
    
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
  enemy = new Person("Enemy", 600, 100, 30, 30, 0, 0, 50);
  
  player.createTerrain(300, 300, 50, 50, 0, 0, 100000);
  player.createGround("Ground", 0, 400, 1000, 50, 0, 0, 100000);
//  player.createWall("Wall", 500, 300, 30, 50, 0, 0, 100000);
//  player.createCeiling("Ceiling", 300, 300, 30, 50, 0, 0, 100000);
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
    else if (so.name == "Wall") {
      fill(255,255,255);
      rect(so.xPos, so.yPos, so.width, so.height);
    }
    else if (so.name == "Ceiling"){
      fill(255,255,255);
      rect(so.xPos, so.yPos, so.width, so.height);
    }
    else if (so.name == "Player"){
      fill(255,0,0);
      rect(so.xPos, so.yPos, so.width, so.height);
    }
    else if (so.name == "Enemy"){
      fill(0,255,0);
      rect(so.xPos, so.yPos, so.width, so.height);
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
      ArrayList<SolidObject> objectsTouched = checkCollision(so);
      
      // testing 
//      if (objectTouched != null){
//      //System.out.println(String.format("%s", objectTouched.name)); 
//      }
      for (SolidObject sot : objectsTouched) {
        if (sot != null && sot.name == "Ground") {  
          
          so.yPos = sot.yPos - so.height;
          so.ySpeed = 0;
          player.isJumping = false;
        }
        
        if (sot != null && sot.name == "Wall") {
          so.xSpeed = 0;
          if (so.xPos <= sot.xPos){
            so.xPos = sot.xPos - so.width;
          } else {
            so.xPos = sot.xPos + sot.width;
          }
        }
        
        if (sot != null && sot.name == "Ceiling") {
          so.yPos = sot.yPos + sot.height;
          so.ySpeed = 0;
        }
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
        
      }
      enemy.health = so.health;
      
      so.ySpeed += gravity;
      so.yPos += so.ySpeed;
      
      so.xPos += so.xSpeed;
     

      if (so.xPos <= 0) {
        so.xPos = 0;
      }
      if (so.xPos >= width-player.width){
        so.xPos = width-player.width;
      }
      ArrayList<SolidObject> objectsTouched = checkCollision(so);
      
      // testing 
//      if (objectTouched != null){
//      //System.out.println(String.format("%s", objectTouched.name)); 
//      }
      for (SolidObject sot : objectsTouched) {
        if (sot != null && sot.name == "Ground") {        
          so.yPos = sot.yPos - so.height;        
          so.ySpeed = 0;       
          player.isJumping = false;       
        }
        
        if (sot != null && sot.name == "Wall") {
          so.xSpeed = 0;
          if (so.xPos <= sot.xPos){
            so.xPos = sot.xPos - so.width;
          } else {
            so.xPos = sot.xPos + sot.width;
          }
        }
        
         if (sot != null && sot.name == "Ceiling") {
          so.yPos = sot.yPos + sot.height;
          so.ySpeed = 0;
        }
        
      }
      
    }
    
    
    else if (so.name == "Projectile"){
      
      Projectile temp = (Projectile) so;
      
      ArrayList<SolidObject> objectsTouched = checkCollision(so);
      for (SolidObject sot : objectsTouched) {
        if (sot != null && sot.name == "Enemy") {  
                
        System.out.println(String.format("HP Before: %s", sot.health));
        
        sot.health -= temp.damage;
        iter.remove();
        player.attacksFired.remove(0);

        System.out.println(String.format("Damage dealt: %s", temp.damage));
        System.out.println(String.format("HP After: %s", sot.health));
      }
      }
      
      // so.ySpeed += gravity;
      so.yPos += so.ySpeed;
      so.xPos += so.xSpeed;
      
      if (so.xPos >= width) {
        iter.remove();
        player.attacksFired.remove(0);
      }
    
    }
  
  } 
    }// while loop

    
ArrayList<SolidObject> checkCollision(SolidObject so1){
  
  ArrayList<SolidObject> list = new ArrayList<SolidObject>();
  
  Iterator<SolidObject> iter = player.getInstances().iterator();
  while (iter.hasNext()) {
    SolidObject so2 = iter.next();
      
      if (so1.name == "Ground"){
        if (so2.name == "Ground" || so2.name == "Wall" || so2.name == "Ceiling"){
          continue;
        }
      }
      if (so1.name == "Wall"){
        if(so2.name == "Ground" || so2.name == "Wall" || so2.name == "Ceiling") {
          continue;
        }
      }
      if (so1.name == "Ceiling"){
        if(so2.name == "Ground" || so2.name == "Wall" || so2.name == "Ceiling") {
          continue;
        }
      }
      
      if (intersects(so1, so2)) { 
        list.add(so2);
        //return so2;
    }
  }
  return list;
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
    //player.createTerrain(player.getInstances().get(0).xPos + 50, player.getInstances().get(0).yPos, 10, 10, 0, 0, 100000);
    System.out.println("Shoot");
    
    for ( SolidObject so : player.getInstances()){
      System.out.println(String.format("Name: %s, X: %s, Y: %s, W: %s, H: %s, xSpd: %s, ySpd: %s, HP: %s", so.name, so.xPos, so.yPos, so.width, so.height, so.xSpeed, so.ySpeed, so.health));
//    System.out.println(String.format("xPos: %s", player.getInstances().get(0).xPos));
//    System.out.println(String.format("yPos: %s", player.getInstances().get(0).yPos));
//    System.out.println(String.format("W: %s", player.getInstances().get(0).width));
//    System.out.println(String.format("H: %s", player.getInstances().get(0).height));
//    System.out.println(String.format("%s", player.getInstances().get(0).name));
//    System.out.println(String.format("%s", player.getInstances().get(1).name));
//    System.out.println(String.format("%s", player.getInstances().get(2).name));
//    System.out.println(String.format("%s", player.getInstances().get(3).name));
  }
}}

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
  
