/* As numbers float up, they display their Y position values.
 
 The colors change with Y position as well.
 
 The sideways motion is created using this sine equation (in the number class):
 cPosX = cPosX + sin(angle) *  scalar;
 
 You can click on any of the numbers, drag them around and see the Y values change.
 
 */


PFont f;
float posX, posY;

number [] myNums = new number[400];

//*************************** SETUP *******************************************
void setup () {
  size(500, 500);

  f = loadFont("FrutigerNeueLTW1G-Book-48.vlw"); 
  for (int i=0; i<myNums.length; i++) {
    myNums[i] = new number();
  }
}

//*************************** DRAW *******************************************
void draw () {
  background(5, 25, 30);

  for (int i=0; i<myNums.length; i++) {

    myNums[i].floating();
    myNums[i].rollover();
    myNums[i].drag();
    myNums[i].display();
  }
}

void mousePressed () {

  for (int i=0; i<myNums.length; i++) {
    myNums[i].clicked();
  }
}

void mouseReleased () {
  for (int i=0; i<myNums.length; i++) {
    myNums[i].stopDragging();
  }
}

//*************************** NUMBER CLASS ***********************************
class number {

  //_________________________ NUMBER VARS ___________________________________

  // var for position and size
  float cPosX, cPosY, cSize, fontSize;
  float numR, numG, numB, numA;

  // vars for eased horizontal movement
  float angle, offset, scalar, speed;

  //var for vertical movement
  float vertSpeed;

  // vars for dragging and mouse rollover
  boolean dragging, rollover;

  // vars to prevent snapping numbers to mouse when grabbed
  int offsetX, offsetY;


  //_________________________ NUMBER VARS ___________________________________

  //......................... CONSTRUCTOR

  number() {
    angle = random(5);
    speed = random(.03, .05);
    vertSpeed = random(.5, 1.5);
    cSize = random (20, 50);
    fontSize =  random (random(2, 5), random(5, random(20, 60)));
    cPosX = random (-fontSize, width);
    cPosY = random (-fontSize, height);
    // increasing this number will widen the horizontal motion of the objects
    scalar = .06*(fontSize/2);
  }

  //.......................... FLOATING

  void floating () {

    if (!dragging) {

      cPosX = cPosX + sin(angle) *  scalar;
      angle+=speed;

      if (cPosY > 0-fontSize) {
        cPosY-=vertSpeed*(fontSize/25);
      } 
      else {

        cPosY = height+fontSize*2;
        cPosX = random(0, width);

        fontSize = random (random(2, 5), random(5, random(20, 60)));
        cSize = fontSize*1.7;
      }

    }
  }


  //......................... ROLLOVER

  void rollover () {
    if (abs(mouseX - cPosX) < cSize/2 && abs(mouseY - cPosY) < cSize/2) {
      rollover = true;
  
} 
    else {
      rollover = false;
    }
  } 


  //......................... CLICKED

  void clicked () {
    if (abs(mouseX - cPosX) < cSize/2 && abs(mouseY - cPosY) < cSize/2) {
      dragging=true;

      offsetX = int(cPosX - mouseX);
      offsetY = int(cPosY - mouseY);
      
      println (fontSize);
    }
  }


  //......................... DRAG

  void drag () {
    if (dragging) {
      rollover = false;
      cPosX = mouseX + offsetX;
      cPosY = mouseY + offsetY;
    }
  }

  //......................... STOP DRAGGIN
  void stopDragging() {
    dragging = false;
    rollover = false;
  }

  //......................... DISPLAY

  void display () {
      
    if (dragging) {
      numR = 255;
      numG = 80;
      numB = 0;
      numA = 255;
    }
    
    if (rollover) {
      numR = 180;
      numG = 255;
      numB = 0;
      numA = 255;
    }
    
    if (!rollover && !dragging) {
    
      numR = map(cPosY, height, 50, 100, 255);
      numG = 180;
      numB = map(cPosY, height, 0, 255, 100);
      numA = map(fontSize, 2, 60, 50, 255);
      
    }

    noStroke();
    textFont(f, fontSize);
    fill (numR, numG, numB, numA);
    text(int(cPosY), cPosX, cPosY);
  }
}

