//Import OpenCV for Processing Library, Processing.video for webcam access and java.awt
import gab.opencv.*;
import processing.video.*;
import java.awt.*;

//Import Processing.Sound
import processing.sound.*;

//Initialize Webcams and OpenCV models
Capture video;
OpenCV opencv;
OpenCV fist;

SinOsc sine;
Env ping;
Delay echo;

void setup() {
  size(640, 480);
  
  sine = new SinOsc(this);
  ping = new Env(this);
  echo = new Delay(this);
  
  echo.process(sine, 5);
  echo.time(0.5);
  echo.feedback(0.8);
  
  video = new Capture(this, 640, 480);
  opencv = new OpenCV(this, 640, 480);
  fist = new OpenCV(this, 640, 480);
  opencv.loadCascade("/Users/hoangmanhquan/Documents/Processing/opencv_hand/data/lpalm.xml", true);  
  fist.loadCascade("/Users/hoangmanhquan/Documents/Processing/opencv_hand/data/aGest.xml", true);

  video.start();
  
  
  frameRate(240);
}

void draw() {
  opencv.loadImage(video);
  fist.loadImage(video);

  //image(video, 0, 0 );

  noFill();
  stroke(0, 255, 0);
  strokeWeight(3);
  Rectangle[] faces = opencv.detect();
  Rectangle[] fists = fist.detect();
  
  println(faces.length);
  println("Fist detected: ", fists.length);

  for (int i = 0; i < faces.length; i++) {
    println(faces[i].x + "," + faces[i].y);
    rect(faces[i].x, faces[i].y, faces[i].width, faces[i].height);
  }
  for (int i = 0; i < fists.length; i++) {
    println(fists[i].x + "," + fists[i].y);
    rect(fists[i].x, fists[i].y, fists[i].width, fists[i].height);
  }
}

void captureEvent(Capture c) {
  c.read();
}

void playNote() {
   sine.freq(noteToFreq((int) map(mouseX, 0, width, 50, 74))); 
   sine.play();
   ping.play(sine, 0.02, 0.05, 1, 0.3);
}

void keyPressed() {
   playNote();
   try {
    Thread.sleep(5000);
   } catch (InterruptedException e) {
    Thread.currentThread().interrupt();
   }
}

float noteToFreq(float midiNote) {
  return 440.0 * pow(2, (midiNote - 69) / 12.0);
}
