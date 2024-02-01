import java.lang.reflect.Field;
import PropertiesClass;
public class ObjectPropertiesMapper{
  public <T> T Parse(File file,Class<T> Classe){
    if(!file.exists()) throw new IllegalArgumentException("se esta intendato aceder a " + file.getName() + " peso este archivo/directorio no existe");
    if(PropertiesClass.class.isAssignableFrom(Classe))
    for(Field field : Classe.getDeclaredFields()){
    
    }
  }
}
