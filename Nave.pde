public class Nave extends MovibleObject{
  private List<Bala> balas = new ArrayList<>();
  public Nave(int x, int y, int x_size, int y_size) {
    this.y = y;
    this.x = x;
    this.x_size = x_size;
    this.y_size = y_size;
  }

  public int getX() {
    return x;
  }
  public List<Bala> getBalas(){
    return balas;
  }
  public void disparar(){
    Bala bala = new Bala(this);
    bala.setDirection(Direction.BOTTOM);
    bala.playerVulnerable();
    balas.add(bala);
  }

  public int getY() {
    return y;
  }

  public int getXSIZE() {
    return x_size;
  }

  public int getYSIZE() {
    return y_size;
  }
  public boolean isInBorder() {
    if (x + (x_size + 2) > width || (2 + x) < 0) {
      return true;
    }
    return false;
  }
  public void teleport(int x, int y) {
    clean();
    this.x = x;
    this.y = y;
    stroke(1.0);
    fill(299, 9, 9);
    rect(x, y, x_size + 2, y_size + 2);
  }

  public void move(int velocity, int y_) {
    clean();
    x += velocity;
    this.y = y_;
    println(velocity, y_, y, x);
    stroke(1.0);
    fill(299, 9, 9);
    logger.debug("nave: " + this + " cords: y: " + y + " x: " + x + " x_size: " + x_size + " y_size: " + y_size);
    rect(x, y, x_size, y_size);
  }
  public void move(int velocity) {
    clean();
    x += velocity;
    stroke(1.0);         
    fill(299, 9, 9);
    rect(x, y, x_size, y_size);
  }
}
