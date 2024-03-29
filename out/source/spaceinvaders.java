/* autogenerated by Processing revision 1293 on 2024-03-01 */
import processing.core.*;
import processing.data.*;
import processing.event.*;
import processing.opengl.*;

import org.apache.commons.logging.*;
import org.apache.commons.logging.impl.*;
import net.k3nder.game.*;
import com.fasterxml.jackson.annotation.*;
import com.fasterxml.jackson.core.*;
import com.fasterxml.jackson.core.async.*;
import com.fasterxml.jackson.core.base.*;
import com.fasterxml.jackson.core.exc.*;
import com.fasterxml.jackson.core.filter.*;
import com.fasterxml.jackson.core.format.*;
import com.fasterxml.jackson.core.io.*;
import com.fasterxml.jackson.core.io.schubfach.*;
import com.fasterxml.jackson.core.json.*;
import com.fasterxml.jackson.core.json.async.*;
import com.fasterxml.jackson.core.sym.*;
import com.fasterxml.jackson.core.type.*;
import com.fasterxml.jackson.core.util.*;
import com.fasterxml.jackson.core.io.doubleparser.*;
import com.fasterxml.jackson.databind.*;
import com.fasterxml.jackson.databind.annotation.*;
import com.fasterxml.jackson.databind.cfg.*;
import com.fasterxml.jackson.databind.deser.*;
import com.fasterxml.jackson.databind.deser.impl.*;
import com.fasterxml.jackson.databind.deser.std.*;
import com.fasterxml.jackson.databind.exc.*;
import com.fasterxml.jackson.databind.ext.*;
import com.fasterxml.jackson.databind.introspect.*;
import com.fasterxml.jackson.databind.jdk14.*;
import com.fasterxml.jackson.databind.json.*;
import com.fasterxml.jackson.databind.jsonFormatVisitors.*;
import com.fasterxml.jackson.databind.jsonschema.*;
import com.fasterxml.jackson.databind.jsontype.*;
import com.fasterxml.jackson.databind.jsontype.impl.*;
import com.fasterxml.jackson.databind.module.*;
import com.fasterxml.jackson.databind.node.*;
import com.fasterxml.jackson.databind.ser.*;
import com.fasterxml.jackson.databind.ser.impl.*;
import com.fasterxml.jackson.databind.ser.std.*;
import com.fasterxml.jackson.databind.type.*;
import com.fasterxml.jackson.databind.util.*;
import com.fasterxml.jackson.databind.util.internal.*;
import net.kender.Kjson.*;
import net.kender.logger.log5k.conf.*;
import net.kender.logger.log5k.*;
import net.kender.logger.log5k.Extras.*;

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

import java.util.HashMap;
import java.util.ArrayList;
import java.io.File;
import java.io.BufferedReader;
import java.io.PrintWriter;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.IOException;

public class spaceinvaders extends PApplet {













final Properties propiedades = new Properties();

public static final File DEFAULT_CONFIG_FILE = new File("C:/Users/krist/Desktop/spaceinvaders/data/conf.default.properties");
public static final File DEFAULT_LEVELS_CONFIG = new File("C:/Users/krist/Desktop/spaceinvaders/data/game/levels/levels.json");
public static Boolean IsWin = false;
// true suma i false resta
public static Boolean DirectionNave = false;
public static Boolean pause = false;
public static levels level;

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

  public Nave() {
  }

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
    clean();
    
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
  public void teleport(int x, int y) {
    clean();
    this.x = x;
    this.y = y;
    stroke(1.0f);
    fill(299, 9, 9);
    rect(x, y, x_size + 2, y_size + 2);
  }

  public void move(int velocity, int y_) {
    clean();
    x += velocity;
    this.y = y_;
    println(velocity, y_, y, x);
    stroke(1.0f);
    fill(299, 9, 9);
    println("nave: " + this + " cords: y: " + y + " x: " + x + " x_size: " + x_size + " y_size: " + y_size);
    rect(x, y, x_size, y_size);
  }
  public void move(int velocity) {
    clean();
    x += velocity;
    stroke(1.0f);         
    fill(299, 9, 9);
    rect(x, y, x_size, y_size);
  }
}


