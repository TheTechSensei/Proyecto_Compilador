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

package src.Analizador_Sintactico_BYACCJ;

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
espacio = [ \t\n]                           /* Espacios en blanco, tabulaciones y saltos de línea */
letra = [a-zA-Z_]                           /* Letras y guión bajo */
digito = [0-9]                              /* Dígitos del 0 al 9 */
identificador = {letra}({letra}|{digito})*  /* Patrón para identificadores */
numero_entero = {digito}+                   /* Números enteros */
numero_real = {digito}+"."{digito}+         /* Números reales con punto decimal */

%%
/* Reglas léxicas */

{espacio}+ { /* Ignorar espacios en blanco */ }

/* Palabras reservadas */
"int"    { printLexicalState(yytext(), ClaseLexica.INT); return new Token(ClaseLexica.INT, yytext(), getLine()); }
"float"  { printLexicalState(yytext(), ClaseLexica.FLOAT); return new Token(ClaseLexica.FLOAT, yytext(), getLine()); }
"if"     { printLexicalState(yytext(), ClaseLexica.IF); return new Token(ClaseLexica.IF, yytext(), getLine()); }
"else"   { printLexicalState(yytext(), ClaseLexica.ELSE); return new Token(ClaseLexica.ELSE, yytext(), getLine()); }
"while"  { printLexicalState(yytext(), ClaseLexica.WHILE); return new Token(ClaseLexica.WHILE, yytext(), getLine()); }

/* Identificadores y números */
{identificador} { printLexicalState(yytext(), ClaseLexica.ID); return new Token(ClaseLexica.ID, yytext(), getLine()); }
{numero_entero} { printLexicalState(yytext(), ClaseLexica.NUMERO_ENTERO); return new Token(ClaseLexica.NUMERO_ENTERO, yytext(), getLine()); }
{numero_real}   { printLexicalState(yytext(), ClaseLexica.NUMERO_REAL); return new Token(ClaseLexica.NUMERO_REAL, yytext(), getLine()); }

/* Símbolos y operadores */
";"   { printLexicalState(yytext(), ClaseLexica.PYC); return new Token(ClaseLexica.PYC, yytext(), getLine()); }
","   { printLexicalState(yytext(), ClaseLexica.COMA); return new Token(ClaseLexica.COMA, yytext(), getLine()); }
"("   { printLexicalState(yytext(), ClaseLexica.LPAR); return new Token(ClaseLexica.LPAR, yytext(), getLine()); }
")"   { printLexicalState(yytext(), ClaseLexica.RPAR); return new Token(ClaseLexica.RPAR, yytext(), getLine()); }
"{"   { printLexicalState(yytext(), ClaseLexica.LLLA); return new Token(ClaseLexica.LLLA, yytext(), getLine()); }
"}"   { printLexicalState(yytext(), ClaseLexica.RLLA); return new Token(ClaseLexica.RLLA, yytext(), getLine()); }
"="   { printLexicalState(yytext(), ClaseLexica.ASIGNACION); return new Token(ClaseLexica.ASIGNACION, yytext(), getLine()); }
"=="  { printLexicalState(yytext(), ClaseLexica.IGUALDAD); return new Token(ClaseLexica.IGUALDAD, yytext(), getLine()); }
">"   { printLexicalState(yytext(), ClaseLexica.MAYORQUE); return new Token(ClaseLexica.MAYORQUE, yytext(), getLine()); }
"<"   { printLexicalState(yytext(), ClaseLexica.MENORQUE); return new Token(ClaseLexica.MENORQUE, yytext(), getLine()); }
"+"   { printLexicalState(yytext(), ClaseLexica.SUMA); return new Token(ClaseLexica.SUMA, yytext(), getLine()); }
"-"   { printLexicalState(yytext(), ClaseLexica.RESTA); return new Token(ClaseLexica.RESTA, yytext(), getLine()); }
"*"   { printLexicalState(yytext(), ClaseLexica.MULTIPLICACION); return new Token(ClaseLexica.MULTIPLICACION, yytext(), getLine()); }
"/"   { printLexicalState(yytext(), ClaseLexica.DIVISION); return new Token(ClaseLexica.DIVISION, yytext(), getLine()); }

/* Operadores relacionales y lógicos */
">="  { printLexicalState(yytext(), ClaseLexica.MAYORIGUAL); return new Token(ClaseLexica.MAYORIGUAL, yytext(), getLine()); }
"<="  { printLexicalState(yytext(), ClaseLexica.MENORIGUAL); return new Token(ClaseLexica.MENORIGUAL, yytext(), getLine()); }
"!="  { printLexicalState(yytext(), ClaseLexica.DIFERENTE); return new Token(ClaseLexica.DIFERENTE, yytext(), getLine()); }

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