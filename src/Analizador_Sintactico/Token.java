package Analizador_Sintactico;
public class Token {
    private ClaseLexica clase;
    private String lexema;
    private int linea;

    public Token(ClaseLexica clase, String lexema, int linea) {
        this.clase = clase;
        this.lexema = lexema;
        this.linea = linea;
    }

    public ClaseLexica getClase() {
        return clase;
    }

    public String getLexema() {
        return lexema;
    }

    public int getLinea() {
        return linea;
    }

    @Override
    public String toString() {
        return "Token{" +
                "clase=" + clase +
                ", lexema='" + lexema + '\'' +
                ", linea=" + linea +
                '}';
    }
}