%{
/* Importaciones necesarias para el analizador */
import java.io.*;
import src.Analizador_Sintactico_BYACCJ.*;
%}

/* Símbolo inicial de la gramática */
%start programa

/* Declaración de tokens y sus tipos */
%token <token> INT FLOAT DOUBLE COMPLEX RUNE VOID STRING
%token <token> IF ELSE WHILE DO FOR BREAK RETURN SWITCH CASE DEFAULT PRINT SCAN
%token <token> FUNC STRUCT PROTO PTR
%token <token> TRUE FALSE
%token <token> ID
%token <token> LITERAL_ENTERA LITERAL_RUNA LITERAL_FLOTANTE LITERAL_DOBLE LITERAL_COMPLEJA LITERAL_CADENA
%token <token> PUNTO_Y_COMA COMA PARENTESIS_IZQ PARENTESIS_DER LLAVE_IZQ LLAVE_DER CORCHETE_IZQ CORCHETE_DER PUNTO DOS_PUNTOS
%token <token> ASIGNACION IGUALDAD MAYORQUE MENORQUE MAYORIGUAL MENORIGUAL DIFERENTE
%token <token> SUMA RESTA MULTIPLICACION DIVISION MODULO DIVISION_ENTERA
%token <token> OR_LOGICO AND_LOGICO NOT_LOGICO
%token <token> OR_BIT AND_BIT XOR_BIT NOT_BIT SHIFT_IZQUIERDA SHIFT_DERECHA
%token <token> EOF UNKNOWN

%type <token> programa
%type <token> decl_proto
%type <token> decl_var
%type <token> decl_func
%type <token> tipo
%type <token> basico
%type <token> puntero
%type <token> compuesto
%type <token> lista_var
%type <token> argumentos
%type <token> lista_args
%type <token> bloque
%type <token> declaracion
%type <token> instrucciones
%type <token> sentencia
%type <token> casos
%type <token> caso
%type <token> opcion
%type <token> predeterminado
%type <token> parte_izquierda
%type <token> localizacion
%type <token> arreglo
%type <token> estructurado
%type <token> exp
%type <token> exp_and
%type <token> exp_or_bit
%type <token> exp_xor_bit
%type <token> exp_and_bit
%type <token> exp_igualdad
%type <token> exp_relacional
%type <token> exp_shift
%type <token> exp_aditiva
%type <token> exp_multiplicativa
%type <token> exp_unaria
%type <token> exp_primaria
%type <token> parametros
%type <token> lista_param

/* Precedencia y asociatividad de operadores (de menor a mayor precedencia) */
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
/* Reglas de producción de la gramática con acciones semánticas */

/**
 * Regla inicial del programa
 * Se verifica la estructura general del programa
 */
programa : decl_proto decl_var decl_func EOF
        {
          System.out.println("\nPrograma analizado correctamente.");
          $$ = new ParserVal(new Token(ClaseLexica.ID, "programa", yylineno));
        }
        ;

decl_proto : proto tipo ID PARENTESIS_IZQ argumentos PARENTESIS_DER PUNTO_Y_COMA decl_proto
           {
             $$ = new ParserVal(new Token(ClaseLexica.PROTO, "decl_proto", yylineno));
           }
           | /* ε */
           {
             $$ = new ParserVal(new Token(ClaseLexica.PROTO, "epsilon", yylineno));
           }
           ;

decl_var : tipo lista_var PUNTO_Y_COMA decl_var
         { $$ = new ParserVal(new Token(ClaseLexica.ID, "decl_var", yylineno));}
         | /* ε */ { $$ = new ParserVal(new Token(ClaseLexica.ID, "epsilon", yylineno)); }
         ;

decl_func : FUNC tipo ID PARENTESIS_IZQ argumentos PARENTESIS_DER bloque decl_func
          { $$ = new ParserVal(new Token(ClaseLexica.FUNC, "decl_func", yylineno)); }
          | /* ε */
          { $$ = new ParserVal(new Token(ClaseLexica.FUNC, "epsilon", yylineno)); }
          ;

tipo : basico compuesto
     | STRUCT LLAVE_IZQ decl_var LLAVE_DER
     | puntero
     ;

