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
