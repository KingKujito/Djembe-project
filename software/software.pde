import processing.sound.*;

AudioIn input;
Amplitude rms;

SawOsc sine;

PImage img;
int imgx; int imgy;
float cof;
int scale=1;
int Timer;
int score;
int TimeFrame = 10;


int djembe; //geeft aan welke djembe de drum begon
boolean press;

void setup() {
  img = loadImage("cda.jpg");
  imgx = img.width; imgy = img.height;
  cof = imgy/imgx;
    Timer = TimeFrame;
    size(640,360);
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


void draw() {
    runGame();
}


void renderGraphic () {
  fill(0);
  stroke(0);
  strokeWeight(5);
  
  line(30, 0, 30, score/10 + 30);
  ellipse(30,score/10 + 30, 20, 20);
  
}


void runGame () {
  background(255);
   //metronome(60);
   gameLogic();
   tint(255, 50);
  image(img, 0, -score*0.5f, width, cof*width);
   renderGraphic();
    
    // adjust the volume of the audio input
    input.amp(map(mouseY, 0, height, 0.0, 1.0));
    
    // rms.analyze() return a value between 0 and 1. To adjust
    // the scaling and mapping of an ellipse we scale from 0 to 0.5
    scale=int(map(rms.analyze(), 0, 0.5, 1, 350));
    noStroke();
    
    fill(255,0,20);
    // We draw an ellispe coupled to the audio analysis
    textSize(30);
    text(score, width/2, 50);
    rectMode(CENTER);
    rect(width/2, height, height/10, 2*scale);
}

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

void gameLogic () {
  
  if(Timer <= 1) {
    sine.play();
  } else if (Timer >= TimeFrame - 5) {
    sine.stop();
  }
  
  if (Timer < TimeFrame) {
      background(200,255,200);
  }
  
  if (scale > 100 && Timer >= TimeFrame-3 || keyPressed && key == 'm' && !press && Timer >= TimeFrame-3 ) {
      Timer = 0;
      if (scale > 100) {
      djembe = 1;
      } else if (keyPressed && key == 'm' && !press) {
      djembe = 2;
      }
    }
    
  if(Timer < TimeFrame) {
   Timer++;
   
   if (scale > 100 || keyPressed && key == 'm') {
     if (scale > 100 && djembe != 1) {
       score += TimeFrame - Timer - 3;
     } if (keyPressed && key == 'm' && djembe != 2) {
       score += TimeFrame - Timer - 3;
     }
      
    }
  }
  
    if (keyPressed && key == 'm') {
      press = true;
    } else {
      press = false;
    }
  
}