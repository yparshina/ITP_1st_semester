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


