/**
 * Enumeración ClaseLexica que define los diferentes tipos de tokens que el
 * analizador léxico puede reconocer en el lenguaje C_1.
 * Cada constante representa una categoría de lexemas del código fuente.
 * 
 * @authors the-tech-team
 */
public enum ClaseLexica {
    // Palabras clave
    INT("INT"),
    FLOAT("FLOAT"),
    DOUBLE("DOUBLE"),
    COMPLEX("COMPLEX"),
    RUNE("RUNE"),
    VOID("VOID"),
    STRING("STRING"),
    IF("IF"),
    ELSE("ELSE"),
    WHILE("WHILE"),
    DO("DO"),
    FOR("FOR"),
    BREAK("BREAK"),
    RETURN("RETURN"),
    SWITCH("SWITCH"),
    CASE("CASE"),
    DEFAULT("DEFAULT"),
    PRINT("PRINT"),
    SCAN("SCAN"),

    // Identificadores
    ID("ID"),

    // Números
    NUMERO_ENTERO("NUMERO_ENTERO"),
    NUMERO_REAL("NUMERO_REAL"),
    LITERAL_ENTERA("LITERAL_ENTERA"),
    LITERAL_RUNA("LITERAL_RUNA"),
    LITERAL_FLOTANTE("LITERAL_FLOTANTE"),
    LITERAL_DOBLE("LITERAL_DOBLE"),
    LITERAL_COMPLEJA("LITERAL_COMPLEJA"),
    LITERAL_CADENA("LITERAL_CADENA"),

    // Símbolos y operadores
    PYC("PYC"),          // ;
    COMA("COMA"),        // ,
    LPAR("LPAR"),        // (
    RPAR("RPAR"),        // )
    LLLA("LLLA"),        // {
    RLLA("RLLA"),        // }
    ASIGNACION("ASIGNACION"), // =
    IGUALDAD("IGUALDAD"),     // ==
    DIFERENTE("DIFERENTE"),   // !=
    MAYORQUE("MAYORQUE"),     // >
    MENORQUE("MENORQUE"),     // <
    MAYORIGUAL("MAYORIGUAL"), // >=
    MENORIGUAL("MENORIGUAL"), // <=
    SUMA("SUMA"),             // +
    RESTA("RESTA"),           // -
    MULTIPLICACION("MULTIPLICACION"), // *
    DIVISION("DIVISION"),     // /
    MODULO("MODULO"),         // %

    // Operadores lógicos
    OR_LOGICO("OR_LOGICO"),   // ||
    AND_LOGICO("AND_LOGICO"), // &&
    NOT_LOGICO("NOT_LOGICO"), // !

    // Operadores bit a bit
    OR_BIT("OR_BIT"),         // |
    AND_BIT("AND_BIT"),       // &
    XOR_BIT("XOR_BIT"),       // ^
    NOT_BIT("NOT_BIT"),       // ~
    SHIFT_IZQUIERDA("SHIFT_IZQUIERDA"), // <<
    SHIFT_DERECHA("SHIFT_DERECHA"),     // >>

    // Valores booleanos
    TRUE("TRUE"),
    FALSE("FALSE"),

    // Fin de archivo
    EOF("EOF"),

    // Desconocido
    UNKNOWN("UNKNOWN");

    private final String nombre;

    /**
     * Constructor de la enumeración ClaseLexica.
     * 
     * @param nombre El nombre de la clase léxica.
     */
    ClaseLexica(String nombre) {
        this.nombre = nombre;
    }

    /**
     * Obtiene el nombre de la clase léxica.
     * 
     * @return El nombre de la clase léxica.
     */
    public String getNombre() {
        return nombre;
    }

    /**
     * Método para obtener el nombre de la clase léxica a partir de su código.
     * 
     * @param claseLexica El código de la clase léxica.
     * @return El nombre de la clase léxica.
     */
    public static String getNombreClase(ClaseLexica claseLexica) {
        for (ClaseLexica clase : values()) {
            if (clase == claseLexica) {
                return clase.getNombre();
            }
        }
        return UNKNOWN.getNombre();
    }
}
