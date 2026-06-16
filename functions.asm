# =================================================================
# FUNCOES DE LOGICA E DESENHO DA BATALHA NAVAL
# =================================================================

# -----------------------------------------------------------------
# ESPALHAR NAVIOS
# Espalha os navios de forma aleatoria no tabuleiro
# Argumentos: s1 = Endereco base do tabuleiro, s0 = Total de navios
# -----------------------------------------------------------------
espalhar_navios:
loop_espalhar:
    beqz s0, fim_espalhar
    li a7, RANDINT
    li a0, 0
    li a1, 25               # Gera numero de 0 a 24
    ecall
    
    add t0, s1, a0          
    lb t1, 0(t0)            
    bnez t1, loop_espalhar  # Se ja tem navio, sorteia de novo
    
    li t2, 1
    sb t2, 0(t0)            # Grava o navio
    addi s0, s0, -1         
    j loop_espalhar         
fim_espalhar:
    ret

# -----------------------------------------------------------------
# IMPRIMIR TABULEIRO
# Imprime o tabuleiro 5x5 com identificadores visuais
# Argumentos: s1 = Endereco base do tabuleiro
# -----------------------------------------------------------------
imprimir_tabuleiro:
    li t0, 0                # t0 = indice de impressao (0 a 24)
print_loop:
    li t1, 25
    beq t0, t1, fim_imprimir

    # Checar se eh comeco de linha (indice % 5 == 0)
    li t1, 5
    rem t2, t0, t1          
    bnez t2, skip_row_label 

    print_str(newline)
    
    div t3, t0, t1          
    addi t3, t3, 1          # Numero da Linha (1 a 5)

    # Espacamento visual (todas as linhas sao 1 digito, usa space2)
    print_str(space2)
    print_int(t3)
    print_str(space)	
    
skip_row_label:
    add t2, s1, t0          
    lb t3, 0(t2)            

    li t4, 2
    beq t3, t4, p_miss  
    li t4, 3
    beq t3, t4, p_hit   

p_water:
    print_str(char_water)       
    j do_print
p_miss:
    print_str(char_miss)
    j do_print
p_hit:
    print_str(char_hit)

do_print:
    addi t0, t0, 1          
    j print_loop

fim_imprimir:
    ret

# -----------------------------------------------------------------
# LER COORDENADA
# Solicita linha/coluna, valida e converte para uso interno
# Argumentos: a0 = Endereco do texto de pergunta (msg_row/msg_col)
# Retorno: a0 = Coordenada ajustada (0 a 4)
# -----------------------------------------------------------------
ler_coordenada:
    mv t2, a0               # Salva a mensagem base em t2
loop_ler:
    mv a0, t2
    li a7, STRING
    ecall                   # Imprime a pergunta recebida
    
    li a7, READ_INT                
    ecall                   # Le a entrada do usuario

    # Validar 1 a 5
    blez a0, input_invalido
    li t0, 5
    bgt a0, t0, input_invalido
    
    addi a0, a0, -1         # AJUSTE MAGICO: Transforma 1-5 em 0-4
    ret

input_invalido:
    print_str(msg_invalid)
    j loop_ler