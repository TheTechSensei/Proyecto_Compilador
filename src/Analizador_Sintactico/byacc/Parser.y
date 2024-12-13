%{
import java.io.*;
import Analizador_Sintactico.*;
%}

/* Símbolo inicial de la gramática */
%start programa

/* Declaración de tokens */
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
%nonassoc ASIGNACION
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
%nonassoc IF
%right ELSE

%%
/* Reglas de producción */

programa : decl_proto decl_tipo decl_var decl_func EOF 
        { System.out.println("\nPrograma analizado correctamente."); }
        ;

/* Declaración de prototipos de funciones */
decl_proto : PROTO tipo ID PARENTESIS_IZQ argumentos PARENTESIS_DER PUNTO_Y_COMA decl_proto 
           { /* Declaración de proto procesada */ }
           | /* ε */
           { /* epsilon en decl_proto */ }
           ;

/* Declaración de tipos estructurados con nombre a nivel superior */
decl_tipo : STRUCT ID LLAVE_IZQ decl_var LLAVE_DER PUNTO_Y_COMA decl_tipo
          { /* Declaración de struct con nombre procesada */ }
          | /* ε */
          { /* epsilon en decl_tipo */ }
          ;

/* Declaración de variables globales */
decl_var : tipo lista_inis PUNTO_Y_COMA decl_var 
         { /* Declaración de variable con potencial inicialización procesada */ }
         | /* ε */
         { /* epsilon en decl_var */ }
         ;

/* Declaración de funciones */
decl_func : FUNC tipo ID PARENTESIS_IZQ argumentos PARENTESIS_DER bloque decl_func 
          { /* Declaración de función procesada */ }
          | /* ε */
          { /* epsilon en decl_func */ }
          ;

tipo : basico compuesto
     | STRUCT LLAVE_IZQ decl_var LLAVE_DER
     | STRUCT ID
     | puntero
     | ID  
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

/* Lista de inicializaciones en declaraciones de variables */
lista_inis : lista_inis COMA ini_var 
           { /* Lista de variables extendida */ }
           | ini_var
           { /* Variable inicializada o no */ }
           ;

ini_var : ID
        { /* Variable sin inicializar */ }
        | ID ASIGNACION init_val
        { /* Variable con inicialización */ }
        ;

init_val : exp
         { /* Inicialización simple con expresión */ }
         | LLAVE_IZQ lista_exps LLAVE_DER
         { /* Inicialización tipo {exp, exp, ...} */ }
         ;

lista_exps : lista_exps COMA exp
           { /* Lista de expresiones extendida */ }
           | exp
           { /* Lista de expresiones simple */ }
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

declaracion : tipo lista_inis PUNTO_Y_COMA
            { /* Declaración simple procesada */ }
            ;

instrucciones : instrucciones sentencia
              { /* Instrucciones múltiples procesadas */ }
              | sentencia
              { /* Instrucción simple procesada */ }
              ;

sentencia : if_sentencia
          { /* Sentencia procesada */ }
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
          | ID ASIGNACION exp PUNTO_Y_COMA
          | ID localizacion ASIGNACION exp PUNTO_Y_COMA
          | ID PARENTESIS_IZQ parametros PARENTESIS_DER PUNTO_Y_COMA
          { /* Llamada a función como sentencia */ }
          ;

if_sentencia : IF PARENTESIS_IZQ exp PARENTESIS_DER sentencia else_parte %prec IF
             { /* Sentencia IF procesada */ }
             ;

else_parte : ELSE sentencia
           { /* Sentencia ELSE procesada */ }
           | /* ε */
           { /* epsilon en else_parte */ }
           ;

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
             | estructurado
             | /* ε - Eliminamos la localización vacía */
             ;

arreglo : CORCHETE_IZQ exp CORCHETE_DER arreglo
        | CORCHETE_IZQ exp CORCHETE_DER
        ;

estructurado : PUNTO ID estructurado
             | PUNTO ID
             ;

exp : exp OR_LOGICO exp
    | exp AND_LOGICO exp
    | exp OR_BIT exp
    | exp XOR_BIT exp
    | exp AND_BIT exp
    | exp IGUALDAD exp
    | exp DIFERENTE exp
    | exp MENORQUE exp
    | exp MAYORQUE exp
    | exp MENORIGUAL exp
    | exp MAYORIGUAL exp
    | exp SHIFT_IZQUIERDA exp
    | exp SHIFT_DERECHA exp
    | exp SUMA exp
    | exp RESTA exp
    | exp MULTIPLICACION exp
    | exp DIVISION exp
    | exp MODULO exp
    | exp DIVISION_ENTERA exp
    | exp_unaria
    ;

exp_unaria : RESTA exp_unaria
           | NOT_LOGICO exp_unaria
           | NOT_BIT exp_unaria
           | exp_primaria
           ;

exp_primaria : PARENTESIS_IZQ exp PARENTESIS_DER
             | ID CORCHETE_IZQ exp CORCHETE_DER  
             | ID PUNTO ID                    
             | ID PARENTESIS_IZQ parametros PARENTESIS_DER 
             | ID                             
             | FALSE
             | TRUE
             | LITERAL_ENTERA
             | LITERAL_RUNA
             | LITERAL_FLOTANTE
             | LITERAL_DOBLE
             | LITERAL_COMPLEJA
             | LITERAL_CADENA
             ;
parametros : lista_param
            | /* ε */
            ;

lista_param : lista_param COMA exp
            | exp
            ;

%%

/* Código de soporte */
private Lexer lexer;
private Analizador_Sintactico.Token currentToken;

public Parser(Reader input) {
    lexer = new Lexer(input);
    System.out.println("\nIniciando el análisis sintáctico... ⏳");
}

private void yyerror(String msg) {
    System.out.println("\n❌ Error sintáctico en línea " +
        (currentToken != null ? currentToken.getLinea() : "desconocida") +
        ": " + msg +
        "\nToken actual: " + (currentToken != null ? currentToken.getLexema() : "null"));
}

private int yylex() {
    try {
        currentToken = lexer.yylex();
        if (currentToken == null) {
            System.out.println("\nFin de archivo alcanzado 📜");
            return 0; // EOF
        }
        yylval = new ParserVal(currentToken);
        return currentToken.getClase().ordinal() + 257;
    } catch (IOException e) {
        System.out.println("\n❌ Error de lectura: " + e.getMessage());
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
