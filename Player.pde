public class Player extends MovibleObject{
  private List<Bala> balas = new ArrayList<>();
  public Player(int x, int y) {
    this.y = y;
    this.x = x;
    Integer PLAYER_SIZE = Integer.parseInt(propiedades.getProperty("player.size"));
    this.x_size = PLAYER_SIZE;
    this.y_size = PLAYER_SIZE;
    show();
    println("player created");
  }
  public List<Bala> getBalas() {
    return balas;
  }
  public void move(int pasos) {
    println("move");
    clean();
    this.x += pasos;
    show();
  }
  void disparar() {
    Bala b = new Bala(this);
    balas.add(b);
  }
  public int getY() {
    return this.y;
  }
  public int getX() {
    return this.x;
  }
}
