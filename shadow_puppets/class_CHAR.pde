
class character {

  // character's physical attributes
  int torsoX, torsoY, charW, charH, charLegLength, charToeLength, charGround, eyeSize;

  // HORN SHAPES
  PShape horn1, horn2;
  
  int birdEar;

  // offsets the character from mouseX/mouseY based on where the mouse was when the character was clicked
  int offsetX, offsetY;
  int charBlink; 
  int charR;

  //customizes the rectangle curves of each character type
  int rectCurve, rectCurveComp;

  //determines which character to make based on user input
  int charType;

  //drag and rollover states of characters
  boolean dragging, rollover;

  // leg class
  leg leg1, leg2, leg3, leg4, leg5, leg6;

  // eye class 
  eye eye1, eye2, eye3, eye4;

  //----------------------------- CONSTRUCTOR -------------------------------

  character (int passCharType) {
    charR = 0;
    charType = passCharType;

    torsoX = int(random(80, width-80));
    torsoY = -80;

    if (charType == 1 ) {

      charW = int(random(180, 210));
      charH = int (random(100, 120));
      charLegLength = int( random(30, 60));
      charToeLength = int ( random(8, 12));
      charGround = stageH - (charH/2+charLegLength+charToeLength-4);
      eyeSize = int(random(14, 20));

      //curveComp is a number that's compensating for the curved angles of the rect when trying to determine rollover
      rectCurveComp = 40;
      rectCurve = 50;

      leg1 = new leg(torsoX, torsoY, -(charW/4), charH/2-2, charLegLength, charToeLength);
      leg2 = new leg(torsoX, torsoY, -(charW/4-(10*(charW/90))), charH/2-2, charLegLength, charToeLength);
      leg3 = new leg(torsoX, torsoY, charW/4-(10*(charW/90)), charH/2-2, charLegLength, charToeLength);
      leg4 = new leg(torsoX, torsoY, charW/4, charH/2-2, charLegLength, charToeLength);

      eye1 = new eye(torsoX, torsoY, -int((charW/2.8)), -(charH/6), eyeSize);
      eye2 = new eye(torsoX, torsoY, -int((charW/4.5)), -(charH/6), eyeSize+4);

    }

    if (charType == 2 ) {

      charW = int(random(60, 80));
      charH = int (random(80, 100));
      charLegLength = int( random(60, 100));
      charToeLength = int ( random(8, 12));
      charGround = stageH - (charH/2+charLegLength+charToeLength-4);
      eyeSize = int(random(10, 18));


      //curveComp is a number that's compensating for the curved angles of the rect when trying to determine rollover
      rectCurveComp = -9;
      rectCurve = 50;

      leg5 = new leg(torsoX, torsoY, -(charW/5), charH/2-2, charLegLength, charToeLength);
      leg6 = new leg(torsoX, torsoY, (charW/5), charH/2-2, charLegLength, charToeLength);

      eye3 = new eye(torsoX, torsoY, -(charW/4), -(charH/6), eyeSize);
      eye4 = new eye(torsoX, torsoY, (charW/4), -(charH/6), eyeSize+2);
      
       birdEar = int(random(14, 26));
    }
  }

  //-------------------------------  DISPLAY -----------------------------------
  void display () {


    // DEER LEGS & HORNS
    if (charType == 1) {    
      // legs
      leg1.makeLeg(torsoX, torsoY, rollover);
      leg2.makeLeg(torsoX, torsoY, rollover);
      leg3.makeLeg(torsoX, torsoY, rollover);
      leg4.makeLeg(torsoX, torsoY, rollover);

      // horns

      // load black horns when no rollover & load red horns on rollover
      if (rollover) {
        horn1 = loadShape ("horn1_red.svg");
        horn2 = loadShape ("horn2_red.svg");
      } 
      else {

        horn1 = loadShape ("horn1_black.svg");
        horn2 = loadShape ("horn2_black.svg");
      }    
      // draw horns
      shape (horn1, torsoX-charW/3.8, torsoY-(charH/2+60));
      shape (horn2, torsoX-charW/1.7, torsoY-(charH/2+58));
    }

    // BIRD LEGS & EARS
    if (charType == 2) {    
      // legs
      leg5.makeLeg(torsoX, torsoY, rollover);
      leg6.makeLeg(torsoX, torsoY, rollover);
    
    // earL (topX, topY, bttmL X, bttmL YbttmR X, bttmR Y);
  triangle(torsoX-charW/4, torsoY-(charH/2+birdEar),torsoX-(charW/4-8), torsoY-(charH/2-2), torsoX-(charW/4+10), torsoY-(charH/3-2));
   
   // earR (topX, topY, bttmL X, bttmL YbttmR X, bttmR Y);
    triangle(torsoX+charW/4, torsoY-(charH/2+birdEar),torsoX+(charW/4-8), torsoY-(charH/2-2), torsoX+(charW/4+10), torsoY-(charH/3-2));
}

    if (rollover) {
      charR = 255;
    } 
    else {
      charR = 0;
    }
    // BODY
    noStroke();
    fill(charR, 0, 0);
    rect(torsoX, torsoY, charW, charH, rectCurve);

    // DEER EYES

    if (charType == 1) {    

      eye1.display(torsoX, torsoY);
      eye1.blink(charBlink);
      eye2.display(torsoX, torsoY);
      eye2.blink(charBlink);
    }

    // BIRD EYES & BEAK
    if (charType == 2) {    

      eye3.display(torsoX, torsoY);
      eye3.blink(charBlink);
      eye4.display(torsoX, torsoY);
      eye4.blink(charBlink);
      
      //beak
      fill(255);
      triangle(torsoX, torsoY+charH/9,torsoX-charW/12, torsoY-2, torsoX+charW/12, torsoY-2); 
    }
  }
  //-------------------------------  MOVE ------------------------------------
  void move () {
    if (!dragging) {

      if (torsoY < charGround) {
        torsoY=int((torsoY+50)*.909);
      } 
      else {
        torsoY = charGround;
      }
    }
  }

  //-------------------------------  CLICKED ------------------------------------
  void clicked () {

    if (abs(mouseX - torsoX) < charH/2+rectCurveComp && abs(mouseY - torsoY) < charH/2) {

      dragging=true;

      offsetX = torsoX - mouseX;
      offsetY = torsoY - mouseY;
    }
  }

  //-------------------------------  ROLLOVER ------------------------------------

  void rollover () {

    if (abs(mouseX - torsoX) < charH/2+rectCurveComp && abs(mouseY - torsoY) < charH/2) {

      rollover = true;
    } 
    else {
      rollover = false;
    }
  }
  //-------------------------------  DRAG ------------------------------------
  void drag() {
    if (dragging) {
      rollover = true;
      torsoX = mouseX + offsetX;
      torsoY = mouseY + offsetY;
    }
  }


  //-------------------------------  STOP DRAGGING ------------------------------------
  void stopDragging() {
    dragging = false;
    rollover = false;
  }
  //--------------------------- INITIALIZE BLINKING ------------------------------------
  void blinkInit () {

    charBlink = int(random(1, 80));
  }
}

