import java.util.HashMap;
import java.util.Map;

public class TablaSimbolos {
    private Map<String, Simbolo> tabla;

    public TablaSimbolos() {
        tabla = new HashMap<>();
    }

    public void insertar(Simbolo simbolo) {
        if (tabla.containsKey(simbolo.nombre)) {
            System.err.println("Error: El identificador " + simbolo.nombre + " ya está definido.");
        } else {
            tabla.put(simbolo.nombre, simbolo);
        }
    }

    public Simbolo buscar(String nombre) {
        return tabla.get(nombre);
    }
}
