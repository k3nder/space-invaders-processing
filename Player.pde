public class Player extends MovibleObject{
  // maximo de balas
  private int maximumBalas;
  // delay de la bala
  private int playerBalasDelay;
  // vidas del jugador
  private int lives = 3;
  // lista de balas
  private List<Bala> balas = new ArrayList<>();
  public Player(int x, int y) {
    this.y = y;
    this.x = x;
    Integer PLAYER_SIZE = Integer.parseInt(propiedades.getProperty("player.size"));
    this.x_size = PLAYER_SIZE;
    this.y_size = PLAYER_SIZE;
    show();
    println("player created");
    maximumBalas=Integer.parseInt(propiedades.getProperty("player.maximum.balas"));
    playerBalasDelay=Integer.parseInt(propiedades.getProperty("player.balas.delay"));
  }
  public List<Bala> getBalas() {
    return balas;
  }
  // obtener balas restantes
  public int getBalasRest(){
    return maximumBalas - balas.size();
  }
  // poner maximo de balas
  public void setMaximumBalas(int value){
    maximumBalas = value;
  }
  // mover el jugador
  public void move(int pasos) {
    println("move");
    clean();
    this.x += pasos;
    show();
  }
  // poner el delay de la bala
  public void setPlayerBalasDelay(int value){
    playerBalasDelay=value;
  }
  public int getLives(){
    return lives;
  }
  // methodo para disparar
  void disparar() {
    if(fpst < playerBalasDelay) return;
    if(maximumBalas < balas.size()) return;
    Bala b = new Bala(this);
    balas.add(b);
    fpst=0;
  }
  public int getY() {
    return this.y;
  }
  public int getX() {
    return this.x;
  }
  @Override
  public void delete(){
    println(lives);
    if(lives == 0) delete = true;
    else lives--;
  }
}
