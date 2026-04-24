import processing.serial.*;
import java.util.Map;
import processing.video.*;


// Creates object from Serial class
Serial myPort;
int usedPort = 3;

String command; // Command written to the serial port containing the angle data

// Current slider and motor angle value
float servo_pitch_angle;
float servo_yaw_angle;
float servo_height_angle;

// Offset value for calibration
float servo_pitch_offset;

// Motor slider objects
Slider slider_pitch;
Slider slider_yaw;
Slider slider_height;

// Cursor object for the timeline
TimeCursor timeCursor;

// Object that stores the keyframe button position data
ButtonCanvas keyframes;
Integer keyframepressed;

// Hashmaps for storing the keyframe data key is the position in the timeline, value the given angle
HashMap<Float, Float> hmap_pitch;
HashMap<Float, Float> hmap_yaw;
HashMap<Float, Float> hmap_height;

// In and out point
float in;
float out;

// Buttons
ImageButton playbutton;
ImageButton camerabutton;
ImageButton communicationbutton;


// Booleans attached to buttons
boolean play;
boolean camera = false;
boolean communicating = false;
boolean camera_setup = false;
boolean communication_setup = false;

// Time at last iteration
int time;

// Camera object from library processing.video
Capture cam;


// Images for button icons
PImage stopimg;
PImage playimg;
PImage cameraimg;
PImage cameranotimg;
PImage communicationimg;
PImage communicationnotimg;


void setup() {
  
  // Window size for the GUI
  size(1200, 700);
  pixelDensity(2);
  
  if (camera) {
    setup_camera();
  }
  
  if (communicating) {
    setup_communication();
  }
  
  hmap_pitch = new HashMap<Float, Float>();
  hmap_yaw = new HashMap<Float, Float>();
  hmap_height = new HashMap<Float, Float>();
  
  slider_pitch = new Slider("Pitch Axis", 30, 100);
  slider_yaw = new Slider("Yaw Axis", 30, 140);
  slider_height = new Slider("Height", 30, 180);
  
  timeCursor = new TimeCursor("Timeline", 0, 1000, 0, 100, 500, 1000, 20);
  keyframes = new ButtonCanvas();
  
  stopimg = loadImage("stop.png");
  playimg = loadImage("play.png");
  cameraimg = loadImage("camera.png");
  cameranotimg = loadImage("camera_not.png");
  communicationimg = loadImage("communication.png");
  communicationnotimg = loadImage("communication_not.png");
  
  playbutton = new ImageButton(playimg, 530, 450, 30);
  camerabutton = new ImageButton(cameranotimg, 20, 10, 30);
  if (!camera) {
    camerabutton.icon = cameraimg;
  }
  communicationbutton = new ImageButton(communicationnotimg, 70, 10, 30);
  if (!communicating) {
    communicationbutton.icon = communicationimg;
  }
  
  in = 0.0;
  out = 0.0;
  play = false;
  
  // First and last keyframe in the timeline zeroed out
  hmap_pitch.put(0.0, 90.0);
  hmap_yaw.put(0.0, 90.0);
  hmap_height.put(0.0, 90.0);
  hmap_pitch.put(1100.0, 90.0);
  hmap_yaw.put(1100.0, 90.0);
  hmap_height.put(1100.0, 90.0);
}

