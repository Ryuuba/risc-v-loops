# Compilación de bucles

En este repositorio se alojan tres ejemplos simples que ilustran cómo se compilan las estructuras de control de flujo *do-while*, *while* y *for*.

## Compilación de un bucle *do-while*

En el archivo `do-while.cc` se encuentra el código C++ de un bucle que incrementa, al menos una vez, el valor de la variable `accum` siempre que se satisfaga la condición `accum < max`. En el siguiente listado de instrucciones se presenta el código en cuestión.

```C++
int main()
{
    int accum = 0, max = 10;
    do
    {
        accum++;
    } while (accum < max);
    return 0;
}
```

Las instrucciones de inicialización `accum = 0` y `max = 10` se compilan con la instrucción `addi s1, s1, 0` y `addi s2, s2, 10`, respectivamente. La traducción del bucle *do-while* se realiza como se observa en la tabla siguiente. 

| Línea | C++                               | RISC-V                         |
| ----- | --------------------------------- | -------------------------------|
| 1     | `do`                              |                                |
| 2     | `{`                               |                                |
| 3     | `accum++;`                        | `do1:    addi s1, s1, 1`       |
| 4     | `} while (accum < max);`          | `        blt  s1, s2, do1`     |

En la línea uno del código C++ se presenta la palabra reservada `do`, a la que le corresponde la etiqueta `do1` de RISC-V. Esta etiqueta indica el inicio del bloque de instrucciones del bucle *do-while* en el lenguaje ensamblador.

Las llaves del código C++ no se traducen a RISC-V, simplemente se emplean para delimitar el ámbito del bucle y colocar las etiquetas de los saltos condicionales según corresponda.

La instrucción de la línea tres del código C++ es la primera del bucle; ésta instrucción se compila a RISC-V de esta forma `addi s1, s1, 1`. Se asume que el registro `s1` almacena el valor de la variable `accum`. La instrucción `addi` se coloca enseguida de la etiqueta `do1` para garantizar que sea la primera en ejecutarse cuando la condición del bucle se satisfaga.

La condición del bucle `accum < max` se compila a RISC-V como `blt s1, s2, do1` porque, si la expresión $accum < max$ es verdadera, entonces el salto hacia atrás se produce, en caso contrario, el programa debe seguir su avance secuencial. La etiqueta que se usa en la instrucción `blt` es `do1` porque así se salta a la primera instrucción del bucle.

## Compilación de un bucle *while*

En el archivo `while.cc` se encuentra el código de un programa que incrementa, mediante un bucle *while*, el valor de una variable llamada `accum` siempre que la condición $accum < max$ se cumpla. El código también se puede observar en el siguiente listado de instrucciones.

```C++
int main()
{
    int accum = 0, max = 0;
    while (accum < max)
        accum++;
    return 0;
}
```

Dado que las instrucciones de inicialización se compilan de la misma forma que en el caso del bucle *do-while*, en este apartado solo nos concentraremos en compilar las líneas del bucle *while*. En la siguiente tabla se presenta el resultado de dicha compilación.

| Línea | C++                               | RISC-V                         |
| ----- | --------------------------------- | -------------------------------|
| 1     | `while (accum < max)`             | `j wh1`                        |
| 2     | `{`                               |                                |
| 3     | `accum++;`                        | `L1:     addi s1, s1, 1`       |
| 4     | `}`                               | `wh1:    blt  s1, s2, L1`      |

El bucle *while* requiere de dos saltos para ser compilado: el primero es un salto incondicional que evita la ejecución del cuerpo de instrucciones del bucle, el segundo es un salto condicional que lleva a la primera instrucción del bucle.

La etiqueta `wh1` que se usa en la instrucción `j` indica que es está compilando un bucle *while*. En general, la etiqueta puede ser cualquiera; sin embargo, `wh1` indica con claridad que se está traduciendo el primer bucle `while`. Siendo así, un segundo bucle *while* tendría la etiqueta `wh2` y así, sucesivamente. Este tipo de etiqueta solo aparece después de un salto incondicional.

La etiqueta `L1` se utiliza en la instrucción `blt` para saltar a la primera instrucción del bucle *while*, en este caso, a la instrucción `addi`. El nombre de la etiqueta puede ser el que sea; sin embargo, se utiliza `L1` porque es la primera etiqueta usada en un salto condicional. Siguiendo esta convención, un segundo salto condicional emplearía la etiqueta L2.

## Compilación de un bucle *for*

El azúcar sintáctico (*syntactic sugar*) es un término que denota aquellas construcciones que facilitan el entendimiento de un conjunto de instrucciones, de tal manera que la nueva construcción resulta ser más concisa y directa. El bucle *for* es un ejemplo de azúcar sintáctico, dado que este tipo de bucle deriva de un bucle *while*, como se observa en la siguiente tabla.

| Línea | while                 | for                                          |
| ----- | --------------------- | -------------------------------------------- |
| 1     | `accum = 0;`          | `for (int accum = 0; accum < max; accum++);` |
| 2     | `while (accum < max)` |                                              |
| 3     | `accum++;`            |                                              |

Las instrucciones presentes en la columna con encabezado *while* son equivalentes a la única línea de código de la columna con encabezado *for*, de ahí que el bucle *for* sea considerado como azúcar sintáctico.

En lenguaje ensamblador, el código que resulta de la compilación de un bucle *for* es muy similar al que se obtiene de compilar un bucle *while* porque el bucle *for* azúcar sintáctico derivada de bucle *while*, tal como se observa en la tabla siguiente.

| RISC-V (for)          | RISC-V (while)            | 
| --------------------- | ------------------------- |
| `addi s1, s1, 0`      | `addi s1, s1, 0`          |
| `j for1`              | `j wh1`                   |
| `L1: addi s1, s1, 1`  | `L1:     addi s1, s1, 1`  |
| `for1: blt s1, s2, L1`| `wh1:    blt  s1, s2, L1` |

La diferencia entre ambos códigos es el uso de la etiqueta `wh1` y `for1`; la primera se usa para indicar que un bucle tipo *while* se está compilador, mientras que la segunda se usa para denotar la compilación de un bucle tipo *for*.

La compilación de un bucle *for* puede hacerse de la siguiente manera:

1. Compilación de la expresión de inicialización del bucle. En esta parte se traduce la expresión de inicialización. En el ejemplo manejado en este apartado, esta expresión es `int accum = 0`.
2. Compilación del conjunto de instrucciones del bucle.
3. Compilación de la expresión de bucle.
4. Compilación de la expresión de condición.

| Línea | for                                          | RISC-V                |
| ----- | -------------------------------------------- | --------------------- |
| 1     | `for (int accum = 0; accum < max; accum++);` | `addi s1, s1, 0`      |
| 2     |                                              | `j for1`              |
| 3     |                                              | `L1: addi s1, s1, 1`  |
| 4     |                                              | `for1: blt s1, s2, L1`|