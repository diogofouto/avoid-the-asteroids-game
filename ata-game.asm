; Diogo Fouto


; ******************************************************************************
;    CONSTANTES
; ******************************************************************************
ECRA           EQU  8000H  ; Endereco do ecra (PixelScreen)
DISPLAYS   	   EQU  0A000H ; Endereco de displays (periferico POUT-1)
TEC_LIN   	   EQU  0C000H ; Endereco das linhas do teclado (periferico POUT-2)
TEC_COL   	   EQU  0E000H ; Endereco das colunas do teclado (periferico PIN)
BYTES_ECRA     EQU  128    ; Tamanho do ecra em bytes
BYTE_XADREZ    EQU  0AAH   ; Byte para escrever no ecra e desenhar um padrao
BYTE_0         EQU  000H   ; Byte para limpar o ecra
N_BYTES_LINHA  EQU  4      ; Numero de bytes por cada linha do ecra




; ******************************************************************************
;    DADOS
; ******************************************************************************
PLACE       1000H
pilha:      TABLE 100H      ; Reservado para a pilha (200H bytes = 100H words)
SP_inicial:                 ; Endereco (1200H) com que o SP e inicializado




; O algorismo "2" nos dados em baixo apenas funciona como valor para fazer 
; return caso o "bit a ser desenhado" for esse

dados_nave:
	STRING 27,0             ; Linha e coluna iniciais da nave
	STRING 0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0
	STRING 0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0
	STRING 0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0
	STRING 0,1,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,1,0
	STRING 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,2

dados_volante_inicial:
    STRING 29,14            ; Linha e coluna iniciais para o volante
    STRING 0,0,0,0          
    STRING 1,1,1,1          
    STRING 0,0,0,0,2         

dados_volante_virar_e:
	STRING 29,14
	STRING 0,0,0,1
	STRING 0,1,1,0
	STRING 1,0,0,0,2

dados_volante_virar_d:
	STRING 29,14
	STRING 1,0,0,0
	STRING 0,1,1,0
	STRING 0,0,0,1,2
	
mascaras:
    STRING 80H, 40H, 20H, 10H
    STRING 8H, 4H, 2H, 1H




; Asteróide de apenas um pixel. Os dois primeiros valores indicam a linha e coluna
; onde comecam, respetivamente					  
asteroide_MP:
	STRING 0,16
	STRING 1,2
	
	
; Asteróide composto por uma matriz 2x2 totalmente preenchida	
asteroide_P:
	STRING 2, 15
	STRING 1, 1			  
	STRING 1, 1,2

; Asteróide "mau" em formato de cruz, numa matriz 3x3
asteroide_M_M:
	STRING 5,16
	STRING 0, 1, 0			  
	STRING 1, 1, 1
	STRING 0, 1, 0,2
	
; Asteróide "mau" composto por uma matriz 4x4
asteroide_M_G:
	STRING  9,15 
	STRING	0, 1, 1, 0 
	STRING	1, 1, 1, 1
	STRING	1, 1, 1, 1
	STRING  0, 1, 1, 0,2

; Asteróide "mau" composto por uma matriz 5x5
asteroide_M_MG:
	STRING 14,14
	STRING 0, 1, 1, 1, 0
	STRING 1, 1, 1, 1, 1
	STRING 1, 1, 1, 1, 1
	STRING 1, 1, 1, 1, 1
	STRING 0, 1, 1, 1, 0,2

; Asteróide destruído, numa matriz 5x5
asteroide_destruido:
	STRING 14, 14
	STRING 0, 1, 0, 1, 0
	STRING 1, 0, 1, 0, 1
	STRING 0, 1, 0, 1, 0
	STRING 1, 0, 1, 0, 1
	STRING 0, 1, 0, 1, 0,2

; Asteróide "bom" em forma de "X", numa matriz 3x3
asteroide_B_M:
	STRING 5, 16 
	STRING 1, 0, 1
	STRING 0, 1, 0
	STRING 1, 0, 1,2
	
; Asteróide "bom", numa matriz 4x4
asteroide_B_G:
	STRING 9,15
	STRING 1, 0, 0, 1
	STRING 0, 1, 1, 0
	STRING 0, 1, 1, 0
	STRING 1, 0, 0, 1,2

