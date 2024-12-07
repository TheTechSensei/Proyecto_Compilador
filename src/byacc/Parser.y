/**
 * Analizador Sintáctico para el lenguaje C_1
 *
 * Este archivo define la gramática y las acciones semánticas para 
 * un subconjunto del lenguaje C que incluye declaraciones de variables, 
 * estructuras de control y expresiones aritméticas.
 *
 * Gramática implementada:
 * programa → lista declaraciones cuerpo programa EOF
 *  
 * cuerpo programa → bloque principal | lista sentencias
 * bloque principal → {lista sentencias}
 * lista declaraciones → lista declaraciones declaracion | declaracion
 * declaracion → tipo lista var ;
 * tipo → int | float
 * lista var → lista var , id | id
 * 
 * lista sentencias → lista sentencias sentencia | sentencia
 * sentencias → {lista sentencias} | sentencia
 * 
 * sentencia → asignacion
 * | if stmt
 * | while stmt
 * 
 * asignacion → id = expresion ;
 * 
 * if stmt → if (expresion) sentencias
 * | if (expresion) sentencias else sentencias
 * 
 * while stmt → while (expresion) sentencias
 * 
 * expresion → expresion + termino
 * | expresion − termino
 * | expresion < termino
 * | expresion > termino
 * | expresion <= termino
 * | expresion >= termino
 * | expresion == termino
 * | expresion ! = termino
 * | termino
 * 
 * termino → termino ∗ factor
 * | termino / factor
 * | factor
 * 
 * factor → (expresion)
 * | id | numero entero | numero real
 *
 */

%{
/* Importaciones necesarias para el analizador */
import java.io.*;
import src.Analizador_Sintactico_BYACCJ.*;
%}

/* Símbolo inicial de la gramática */
%start programa

/* Declaración de tokens y sus tipos */
%token INT FLOAT IF ELSE WHILE                   /* Palabras reservadas */
%token ID NUMERO_ENTERO NUMERO_REAL              /* Identificadores y números */
%token PYC COMA LPAR RPAR LLLA RLLA              /* Símbolos de puntuación */
%token ASIGNACION IGUALDAD MAYORQUE MENORQUE     /* Operadores */
%token SUMA RESTA MULTIPLICACION DIVISION        /* Operadores aritméticos */
%token MAYORIGUAL MENORIGUAL DIFERENTE           /* Operadores relacionales */
%token EOF                                       /* Fin de archivo */

/* Precedencia y asociatividad de operadores (de menor a mayor precedencia) */
%left SUMA RESTA
%left MULTIPLICACION DIVISION
%nonassoc MENORQUE MAYORQUE MENORIGUAL MAYORIGUAL IGUALDAD DIFERENTE
%nonassoc THEN
%nonassoc ELSE

%%
/* Reglas de producción de la gramática con acciones semánticas */

/**
 * Regla inicial del programa
 * Verifica la estructura general del programa
 */
programa : lista_declaraciones cuerpo_programa EOF
        { System.out.println("\nPrograma analizado correctamente."); }
        ;

/**
 * Define la estructura del cuerpo principal del programa
 */
cuerpo_programa : bloque_principal 
                | lista_sentencias
                ;

/**
 * Define un bloque de código delimitado por llaves
 */
bloque_principal : LLLA lista_sentencias RLLA
                ;

/**
 * Maneja múltiples declaraciones de variables
 */
lista_declaraciones : lista_declaraciones declaracion
                   | declaracion
                   ;

/**
 * Procesa una declaración de variables
 */
declaracion : tipo lista_var PYC
            { System.out.println("\nDeclaración procesada"); }
            ;

/**
 * Define los tipos de datos permitidos
 */
tipo : INT | FLOAT ;

/**
 * Maneja listas de variables en declaraciones
 */
lista_var : lista_var COMA ID
          | ID
          ;

/**
 * Procesa múltiples sentencias
 */
lista_sentencias : lista_sentencias sentencia
                | sentencia
                ;

/**
 * Define bloques de sentencias o sentencias individuales
 */
sentencias : LLLA lista_sentencias RLLA
          | sentencia
          ;

/**
 * Define los tipos de sentencias permitidas
 */
sentencia : asignacion
          | if_stmt
          | while_stmt
          ;

/**
 * Procesa asignaciones de valores a variables
 */
asignacion : ID ASIGNACION expresion PYC
           { System.out.println("\nAsignación procesada"); }
           ;

/**
 * Maneja estructuras de control if-else
 */
if_stmt : IF LPAR expresion RPAR sentencias %prec THEN
        | IF LPAR expresion RPAR sentencias ELSE sentencias
        ;

/**
 * Maneja estructuras de control while
 */
while_stmt : WHILE LPAR expresion RPAR sentencias
           ;

/**
 * Define las expresiones permitidas y sus operadores
 */
expresion : expresion SUMA termino
          | expresion RESTA termino
          | expresion MENORQUE termino
          | expresion MAYORQUE termino
          | expresion MENORIGUAL termino
          | expresion MAYORIGUAL termino
          | expresion IGUALDAD termino
          | expresion DIFERENTE termino
          | termino
          ;

/**
 * Define términos y operaciones de mayor precedencia
 */
termino : termino MULTIPLICACION factor
        | termino DIVISION factor
        | factor
        ;

/**
 * Define los elementos básicos de las expresiones
 */
factor : LPAR expresion RPAR
       | ID
       | NUMERO_ENTERO
       | NUMERO_REAL
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
            return 0;
        }
        
        yylval = new ParserVal(currentToken);
        return currentToken.getClaseLexica().ordinal() + 257;
    } catch (IOException e) {
        System.out.println("Error de lectura: " + e.getMessage());
        return -1;
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
