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

// archivos de configuracion, modificar para otros sitemas operativos
public static File DEFAULT_CONFIG_FILE = new File("C:/Users/krist/Desktop/spaceinvaders/data/conf.default.properties");
public static final File DEFAULT_LEVELS_CONFIG = new File("C:/Users/krist/Desktop/spaceinvaders/data/game/levels/levels.json");
// variable que dice si el jugador a ganado o no
public static Boolean IsWin = false;
// true suma i false resta
public static Boolean DirectionNave = false;
public static Log logger = LogFactory.getLog("GAME");
// lista de naves
List<Nave> Naves = new ArrayList<Nave>();

void settings() {
  logger.info("settings");
  // carga el arvhivo de propiedades en las propiedades
  loadPropertiesFile();
  // obtinene el tamaño del panel i lo añade
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
// velocidad de las naves
int velocity;
// velocidad de bajada
int down_velocity;
// fps para un conteo en el delay de la bala
int fpst;
// el jugador principal
Player jugador;
// objeto con los datos del juego
Game game = new Game();
void setup() {
  println("setup");
  // carga el archivo de porpiedades
  loadPropertiesFile();
  // carga los valores de movimento predeterminados en el archivo de configuacion
  velocity = Integer.parseInt(propiedades.getProperty("nave.velocity"));
  down_velocity = Integer.parseInt(propiedades.getProperty("nave.down.velocity"));
  // genera las naves
  game.generateNaves();
  int PLAYER_BOTTOM_DISTANCE = Integer.parseInt(propiedades.getProperty("player.bottom.distance"));
  // poner las naves
  Naves.stream().forEach(Nave -> println(Nave));
  // crea el jugador
  jugador = new Player(width/2, (height)-(PLAYER_BOTTOM_DISTANCE));
  // crea la nave nodriza
  nodriz = new Nodriza(50);
  // añade la nave nodriza
  Naves.add(nodriz);
  println("setup finish"); 
}
// fps de delay para el delay de las balas de la nodiza
int fpstn;
// nave nodriza
Nodriza nodriz;
void draw() {
  /*
  NOTE: se pensaba que la detecoion de si una bala toca una nave fallaba, i que eso generaba el error de un game.over temprano, pero se descubrio que no es un error
  i que lo que lo estaba generando es el limite de 600...
  */
  // si esta pausado resetear el medodo para saltarlo
  if(game.pause) return;
  // si el jugador esta eliminado i no tiene vidas, hacer que el juego termine
  if(jugador.isDeleted() || jugador.getLives() == 0) game.over();
  // añadir los status mostrables del juego
  game.addStatus("vidas", jugador.getLives());
  game.addStatus("balas", jugador.getBalasRest());
  game.addStatus("level", game.levelIndex + 1);
  // actualizar el jugador
  jugador.update();
  // sumar los fps
  fpst++;
  fpstn++;
  // si el fps de la nodriza i no esta eliminada disparar
  if(!(fpstn < 40) && (!nodriz.isDeleted())) {nodriz.disparar(); fpstn=0;}
  // generar un numero random para ver que nave a a disparar
  /*
  EXPLICACION:
  genera un numero aleatorio, este numero es el index de la nave que va disparar, el numero generado esta entre el 0 i el numero de naves X la probablilidad nave.bala.probability
  para que si ese index como 8 no exite (no existe la nave numero 8) la nave no dispara i de igual forma si esta eliminada
  */
  Random rand = new Random();
  int n = rand.nextInt(Naves.size()*(Integer.parseInt(propiedades.getProperty("nave.bala.probablity"))));
  if(!(n > Naves.size()-1) && (!Naves.get(n).isDeleted())) Naves.get(n).disparar();
  
  // cargar i imprimir todos los statuses
  // iterator_statuses es el idex de los statuses para indicar la altura
  int iterator_statuses = 1;
  for(java.util.Map.Entry<String, String> entry : game.statuses.entrySet()){
    // se otiene la key i el valor 
    String key = entry.getKey();
    String value = entry.getValue();
    // se crea un texto
    Text text = new Text(60, iterator_statuses*100);
    // se limpia para quitar los anteriores si hay
    text.clean();
    // se muestra en la pantalla con el nuevo valor
    text.show(key + " " + value);
    // se incremeta los statuses
    iterator_statuses++;
  }
  // si se activa la opcion de mostrar fps, imprimirlos en pantalla
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
  // por cada nave cargar sus balas
  for(Nave nav : Naves){
     nav.getBalas().stream().filter(Bala -> !Bala.isDeleted())
      .forEach(Bala -> Bala.update());
  }
  // carga i actualiza todas las naves, mira si hay una en el borde
  for (Nave nave : Naves) {
    // si esta eliminada saltarla
    if (nave.isDeleted()) continue;
    // si esta en el borde cambiar la velocidad global a su contrario para que vallan al otro lado i moverlas todas hacia abajo
    if (nave.isInBorder()) {
      println("is in border: "+velocity);
      velocity = -velocity;
      Naves.stream().filter(Nave -> !Nave.isDeleted()).forEach(Nave -> Nave.move(0, Nave.getY()+down_velocity));
    }
  }
  // verificar si hay alguna nave en el eje y mimimo permitido, si hay terminar el juego
  Naves.stream().filter(Nave -> !Nave.isDeleted()).forEach(Nave -> {
    if(Nave.getY() > Integer.parseInt(propiedades.getProperty("game.over.to.ymin"))) game.over();
  });
  // mover todas las naves que no estan eliminadas
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
  // teclas de desarollador, solo si estan activadas
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
// objeto que tiene todas las clases de un objeto movible
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
// direcciones, normal mente usadas en las balas para indicar si van arriba o abajo
enum Direction{
  TOP,
  BOTTOM,
  LEFT,
  RIGHT;
}
// posiciones(algo como directiones) usado en Increase de MovibleObject para indicar el eje a incrementar
enum Position{
  Y,
  X,
  Y_SIZE,
  X_SIZE,
  Y_AND_SIZE,
  X_AND_SIZE;
}