puntero : PTR basico
        ;

basico : INT
       | FLOAT
       | DOUBLE
       | COMPLEX
       | RUNE
       | VOID
       | STRING
       ;

compuesto : CORCHETE_IZQ LITERAL_ENTERA CORCHETE_DER compuesto
          | /* ε */
          ;

lista_var : lista_var COMA ID
          | ID
          ;

argumentos : lista_args
           | /* ε */
           ;

lista_args : lista_args COMA tipo ID
           | tipo ID
           ;

bloque : LLAVE_IZQ declaraciones instrucciones LLAVE_DER
       { $$ = new ParserVal(new Token(ClaseLexica.LLAVE_IZQ, "bloque", yylineno)); }
       ;

declaraciones : declaraciones declaracion
               { $$ = new ParserVal(new Token(ClaseLexica.ID, "declaraciones", yylineno));}
               | /* ε */ { $$ = new ParserVal(new Token(ClaseLexica.ID, "epsilon", yylineno)); }
               ;

declaracion : tipo lista_var PUNTO_Y_COMA
            { $$ = new ParserVal(new Token(ClaseLexica.ID, "declaracion", yylineno)); }
            ;

instrucciones : instrucciones sentencia
              { $$ = new ParserVal(new Token(ClaseLexica.ID, "instrucciones", yylineno)); }
              | sentencia
              { $$ = $1; }
              ;

sentencia : IF PARENTESIS_IZQ exp PARENTESIS_DER sentencia
          { $$ = new ParserVal(new Token(ClaseLexica.IF, "sentencia", yylineno)); }
          | IF PARENTESIS_IZQ exp PARENTESIS_DER sentencia ELSE sentencia
          { $$ = new ParserVal(new Token(ClaseLexica.IF, "sentencia", yylineno)); }
          | WHILE PARENTESIS_IZQ exp PARENTESIS_DER sentencia
          { $$ = new ParserVal(new Token(ClaseLexica.WHILE, "sentencia", yylineno)); }
          | DO sentencia WHILE PARENTESIS_IZQ exp PARENTESIS_DER PUNTO_Y_COMA
          { $$ = new ParserVal(new Token(ClaseLexica.DO, "sentencia", yylineno)); }
          | BREAK PUNTO_Y_COMA
          { $$ = new ParserVal(new Token(ClaseLexica.BREAK, "sentencia", yylineno)); }
          | bloque
          { $$ = $1; }
          | RETURN exp PUNTO_Y_COMA
          { $$ = new ParserVal(new Token(ClaseLexica.RETURN, "sentencia", yylineno)); }
          | RETURN PUNTO_Y_COMA
          { $$ = new ParserVal(new Token(ClaseLexica.RETURN, "sentencia", yylineno)); }
          | SWITCH PARENTESIS_IZQ exp PARENTESIS_DER LLAVE_IZQ casos LLAVE_DER
          { $$ = new ParserVal(new Token(ClaseLexica.SWITCH, "sentencia", yylineno)); }
          | PRINT exp PUNTO_Y_COMA
          { $$ = new ParserVal(new Token(ClaseLexica.PRINT, "sentencia", yylineno)); }
          | SCAN parte_izquierda PUNTO_Y_COMA
          { $$ = new ParserVal(new Token(ClaseLexica.SCAN, "sentencia", yylineno)); }
          | parte_izquierda ASIGNACION exp PUNTO_Y_COMA
          { $$ = new ParserVal(new Token(ClaseLexica.ASIGNACION, "sentencia", yylineno)); }
          ;

casos : caso casos
      { $$ = new ParserVal(new Token(ClaseLexica.CASE, "casos", yylineno)); }
      | /* ε */
      { $$ = new ParserVal(new Token(ClaseLexica.CASE, "epsilon", yylineno)); }
      | predeterminado
      { $$ = $1; }
      ;

caso : CASE opcion DOS_PUNTOS instrucciones
     { $$ = new ParserVal(new Token(ClaseLexica.CASE, "caso", yylineno)); }
     ;

opcion : LITERAL_ENTERA
       | LITERAL_RUNA
       ;

