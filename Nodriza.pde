public class Nodriza extends Nave {
  public Nodriza(int size){
    super(width/2,size/2,size,size/2);
  }
  @Override
  public void show(){
    fill(247, 255, 0);
    super.show();
  }
  @Override
  public void move(int velocity, int y_) {
    clean();
    x += velocity;
    this.y = y_;
    println(velocity, y_, y, x);
    stroke(1.0);
    fill(247, 255, 0);
    logger.debug("nave: " + this + " cords: y: " + y + " x: " + x + " x_size: " + x_size + " y_size: " + y_size);
    rect(x, y, x_size, y_size);
  }
  @Override
  public void disparar(){
    Bala bala = new Bala(this);
    bala.setDirection(Direction.BOTTOM);
    bala.playerVulnerable();
    bala.hyperBala();
    balas.add(bala);
  }
}
