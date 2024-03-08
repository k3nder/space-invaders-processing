public class Bala extends MovibleObject{
  private boolean playerVulnerable = false;
  private boolean delated;
  private int relay = 5;
  private Direction direct = Direction.TOP;
  private Runnable onTouch = () -> {
    println("touched");
  };
  public void onTouch(Runnable run) {
    onTouch = run;
  }
  public Bala(MovibleObject jugador) {
    y = jugador.getY()+relay;
    y_size = -50;
    x = jugador.getX();
    x_size = 3;
    show();
  }
  public void setDirection(Direction direct){
    this.direct = direct;
  }
  public void move(int velocity) {
    int BALA_MAXIMUM_DISTANCE = Integer.parseInt(propiedades.getProperty("bala.maximum.distance"));
    moveBala(BALA_MAXIMUM_DISTANCE, velocity);
  }
  private void moveBala(int BALA_MAXIMUM_DISTANCE, int velocity) {
    boolean breaker = false;
    for (int i = 0; i <= BALA_MAXIMUM_DISTANCE; i++) {
      // TODO
      if (breaker) break;
      println("verify vulnerable: ", playerVulnerable);
      if(playerVulnerable){
        println("player vulnerable");
        verifyNaveTouched(jugador);
      } else {
        println("nave vulnerable");
        Naves.stream().forEach(Nave -> verifyNaveTouched(Nave));
      }
      verifyWin();
      clean();
      y -= velocity;
      y_size -= velocity;
    }
  }
  public boolean isOutOfMap(){
    if(x <= 0) return true;
    return false;
  }
  private Boolean verifyNaveTouched(MovibleObject nav) {
    // si la nave ya esta eliminada, pasar a otra
    if (nav.isDeleted()) return false;
    if (isInRadius(nav)) {
      logger.debug("touched");
      onTouch.run();
      nav.delete();
      return true;
    }
    return false;
  }
  private void verifyWin() {
    boolean totaldelated = true;
    for (Nave nave : Naves) {
      if (!nave.isDeleted()) totaldelated = false;
    }
    if (totaldelated) {
      IsWin = true;
      game.win();
    }
  }
  private boolean isInRadius(MovibleObject nav) {
    return (x >= nav.getX() && x <= (nav.getXSIZE() + nav.getX())) && (y >= nav.getY());
  }
  public void playerVulnerable(){
    playerVulnerable = true;
  }
  @Override
  public void update() {
    clean();
    Increase(Position.Y, (direct == Direction.BOTTOM ? 10 : -10 ));
    move(1);
    show();
  }
  public boolean isDelated(){
    return delated;
  }
  public void delete(){
    delated = true;
    clean();
  }
}