; Asteróide "bom" em forma de "X", numa matriz 5x5
asteroide_B_MG:
	STRING 14, 14
	STRING 1, 0, 0, 0, 1
	STRING 0, 1, 0, 1, 0
	STRING 0, 0, 1, 0, 0
	STRING 0, 1, 0, 1, 0
	STRING 1, 0, 0, 0, 1,2
	
	
	
	
; Tabela das rotinas de interrupcao:
tab:  
	WORD asteroide          ; Rotina de atendimento da interrupcao asteroide
	WORD rot_int_missil     ; Rotina de atendimento da interrupcao missil

linha_info:                 ; Contem o valor da linha da tecla que o teclado escreveu
    WORD 1

coluna_info:                ; Contem o valor da coluna da tecla premida
	WORD 1

valor_invalido:             ; Assinala se uma tecla foi premida ou nao:
	WORD 0                  ; Se for 0, entao foi; Se for 2, entao nao foi

dados_gerador:              ; Guarda o valor atual do gerador
	WORD 0

linha_missil:               ; Linha onde comeca o missil
	WORD 26
	
N_LINHAS_MISSIL:            ; Alcance (em linhas) do missil
	WORD 14

linha_asteroide:            ; Linha em que o asteroide está
    WORD 0                  

desenhar_0:                 ; Desenhar o BIT a 0
	WORD 0
	
dados_pontuacao:            ; Guarda o valor da pontuacao
	WORD 0                    





; ******************************************************************************
;    CODIGO
; ******************************************************************************
PLACE 0



;*******************************************************************************
; START - Inicializa BTE (Registo de Base da Tabela de Excecoes)
;       - SP na posicao inicial
;       - Limpa ecra
;       - Inicializa os displays
;       - Espera que seja premida a tecla c e depois:
;       - Comeca o jogo
; ******************************************************************************
start:
	MOV  BTE, tab             
    MOV  SP, SP_inicial
    CALL limpar_ecra
	CALL inicializar_displays
    CALL press_start
	EI0                       ; permite interrupcao 0
	EI1                       ; permite interrupcao 1
    EI                        ; permite interrupcoes (geral)




; ******************************************************************************
; NOVO_JOGO - Desenha a nave no ecra
;           - Comeca os processos cooperativos
; ******************************************************************************	
novo_jogo:
    CALL launch_spaceship




; ******************************************************************************
; MAIN - programa principal, chama os processos cooperativos
; ******************************************************************************
main:
	CALL asteroide
    CALL teclado
    CALL testar_virar_nave
	CALL testa_missil
	CALL controlo
	CALL gerador
    JMP  main                   ; Repete os processos




; ******************************************************************************
; GERADOR   - É 0 ou 1,  altera com cada ciclo de processos cooperativos
; ******************************************************************************
gerador:
	PUSH R0
	PUSH R1
	
	MOV  R0, dados_gerador
	MOV  R1, [R0]
	
	SUB  R1, 1              ; Como o gerador comeca a 0, ira variar sempre entre
	NEG  R1                 ; 0 e 1
	
	MOV [R0], R1
	
	POP  R1
	POP  R0
	RET
	
	
	

; ******************************************************************************
; LIMPAR_ECRA - Coloca o ecra a 0 quando o programa comeca
; ******************************************************************************
limpar_ecra:
    PUSH R1
	
    MOV  R1, BYTE_0
	CALL limpar_ecra_ou_xadrez
	
    POP  R1
    RET




; ******************************************************************************
; PRESS_START - Rotina que inicia o jogo se a tecla clicada for a "c"
; ******************************************************************************
press_start:
  	PUSH R4
	
	MOV  R4, 081H               ; Queremos que a tecla "c" seja premida
	CALL press_menu
	
	POP  R4
	RET  



	
;*******************************************************************************
; INICIALIZAR_DISPLAYS - Inicia os displays a 0
;*******************************************************************************
inicializar_displays:
    PUSH R0
    PUSH R1
	
    MOV  R0, DISPLAYS
    MOV  R1, 0                  ; displays a 0
    MOVB [R0], R1
	
  	POP  R1
  	POP  R0
  	RET




