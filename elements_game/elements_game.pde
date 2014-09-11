// File Details

// TO DO: parse text file to generate map, merge player/enemy code together (currently lots of duplicate code), element based attacks (collision reactions based on current element)

// Imports

import java.util.Iterator;
import java.awt.Rectangle;

// Define initial variable ******

float gravity = 0.2;

// red blue green grey
color fire = color(255,0,0), water = color(0, 0, 255), earth = color(0,255,0), wind = color(244,244,244);

// Variable to store how much the screen has been scrolled/translated
float environmentTranslate = 0;

// Map
String[] mapText;

// Player and test Enemy variable
Person player;
Person enemy;

// ******************************

// Solid Object class *****
// SolidObject: id, x-position, y-position, width, height, x-speed, y-speed, health
// Player, enemies, projectiles and terrain are all solid objects
static class SolidObject {
  
  float xPos, yPos, width, height, xSpeed, ySpeed, health;
  String name;
  
  // stores all SolidObjects in the game
  private static ArrayList instances = new ArrayList<SolidObject>();
  
  // use instead of constructor to keep track of all SolidObjects created
  public SolidObject createSolidObject (String id, float x, float y, float w, float h, float xSpd, float ySpd, float hp){
    SolidObject so = new SolidObject();
//    name = id;
//    xPos = x;
//    yPos = y;
//    xSpeed = xSpd;
//    ySpeed = ySpd;  
//    width = w;
//    height = h;
//    health = hp;
    
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
  
  // use instead of Projector constructor to keep track of all Projectiles created
  // Projectiles are added to the same list as SolidObjects since they subclass SolidObject
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
  
  // creates impassable Terrain at point (x, y) with width w, height h... etc
  // Terrain consists of a Ground block on top, 2 Walls for the sides, and a Ceiling for the bottom
  void createTerrain(float x, float y, float w, float h, float xSpd, float ySpd, float hp){
    createGround("Ground", x, y, w, h/2, xSpd, ySpd, hp);
    createWall("Wall", x-5, y+5, w/2 + 5, h-10, xSpd, ySpd, hp);
    createWall("Wall", x + w/2, y+5, w/2 + 5, h-10, xSpd, ySpd, hp);
    createCeiling("Ceiling", x, y + h/2, w, h/2, xSpd, ySpd, hp);
  }
  
  // Creates a SolidObject with id "Ground"
  // When collided with, player is set on top of Ground
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

  // Creates a SolidObject with id "Wall"
  // When collided with, player is set to the left or right of Wall
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
  
  // Creates a SolidObject with id "Ceiling"
  // When collided with, player is set to the bottom of Ceiling
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
 
  // Constructor not used publicly
  private SolidObject (){
  }
  
  public static ArrayList<SolidObject> getInstances() {
    return instances;
  }
}

// Person class *****
// Person: width, height, x-position, y-position, health
class Person extends SolidObject {
  boolean isJumping, isFacingR, isMovingR, isMovingL, isStopped;
  ArrayList<Projectile> attacksFired;
  
  // creates a Person and adds it to the list of all SolidObjects using createSolidObject()
  Person(String id, float x, float y, float w, float h, float xSpd, float ySpd, float hp) {
    createSolidObject(id, x, y, w, h, xSpd, ySpd, hp);
    isJumping = true;
    isFacingR = true;
    isMovingR = false;
    isMovingL = false;
    isStopped = true;

    attacksFired = new ArrayList<Projectile>();
  }