predeterminado : DEFAULT DOS_PUNTOS instrucciones
               { $$ = new ParserVal(new Token(ClaseLexica.DEFAULT, "predeterminado", yylineno)); }
               ;

parte_izquierda : ID localizacion
               | ID
               ;

localizacion : arreglo
            | estructurado
            ;

arreglo : CORCHETE_IZQ exp CORCHETE_DER arreglo
        | CORCHETE_IZQ exp CORCHETE_DER
        ;

estructurado : PUNTO ID estructurado
             | PUNTO ID
             ;

exp : exp OR_LOGICO exp_and
    | exp_and
    ;

exp_and : exp_and AND_LOGICO exp_or_bit
        | exp_or_bit
        ;

exp_or_bit : exp_or_bit OR_BIT exp_xor_bit
           | exp_xor_bit
           ;

exp_xor_bit : exp_xor_bit XOR_BIT exp_and_bit
            | exp_and_bit
            ;

exp_and_bit : exp_and_bit AND_BIT exp_igualdad
            | exp_igualdad
            ;

exp_igualdad : exp_igualdad IGUALDAD exp_relacional
             | exp_igualdad DIFERENTE exp_relacional
             | exp_relacional
             ;

exp_relacional : exp_relacional MENORQUE exp_shift
               | exp_relacional MAYORQUE exp_shift
               | exp_relacional MENORIGUAL exp_shift
               | exp_relacional MAYORIGUAL exp_shift
               | exp_shift
               ;

exp_shift : exp_shift SHIFT_IZQUIERDA exp_aditiva
          | exp_shift SHIFT_DERECHA exp_aditiva
          | exp_aditiva
          ;

exp_aditiva : exp_aditiva SUMA exp_multiplicativa
            | exp_aditiva RESTA exp_multiplicativa
            | exp_multiplicativa
            ;

exp_multiplicativa : exp_multiplicativa MULTIPLICACION exp_unaria
                   | exp_multiplicativa DIVISION exp_unaria
                   | exp_multiplicativa MODULO exp_unaria
                   | exp_multiplicativa DIVISION_ENTERA exp_unaria
                   | exp_unaria
                   ;

exp_unaria : RESTA exp_unaria
           | NOT_LOGICO exp_unaria
           | NOT_BIT exp_unaria
           | exp_primaria
           ;

exp_primaria : PARENTESIS_IZQ exp PARENTESIS_DER
             | ID localizacion
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
            { $$ = new ParserVal($1.token);}
            | /* ε */ { $$ = new ParserVal(new Token(ClaseLexica.ID, "epsilon", yylineno)); }
            ;

lista_param : lista_param COMA exp
            | exp
            ;

%%

/* Código de soporte */

private Lexer lexer;           // Analizador léxico
private Token currentToken;    // Token actual siendo procesado

/**
 * Constructor del analizador sintáctico
 * @param input Reader para la entrada
 */
public Parser(Reader input) {
    lexer = new Lexer(input);
    System.out.println("\nInicio del análisis sintáctico");
}

/**
 * Maneja los errores sintácticos
 * @param msg Mensaje de error
 */
private void yyerror(String msg) {
    System.out.println("\nError sintáctico en línea " +
        (currentToken != null ? currentToken.getLinea() : "desconocida") +
        ": " + msg +
        "\nToken actual: " + (currentToken != null ? currentToken.getLexema() : "null"));
}

/**
 * Obtiene el siguiente token del analizador léxico
 * @return código del token o -1 en caso de error
 */
private int yylex() {
    try {
        currentToken = lexer.yylex();
        if (currentToken == null) {
            System.out.println("\nFin de archivo alcanzado");
            return 0; // Devuelve 0 para EOF
        }

        // Aquí se asigna el objeto Token a yylval.
        yylval = new ParserVal(currentToken);
        return currentToken.getClase().ordinal() + 257;
    } catch (IOException e) {
        System.out.println("Error de lectura: " + e.getMessage());
        return -1; // Devuelve -1 en caso de error
    }
}

/**
 * Método principal para iniciar el análisis sintáctico
 * @param args Argumentos de la línea de comandos (archivo de entrada)
 */
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