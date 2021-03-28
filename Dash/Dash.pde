import meter.*;
import controlP5.*;

ControlP5 cp5;
 
Meter speedometer;
Meter tachometer;
Button accelerator;
Button brake;
RadioButton turnSelector;
int minSpeed = 0;
int maxSpeed = 160;
int speed = 0;
int maxRpms=7000;
int minRpms=0;
int rpms = 0;
int turnSignal = 0;
int savedTime;
int totalTime = 1000;
 
void setup() {
 
  size(1000, 500);
  background(1);
  //saving time for the timer
  savedTime = millis();
  speedometer = createSpeedometer(300,100,375);
  tachometer = createTachometer(50,100,210);
  cp5 = new ControlP5(this);
  
  accelerator = cp5.addButton("Accelerator")
     .setValue(0)
     .setPosition(100,450)
     .setSize(100,19)
     ;
     
  brake = cp5.addButton("Brake")
     .setValue(0)
     .setPosition(250,450)
     .setSize(100,19)
     ;
     
  turnSelector = cp5.addRadioButton("radioButton")
         .setPosition(400,450)
         .setSize(30,15)
         .setColorForeground(color(120))
         .setColorActive(color(255))
         .setColorLabel(color(255))
         .setItemsPerRow(5)
         .setSpacingColumn(25)
         .addItem("Left",1)
         .addItem("None",2)
         .addItem("Right",3)
         ;
}
 
void draw() {
  
  // This is the global timer.  It checks if 1 sec has passed. 
  int passedTime = millis() - savedTime;
   
  //check if accelerator pedal is pressed and increase speed
  if (accelerator.isPressed()){
    if(speed<maxSpeed){
      delay(50);
      speed++; 
    }
  //check if brake pedal is pressed and decrease speed quickly
  }else if(brake.isPressed()){
    if(speed>minSpeed){
      delay(10);
      speed--; 
    }  
  //decrease speed slowly
  }else{
    if(speed>minSpeed){
      delay(200);
      speed--; 
    }
  }
  
  //Left Turn Signal.  Toggles on and off if turn selected
  if(turnSignal==1 && passedTime < totalTime){
    delay(150);
    fill(0,255,0);
  }else{
    fill(100);
  }
  triangle(230, 60, 280, 40, 280, 80);
  
  //Right Turn Signal.  Toggles on and off if turn selected
  if(turnSignal==2 && passedTime < totalTime){
    delay(150);
    fill(0,255,0);
  }else{
    fill(100);
  }
  triangle(730, 60, 680, 40, 680, 80);
  
  if (passedTime > totalTime) {
    savedTime = millis(); // Save the current time to restart the timer!
  }
  
  tachometer.updateMeter(caluclateRpmsBySpeed(speed));
  speedometer.updateMeter(speed);
}

Meter createSpeedometer(int x, int y, int meterWidth){
    Meter m = new Meter(this, x, y, false); // full circle - true, 1/2 circle - false  
    m.setMeterWidth(meterWidth);
    m.setMinScaleValue(minSpeed);
    m.setMaxScaleValue(maxSpeed);
    m.setMinInputSignal(0);
    m.setMaxInputSignal(160);
    m.setFrameColor(color(0, 0, 255));
    m.setTitleFontColor(color(0, 0, 0));
    m.setPivotPointColor(color(255, 0, 0));
    m.setArcColor(color(0, 0, 200));
    m.setScaleFontColor(color(200, 100, 0));
    m.setTicMarkColor(color(217, 22, 247));
    m.setArcMinDegrees(180.0); // (start)
    m.setArcMaxDegrees(360.0); // ( end)
      
    // Display digital meter value.
    m.setDisplayDigitalMeterValue(true);
    
    String[] scaleLabels = {"0", "10", "20", "30", "40", "50", "60", "70", "80", "90", "100", "110", "120", "130", "140", "150", "160"};
    m.setScaleLabels(scaleLabels);
    m.setShortTicsBetweenLongTics(4);
    m.setTitle("Mph");
    return m;
}

Meter createTachometer(int x, int y, int meterWidth){
    Meter m = new Meter(this, x, y, true); // full circle - true, 1/2 circle - false  
    m.setMeterWidth(meterWidth);
    m.setMinScaleValue(minRpms);
    m.setMaxScaleValue(maxRpms);
    m.setMinInputSignal(0);
    m.setMaxInputSignal(7000);
    m.setFrameColor(color(0, 100, 0));
    m.setTitleFontColor(color(0, 0, 0));
    m.setPivotPointColor(color(255, 0, 0));
    m.setArcColor(color(0, 0, 200));
    m.setScaleFontColor(color(200, 100, 0));
    m.setTicMarkColor(color(217, 22, 247));
    m.setArcMinDegrees(90.0); // (start)
    m.setArcMaxDegrees(300.0); // ( end)
      
    // Display digital meter value.
    m.setDisplayDigitalMeterValue(true);
    
    String[] scaleLabels = {"0", "1", "2", "4", "5", "6", "7"};
    m.setScaleLabels(scaleLabels);
    m.setShortTicsBetweenLongTics(5);
    m.setTitle("RPM (x1000)");
    return m;
}

int caluclateRpmsBySpeed(int speed){
  int rpm = speed * 100; 
  
  if (speed < 10){
    rpm = speed * 500;
  }
  
  if (speed > 10 && speed < 25){
    rpm = speed * 225;
  }
  
  if (speed > 25 && speed < 45){
    rpm = speed * 100;
  }
  
  if (speed > 45 && speed < 70){
    rpm = speed * 50;
  }
  
  if (speed > 70 && speed <= 160){
    rpm = speed * 30;
  }
  
  return rpm;
}

void controlEvent(ControlEvent theEvent) {
  if(theEvent.isFrom(turnSelector)) {
    
    if(theEvent.getValue() == 1.0){
      turnSignal=1;
    }
    
    if(theEvent.getValue() == 2.0){
      turnSignal=0;
    }
    
    if(theEvent.getValue() == 3.0){
      turnSignal=2;
    }
  }
}
