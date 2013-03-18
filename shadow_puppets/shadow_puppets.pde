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
