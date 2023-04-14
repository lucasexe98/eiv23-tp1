/* En este archivo escribirás tu solución.
 * Para ello deberás completar las rutinas en código
 * ensamblador.
 * Puedes usar los registros R0 a R12 pues ya está preservado
 * el valor de los registros que deben mantenerse.
 * Los registros R0 a R3 contienen los argumentos al entrar a
 * la rutina y contendrán el valor devuelto al salir.
 * Si realizas un llamado a subrutina, los registros R0 a R3 y el
 * registro R12 pueden cambiar su valor (y en particular, R0 contiene 
 * normalmente el valor devuelto), los registros R4 a R11 preservan
 * su valor.
 */
.syntax unified
.cpu cortex-m3
.fpu softvfp
.thumb

.macro defun nombre
    .section .text.\nombre
    .global \nombre
    .type \nombre, %function
\nombre:
.endm

.macro endfun nombre
    .size \nombre, . - \nombre
.endm


/**
 * Sumar dos enteros de 32 bit
 *  suma(2,3) => 5
 * Entrada
 *  a->R0, b->R1 : sumandos, enteros de 32 bit con signo 
 * Salida
 *  R0     : suma, entero de 32 bit con signo
 */
defun suma
    push {r4-r11,lr}
    // Insertar código a continuación
    ADD R0,R1
    // Retorno, antes R0 debe tener el valor correcto
    pop {r4-r11,pc}
endfun suma

/**
 * Sumar los números de un arreglo en memoria de enteros de
 * 32 bit con resultado de 64 bit.
 *
 * sumatoria(5,(uint32_t[]){1,2,3,4,5}) => 15
 *
 * Entrada 
 *  n->R0    : Cantidad de números en registro R0, entero de 32 bit
 *  b->R1    : Dirección en memoria del primer número, puntero a
 *             entero de 32 bit con signo.
 * Salida
 *  R1:R0 : Sumatoria, entero de 64 bit con signo 
 *  R3:R2 : Resultado de sumatoria, parte alta y baja
 */
defun sumatoria
    push {r4-r11,lr}
    MOV R2,#0
    MOV R3,#0
    MOV R4,#0

    0:
    CMP R4,R0
    BGE 1f

    LDR R5, [R1, R4, LSL #2]
    ASR R6,R5,#31

    ADDS R2,R5
    ADC R3,R6
    
    ADD R4,#1

    B 0b
    
    1:
    MOV R1,R3
    MOV R0,R2
    pop {r4-r11,pc}
endfun sumatoria

/**
 * Encuentra la posicion del máximo elemento de un arreglo
 *
 * posicion_maximo(4,(uint32_t[]){1,4,2,3}) => 1
 *
 * Entrada:
 *  n->R0 : cantidad de números en el arreglo, entero de 32 bit
 *  b->R1 : posición en memoria del primer número, puntero
 *          a entero de 32 bit con signo.
 * Salida:
 *  R0 : posición del máximo elemento en el arreglo, entero
 *       de 32 bit.
 */
defun posicion_maximo
    push {r4-r11,lr}
    // Insertar código a continuación
    MOV R4, #0
    CMP R0, #1
    BLE Retorno
    LDR R6,[R1]
    MOV R7, #1
    0:
    CMP R7, R0
    BGE Retorno
    LDR R8, [R1, R7, LSL #2]
    CMP R6, R8
    BGE 1f
    MOV R6, R8
    MOV R4, R7
    1:
    ADD R7, #1
    BAL 0b
    Retorno:
    MOV R0, R4

    // Retorno, antes R0 debe tener el valor correcto
    pop {r4-r11,pc}
endfun posicion_maximo

/**
 * Ordenar de menor a mayor un arreglo de números en memoria.
 * La ordenación es en el lugar, sobreescribiendo el arreglo
 * original.
 *
 * uint32_t vals[]={4,1,3,5,2,6,7};
 * ordenar_en_sitio_menor_a_mayor(7,vals)
 * luego vals contendrá {1,2,3,4,5,6,7}
 *
 * Entrada:
 *  n->R0 : Cantidad de números en el arreglo, entero de 32 bit
 *  b->R1 : Dirección del primer número, puntero a entero de
 *          32 bit con signo.
 * Salida:
 *  Sin valor de salida. El arreglo dado debe haber sido ordenado
 *  sobreescribiendo los valores originales.
 */
defun ordenar_en_sitio_menor_a_mayor
    push {r4-r11,lr}
    MOV R6, R1
    SUB R4, R0, #1
    0:
    CMP R4, #0
    BLE Fin
    ADD R0, R4, #1
    MOV R1, R6
    BL posicion_maximo
    LDR R5,[R6,R4,LSL #2]
    LDR R7,[R6,R0,LSL #2]
    STR R7,[R6,R4,LSL #2]
    STR R5,[R6,R0,LSL #2]
    SUB R4, #1
    BAL 0b
    Fin:
    pop {r4-r11,pc}
endfun ordenar_en_sitio_menor_a_mayor
