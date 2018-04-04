//---------------------------------------LIBRARIES-------------------------------------------//
import processing.sound.*;

//---------------------------------------AUDIO VARS-------------------------------------------//
//AudioIn input;
//Amplitude rms;//

SawOsc sine;

//---------------------------------------VARS-------------------------------------------//
PImage img, img2;
PImage char11,char12,char21,char22,char31,char32;
int imgx, imgx2; int imgy, imgy2;
float cof, cof2;
//int scale=1;
int Timer;
public int score, progress, highscore;
int maxProgress = 500;
int TimeFrame = 100;


public boolean playingGame = false;


int djembe; //geeft aan welke djembe de drum begon
boolean press;
public float TimePass;

//---------------------------------------SETUP-------------------------------------------//
void setupSecondSketch () {
  String[] args = {"spel"};
  SecondApplet sa = new SecondApplet();
  PApplet.runSketch(args, sa);
}

void setup() {
  frameRate(50);
  setupSecondSketch();
  FFTsetup();
  surface.setResizable(true);
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
    //input = new AudioIn(this, 0);
    
    // start the Audio Input
    //input.start();
    
    // create a new Amplitude analyzer
    //rms = new Amplitude(this);
    
    // Patch the input to an volume analyzer
    //rms.input(input);
}      


//---------------------------------------DRAW-------------------------------------------//
void draw() {
  
  if(score > highscore) {
    highscore = score;
  }
  
  if (playingGame) {
  TimePass += 0.1f;
    runGame();
  } else {
   TimePass = 0; 
   RenderMenu();
  }
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
  if(b < 60) {
  image(char11, width/2 - width/9, height/2.5f + sin(TimePass) * 10 + 20, 225*1.5, 250*1.5);
  image(char21, width/2 + width/4 - width/9, height/2.5f + sin(TimePass) * 10 + 20, 225*1.5, 250*1.5);
  image(char31, width/2 - width/4 - width/9, height/2.5f + sin(TimePass) * 10 + 20, 225*1.5, 250*1.5);
  } else {
    image(char12, width/2 - width/9, height/2.5f + sin(TimePass) * 10 + 20, 225*1.5, 250*1.5);
    image(char22, width/2 + width/4 - width/9, height/2.5f + sin(TimePass) * 10 + 20, 225*1.5, 250*1.5);
    image(char32, width/2 - width/4 - width/9, height/2.5f + sin(TimePass) * 10 + 20, 225*1.5, 250*1.5);
  }
}

//---------------------------------------RENDER GAME-------------------------------------------//

void RenderMenu() {
  background(0);
  FFTdraw();
  
  noStroke();
  fill(0,200);
  rect(0,0,displayWidth,displayHeight);
  
  fill(255);
  textSize(50);
  textAlign(CENTER);
  
  text("Sla de djembé om te beginnen! \nMaak zoveel mogelijk herrie in een \nkwart minuut om de score te verbeteren! \nMeer mensen betekent meer herrie! \nMaak vrienden en maak herrie!", width/2, height/6);
  text("Score : " + score + "\nHighscore : " + highscore, width/2, height*0.75f);
  
  //LOGIC
  if(b > 650) {
    score = 0;
    playingGame = true;
  }
}

void runGame () {
  background(255);
   //metronome(60);
  // tint(255, 50);
  //image(img, 0, -score*0.5f, width, cof*width);
  tint(255, 255);
  image(img2, -20, sin(TimePass) * 10 - 20, width*1.1f, height*1.1f);
  gameLogic();
  FFTdraw();
  renderWave();
  renderChar();
  // renderGraphic();
    
    // adjust the volume of the audio input
    //input.amp(map(mouseY, 0, height, 0.0, 1.0));
    
    // rms.analyze() return a value between 0 and 1. To adjust
    // the scaling and mapping of an ellipse we scale from 0 to 0.5
    //scale=int(map(rms.analyze(), 0, 0.5, 1, 350));
    noStroke();
    
    fill(255, 200);
    // We draw an ellispe coupled to the audio analysis
    textSize(45);
    text(score, width/2, 50);
    text(TimePass, width/4, 50);
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
  if(TimePass > 15) {
    playingGame = false;
  }
  
  if(b > 60) {
    score+= b/10;
  }
  /*println(Timer);
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
  }*/
  
}






// --------------------------FFT---------------------------------//
AudioIn input;
Amplitude rms;
SoundFile sample;
FFT fft;
AudioDevice device;
int b;
int h;

//BG colors
color bg = color (0,0);
color spctrm = color(255,20);
color txt = color(255);
color temp;

// Declare a scaling factor
int scale=5;

// Define how many FFT bands we want
int bands = 128;

// declare a drawing variable for calculating rect width
float r_width;

// Create a smoothing vector
float[] sum = new float[bands];

// Create a smoothing factor
float smooth_factor = 0.2;

