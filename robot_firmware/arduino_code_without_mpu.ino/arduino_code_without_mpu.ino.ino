#include <Wire.h>
#include <Servo.h>

// Initialize servos for all axis
Servo servo_pitch;
Servo servo_yaw;
Servo servo_height;

// Defining the input pins for all servos
#define SERVO_PITCH_PIN            A1
#define SERVO_YAW_PIN              A2
#define SERVO_HEIGHT_PIN           A3

void setup() {
  servo_pitch.attach(SERVO_PITCH_PIN);
  servo_yaw.attach(SERVO_YAW_PIN);
  servo_height.attach(SERVO_HEIGHT_PIN);

  servo_pitch.write(90);
  servo_yaw.write(90);
  servo_height.write(90);


  Serial.begin(19200);
}

void loop() {
  // Listening on the serial port for commands from processing

  if (Serial.available()) {
    String command;
 
      command = Serial.readStringUntil('\n');
      if (command[0] == 'P' && command[4] == 'Y' && command[8] == 'H') {
        int servo_pitch_degree = command.substring(1, 4).toInt();
        int servo_yaw_degree = command.substring(5, 8).toInt();
        int servo_height_degree = command.substring(9, 12).toInt();
        servo_pitch.write(servo_pitch_degree);
        servo_yaw.write(servo_yaw_degree);
        servo_height.write(servo_height_degree);
      } else if (command[0] == 'S') {
        pinMode(13, OUTPUT);
      }
  }
}
