//************************ VARS****************************

//--------------------- vars: CHARACTERS -----------------------------
ArrayList creatures;

int charType=0;

boolean grab = false;



//--------------------- vars: BUTTONS -----------------------------

button buttonDeer, buttonBird;

  boolean deerClicked = false;
  boolean newChar = false;

//--------------------- vars: STAGE -----------------------------
int scaleStage = 2;
int stageW = 1920/scaleStage;
int stageH = 1080/scaleStage; 
int shelf = 300/scaleStage;

//--------------------- vars: TEXTURES -----------------------------

// texture images
PImage darkImg, lightImg, rolloverImg;

// texture arrays
float [] darkR = new float[stageW*(stageH+shelf)];
float [] darkG = new float[stageW*(stageH+shelf)];
float [] darkB = new float[stageW*(stageH+shelf)];

float [] lightR = new float[stageW*(stageH+shelf)];
float [] lightG = new float[stageW*(stageH+shelf)];
float [] lightB = new float[stageW*(stageH+shelf)];

float [] rolloverR = new float[stageW*(stageH+shelf)];
float [] rolloverG = new float[stageW*(stageH+shelf)];
float [] rolloverB = new float[stageW*(stageH+shelf)];



//****************************** SETUP ******************************************
void setup () {
  noSmooth();
  size(960, 690);

  frameRate(30);

  rectMode(CENTER);

  mouseX = stageW/2;
  mouseY = stageH/2;

  //--------------------- setup: CHARACTERS ----------------------------
  
  creatures = new ArrayList();
  creatures.add(new character(charType)); 

  //--------------------- setup: CHARACTERS ----------------------------
 
  buttonDeer = new button (width/2-150, 1);
  buttonBird = new button (width/2+150, 2);


  //--------------------- setup: TEXTURES ------------------------------
  // LOAD TEXTURE IMAGES
  if (scaleStage == 3) {
    darkImg = loadImage("dark_3x.png");
    lightImg = loadImage("light_3x.png");
    rolloverImg = loadImage("rollover_3x.png");
  }

  if (scaleStage == 2) {
    darkImg = loadImage("dark_2x.png");
    lightImg = loadImage("light_2x.png");
    rolloverImg = loadImage("rollover_2x.png");
  }

  // POPULATE TEXTURE ARRAYS
  for (int x=0;x< width; x++) {
    for (int y=0;y< height; y++) {

      int thisPixel1 = (x+ y*width);

      color ColorFromDark = darkImg.pixels[thisPixel1];
      color ColorFromLight = lightImg.pixels[thisPixel1];
      color ColorFromRollover = rolloverImg.pixels[thisPixel1];

      darkR [thisPixel1] = red(ColorFromDark);
      darkG [thisPixel1] = green(ColorFromDark);
      darkB [thisPixel1] = blue(ColorFromDark);

      lightR [thisPixel1] = red(ColorFromLight);
      lightG [thisPixel1] = green(ColorFromLight);
      lightB [thisPixel1] = blue(ColorFromLight);

      rolloverR [thisPixel1] = red(ColorFromRollover);
      rolloverG [thisPixel1] = green(ColorFromRollover);
      rolloverB [thisPixel1] = blue(ColorFromRollover);
    }
  }
}



//************************ DRAW ****************************
void draw () {
  background(255);

  //--------------------- draw: CHARACTERS -----------------------------
  for (int i = creatures.size()-1; i > 0; i--) { 
    character Char = (character) creatures.get(i);
    Char.rollover();
    Char.drag();
    Char.move();
    Char.blinkInit();
    Char.display();
  }  


  //--------------------- draw: SHELF -----------------------------

  noStroke();
  fill(0);
  rect(stageW/2, stageH+shelf/2, stageW, shelf);

  //--------------------- draw: BUTTONS -----------------------------

buttonDeer.display();
buttonBird.display();
buttonDeer.rollover();
buttonBird.rollover();
  //------------------- draw: TEXTURES -----------------------------

  // in order to process the pixels from the graphics above, they must be loaded first
  loadPixels();


  for (int x=0; x< width; x++) {
    for (int y=0;y< height; y++) {

      //find a pixel in the array
      int thisPixel2 = (x+ y*width);

      //get color info
      color ColorFromStage = pixels[thisPixel2];

      float pixelR= red(ColorFromStage);
      float pixelG= green(ColorFromStage);
      float pixelB= blue(ColorFromStage);


      if (pixelR ==0 && pixelG ==0  && pixelB ==0 ) {
        // change colors
        pixelR = darkR [thisPixel2];
        pixelG = darkG [thisPixel2];
        pixelB = darkB [thisPixel2];
      }
      if (pixelR == 255 && pixelG == 255 && pixelB == 255) {
        // change colors
        pixelR = lightR [thisPixel2];
        pixelG = lightG [thisPixel2];
        pixelB = lightB [thisPixel2];
      }
      if (pixelR == 255 && pixelG == 0 && pixelB == 0) {
        // change colors
        pixelR = rolloverR [thisPixel2];
        pixelG = rolloverG [thisPixel2];
        pixelB = rolloverB [thisPixel2];
      }

      // put new colors into pixels
      color newColor= color(pixelR, pixelG, pixelB);
      pixels[thisPixel2]= newColor;
    }
  }

  updatePixels();
}

void mousePressed () {

  for (int i = creatures.size()-1; i > 0; i--) { 
    character Char = (character) creatures.get(i);
    Char.clicked();
  }

buttonDeer.clicked();
//newChar = buttonDeer.makeChar;

if (buttonDeer.makeChar) {
     charType = 1;
    // A new character is added to the ArrayList, by default to the end.
    creatures.add(new character(charType));
  }
 
 buttonBird.clicked(); 

if (buttonBird.makeChar) {
     charType = 2;
    // A new character is added to the ArrayList, by default to the end.
    creatures.add(new character(charType));
  }
  
}