public void FFTsetup() {
  input = new AudioIn(this, 0);
    
    // start the Audio Input
    input.start();
    rms = new Amplitude(this);
    rms.input(input);
    
  //size(640, 360);
  //background(bg);
  
  // If the Buffersize is larger than the FFT Size, the FFT will fail
  // so we set Buffersize equal to bands
  device = new AudioDevice(this, 44000, bands);
  
  // Calculate the width of the rects depending on how many bands we have
  
  
  //Load and play a soundfile and loop it. This has to be called 
  // before the FFT is created.
  //sample = new SoundFile(this, "beat.aiff");
  //sample.loop();

  // Create and patch the FFT analyzer
  fft = new FFT(this, bands);
  fft.input(input);
  //surface.setResizable(true);
}      

public void FFTdraw() {
  r_width = width*6/float(bands);
  // Set background color, noStroke and fill color
  //background(125,255,125);
  switch(key) {
    case '1':  spctrm = color(255,0,0,10);
    break;
    case '2':  spctrm = color(0,255,0,10);
    break;
    case '3':  spctrm = color(0,0,255,10);
    break;
    default:  spctrm = txt;
    break;
  }
  fill(spctrm);
  noStroke();

  fft.analyze();

  for (int i = 0; i < 30; i++) {
    
    // smooth the FFT data by smoothing factor
    sum[i] += (fft.spectrum[i] - sum[i]) * smooth_factor;
    
    // draw the rects with a scale factor
    rect( i*r_width, height, r_width, -sum[i]*scale * 1400);
  }
  
  for (int i = 0; i < 20; i++) {
    fill(0, 3);
    noStroke();
    rect(25, height-10*i*scale + 5, 25, -20);
  fill(txt);
    strokeWeight(1);
    stroke(txt);
    text(i*10*scale, 30, height-10*i*scale);
    line(0, height-10*i*scale, width, height-10*i*scale);
  }
  
  
  fill(0, 10);
  noStroke();
  rect(width, height, -35, -height);
  
  
  b = 0;
  for (int i = 0; i < 13; i++) {
    
    // smooth the FFT data by smoothing factor
    sum[i] += (fft.spectrum[i] - sum[i]) * smooth_factor;
    
    // draw the rects with a scale factor
    b += sum[i]*scale * 800;
  }
  b = b/13;
  
  if(b>h) {
  h=b;
  }
  if(b > 60) {
    temp = color(0,255,0);
    fill(temp);
    rect(width, height, -35, -height/8);
  }
  if(b > 100) {
    temp = color(32,223,0);
    fill(temp);
    rect(width, height/8*7, -35, -height/8);
  }
  if(b > 140) {
    temp = color(64,191,0);
    fill(temp);
    rect(width, height/8*6, -35, -height/8);
  }
  if(b > 180) {
    temp = color(96,159,0);
    fill(temp);
    rect(width, height/8*5, -35, -height/8);
  }
  if(b > 220) {
    temp = color(128,127,0);
    fill(temp);
    rect(width, height/8*4, -35, -height/8);
  }
  if(b > 260) {
    temp = color(160,95,0);
    fill(temp);
    rect(width, height/8*3, -35, -height/8);
  }
  if(b > 300) {
    temp = color(192,63,0);
    fill(temp);
    rect(width, height/8*2, -35, -height/8);
  }
  if(b > 340) {
    temp = color(224,31,0);
    fill(temp);
    rect(width, height/8, -35, -height/8);
  }
  fill(temp);
   text(h,width-25,50);
  
  //fill(0);
  //noStroke();
  //rect(width, height, -35, -height);
  //fill(255);
  //input.amp(map(mouseY, 0, height, 0.0, 1.0));
  //  rect(width, height, -35, -height * int(rms.analyze()*1000) );
}
// --------------------------FFT---------------------------------//




public class SecondApplet extends PApplet {
 PImage sky;
 int o = 0;
  public void settings() {
    size(displayWidth,displayHeight);
    //surface.setResizable(true);
  }
  public void draw() {
    if (o < 1) {
     sky = loadImage("/Users/cameron/Documents/school/CLE3/spel/data/sky.jpg"); o = 1; 
    }
    image(sky, -20,-20, width*1.1f, height*1.1f);
    //fill(0);
    //ellipse(100, 50, 10, 10);
    
    
    if (playingGame) {
      fill(0,70);
  rect(0,0,width,height);
  
  if(TimePass < 10) {
    fill(255);
  } else {
    fill(255,0,0);
  }
  textSize(100);
  textAlign(CENTER);
  text("MAAK HERRIE!!!", width/2, height/4);
  int g = int(TimePass);
  text("Tijd : " + g, width/2, height/2);
  } else {
        noStroke();
  fill(0,200);
  rect(0,0,width,height);
  
  fill(255);
  textSize(50);
  textAlign(CENTER);
  
  text("Sla de djembé om te beginnen! \nMaak zoveel mogelijk herrie in een \nkwart minuut om de score te verbeteren! \nMeer mensen betekent meer herrie! \nMaak vrienden en maak herrie! \n(Je mag schreeuwen en stampen)", width/2, height/6);
  text("Score : " + score + "\nHighscore : " + highscore, width/2, height*0.75f);
  }
  }
}