void draw() {
  background(200);
  
  if (play) {
    timeCursor.value += play();
    if (out != 0) {
      if (timeCursor.value > out) {
        timeCursor.value = in;
      }
    } else {
      if (timeCursor.value > timeCursor.max) {
        timeCursor.value = in;
      }
    }
  }
  
  if (!play) {
      timeCursor.user_input();
  }
  draw_lines();
  
  slider_pitch.draw();
  slider_yaw.draw();
  slider_height.draw();
  timeCursor.draw();
  
  // To compute inbetween values using linear pro/regression from the two points surrounding the cursor
  slider_pitch.value = compute_value(timeCursor.value, hmap_pitch);
  slider_yaw.value = compute_value(timeCursor.value, hmap_yaw);
  slider_height.value = compute_value(timeCursor.value, hmap_height);
  
  if (!play) {
    // Registering user input and adding keyframe data to hashmap and buttons to canvas
    Float p = slider_pitch.user_input();
    if (p != null) {
      hmap_pitch.put((Float)timeCursor.value, p);
      keyframes.add( 100 + (int)timeCursor.value, 530, 10);
    }
    Float y = slider_yaw.user_input();
    if (y != null) {
      hmap_yaw.put((Float)timeCursor.value, y);
      keyframes.add( 100 + (int)timeCursor.value, 580, 10);
    }
    Float h = slider_height.user_input();
    if (h != null) {
      hmap_height.put((Float)timeCursor.value, h);
      keyframes.add( 100 + (int)timeCursor.value, 630, 10);
    }
    
    keyframepressed = keyframes.user_input();
    if (keyframepressed != null) {
      timeCursor.value = keyframepressed - 100;
    }
  }
  
  if(playbutton.user_input()) {
    play();
    play = !play;
    if (play) {
      playbutton.icon = stopimg;
    } else {
      playbutton.icon = playimg;
    }
  }
  
  if (camerabutton.user_input()) {
    setup_camera();
    if (camera) {
      camerabutton.icon = cameranotimg;
    } else {
      camerabutton.icon = cameraimg;
    }
  }
  
  if (communicationbutton.user_input()) {
    setup_communication();
    if (communicating) {
      communicationbutton.icon = communicationnotimg;
    } else {
      communicationbutton.icon = communicationimg;
    }
  }
  
  // Drawing keyframes to the GUI
  keyframes.draw();
  
  
  if (communicating) {
    // --NOT USED-- // To receive servo or sensor data from the arduino
    if (myPort.available() > 0) {
       String var = myPort.readStringUntil('\n');
       println(var);
    }
  }
  
  if(communicating) {
    // Formatting the string and sending it to the arduino
    command = "P" + trnsfm(slider_pitch) + "Y" + trnsfm(slider_yaw) + "H" + trnsfm(slider_height);
    myPort.write(command + "\n");
  }
  
  if (camera) {
    // Reading camera data
    if (cam.available() == true) {
      cam.read();
    }
    // Putting the camera image on the screen
    image(cam, 500, 30, 600, 400);
  }
  
  playbutton.draw();
  camerabutton.draw();
  communicationbutton.draw();
}


String trnsfm(Slider input_slider) { // Formatting floats to three character strings
  int output = (int)input_slider.value;
  if (output < 10) {
    return "00" + output;
  } if (output < 100) {
    return "0" + output;
  } else {
    return "" + output;
  }
}

void draw_lines() { // Draws lines for some beauty
  strokeWeight(1);
  line(100, 550, 1100, 550);
  text("Pitch", 60, 530);
  line(100, 600, 1100, 600);
  text("Yaw", 60, 580);
  line(100, 650, 1100, 650);
  text("Height", 60, 630);
}

float compute_value(float cursor, HashMap<Float, Float> hashmap) { // Finds two entrys in hashmap with the keys surrounding the cursor and computes should value for cursor position
  if (!hashmap.containsKey(cursor)) {
    Float before = -1.0;
    Float next = null;
    for (Map.Entry entry: hashmap.entrySet()) {
      Float helper = (Float)entry.getKey();
      if (before == -1) {
        before = helper;
        continue;
      }
      if (helper < cursor && helper > before) {
        before = helper;
      }
      if (helper > cursor) {
        if (next == null) {
          next = helper;
        }
        if (helper < next) {
          next = helper;
        }
      }
    }
    if (next == null) {
      return before;
    } else {
      // Computes gradient and returns the appropriate value for a given time (cursor)
      float gradient = (hashmap.get(next) - hashmap.get(before)) / (next - before);
      return hashmap.get(before) + (cursor - before) * gradient;
    }
  }
  return hashmap.get(cursor);
}

float play() { // Returns the time since last call
  float timeDiff = (float)((millis() - time)) / 1000;
  time = millis();
  return timeDiff;
}

void draw_bg() {
  
}

void setup_camera() {
  if (!camera_setup) {
    try {
    // To receive image data from the camera
    String[] cameras = Capture.list();
    if (cameras.length == 0) {
      println("There are no cameras available for capture.");
      exit();
    } else {
      println("Available cameras:");
      for (int i = 0; i < cameras.length; i++) {
        println(cameras[i]);
      }
    
      cam = new Capture(this, cameras[0]);
      cam.start();     
    }
    camera_setup = true;
    } finally {}
  }
  if (camera_setup) {
    camera = !camera;
  }
}

void setup_communication() {
  if (!communication_setup) {
      // Serial port to connect to the arduino
      try {
        String portName = Serial.list()[usedPort];
        myPort = new Serial(this, portName, 19200);
        
        communication_setup = true;
    } finally {}
    if (communication_setup) {
      communicating = !communicating;
    }
  }
}
