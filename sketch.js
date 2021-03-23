var x = 0;
var y = 300;
var forward = true;

function setup() {
  createCanvas(1000, 500);
}

function draw() {
  background(1);
  if (mouseIsPressed) {
    if(forward){
      forward=false;
    }else{
      forward=true;
    }
  }
  
  if (forward) {
    x++;
  } else {
    x--;
  }
  circle(x, y, 80);
}