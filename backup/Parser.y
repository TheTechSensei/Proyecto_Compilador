%{
import java.io.*;
import src.*; // Ajusta este import según la ubicación de Token, ClaseLexica y Lexer
%}

%start programa

%token INT FLOAT DOUBLE COMPLEX RUNE VOID STRING
%token IF ELSE WHILE DO FOR BREAK RETURN SWITCH CASE DEFAULT PRINT SCAN
%token FUNC STRUCT PROTO PTR
%token TRUE FALSE
%token ID
%token LITERAL_ENTERA LITERAL_RUNA LITERAL_FLOTANTE LITERAL_DOBLE LITERAL_COMPLEJA LITERAL_CADENA
%token PUNTO_Y_COMA COMA PARENTESIS_IZQ PARENTESIS_DER LLAVE_IZQ LLAVE_DER CORCHETE_IZQ CORCHETE_DER PUNTO DOS_PUNTOS
%token ASIGNACION IGUALDAD MAYORQUE MENORQUE MAYORIGUAL MENORIGUAL DIFERENTE
%token SUMA RESTA MULTIPLICACION DIVISION MODULO
%token OR_LOGICO AND_LOGICO NOT_LOGICO
%token OR_BIT AND_BIT XOR_BIT NOT_BIT SHIFT_IZQUIERDA SHIFT_DERECHA
%token EOF UNKNOWN

%left OR_LOGICO
%left AND_LOGICO
%left OR_BIT
%left XOR_BIT
%left AND_BIT
%left IGUALDAD DIFERENTE
%left MAYORQUE MENORQUE MAYORIGUAL MENORIGUAL
%left SHIFT_IZQUIERDA SHIFT_DERECHA
%left SUMA RESTA
%left MULTIPLICACION DIVISION MODULO
%right NOT_LOGICO NOT_BIT
%nonassoc PARENTESIS_IZQ PARENTESIS_DER CORCHETE_IZQ CORCHETE_DER PUNTO

%%

programa : decl_proto decl_var decl_func EOF
        {
          System.out.println("\nPrograma analizado correctamente.");
          $$.obj = new Token(ClaseLexica.ID, "programa", (currentToken!=null?currentToken.getLinea():0));
        }
        ;

decl_proto : PROTO tipo ID PARENTESIS_IZQ argumentos PARENTESIS_DER PUNTO_Y_COMA decl_proto
           {
             $$.obj = new Token(ClaseLexica.PROTO, "decl_proto", (currentToken!=null?currentToken.getLinea():0));
           }
           | /* ε */
           {
             $$.obj = new Token(ClaseLexica.PROTO, "epsilon", (currentToken!=null?currentToken.getLinea():0));
           }
           ;

decl_var : tipo lista_var PUNTO_Y_COMA decl_var
         {
           $$.obj = new Token(ClaseLexica.ID, "decl_var", (currentToken!=null?currentToken.getLinea():0));
         }
         | /* ε */ {
           $$.obj = new Token(ClaseLexica.ID, "epsilon", (currentToken!=null?currentToken.getLinea():0));
         }
         ;

decl_func : FUNC tipo ID PARENTESIS_IZQ argumentos PARENTESIS_DER bloque decl_func
          {
            $$.obj = new Token(ClaseLexica.FUNC, "decl_func", (currentToken!=null?currentToken.getLinea():0));
          }
          | /* ε */
          {
            $$.obj = new Token(ClaseLexica.FUNC, "epsilon", (currentToken!=null?currentToken.getLinea():0));
          }
          ;

tipo : basico compuesto {
  $$.obj = new Token(ClaseLexica.ID, "tipo", (currentToken!=null?currentToken.getLinea():0));
}
     | STRUCT LLAVE_IZQ decl_var LLAVE_DER {
  $$.obj = new Token(ClaseLexica.STRUCT, "tipo_struct", (currentToken!=null?currentToken.getLinea():0));
}
     | puntero {
  $$.obj = new Token(ClaseLexica.PTR, "tipo_puntero", (currentToken!=null?currentToken.getLinea():0));
}
     ;

