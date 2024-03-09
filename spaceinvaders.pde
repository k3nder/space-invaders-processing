import java.util.List;
import java.util.ListIterator;
import java.io.FileWriter;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.Properties;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import java.util.Random;
final Properties propiedades = new Properties();

public static File DEFAULT_CONFIG_FILE = new File("C:/Users/krist/Desktop/spaceinvaders/data/conf.default.properties");
public static final File DEFAULT_LEVELS_CONFIG = new File("C:/Users/krist/Desktop/spaceinvaders/data/game/levels/levels.json");
public static Boolean IsWin = false;
// true suma i false resta
public static Boolean DirectionNave = false;
public static Log logger = LogFactory.getLog("GAME");

List<Nave> Naves = new ArrayList<Nave>();

void settings() {
  logger.info("settings");
  loadPropertiesFile();
  int PANE_SIZE = Integer.parseInt(propiedades.getProperty("pane.size"));
  size(PANE_SIZE, PANE_SIZE);
  logger.info("settings finish");
}
private void loadPropertiesFile(){
  try {
    propiedades.load(new FileInputStream(DEFAULT_CONFIG_FILE));
  }
  catch(IOException e) {
    logger.error("error IO", e);
    System.exit(10);
  }
}

int velocity;
int down_velocity;
int fpst;
// el jugador principal
Player jugador;

Game game = new Game();
void setup() {
  println("setup");
  loadPropertiesFile();
  velocity = Integer.parseInt(propiedades.getProperty("nave.velocity"));
  down_velocity = Integer.parseInt(propiedades.getProperty("nave.down.velocity"));
  game.generateNaves();
  int PLAYER_BOTTOM_DISTANCE = Integer.parseInt(propiedades.getProperty("player.bottom.distance"));
  // poner las naves
  Naves.stream().forEach(Nave -> println(Nave));
  jugador = new Player(width/2, (height)-(PLAYER_BOTTOM_DISTANCE));
  nodriz = new Nodriza(50);
  Naves.add(nodriz);
  println("setup finish"); 
}
int fpstn;
Nodriza nodriz;
void draw() {
  /*
  NOTE: se pensaba que la detecoion de si una bala toca una nave fallaba, i que eso generaba el error de un game.over temprano, pero se descubrio que no es un error
  i que lo que lo estaba generando es el limite de 600...
  */
  if(game.pause) return;
  if(jugador.isDeleted() || jugador.getLives() == 0) game.over();
  game.addStatus("vidas", jugador.getLives());
  game.addStatus("balas", jugador.getBalasRest());
  game.addStatus("level", game.levelIndex + 1);
  jugador.update();
  fpst++;
  fpstn++;
  if(!(fpstn < 40) && (!nodriz.isDeleted())) {nodriz.disparar(); fpstn=0;}

  Random rand = new Random();
  int n = rand.nextInt(Naves.size()*(Integer.parseInt(propiedades.getProperty("nave.bala.probablity"))));
  if(!(n > Naves.size()-1)) if(!Naves.get(n).isDeleted()) Naves.get(n).disparar();
  
  //logger.info("velocity: " + velocity);
  int iterator_statuses = 1;
  for(java.util.Map.Entry<String, String> entry : game.statuses.entrySet()){
    String key = entry.getKey();
    String value = entry.getValue();
    Text text = new Text(60, iterator_statuses*100);
    text.clean();
    text.show(key + " " + value);
    iterator_statuses++;
  }
  if(game.showFPS){
    noStroke();
    fill(204, 204, 204);
    rect(502, 140,400,-100);
    fill(204, 204, 255);
    stroke(1.0);
    textSize(128);
    text(frameRate , 500, 120);
  } 
  // cargar todas las balas
  jugador.getBalas().stream().filter(Bala -> !Bala.isDeleted())
    .forEach(bala -> bala.update());
  for(Nave nav : Naves){
     nav.getBalas().stream().filter(Bala -> !Bala.isDeleted())
      .forEach(Bala -> Bala.update());
  }
  // carga i actualiza todas las naves, mira si hay una en el borde
  for (Nave nave : Naves) {
    if (nave.isDeleted()) continue;
    if (nave.isInBorder()) {
      println("is in border: "+velocity);
      velocity = -velocity;
      Naves.stream().filter(Nave -> !Nave.isDeleted()).forEach(Nave -> Nave.move(0, Nave.getY()+down_velocity));
    }
  }
  Naves.stream().filter(Nave -> !Nave.isDeleted()).forEach(Nave -> {
    if(Nave.getY() > Integer.parseInt(propiedades.getProperty("game.over.to.ymin"))) game.over();
  });
  Naves.stream().filter(Nave -> !Nave.isDeleted()).forEach(Nave -> Nave.move(velocity));
}

