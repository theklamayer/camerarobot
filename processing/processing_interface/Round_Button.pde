class RoundButton extends Button {
  int size;
  
  
  RoundButton(int x, int y, int size) {
    super(x, y);
    this.size = size;
  }
  
  void draw() {
    circle(x, y, size);
  }
  
  boolean user_input() { // Tests if mouse cursor is in applicable position and returns true when button is pressed
    if (mouseX > x - size / 2 && mouseX < x + size / 2){
      if (mouseY > y - size / 2 && mouseY < y + size / 2) {
        if (mousePressed) {
          return true;
        }
      }
    }
    return false;
  }
}
