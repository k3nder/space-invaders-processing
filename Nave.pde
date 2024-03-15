public class Nave extends MovibleObject{
  // lista de balas
  protected List<Bala> balas = new ArrayList<>();
  public Nave(int x, int y, int x_size, int y_size) {
    this.y = y;
    this.x = x;
    this.x_size = x_size;
    this.y_size = y_size;
  }
  public List<Bala> getBalas(){
    return balas;
  }
  // methodo para disparar
  public void disparar(){
    Bala bala = new Bala(this);
    bala.setDirection(Direction.BOTTOM);
    bala.playerVulnerable();
    balas.add(bala);
  }
  // methodo para verificar si esta en el borde
  public boolean isInBorder() {
    if (x + (x_size + 2) > width || (2 + x) < 0) {
      return true;
    }
    return false;
  }
  // methodo para teleportar la nave
  public void teleport(int x, int y) {
    clean();
    this.x = x;
    this.y = y;
    stroke(1.0);
    fill(299, 9, 9);
    rect(x, y, x_size + 2, y_size + 2);
  }
  // methodo para mover la nave con su velocidad i su posicion Y
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
  // methodo que mueve solo la velocidad
  public void move(int velocity) {
    move(velocity, y);
  }
}