puntero : PTR basico {
  $$.obj = new Token(ClaseLexica.PTR, "puntero", (currentToken!=null?currentToken.getLinea():0));
}
;

basico : INT { $$.obj = ((Token)$1.obj); }
       | FLOAT { $$.obj = ((Token)$1.obj); }
       | DOUBLE { $$.obj = ((Token)$1.obj); }
       | COMPLEX { $$.obj = ((Token)$1.obj); }
       | RUNE { $$.obj = ((Token)$1.obj); }
       | VOID { $$.obj = ((Token)$1.obj); }
       | STRING { $$.obj = ((Token)$1.obj); }
       ;

compuesto : CORCHETE_IZQ LITERAL_ENTERA CORCHETE_DER compuesto {
  $$.obj = new Token(ClaseLexica.ID, "compuesto", (currentToken!=null?currentToken.getLinea():0));
}
          | /* ε */ {
  $$.obj = new Token(ClaseLexica.ID, "epsilon", (currentToken!=null?currentToken.getLinea():0));
}
          ;

lista_var : lista_var COMA ID {
  $$.obj = new Token(ClaseLexica.ID, "lista_var", (currentToken!=null?currentToken.getLinea():0));
}
          | ID {
  $$.obj = ((Token)$1.obj);
}
          ;

argumentos : lista_args {
  $$.obj = ((Token)$1.obj);
}
           | /* ε */ {
  $$.obj = new Token(ClaseLexica.ID, "epsilon", (currentToken!=null?currentToken.getLinea():0));
}
           ;

lista_args : lista_args COMA tipo ID {
  $$.obj = new Token(ClaseLexica.ID, "lista_args", (currentToken!=null?currentToken.getLinea():0));
}
           | tipo ID {
  $$.obj = new Token(ClaseLexica.ID, "lista_args_single", (currentToken!=null?currentToken.getLinea():0));
}
           ;

bloque : LLAVE_IZQ declaraciones instrucciones LLAVE_DER
       {
         $$.obj = new Token(ClaseLexica.LLAVE_IZQ, "bloque", (currentToken!=null?currentToken.getLinea():0));
       }
       ;

declaraciones : declaraciones declaracion {
  $$.obj = new Token(ClaseLexica.ID, "declaraciones", (currentToken!=null?currentToken.getLinea():0));
}
               | /* ε */ {
  $$.obj = new Token(ClaseLexica.ID, "epsilon", (currentToken!=null?currentToken.getLinea():0));
}
               ;

declaracion : tipo lista_var PUNTO_Y_COMA {
  $$.obj = new Token(ClaseLexica.ID, "declaracion", (currentToken!=null?currentToken.getLinea():0));
}
            ;

instrucciones : instrucciones sentencia {
  $$.obj = new Token(ClaseLexica.ID, "instrucciones", (currentToken!=null?currentToken.getLinea():0));
}
              | sentencia {
  $$.obj = ((Token)$1.obj);
}
              ;

