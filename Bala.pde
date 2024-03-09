public class Bala extends MovibleObject{
  private boolean playerVulnerable = false;
  private boolean hyper = false;
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
  public void move() {
    int BALA_MAXIMUM_DISTANCE = Integer.parseInt(propiedades.getProperty("bala.maximum.distance"));
    moveBala(BALA_MAXIMUM_DISTANCE);
  }
  private void moveBala(int BALA_MAXIMUM_DISTANCE) {
    boolean breaker = false;
    for (int i = 0; i <= BALA_MAXIMUM_DISTANCE; i++) {
      // TODO
      if (breaker) break;
      if(playerVulnerable){
        verifyNaveTouched(jugador);
      } else {
        Naves.stream().forEach(Nave -> verifyNaveTouched(Nave));
      }
      verifyWin();
    }
  }
  public void hyperBala(){
    hyper=true;
  }
  private Boolean verifyNaveTouched(MovibleObject nav) {
    if(delete){  return false;} 
    // si la nave ya esta eliminada, pasar a otra
    if (nav.isDeleted()) return false;
    if (isInRadius(nav)) {
      logger.debug("touched");
      onTouch.run();
      println("for touch of", this);
      nav.delete();
      if(hyper) {nav.delete(); nav.delete();}
      this.delete();
      this.clean();
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
  private boolean isOut(){
    return (between(y, 0, width));
  }
  private boolean isInRadius(MovibleObject nav) {
    //println("test", 40, 100, 0, between(40,0,100));
    //println("x", x, nav.getX(), (nav.getX() + nav.getXSIZE()), between(x, nav.getX(), (nav.getX() + nav.getXSIZE())));
    //println("y", y, nav.getY(), (nav.getY() + nav.getYSIZE()), between(y, nav.getY(), (nav.getY() + nav.getYSIZE())));
    return (between(x, nav.getX(), (nav.getX() + nav.getXSIZE())) && between(y, nav.getY(), (nav.getY() + nav.getYSIZE())));
    //return (x >= nav.getX() && x <= (nav.getXSIZE() + nav.getX())) && (((y <= nav.getY() + nav.getYSIZE())));
  }
  private boolean between(int valor, int pnt1, int pnt2){
    int p1 = (pnt1 < pnt2 ? pnt1 : pnt2);
    int p2 = (pnt1 > pnt2 ? pnt1 : pnt2);
   // println("nimor",p1,"major",p2);
    //println((p1 >= valor), (p2 <= valor));
    return (!(p1 >= valor) && !(p2 <= valor));
  }
  public void playerVulnerable(){
    playerVulnerable = true;
  }
  @Override
  public void update() {
    clean();
    Increase(Position.Y, (direct == Direction.BOTTOM ? 10 : -10 ));
    if(hyper) fill(255, 147, 0);
    show();
     move();
    if (!isOut()) {
      println("clean", this);
      this.clean();
      this.delete();
    }
  }
  @Override
  public void show(){
    println("showing", this);
    super.show();
  }
}
