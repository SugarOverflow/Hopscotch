import processing.serial.*;
import ddf.minim.*;

Minim minim;
AudioPlayer player;
Serial myPort;
int val = 6;

boolean gameStart = false;
boolean playerDetected = false;
boolean position = false;
boolean readingTest = false;

int maximumPlayerDetection = 200;
int randomSC = 0;
int currentRound = 1;

int blueCircle = 1;
int blueSquare = 2;
int redCircle = 3;
int redSquare = 4;
int orangeTriangle = 5;

int blueCircleValMin = 20;
int blueCircleValMax = 35;

int redCircleValMin = 37;
int redCircleValMax = 55;

int redSquareValMin = 64;
int redSquareValMax = 79;

int orangeTriangleValMin = 84;
int orangeTriangleValMax = 87;

int blueSquareValMin = 90;
int blueSquareValMax = 115;


AudioPlayer newgame;
AudioPlayer gameover;
AudioPlayer correct;
AudioPlayer bluesquare;
AudioPlayer redsquare;
AudioPlayer redcircle;
AudioPlayer orangetriangle;
AudioPlayer bluecircle;

void setup(){ 
  String portName = Serial.list()[0];
  myPort = new Serial(this,portName,9600); 
  minim = new Minim(this);
  newgame = minim.loadFile("newgame.mp3");
  gameover = minim.loadFile("game over.mp3");
  correct = minim.loadFile("correct.mp3");
  bluesquare = minim.loadFile("bluesquare.mp3");
  redsquare = minim.loadFile("redSquare.mp3");
  redcircle = minim.loadFile("redcircle.mp3");
  orangetriangle = minim.loadFile("orangeTriangle.mp3");
  bluecircle = minim.loadFile("bluecircle.mp3");
  
  
}

/* ******************************************8

You can test the game even without the range finder.
All you need to do is comment out the val = myPort.read() statements and just enter static data.

For example, if you want to test orange triangle (according to the values above)

1)Set int val = 30. 
2)Comment out the val = myPort.read() in both places (at the beginning of the code and in the checkPosition function)
3)Go into the randomShapecolor function and comment out randomSC = tempSC and uncomment the testing value and set it to 5(the value we gave orangeTriangle)

-You can do this with all of the shape/color combo's to test the audio and make sure it works properly. If you want to test the game over audio, just set int val to a different value than the testing value ranges


//***************************** */

void draw(){
  
//      while(readingTest == false){      
//        val = myPort.read();
//        println(val);
//        delay(100);
//        
//        if (keyPressed) {
//          if (key == 'z') {
//            readingTest = true;
//          }
//        }             
//      }
  
     val = myPort.read();
     println(val);
         
     if ((playerDetected()) && (gameStart == false)){
       gameStart = true;
       //INSERT AUDIO HERE ---> NEW GAME START************
       newgame.play();
       newgame.rewind();
       delay(2000);
       println("GAME WILL START IN 2 SECONDS");
     }
     
     if (gameStart){
       
        randomShapeColor();//gets a randomShapeColor
        announce(); //announces the randomSC (INSERT AUDIO IN THIS FUNCTION************)
        delayChecker();//delay depending on what round it is (can modify the delay I just set the default to start at 5sec then go down 1sec each round to 1sec)
        checkPosition();//checks if the position is correct or not
        
        if (position){
          ++currentRound;
          println("CURRENT ROUND: " + currentRound);
          //INSERT AUDIO HERE ----> CORRECT ANSWER ****************************** / Might need to put a delay or it may intertwine with the shape/color audio
          correct.play();
          correct.rewind();
          delay(1500);
        }
        else{
          println("GAME RESTART");
          //INSERT AUDIO HERE ---> ********************* GAME OVER (did not detect a person in the correct range or maybe didnt detect anyone at all(maybe they left)
          gameover.play();
          gameover.rewind();
          delay(3000);
          gameStart = false;
          playerDetected = false;
          currentRound = 1;
          readingTest = false;
        }        
     }     
     delay(100);    
}

void randomShapeColor(){
  int tempSC;
  
  do{
  tempSC = (int) random(0,5);//<<<<<<
  }
  while (tempSC == randomSC);
  
  if (tempSC < 1)
  {
    tempSC = 1;
  }
  
  randomSC = tempSC; 
     //randomSC = 1; //TESTINGGGGGGGGGGGGGGG VALUE
}//Function gets a random shape/color combo from the 5 choices


void announce(){ 
  switch(randomSC){
    case 1:
      println("blueCircle");
      //ANNOUNCE THE SHAPE AND COLOR FOR EACH CASE
      bluecircle.play();
      bluecircle.rewind();
      break;
    case 2:
      println("blueSquare");
      bluesquare.play();
      bluesquare.rewind();
      break; 
    case 3:
      println("redCircle");
      redcircle.play();
      redcircle.rewind();
      break;
    case 4:
      println("redSquare");
      redsquare.play();
      redsquare.rewind(); 
      break;   
    case 5:
      println("orangeTriangle");
      orangetriangle.play();
      orangetriangle.rewind();
      break;
  }  
}//Function annouces the shape/coloraa

void delayChecker(){  
  int delay = 6000 - (currentRound * 350);
  println("DELAY OF:" + delay);
  
  if (delay < 1000)
    delay(1000);
  else
    delay(delay);
}//Function changes the delay depending on the current round (to make the game harder)

void checkPosition(){
  position = false;
  
  myPort.clear();
  val = -1;
  
  while(val == -1){
    val = myPort.read();
    println("GOT A POSITION CHECK OF: " + val);
  }
  
  if (randomSC == blueCircle){
    if ((val > blueCircleValMin) && (val < blueCircleValMax))
      position = true;  
  }
  else if (randomSC == blueSquare){
    if ((val > blueSquareValMin) && (val < blueSquareValMax))
      position = true;    
  }
  else if (randomSC == redCircle){
    if ((val > redCircleValMin) && (val < redCircleValMax))
      position = true;    
  }
  else if (randomSC == redSquare){
    if ((val > redSquareValMin) && (val < redSquareValMax))
      position = true;     
  }
  else if (randomSC == orangeTriangle){
    if ((val > orangeTriangleValMin) && (val < orangeTriangleValMax))
      position = true;    
  }
}//Function compares the chosen shape/color for this round and compares it with the min and max distance for that shape/color. Returns true if its in the range, otherwise false

boolean playerDetected(){
  if ((val < maximumPlayerDetection) && (val > 0)){
    return true;
  }
  return false;  
}//If a player is detected (val > 0 mens that we are getting some kind of input), (val < max needs to be changed to the max range of the sensor)--> tells us we detect an object, return true otherwise false