;*******************************************************************************
; LAUNCH_SPACESHIP - Rotina que desenha a consola e o volante da nave no ecra
;*******************************************************************************
launch_spaceship:
    PUSH R0
    PUSH R1
    PUSH R2
	PUSH R3
	PUSH R4
	PUSH R5
	PUSH R6
	PUSH R7
	
	MOV  R0, dados_nave
	MOVB R1, [R0]
	ADD  R0, 1
	MOVB R2, [R0]
	MOV  R4, 2
	MOV  R5, 31
	MOV  R6, 0
	CALL desenhar_objeto
	
	POP  R7
	POP  R6
	POP  R5
	POP  R4
	POP  R3
    POP  R2
	POP  R1
    POP  R0
    RET




; ******************************************************************************
; PRESS_MENU - Rotina bloqueante que so faz return quando a tecla desejada seja
;            - premida
; ARGUMENTO: R4 - Contem o valor da tecla desejada  (Em hexadecimal)
; ******************************************************************************	
press_menu:
	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R3

ler:	
  	MOV  R0, TEC_LIN
  	MOV  R1, TEC_COL
  	MOV  R2, 8	
  	MOVB [R0], R2
  	MOVB R3, [R1]       ; Ler teclado
  	SHL  R2, 4
  	OR   R2, R3
  	CMP  R2, R4
  	JNZ  ler            ; Se a tecla desejada não tiver sido clicada, repete

return_press_menu:
    POP  R3
    POP  R2
    POP  R1
    POP  R0
    RET                 ; So faz return quando a tecla e clicada




; ******************************************************************************
; DESENHAR_OBJETO   - Desenha um objeto dado
; Argumentos:    R0 - Endereco com objeto a ser desenhado
;                R1 - Linha onde se comeca a ser desenhado
;                R2 - Coluna onde se comeca a ser desenhado
;                R4 - Contem o valor que se R3 o igualar entao faz return
;                R5 - Coluna final a desenhar
;                R6 - Coluna inicial a desenhar
; ******************************************************************************
desenhar_objeto:
	ADD  R0, 1
	MOVB R3, [R0]
	
	CMP  R3, R4
	JZ   return_desenhar_objeto
	
	CALL desenhar_bit
	
	CMP  R2, R5
	JZ   coluna_linha_seguinte
	
	ADD  R2, 1
	JMP  desenhar_objeto	
	
coluna_linha_seguinte:
	MOV  R2, R6
	ADD  R1, 1
	JMP  desenhar_objeto

return_desenhar_objeto:
	RET
	



; **********************************************************************
; LIMPAR_ECRA_OU_XADREZ  - Escreve todos os bytes do ecra
; Argumentos:    R1 - Valor do byte a escrever
; **********************************************************************
limpar_ecra_ou_xadrez:              
    PUSH  R2
    PUSH  R3
    PUSH  R4
    PUSH  R5
	
    MOV   R2, 0               ; usado para indicar qual o byte dentro do ecra
    MOV   R3, BYTES_ECRA      ; tamanho do ecra em bytes
	
proximo_byte:
    MOV   R4, N_BYTES_LINHA   ; numero de bytes por cada linha do ecra
    MOV   R5, R2              ; copia para nao estragar o R2
    MOD   R5, R4              ; ou seja, R2 e multiplo de N_BYTES_LINHA?
    JZ    testar_troca_r1     ; numero do byte a escrever e o primeiro de uma linha?  
	
escreve_byte:
    CALL  desenhar_unico_byte ; escreve o byte dado por R1 no ecra
    ADD   R2, 1               ; mais um byte escrito
    CMP   R2, R3              ; ja chegamos ao fim?
    JLT   proximo_byte
	
    POP   R5                  ; recupera valor dos registos
    POP   R4
    POP   R3
    POP   R2
    RET
	
testar_troca_r1:              ; testamos se e para desenhar o xadrez ou limpar ecra
	PUSH  R6
	
	MOV   R6, BYTE_XADREZ
	CMP   R1, R6
	JZ    troca_r1
	NOT   R6
	CMP   R1, R6
	JZ    troca_r1
	
	POP   R6
	
	JMP   escreve_byte       ; e para limpar o ecra
	
troca_r1:
	POP   R6
	
	NOT   R1                 ; e para desenhar o xadrez, troca os bits do byte a escrever
	JMP   escreve_byte