List<Nave> Naves = new ArrayList<Nave>();

class bala {
  private boolean delated;
  private int y;
  private int x;
  private int x_size;
  private int y_size;
  private Runnable onTouch = () -> {
    println("touched");
  };
  public void onTouch(Runnable run) {
    onTouch = run;
  }
  public bala(jugador jugador) {
    y = jugador.getY()+2;
    y_size = 3;
    x = jugador.getX();
    x_size = -50;
    fill(255, 255, 255);
    stroke( 255, 87, 51);
    rect(y, x, y_size, x_size);
    move(1);
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
  public void move(int velocity) {
    int BALA_MAXIMUM_DISTANCE = Integer.parseInt(propiedades.getProperty("bala.maximum.distance"));
    moveBala(BALA_MAXIMUM_DISTANCE, velocity);
  }
  private void moveBala(int BALA_MAXIMUM_DISTANCE, int velocity) {
    boolean breaker = false;
    for (int i = 0; i <= BALA_MAXIMUM_DISTANCE; i++) {
      // TODO
      if (breaker) break;
      Naves.stream().forEach(Nave -> verifyNaveTouched(Nave));
      verifyWin();
      clean();
      x -= velocity;
      x_size -= velocity;
    }
  }
  public boolean isOutOfMap(){
    if(x <= 0) return true;
    return false;
  }
  private Boolean verifyNaveTouched(Nave nav) {
    int x = nav.getX();
    int x_size = nav.getXSIZE();
    // si la nave ya esta eliminada, pasar a otra
    if (nav.isDeleted()) return false;
    if (isInRadius(x, x_size + x)) {
      println("touched");
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
      println("game win");
      textSize(128);
      fill(255, 246, 51);
      text("WIN", 40, 120);
    }
  }
  private boolean isInRadius(int num1, int num2) {
    return y >= num1 && y <= num2;
  }
  public void clean() {
    println("clean");
    fill(204, 204, 204);
    stroke(206, 204, 205);
    rect(y, x, y_size, x_size);
    stroke(1.0f);
    fill(255, 255, 255);
  }
  public void update() {
    clean();
    x_size += -50;
    x += -50;
    //println(WIDTH,HEIGHT,WIDTH2,HEIGHT2);
    stroke( 255, 87, 51);
    rect(y, x, y_size, x_size);
    println("draw in bala");
  }
  public boolean isDelated(){
    return delated;
  }
  public void delete(){
    delated = true;
    clean();
  }
}

class jugador extends MovibleObject{
  private List<bala> balas = new ArrayList<bala>();
  public jugador(int y, int x) {
    this.y = y;
    this.x = x;
    float PLAYER_SIZE = Float.parseFloat(propiedades.getProperty("player.size"));
    rect(y, x, PLAYER_SIZE, PLAYER_SIZE);
    println("player created");
  }
  public List<bala> getBalas() {
    return balas;
  }
  public void move(int pasos) {
    int PLAYER_SIZE = Integer.parseInt(propiedades.getProperty("player.size"));
    println("move");
    fill(204, 204, 204);
    noStroke();
    rect(y, x, PLAYER_SIZE+2, PLAYER_SIZE+2);
    stroke(1.0f);
    this.y += pasos;
    fill(255);
    rect(y, x, PLAYER_SIZE, PLAYER_SIZE);
  }
  public void disparar() {
    bala b = new bala(this);
    balas.add(b);
  }
  public int getY() {
    return y;
  }
  public int getX() {
    return x;
  }
}
public void settings() {
  println("settings");
  loadPropertiesFile();
  int PANE_SIZE = Integer.parseInt(propiedades.getProperty("pane.size"));
  size(PANE_SIZE, PANE_SIZE);
  println("settings finish");
}
private void loadPropertiesFile(){
  try {
    propiedades.load(new FileInputStream(DEFAULT_CONFIG_FILE));
  }
  catch(IOException e) {
    println("error IO");
    System.exit(10);
  }
}

int velocity;
// el jugador principal
jugador jugador;
public void setup() {
  println("setup");
  loadPropertiesFile();
  velocity = Integer.parseInt(propiedades.getProperty("nave.velocity"));
  velocity = 8;
  generateNaves();
  int PLAYER_BOTTOM_DISTANCE = Integer.parseInt(propiedades.getProperty("player.bottom.distance"));
  /////int ARRAY_COLUMN_SIZE = Integer.parseInt(propiedades.getProperty("array.column.size"));
  /////int ARRAY_LINE_SIZE = Integer.parseInt(propiedades.getProperty("array.line.size"));
  /////float NAVE_SEPARATION = Float.parseFloat(propiedades.getProperty("nave.separation"));
  /////float NAVE_DEFAULT_SIZE = Float.parseFloat(propiedades.getProperty("nave.default.size"));

  // poner las naves
  Naves.stream().forEach(Nave -> println(Nave));
  jugador = new jugador(width/2, (height)-(PLAYER_BOTTOM_DISTANCE));
  println("setup finish"); 
}
public void draw() {
  println("velocity: " + velocity);
  if(pause) return;
  noStroke();
  fill(204, 204, 204);
  rect(502, 140,400,-100);
  fill(204, 204, 255);
  stroke(1.0f);
  textSize(128);
  text(frameRate , 500, 120);
  // cargar todas las balas
  jugador.getBalas().stream().filter(bala -> !bala.isDelated())
    .forEach(bala -> bala.update());
  // carga i actualiza todas las naves, mira si hay una en el borde
  for (Nave nave : Naves) {
    if (nave.isDeleted()) continue;
    if (nave.isInBorder()) {
      println("is in border: "+velocity);
      velocity = -velocity;
      //Naves.stream().filter(Nave -> !Nave.isDeleted()).forEach(Nave -> Nave.move(0, Nave.getY()+10));
      //nave.move(velocity);
      
    }
    delay(10);
    nave.move(velocity);
  }
}

// detectar las teclas
public void keyPressed() {
  println("key presed");
  int PLAYER_STEPS = Integer.parseInt(propiedades.getProperty("player.steps"));
  if (keyCode == LEFT) {
    println(PLAYER_STEPS);
    jugador.move(-PLAYER_STEPS);
  } else if (keyCode == RIGHT) {
    jugador.move(PLAYER_STEPS);
  } else if (key == ' ') {
    jugador.disparar();
  } else if(key == 'p'){
    pause = !pause;
  }
  println("event close");
}
// parser de nave a Nave
public Nave NaveConvertedOf(nave n) {
  return new Nave(n.x, n.y, n.x_size, n.y_size);
}
// carga todos los nives i las naves
List<levels> Levels = new ArrayList<levels>();
public void generateNaves() {
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
  protected Integer x;
  protected Integer y;
  protected Integer x_size;
  protected Integer y_size;
  public void clean(){
    fill(204, 204, 204);
    stroke(206, 204, 205);
    rect(y, x, y_size, x_size);
    stroke(1.0f);
    fill(255, 255, 255);
  }
  public void show(){
    rect(y, x, x_size, y_size);
  }
  private void update(){
    clean();
    show();
  }
  public void Increase(Positon pos, Integer velocity){
    if(pos == Position.Y) IncreaseY(velocity);
    if(pos == Position.X) IncreaseX(velocity);
  }
  protected void IncreaseX(Integer velocity){
    x += velocity;
    x_size += velocity;
  }
  protected void IncreaseY(Integer velocity){
    y += velocity;
    y_size += velocity;
  }
}
final enum Position{
  Y,
  X;
}


  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "spaceinvaders" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
