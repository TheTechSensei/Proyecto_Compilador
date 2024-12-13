package Analizador_Sintactico;

public enum ClaseLexica {
    // Orden EXACTO según Parser.y
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

    FUNC("FUNC"),
    STRUCT("STRUCT"),
    PROTO("PROTO"),
    PTR("PTR"),

    TRUE("TRUE"),
    FALSE("FALSE"),

    ID("ID"),

    LITERAL_ENTERA("LITERAL_ENTERA"),
    LITERAL_RUNA("LITERAL_RUNA"),
    LITERAL_FLOTANTE("LITERAL_FLOTANTE"),
    LITERAL_DOBLE("LITERAL_DOBLE"),
    LITERAL_COMPLEJA("LITERAL_COMPLEJA"),
    LITERAL_CADENA("LITERAL_CADENA"),

    PUNTO_Y_COMA("PUNTO_Y_COMA"),
    COMA("COMA"),
    PARENTESIS_IZQ("PARENTESIS_IZQ"),
    PARENTESIS_DER("PARENTESIS_DER"),
    LLAVE_IZQ("LLAVE_IZQ"),
    LLAVE_DER("LLAVE_DER"),
    CORCHETE_IZQ("CORCHETE_IZQ"),
    CORCHETE_DER("CORCHETE_DER"),
    PUNTO("PUNTO"),
    DOS_PUNTOS("DOS_PUNTOS"),

    ASIGNACION("ASIGNACION"),
    IGUALDAD("IGUALDAD"),
    MAYORQUE("MAYORQUE"),
    MENORQUE("MENORQUE"),
    MAYORIGUAL("MAYORIGUAL"),
    MENORIGUAL("MENORIGUAL"),
    DIFERENTE("DIFERENTE"),

    SUMA("SUMA"),
    RESTA("RESTA"),
    MULTIPLICACION("MULTIPLICACION"),
    DIVISION("DIVISION"),
    MODULO("MODULO"),
    DIVISION_ENTERA("DIVISION_ENTERA"),

    OR_LOGICO("OR_LOGICO"),
    AND_LOGICO("AND_LOGICO"),
    NOT_LOGICO("NOT_LOGICO"),

    OR_BIT("OR_BIT"),
    AND_BIT("AND_BIT"),
    XOR_BIT("XOR_BIT"),
    NOT_BIT("NOT_BIT"),
    SHIFT_IZQUIERDA("SHIFT_IZQUIERDA"),
    SHIFT_DERECHA("SHIFT_DERECHA"),

    EOF("EOF"),
    UNKNOWN("UNKNOWN");

    private final String nombre;

    ClaseLexica(String nombre) {
        this.nombre = nombre;
    }

    public String getNombre() {
        return nombre;
    }

    public static String getNombreClase(ClaseLexica claseLexica) {
        for (ClaseLexica clase : values()) {
            if (clase == claseLexica) {
                return clase.getNombre();
            }
        }
        return UNKNOWN.getNombre();
    }
}
