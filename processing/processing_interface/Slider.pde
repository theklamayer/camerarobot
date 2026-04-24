class Slider{
  
  // Positional and size values
  String name;
  float min; // Min value
  float max; // Max value
  int x; // X position
  int y; // Y position
  int w; // Width
  int h; // Height
  // Movable part used for motor value
  float value;

  
  Slider(String name, float min, float max, float value, int x, int y, int w, int h){
    this.name = name;
    this.min = min;
    this.max = max;
    this.value = value;
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }
  
  Slider(String name, int x, int y) {
    this.name = name;
    min = 0;
    max = 180;
    value = 90;
    this.x = x;
    this.y = y;
    w = 180;
    h = 15;
  }
  
  void draw() { // Draws the slider with all containments
    strokeWeight(2);
    line(x, y, x + w, y);
    circle(x + value, y, h);
    text(name, x, y - h);
    text(value, x + w + h, y);
  }
  
  Float user_input() { // Tests if the mouse cursor is in applicable position and if the slider is moved by the user then returns updated value
    if (mouseX > x && mouseX < x + w){
      if (mouseY > y - h/2 && mouseY < y + h/2) {
        if (mousePressed) {
          value = mouseX - x;
          if (value > max) {
            value = max;
          }
          if (value < min) {
            value = min;
          }
          return value;
        }
      }
    }
    return null;
  }
}
