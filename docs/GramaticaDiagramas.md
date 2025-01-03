**programa:**

![programa](diagrams/programa.png)

```
programa ::= ( proto tipo id '(' argumentos ')' ';' )* '' decl_var ( func tipo id '(' argumentos ')' bloque )* ''
```

**decl_var:**

![decl_var](diagrams/decl_var.png)

```
decl_var ::= ( tipo id ( ',' id )* ';' )* ''
```

referenced by:

* programa
* tipo

**tipo:**

![tipo](diagrams/tipo.png)

```
tipo     ::= basico
           | ( '[' literal_entera ']' )* ''
           | 'struct' '{' decl_var '}'
           | puntero
```

referenced by:

* argumentos
* decl_var
* programa

**puntero:**

![puntero](diagrams/puntero.png)

```
puntero  ::= 'ptr' basico
```

referenced by:

* tipo

**basico:**

![basico](diagrams/basico.png)

```
basico   ::= 'int'
           | 'float'
           | 'double'
           | 'complex'
           | 'rune'
           | 'void'
           | 'string'
```

referenced by:

* puntero
* tipo

**argumentos:**

![argumentos](diagrams/argumentos.png)

```
argumentos
         ::= tipo id ( ',' tipo id )*
           | ''
```

referenced by:

* programa

**bloque:**

![bloque](diagrams/bloque.png)

```
bloque   ::= '{' declaraciones instrucciones '}'
```

referenced by:

* programa
* sentencia

**instrucciones:**

![instrucciones](diagrams/instrucciones.png)

```
instrucciones
         ::= sentencia+
```

referenced by:

* bloque
* caso
* predeterminado

**sentencia:**

![sentencia](diagrams/sentencia.png)

```
sentencia
         ::= ( 'if' '(' exp ')' ( sentencia 'else' )? | 'while' '(' exp ')' ) sentencia
           | 'do' sentencia 'while' '(' exp ')'
           | ( 'break' | ( 'print' | parte_izquierda '=' ) exp | 'return' exp? ) ';'
           | bloque
           | 'switch' '(' exp ')' '{' caso* ( '' | predeterminado ) '}'
           | 'scan' parte_izquierda
```

referenced by:

* instrucciones
* sentencia

**caso:**

![caso](diagrams/caso.png)

```
caso     ::= 'case' opcion ':' instrucciones
```

referenced by:

* sentencia

**opcion:**

![opcion](diagrams/opcion.png)

```
opcion   ::= literal_entera
           | literal_runa
```

referenced by:

* caso

**predeterminado:**

![predeterminado](diagrams/predeterminado.png)

```
predeterminado
         ::= 'default' ':' instrucciones
```

referenced by:

* sentencia

**parte_izquierda:**

![parte_izquierda](diagrams/parte_izquierda.png)

```
parte_izquierda
         ::= id localizacion?
```

referenced by:

* sentencia

**localizacion:**

![localizacion](diagrams/localizacion.png)

```
localizacion
         ::= ( '[' exp ']' )+
           | ( '.' id )+
```

referenced by:

* exp
* parte_izquierda

**exp:**

![exp](diagrams/exp.png)

```
exp      ::= ( exp ( '||' | '&&' | '|' | '^' | '&' | '==' | '!=' | '<' | '<=' | '>=' | '>' | '<<' |
                  '>>' | '+' | '-' | '*' | '/' | '%' ) | '-' | '!' | '~' ) exp
           | '(' exp ')'
           | id ( localizacion | '(' parametros ')' )?
           | 'false'
           | 'true'
           | literal_entera
           | literal_runa
           | literal_flotante
           | literal_doble
           | literal_compleja
           | literal_cadena
```

referenced by:

* exp
* localizacion
* parametros
* sentencia

## 
![parametros](diagrams/parametros.png) <sup>generated by [RR - Railroad Diagram Generator][RR]</sup>

[RR]: https://www.bottlecaps.de/rr/ui