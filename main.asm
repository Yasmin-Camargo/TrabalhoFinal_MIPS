# JOGO DA FORCA - PROJETO FINAL - AOC
# Caroline Souza Camargo
# Yasmin Souza Camargo
 
.data
letra: .space 2
palavra: .space 20
pforca: .space 40
dica: .space 30
letrasDigitadas: .space 26

espaco: .asciiz " "
opMenu: .asciiz " \n\n @@@@@           JOGO DA FORCA\n@             @\n@          @@@\n@\n@             | 1 |   ----------  Jogar\n@             | 2 |   ----------  Sobre \n@             | 0 |   ----------  Sair\n@@\n\n Atenção: São permitido 5 erros\n\n"
desenvolvedores1: .asciiz "\nDESENVOLVEDORES: \n\n"
desenvolvedores2: .asciiz "Caroline Souza Camargo \nYasmin Souza Camargo\n"
stringGanhou: .asciiz " \n----------- PARABÉNS!!! -----------\n\nVocê Acertou todas palavras"
stringPerdeu: .asciiz " \n----------- Você Perdeu :( -----------  \n\n A quantidade de chutes errados foi atingida\n A palavra era:  "
 stringDigiteTamanho: .asciiz " \nPor favor, Digite a Quantidade de Letras da Palavra:"
stringDigitePalavra: .asciiz " \nPor favor, Digite a Palavra:"
stringDigiteDica: .asciiz " \nPor favor, Digite a dica da Palavra:"
stringDigiteLetra: .asciiz " \nPor favor, Digite uma letra:"
     
# _____Consulta registradores _____________________________________________
#                                                                             |  	
#    $s0 --->  Guarda a quantidade máxima de chutes errados                   |  
#    $s1 --->  Guarda o tamanho da palavra                                    |  
#    $s2 --->  Guarda a quantidade atual de chutes errados                    |  
#    $s3 --->  Contador (Guarda a quantidade de letras acertadas)             |
#    $s4 --->  booleana                                                       | 	 
#    $s5 --->  Endereço do Pforca                                             |
#    $s6 --->  Endereço da palavra                                            |
#    $s7 --->  Endereço da letra                                              |
#                                                                             |
# Nos temporarios seguimos este padrão                                        |
#    $t6:  i++ do while                                                       |
#    $t7: Códigos de erro                                                     |
# _________________________________________________________________________   |

.text
# Define a quantidade de chutes errados que o jogo da forca vai permitir
addi $s0, $zero, 5
 
   # -------------- MENU ---------------------
   menu:
   # Mostra o menu
   li $v0, 51
   la $a0, opMenu
   syscall
   
   # Tratamento de erros
   li $t7, -4 # -4 para indicar que o erro foi no menu
   li $t8, -1 # dado inserido é invalido
   beq $a1, $t8, invalida
   li $t1, -2 # opcao cancelar foi escolhida
   beq $a1, $t8, sair
   li $t8, -3 # nenhum dado foi digitado
   beq $a1, $t8, invalida
   slti $t8, $a0, 3 # numero não corresponde a nenhuma opção do menu
   beq $t8, $zero, invalida
   
   # Direciona para parte do código correspondente
   beq $a0, $zero, sair
   li $t8, 1
   beq $a0, $t8, jogar
   li $t8, 2
   beq $a0, $t8, sobre
   j menu
   
   # -------------- JOGAR ---------------------
   jogar:
   jal FUNCAO_LeituraTamanhoPalavra
   move $s1, $v0 # recebe tamanho da palavra
   lerPalavra:
   move $a0, $s1 # manda tamanho da palavra como argumento
   jal FUNCAO_LeituraPalavra
   jal FUNCAO_LeituraDica
   move $a0, $s1 # manda tamanho da palavra como argumento
   jal FUNCAO_InicializaComUnderlines
   move $s3, $v0 # recebe quantidade de letras acertadas
   addi $s2, $zero, 0 # erros = 0
   
   # Lê caracter até adivinhar a palavra
   while2:
    beq $s3,  $s1, volta2 # cont == quantidade de letras
    jal FUNCAO_LerCaracter
    jal FUNCAO_VerificaLetra
 
    #Inicializa endereços dos registradores
    la  $s6, palavra
    la $s5, pforca
    lbu $s7, letra
    addi $t6, $zero, 1 # i = 1

# Verifica se a letra digitada está presente em alguma parte da palavra
 	 addi $s4, $zero, 0 # indica se acertou ou não alguma letra
    while3:
    beq $t6, $s1, volta3 # i = quantidade de palavras
    lbu $t8, 0($s6)
    if: bne $t8, $s7, else # caracter == palavra[i]
    		sb $s7, 0($s5)
    		addi $s3, $s3, 1 # cont++
    		addi $s4, $zero, 1 # indica que acertou  
    else:
    addi $s6, $s6, 1 # palavra[i+1]
    addi $s5, $s5, 2 # pforca[i+2]
    addi $t6, $t6, 1 # i++
    j while3
   
    volta3:
    bne $s4, $zero, continua3
    addi $s2, $s2, 1 # erros++
    beq $s2, $s0, perdeu # erros == total de erros permitidos
   
    continua3 :
    li $v0, 59
  	 la $a0, dica
    la $a1, pforca
    syscall
