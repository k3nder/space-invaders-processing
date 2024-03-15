public class Text {
  private int x;
  private int y;
  // tamaño del texto
  private int size = 60;
  // methodo para mostrar el texto
  public void show(String text){
    textSize(size);
    fill(163, 255, 77);
    text(text, x, y);
  }
  // limpiar el texto
  public void clean(){
    fill(204,204,204);
    rect(x+2, y+20,400,-100);
  }
  public Text(int x, int y){
    this.x = x;
    this.y = y;
  }
}
