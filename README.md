# Compilación de bucles

En este repositorio se alojan tres ejemplos simples que ilustran cómo se compilan las estructuras de control de flujo *do-while*, *while* y *for*.

## Compilación de un bucle *do-while*

En el archivo `do-while.cc` se encuentra el código C++ de un bucle que incrementa, al menos una vez el valor, de la variable `accum` siempre que se satisfaga la condición `accum < max`. Para realizar la compilación, se siguen estos pasos:

1. Traducción de la inicialización de la variables `accum` y `max`.
2. Compilación de las instrucciones que integran el bloque *do-while*.
3. Compilación de la condición de iteración. Si la condición se compone por un único operador relacional, entonces se usa el salto que corresponda a dicho operador; en caso contrario, se debe analizar el flujo de ejecución el programa para determinar el tipo de instrucción de salto. La etiqueta del salto se debe colocar en la misma línea que la primera instrucción del bloque de intrucciones de la estructura *do-while*.

La siguiente tabla ilustra la aplicación de los tres pasos anteriores. 

| Línea | C++                               | RISC-V                         |
| ----- | --------------------------------- | -------------------------------|
| 1     | `int accum = 0, max = 0;`         | `         addi s1, zero, 0`    |
|       |                                   | `         addi s2, zero, 0`    |
| 2     | `do`                              |                                |
| 3     | `{`                               |                                |
| 4     | `accum++`                         | `do1:    addi accum, accum, 1` |
| 5     | `} while (accum < max);`          | `        blt  accum, max, do1` |