sentencia : IF PARENTESIS_IZQ exp PARENTESIS_DER sentencia {
  $$.obj = new Token(ClaseLexica.IF, "sentencia_if", (currentToken!=null?currentToken.getLinea():0));
}
          | IF PARENTESIS_IZQ exp PARENTESIS_DER sentencia ELSE sentencia {
  $$.obj = new Token(ClaseLexica.IF, "sentencia_if_else", (currentToken!=null?currentToken.getLinea():0));
}
          | WHILE PARENTESIS_IZQ exp PARENTESIS_DER sentencia {
  $$.obj = new Token(ClaseLexica.WHILE, "sentencia_while", (currentToken!=null?currentToken.getLinea():0));
}
          | DO sentencia WHILE PARENTESIS_IZQ exp PARENTESIS_DER PUNTO_Y_COMA {
  $$.obj = new Token(ClaseLexica.DO, "sentencia_do_while", (currentToken!=null?currentToken.getLinea():0));
}
          | BREAK PUNTO_Y_COMA {
  $$.obj = new Token(ClaseLexica.BREAK, "sentencia_break", (currentToken!=null?currentToken.getLinea():0));
}
          | bloque {
  $$.obj = ((Token)$1.obj);
}
          | RETURN exp PUNTO_Y_COMA {
  $$.obj = new Token(ClaseLexica.RETURN, "sentencia_return_exp", (currentToken!=null?currentToken.getLinea():0));
}
          | RETURN PUNTO_Y_COMA {
  $$.obj = new Token(ClaseLexica.RETURN, "sentencia_return", (currentToken!=null?currentToken.getLinea():0));
}
          | SWITCH PARENTESIS_IZQ exp PARENTESIS_DER LLAVE_IZQ casos LLAVE_DER {
  $$.obj = new Token(ClaseLexica.SWITCH, "sentencia_switch", (currentToken!=null?currentToken.getLinea():0));
}
          | PRINT exp PUNTO_Y_COMA {
  $$.obj = new Token(ClaseLexica.PRINT, "sentencia_print", (currentToken!=null?currentToken.getLinea():0));
}
          | SCAN parte_izquierda PUNTO_Y_COMA {
  $$.obj = new Token(ClaseLexica.SCAN, "sentencia_scan", (currentToken!=null?currentToken.getLinea():0));
}
          | parte_izquierda ASIGNACION exp PUNTO_Y_COMA {
  $$.obj = new Token(ClaseLexica.ASIGNACION, "sentencia_asign", (currentToken!=null?currentToken.getLinea():0));
}
          ;

/* Redefinimos la sección de casos para evitar conflictos */
casos : casos_con_opciones {
  $$.obj = ((Token)$1.obj);
}
     ;

casos_con_opciones : lista_casos predeterminado {
  $$.obj = ((Token)$2.obj);
}
                   | lista_casos {
  $$.obj = ((Token)$1.obj);
}
                   | predeterminado {
  $$.obj = ((Token)$1.obj);
}
                   | /* vacío */ {
  $$.obj = new Token(ClaseLexica.CASE, "epsilon", (currentToken!=null?currentToken.getLinea():0));
}
                   ;

lista_casos : caso
            | lista_casos caso
            ;

caso : CASE opcion DOS_PUNTOS instrucciones {
  $$.obj = new Token(ClaseLexica.CASE, "caso", (currentToken!=null?currentToken.getLinea():0));
}
     ;

opcion : LITERAL_ENTERA {
  $$.obj = ((Token)$1.obj);
}
       | LITERAL_RUNA {
  $$.obj = ((Token)$1.obj);
}
       ;

predeterminado : DEFAULT DOS_PUNTOS instrucciones {
  $$.obj = new Token(ClaseLexica.DEFAULT, "predeterminado", (currentToken!=null?currentToken.getLinea():0));
}
               ;

parte_izquierda : ID localizacion {
  $$.obj = new Token(ClaseLexica.ID, "parte_izquierda", (currentToken!=null?currentToken.getLinea():0));
}
               | ID {
  $$.obj = ((Token)$1.obj);
}
               ;

localizacion : arreglo {
  $$.obj = ((Token)$1.obj);
}
            | estructurado {
  $$.obj = ((Token)$1.obj);
}
            ;

arreglo : CORCHETE_IZQ exp CORCHETE_DER arreglo {
  $$.obj = new Token(ClaseLexica.ID, "arreglo", (currentToken!=null?currentToken.getLinea():0));
}
        | CORCHETE_IZQ exp CORCHETE_DER {
  $$.obj = new Token(ClaseLexica.ID, "arreglo_simple", (currentToken!=null?currentToken.getLinea():0));
}
        ;

