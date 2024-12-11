/**
 * Analizador Léxico para el lenguaje C_1
 *
 * Este archivo define las reglas léxicas para reconocer los tokens del lenguaje C_1,
 * incluyendo palabras reservadas, identificadores, números, operadores y símbolos.
 *
 * Tokens reconocidos:
 * - Palabras reservadas: int, float, if, else, while
 * - Identificadores: secuencias de letras y dígitos que comienzan con letra
 * - Números: enteros y reales
 * - Operadores: +, -, *, /, =, ==, <, >, <=, >=, !=
 * - Símbolos: (, ), {, }, ;, ,
 *
 * @author the-tech-team
 */
package Analizador_Sintactico;

%%

%{
  public Token actual;

  /**
  * Obtiene la línea actual del análisis léxico.
  *
  * @return El número de línea actual.
  */
  public int getLine() { return yyline + 1; }

  /**
  * Imprime el estado léxico actual.
  *
  * @param lexema El lexema del token.
  * @param claseLexica La clase léxica del token.
  */
  public void printLexicalState(String lexema, ClaseLexica claseLexica) {
      int valor = claseLexica.ordinal() + 257;
      System.out.println("\nToken: " + lexema +
                    " | Clase: " + claseLexica.getNombre() +
                    " | Línea: " + getLine() +
                    " | Valor: " + valor);
  }

  private boolean eofAlcanzado = false;
%}

%public
%class Lexer
%standalone
%unicode
%line
%type Token

/* Definición de expresiones regulares básicas */
espacio        = [ \t\r\n]
letra          = [a-zA-Z_]
digito         = [0-9]
identificador  = {letra}({letra}|{digito})*
numero_entero  = {digito}+
numero_real    = {digito}+"."{digito}+
numero_real_exp = {numero_real}(("E"|"e")("+"|"-")?{digito}+)?
comentario_linea = "//".*
comentario_bloque = "/"(.|\n)?"*/"

