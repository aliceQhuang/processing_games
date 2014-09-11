// File Details

// TO DO: parse text file to generate map, merge player/enemy code together (currently lots of duplicate code), element based attacks (collision reactions based on current element)

// Imports

import java.util.Iterator;
import java.awt.Rectangle;

// Define initial variable ******
float gravity = 0.2;
float friction = 0.2;

// red blue green grey
color fire = color(255,0,0), water = color(0, 0, 255), earth = color(0,255,0), wind = color(244,244,244);

// Variable to store how much the screen has been scrolled/translated
float environmentTranslate = 0;

// For loading a pre-made map, not implemented yet
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
  
  // Stores all SolidObjects in the game
  private static ArrayList instances = new ArrayList<SolidObject>();
  
  // Use this instead of constructor to keep track of all SolidObjects created
  // creates a SolidObject and adds it to the ArrayList instances
  public SolidObject createSolidObject (String id, float x, float y, float w, float h, float xSpd, float ySpd, float hp){
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
  
  // Use this instead of Projector constructor to keep track of all Projectiles created
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
  
  // Creates impassable Terrain at point (x, y) with width w, height h... etc
  // Terrain consists of a Ground block on top, a Wall block for the body, and a Ceiling for the bottom
  // Looks like a sandwich with the middle longer than the buns
  // The Wall 'body' block has greater width than the Ground and Ceiling blocks
  void createTerrain(float x, float y, float w, float h, float xSpd, float ySpd, float hp){
    createGround(x, y, w, 6, xSpd, ySpd, hp);
    createWall(x - 5, y + 5, w + 10, h-10, xSpd, ySpd, hp);
    createCeiling(x, y + h - 6, w, 6, xSpd, ySpd, hp);
  }
  
  // Creates a SolidObject with id "Ground"
  // When collided with, player is set on top of Ground
  SolidObject createGround(float x, float y, float w, float h, float xSpd, float ySpd, float hp){
    SolidObject so = new SolidObject();
    
    so.name = "Ground";
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
  SolidObject createWall(float x, float y, float w, float h, float xSpd, float ySpd, float hp){
    SolidObject so = new SolidObject();
    
    so.name = "Wall";
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
  // When collided with, player is set below the Ceiling
  SolidObject createCeiling(float x, float y, float w, float h, float xSpd, float ySpd, float hp){
    SolidObject so = new SolidObject();
    
    so.name = "Ceiling";
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
  // Movement variables
  boolean isJumping, isFacingR, isMovingR, isMovingL, isStopped;
  
  // Stores all active Projectiles shot by the Person
  ArrayList<Projectile> attacksFired;
  
  // Creates a Person and adds it to the list of all SolidObjects using createSolidObject()
  Person(String id, float x, float y, float w, float h, float xSpd, float ySpd, float hp) {
    createSolidObject(id, x, y, w, h, xSpd, ySpd, hp);
    isJumping = true;
    isFacingR = true;
    isMovingR = false;
    isMovingL = false;
    isStopped = true;

    attacksFired = new ArrayList<Projectile>();
  }

  // Creates a moving projectile starting from the player and adds it to the list of all SolidObjects as well as the Person's list of projectiles
  void attack() {                           //(    id     , initial x-position = player's x-position + 5 , initial yPos = player.yPos, w  , h  ,xSpd,ySpd,hp, damage)
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
  
  // Special effects
  
  // Knocks back input SolidObject
  public void knockBack(SolidObject so, float xSpd, float ySpd){
    so.xSpeed = xSpd;
    so.ySpeed = ySpd; 
  }
}
// ***********************

void setup() {
  size(1000, 600);

  // Graphics formatting
  smooth();

  // Player
  player = new Person("Player", 0.3 * width, 100, 30, 30, 0, 0, 100);
  enemy = new Person("Enemy", 600, 100, 30, 30, 0, 0, 500);
  
  // TO DO: generate complete terrain
  player.createTerrain(300, 300, 50, 50, 0, 0, 100000);
  generateMap1();
}

// Read and parse a mapText file, not implemented yet
void generateMap(){
  for (int i = 0; i < mapText.length; i++){
    for (char ch : mapText[i].toCharArray()){
        System.out.println(ch);
    }
  }
}

// Currently used map generation function
// Creates a long Ground with random 'pillars' of Terrain
void generateMap1(){
  player.createGround(0, 400, 99999999, 500, 0, 0, 100000);
  for (int i = 0; i < 10; i++){
    player.createTerrain(random(0,2000), random(height/2, 400), random(10, 100), random(100, 200), 0, 0, 100000);
    player.createTerrain(random(2000,4000), random(height/3, 600), random(10, 100), random(100, 200), 0, 0, 100000);
    player.createTerrain(random(4000,6000), random(height/1.5, 700), random(10, 100), random(100, 200), 0, 0, 100000);
  }
}


void draw() {
  background(255,255,255);
  noStroke();
  
  update();
  
  // Scroll Environment
  environmentTranslate -= player.getInstances().get(0).xSpeed;
  translate(environmentTranslate, 0);
 
  
  // !!! For testing purposes !!! Display player/enemy health, number of active projectiles...
  fill(0,255,0);
  text(player.attacksFired.size(), -environmentTranslate, 20);
  text(String.format("Health: %s", player.getInstances().get(0).health), width-110-environmentTranslate, 20);
  text(String.format("Enemy Health: %s" , enemy.health), width-200, 500);
  
  // Draw all terrain, then player/enemy, then projectiles
  for (SolidObject so : player.getInstances()) {
    if (so.name == "Ground") {
      fill(139,69,19);
      rect(so.xPos, so.yPos, so.width, so.height);
    }
    else if (so.name == "Wall") {
      fill(139,69,19);
      rect(so.xPos, so.yPos, so.width, so.height);
    }
    else if (so.name == "Ceiling"){
      fill(139,69,19);
      rect(so.xPos, so.yPos, so.width, so.height);
    }
    else if (so.name == "Enemy"){
      fill(water);
      rect(so.xPos, so.yPos, so.width, so.height);
    }
    else if (so.name == "Player"){
      fill(fire);
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
  // The while loop below loops through the list of all SolidObjects (player.getInstances())
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
      
      // if player is moving vertically, assume he is in the air to disable jumping infinite times
      if (so.ySpeed != 0) {
        player.isJumping = true;
      }
      // Update variables and which way the player is facing
      if (xSpeed != 0){
        player.isStopped = false;
        if (xSpeed > 0) {
          player.isMovingR = true;
          player.isMovingL = false;
          player.isFacingR = true;
        } else {
          player.isMovingR = false;
          player.isMovingL = true;
          player.isFacingR = false;
        }
      } else {
        player.isStopped = true;
      }
      
      so.ySpeed += gravity;
      so.yPos += so.ySpeed; 
      so.xPos += so.xSpeed;

      // Terrain Collision ***************
      // Get all objects touched by Player
      ArrayList<SolidObject> objectsTouched = checkCollision(so);
      
      // Stores the specific ground, wall, and ceiling touched by Player. 0 = Ground, 1 = Wall, 2 = Ceiling
      SolidObject[] ObjectsTouched = new SolidObject[3];
      boolean touchedGround = false, touchedLWall = false, touchedRWall = false, touchedCeiling = false;
      
      // Loops through all objects touched to find the specific ground, wall, and ceiling touched, if any
      for (SolidObject sot : objectsTouched) {
        if (sot != null && sot.name == "Ground") {            
          touchedGround = true;
          ObjectsTouched[0] = sot;
        }
        
        else if (sot != null && sot.name == "Wall") {
          so.xSpeed = 0;
          if (so.xPos < sot.xPos){
            touchedLWall = true;
          } else {// if (so.xPos > sot.xPos + sot.width) {
            touchedRWall = true;
          }
          ObjectsTouched[1] = sot;
        }
        
        else if (sot != null && sot.name == "Ceiling") {
          touchedCeiling = true;
          ObjectsTouched[2] = sot;
        }
      }
      
      // Prevent player from going through a Ground block by setting their y-position just above the block upon collision
      if (touchedGround) {
          so.yPos = ObjectsTouched[0].yPos - so.height;
          so.ySpeed = 0;
          player.isJumping = false;
          
          // If player is also touching a Wall, ignore it only if the Wall is below the ground, since the Wall 
          // shouldn't be touched in the first place if there is Ground above it
          if (ObjectsTouched[1] != null && ObjectsTouched[0].yPos < ObjectsTouched[1].yPos && so.yPos < ObjectsTouched[1].yPos){
            touchedLWall = false;
            touchedRWall = false;
          }
      }
      
      // Prevent player from going through walls by setting their x-position depending on whether they are left or right 
      // of the touched wall
      if (touchedLWall){
        so.xPos = ObjectsTouched[1].xPos - so.width;
        System.out.println("Left touch");
      }
      if (touchedRWall){
        so.xPos = ObjectsTouched[1].xPos + ObjectsTouched[1].width;
        System.out.println("Right touch");
      }
      
      // Same for ceiling
      if (touchedCeiling){
        so.yPos = ObjectsTouched[2].yPos + ObjectsTouched[2].height;
        so.ySpeed = 0;
      }
      
      // End Terrain Collision Logic ****
    }
    
    // Enemy Update
    else if (so.name == "Enemy") {
      
      // Remove if enemy is dead
      if (so.health == 0) {
        iter.remove();       
      }
      
      // Update variables; self explanatory
      enemy.health = so.health;
      
      so.ySpeed += gravity;
      so.yPos += so.ySpeed;
      so.xPos += so.xSpeed;
     
      // Apply friction for knock back to function correctly
      if (so.xSpeed > 1){
        so.xSpeed -= friction;
      } else if (so.xSpeed < -1){
        so.xSpeed += friction;
      } else {
        so.xSpeed = 0;
      }
      
      // Simplified Terrain Collision; should copy the extensive one from player later
      ArrayList<SolidObject> objectsTouched = checkCollision(so);
      
      for (SolidObject sot : objectsTouched) {
        if (sot != null && sot.name == "Wall") {
          so.xSpeed = 0;
          if (so.xPos <= sot.xPos){
            so.xPos = sot.xPos - so.width;
          } else {
            so.xPos = sot.xPos + sot.width;
          }
        }
        if (sot != null && sot.name == "Ground") {        
          so.yPos = sot.yPos - so.height;        
          so.ySpeed = 0;                 
        } 
        if (sot != null && sot.name == "Ceiling") {
          so.yPos = sot.yPos + sot.height;
          so.ySpeed = 0;
        }    
      }   
    }
 
    // Projectiles update
    else if (so.name == "Projectile"){  
      // Downcast from SolidObject to Projectile
      Projectile temp = (Projectile) so;
      
      // Collision mechanics for projectiles
      ArrayList<SolidObject> objectsTouched = checkCollision(so);
      for (SolidObject sot : objectsTouched) {
        // if an enemy is hit
        if (sot != null && sot.name == "Enemy") {  
                
          System.out.println(String.format("HP Before: %s", sot.health));
        
          // Apply damage
          sot.health -= temp.damage;
          
          // Apply special effects of projectile (depending on player's element)
          temp.knockBack(sot, 10f, -3f);
          
          // Remove the projectile
          iter.remove();
          player.attacksFired.remove(0);

          System.out.println(String.format("Damage dealt: %s", temp.damage));
          System.out.println(String.format("HP After: %s", sot.health));
          break;
        }
        // if a wall is hit, just remove the projectile
        else if (sot != null && sot.name == "Wall"){
          iter.remove();
          player.attacksFired.remove(0);
          break;
        }
      }
      
      // Update variables    
      so.yPos += so.ySpeed;
      so.xPos += so.xSpeed;
      
      // If projectile goes off-screen, remove it
      if (so.xPos >= player.getInstances().get(0).xPos + width) {
        iter.remove();
        player.attacksFired.remove(0);
        break;
      }   
    }
  } // end of while loop
}

 
// Returns an Array of SolidObjects that intersect with the input SolidObject
// Ignores terrain-terrain collisions
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
    }
  }
  return list;
}

// returns true is the two SolidObjects are overlapping
boolean intersects(SolidObject so1, SolidObject so2) {
  if (so1 == so2){
    return false;
  }
  Rectangle r1 = new Rectangle((int)so1.xPos, (int)so1.yPos, (int)so1.width, (int)so1.height);
  Rectangle r2 = new Rectangle((int)so2.xPos, (int)so2.yPos, (int)so2.width, (int)so2.height);
  
  return (r1.intersects(r2));
}


void keyPressed() {
  // get the SolidObject player
  SolidObject p = player.getInstances().get(0);
  // jump if not already jumping
  if (keyCode == UP && !player.isJumping){ 
    System.out.println("Jumped");
    p.ySpeed = -6; 
    player.isJumping = true;
  } 
  if (keyCode == RIGHT) { 
   player.isMovingR = true;
   player.isMovingL = false; 
  }
  if (keyCode == LEFT) { 
    player.isMovingR = false;
    player.isMovingL = true;
  }
  if (key == ' ') {
    player.attack();
    //player.createTerrain(player.getInstances().get(0).xPos, player.getInstances().get(0).yPos+10, 10, 10, 0, 0, 100000);
    //player.createTerrain(player.getInstances().get(0).xPos, player.getInstances().get(0).yPos+player.height, 30, 30, 0, 0, 100000);
    System.out.println("Shoot");
  }
}

void keyReleased(){
  SolidObject p = player.getInstances().get(0);
  // Stop moving
  if (keyCode == LEFT || keyCode == RIGHT){
    p.xSpeed = 0;
    player.xSpeed = 0; 
    player.isStopped = true;
    player.isMovingR = false;
    player.isMovingL = false;    
  }
}

// Animation class
// Class for animating a sequence of GIFs

class Animation {
  PImage[] images;
  int imageCount;
  int frame;
  
  Animation(String imagePrefix, int count) {
    imageCount = count;
    images = new PImage[imageCount];

    for (int i = 0; i < imageCount; i++) {
      // Use nf() to number format 'i' into four digits
      String filename = imagePrefix + nf(i, 4) + ".gif";
      images[i] = loadImage(filename);
    }
  }

  void display(float xpos, float ypos) {
    frame = (frame+1) % imageCount;
    image(images[frame], xpos, ypos);
  }
  
  int getWidth() {
    return images[0].width;
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
  