estructurado : PUNTO ID estructurado {
  $$.obj = new Token(ClaseLexica.ID, "estructurado", (currentToken!=null?currentToken.getLinea():0));
}
             | PUNTO ID {
  $$.obj = new Token(ClaseLexica.ID, "estructurado_simple", (currentToken!=null?currentToken.getLinea():0));
}
             ;

exp : exp OR_LOGICO exp_and {
  $$.obj = new Token(ClaseLexica.OR_LOGICO, "exp_or_logico", (currentToken!=null?currentToken.getLinea():0));
}
    | exp_and {
  $$.obj = ((Token)$1.obj);
}
    ;

exp_and : exp_and AND_LOGICO exp_or_bit {
  $$.obj = new Token(ClaseLexica.AND_LOGICO, "exp_and_logico", (currentToken!=null?currentToken.getLinea():0));
}
        | exp_or_bit {
  $$.obj = ((Token)$1.obj);
}
        ;

exp_or_bit : exp_or_bit OR_BIT exp_xor_bit {
  $$.obj = new Token(ClaseLexica.OR_BIT, "exp_or_bit", (currentToken!=null?currentToken.getLinea():0));
}
           | exp_xor_bit {
  $$.obj = ((Token)$1.obj);
}
           ;

exp_xor_bit : exp_xor_bit XOR_BIT exp_and_bit {
  $$.obj = new Token(ClaseLexica.XOR_BIT, "exp_xor_bit", (currentToken!=null?currentToken.getLinea():0));
}
            | exp_and_bit {
  $$.obj = ((Token)$1.obj);
}
            ;

exp_and_bit : exp_and_bit AND_BIT exp_igualdad {
  $$.obj = new Token(ClaseLexica.AND_BIT, "exp_and_bit", (currentToken!=null?currentToken.getLinea():0));
}
            | exp_igualdad {
  $$.obj = ((Token)$1.obj);
}
            ;

exp_igualdad : exp_igualdad IGUALDAD exp_relacional {
  $$.obj = new Token(ClaseLexica.IGUALDAD, "exp_igualdad", (currentToken!=null?currentToken.getLinea():0));
}
             | exp_igualdad DIFERENTE exp_relacional {
  $$.obj = new Token(ClaseLexica.DIFERENTE, "exp_diferente", (currentToken!=null?currentToken.getLinea():0));
}
             | exp_relacional {
  $$.obj = ((Token)$1.obj);
}
             ;

exp_relacional : exp_relacional MENORQUE exp_shift {
  $$.obj = new Token(ClaseLexica.MENORQUE, "exp_menorque", (currentToken!=null?currentToken.getLinea():0));
}
               | exp_relacional MAYORQUE exp_shift {
  $$.obj = new Token(ClaseLexica.MAYORQUE, "exp_mayorque", (currentToken!=null?currentToken.getLinea():0));
}
               | exp_relacional MENORIGUAL exp_shift {
  $$.obj = new Token(ClaseLexica.MENORIGUAL, "exp_menorigual", (currentToken!=null?currentToken.getLinea():0));
}
               | exp_relacional MAYORIGUAL exp_shift {
  $$.obj = new Token(ClaseLexica.MAYORIGUAL, "exp_mayorigual", (currentToken!=null?currentToken.getLinea():0));
}
               | exp_shift {
  $$.obj = ((Token)$1.obj);
}
               ;

exp_shift : exp_shift SHIFT_IZQUIERDA exp_aditiva {
  $$.obj = new Token(ClaseLexica.SHIFT_IZQUIERDA, "exp_shift_izq", (currentToken!=null?currentToken.getLinea():0));
}
          | exp_shift SHIFT_DERECHA exp_aditiva {
  $$.obj = new Token(ClaseLexica.SHIFT_DERECHA, "exp_shift_der", (currentToken!=null?currentToken.getLinea():0));
}
          | exp_aditiva {
  $$.obj = ((Token)$1.obj);
}
          ;