; **********************************************************************
; DESENHAR_UNICO_BYTE  - Escreve apenas um byte no ecra
; Argumentos: R1 - Valor do byte a escrever
;             R2 - Numero do byte a escrever (entre 0 e BYTES_ECRA - 1)
; **********************************************************************
desenhar_unico_byte:
	PUSH  R0
	
	MOV   R0, ECRA            ; endereco do primeiro byte do ecra
	ADD   R0, R2              ; calcula endereco onde escrever o byte
    MOVB  [R0], R1            ; escreve o byte no ecra
	
	POP   R0
	RET




; ******************************************************************************
; DESENHAR_BIT   1 - Ler do ecra o byte em que o BIT se encontram
;                2 - Altera apenas esse BIT nesse byte (0 apaga, 1 desenha)
;                3 - Escreve o byte com o BIT alterado no mesmo endereço
; Argumentos:    R1: Contém o número da linha do pixel a ser desenhado
;                R2: Contem o numero da coluna do pixel a ser desenhado
;                R3: Contem o valor do BIT (1/0) a ser desenhado
; ******************************************************************************
desenhar_bit:
    PUSH R0
    PUSH R1
    PUSH R2
    PUSH R4
    PUSH R5
	
    MOV  R4, 4               ; Valor pelo qual a linha será multiplicada
    MOV  R5, 8               ; Valor pelo qual a coluna será dividida
    MOV  R0, ECRA            ; Endereco base do ecra
    MUL  R1, R4              ; Multiplicamos a linha por 4
    MOV  R4, R2              ; Copiamos a coluna para R4
    DIV  R2, R5              ; Divisao inteira da coluna por 8
    ADD  R0, R1              ; Soma-se o resultado ao endereco base do ecra
    ADD  R0, R2
    MOD  R4, R5              ; Peso N do bit
    MOV  R1, mascaras        ; Endereço das mascaras
    ADD  R1, R4              ; Encontramos a mascara correta
    MOVB R2, [R1]            ; Mascara correta para R2
    MOVB R4, [R0]            ; Copiar para R4 o valor lido do ecra
	
    CMP  R3, 0               ; Bit a 1 ou 0?
    JZ   bit_0

bit_1:                       ; Desenhar bit a 1
    OR   R4, R2
    JMP  escrever

bit_0:                       ; Desenhar bit a 0
    NOT  R2
    AND  R4, R2

escrever:
    MOVB [R0], R4            ; Escreve o bit

return_desenhar_bit:
    POP  R5
    POP  R4
    POP  R2
    POP  R1
    POP  R0
    RET




; ******************************************************************************
; GAME_OVER - Acaba o programa
;           - Desenha o xadrez
;           - Espera que a tecla de start seja premida e depois comeca o jogo
; ******************************************************************************
game_over:
    MOV  R1, BYTE_XADREZ      ; byte para escrever no ecra e desenhar o xadrez
    CALL limpar_ecra_ou_xadrez

esperar_novo_jogo:
	MOV  SP, SP_inicial
    CALL press_start
    CALL limpar_ecra
	CALL inicializar_displays
    JMP  novo_jogo




; ******************************************************************************
; TECLADO - Rotina que lê o teclado
;         - Se for premida uma tecla, assinala em "valor_invalido" 0
;         - Se não for premida, assinala em "valor_invalido" 2
;         - Guarda em "linha_info" e "coluna_info", o valor da tecla
; ******************************************************************************
teclado:
    PUSH R0
    PUSH R1
    PUSH R2
    PUSH R3
    PUSH R4
	PUSH R5
    PUSH R7
	PUSH R8
	PUSH R9
	
	MOV  R2, TEC_LIN        ; endereco do periferico das linhas
    MOV  R3, TEC_COL        ; endereco do periferico das colunas
    MOV  R7, linha_info     ; Coloca em R7 e R8, os enderecos dos 
	MOV  R8, coluna_info    ; dados das linha e coluna testadas anteriormente
	MOV  R9, valor_invalido 
	MOV  R5, 0
	MOV [R9], R5            ; Coloca valor_invalido a 0
    MOV  R1, [R7]    
	
proxima_linha:
    ROL  R1, 1              ; Passa para a proxima linha

escrever_linha:	
    MOVB [R2], R1           ; escrever no periferico de saida (linhas)
    MOVB R0, [R3]           ; ler do periferico de entrada (colunas)
	
