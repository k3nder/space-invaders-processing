public class Text {
  private int x;
  private int y;
  private int size = 60;
  public void show(String text){
    textSize(size);
    fill(163, 255, 77);
    text(text, x, y);
  }
  public void clean(){
    fill(204,204,204);
    rect(x+2, y+20,400,-100);
  }
  public Text(int x, int y){
    this.x = x;
    this.y = y;
  }
}
