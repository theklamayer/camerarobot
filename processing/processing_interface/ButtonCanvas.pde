class ButtonCanvas{
  ArrayList<Button> buttons;
  
  ButtonCanvas() {
    buttons = new ArrayList();
  }
  
  void add(int x, int y, int size) {
    Button newbutton = new RoundButton(x, y, size);
    buttons.add(newbutton);
  }
  
  void draw() {
    for (Button button : buttons) {
      button.draw();
    }
  }
  
  Integer user_input() {
    for (Button button : buttons) {
      if (button.user_input()) {
        return button.x;
      }
    }
    return null;
  }
}
