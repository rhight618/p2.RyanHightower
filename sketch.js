var x = 0;
var y = 300;
var forward = true;

function setup() {
  createCanvas(600, 600);
}

function draw() {
  background(220);
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