guardar_dados:	
    MOV  [R7], R1           ; guarda qual a linha
	MOV  [R8], R0           ; guarda qual a coluna

tecla_nao_premida:	
	CMP  R0, R5
	JZ   valor_invalido_alterar
	
return_teclado:
	POP  R9
	POP  R8
    POP  R7 
	POP  R5
    POP  R4
    POP  R3
    POP  R2
    POP  R1
    POP  R0
    RET

valor_invalido_alterar:
	MOV  R1, 2            ; valor_invalido a 2, nao permite fazer as operacoes 
	MOV [R9], R1
	JMP  return_teclado
	



; ******************************************************************************
; TESTAR_VIRAR_NAVE - Se as teclas 0 ou 3 estiverem a ser premidas, vira a nave
;                   - Senao, mantem o volante na posicao inicial
; ******************************************************************************
testar_virar_nave:
    PUSH R1
    PUSH R2
	PUSH R3
	PUSH R4
    PUSH R6
	PUSH R7
	PUSH R8
	PUSH R9
	
	MOV  R3, 0
	MOV  R7, linha_info
	MOV  R8, coluna_info
	MOV  R9, valor_invalido
	MOV  R1, [R7]
	MOV  R2, [R8]
	MOV  R4, [R9]

testar_tecla:	
	MOV  R0, dados_volante_inicial
	CMP  R4, R3                         ; Se nao tiver sido premida nenhuma tecla
	JNZ  call_desenhar_objeto           ; Salta e desenha o volante inicial

testar_linha1:	
	MOV  R3, 1
	CMP  R1, R3                         ; Se uma tecla for premida, mas nao for
	JNZ  call_desenhar_objeto           ; na linha 1, desenha na posicao inicial
	
testar_tecla_1:
	MOV  R0, dados_volante_virar_e
	CMP  R2, R3                         ; Se a tecla 1 for premida,
	JZ   call_desenhar_objeto           ; Vira a esquerda
	
testar_tecla_3:	
	MOV  R0, dados_volante_virar_d
	MOV  R3, 8
	CMP  R2, R3                         ; Se a tecla 3 for premida,
	JZ   call_desenhar_objeto           ; Vira a direita

desenhar_volante_inicial:	
	MOV  R0, dados_volante_inicial      ; Se a tecla premida for a na linha 1 mas nao
	JMP  call_desenhar_objeto           ; para virar, desenha na posicao inicial


call_desenhar_objeto:
	MOVB R1, [R0]
	ADD  R0, 1
	MOVB R2, [R0]
	MOV  R4, 2                          
	MOV  R5, 17
	MOV  R6, 14
	
	CALL desenhar_objeto
	JMP  return_testar_virar_nave
	
return_testar_virar_nave:
	POP R9
	POP R8
	POP R7
	POP R6
	POP R4
	POP R3
	POP R2
	POP R1
	RET
	
	
	
	
; ******************************************************************************
; TESTA_MISSIL  - Se a tecla premida for a 1, dispara o missil e vai subindo-o
; ******************************************************************************	
testa_missil:
	PUSH R0
    PUSH R1
    PUSH R2
	PUSH R3
	PUSH R4
    PUSH R6
	PUSH R7
	PUSH R8
	PUSH R9
	
	MOV  R3, 0
	MOV  R7, linha_info
	MOV  R8, coluna_info
	MOV  R9, valor_invalido
	MOV  R1, [R7]
	MOV  R2, [R8]
	MOV  R4, [R9]

testar_se_tecla_premida:	
	CMP  R4, R3
	JNZ  return_testa_missil

testar_a_linha1:	
	MOV  R3, 1
	CMP  R1, R3
	JNZ  return_testa_missil
	
testar_tecla_missil:	
	MOV  R3, 2
	CMP  R2, R3
	JNZ  return_testa_missil
	
tecla_missil_premida:	
	CALL rot_int_missil
	
return_testa_missil:
	POP R9
	POP R8
	POP R7
	POP R6
	POP R4
	POP R3
	POP R2
	POP R1
	POP R0
	RET

rot_int_missil:
    PUSH R2
    MOV  R2, 16              ; coluna em que a missil e desenhado
    CALL missil              ; desenha o missil no ecra
    POP  R2
    RFE                      ; Return From Exception

