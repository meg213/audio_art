import ddf.minim.*;
import ddf.minim.ugens.*;
import ddf.minim.spi.*; 
import ddf.minim.analysis.*;

Minim minim;

// for recording
AudioInput in;
AudioRecorder recorder;
AudioPlayer test;
boolean recorded;
boolean done = false;

// for playing back
AudioOutput out;
FilePlayer player;
FilePlayer recording;

//for visuals
int spacing = 10;
int border = spacing*2;
int amplification = 6;
//int y = spacing;
float ySteps;
float lastx;
float lasty;
float x;
float y;
int length;

void setup(){
  size(800, 800, P3D);
  background(255);
  strokeWeight(1);
  stroke(0);
  noFill();

  minim = new Minim(this);
  
  //Step 1: record audio from user
  recordSound();
}
int draw = -50;
int timesThrough = 0;
int flipped = 0;
void draw(){
  
  fill(0);
  text("To reset, press R", 10, 15);
  
  //show the user that it is recording
    for(int i = 0; i < in.left.size() - 1; i++) {
      float freqMix = in.mix.get(int(i));
      float freqLeft = in.left.get(int(i)) ;
      float freqRight = in.right.get(int(i));
      float amplitude = in.mix.level();
    
      float red = map(freqLeft, -1, 1,0, 200);
      float green = map(freqRight, -1, 1, 0, 215);
      float blue = map(freqMix, -1, 1, 0, 55);
      float opacity = map(amplitude, 0, 0.4, 20, 100);

      stroke(red + abs(amplitude * 10) , green + abs(freqMix * 100), blue + 100);
    
    stroke(red + abs(amplitude * 1000) , green + abs(freqMix * 1000), blue + abs(freqRight * 1000));
    if (i == 0){
      timesThrough++;
      if (timesThrough % 40 == 0){
        draw = (int)random(0, 800);
        int random = (int) random(3);
        if (random == 1){
          flipped = 1;
        } else if (random == 2){
          flipped = 2;
        }  else {
          flipped = 0;
        }
        if (draw == 800){
          draw = 0;
        }
      }
    }
    if (flipped == 1){
    line(i, draw + (int)red + in.right.get(i)*100, i+1, draw + (int)red + in.right.get(i+1)*100);
    }
    if (flipped == 2){
    line(draw + (int)red + in.right.get(i)*50, i, draw + (int)red + in.right.get(i+1)*5, i+1);
    } else {
      line(i, (int)blue + in.left.get(i)*50, i + 1, (int)blue + in.left.get(i+1)*50);
    }
    System.out.println(freqMix * 10000);
    int randomX = (int)random((int) abs(amplitude * 1000) + random(800));
    int rand = (int) random(800) + (int)amplitude;
    int rand2 = (int) random(800) + (int)freqMix * 100;
    float size = freqMix * spacing * amplification;
    fill(rand + red, rand2 + green ,rand2 + blue); 
    if ((amplitude * 10 > 1)){
      ellipse( randomX - freqMix * 10000, rand2 + abs(freqMix * 10000) + abs(amplitude * 1000) , size * 20, size * 20);
    }
    strokeWeight(amplitude * 5);
    if (amplitude > 0.3){
    noStroke();
    fill(red, green, blue, opacity);
    pushMatrix();
    translate(rand+border, rand2+border * freqMix);
    int circleResolution = (int)map(amplitude, 0.3, 0.45, 3, 5);// num verticies
    float radius = size/4;
    float angle = TWO_PI/circleResolution;
    beginShape();
    for (int j = 0; j <= circleResolution; j++){
      float xShape = 0 + cos(angle*j) * radius;
      float yShape = 0 + sin(angle*j) * radius;
      vertex(xShape, yShape);
    }
    endShape();
    popMatrix();
  }
  }
}

void keyReleased(){
  if ( key == 'r'){
    background(255);
  }
}

void recordSound(){
  in = minim.getLineIn(Minim.STEREO, 2048);
  
  // create an AudioRecorder that will record from in to the filename specified.
  // the file will be located in the sketch's main folder.
  recorder = minim.createRecorder(in, "myrecording.wav");
  
  // get an output 
  out = minim.getLineOut( Minim.STEREO );
  
 // textFont(createFont("Arial", 12));
} 
 
void stop(){
  test.close();
  minim.stop();
  super.stop();
}
