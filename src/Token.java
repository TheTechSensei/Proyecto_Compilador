/**
 * Clase Token que representa un token en el análisis léxico.
 * 
 * @authors the-tech-team
 */
public class Token {
    private ClaseLexica clase;
    private String lexema;
    private int linea;

    /**
     * Constructor de la clase Token.
     * 
     * @param clase  La clase léxica del token.
     * @param lexema El lexema del token.
     * @param linea  La línea en la que se encuentra el token.
     * @throws IllegalArgumentException Si el lexema es nulo o vacío, o si la línea
     *                                  es negativa.
     */
    public Token(ClaseLexica clase, String lexema, int linea) {
        if (lexema == null || lexema.isEmpty()) {
            throw new IllegalArgumentException("El lexema no puede ser nulo o vacío.");
        }
        if (linea < 0) {
            throw new IllegalArgumentException("La línea no puede ser negativa.");
        }
        this.clase = clase;
        this.lexema = lexema;
        this.linea = linea;
    }

    /**
     * Obtiene la clase léxica del token.
     * 
     * @return La clase léxica del token.
     */
    public ClaseLexica getClaseLexica() {
        return clase;
    }

    /**
     * Obtiene el lexema del token.
     * 
     * @return El lexema del token.
     */
    public String getLexema() {
        return lexema;
    }

    /**
     * Obtiene la línea en la que se encuentra el token.
     * 
     * @return La línea del token.
     */
    public int getLinea() {
        return linea;
    }

    /**
     * Devuelve una representación en cadena del token.
     * 
     * @return Una cadena que representa el token en el formato "<clase, lexema, linea>".
     */
    @Override
    public String toString() {
        return "<" + this.clase.getNombre() + "," + this.lexema + "," + this.linea + ">";
    }

    /**
     * Verifica si el token es de una clase léxica específica.
     * 
     * @param clase La clase léxica a verificar.
     * @return true si el token es de la clase léxica especificada, 
     *         false en caso contrario.
     */
    public boolean esDeClase(ClaseLexica clase) {
        return this.clase == clase;
    }

    /**
     * Compara este token con otro token.
     * 
     * @param otro El otro token a comparar.
     * @return true si ambos tokens son iguales, 
     *         false en caso contrario.
     */
    public boolean equals(Token otro) {
        return this.clase == otro.clase && this.lexema.equals(otro.lexema) && this.linea == otro.linea;
    }

    /**
     * Verifica el token y lo imprime en pantalla.
     */
    public void verificarImprimirToken() {

        String mensaje;

        if (this.clase == ClaseLexica.UNKNOWN || this.lexema == null || this.lexema.isEmpty()) {
            mensaje = "\nToken inválido: " + this.toString();
        } else {
            mensaje = "\nToken válido: " + this.toString();
        }

        System.out.println(mensaje);
    }
}