  // creates a moving projectile starting from the player and adds it to the list of all SolidObjects as well as the Person's list of projectiles
  void attack() {
    Projectile attackFired = createProjectile("Projectile", getInstances().get(0).xPos + player.width + 5, getInstances().get(0).yPos, 10f, 10f, 15f, 0f, 0f, 10f); 
    attacksFired.add(attackFired);
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
//PImage lsp;

void setup() {
  size(1000, 600);

  // Graphics formatting
  smooth();
//
//    lsp = loadImage("lsp_transparent.png");
//    lsp.resize(80, 80);

  // Player
  player = new Person("Player", 0.3 * width, 100, 30, 30, 0, 0, 100);
  enemy = new Person("Enemy", 600, 100, 30, 30, 0, 0, 500);
  
  // TO DO: generate complete terrain
  player.createTerrain(300, 300, 50, 50, 0, 0, 100000);
  generateMap1();//player.createGround("Ground", 0, 400, 1000, 50, 0, 0, 100000);
  mapText = loadStrings("file.txt");
  //System.out.println(mapText[0]+mapText[1]+mapText[2]);
  //generateMap();
}

void generateMap(){
  for (int i = 0; i < mapText.length; i++){
    for (char ch : mapText[i].toCharArray()){
        System.out.println(ch);
    }
  }
}

void generateMap1(){
  player.createGround("Ground", 0, 400, 99999999, 500, 0, 0, 100000);
  for (int i = 0; i < 10; i++){
  player.createTerrain(random(0,1000), random(height/2, 500), random(10, 100), random(100, 200), 0, 0, 100000);
  }
}


void draw() {
  background(255,255,255);
  noStroke();
  
  update();
  
  // Scroll Environment
  //if (player.getInstances().get(0).xPos >= width * 0.3) {
    environmentTranslate -= player.getInstances().get(0).xSpeed;
    translate(environmentTranslate, 0);
  //}  
  
  // !!! For testing purposes !!! Display player/enemy health, number of active projectiles...
  fill(0,255,0);
  text(player.attacksFired.size(), -environmentTranslate, 20);
  text(String.format("Health: %s", player.health), width-110, 20);
  text(String.format("Enemy Health: %s" , enemy.health), width-200, 500);
  
  // Draw all terrain, then player/enemy, then projectiles
  for (SolidObject so : player.getInstances()) {
    if (so.name == "Ground") {
      fill(0,0,0);
      rect(so.xPos, so.yPos, so.width, so.height);
    }
    else if (so.name == "Wall") {
      fill(0,0,0);
      rect(so.xPos, so.yPos, so.width, so.height);
    }
    else if (so.name == "Ceiling"){
      fill(0,0,0);
      rect(so.xPos, so.yPos, so.width, so.height);
    }
    else if (so.name == "Player"){
      fill(fire);
      //image(lsp,so.xPos, so.yPos - 50);//
      rect(so.xPos, so.yPos, so.width, so.height);
    }
    else if (so.name == "Enemy"){
      fill(water);
      rect(so.xPos, so.yPos, so.width, so.height);
    }
    else if (so.name == "Projectile"){
      fill(fire);
      rect(so.xPos, so.yPos, so.width, so.height);
    }
    
  }
}

void update(){
  
  // Update all SolidObjects
  // The while loop below just loops through the list of all SolidObjects (player.getInstances())
  Iterator<SolidObject> iter = player.getInstances().iterator();
  while (iter.hasNext()) {
    SolidObject so = iter.next();
    // Player update
    if (so.name == "Player"){   

      if (player.isMovingR){
        so.xSpeed = 5;
      } else if (player.isMovingL){
        so.xSpeed = -5;
      }
//      if (xSpeed != 0){
//        player.isStopped = false;
//        if (xSpeed > 0) {
//          player.isMovingR = true;
//          player.isMovingL = false;
//          player.isFacingR = true;
//        } else {
//          player.isMovingR = false;
//          player.isMovingL = true;
//          player.isFacingR = false;
//        }
//      } else {
//        player.isStopped = true;
//      }
      so.ySpeed += gravity;
      so.yPos += so.ySpeed;
      
      so.xPos += so.xSpeed;

      // Terrain Collision ***************
      ArrayList<SolidObject> objectsTouched = checkCollision(so);
      for (SolidObject sot : objectsTouched) {
        if (sot != null && sot.name == "Ground") {  
          
          so.yPos = sot.yPos - so.height;
          so.ySpeed = 0;
          player.isJumping = false;
        }
        
        else if (sot != null && sot.name == "Wall" && so.xSpeed != 0) {
          so.xSpeed = 0;
          if (so.xPos < sot.xPos){
            so.xPos = sot.xPos - so.width;
            System.out.println("Left touch");
          } else {
            so.xPos = sot.xPos + sot.width;
            System.out.println("Right touch");
          }
        }
        
        else if (sot != null && sot.name == "Ceiling") {
          so.yPos = sot.yPos + sot.height;
          so.ySpeed = 0;
        }
      }
      // ********************************
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
      
      for (SolidObject sot : objectsTouched) {
        if (sot != null && sot.name == "Ground") {        
          so.yPos = sot.yPos - so.height;        
          so.ySpeed = 0;       
           
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
        if (sot != null && sot.name == "Enemy" || sot.name == "Wall") {  
                
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
      
      if (so.xPos >= player.getInstances().get(0).xPos + width) {
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
  if (keyCode == UP && !player.isJumping){ 
    System.out.println("Jumped");
    p.ySpeed = -6; 
    
    player.isJumping = true;
    //System.out.println(player.isJumping);
  } 
  if (keyCode == RIGHT) { 
    //p.xSpeed = 5;
   player.isMovingR = true;
   player.isMovingL = false; 
  }
  if (keyCode == LEFT) { 
    //p.xSpeed = -5; 
    player.isMovingR = false;
    player.isMovingL = true;
  }
  if (key == ' ') {
    player.attack();
    //player.createTerrain(player.getInstances().get(0).xPos, player.getInstances().get(0).yPos+10, 10, 10, 0, 0, 100000);
    //player.createTerrain(player.getInstances().get(0).xPos, player.getInstances().get(0).yPos+player.height, 30, 30, 0, 0, 100000);
    System.out.println("Shoot");
    System.out.println(player.isJumping);
    
//    for ( SolidObject so : player.getInstances()){
//      System.out.println(String.format("Name: %s, X: %s, Y: %s, W: %s, H: %s, xSpd: %s, ySpd: %s, HP: %s", so.name, so.xPos, so.yPos, so.width, so.height, so.xSpeed, so.ySpeed, so.health));
//  }
}}

void keyReleased(){
  SolidObject p = player.getInstances().get(0);
  if (keyCode == LEFT || keyCode == RIGHT){
    p.xSpeed = 0;
    player.xSpeed = 0; 
    player.isStopped = true;
    player.isMovingR = false;
    player.isMovingL = false;
    
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
  
