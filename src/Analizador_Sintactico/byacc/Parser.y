%{
import java.io.*;
import Analizador_Sintactico.*;
%}

/* Símbolo inicial de la gramática */
%start programa

/* Declaración de tokens (sin <token>) */
%token INT FLOAT DOUBLE COMPLEX RUNE VOID STRING
%token IF ELSE WHILE DO FOR BREAK RETURN SWITCH CASE DEFAULT PRINT SCAN
%token FUNC STRUCT PROTO PTR
%token TRUE FALSE
%token ID
%token LITERAL_ENTERA LITERAL_RUNA LITERAL_FLOTANTE LITERAL_DOBLE LITERAL_COMPLEJA LITERAL_CADENA
%token PUNTO_Y_COMA COMA PARENTESIS_IZQ PARENTESIS_DER LLAVE_IZQ LLAVE_DER CORCHETE_IZQ CORCHETE_DER PUNTO DOS_PUNTOS
%token ASIGNACION IGUALDAD MAYORQUE MENORQUE MAYORIGUAL MENORIGUAL DIFERENTE
%token SUMA RESTA MULTIPLICACION DIVISION MODULO DIVISION_ENTERA
%token OR_LOGICO AND_LOGICO NOT_LOGICO
%token OR_BIT AND_BIT XOR_BIT NOT_BIT SHIFT_IZQUIERDA SHIFT_DERECHA
%token EOF UNKNOWN

/* Precedencia y asociatividad de operadores */
%left OR_LOGICO
%left AND_LOGICO
%left OR_BIT
%left XOR_BIT
%left AND_BIT
%left IGUALDAD DIFERENTE
%left MAYORQUE MENORQUE MAYORIGUAL MENORIGUAL
%left SHIFT_IZQUIERDA SHIFT_DERECHA
%left SUMA RESTA
%left MULTIPLICACION DIVISION MODULO DIVISION_ENTERA
%right NOT_LOGICO NOT_BIT
%nonassoc PARENTESIS_IZQ PARENTESIS_DER CORCHETE_IZQ CORCHETE_DER PUNTO

%%
/* Reglas de producción */

// Sin $$ ni $n, solo acciones vacías o mensajes.

programa : decl_proto decl_var decl_func EOF 
        { System.out.println("\nPrograma analizado correctamente."); }
        ;

decl_proto : PROTO tipo ID PARENTESIS_IZQ argumentos PARENTESIS_DER PUNTO_Y_COMA decl_proto 
           { /* Declaración de proto procesada */ }
           | /* ε */
           { /* epsilon en decl_proto */ }
           ;

decl_var : tipo lista_var PUNTO_Y_COMA decl_var 
         { /* Declaración de variable procesada */ }
         | /* ε */
         { /* epsilon en decl_var */ }
         ;

decl_func : FUNC tipo ID PARENTESIS_IZQ argumentos PARENTESIS_DER bloque decl_func 
          { /* Declaración de función procesada */ }
          | /* ε */
          { /* epsilon en decl_func */ }
          ;

tipo : basico compuesto 
     { /* Tipo básico compuesto */ }
     | STRUCT LLAVE_IZQ decl_var LLAVE_DER
     { /* Tipo struct procesado */ }
     | puntero
     { /* Tipo puntero procesado */ }
     ;

puntero : PTR basico
        { /* Puntero a tipo básico */ }
        ;

basico : INT { /* Tipo INT */ }
       | FLOAT { /* Tipo FLOAT */ }
       | DOUBLE { /* Tipo DOUBLE */ }
       | COMPLEX { /* Tipo COMPLEX */ }
       | RUNE { /* Tipo RUNE */ }
       | VOID { /* Tipo VOID */ }
       | STRING { /* Tipo STRING */ }
       ;

compuesto : CORCHETE_IZQ LITERAL_ENTERA CORCHETE_DER compuesto
          { /* Tipo compuesto (arreglo) */ }
          | /* ε */
          { /* epsilon en compuesto */ }
          ;

lista_var : lista_var COMA ID 
          { /* Lista de variables extendida */ }
          | ID
          { /* Variable declarada */ }
          ;

argumentos : lista_args 
           { /* Argumentos procesados */ }
           | /* ε */
           { /* epsilon en argumentos */ }
           ;

lista_args : lista_args COMA tipo ID
           { /* Lista de argumentos extendida */ }
           | tipo ID
           { /* Argumento simple procesado */ }
           ;

bloque : LLAVE_IZQ declaraciones instrucciones LLAVE_DER
       { /* Bloque procesado */ }
       ;

declaraciones : declaraciones declaracion
               { /* Declaraciones múltiples procesadas */ }
               | /* ε */ 
               { /* epsilon en declaraciones */ }
               ;

