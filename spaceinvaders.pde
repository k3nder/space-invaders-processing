import java.util.List;
import java.util.ListIterator;
import java.io.FileWriter;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.Properties;
import net.kender.Kjson.ConfigFile;
import net.k3nder.game.nave;
import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonProperty;
import net.k3nder.game.levels;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import java.util.Random;
final Properties propiedades = new Properties();

public static final File DEFAULT_CONFIG_FILE = new File("C:/Users/krist/Desktop/spaceinvaders/data/conf.default.properties");
public static final File DEFAULT_LEVELS_CONFIG = new File("C:/Users/krist/Desktop/spaceinvaders/data/game/levels/levels.json");
public static Boolean IsWin = false;
// true suma i false resta
public static Boolean DirectionNave = false;
public static levels level;
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
// el jugador principal
Player jugador;

Game game = new Game();
void setup() {
  println("setup");
  loadPropertiesFile();
  velocity = Integer.parseInt(propiedades.getProperty("nave.velocity"));
  down_velocity = Integer.parseInt(propiedades.getProperty("nave.down.velocity"));
  generateNaves();
  int PLAYER_BOTTOM_DISTANCE = Integer.parseInt(propiedades.getProperty("player.bottom.distance"));
  // poner las naves
  Naves.stream().forEach(Nave -> println(Nave));
  jugador = new Player(width/2, (height)-(PLAYER_BOTTOM_DISTANCE));
  println("setup finish"); 
}
void draw() {
  if(jugador.isDeleted()) game.over();
  Random rand = new Random();

  // Obtain a number between [0 - 49].
  int n = rand.nextInt(Naves.size()*40);
  if(!(n > Naves.size()-1)) Naves.get(n).disparar();
  
  //logger.info("velocity: " + velocity);
  if(game.pause) return;
  noStroke();
  fill(204, 204, 204);
  rect(502, 140,400,-100);
  fill(204, 204, 255);
  stroke(1.0);
  textSize(128);
  text(frameRate , 500, 120);
  // cargar todas las balas
  jugador.getBalas().stream().filter(Bala -> !Bala.isDelated())
    .forEach(bala -> bala.update());
  for(Nave nav : Naves){
     nav.getBalas().stream().filter(Bala -> !Bala.isDelated())
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
    if(Nave.getY() > 600) game.over();
  });
  Naves.stream().filter(Nave -> !Nave.isDeleted()).forEach(Nave -> Nave.move(velocity));
}

// detectar las teclas
void keyPressed() {
  if(key == 'p'){
    game.changePause();
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
  } else if (key == ' ') {
    jugador.disparar();
  } else if (key == 'n') {
    if(!game.devtools) return;
    Naves.stream().filter(Nave -> !Nave.isDeleted()).forEach(Nave -> Nave.disparar());
  }
  println("event close");
}
// parser de nave a Nave
public Nave NaveConvertedOf(nave n) {
  return new Nave(n.x, n.y, n.x_size, n.y_size);
}
// carga todos los nives i las naves
List<levels> Levels = new ArrayList<levels>();
void generateNaves() {
  loadLevels();
  for (levels Level : Levels) {
    getLevelNaves(Level).stream()
      .forEach(nave -> Naves.add(NaveConvertedOf(nave)));
  }
  println(Levels.get(0));
}
// carga los niveles
private void loadLevels() {
  try {
    ConfigFile config = new ConfigFile(DEFAULT_LEVELS_CONFIG);
    List<levels> levels = config.getArrayList("levels", levels.class);
    Levels = levels;
  }
  catch(IOException | IllegalAccessException | InstantiationException e) {
    e.printStackTrace();
  }
}
// carga todas las naves de los niveles 
private List<nave> getLevelNaves(levels Level) {
  List<nave> result = new ArrayList<nave>();
  try {
    ConfigFile LevelConfig = new ConfigFile(new File("C:/Users/krist/Desktop/spaceinvaders/data/game/levels", Level.LevelFile));
    result = LevelConfig.getArrayList("naves", nave.class);
  }
  catch(IOException | IllegalAccessException | InstantiationException e) {
    e.printStackTrace();
  }
  return result;
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
    clean();
    delete=true;
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
