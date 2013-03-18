/* 
To interact with it, click on one of the "plants", drag them around, and enjoy the bounce!
You can grab more than one plant at a time.
*/

plant [] meadow = new plant[50];

boolean grab = false;

//*********************************** SETUP ************************************
void setup() {
  frameRate(30);
  size(1000, 400);

  for (int i=0; i< meadow.length; i++) {
    meadow[i] = new plant();
  }
}

//*********************************** DRAW ************************************
void draw() {
  background(255);

  for (int i=0; i<meadow.length; i++) {
    meadow[i].drawPlant();
    meadow[i].grabPlant();
    meadow[i].shakePlant();
  }
}
void mousePressed () {
  grab = true;
}

void mouseReleased () {

  grab = false;
}

//*********************************** PLANT CLASS ******************************

class plant {
  //--------------------------------- PLANT VARS -------------------------------

  //circle top pos & size
  float cPosX, cPosY, cSizeX, cSize, cConstX, cConstY;
  //circle top colors
  float cR, cG, cB, cRon, cGon, cBon, cRoff, cGoff, cBoff;
  // stem curve
  float xTip, yTip, xTipBez, yTipBez, xBaseBez, yBaseBez, xBase, yBase;
  //bounce var
  float cBounce;

  // grab circle top
  boolean cGrabbed=false;

  //--------------------------------- INITIATE PLANT ----------------------------------
  plant () {
    // circle top pos & size
    cSize = random(10, 30);
    cConstX = random(15, width-15);
    cConstY = random(20, height/1.2);
    cPosX = cConstX;
    cPosY = cConstY;

    // circle top off
    cRoff = random (200, 210);
    cGoff = random (0, 100);
    cBoff = random (0, 100);

    // circle top on
    cRon = random (220, 255);
    cGon = random (100, 150);
    cBon = random (50, 100); 

    // final circle top colors
    cR = cRoff;
    cG = cGoff;
    cB = cBoff;

    //stem curve
    xBase = cConstX;
    yBase = height;
    xBaseBez = xBase;
    xTipBez = xBase;
    yTipBez = yBase-(yBase-cPosY)/2;
    yBaseBez = yBase+(yBase-cPosY)/2;
  }

  //---------------------------------------- SHAKE PLANT -------------------------------------
   void shakePlant() {
    cBounce = .5 + (3.7 / cSize);
    yTip = cPosY;
    xTip = cPosX;
    // yBaseBez = yBase-(yBase-yTip)/2;

    if (cGrabbed) {
      cPosX = mouseX;
      cPosY = mouseY;

      cR = cRon;
      cG = cGon;
      cB = cBon;
    }

    else {
      //This condition snaps the cPos back to cConst if the distance between the two is less than 1
      //Otherwise the ball will never completely settle into cConst and will continue to "rubberband" infinitely

      if (dist(cPosX, cPosY, cConstX, cConstY) > 1) {
        // rubberband equations
        cPosX = cConstX+(cConstX-cPosX)* cBounce;
        cPosY = cConstY+(cConstY-cPosY)* cBounce;

        cR = cRoff;
        cG = cGoff;
        cB = cBoff;
      } 
      else {
        cPosX = cConstX;
        cPosY = cConstY;
      }
    }
  }
  //---------------------------------------- GRAB PLANT -------------------------------------
  void grabPlant() {

    if (cSize/2 >= dist(cPosX, cPosY, mouseX, mouseY)) {

      cR = cRon;
      cG = cGon;
      cB = cBon;

      if (grab) {
        cGrabbed = true;
      }
    } 
    else {
      cR = cRoff;
      cG = cGoff;
      cB = cBoff;
    }

    if (!grab) {
      cGrabbed = false;
    }
  }

  //---------------------------------------- DRAW PLANT -------------------------------------
  void drawPlant () {
    // stem curve
    noFill();
    stroke(0) ;
    bezier (cPosX, cPosY, xTipBez, yTipBez, xBaseBez, yBaseBez, xBase, yBase);
    // circle top
     noStroke();
    fill (cR, cG, cB);
    ellipse (cPosX, cPosY, cSize, cSize);

  }
}

