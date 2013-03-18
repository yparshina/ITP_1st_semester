PFont f;
float posX, posY;

number [] myNums = new number[400];

void setup () {
  size(500,500);
 
  f = loadFont("FrutigerNeueLTW1G-Book-48.vlw"); 
    for (int i=0; i<myNums.length; i++) {
    myNums[i] = new number();
  }
}


void draw () {
  background(5,25,30);
  
    for (int i=0; i<myNums.length; i++) {
   myNums[i].makeNum();
   myNums[i].moveNum();
  }
  
  
  
  
}
class number {

  //_______________ VARS __________________

  // var for position and size
  float cPosX, cPosY, cSize, fontSize;
  float numR, numG, numB;
  // vars for eased horizontal movement
  float angle, offset, scalar, speed;
  //var for vertical movement
  float vertSpeed;


  //_______________ FUNCTIONS __________________


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


  void moveNum() {
    cPosX = cPosX + sin(angle) *  scalar;
    angle+=speed;

    if (cPosY > 0-fontSize) {
      cPosY-=vertSpeed*(fontSize/25);
    } 
    else {

      cPosY = height+fontSize*2;
      cPosX = random(0, width);

      fontSize = random (random(2, 5), random(5, random(20, 60)));
    }
  }

  void makeNum() {
    numR = map(cPosY, height, 50, 100, 255);
    numG = 180;
    numB = map(cPosY, height, 0, 255, 100);

    noStroke();
    textFont(f, fontSize);
    fill (numR, numG, numB, map(fontSize, 2, 60, 50, 255));
    text(int(cPosY), cPosX, cPosY);
  }
}


