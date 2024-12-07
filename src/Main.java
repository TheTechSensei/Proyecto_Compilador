import java.io.FileReader;

/**
 * Clase principal que inicia el análisis sintáctico.
 * 
 * Esta clase contiene el método principal que se encarga de iniciar el proceso
 * de análisis sintáctico utilizando un analizador léxico y un analizador sintáctico.
 * 
 */
public class Main {
    /**
     * Método principal que inicia el análisis sintáctico.
     * 
     * @param args Argumentos de la línea de comandos. Se espera un único argumento
     *             que es el nombre del archivo de entrada.
     */
    public static void main(String[] args) {
        if (args.length != 1) {
            System.err.println("Uso: java Main <archivo_entrada>");
            System.exit(1);
        }

        try {
            Parser parser = new Parser(new FileReader(args[0]));
            parser.yyparse();
        } catch (Exception e) {
            System.err.println("Error: " + e.getMessage());
            System.exit(1);
        }
    }
}