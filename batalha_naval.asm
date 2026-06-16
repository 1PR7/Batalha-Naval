.data
    # O Tabuleiro: Vetor de 25 bytes (5x5).
    board: .space 25

    # Textos e Interface
    msg_title:   .asciz "\n--- BATALHA NAVAL BOM DIA & CIA ---\n"
    msg_header:  .asciz "     1  2  3  4  5"  # Cabecalho das colunas
    msg_ammo:    .asciz "\n[TIROS RESTANTES: "
    msg_ammo_end:.asciz "]\n"
    msg_row:     .asciz "Digite a Linha (1 a 5): "
    msg_col:     .asciz "Digite a Coluna (1 a 5): "
    msg_hit:     .asciz "\n\n>>> VOCE ACERTOU UM NAVIO! <<<\n"
    msg_miss:    .asciz "\n\n>>> AGUA! Nao foi dessa vez... <<<\n"
    
    # Condicoes de Fim de Jogo
    msg_win:     .asciz "\n\nPARABENS! VOCE DESTRUIU TODOS OS 5 NAVIOS!\n"
    msg_lose:    .asciz "\n\nGAME OVER! ACABARAM SEUS TIROS!\n"
    msg_invalid: .asciz "Coordenada invalida! Digite numeros de 1 a 5.\n"

    # Graficos
    char_water:  .asciz " ~ "
    char_miss:   .asciz " O "
    char_hit:    .asciz " X "
    space:       .asciz " "
    space2:      .asciz "  "
    newline:     .asciz "\n"

# Inclusao das Macros
.include "macros.asm"

.text
.globl main

main:
    # ==========================================
    # 1. SETUP INICIAL DO JOGO
    # ==========================================
    li s0, 5                # s0 = Total de navios a colocar
    la s1, board            # s1 = Endereco base da memoria do tabuleiro
    jal espalhar_navios     # Chama funcao para montar mapa

    li s2, 0                # s2 = Navios destruidos (inicia em 0)
    li s5, 15               # s5 = Chances/Tiros totais (Condicao de parada)

    # ==========================================
    # 2. LOOP PRINCIPAL DO JOGO
    # ==========================================
loop_principal:
    # Interface superior
    print_str(msg_title)
    print_str(msg_ammo)
    print_int(s5)
    print_str(msg_ammo_end)
    print_str(msg_header)

    # Imprimir mapa
    jal imprimir_tabuleiro
    
    print_str(newline)
    print_str(newline)

    # ==========================================
    # 3. RECEBER O TIRO DO JOGADOR
    # ==========================================
    # Pedir Linha
    la a0, msg_row          # Passa mensagem da linha
    jal ler_coordenada
    mv s3, a0               # Salva a linha validada (0-4) em s3

    # Pedir Coluna
    la a0, msg_col          # Passa mensagem da coluna
    jal ler_coordenada
    mv s4, a0               # Salva a coluna validada (0-4) em s4

    # ==========================================
    # 4. CHECAR MEMORIA E CONSUMIR MUNICAO
    # ==========================================
    li t0, 5
    mul t1, s3, t0          
    add t1, t1, s4          # Posicao = (Linha_ajustada * 5) + Coluna_ajustada

    add t2, s1, t1          # t2 recebe o endereco exato da memoria
    lb t3, 0(t2)            

    li t4, 0
    beq t3, t4, acertou_agua  
    li t4, 1
    beq t3, t4, acertou_navio 

    # Se atirar onde ja atirou (2 ou 3), nao perde municao.
    j loop_principal

acertou_agua:
    li t4, 2
    sb t4, 0(t2)            
    print_str(msg_miss)
    
    addi s5, s5, -1         
    beqz s5, fim_derrota    
    j loop_principal

acertou_navio:
    li t4, 3
    sb t4, 0(t2)            
    print_str(msg_hit)

    addi s2, s2, 1          
    li t0, 5
    beq s2, t0, fim_vitoria 
    
    addi s5, s5, -1         
    beqz s5, fim_derrota    
    j loop_principal

    # ==========================================
    # 5. TELAS DE FIM DE JOGO
    # ==========================================
fim_vitoria:
    print_str(msg_win)
    j encerrar

fim_derrota:
    print_str(msg_lose)

encerrar:
    li a7, EXIT               
    ecall

# Inclusao das funcoes (obrigatoriamente no final)
.include "functions.asm"