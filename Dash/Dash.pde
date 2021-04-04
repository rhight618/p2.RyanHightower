import meter.*;
import controlP5.*;

ControlP5 cp5;
 
Meter speedometer;
Meter tachometer;
Button accelerator;
Button brake;
RadioButton turnSelector;
RadioButton gearSelector;
RadioButton cruiseControlSelector;
Slider fuelGuage;
int minSpeed = 0;
int maxSpeed = 160;
int speed = 0;
int maxRpms=7000;
int minRpms=0;
int rpms = 0;
int turnSignal = 0;
int savedTime;
int totalTime = 1000;
double miles = 22222.2;
double milesInSeconds = 0.0;
boolean isParked = false;
boolean isDrive = false;
boolean isNeutral = false;
boolean isReverse = false;
boolean isStandard = false;
boolean cruiseControl = false;
int cruiseControlSpeed = 0;
String panelText="Stuff";
 
void setup() {
 
  size(1000, 500);
  //saving time for the timer
  savedTime = millis();
  speedometer = createSpeedometer(300,100,375);
  tachometer = createTachometer(50,100,210);
  
  cp5 = new ControlP5(this);
  accelerator = cp5.addButton("Accelerator")
     .setValue(0)
     .setPosition(25,450)
     .setSize(75,19)
     ;
     
  brake = cp5.addButton("Brake")
     .setValue(0)
     .setPosition(125,450)
     .setSize(75,19)
     ;
     
  turnSelector = cp5.addRadioButton("radioButton1")
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

  gearSelector = cp5.addRadioButton("radioButton2")
         .setPosition(600,450)
         .setSize(30,15)
         .setColorForeground(color(120))
         .setColorActive(color(255))
         .setColorLabel(color(255))
         .setItemsPerRow(3)
         .setSpacingColumn(40)
         .addItem("Park",1)
         .addItem("Reverse",2)
         .addItem("Neutral",3)
         .addItem("Drive",4)
         .addItem("Standard",5)
         ;
         
  cruiseControlSelector = cp5.addRadioButton("radioButton3")
         .setPosition(850,450)
         .setSize(30,15)
         .setColorForeground(color(120))
         .setColorActive(color(255))
         .setColorLabel(color(255))
         .setItemsPerRow(2)
         .setSpacingColumn(40)
         .addItem("Set",1)
         .addItem("Coast",2)
         .addItem("Off",3)
         ;
  
 fuelGuage = cp5.addSlider("")
       .setPosition(50,370)
       .setSize(200,20)
       .setRange(0,20) // values can range from big to small as well
       .setValue(15)
       .setNumberOfTickMarks(5)
       .setSliderMode(Slider.FLEXIBLE)
       ;
}
 
void draw() {
  
  background(1);
  stroke(1);
  
  // This is the global timer.  It checks if 1 sec has passed. 
  int passedTime = millis() - savedTime;

  //adding the Display Section
  fill(0,0,255);
  textSize(28);
  textAlign(CENTER);
  text(panelText, 500, 70);
   
  //check if accelerator pedal is pressed and increase speed
  if (accelerator.isPressed()){
    if(speed<maxSpeed){
      delay(50);
      cruiseControl=false;
      panelText="Cruise Control De-activated";
      speed++; 
    }
  //check if brake pedal is pressed and decrease speed quickly
  }else if(brake.isPressed()){
    if(speed>minSpeed){
      delay(10);
      cruiseControl=false;
      panelText="Cruise Control De-activated";
      speed--; 
    }  
  //decrease speed slowly
  }else{
    if(speed>minSpeed){
      delay(200);
      speed--; 
    }
  }
  
  if(cruiseControl){
    speed=cruiseControlSpeed;
  }
  
  //Left Turn Signal.  Toggles on and off if turn selected
  if(turnSignal==1 && passedTime < totalTime){
    delay(150);
    fill(0,255,0);
  }else{
    fill(1);
  }
  triangle(230, 60, 280, 40, 280, 80);
  
  //Right Turn Signal.  Toggles on and off if turn selected
  if(turnSignal==2 && passedTime < totalTime){
    delay(150);
    fill(0,255,0);
  }else{
    fill(1);
  }
  triangle(730, 60, 680, 40, 680, 80);
  
  //adding the Display Section
  fill(0,0,255);
  textSize(20);
  textAlign(CENTER);
  text((float)miles + " mi", 500, 350);
  
  if (passedTime > totalTime) {
    savedTime = millis(); // Save the current time to restart the timer!
    if(speed > 0){
      milesInSeconds = (((double)speed) / 60.0) / 60.0;
      print(milesInSeconds);
      miles+=milesInSeconds;
      //print(miles);
    }
    
  }
  tachometer.updateMeter(caluclateRpmsBySpeed(speed));
  speedometer.updateMeter(speed);
  
  textAlign(CENTER);
  textSize(20);
  if(isParked){
    fill(255,0,0);
  }else{
    fill(255);
  }
  text("P", 400, 380);
  
  textAlign(CENTER);
  textSize(20);
  if(isReverse){
    fill(255,0,0);
  }else{
    fill(255);
  }
  text("R", 440, 380);
  
  textAlign(CENTER);
  textSize(20);
  if(isNeutral){
    fill(255,0,0);
  }else{
    fill(255);
  }
  text("N", 480, 380);
  
  textAlign(CENTER);
  textSize(20);
  if(isDrive){
    fill(255,0,0);
  }else{
    fill(255);
  }
  text("D", 520, 380);
  
  textAlign(CENTER);
  textSize(20);
  if(isStandard){
    fill(255,0,0);
  }else{
    fill(255);
  }
  text("S", 560, 380);
  
  rect(725, 100, 200, 220);
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
  
  if(theEvent.isFrom(gearSelector)) {
    
    if(theEvent.getValue() == 1.0){
      isParked = true;
      isDrive = false;
      isNeutral = false;
      isReverse = false;
      isStandard = false;
    }

    if(theEvent.getValue() == 2.0){
      isParked = false;
      isDrive = false;
      isNeutral = false;
      isReverse = true;
      isStandard = false;
    }
    
    if(theEvent.getValue() == 3.0){
      isParked = false;
      isDrive = false;
      isNeutral = true;
      isReverse = false;
      isStandard = false;
    }
    
    if(theEvent.getValue() == 4.0){
      isParked = false;
      isDrive = true;
      isNeutral = false;
      isReverse = false;
      isStandard = false;
    }
    
    if(theEvent.getValue() == 5.0){
      isParked = false;
      isDrive = false;
      isNeutral = false;
      isReverse = false;
      isStandard = true;
    }

  }
  
  if(theEvent.isFrom(cruiseControlSelector)) {
    
    if(theEvent.getValue() == 1.0){
      cruiseControl=true;
      cruiseControlSpeed=speed;
      panelText="Cruise Control Activated";
    }

    if(theEvent.getValue() == 2.0){
      cruiseControl=true;
      cruiseControlSpeed=speed;
    }
    
    if(theEvent.getValue() == 3.0){
      cruiseControl=false;
      cruiseControlSpeed=0;
    }

  }
}
