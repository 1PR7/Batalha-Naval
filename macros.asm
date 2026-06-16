###############################################
#                 CONSTANTES                  #
###############################################
.eqv STRING 4
.eqv PRINT_INT 1
.eqv READ_INT 5
.eqv EXIT 10
.eqv CHAR 11
.eqv RANDINT 42

###############################################
#                   MACROS                    #
###############################################

# Imprime uma string a partir do seu rotulo (label) na memoria
.macro print_str(%label)
    li a7, STRING
    la a0, %label
    ecall
.end_macro

# Imprime um valor inteiro guardado em um registrador
.macro print_int(%reg)
    li a7, PRINT_INT
    mv a0, %reg
    ecall
.end_macro