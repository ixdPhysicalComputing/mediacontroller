import cc.arduino.*;
import processing.serial.*;

Arduino arduino;

void setup(){
  size(800,500);
  
  arduino = new Arduino(this, "/dev/tty.usbmodem1421", 57600);
  
  arduino.pinMode(0, Arduino.INPUT);
}

void draw(){
  background(255);
  
  int potVal = arduino.analogRead(0);
  float newVal = map(potVal,0,1023,0,width);
  
  fill(255,127,127);
  rect(0,0,newVal,height);  
}