declaracion : tipo lista_var PUNTO_Y_COMA
            { /* Declaración simple procesada */ }
            ;

instrucciones : instrucciones sentencia
              { /* Instrucciones múltiples procesadas */ }
              | sentencia
              { /* Instrucción simple procesada */ }
              ;

sentencia : IF PARENTESIS_IZQ exp PARENTESIS_DER sentencia
          { /* Sentencia IF procesada */ }
          | IF PARENTESIS_IZQ exp PARENTESIS_DER sentencia ELSE sentencia
          { /* Sentencia IF-ELSE procesada */ }
          | WHILE PARENTESIS_IZQ exp PARENTESIS_DER sentencia
          { /* Sentencia WHILE procesada */ }
          | DO sentencia WHILE PARENTESIS_IZQ exp PARENTESIS_DER PUNTO_Y_COMA
          { /* Sentencia DO-WHILE procesada */ }
          | BREAK PUNTO_Y_COMA
          { /* Sentencia BREAK procesada */ }
          | bloque
          { /* Sentencia bloque procesada */ }
          | RETURN exp PUNTO_Y_COMA
          { /* Sentencia RETURN con expresión */ }
          | RETURN PUNTO_Y_COMA
          { /* Sentencia RETURN simple */ }
          | SWITCH PARENTESIS_IZQ exp PARENTESIS_DER LLAVE_IZQ casos LLAVE_DER
          { /* Sentencia SWITCH procesada */ }
          | PRINT exp PUNTO_Y_COMA
          { /* Sentencia PRINT procesada */ }
          | SCAN parte_izquierda PUNTO_Y_COMA
          { /* Sentencia SCAN procesada */ }
          | parte_izquierda ASIGNACION exp PUNTO_Y_COMA
          { /* Sentencia de asignación procesada */ }
          ;

// Nueva estructura para evitar conflictos:
// En vez de casos con 4 opciones, lo partimos en dos opcionales: lista_casos_opt y predeterminado_opt.
casos : lista_casos_opt predeterminado_opt
      { /* casos procesados */ }
      ;

lista_casos_opt : lista_casos
                { /* lista_casos opcional */ }
                | /* ε */
                { /* epsilon en lista_casos_opt */ }
                ;

predeterminado_opt : predeterminado
                   { /* predeterminado opcional */ }
                   | /* ε */
                   { /* epsilon en predeterminado_opt */ }
                   ;

lista_casos : lista_casos caso
            { /* lista_casos extendida */ }
            | caso
            { /* lista_casos simple */ }
            ;

caso : CASE opcion DOS_PUNTOS instrucciones
     { /* caso procesado */ }
     ;

opcion : LITERAL_ENTERA 
       { /* Opción literal entera */ }
       | LITERAL_RUNA
       { /* Opción literal runa */ }
       ;

predeterminado : DEFAULT DOS_PUNTOS instrucciones
               { /* predeterminado procesado */ }
               ;

parte_izquierda : ID localizacion
                { /* Parte izquierda con localización */ }
                | ID
                { /* Parte izquierda simple (ID) */ }
                ;

localizacion : arreglo 
             { /* Localización tipo arreglo */ }
             | estructurado 
             { /* Localización tipo estructurado */ }
             ;

arreglo : CORCHETE_IZQ exp CORCHETE_DER arreglo
        { /* Arreglo con múltiples índices procesado */ }
        | CORCHETE_IZQ exp CORCHETE_DER
        { /* Arreglo simple procesado */ }
        ;

estructurado : PUNTO ID estructurado
             { /* Estructura anidada procesada */ }
             | PUNTO ID
             { /* Acceso a campo de estructura procesado */ }
             ;

exp : exp OR_LOGICO exp_and
    { /* Expresión con OR lógico */ }
    | exp_and
    { /* Expresión AND base */ }
    ;

exp_and : exp_and AND_LOGICO exp_or_bit
        { /* Expresión con AND lógico */ }
        | exp_or_bit
        { /* Expresión OR bit base */ }
        ;

exp_or_bit : exp_or_bit OR_BIT exp_xor_bit
           { /* Expresión con OR bit a bit */ }
           | exp_xor_bit
           { /* Expresión XOR bit base */ }
           ;

exp_xor_bit : exp_xor_bit XOR_BIT exp_and_bit
            { /* Expresión con XOR bit a bit */ }
            | exp_and_bit
            { /* Expresión AND bit base */ }
            ;

exp_and_bit : exp_and_bit AND_BIT exp_igualdad
            { /* Expresión con AND bit a bit */ }
            | exp_igualdad
            { /* Expresión igualdad base */ }
            ;

exp_igualdad : exp_igualdad IGUALDAD exp_relacional
             { /* Expresión con IGUALDAD */ }
             | exp_igualdad DIFERENTE exp_relacional
             { /* Expresión con DIFERENTE */ }
             | exp_relacional
             { /* Expresión relacional base */ }
             ;

