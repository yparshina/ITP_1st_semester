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

