
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
final Properties propiedades = new Properties();

public static final File DEFAULT_CONFIG_FILE = new File("C:/Users/krist/Desktop/spaceinvaders/data/conf.default.properties");
public static final File DEFAULT_LEVELS_CONFIG = new File("C:/Users/krist/Desktop/spaceinvaders/data/game/levels/levels.json");
public static Boolean IsWin = false;
// true suma i false resta
public static Boolean DirectionNave = false;

public class Nave {
  private boolean deleted = false;
  int x;  // Posición inicial en el eje x
  int y;  // Posición en el eje y (constante en este ejemplo)
  int x_size;  // Longitud del lado del cuadrado
  int y_size;

  public Nave(int x, int y, int x_size, int y_size) {
    this.y = y;
    this.x = x;
    this.x_size = x_size;
    this.y_size = y_size;
  }

  public Nave() {}

  public int getX() {
    return x;
  }

  public int getY() {
    return y;
  }

  public int getXSIZE() {
    return x_size;
  }

  public int getYSIZE() {
    return y_size;
  }

  public void setDeleted(boolean del) {
    deleted = del;
  }

  public boolean isDeleted() {
    return deleted;
  }

  public void delete() {
    setDeleted(true);
  }

  private void clean() {
    noStroke();
    fill(204, 204, 204);
    rect(x, y, x_size + 2, y_size+ 2);
  }

  public boolean isInBorder() {
    if (x + (x_size + 2) > width || (2 + x) < 0) {
      return true;
    }
    return false;
  }
  public void teleport(int x,int y){
    clean();
    this.x = x;
    this.y = y;
    stroke(1.0);
    fill(299, 9, 9);
    rect(x, y, x_size + 2, y_size + 2);
  }

  public void move(int velocity,int y_) {
    clean();
    x += velocity;
    this.y = y_;
    println(velocity, y_ , y, x);
    stroke(1.0);
    fill(299, 9, 9);
    rect(x, y, x_size, y_size);
  }
  public void move(int velocity) {
    clean();
    x += velocity;
    stroke(1.0);
    fill(299, 9, 9);
    rect(x, y, x_size, y_size);
  }
}


List<Nave> Naves = new ArrayList<Nave>();

class bala{
  private float WIDTH;
  private float HEIGHT;
  private float HEIGHT2;
  private float WIDTH2;
  private Runnable onTouch = () -> {
    println("touched");
  };
  public void onTouch(Runnable run){
    onTouch = run;
  }
  public bala(jugador jugador){
    WIDTH = jugador.getWIDTH()+2;
    WIDTH2 = 3;
    HEIGHT = jugador.getHEIGHT();
    HEIGHT2 = -50;
    fill(255,255,255);
    stroke( 255, 87, 51);
    rect(WIDTH,HEIGHT,WIDTH2,HEIGHT2);
    move(1.0);
  }
  public void move(float velocity){
    int BALA_MAXIMUM_DISTANCE = Integer.parseInt(propiedades.getProperty("bala.maximum.distance"));
    moveBala(BALA_MAXIMUM_DISTANCE,1.0);
  }
  private void moveBala(int BALA_MAXIMUM_DISTANCE,float velocity) {
    boolean breaker = false;
    for(int i = 0;i <= BALA_MAXIMUM_DISTANCE;i++){
      if(breaker) break;
      ListIterator<Nave> iterator = Naves.listIterator(Naves.size());
      while(iterator.hasPrevious()){
        Nave navee = iterator.previous();
        int Heigth = navee.getX();
        int Height1 = navee.getXSIZE();
        println("bala:WIDTH: " + WIDTH);
        println("nave:WIDTH: " + Heigth);
        println("nave:WIDTH2: " + Height1);
        if(navee.isDeleted()){
          breaker = true;
          continue;
        }
        if(isInRadius(Heigth,Heigth + Height1)){
          breaker=true;
          println("touched");
          onTouch.run();
          navee.delete();
          clean();
          break;
        }
      }
      verifyWin();
      clean();
      HEIGHT -= velocity;
      HEIGHT2 -= velocity;
      //update();
    }
  }
  private void verifyWin(){
     boolean totaldelated = true;
     for(Nave nave : Naves){
       if(!nave.isDeleted()) totaldelated = false;
     }
     if(totaldelated){
          IsWin = true;
          println("game win");
          textSize(128);
          fill(255, 246, 51);
          text("WIN", 40, 120);
      }
  }
  private boolean isInRadius(int num1,int num2) {
        return WIDTH >= num1 && WIDTH <= num2;  
  }
  public void clean(){
    println("clean");
    //println(WIDTH,HEIGHT,WIDTH2,HEIGHT2);
    fill(204, 204, 204);
    stroke(206,204,205);
    rect(WIDTH,HEIGHT,WIDTH2,HEIGHT2);
    stroke(1.0);
    fill(255,255,255);
  }
  public void update(){
    clean();
    HEIGHT2 += -50;
    HEIGHT += -50;
    //println(WIDTH,HEIGHT,WIDTH2,HEIGHT2);
    stroke( 255, 87, 51);
    rect(WIDTH,HEIGHT,WIDTH2,HEIGHT2);
    println("draw in bala");

  }
}

