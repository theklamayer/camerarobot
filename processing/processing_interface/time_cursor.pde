class TimeCursor extends Slider {
  
  TimeCursor(String name, float min, float max, float value, int x, int y, int w, int h){
    super(name, min, max, value, x, y, w, h);
  }
  
  void draw() { // Overwritten method that displays additional lines
    strokeWeight(2);
    line(x, y, x + w, y);
    circle(x + value, y, h);
    // text(name, x, y - h);
    text(value, x + value + h, y - h / 2);
    line(x + value, y - h, x + value, height - 30);
  }
}
