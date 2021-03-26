import meter.*;
import controlP5.*;

ControlP5 cp5;
 
Meter speedometer;
Button accelerator;
Button brake;
int sensorValue;
int minSpeed = 0;
int maxSpeed = 160;
int speed = 0;
 
void setup() {
 
  size(1000, 500);
  background(1);
  speedometer = createSpeedometer();
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
}
 
void draw() {
   
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
  
  
  
  speedometer.updateMeter(speed);
}

Meter createSpeedometer(){
    Meter m = new Meter(this, 300, 100, false); // full circle - true, 1/2 circle - false  
    m.setMeterWidth(320);
    m.setMinScaleValue(minSpeed);
    m.setMaxScaleValue(maxSpeed);
    m.setMinInputSignal(0);
    m.setMaxInputSignal(160);
    m.setFrameColor(color(100, 100, 0));
    m.setTitleFontColor(color(0, 200, 0));
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
    m.setShortTicsBetweenLongTics(5);
    m.setTitle("");
    return m;
}
