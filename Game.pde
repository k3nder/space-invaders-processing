public class Game{
  public levels level;
  public List<levels> levels;
  public boolean pause;
  public boolean lockGamePause = false;
  public boolean devtools;
  public Game(){
    loadPropertiesFile();
    lockGamePause = Boolean.parseBoolean(propiedades.getProperty("game.devtools"));
    devtools = lockGamePause;
  }
  public void pause(){
    pause = true;
  }
  public void unpause(){
    pause = false;
  }
  public void changePause(){
    if(!lockGamePause) return;
    pause = !pause;
  }
  public void over(){
    println("game over");
    textSize(128);
    fill(255, 246, 51);
    text("GAME OVER", 40, 120);
    lockGamePause = true;
    pause();
  }
  public void win(){
    println("game win");
    textSize(128);
    fill(255, 246, 51);
    text("WIN", 40, 120);
    lockGamePause = true;
    pause();
  }
}