j while2

   volta2:
   j somGanhou
   ganhou:
   li $v0, 59
   la $a0, stringGanhou
   la $a1, espaco
   syscall
   j menu
   
         
   # -------------- SOBRE ---------------------
   sobre:
   # Mostra as informacoes
   li $v0, 59
   la $a0, desenvolvedores1
   la $a1, desenvolvedores2
   syscall
   j menu
   
   
   # -------------- SAIR ---------------------
sair:
li $v0, 10  # encerra programa
syscall
   
   # -------------- FUNÇÕES ---------------------
   
FUNCAO_LeituraTamanhoPalavra:
   li $v0, 51
   la $a0, stringDigiteTamanho
   syscall
   move $t0, $a0 # tam
   addi $t0, $t0, 1 # tam++
   
   # Tratamento de erros
   li $t7, -5 # -5 para indicar que o erro foi no momento de ler o tamanho da palavra
   li $t8, -1 # dado inserido é invalido
   beq $a1, $t8, invalida
   li $t8, -2 # opcao cancelar foi escolhida
   beq $a1, $t8, menu
   li $t8, -3 # nenhum dado foi digitado
   beq $a1, $t8, invalida
   
   move $v0, $t0 # retorna o tamanho da palavra
jr $ra


FUNCAO_LeituraPalavra:
   move $t0, $a0 # tamanho da palavra
   # Lê a palavra
   li $v0, 54
   la $a0, stringDigitePalavra
   la $a1, palavra
   move $a2, $t0
   syscall
   
   # Tratamento de erros
   li $t7, -6 # -6 para indicar que o erro foi no momento de ler a palavra
   li $t8, -2 # opcao cancelar foi escolhida
   beq $a1, $t8, menu
   li $t8, -3 # nenhum dado foi digitado
   beq $a1, $t8, invalida
   li $t8, -4 # tamanhoo máximo da palavra foi excedido
   beq $a1, $t8, invalida
   
   #Inicializa letras digitadas
   la $t1, letrasDigitadas
   li $t3, 0x0 # Coloca um \0
	sb $t3, 0($t1)
 jr $ra  
 
FUNCAO_LeituraDica:
  # Escreve "DICA: " na memória e lê a dica
   la $t0, dica
   li $t1, 0x44 # Coloca um D
   sb $t1, 0($t0)
   addi $t0, $t0, 1
   li $t1, 0x49 # Coloca um I
   sb $t1, 0($t0)
   addi $t0, $t0, 1
   li $t1, 0x43 # Coloca um C
   sb $t1, 0($t0)
   addi $t0, $t0, 1
   li $t1, 0x41 # Coloca um A
   sb $t1, 0($t0)
   addi $t0, $t0, 1
   li $t1, 0x3A # Coloca um :
   sb $t1, 0($t0)
   addi $t0, $t0, 1
   li $t1, 0x20 # Coloca um espaço
   sb $t1, 0($t0)
   addi $t0, $t0, 1
   
	lerDica:
   # Lê a dica
   addi $t2, $zero, 22 # sobrou 22 bytes para armazenar a dica
   li $v0, 54
   la $a0, stringDigiteDica
   la $a1, 0($t0)
   move $a2, $t2
   syscall

   # Tratamento de erros
   li $t7, -7 # -7 para indicar que o erro foi no momento de ler a dica
   li $t8, -2 # opcao cancelar foi escolhida
   beq $a1, $t8, menu
   li $t8, -3 # nenhum dado foi digitado
   beq $a1, $t8, invalida
   
   addi $t0, $t0, 22
   li $t1, 0xa # Coloca um /n
   sb $t1, 0($t0)
   addi $t0, $t0, 1
   li $t1, 0x0 # Coloca um \0
   sb $t1, 0($t0)
 jr $ra
 
 
FUNCAO_InicializaComUnderlines:
	move $t0, $a0 # salva no registrador $t0 o tamanho da palavra

   la  $t1, palavra # guarda o endereço da palavra
   la $t2, pforca # guarda o endereço da palavra da forca
   
   addi $t3, $zero, 1 # cont = 1
   addi $t5, $zero, 1 # i = 1
   
   while1:
    beq $t5, $t0, continua1
   
    li $t4, 0x20 # Se for um espaço coloca um hifem na palavra da forca
    lb $t6, 0($t1)
    bne $t6, $t4, naoTemEspaco
    addi $t3, $t3, 1 # cont++
    li $t4, 0x2d # -
    sb $t4, 0($t2)
    j continua
   
    naoTemEspaco:
    li $t4, 0x5f # Inicializa com _
    sb $t4, 0($t2)
   
    continua:
    addi $t2, $t2, 1 # pforca[i+1]
    li $t4, 0x20 # Coloca um espaço
    sb $t4, 0($t2)
   
    addi $t1, $t1, 1 # palavra[i+1]
    addi $t2, $t2, 1 # pforca[i+1]
    addi $t5, $t5, 1 # i++
    j while1
   
   continua1:
   li $t4, 0x0 # Coloca um \0
   sb $t4, 0($t2)
   
   # Mostra a palavra da forca
   li $v0, 59
   la $a0, dica
   la $a1, pforca
   syscall
   
   move $v0, $t3 # retorna o cont de letras acertadas (Pois os - das palavras compostas são considerados como acertos)