class jugador{
  private List<bala> balas = new ArrayList<bala>();
  private float WIDTH;
  private float HEIGHT;
  public jugador(float WIDTH,float HEIGHT){
    this.WIDTH = WIDTH;
    this.HEIGHT = HEIGHT;
    float PLAYER_SIZE = Float.parseFloat(propiedades.getProperty("player.size"));
    rect(WIDTH,HEIGHT, PLAYER_SIZE,PLAYER_SIZE);
    println("player created");
  }
  public List<bala> getBalas(){
      return balas;
  }
  public void move(float pasos){
    float PLAYER_SIZE = Float.parseFloat(propiedades.getProperty("player.size"));
    println("move");
    fill(204, 204, 204);
    noStroke();
    rect(WIDTH,HEIGHT, PLAYER_SIZE+2,PLAYER_SIZE+2);
    stroke(1.0);
    this.WIDTH += pasos;
    fill(255);
    rect(WIDTH,HEIGHT, PLAYER_SIZE,PLAYER_SIZE);
  }
  void disparar(){
    bala b = new bala(this);
    balas.add(b);
    //b.clean();
  }
  float getWIDTH(){
    return WIDTH;
  }
  float getHEIGHT(){
    return HEIGHT;
  }
}
void settings(){
  println("settings");
  try{
    propiedades.load(new FileInputStream(DEFAULT_CONFIG_FILE));
  }catch(IOException e){
    println("error IO");
    System.exit(10);
  }
  int PANE_SIZE = Integer.parseInt(propiedades.getProperty("pane.size"));
  size(PANE_SIZE,PANE_SIZE);
  println("settings finish");
}


int velocity;
// el jugador principal
jugador jugador;
void setup(){
  println("setup");
  try{
    propiedades.load(new FileInputStream(DEFAULT_CONFIG_FILE));
  }catch(IOException e){
    println("error IO");
    System.exit(10);
  }
  velocity = Integer.parseInt(propiedades.getProperty("nave.velocity"));
  generateNaves();
  float PLAYER_BOTTOM_DISTANCE = Float.parseFloat(propiedades.getProperty("player.bottom.distance"));
  int ARRAY_COLUMN_SIZE = Integer.parseInt(propiedades.getProperty("array.column.size"));
  int ARRAY_LINE_SIZE = Integer.parseInt(propiedades.getProperty("array.line.size"));
  float NAVE_SEPARATION = Float.parseFloat(propiedades.getProperty("nave.separation"));
  float NAVE_DEFAULT_SIZE = Float.parseFloat(propiedades.getProperty("nave.default.size"));

  // poner las naves 
  Naves.stream().forEach(Nave -> println(Nave));
  jugador = new jugador(width/2,(height)-(PLAYER_BOTTOM_DISTANCE));
  println("setup finish");
}
void draw(){
  jugador.getBalas().stream()
    .forEach(bala -> bala.update());  
  for(Nave nave : Naves){
    if(nave.isDeleted()) continue;
    if(nave.isInBorder()){
        println("is in border: "+velocity);
        velocity = -velocity;
        Naves.stream().forEach(Nave -> Nave.move(0,Nave.getY()+10));
    }
    nave.move(velocity);
  }
}

// detectar las teclas
void keyPressed() {
  println("key presed");
  int PLAYER_STEPS = Integer.parseInt(propiedades.getProperty("player.steps"));
  if (key == CODED || keyCode == LEFT) {
      println(PLAYER_STEPS);
      jugador.move(-PLAYER_STEPS);
   } else if (key == CODED || keyCode == RIGHT) {
     jugador.move(PLAYER_STEPS);
   } else if(key == ' '){
    jugador.disparar();
  }
  println("event close");

}
public Nave NaveConvertedOf(nave n){
    return new Nave(n.x,n.y,n.x_size,n.y_size);
}
List<levels> Levels = new ArrayList<levels>();
void generateNaves(){
  loadLevels();
  for(levels Level : Levels){
    getLevelNaves(Level).stream()
      .forEach(nave -> Naves.add(NaveConvertedOf(nave)));
  }
  println(Levels.get(0));
}
private void loadLevels(){
  try{
    ConfigFile config = new ConfigFile(DEFAULT_LEVELS_CONFIG);
    List<levels> levels = config.getArrayList("levels",levels.class);
    Levels = levels;
  } catch(IOException | IllegalAccessException | InstantiationException e){
    e.printStackTrace();
  }
}
private List<nave> getLevelNaves(levels Level){
  List<nave> result = new ArrayList<nave>();
  try{
    ConfigFile LevelConfig = new ConfigFile(new File("C:/Users/krist/Desktop/spaceinvaders/data/game/levels",Level.LevelFile));
    result = LevelConfig.getArrayList("naves",nave.class);
  } catch(IOException | IllegalAccessException | InstantiationException e){
    e.printStackTrace();
  }
  return result;
}