missil:
    PUSH R1
	PUSH R3
    PUSH R4
    PUSH R5
	
    MOV  R4, linha_missil
    MOV  R1, [R4]            ; Linha em que o missil esta
    MOV  R3, 0               ; Para apagar o missil
    CALL desenhar_bit        ; Apaga o missil do ecra
    SUB  R1, 1               ; Passa para linha acima
    MOV  R5, N_LINHAS_MISSIL
    CMP  R1, R5              ; Ja chegou ao seu alcance maximo?
    JGT  anima_missil
    JMP  return_missil
	
anima_missil:
    MOV  [R4], R1            ; Atualiza a linha em que o missil esta na variavel
    MOV  R3, 1               ; Valor do missil
    CALL desenhar_bit        ; Escreve o missil na nova linha

return_missil:
    POP  R5
    POP  R4
	POP  R3
    POP  R1
    RET
	



; ******************************************************************************
; CONTROLO   - Verifica se foram premidas as teclas C/D/E
;            - C: reinicia o jogo
;            - D: pausa o jogo
;            - E: Game Over ao jogo
; ******************************************************************************
controlo:
	PUSH R0
    PUSH R1
    PUSH R2
	PUSH R3
	PUSH R4
    PUSH R6
	PUSH R7
	PUSH R8
	PUSH R9
	
	MOV  R3, 0
	MOV  R7, linha_info
	MOV  R8, coluna_info
	MOV  R9, valor_invalido
	MOV  R1, [R7]
	MOV  R2, [R8]
	MOV  R4, [R9]
	
testar_se_tecla_clicada:	
	CMP  R4, R3
	JNZ  return_controlo
	
testar_linha_4:	
	MOV  R3, 8
	CMP  R1, R3
	JNZ  return_controlo

testar_start:
	MOV  R3, 1
	CMP  R2, R3
	JZ   jmp_start
	
testar_game_over:
	MOV  R3, 4
	CMP  R2, R3
	JZ   jmp_game_over

chamar_pausa:
	MOV  R3, 2
	CALL pausa
	
return_controlo:
	POP R9
	POP R8
	POP R7
	POP R6
	POP R4
	POP R3
	POP R2
	POP R1
	POP R0
	RET

jmp_start:
	JMP start

jmp_game_over:
	JMP game_over

pausa:
  	PUSH R4
	
	MOV  R4, 0DH                ; Valor da tecla "d"
	CALL press_menu
	
    POP  R4
    RET
	
	

	
; ******************************************************************************
; ASTEROIDE - Desenha o asteroide no ecra 
;           - O tipo do asteroide e determinado pelo gerador
;           - Se o gerador for 1, desenha asteroide bom
;           - Se o gerador for 0, desenha asteroide mau
; ******************************************************************************
asteroide:
	PUSH R0
	PUSH R1
	CALL anima_asteroide_b
	POP R1
	POP R0
	RFE
	

anima_asteroide_b:            ; Anima asteroide bom
    PUSH R2
    PUSH R4
    PUSH R5
	
	MOV  R4, linha_asteroide  ; Linha em que o asteroide está
	MOV  R2, [R4]   
	
    MOV  R5, 2
    CMP  R2, R5              
    JLT  escreve_1x1
	
	MOV  R5, 5
	CMP  R2, R5
	JLT  escreve_2x2
	
	MOV  R5, 9
	CMP  R2, R5
	JLT  escreve_B_3X3
	
	MOV  R5, 14
	CMP  R2, R5
	JLT  escreve_B_4x4
	
	MOV  R5, 22
	CMP  R2, R5
	JLT  escreve_B_5X5
	
	JMP  escreve_destruido

	
	
escreve_1x1:     
	CALL limpar_desenho_destruido
    CALL desenho_1X1             ; escreve o asteroide na nova linha
	JMP  return_anima_asteroide	
	
escreve_2x2:
	CALL limpar_desenho_1X1
	CALL desenho_2X2
	JMP  return_anima_asteroide	
	
escreve_B_3X3:
	CALL limpar_desenho_2X2
	CALL desenho_B_3X3
	JMP  return_anima_asteroide	
	
escreve_B_4x4:
	CALL limpar_desenho_B_3X3
	CALL desenho_B_4X4
	JMP  return_anima_asteroide	
	