exp_aditiva : exp_aditiva SUMA exp_multiplicativa {
  $$.obj = new Token(ClaseLexica.SUMA, "exp_suma", (currentToken!=null?currentToken.getLinea():0));
}
            | exp_aditiva RESTA exp_multiplicativa {
  $$.obj = new Token(ClaseLexica.RESTA, "exp_resta", (currentToken!=null?currentToken.getLinea():0));
}
            | exp_multiplicativa {
  $$.obj = ((Token)$1.obj);
}
            ;

exp_multiplicativa : exp_multiplicativa MULTIPLICACION exp_unaria {
  $$.obj = new Token(ClaseLexica.MULTIPLICACION, "exp_mult", (currentToken!=null?currentToken.getLinea():0));
}
                   | exp_multiplicativa DIVISION exp_unaria {
  $$.obj = new Token(ClaseLexica.DIVISION, "exp_div", (currentToken!=null?currentToken.getLinea():0));
}
                   | exp_multiplicativa MODULO exp_unaria {
  $$.obj = new Token(ClaseLexica.MODULO, "exp_modulo", (currentToken!=null?currentToken.getLinea():0));
}
                   | exp_unaria {
  $$.obj = ((Token)$1.obj);
}
                   ;

exp_unaria : RESTA exp_unaria {
  $$.obj = new Token(ClaseLexica.RESTA, "exp_unaria_resta", (currentToken!=null?currentToken.getLinea():0));
}
           | NOT_LOGICO exp_unaria {
  $$.obj = new Token(ClaseLexica.NOT_LOGICO, "exp_unaria_not_logico", (currentToken!=null?currentToken.getLinea():0));
}
           | NOT_BIT exp_unaria {
  $$.obj = new Token(ClaseLexica.NOT_BIT, "exp_unaria_not_bit", (currentToken!=null?currentToken.getLinea():0));
}
           | exp_primaria {
  $$.obj = ((Token)$1.obj);
}
           ;

exp_primaria : PARENTESIS_IZQ exp PARENTESIS_DER {
  $$.obj = ((Token)$2.obj);
}
             | ID localizacion {
  $$.obj = new Token(ClaseLexica.ID, "exp_primaria_id_loc", (currentToken!=null?currentToken.getLinea():0));
}
             | ID PARENTESIS_IZQ parametros PARENTESIS_DER {
  $$.obj = new Token(ClaseLexica.ID, "exp_primaria_llamada", (currentToken!=null?currentToken.getLinea():0));
}
             | ID {
  $$.obj = ((Token)$1.obj);
}
             | FALSE {
  $$.obj = ((Token)$1.obj);
}
             | TRUE {
  $$.obj = ((Token)$1.obj);
}
             | LITERAL_ENTERA {
  $$.obj = ((Token)$1.obj);
}
             | LITERAL_RUNA {
  $$.obj = ((Token)$1.obj);
}
             | LITERAL_FLOTANTE {
  $$.obj = ((Token)$1.obj);
}
             | LITERAL_DOBLE {
  $$.obj = ((Token)$1.obj);
}
             | LITERAL_COMPLEJA {
  $$.obj = ((Token)$1.obj);
}
             | LITERAL_CADENA {
  $$.obj = ((Token)$1.obj);
}
             ;

parametros : lista_param {
  $$.obj = ((Token)$1.obj);
}
            | /* ε */ {
  $$.obj = new Token(ClaseLexica.ID, "epsilon", (currentToken!=null?currentToken.getLinea():0));
}
            ;

lista_param : lista_param COMA exp {
  $$.obj = new Token(ClaseLexica.ID, "lista_param", (currentToken!=null?currentToken.getLinea():0));
}
            | exp {
  $$.obj = ((Token)$1.obj);
}
            ;

%%

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
        yylval.obj = currentToken;
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
