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
Slider tempGuage;
Slider oilGuage;
MultiList settingsList;
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
boolean isParked = true;
boolean isDrive = false;
boolean isNeutral = false;
boolean isReverse = false;
boolean isStandard = false;
boolean cruiseControl = false;
int cruiseControlSpeed = 0;
String panelText="Welcome";
int timeInSecs = 55000;
 
void setup() {
 
  size(1000, 500);
  //saving time for the timer
  savedTime = millis();
  speedometer = createSpeedometer(300,100,375);
  tachometer = createTachometer(75,100,210);
  
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
  
 fuelGuage = cp5.addSlider(" ")
       .setPosition(75,335)
       .setSize(210,20)
       .setRange(0,20) // values can range from big to small as well
       .setValue(15)
       .setNumberOfTickMarks(5)
       .setSliderMode(Slider.FLEXIBLE)
       ;
       
tempGuage = cp5.addSlider("  ")
       .setPosition(30,100)
       .setSize(20,220)
       .setRange(0,20) // values can range from big to small as well
       .setValue(15)
       .setNumberOfTickMarks(5)
       .setSliderMode(Slider.FLEXIBLE)
       ;
       
oilGuage = cp5.addSlider("   ")
       .setPosition(950,100)
       .setSize(20,220)
       .setRange(0,20) // values can range from big to small as well
       .setValue(15)
       .setNumberOfTickMarks(5)
       .setSliderMode(Slider.FLEXIBLE)
       ;
 
    

  settingsList = cp5.addMultiList("settingsList",710,100,100,20);
  MultiListButton b;
  b = settingsList.add("Climate",1);
   // add items to a sublist of button "level1"
  b.add("level11",11).setLabel("Temp");
  b.add("level12",12).setLabel("Air Flow");
  b = settingsList.add("Entertainment",2);
  b.add("level21",21).setLabel("Bluetooth Audio");
  b.add("level22",22).setLabel("AM/FM");
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
  text(panelText, 490, 70);
   
  //check if accelerator pedal is pressed and increase speed
  if (accelerator.isPressed()){
    if(speed<maxSpeed){
      delay(50);
      if(cruiseControl){
        cruiseControlSpeed++;
      }
      speed++; 
    }
  //check if brake pedal is pressed and decrease speed quickly
  }else if(brake.isPressed()){
    if(speed>minSpeed){
      delay(10);
      if(cruiseControl){
        cruiseControl=false;
        panelText="Cruise Control Disabled";
      }
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
  text((float)miles + " mi", 490, 350);
  
  if (passedTime > totalTime) {
    savedTime = millis(); // Save the current time to restart the timer!
    timeInSecs++;
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
  textSize(15);
  fill(255);
  text("H", 10, 115);
  
  textAlign(CENTER);
  textSize(15);
  fill(255);
  text("C", 10, 315);

  textAlign(CENTER);
  textSize(15);
  fill(255);
  text("F", 930, 115);
  
  textAlign(CENTER);
  textSize(15);
  fill(255);
  text("E", 930, 315);
  

  textAlign(CENTER);
  textSize(20);
  if(isParked){
    fill(255,0,0);
  }else{
    fill(255);
  }
  text("P", 405, 380);
  
  textAlign(CENTER);
  textSize(20);
  if(isReverse){
    fill(255,0,0);
  }else{
    fill(255);
  }
  text("R", 445, 380);
  
  textAlign(CENTER);
  textSize(20);
  if(isNeutral){
    fill(255,0,0);
  }else{
    fill(255);
  }
  text("N", 485, 380);
  
  textAlign(CENTER);
  textSize(20);
  if(isDrive){
    fill(255,0,0);
  }else{
    fill(255);
  }
  text("D", 525, 380);
  
  textAlign(CENTER);
  textSize(20);
  if(isStandard){
    fill(255,0,0);
  }else{
    fill(255);
  }
  text("S", 565, 380);
  
  textAlign(CENTER);
  textSize(15);
  fill(255);
  text("E", 80, 380);
  
  textAlign(CENTER);
  textSize(15);
  fill(255);
  text("1/2", 180, 380);
  
  textAlign(CENTER);
  textSize(15);
  fill(255);
  text("F", 280, 380);
  
  textAlign(CENTER);
  textSize(15);
  fill(0,0,255);
  text("55°", 730, 355);
  
  textAlign(CENTER);
  textSize(15);
  fill(0,0,255);
  text("NW", 805, 355);
  
  textAlign(CENTER);
  textSize(15);
  fill(0,0,255);
  text(getDisplayTimeFromString(timeInSecs), 900, 355);
}

//converts seconds to hours:minutes:seconds for display
String getDisplayTimeFromString(int time){
  
  String returnvalue = "";
  String morning = "AM";
    
  if(time > 0){
    int intTime = Integer.valueOf(time);
    int totalMinutes = intTime / 60;
    int remainderSeconds= intTime % 60;
    int hours = totalMinutes / 60;
    int remainderMinutes = totalMinutes % 60;
    
    if(hours>0){
      
      if(hours>12){
        hours=hours / 12;
        morning= "PM";
      }
      
      returnvalue+= hours + ":";
    }
    
    if(remainderMinutes>0){
      if(hours>0){
        returnvalue+= padWithZeros(remainderMinutes) + ":";
      }else{
        returnvalue+= remainderMinutes + ":";
      }
    }
    
    if(remainderMinutes>0){
      returnvalue+= padWithZeros(remainderSeconds) + "";
    }else{
      returnvalue+= remainderSeconds + "";
    }
  }
  
  return returnvalue + " " + morning; 
}

String padWithZeros(int time){
  String returnValue = str(time);
  
  if(returnValue.length()<2){
    returnValue = "0" + time;
  }
  return returnValue;
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
    m.setFrameColor(color(0, 0, 255));
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