escreve_B_5X5:
	CALL limpar_desenho_B_4X4
	CALL desenho_B_5X5
	JMP  return_anima_asteroide	

escreve_destruido:
	CALL desenho_destruido
	CALL pontuacao
	MOV  R2, 0                   ; volta ao topo do ecrã
	MOV  [R4], R2
	JMP  return_anima_asteroide

return_anima_asteroide:
	ADD  R2, 1
	MOV  [R4], R2                ; Atualiza a linha em que o asteroide está na variável
	POP  R5
    POP  R4
    POP  R2
	RET
	


desenho_1X1:
	PUSH R0
	PUSH R1
	PUSH R2	
	PUSH R3
	PUSH R4
	PUSH R5
	PUSH R6
	
	MOV  R0, asteroide_MP
	MOV  R4, linha_asteroide
	MOV  R1, [R0]
	ADD  R0, 1
	MOV  R2, [R4]
	MOV  R4, 2
	MOV  R5, 16
	MOV  R6, 16
	
	JMP  chamar_desenhar_objeto
	
	
	
desenho_2X2:
	PUSH R0
	PUSH R1
	PUSH R2	
	PUSH R3
	PUSH R4
	PUSH R5
	PUSH R6
	
	MOV  R0, asteroide_P
	MOV  R4, linha_asteroide
	MOV  R1, [R0]
	ADD  R0, 1
	MOV  R2, [R4]
	MOV  R4, 2
	MOV  R5, 16
	MOV  R6, 15
	
	JMP  chamar_desenhar_objeto



desenho_B_3X3:
	PUSH R0
	PUSH R1
	PUSH R2	
	PUSH R3
	PUSH R4
	PUSH R5
	PUSH R6
	
	MOV  R0, asteroide_B_M
	MOV  R4, linha_asteroide
	MOV  R1, [R0]
	ADD  R0, 1
	MOV  R2, [R4]
	MOV  R4, 2
	MOV  R5, 18
	MOV  R6, 16
	
	JMP  chamar_desenhar_objeto

	
	
	
desenho_B_4X4:
	PUSH R0
	PUSH R1
	PUSH R2	
	PUSH R3
	PUSH R4
	PUSH R5
	PUSH R6
	
	MOV  R0, asteroide_B_G
	MOV  R4, linha_asteroide
	MOV  R1, [R0]
	ADD  R0, 1
	MOV  R2, [R4]
	MOV  R4, 2
	MOV  R5, 18
	MOV  R6, 15
	
	JMP  chamar_desenhar_objeto
	
	
	
desenho_B_5X5:
	PUSH R0
	PUSH R1
	PUSH R2	
	PUSH R3
	PUSH R4
	PUSH R5
	PUSH R6
	
	MOV  R0, asteroide_B_MG
	MOV  R4, linha_asteroide
	MOV  R1, [R0]
	ADD  R0, 1
	MOV  R2, [R4]
	MOV  R4, 2
	MOV  R5, 18
	MOV  R6, 14
	
	JMP  chamar_desenhar_objeto

desenho_destruido:
	PUSH R0
	PUSH R1
	PUSH R2	
	PUSH R3
	PUSH R4
	PUSH R5
	PUSH R6
	
	MOV  R0, asteroide_destruido
	MOV  R4, linha_asteroide
	MOV  R1, [R0]
	ADD  R0, 1
	MOV  R2, [R4]
	MOV  R4, 2
	MOV  R5, 18
	MOV  R6, 14
	
	JMP  chamar_desenhar_objeto

	
limpar_desenho_1X1:
	PUSH R0
	PUSH R1
	PUSH R2	
	PUSH R3
	PUSH R4
	PUSH R5
	PUSH R6
	
	MOV  R0, asteroide_MP
	MOV  R4, linha_asteroide
	MOV  R1, [R0]
	ADD  R0, 1
	MOV  R2, [R4]
	SUB  R2, 1
	MOV  R4, 2
	MOV  R5, 16
	MOV  R6, 16
	MOV  R0, desenhar_0
	
	JMP  chamar_desenhar_objeto