// detectar las teclas
void keyPressed() {
  if(key == 'p'){
    game.changePause();
    return;
  }
  if (key == ' ') {
    if(game.pause) {
      if(IsWin) game.nextLevel();
      else game.restart();
      return;
    }
    jugador.disparar();;
  }
  if(game.pause) return;
  println("key presed");
  int PLAYER_STEPS = Integer.parseInt(propiedades.getProperty("player.steps"));
  if (keyCode == LEFT) {
    jugador.clean();
    jugador.Increase(Position.X,-PLAYER_STEPS);
    jugador.show();
  } else if (keyCode == RIGHT) {
    jugador.clean();
    jugador.Increase(Position.X,PLAYER_STEPS);
    jugador.show();
  } else if(key == 'f') {
    game.showFPS = !game.showFPS;
    if(!game.showFPS){
      noStroke();
      fill(204, 204, 204);
      rect(502, 140,400,-100);
      stroke(1);
    }
  }
  if(game.devtools){
    println("game tools on");
    if (key == 'n') {
      if(!game.devtools) return;
      Naves.stream().filter(Nave -> !Nave.isDeleted()).forEach(Nave -> Nave.disparar());
    } else if(key == 'w'){
      game.win();
    } else if(key == 'o'){
      game.over();
    } else if(key == 'i'){
      // hacer el jugadopr invulnerable
    } else if(key == 'l'){
      game.nextLevel();
    } else if(key == 'k'){
      game.previusLevel();
    } else if(key == 'm'){
     jugador.setPlayerBalasDelay(0);
    } else if(key == 'z'){
      jugador.setMaximumBalas(Integer.MAX_VALUE);
    }
  } 
  println("event close");
}

abstract class MovibleObject{
  protected boolean delete = false;
  protected Integer x;
  protected Integer y;
  protected Integer x_size;
  protected Integer y_size;
  public void clean(){
    fill(204, 204, 204);
    stroke(206, 204, 205);
    rect(x, y, x_size, y_size);
    stroke(1.0);
    fill(255, 255, 255);
  }
  public void show(){
    rect(x, y, x_size, y_size);
  }
  public void update(){
    clean();
    show();
  }
  public void Increase(Position pos, Integer velocity){
    if(pos == Position.Y) IncreaseY(velocity);
    if(pos == Position.X) IncreaseX(velocity);
    if(pos == Position.X_SIZE) IncreaseXSIZE(velocity);
    if(pos == Position.Y_SIZE) IncreaseYSIZE(velocity);
    if(pos == Position.X_AND_SIZE){
      IncreaseXSIZE(velocity);
      IncreaseX(velocity);
    }
    if(pos == Position.Y_AND_SIZE){
      IncreaseYSIZE(velocity);
      IncreaseY(velocity);
    }
  }
  protected void IncreaseX(Integer velocity){
      x += velocity;
  }
  protected void IncreaseY(Integer velocity){
      y += velocity;
  }
  protected void IncreaseXSIZE(Integer velocity){
      x_size += velocity;
  }
  protected void IncreaseYSIZE(Integer velocity){
      y_size += velocity;
  }
  public int getX(){
    return x;
  }
  public int getY(){
    return y;
  }
  public int getXSIZE(){
    return x_size;
  }
  public int getYSIZE(){
    return y_size;
  }
  public boolean isDeleted(){
    return delete;
  }
  public void delete(){
    delete=true;
    println("delete", this);
    clean();
  }
}
enum Direction{
  TOP,
  BOTTOM,
  LEFT,
  RIGHT;
}
enum Position{
  Y,
  X,
  Y_SIZE,
  X_SIZE,
  Y_AND_SIZE,
  X_AND_SIZE;
}
