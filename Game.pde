import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import java.lang.reflect.Type;
import java.util.List;
import org.apache.commons.io.FileUtils;
import java.io.File;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
public class Game{
  // variable que almacena todos los status del juego
  private HashMap<String, String> statuses = new HashMap<>();
  // variable que indica si el juego esta pausado
  public boolean pause;
  // variable que indica que el pause se a bloqueado
  public boolean lockGamePause = false;
  // variable que indica si se han activado los devtools
  public boolean devtools;
  // variable que indica si se muestran los fps 
  public boolean showFPS = false;
  // lista de niveles
  public List<Level> levelsList = new ArrayList<>();
  // index del nivel actual
  public Integer levelIndex = 0;
  public Game(){
    // cargar las propiedades del juego
    loadPropertiesFile();
    // bloquear la pausa si no hay devtools activadas
    lockGamePause = Boolean.parseBoolean(propiedades.getProperty("game.devtools"));
    devtools = lockGamePause;
  }
  // methdo que pausa el juego
  public void pause(){
    pause = true;
  }
  // methodo que despausa el juego
  public void unpause(){
    pause = false;
  }
  // methodo que si se invoca cambia pause a su contrario
  public void changePause(){
    if(!lockGamePause) return;
    pause = !pause;
  }
  // methodo que hace que el juego termine i muestre un mensage
  public void over(){
    println("game over");
    textSize(128);
    fill(255, 246, 51);
    text("GAME OVER\nSPACE to restart", 40, 120);
    lockGamePause = true;
    pause();
  }
  
  // methodo que resetea el juego
  public void restart(){
    fill(204, 204, 204);
    stroke(206, 204, 205);
    rect(0,0,width,height);
    Naves = new ArrayList<>();
    setup();
    unpause();
  }
  // añade un status a mostrar
  public void addStatus(String key, Object initialValue){
    statuses.put(key,initialValue.toString());
  }
  // methodo que hace que se gane el juego
  public void win(){
    println("game win");
    textSize(128);
    fill(255, 246, 51);
    text("WIN", 40, 120);
    IsWin=true;
    lockGamePause = true;
    pause();
  }
  // saltar al anterior nivel
  public void previusLevel(){
     levelIndex--;
    if(levelIndex+1 < (levelsList.size() -1)) levelIndex++;
    restart();
  }
  // pasar al siguiente nivel
  public void nextLevel(){
    levelIndex++;
    println("next level", levelIndex, levelIndex > (levelsList.size() -1));
    if(levelIndex > (levelsList.size() -1)) levelIndex--;
    restart();
  }
  // parser de nave a Nave
  public Nave NaveConvertedOf(JNave n) {
    return new Nave(n.x, n.y, n.x_size, n.y_size);
  }
  private void loadLevels() {
  try {
        Gson gson = new Gson();
        // Obtén el tipo de la lista
        Type listaTipo = new TypeToken<List<Level>>() {}.getType();
        // Parsea el JSON a una lista de objetos Nivel
        String json = FileUtils.readFileToString(DEFAULT_LEVELS_CONFIG, StandardCharsets.UTF_8);
        levelsList = gson.fromJson(json, listaTipo);
  }
  catch(IOException e) {
    e.printStackTrace();
  }
}
// genera las naves
public void generateNaves() {
  loadLevels();
  getLevelNaves(levelsList.get(levelIndex)).stream()
    .forEach(nave -> Naves.add(NaveConvertedOf(nave)));
}
// carga todas las naves de los niveles 
private List<JNave> getLevelNaves(Level Level) {
  List<JNave> result = new ArrayList<>();
  try {
    
    Gson gson = new Gson();
    String json = FileUtils.readFileToString(new File("C:/Users/krist/Desktop/spaceinvaders/data/game/levels", Level.LevelFile), StandardCharsets.UTF_8);
    println(json);
    try{
      JLevel level = gson.fromJson(json, JLevel.class);
      result = level.naves;
      DEFAULT_CONFIG_FILE = new File("C:/Users/krist/Desktop/spaceinvaders/data", level.settings);
    } catch(NullPointerException e){
      e.printStackTrace();
    }
  }
  catch(IOException e) {
    e.printStackTrace();
  }
  return result;
}
}
