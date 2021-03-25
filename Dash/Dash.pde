import meter.*;
 
Meter m;
int sensorValue;
String ivalue = "0";
BufferedReader datafile1;
 
void setup() {
 
  size(1000, 500);
  //background(150, 255, 100);
 
  m = new Meter(this, 400, 200, false); // full circle - true, 1/2 circle - false  
  m.setMeterWidth(300);
  m.setMinScaleValue(0);
  m.setMaxScaleValue(160);
  m.setMinInputSignal(0);
  m.setMaxInputSignal(160);
    
  // Display digital meter value.
  m.setDisplayDigitalMeterValue(true);
  
  String[] scaleLabels = {"0", "10", "20", "30", "40", "50", "60", "70", "80", "90", "100", "110", "120", "130", "140", "150", "160"};
  m.setScaleLabels(scaleLabels);
  m.setShortTicsBetweenLongTics(9);
}
 
void draw() {
   
  ivalue="75";
  println(ivalue);
  println("currentMeterValue: " + m.getCurrentMeterValue());
 
  m.updateMeter(int(ivalue));
  // Use a delay to see the changes.
  // delay(700);
}
