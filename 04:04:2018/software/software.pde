//---------------------------------------LIBRARIES-------------------------------------------//
import processing.sound.*;

//---------------------------------------AUDIO VARS-------------------------------------------//
AudioIn input;
Amplitude rms;

SawOsc sine;

//---------------------------------------VARS-------------------------------------------//
PImage img, img2;
PImage char11,char12,char21,char22,char31,char32;
int imgx, imgx2; int imgy, imgy2;
float cof, cof2;
int scale=1;
int Timer;
int score, progress;
int maxProgress = 500;
int TimeFrame = 100;


int djembe; //geeft aan welke djembe de drum begon
boolean press;
float TimePass;

//---------------------------------------SETUP-------------------------------------------//
void setup() {
  img = loadImage("cda.jpg");
  img2 = loadImage("bg.png");
  imgx = img.width; imgy = img.height;
  cof = imgy/imgx;
  //imgx2 = img2.width; imgy2 = img2.height;
  //cof2 = imgy2/imgx2;
  
  char11 = loadImage("char1_1.png"); char12 = loadImage("char1_2.png");
  char21 = loadImage("char2_1.png"); char22 = loadImage("char2_2.png");
  char31 = loadImage("char3_1.png"); char32 = loadImage("char3_2.png");
  
    Timer = TimeFrame;
    //size(640,360);
    size(1280,720);
    background(255);
    
    sine = new SawOsc(this);
    sine.amp(1);
    sine.freq(400);
    //Create an Audio input and grab the 1st channel
    input = new AudioIn(this, 0);
    
    // start the Audio Input
    input.start();
    
    // create a new Amplitude analyzer
    rms = new Amplitude(this);
    
    // Patch the input to an volume analyzer
    rms.input(input);
}      


//---------------------------------------DRAW-------------------------------------------//
void draw() {
  TimePass += 0.025f;
    runGame();
}


//---------------------------------------CUSTOM VOIDS-------------------------------------------//
//---------------------------------------RENDERING-------------------------------------------//
void renderGraphic () {
  fill(0);
  stroke(0);
  strokeWeight(5);
  
  line(30, 0, 30, score/10 + 30);
  ellipse(30,score/10 + 30, 20, 20);
  
}


void renderWave () {
  pushStyle();
  fill(135, 235, 255, 100);
  //stroke(84, 149, 255);
  //strokeWeight(5);
  int o = 30;
  for(int i = 0; i <= o; i++) {
    float u = sin((sin(TimePass/1 + i) * 4 - 50)/3.5f) * height/30;
    float u2 = sin((sin(TimePass/1 + (i+1)) * 4 - 50)/3.5f) * height/30;
    float u3 = sin(TimePass) * 10 + height/10;
    //line(width/o*i, height*0.75f-u +u3, width/o*(i+1), height*0.75f-u2 +u3);
    noStroke();
    beginShape();
vertex(width/o*i, height*0.75f-u +u3);
vertex(width/o*i, height);
vertex(width/o*(i+1), height);
vertex(width/o*(i+1), height*0.75f-u2 +u3);
endShape();
  }
  popStyle();
  
}

void renderChar () {
  if(scale < 100) {
  image(char11, width/2, height/2 + sin(TimePass) * 10 + 20, 225, 250);
  } else {
    image(char12, width/2, height/2 + sin(TimePass) * 10 + 20, 225, 250);
  }
}

//---------------------------------------RENDER GAME-------------------------------------------//
void runGame () {
  background(255);
   //metronome(60);
  // tint(255, 50);
  //image(img, 0, -score*0.5f, width, cof*width);
  tint(255, 255);
  image(img2, -20, sin(TimePass) * 10 - 20, width*1.1f, height*1.1f);
  gameLogic();
  renderWave();
  renderChar();
   renderGraphic();
    
    // adjust the volume of the audio input
    //input.amp(map(mouseY, 0, height, 0.0, 1.0));
    
    // rms.analyze() return a value between 0 and 1. To adjust
    // the scaling and mapping of an ellipse we scale from 0 to 0.5
    scale=int(map(rms.analyze(), 0, 0.5, 1, 350));
    noStroke();
    
    fill(255,0,20, 100);
    // We draw an ellispe coupled to the audio analysis
    textSize(30);
    text(score, width/2, 50);
    text(progress, width/4, 50);
    rectMode(CENTER);
    rect(width/2, height, height/20, 2*scale);
}

//---------------------------------------METRONOME-------------------------------------------//
void metronome (int x) {
  Timer++;
  
  if(Timer == x-10) {
    sine.play();
  }
  
  if (Timer > x) {
   Timer = 0;
   sine.stop();
  } else if (Timer >= x-12) {
    if (Timer >= x-10) {
      background(200,255,200);
    }
    if (scale > 100) {
      score++;
    }
  } else if (scale > 100 && Timer < x-16) {
      score--;
    }
}

//---------------------------------------LOGIC-------------------------------------------//
void gameLogic () {
  println(Timer);
  boolean resetTimer = false;
  sine.stop();
  
  if(Timer <= 1) {
    sine.play();
  } else if (Timer >= 5) {
    sine.stop();
  }
  
  if (Timer < 10) {
      fill(100,255,100, 20);
      noStroke();
      rect(width/2,height/2,width,height);
  }
  
  if (scale > 100 || keyPressed && key == 'm' && !press) {
     if (scale > 100 && djembe != 1) {
       progress++;
       score += (TimeFrame - Timer)/4 + 10;
     } if (keyPressed && key == 'm' && djembe != 2) {
       progress++;
       score += (TimeFrame - Timer)/4 + 10;
     }
      
    }
  
  
  if (scale > 100 || keyPressed && key == 'm' && !press) {
    sine.stop();
      if (scale > 100) {
      djembe = 1;
      } else if (keyPressed && key == 'm' && !press) {
      djembe = 2;
      }
      progress++;
      resetTimer = true;
    }
    
  if(Timer < TimeFrame) {
   Timer++;
  }
  
    if (keyPressed && key == 'm') {
      press = true;
    } else {
      press = false;
    }
    
  if(resetTimer) {
    Timer = 0;
  }
  
}