void mouseReleased () {
  newChar = false;
  
  for (int i = creatures.size()-1; i > 0; i--) { 
    character Char = (character) creatures.get(i);
    Char.stopDragging();
  }

buttonDeer.released();
buttonBird.released();
println(newChar);
}
// BUTTON TYPES:
// 1 = deer
// 2 = bird
// 101 = trees
// 201 = rain

class button {
  int posX, posY, buttSize, buttColor, type;
  boolean makeChar, rollover;
  PShape thumbDeer, thumbBird;

  //---------------------------------- CONSTRUCTOR ------------------------------------ 

  button(int passPosX, int passType) {
    
    buttColor = 255;
    buttSize = 110;
    posX = passPosX;
    posY = stageH + shelf/2;
    type = passType;
    makeChar = false;
    
    thumbDeer = loadShape ("thumbDeer.svg");
    thumbBird = loadShape ("thumbBird.svg");
  }
  //---------------------------------- ROLLOVER ------------------------------------ 

  void rollover () {
    if (dist(mouseX, mouseY, posX, posY) < buttSize/2) {
      rollover = true;
    } 
    else {
      rollover = false;
    }
  }
  //---------------------------------- CLICKED ------------------------------------ 

  boolean clicked () {
    if (rollover) {
      makeChar = true; 
  } else {
    makeChar = false;
  }
  return (makeChar);

  }
  
  //---------------------------------- CHAR SELECTION ------------------------------------ 
  int charType () {

    return (type);
  }
  
  
  //------------------------------- RELEASED ------------------------------------ 

  void released () {

    makeChar = false;
  }


  //-------------------------------  DISPLAY ------------------------------------ 
  void display() {



        if (rollover) {
        fill(255, 0, 0);
      } 
      else {
        fill (255);
      }
    ellipse (posX, posY, buttSize, buttSize);
    
        if (type == 1) {
      shape(thumbDeer, posX-45, posY-45);
      }

    if (type ==2 ) {
         shape(thumbBird, posX-45, posY-45); 
      
    }
  }
}


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

class eye {
  boolean blink = false;
  int initBlink, blinkCount;

  int eyeX, eyeY, eyeOffsetX, eyeOffsetY, eyeSize;

  eye(int torsoX, int torsoY, int offsetX, int offsetY, int Size) {

    eyeOffsetX = offsetX;
    eyeOffsetY = offsetY;
    eyeX = torsoX + eyeOffsetX;
    eyeY = torsoY + eyeOffsetY;
    eyeSize = Size;
  }
  void blink(int passCharBlink) {


    if (passCharBlink == 1 && blinkCount == 0) {

      blink = true;
    }

    if (blinkCount > 3) {
      blink = false;
      blinkCount = 0;
    }
  } 


  void display(int torsoX, int torsoY) {

    eyeX = torsoX + eyeOffsetX;
    eyeY = torsoY + eyeOffsetY;

    noStroke();
    fill(255); 

    if (blink == true) {

      rect(eyeX, eyeY, eyeSize, 2, 10);
      blinkCount++;
    } 
    else {
      ellipse(eyeX, eyeY, eyeSize, eyeSize);
      blinkCount = 0;
    }
  }

}
//******************************* LEG *****************************************

class leg {
  //----------------------------- LEG VARS ------------------------------

  float legTopX, legTopY, ankleX, ankleY, toeX, toeY;
  float displaceX, displaceY;
  float legLength, toeLength;
  int legR = 0;

  //----------------------------- LEG CONSTRUCTOR -----------------------
  leg (int mX, int mY, int passDispX, int passDispY, int passLegLength, int passToeLength) {

    displaceX = passDispX;
    displaceY = passDispY;

    legLength = passLegLength;
    toeLength = passToeLength;

    legTopX = mX + displaceX;
    legTopY = mY+ displaceY;

    ankleX = legTopX;
    ankleY = legTopY + legLength;

    toeX = ankleX;
    toeY = ankleY+toeLength;
  }

  //----------------------------- DRAW LEG ------------------------------ 
  void makeLeg (int mX, int mY, boolean rollover) {

    legTopX = mX + displaceX;

    legTopY = mY+ displaceY;

    // DANGLE LEG

    if (abs(legTopX - ankleX) > 1) { 
      ankleX = int(ankleX + (legTopX - ankleX) * .5);
    } 
    else {
      ankleX = legTopX;
    }

    if (abs(legTopY - ankleY) > .1) { 
      ankleY = int(ankleY + ((legTopY+legLength) - ankleY) * .9);
    }

    // DANGLE TOES

    if (abs(ankleX - toeX) > 1) { 
      toeX = int(toeX + (ankleX - toeX) * .5);
    }

    if (abs(ankleY - toeY) > .1) { 
      toeY = int(toeY + ((ankleY+toeLength) - toeY) * .9);
    }

    // DRAW LEG
    if (rollover) {
      legR = 255;
    } 
    else {
      legR = 0;
    }

    stroke(legR, 0, 0);

    line (legTopX, legTopY, ankleX, ankleY);

    // DRAW TOES
    noStroke();
    fill(legR, 0, 0);
    ellipse(ankleX, ankleY+toeLength/2, toeLength, toeLength);

    // old: three toes
    /*
    stroke(50);
     strokeWeight(2);
     line (ankleX, ankleY, toeX, toeY);  // toe center   
     line (ankleX, ankleY, toeX-5, toeY-2); // toe right
     line (ankleX, ankleY, toeX+5, toeY-2);  // toe left
     */
  }
}



