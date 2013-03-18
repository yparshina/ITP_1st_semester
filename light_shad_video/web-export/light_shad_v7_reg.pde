//image for filling in the back
PImage shadowImg, lightImg;

float [] shadR = new float[640*480];
float [] shadG = new float[640*480];
float [] shadB = new float[640*480];

float [] lightR = new float[640*480];
float [] lightG = new float[640*480];
float [] lightB = new float[640*480];

import processing.video.*;

Capture video;
//************************************* SETUP *********************************************
void setup() {
  size(640, 480);

  // load video
  video= new Capture(this, width, height);
  video.start();

  // load image for shadows
  shadowImg = loadImage(/*"shadowImg.png"*/"http://itp.nyu.edu/~yp541/icm/week7_wip/shadowImg.png");
  lightImg = loadImage(/*"lightImg2.png"*/"http://itp.nyu.edu/~yp541/icm/week7_wip/lightImg2.png");
  //background (255,0,255);
  
for (int x=0;x< video.width; x++) {
    for (int y=0;y< video.height; y++) {

      int thisPixel1 = (x+ y*width);
      color ColorFromShad = shadowImg.pixels[thisPixel1];
      color ColorFromLight = lightImg.pixels[thisPixel1];

      shadR [thisPixel1] = red(ColorFromShad);
      shadG [thisPixel1] = green(ColorFromShad);
      shadB [thisPixel1] = blue(ColorFromShad);
      
      lightR [thisPixel1] = red(ColorFromLight);
      lightG [thisPixel1] = green(ColorFromLight);
      lightB [thisPixel1] = blue(ColorFromLight);
    }
  }
  
  
}
//************************************* DRAW *********************************************
void draw() {

  //_________________________________ STUFF FOR THE SHADOWS _____________________________    


// When placed in the Draw loop, the graphic "fights" with the video 
//flashing in front of it every few frames. I temporarily moved the 
//graphic and the arrays into Setup, since I am currently using a static
//image that doesn't need updating every frame. I am hoping to find a 
//solution for using video or moving graphics in the future. 

  //_________________________________VIDEO & CHANGE PIXELS ________________________________     
  if (video.available ()) {
    video.read();
    video.loadPixels();
    loadPixels();

    for (int x=0;x< video.width; x++) {
      for (int y=0;y< video.height; y++) {

        //find a pixel in the array
        int thisPixel2 = (x+ y*video.width);

        //get color info
        color ColorFromVid = video.pixels[thisPixel2];

        float pixelR= red(ColorFromVid);
        float pixelG= green(ColorFromVid);
        float pixelB= blue(ColorFromVid);

        float luma = map(((pixelR+pixelG+pixelB)/3), 0, 255, 0, 1);

        // change colors
        //if (luma < .2) {
        pixelR = (shadR[thisPixel2] * (1-luma)) + (lightR[thisPixel2] * luma);
        pixelG = (shadG[thisPixel2] * (1-luma)) + (lightG[thisPixel2] * luma);
        pixelB = (shadB[thisPixel2] * (1-luma)) + (lightB[thisPixel2] * luma);
       //}

        // put new colors into pixels
        color newColor= color(pixelR, pixelG, pixelB);
        pixels[thisPixel2]= newColor;
      }
    }

    updatePixels();
  }
}


