// This sketch shows how to use the FFT class to analyze a stream  
// of sound. Change the variable bands to get more or less 
// spectral bands to work with. Smooth_factor determines how
// much the signal will be smoothed on a scale form 0-1.

import processing.sound.*;

// Declare the processing sound variables 
AudioIn input;
Amplitude rms;
SoundFile sample;
FFT fft;
AudioDevice device;
int b;
int h;

//BG colors
color bg = color (0);
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

public void setup() {
  input = new AudioIn(this, 0);
    
    // start the Audio Input
    input.start();
    rms = new Amplitude(this);
    rms.input(input);
    
  size(640, 360);
  background(bg);
  
  // If the Buffersize is larger than the FFT Size, the FFT will fail
  // so we set Buffersize equal to bands
  device = new AudioDevice(this, 44000, bands);
  
  // Calculate the width of the rects depending on how many bands we have
  r_width = width/float(bands);
  
  //Load and play a soundfile and loop it. This has to be called 
  // before the FFT is created.
  //sample = new SoundFile(this, "beat.aiff");
  //sample.loop();

  // Create and patch the FFT analyzer
  fft = new FFT(this, bands);
  fft.input(input);
  surface.setResizable(true);
}      

public void draw() {
  // Set background color, noStroke and fill color
  //background(125,255,125);
  switch(key) {
    case '1':  spctrm = color(255,0,0,10);
    break;
    case '2':  spctrm = color(0,255,0,10);
    break;
    case '3':  spctrm = color(0,0,255,10);
    break;
    default:  background(0); spctrm = txt;
    break;
  }
  fill(spctrm);
  noStroke();

  fft.analyze();

  for (int i = 0; i < bands; i++) {
    
    // smooth the FFT data by smoothing factor
    sum[i] += (fft.spectrum[i] - sum[i]) * smooth_factor;
    
    // draw the rects with a scale factor
    rect( i*r_width, height, r_width, -sum[i]*scale * 800);
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