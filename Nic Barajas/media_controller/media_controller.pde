//import org.firmata.*; // ?
import cc.arduino.*;
import processing.serial.*;


/** Setup Note:
    Upload Standard Firmata to your Arduino to use it
    for Processing sketches, or it won’t send input back.
*/

Arduino arduino;

/** Week Four Homework: Media Controller. 
    Using the skills learned so far in class, make
    a simple controller on a breadboard. 
    This controller (pot, buttons, FSR, etc) should control
    a Processing sketch.
    
    Submit a short video clip to show the breadboard and
    the Processing sketch working on your screen.
    
    Example: arduino_input project
*/


int fsrPin = 2;
int potPin = 0;
int buttonPin = 11;

color bkg = 0;

boolean reset = true;
boolean force = false;

// Vars from BouncyBubbles
int numBalls = 16;
float spring = 0.05;
float gravity = 0.00;
float friction = -0.9;
Ball[] balls = new Ball[numBalls];

void setup() {
  arduino = new Arduino(this, "/dev/tty.usbmodem1421", 57600);
  
  arduino.pinMode(buttonPin, Arduino.INPUT);
  arduino.pinMode(potPin, Arduino.INPUT);
  arduino.pinMode(fsrPin, Arduino.INPUT);
  
  size(640,640);
  background(0);
  
  for (int i = 0; i < numBalls; i++) {
    balls[i] = new Ball(random(width), random(height), random(30, 70), i, balls);
  }
  noStroke();
  fill(255, 204);
  
}

void draw() {
  // Reads in values
  
  int fsrVal = arduino.analogRead(fsrPin);
  int buttonVal = arduino.digitalRead(buttonPin); 
  int potVal = arduino.analogRead(potPin);
  
  // map(<value>, source min, source max, dest. min, dest. max)
  float gravityVal = map(potVal, 0, 1023, 0, 0.25); // for gravity
  
  if (fsrVal > 0) {
    println("Gravity: " + gravityVal);
    gravity = gravityVal;
  } else {
    gravity = 0.0;
  }
  
  if (buttonVal == 1) {
    bkg = color(floor(random(0,255)), floor(random(0,255)), floor(random(0,255)));
    background(bkg);
    println("New background: #" + hex(bkg));
  } else {
    background(bkg);
  }
    
  for (int i = 0; i < numBalls; i++) {
    balls[i].collide();
    balls[i].move();
    balls[i].display();  
  }
  
  // Change background flow (reading in pot)
}



/**
 * Bouncy Bubbles  
 * based on code from Keith Peters. 
 * 
 * Multiple-object collision.
 */

class Ball {
  
  float x, y;
  float diameter;
  float vx = 0;
  float vy = 0;
  int id;
  Ball[] others;
 
  Ball(float xin, float yin, float din, int idin, Ball[] oin) {
    x = xin;
    y = yin;
    diameter = din;
    id = idin;
    others = oin;
  } 
  
  void collide() {
    for (int i = id + 1; i < numBalls; i++) {
      float dx = others[i].x - x;
      float dy = others[i].y - y;
      float distance = sqrt(dx*dx + dy*dy);
      float minDist = others[i].diameter/2 + diameter/2;
      if (distance < minDist) { 
        float angle = atan2(dy, dx);
        float targetX = x + cos(angle) * minDist;
        float targetY = y + sin(angle) * minDist;
        float ax = (targetX - others[i].x) * spring;
        float ay = (targetY - others[i].y) * spring;
        vx -= ax;
        vy -= ay;
        others[i].vx += ax;
        others[i].vy += ay;
      }
    }   
  }
  
  void move() {
    vy += gravity;
    x += vx;
    y += vy;
    if (x + diameter/2 > width) {
      x = width - diameter/2;
      vx *= friction; 
    }
    else if (x - diameter/2 < 0) {
      x = diameter/2;
      vx *= friction;
    }
    if (y + diameter/2 > height) {
      y = height - diameter/2;
      vy *= friction; 
    } 
    else if (y - diameter/2 < 0) {
      y = diameter/2;
      vy *= friction;
    }
  }
  
  void display() {
    ellipse(x, y, diameter, diameter);
  }
}