jr $ra


FUNCAO_LerCaracter:
	lerCaracter:
	addi $t4, $zero, 2 # tamanho 2 (letra + /0)
	li $v0, 54
	la $a0, stringDigiteLetra
	la $a1, letra
	move $a2, $t4
	syscall

	# Tratamento de erros
	li $t7, -8 # -8 para indicar que o erro foi no momento de ler o caracter digitado
	li $t8, -1 # dado inserido é invalido
	beq $a1, $t8, invalida
	li $t8, -2 # opcao cancelar foi escolhida
	beq $a1, $t8, menu
	li $t8, -3 # nenhum dado foi digitado
	beq $a1, $t8, invalida
	li $t8, -4 # digitou mais de uma letra
	beq $a1, $t8, invalida
 jr $ra
 
FUNCAO_VerificaLetra:
	li $t7, -9
	la $t0, letrasDigitadas
	lb $t1, letra
	while4:
	lb $t2, 0($t0)
	beq $t2, $zero, armazenaLetra
	beq $t1, $t2, invalida # se encontrou uma letra que já foi digitada é requitado uma nova letra
	addi $t0, $t0, 1
	j while4

	armazenaLetra:
	sb $t1, 0($t0) # armazena letra na lista de letras que já foram digitadas
	addi $t0, $t0, 1
	li $t3, 0x0 # Coloca um \0
	sb $t3, 0($t0)
jr $ra


# -------------- SONS ---------------------
perdeu:
   # som para indicar que a pessoa digitou uma opcao invalida
   li $v0, 31
   la $a0, 61
   la $a1, 3000
   la $a2, 119
   la $a3, 100
   syscall
   li $v0, 31
   la $a0, 61
   la $a1, 3000
   la $a2, 118
   la $a3, 100
   syscall
   li $v0, 31
   la $a0, 61
   la $a1, 3000
   la $a2, 118
   la $a3, 100
   syscall
   li $v0, 31
   la $a0, 61
   la $a1, 3000
   la $a2, 118
   la $a3, 100
   syscall
   li $v0, 31
   la $a0, 61
   la $a1, 3000
   la $a2, 118
   la $a3, 100
   syscall
   li $v0, 31
   la $a0, 61
   la $a1, 2000
   la $a2, 80
   la $a3, 100
   syscall
   
   li $v0, 59
   la $a0, stringPerdeu
   la $a1, palavra
   syscall
   j menu
   
   somGanhou:
   # som para indicar que a pessoa digitou uma opcao invalida
   li $v0, 31
   la $a0, 61
   la $a1, 3000
   la $a2, 119
   la $a3, 100
   syscall
   li $v0, 31
   la $a0, 61
   la $a1, 3000
   la $a2, 118
   la $a3, 100
   syscall
   li $v0, 31
   la $a0, 61
   la $a1, 3000
   la $a2, 118
   la $a3, 100
   syscall
   li $v0, 31
   la $a0, 61
   la $a1, 3000
   la $a2, 118
   la $a3, 100
   syscall
   li $v0, 31
   la $a0, 61
   la $a1, 3000
   la $a2, 118
   la $a3, 100
   syscall
   li $v0, 31
   la $a0, 61
   la $a1, 3000
   la $a2, 122
   la $a3, 100
   syscall
   j ganhou

invalida:
   # som para indicar que a pessoa digitou uma opcao invalida
   li $v0, 31
   la $a0, 61
   la $a1, 3000
   la $a2, 120
   la $a3, 100
   syscall
   # redireciona para o lugar certo, de acordo com o erro
   li $t8, -5
   beq $t7, $t8, erroJogo
   li $t8, -6
	beq $t7, $t8, erroLerPalavra
	li $t8, -7
	beq $t7, $t8, erroLerDica
	li $t8, -8
	beq $t7, $t8, erroLerCaracter
	li $t8, -9
	beq $t7, $t8, erroLetraRepetida

   	j menu # erro durante o menu
  erroJogo: # erro durante o jogo
      j jogar
   erroLerPalavra: # erro durante a leitura da palavra
    	j lerPalavra
   erroLerDica: # erro durante a leitura da dica
   	 j lerDica
   erroLerCaracter: # erro durante a leitura do caracter
   	 j lerCaracter
  erroLetraRepetida: # erro Pessoa digitou caracter repetido
   	 j while2
