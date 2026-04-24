abstract class Button{
  // Positional values
  int x;
  int y;
  
  
  Button(int x, int y){
    this.x = x;
    this.y = y;
  }
  
  abstract void draw();
  
  abstract boolean user_input();
}