limpar_desenho_2X2:
	PUSH R0
	PUSH R1
	PUSH R2	
	PUSH R3
	PUSH R4
	PUSH R5
	PUSH R6
	
	MOV  R0, asteroide_P
	MOV  R4, linha_asteroide
	MOV  R1, [R0]
	ADD  R0, 1
	MOV  R2, [R4]
	SUB  R2, 2
	MOV  R4, 2
	MOV  R5, 16
	MOV  R6, 15
	MOV  R0, desenhar_0
	
	JMP  chamar_desenhar_objeto

limpar_desenho_B_3X3:
	PUSH R0
	PUSH R1
	PUSH R2	
	PUSH R3
	PUSH R4
	PUSH R5
	PUSH R6
	
	MOV  R0, asteroide_B_M
	MOV  R4, linha_asteroide
	MOV  R1, [R0]
	ADD  R0, 1
	MOV  R2, [R4]
	SUB  R2, 3
	MOV  R4, 2
	MOV  R5, 18
	MOV  R6, 16
	MOV  R0, desenhar_0
	
	JMP  chamar_desenhar_objeto
	
limpar_desenho_B_4X4:
	PUSH R0
	PUSH R1
	PUSH R2	
	PUSH R3
	PUSH R4
	PUSH R5
	PUSH R6
	
	MOV  R0, asteroide_B_G
	MOV  R4, linha_asteroide
	MOV  R1, [R0]
	ADD  R0, 1
	MOV  R2, [R4]
	SUB  R2, 4
	MOV  R4, 2
	MOV  R5, 18
	MOV  R6, 15
	MOV  R0, desenhar_0
	
	JMP  chamar_desenhar_objeto
	
limpar_desenho_destruido:
	PUSH R0
	PUSH R1
	PUSH R2	
	PUSH R3
	PUSH R4
	PUSH R5
	PUSH R6
	
	MOV  R0, asteroide_destruido
	MOV  R4, linha_asteroide
	MOV  R1, [R0]
	ADD  R0, 1
	MOV  R2, [R4]
	SUB  R2, 5
	MOV  R4, 2
	MOV  R5, 18
	MOV  R6, 15
	MOV  R0, desenhar_0
	
	JMP  chamar_desenhar_objeto
	
	
chamar_desenhar_objeto:
	CALL desenhar_objeto
	JMP  return_desenhar_asteroide


return_desenhar_asteroide:
	POP  R6 
	POP  R7
	POP  R5
	POP  R4
	POP  R3
	POP  R2
	POP  R1
	POP  R0
	RET




; ******************************************************************************
; PONTUACAO - Aumenta os pontos se houver uma colisao com um asteroide bom
; ******************************************************************************
pontuacao:
	PUSH R4
	PUSH R5
	PUSH R6
	PUSH R7
	PUSH R8
	PUSH R9
	
	MOV  R4, DISPLAYS
	MOV  R8, 3
	MOV  R9, dados_pontuacao   ; Pontuaco anterior

somar_pontos:
    ADD  R9, R8                ; Aumentar os pontos por 3
    MOV  R6, 10
    MOV  R7, R9
    MOV  R5, R9
    DIV  R7, R6                ; Conversão da pontuação de hexadecimal para decimal
    MOD  R5, R6
    PUSH R9
	
    MOV  R9, 10
    CMP  R7, R9                ; Se o algarismo das dezenas chegar ao A
                               ; (10 em decimal), então salta e verifica se o
    JZ  pontuacao_chegou_99    ; algarismo das unidades já passou o 9
	JMP continua_somar

continua_somar:
    SHL R7, 4                  ; Pôr o algarismo que corresponde às dezenas no
                               ; nibble high
    OR  R7, R5                 ; Juntar as unidades no nibble low ao R7
    MOVB [R4], R7              ; Colocamos a pontuação nos displays
	
	POP R9
	POP R8
	POP R7
	POP R6
	POP R5
	POP R4
	RET

	
pontuacao_chegou_99:          ; Confirmamos se o algarismo das unidades já passou
    MOV R9, 2                 ; o 9(decimal)
                              ; Quando se chega às 9 unidades, o próximo algarismo
                              ; das unidades é o 2
    CMP R5, R9                ; Verificamos se o algarismo das unidades é o 2
    POP R9
	
    JNZ continua_somar        ; Se não passou, então continua a aumentar
    JMP game_over             ; os pontos normalmente. 
							  ; Se passou, faz game over.