complejo       = {numero_real}["i"]
literal_entera = {numero_entero}
literal_runa   = "'"(\\.|[^'])"'"             // Carácter entre comillas simples
literal_flotante = {numero_real_exp}["f"]
literal_doble   = {numero_real_exp}
literal_compleja = {numero_real_exp}"i"
literal_cadena = \"([^\"\\\\]|\\\\.)*\"          // Cadena entre comillas dobles

%%
/* Reglas léxicas */

{espacio}+                 { /* Ignorar espacios en blanco */ }
{comentario_linea}         { /* Ignorar comentarios de línea */ }
{comentario_bloque}        { /* Ignorar comentarios de bloque */ }

/* Palabras reservadas */
"int"      { printLexicalState(yytext(), ClaseLexica.INT); return new Token(ClaseLexica.INT, yytext(), getLine()); }
"float"    { printLexicalState(yytext(), ClaseLexica.FLOAT); return new Token(ClaseLexica.FLOAT, yytext(), getLine()); }
"double"   { printLexicalState(yytext(), ClaseLexica.DOUBLE); return new Token(ClaseLexica.DOUBLE, yytext(), getLine()); }
"complex"  { printLexicalState(yytext(), ClaseLexica.COMPLEX); return new Token(ClaseLexica.COMPLEX, yytext(), getLine()); }
"rune"     { printLexicalState(yytext(), ClaseLexica.RUNE); return new Token(ClaseLexica.RUNE, yytext(), getLine()); }
"void"     { printLexicalState(yytext(), ClaseLexica.VOID); return new Token(ClaseLexica.VOID, yytext(), getLine()); }
"string"   { printLexicalState(yytext(), ClaseLexica.STRING); return new Token(ClaseLexica.STRING, yytext(), getLine()); }
"if"       { printLexicalState(yytext(), ClaseLexica.IF); return new Token(ClaseLexica.IF, yytext(), getLine()); }
"else"     { printLexicalState(yytext(), ClaseLexica.ELSE); return new Token(ClaseLexica.ELSE, yytext(), getLine()); }
"while"    { printLexicalState(yytext(), ClaseLexica.WHILE); return new Token(ClaseLexica.WHILE, yytext(), getLine()); }
"do"       { printLexicalState(yytext(), ClaseLexica.DO); return new Token(ClaseLexica.DO, yytext(), getLine()); }
"for"      { printLexicalState(yytext(), ClaseLexica.FOR); return new Token(ClaseLexica.FOR, yytext(), getLine()); }
"break"    { printLexicalState(yytext(), ClaseLexica.BREAK); return new Token(ClaseLexica.BREAK, yytext(), getLine()); }
"return"   { printLexicalState(yytext(), ClaseLexica.RETURN); return new Token(ClaseLexica.RETURN, yytext(), getLine()); }
"switch"   { printLexicalState(yytext(), ClaseLexica.SWITCH); return new Token(ClaseLexica.SWITCH, yytext(), getLine()); }
"case"     { printLexicalState(yytext(), ClaseLexica.CASE); return new Token(ClaseLexica.CASE, yytext(), getLine()); }
"default"  { printLexicalState(yytext(), ClaseLexica.DEFAULT); return new Token(ClaseLexica.DEFAULT, yytext(), getLine()); }
"print"    { printLexicalState(yytext(), ClaseLexica.PRINT); return new Token(ClaseLexica.PRINT, yytext(), getLine()); }
"scan"     { printLexicalState(yytext(), ClaseLexica.SCAN); return new Token(ClaseLexica.SCAN, yytext(), getLine()); }
"func"     { printLexicalState(yytext(), ClaseLexica.FUNC); return new Token(ClaseLexica.FUNC, yytext(), getLine()); }
"struct"   { printLexicalState(yytext(), ClaseLexica.STRUCT); return new Token(ClaseLexica.STRUCT, yytext(), getLine()); }
"proto"    { printLexicalState(yytext(), ClaseLexica.PROTO); return new Token(ClaseLexica.PROTO, yytext(), getLine()); }
"ptr"      { printLexicalState(yytext(), ClaseLexica.PTR); return new Token(ClaseLexica.PTR, yytext(), getLine()); }
"true"     { printLexicalState(yytext(), ClaseLexica.TRUE); return new Token(ClaseLexica.TRUE, yytext(), getLine()); }
"false"    { printLexicalState(yytext(), ClaseLexica.FALSE); return new Token(ClaseLexica.FALSE, yytext(), getLine()); }

/* Identificadores y números */
{identificador}        { printLexicalState(yytext(), ClaseLexica.ID); return new Token(ClaseLexica.ID, yytext(), getLine()); }
{literal_entera}       { printLexicalState(yytext(), ClaseLexica.LITERAL_ENTERA); return new Token(ClaseLexica.LITERAL_ENTERA, yytext(), getLine()); }
{literal_flotante}     { printLexicalState(yytext(), ClaseLexica.LITERAL_FLOTANTE); return new Token(ClaseLexica.LITERAL_FLOTANTE, yytext(), getLine()); }
{literal_doble}       { printLexicalState(yytext(), ClaseLexica.LITERAL_DOBLE); return new Token(ClaseLexica.LITERAL_DOBLE, yytext(), getLine()); }
{literal_compleja}     { printLexicalState(yytext(), ClaseLexica.LITERAL_COMPLEJA); return new Token(ClaseLexica.LITERAL_COMPLEJA, yytext(), getLine()); }
{literal_cadena}       { printLexicalState(yytext(), ClaseLexica.LITERAL_CADENA); return new Token(ClaseLexica.LITERAL_CADENA, yytext(), getLine()); }
{literal_runa}         { printLexicalState(yytext(), ClaseLexica.LITERAL_RUNA); return new Token(ClaseLexica.LITERAL_RUNA, yytext(), getLine()); }

/* Símbolos y operadores */
";"   { printLexicalState(yytext(), ClaseLexica.PUNTO_Y_COMA); return new Token(ClaseLexica.PUNTO_Y_COMA, yytext(), getLine()); }
":"   { printLexicalState(yytext(), ClaseLexica.DOS_PUNTOS); return new Token(ClaseLexica.DOS_PUNTOS, yytext(), getLine()); }
","   { printLexicalState(yytext(), ClaseLexica.COMA); return new Token(ClaseLexica.COMA, yytext(), getLine()); }
"("   { printLexicalState(yytext(), ClaseLexica.PARENTESIS_IZQ); return new Token(ClaseLexica.PARENTESIS_IZQ, yytext(), getLine()); }
")"   { printLexicalState(yytext(), ClaseLexica.PARENTESIS_DER); return new Token(ClaseLexica.PARENTESIS_DER, yytext(), getLine()); }
"{"   { printLexicalState(yytext(), ClaseLexica.LLAVE_IZQ); return new Token(ClaseLexica.LLAVE_IZQ, yytext(), getLine()); }
"}"   { printLexicalState(yytext(), ClaseLexica.LLAVE_DER); return new Token(ClaseLexica.LLAVE_DER, yytext(), getLine()); }
"["   { printLexicalState(yytext(), ClaseLexica.CORCHETE_IZQ); return new Token(ClaseLexica.CORCHETE_IZQ, yytext(), getLine()); }
"]"   { printLexicalState(yytext(), ClaseLexica.CORCHETE_DER); return new Token(ClaseLexica.CORCHETE_DER, yytext(), getLine()); }
"."   { printLexicalState(yytext(), ClaseLexica.PUNTO); return new Token(ClaseLexica.PUNTO, yytext(), getLine()); }
"="   { printLexicalState(yytext(), ClaseLexica.ASIGNACION); return new Token(ClaseLexica.ASIGNACION, yytext(), getLine()); }
"=="  { printLexicalState(yytext(), ClaseLexica.IGUALDAD); return new Token(ClaseLexica.IGUALDAD, yytext(), getLine()); }
"!="  { printLexicalState(yytext(), ClaseLexica.DIFERENTE); return new Token(ClaseLexica.DIFERENTE, yytext(), getLine()); }
">"   { printLexicalState(yytext(), ClaseLexica.MAYORQUE); return new Token(ClaseLexica.MAYORQUE, yytext(), getLine()); }
"<"   { printLexicalState(yytext(), ClaseLexica.MENORQUE); return new Token(ClaseLexica.MENORQUE, yytext(), getLine()); }
"+"   { printLexicalState(yytext(), ClaseLexica.SUMA); return new Token(ClaseLexica.SUMA, yytext(), getLine()); }
"-"   { printLexicalState(yytext(), ClaseLexica.RESTA); return new Token(ClaseLexica.RESTA, yytext(), getLine()); }
"*"   { printLexicalState(yytext(), ClaseLexica.MULTIPLICACION); return new Token(ClaseLexica.MULTIPLICACION, yytext(), getLine()); }
"/"   { printLexicalState(yytext(), ClaseLexica.DIVISION); return new Token(ClaseLexica.DIVISION, yytext(), getLine()); }
"%"   { printLexicalState(yytext(), ClaseLexica.MODULO); return new Token(ClaseLexica.MODULO, yytext(), getLine()); }

/* Operadores relacionales y lógicos */
">="  { printLexicalState(yytext(), ClaseLexica.MAYORIGUAL); return new Token(ClaseLexica.MAYORIGUAL, yytext(), getLine()); }
"<="  { printLexicalState(yytext(), ClaseLexica.MENORIGUAL); return new Token(ClaseLexica.MENORIGUAL, yytext(), getLine()); }
"!="  { printLexicalState(yytext(), ClaseLexica.DIFERENTE); return new Token(ClaseLexica.DIFERENTE, yytext(), getLine()); }
"||"  { printLexicalState(yytext(), ClaseLexica.OR_LOGICO); return new Token(ClaseLexica.OR_LOGICO, yytext(), getLine()); }
"&&"  { printLexicalState(yytext(), ClaseLexica.AND_LOGICO); return new Token(ClaseLexica.AND_LOGICO, yytext(), getLine()); }
"!"   { printLexicalState(yytext(), ClaseLexica.NOT_LOGICO); return new Token(ClaseLexica.NOT_LOGICO, yytext(), getLine()); }

/* Operadores bit a bit */
"|"   { printLexicalState(yytext(), ClaseLexica.OR_BIT); return new Token(ClaseLexica.OR_BIT, yytext(), getLine()); }
"&"   { printLexicalState(yytext(), ClaseLexica.AND_BIT); return new Token(ClaseLexica.AND_BIT, yytext(), getLine()); }
"^"   { printLexicalState(yytext(), ClaseLexica.XOR_BIT); return new Token(ClaseLexica.XOR_BIT, yytext(), getLine()); }
"~"   { printLexicalState(yytext(), ClaseLexica.NOT_BIT); return new Token(ClaseLexica.NOT_BIT, yytext(), getLine()); }
"<<"  { printLexicalState(yytext(), ClaseLexica.SHIFT_IZQUIERDA); return new Token(ClaseLexica.SHIFT_IZQUIERDA, yytext(), getLine()); }
">>"  { printLexicalState(yytext(), ClaseLexica.SHIFT_DERECHA); return new Token(ClaseLexica.SHIFT_DERECHA, yytext(), getLine()); }

/* Manejo del fin de archivo */
<<EOF>> {
    if (!eofAlcanzado) {
        eofAlcanzado = true;
        printLexicalState("EOF", ClaseLexica.EOF);
        return new Token(ClaseLexica.EOF, "EOF", getLine());
    }
    return null;
}

/* Manejo de caracteres no reconocidos */
. {
    System.out.println("\nError: Símbolo no reconocido '" + yytext() +
                   "' en línea " + getLine() + ".");
    return new Token(ClaseLexica.UNKNOWN, yytext(), getLine());
}