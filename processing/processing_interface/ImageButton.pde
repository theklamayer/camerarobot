class ImageButton extends Button {
  
  PImage icon;
  int size;
  boolean mousepressed = false;
  
  ImageButton(PImage icon, int x, int y, int size) {
    super(x, y);
    this.icon = icon;
    this.size = size;
  }
  
  void draw() {
    image(icon, x, y, size, size);
  }
  
  boolean user_input() { // Tests if mouse cursor is in applicable position and returns true when button is pressed
    if (mouseX > x && mouseX < x + size){
      if (mouseY > y && mouseY < y + size) {
        if (mousePressed) {
          mousepressed = true;
        }
        if (!mousePressed && mousepressed) {
          mousepressed = false;
          return true;
        }
      } else mousepressed = false;
    } else mousepressed = false;
    return false;
  }
}
