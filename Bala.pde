public class Bala extends MovibleObject{
  // indica si los jugadores son vulnerables a la bala
  private boolean playerVulnerable = false;
  // si es hyper te quita 3 vidas en vez de solo una, ademas cambia su color a un naranja
  private boolean hyper = false;
  // la distancia que tiene a otro objeto que lo lanza
  private int relay = 5;
  // direcion de la bala
  private Direction direct = Direction.TOP;
  // acion cuando la bala toca un objeto
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
  // mueve la bala sin velocidad
  public void move() {
    int BALA_MAXIMUM_DISTANCE = Integer.parseInt(propiedades.getProperty("bala.maximum.distance"));
    moveBala(BALA_MAXIMUM_DISTANCE);
  }
  // actualiza la bala moviendola i vericiando si ha tocado algo
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
  // verifica si a tocado algo
  private Boolean verifyNaveTouched(MovibleObject nav) {
    if(delete){  return false;} 
    // si la nave ya esta eliminada, pasar a otra
    if (nav.isDeleted()) return false;
    if (isInRadius(nav)) {
      logger.debug("touched");
      onTouch.run();
      println("for touch of", this);
      nav.delete();
      // si es hyper intentar eliminarla otras dos vezes
      if(hyper) {nav.delete(); nav.delete();}
      this.delete();
      this.clean();
      return true;
    }
    return false;
  }
  // verificar si quedan naves vivas
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
  // vericicar si estan fuera del mapa
  private boolean isOut(){
    return (between(y, 0, width));
  }
  // verificar si hay una bala en un objeto movible
  private boolean isInRadius(MovibleObject nav) {
    return (between(x, nav.getX(), (nav.getX() + nav.getXSIZE())) && between(y, nav.getY(), (nav.getY() + nav.getYSIZE())));
  }
  // verificar si un numero esta entre otro
  private boolean between(int valor, int pnt1, int pnt2){
    int p1 = (pnt1 < pnt2 ? pnt1 : pnt2);
    int p2 = (pnt1 > pnt2 ? pnt1 : pnt2);
    return (!(p1 >= valor) && !(p2 <= valor));
  }
  // poner que el jugador sea vulnerable
  public void playerVulnerable(){
    playerVulnerable = true;
  }
  // sobre escribir update para que incremente la posicion i si esta fuera del mapa eliminarla 
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
}
