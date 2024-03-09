public class Player extends MovibleObject{
  private int maximumBalas;
  private int playerBalasDelay;
  private int lives = 3;
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
  public int getBalasRest(){
    return maximumBalas - balas.size();
  }
  public void setMaximumBalas(int value){
    maximumBalas = value;
  }
  public void move(int pasos) {
    println("move");
    clean();
    this.x += pasos;
    show();
  }
  public void setPlayerBalasDelay(int value){
    playerBalasDelay=value;
  }
  public int getLives(){
    return lives;
  }
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