exp_relacional : exp_relacional MENORQUE exp_shift
               { /* Expresión con MENORQUE */ }
               | exp_relacional MAYORQUE exp_shift
               { /* Expresión con MAYORQUE */ }
               | exp_relacional MENORIGUAL exp_shift
               { /* Expresión con MENORIGUAL */ }
               | exp_relacional MAYORIGUAL exp_shift
               { /* Expresión con MAYORIGUAL */ }
               | exp_shift
               { /* Expresión shift base */ }
               ;

exp_shift : exp_shift SHIFT_IZQUIERDA exp_aditiva
          { /* Expresión con SHIFT IZQUIERDA */ }
          | exp_shift SHIFT_DERECHA exp_aditiva
          { /* Expresión con SHIFT DERECHA */ }
          | exp_aditiva
          { /* Expresión aditiva base */ }
          ;

exp_aditiva : exp_aditiva SUMA exp_multiplicativa
            { /* Expresión con SUMA */ }
            | exp_aditiva RESTA exp_multiplicativa
            { /* Expresión con RESTA */ }
            | exp_multiplicativa
            { /* Expresión multiplicativa base */ }
            ;

exp_multiplicativa : exp_multiplicativa MULTIPLICACION exp_unaria
                   { /* Expresión con MULTIPLICACION */ }
                   | exp_multiplicativa DIVISION exp_unaria
                   { /* Expresión con DIVISION */ }
                   | exp_multiplicativa MODULO exp_unaria
                   { /* Expresión con MODULO */ }
                   | exp_multiplicativa DIVISION_ENTERA exp_unaria
                   { /* Expresión con DIVISION ENTERA */ }
                   | exp_unaria
                   { /* Expresión unaria base */ }
                   ;

exp_unaria : RESTA exp_unaria
           { /* Expresión unaria con RESTA */ }
           | NOT_LOGICO exp_unaria
           { /* Expresión unaria con NOT lógico */ }
           | NOT_BIT exp_unaria
           { /* Expresión unaria con NOT bit */ }
           | exp_primaria
           { /* Expresión primaria base */ }
           ;

exp_primaria : PARENTESIS_IZQ exp PARENTESIS_DER
             { /* Expresión primaria con paréntesis */ }
             | ID localizacion
             { /* Expresión primaria con ID y localización */ }
             | ID PARENTESIS_IZQ parametros PARENTESIS_DER
             { /* Expresión primaria llamada a función */ }
             | ID
             { /* Expresión primaria ID */ }
             | FALSE
             { /* Expresión primaria FALSE */ }
             | TRUE
             { /* Expresión primaria TRUE */ }
             | LITERAL_ENTERA
             { /* Expresión primaria literal entera */ }
             | LITERAL_RUNA
             { /* Expresión primaria literal runa */ }
             | LITERAL_FLOTANTE
             { /* Expresión primaria literal flotante */ }
             | LITERAL_DOBLE
             { /* Expresión primaria literal doble */ }
             | LITERAL_COMPLEJA
             { /* Expresión primaria literal compleja */ }
             | LITERAL_CADENA
             { /* Expresión primaria literal cadena */ }
             ;

parametros : lista_param
            { /* Parámetros procesados */ }
            | /* ε */
            { /* epsilon en parámetros */ }
            ;

lista_param : lista_param COMA exp
            { /* Lista de parámetros extendida */ }
            | exp
            { /* Lista de parámetros simple */ }
            ;

%%

/* Código de soporte */
private Lexer lexer;           
private Token currentToken;    

public Parser(Reader input) {
    lexer = new Lexer(input);
    System.out.println("\nInicio del análisis sintáctico");
}

private void yyerror(String msg) {
    System.out.println("\nError sintáctico en línea " +
        (currentToken != null ? currentToken.getLinea() : "desconocida") +
        ": " + msg +
        "\nToken actual: " + (currentToken != null ? currentToken.getLexema() : "null"));
}

private int yylex() {
    try {
        currentToken = lexer.yylex();
        if (currentToken == null) {
            System.out.println("\nFin de archivo alcanzado");
            return 0; // EOF
        }
        yylval = new ParserVal(currentToken);
        return currentToken.getClase().ordinal() + 257;
    } catch (IOException e) {
        System.out.println("Error de lectura: " + e.getMessage());
        return -1;
    }
}

public static void main(String args[]) {
    if (args.length < 1) {
        System.err.println("Uso: java Parser <archivo_entrada>");
        System.exit(1);
    }

    try {
        Parser parser = new Parser(new FileReader(args[0]));
        parser.yyparse();
    } catch (FileNotFoundException e) {
        System.err.println("Error: No se puede abrir el archivo " + args[0]);
    }
}
