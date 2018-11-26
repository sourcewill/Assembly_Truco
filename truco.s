#Jogo de Truco para 2 jogadores implementado em Assembly x86
#Desenvolvido por William Rodrigues e Henrique Misael
#Trabalho referente a disciplina de PLM - 2018

#Definicoes e regras do Truco: https://www.jogatina.com/regras-como-jogar-truco.html

#Montando e executando o programa:
#sudo apt-get install gcc-multilib
#as -32 truco.s -o truco.o
#ld -m elf_i386 truco.o -l c -dynamic-linker /lib/ld-linux.so.2 -o truco
#./truco

.section .data

	tentosJ1: .int 0 #Contador de pontos do jogador
	tentosJ2: .int 0

	aposta: .int 1 #Numero de tentos que esta valendo uma mao (1, 3, 6, 9 ou 12)
	rodada: .int 0 #Numero da rodada atual
	
	separador: .asciz "\n------------------------------------------------\n"	
	abertura1: .asciz "\n+----------------------------------------------+"
	abertura2: .asciz "\n|  Programacao em Linguagem de Maquina - 2018  |"
	abertura3: .asciz "\n|        JOGO DE TRUCO - ASSEMBLY (x86)        |"
	abertura4: .asciz "\n|   Por: William Rodrigues e Henrique Misael   |"
	aberturaRodada1: .asciz "\n|                 RODADA (1)                   |"
	aberturaRodada2: .asciz "\n|                 RODADA (2)                   |"
	aberturaRodada3: .asciz "\n|                 RODADA (3)                   |"
	infoPlacar: .asciz "\n|              PLACAR DO JOGO                  |"

	infoTentosJ1: .asciz "\n\nHUMANO --> %d Tentos"
	infoTentosJ2: .asciz "\nMAQUINA --> %d Tentos\n"

	infoDistribuidas: .asciz "\nCartas distribuidas:\n"
	infoCartasJ1: .asciz "\nCartas disponiveis:\n"
	infoSorteiaPrimeiro: .asciz "\nSorteando o jogador que iniciara a partida..."
	infoJ1primeiro: .asciz "\nHUMANO inicia a partida.\n"
	infoJ2primeiro: .asciz "\nMAQUINA inicia a partida.\n"
	infoCarta1J1: .asciz "\nCarta 1 (Humano): "
	infoCarta2J1: .asciz "\nCarta 2 (Humano): "
	infoCarta3J1: .asciz "\nCarta 3 (Humano): "
	infoCarta1J2: .asciz "\nCarta 1 (Maquina): "
	infoCarta2J2: .asciz "\nCarta 2 (Maquina): "
	infoCarta3J2: .asciz "\nCarta 3 (Maquina): "
	infoCartaVira: .asciz "\n>> CARTA VIRA: "
	infoDistrbuindo: .asciz "\nDistribuindo cartas aleatorias para os jogadores...\n"
	infoPedeEscolhaCarta: .asciz "\nSelecione uma de suas cartas para jogar."
	infoEscolhaJ1: .asciz "\n>> Carta escolhida por HUMANO: "
	infoEscolhaJ2: .asciz "\n>> Carta escolhida por MAQUINA: "
	infoJ1jogouFechada: .asciz "\n>> HUMANO jogou uma carta fechada (virada para baixo)"
	infoValendo: .asciz " (Valendo: %d tentos)\n"
	infoAbertaFechada: .asciz "\nComo deseja jogar a carta?\n\n1) Carta aberta\n2) Carta fechada\n"
	infoOpcao: .asciz "\nOpcao escolhida: "
	infoTextoProbabilidade: .asciz "\nProbabilidade: %d\n"

	desejaPedirTruco: .asciz "\nDeseja pedir truco?\n"
	simNao: .asciz "\n1) Sim\n2) Nao\n"
	simNaoAumenta: .asciz "\n0) Fugir\n1) Aceitar\n2) Pedir %d\n"
	fogeOuAceita: .asciz "\n0) Fugir\n1) Aceitar\n"

	J1fugiu: .asciz "\nO HUMANO FUGIU da aposta.\n"
	J2fugiu: .asciz "\nO MAQUINA FUGIU da aposta.\n"

	valendo: .asciz "\nAPOSTA ACEITA. Agora a mao vale %d tentos!\n"

	pediuTruco: .asciz "\nJogador %d pediu TRUCO!\n"
	pediu6: .asciz "\nJogador %d pediu SEIS!\n"
	pediu9: .asciz "\nJogador %d pediu NOVE!\n"
	pediu12: .asciz "\nJogador %d pediu DOZE!\n"

	pergunta11: .asciz "\n\nDeseja jogar a Mao de 11?\n"
	aceitou11: .asciz "\nJogador %d ACEITOU a Mao de 11!\n"
	fugiu11: .asciz "\nJogador %d FUGIU da Mao de 11!\n"

	J1ganhouRodada: .asciz "\n>> HUMANO GANHOU A RODADA!\n"
	J2ganhouRodada: .asciz "\n>> MAQUINA GANHOU A RODADA!\n"
	empateRodada: .asciz "\n>> A RODADA EMPATOU.\n"

	infoJ1GanhouMao: .asciz "\n>> HUMANO VENCEU A MAO!"
	infoJ2GanhouMao: .asciz "\n>> MAQUINA VENCEU A MAO!"
	infoEmpateMao: .asciz "\n>> AS 3 RODADAS EMPARATARAM, NINGUEM VENCEU A MAO."

	infoJ1ganhouJogo: .asciz "\n>> HUMANO VENCEU O JOGO!\n"
	infoJ2ganhouJogo: .asciz "\n>> MAQUINA VENCEU O JOGO!\n"	

	pedeEscolhaCarta: .asciz "\n\nNumero da carta escolhida: "

	J1escolhendo: .asciz "\nHUMANO esta escolhendo uma carta...\n"
	J2escolhendo: .asciz "\nMAQUINA esta escolhendo uma carta...\n"

	opcaoInvalida: .asciz "\nA opcao digitada eh INVALIDA."

	digiteAlgo: .asciz "\nPressione <Enter> para continuar... "
	limpabuffer: .asciz "%*c"

	pulaLinha: .asciz "\n"

	#Ordem Crescente (Cartas): 4 5 6 7 Q J K A 2 3
	#Ordem Crescente (Manilhas): Our Esp Cop Pau

	vetMapeamento: .asciz "4 Ouros  ", "5 Ouros  ", "6 Ouros  ", "7 Ouros  ", "Q Ouros  ", "J Ouros  ", "K Ouros  ", "A Ouros  ", "2 Ouros  ", "3 Ouros  ", "4 Espadas", "5 Espadas", "6 Espadas", "7 Espadas", "Q Espadas", "J Espadas", "K Espadas", "A Espadas", "2 Espadas", "3 Espadas", "4 Copas  ", "5 Copas  ", "6 Copas  ", "7 Copas  ", "Q Copas  ", "J Copas  ", "K Copas  ", "A Copas  ", "2 Copas  ", "3 Copas  ", "4 Paus   ", "5 Paus   ", "6 Paus   ", "7 Paus   ", "Q Paus   ", "J Paus   ", "K Paus   ", "A Paus   ", "2 Paus   ", "3 Paus   "

	nomeCarta: .space 10 #Aloca 10 bytes

	carta1J1: .int 0
	carta2J1: .int 0
	carta3J1: .int 0

	carta1J2: .int 0
	carta2J2: .int 0
	carta3J2: .int 0

	ordemCrescente1: .int 0
	ordemCrescente2: .int 0
	ordemCrescente3: .int 0

	cartaVira: .int 0
	manilha: .int 0

	cartaEscolhidaJ1: .int 0 #Carta escolhida pelo jogador a cada rodada
	pesoCartaJ1: .int 0 #Peso calculado equivalente a carta escolhida
	cartaEscolhidaJ2: .int 0
	pesoCartaJ2: .int 0

	cartaCompara1: .int 0
	cartaCompara2: .int 0
	pesoCarta1: .int 0
	pesoCarta2: .int 0

	flagJogadorTem11: .int 0 # 0 = Nenhum tem 11 | 1 = J1 tem 11  | 2 = J2 tem 11 | 3 = Ambos tem 11

	opcaoAbertaFechada: .int 0
	flagCartaFechadaJ1: .int 0

	flagJaPediuTruco: .int 0 #Flag que marca se alguem ja pediu truco (0 ou 1)

	respostaApostaJ1: .int 0 # (0, 1 ou 2) 0 = foge | 1 = aceita | 2 = aumenta aposta
	respostaApostaJ2: .int 0

	flagUsouCarta1J1: .int 0 #Flags para saber se o jogador ja usou a carta (0 ou 1)
	flagUsouCarta2J1: .int 0
	flagUsouCarta3J1: .int 0

	flagUsouCarta1J2: .int 0
	flagUsouCarta2J2: .int 0
	flagUsouCarta3J2: .int 0

	flagIniciou: .int 0 #Flag que marca o jogador que iniciou (1 ou 2)
	flagJogouPorUltimo: .int 0 #Flag que marca qual jogador jogou por ultimo na rodada (1 ou 2)
	flagGanhouAtual: .int 0 #Flag setada com o jogador ganhador da rodada atual (1 ou 2 ou 0 caso empate)
	flagGanhouRodada1: .int 0
	flagGanhouRodada2: .int 0
	flagGanhouRodada3: .int 0

	flagMaoJaTeveGanhador: .int 0 #Flag que indica se a mao atual ja teve ganhador
	flagJaFoiR3: .int 0 #Flag que indica se a rodada 3 ja executou (0 ou 1)

	flagJogoTeveGanhador: .int 0 #Flag que indica se o jogo ja teve ganhador (+ de 12 tentos)

	tempo: .int 0
	intervalo: .int 0
	aleatorio: .int 0

	formatoInt: .asciz "%d"
	numDigitado: .int 0

	probabilidade: .int 0
	probabilidadeBase: .int 5

	
.section .text
.globl _start

#-----------------------------------------------------------------------------------------------------------

#Inicia todas as variaveis e flags
iniciaVariaveis:

	pushl %ebp
	movl %esp, %ebp

	movl $1, aposta

	movl $999, carta1J1
	movl $999, carta2J1
	movl $999, carta3J1

	movl $999, carta1J2
	movl $999, carta2J2
	movl $999, carta3J2

	movl $999, cartaVira
	movl $0, manilha

	movl $0, cartaEscolhidaJ1
	movl $0, pesoCartaJ1
	movl $0, cartaEscolhidaJ2
	movl $0, pesoCartaJ2

	movl $0, flagUsouCarta1J1
	movl $0, flagUsouCarta2J1
	movl $0, flagUsouCarta3J1

	movl $0, flagUsouCarta1J2
	movl $0, flagUsouCarta2J2
	movl $0, flagUsouCarta3J2

	movl $0, flagGanhouAtual
	movl $0, flagGanhouRodada1
	movl $0, flagGanhouRodada2
	movl $0, flagGanhouRodada3

	movl $0, flagJaPediuTruco
	movl $999, respostaApostaJ1
	movl $999, respostaApostaJ2

	movl $0, flagMaoJaTeveGanhador
	movl $0, flagJaFoiR3

	movl %ebp, %esp
	popl %ebp
	ret

#-----------------------------------------------------------------------------------------------------------

#Configura semente aleatoria com base no horario
geraSementeRandom:

	pushl %ebp
	movl %esp, %ebp

	pushl $tempo
	call time # Obtem tempo em segundos (desde 01/01/1970)

	pushl tempo
	call srand #Configura semente de geração
	addl $8, %esp

	movl %ebp, %esp
	popl %ebp
	ret

#-----------------------------------------------------------------------------------------------------------

#Gera um numero aleatorio entre 0 e (intervalo-1)
geraRandom:

	pushl %ebp
	movl %esp, %ebp

	call rand #Gera um numero aleatorio positivo, retornado em eax
	movl $0, %edx #Zera o reg edx para evitar erro na divisao
	divl intervalo #Divide eax por numCartas, edx contem o resto da divisao
	movl %edx, aleatorio

	movl %ebp, %esp
	popl %ebp
	ret

#-----------------------------------------------------------------------------------------------------------

#Gera um numero aleatorio (0~39) e verifica se ja existe uma carta em jogo repetida
geraCartaValida:
	
	pushl %ebp
	movl %esp, %ebp

	movl $40, intervalo

	geraNova:

	call geraRandom

	#Verifica se a carta gerada ja pertence a algum jogador
	#Caso o numero gerado seja igual a uma das cartas, gera um novo

	movl aleatorio, %eax
	
	cmp %eax, carta1J1
	je geraNova

	cmp %eax, carta2J1
	je geraNova

	cmp %eax, carta3J1
	je geraNova

	cmp %eax, carta1J2
	je geraNova

	cmp %eax, carta2J2
	je geraNova

	cmp %eax, carta3J2
	je geraNova

	movl %ebp, %esp
	popl %ebp
	ret

#-----------------------------------------------------------------------------------------------------------

#Gera toas as cartas do jogo
distribuiCartas:

	pushl %ebp
	movl %esp, %ebp

	pushl $infoDistrbuindo
	call printf
	addl $4, %esp

	call geraCartaValida
	movl aleatorio, %eax
	movl %eax, carta1J1

	call geraCartaValida
	movl aleatorio, %eax
	movl %eax, carta2J1

	call geraCartaValida
	movl aleatorio, %eax
	movl %eax, carta3J1

	call geraCartaValida
	movl aleatorio, %eax
	movl %eax, carta1J2

	call geraCartaValida
	movl aleatorio, %eax
	movl %eax, carta2J2

	call geraCartaValida
	movl aleatorio, %eax
	movl %eax, carta3J2

	call geraCartaValida
	movl aleatorio, %eax
	movl %eax, cartaVira

	movl %ebp, %esp
	popl %ebp
	ret

#-----------------------------------------------------------------------------------------------------------

#Imprime mensagens inicias sobre o programa
imprimeAbertura:

	pushl %ebp
	movl %esp, %ebp

	pushl $abertura1
	call printf
	pushl $abertura2
	call printf
	pushl $abertura3
	call printf
	pushl $abertura4
	call printf
	pushl $abertura1
	call printf
	pushl $pulaLinha
	call printf
	addl $24, %esp

	movl %ebp, %esp
	popl %ebp
	ret

#-----------------------------------------------------------------------------------------------------------

#Recebe um numero entre 0 e 39 como parametro pelo reg eax e imprime a carta correspondente
imprimeCarta:

	pushl %ebp
	movl %esp, %ebp

	movl $vetMapeamento, %edi #Move o endereço do vetor de mapeamento para edi
	
	movl $0, %edx #Limpa edx para evitar erro na multiplicacao
	movl $10, %ebx
	mull %ebx #Multilica eax por 10 (deslocamento no vetor de 10 bytes cada posicao)
	
	addl %eax, %edi #Adiciona o deslocamento no endereco inicial do vetor

	pushl %edi
	call printf
	popl %edi	

	movl %ebp, %esp
	popl %ebp
	ret

#-----------------------------------------------------------------------------------------------------------

#Imprime todas as cartas disponiveis para Jogador 1 (Humano)
imprimeCartasJ1:

	pushl %ebp
	movl %esp, %ebp

	call imprimeVira

	pushl $infoCartasJ1
	call printf
	addl $4, %esp

imprimecarta1:

	movl flagUsouCarta1J1, %eax
	cmpl $1, %eax
	je imprimecarta2

	pushl $infoCarta1J1
	call printf
	addl $4, %esp
	movl carta1J1, %eax #Coloca o numero da carta no eax para ser passado como parametro
	call imprimeCarta #Imprime a carta de acordo com seu numero no mapeamento

imprimecarta2:

	movl flagUsouCarta2J1, %eax
	cmpl $1, %eax
	je imprimecarta3

	pushl $infoCarta2J1
	call printf
	addl $4, %esp
	movl carta2J1, %eax
	call imprimeCarta

imprimecarta3:

	movl flagUsouCarta3J1, %eax
	cmpl $1, %eax
	je fimImprimeCartasJ1

	pushl $infoCarta3J1
	call printf
	addl $4, %esp
	movl carta3J1, %eax
	call imprimeCarta

fimImprimeCartasJ1:

	movl %ebp, %esp
	popl %ebp
	ret

#-----------------------------------------------------------------------------------------------------------

#Imprime todas as cartas de J1, J2 e Carta Vira (Função usada para testes)
imprimeTodas:

	pushl %ebp
	movl %esp, %ebp

	pushl $infoDistribuidas
	call printf
	
	pushl $infoCarta1J1
	call printf
	movl carta1J1, %eax #Coloca o numero da carta no eax para ser passado como parametro
	call imprimeCarta #Imprime a carta de acordo com seu numero no mapeamento

	pushl $infoCarta2J1
	call printf
	movl carta2J1, %eax
	call imprimeCarta

	pushl $infoCarta3J1
	call printf
	movl carta3J1, %eax
	call imprimeCarta

	pushl $pulaLinha
	call printf

	pushl $infoCarta1J2
	call printf
	movl carta1J2, %eax
	call imprimeCarta

	pushl $infoCarta2J2
	call printf
	movl carta2J2, %eax
	call imprimeCarta

	pushl $infoCarta3J2
	call printf
	movl carta3J2, %eax
	call imprimeCarta

	pushl $pulaLinha
	call printf

	pushl $infoCartaVira
	call printf
	movl cartaVira, %eax
	call imprimeCarta

	pushl $pulaLinha
	call printf

	addl $44, %esp

	movl %ebp, %esp
	popl %ebp
	ret

#-----------------------------------------------------------------------------------------------------------

#Imprime a carta Vira
imprimeVira:

	pushl %ebp
	movl %esp, %ebp

	pushl $infoCartaVira
	call printf
	addl $4, %esp

	movl cartaVira, %eax
	call imprimeCarta

	movl %ebp, %esp
	popl %ebp
	ret

#-----------------------------------------------------------------------------------------------------------

#Imprime o placar atual do jogo
imprimePlacar:

	pushl %ebp
	movl %esp, %ebp

	pushl $abertura1
	call printf
	pushl $infoPlacar
	call printf
	pushl $abertura1
	call printf

	pushl tentosJ1
	pushl $infoTentosJ1
	call printf

	pushl tentosJ2
	pushl $infoTentosJ2
	call printf

	pushl $separador
	call printf

	pushl $pulaLinha
	call printf

	addl $36, %esp

	movl %ebp, %esp
	popl %ebp
	ret

#-----------------------------------------------------------------------------------------------------------

#Define as manilhas do jogo com base na cartaVira+1
defineManilha:

	pushl %ebp
	movl %esp, %ebp

	movl cartaVira, %eax
	incl %eax #Incrementa eax

	movl $0, %edx #Limpa edx para evitar erro na divisão
	movl $10, %ebx

	divl %ebx #Divide eax por 10
	movl %edx, manilha #Manilha recebe o resto da divisao

	movl %ebp, %esp
	popl %ebp
	ret

#-----------------------------------------------------------------------------------------------------------

#Compara as duas cartas escolhidas por J1 e J2
compara2Cartas:

	pushl %ebp
	movl %esp, %ebp

	#Verifica se J1 (humano) escolheu jogar a carta fechada
	movl flagCartaFechadaJ1, %eax
	cmpl $1, %eax
	je J2ganha #Caso afirmativo, Jogador 2 ganha automaticamente

	#Calcula o peso das 2 cartas

	movl cartaEscolhidaJ1, %eax
	movl $0, %edx #Limpa edx para evitar erro na divisao
	movl $10, %ebx
	divl %ebx #Divide eax por 10
	movl %edx, pesoCartaJ1 #Coloca o resto no peso da carta

	movl cartaEscolhidaJ2, %eax
	movl $0, %edx
	movl $10, %ebx
	divl %ebx
	movl %edx, pesoCartaJ2

	#Verifica se as cartas sao manilhas

	movl pesoCartaJ1, %eax
	cmpl %eax, manilha #Se J1 é manilha
	je J1ehManilha

	movl pesoCartaJ2, %ebx
	cmpl %ebx, manilha #Se J2 é manilha ja ganhou
	je J2ganha

	#Se nenhuma das duas eh manilha

	cmpl %eax, %ebx
	jl J1ganha
	jg J2ganha
	jmp empate

J1ehManilha:

	movl pesoCartaJ2, %eax
	cmpl %eax, manilha #Se J2 também é manilha
	je duasSaoManilhas
	jmp J1ganha #Se não J1 ja ganhou

duasSaoManilhas:

	#Se as duas sao manilhas, compara-se os nipes (que ja estao em ordem crescente no mapeamento)
	movl cartaEscolhidaJ1, %eax
	movl cartaEscolhidaJ2, %ebx
	cmpl %eax, %ebx
	jl J1ganha
	jmp J2ganha

J1ganha:
	pushl $J1ganhouRodada
	call printf
	addl $4, %esp

	movl $1, flagGanhouAtual

	jmp fimCompara
J2ganha:
	pushl $J2ganhouRodada
	call printf
	addl $4, %esp

	movl $2, flagGanhouAtual

	jmp fimCompara
empate:
	pushl $empateRodada
	call printf
	addl $4, %esp

	movl $0, flagGanhouAtual

fimCompara:

	movl %ebp, %esp
	popl %ebp
	ret

#-----------------------------------------------------------------------------------------------------------

#Sorteia o jogador que inicia a partida
sorteiaPrimeiro:

	pushl %ebp
	movl %esp, %ebp

	movl flagIniciou, %eax #Se não for a primeira mao, nao decide aleatoriamente
	cmpl $1, %eax #Se J1 iniciou a mao anterior, J2 inicia a mao atual
	je J2inicia

	cmpl $2, %eax
	je J1inicia

	#Se a flagIniciou contem 0, sorteia quem inicia a mao

	pushl $infoSorteiaPrimeiro
	call printf
	addl $4, %esp

	call geraSementeRandom
	movl $2, intervalo #Configura o intervalo (0~1)
	call geraRandom
	movl aleatorio, %eax
	
	cmpl $1, %eax
	je J2inicia

J1inicia:

	movl $1, flagIniciou
	pushl $infoJ1primeiro
	call printf
	addl $4, %esp

	movl flagJogadorTem11, %eax #Se a flag nao for zero, eh mao de 11, portanto nao pode pedir trudo
	cmpl $0, %eax
	jne pulaPerguntaJ1

	call J1pedirTruco

pulaPerguntaJ1:

	call escolheCartaJ1
	jmp fimSorteiaPrimeiro

J2inicia:

	movl $2, flagIniciou
	pushl $infoJ2primeiro
	call printf
	addl $4, %esp

	movl flagJogadorTem11, %eax #Se a flag nao for zero, eh mao de 11, portanto nao pode pedir trudo
	cmpl $0, %eax
	jne pulaPerguntaJ2

	call J2pedirTruco

pulaPerguntaJ2:

	call escolheCartaJ2

fimSorteiaPrimeiro:

	movl %ebp, %esp
	popl %ebp
	ret

#-----------------------------------------------------------------------------------------------------------

#Solicita que Jogador 1 (Humano) escolha uma carta
escolheCartaJ1:

	pushl %ebp
	movl %esp, %ebp

	pushl $J1escolhendo
	call printf
	addl $4, %esp

pedeCartaJ1:

	pushl $infoPedeEscolhaCarta
	call printf

	call imprimeCartasJ1

	pushl $pedeEscolhaCarta
	call printf

	pushl $numDigitado
	pushl $formatoInt
	call scanf

	addl $16, %esp

verifica_cartaEscolhida:

	movl numDigitado, %eax
	cmpl $1, %eax
	je J1escolheu1

	cmpl $2, %eax
	je J1escolheu2

	cmpl $3, %eax
	je J1escolheu3
	
invalidaJ1:

	pushl $opcaoInvalida
	call printf
	addl $4, %esp
	jmp pedeCartaJ1

J1escolheu1:

	movl flagUsouCarta1J1, %eax #Verifica se a carta escolhida ja nao foi usada
	cmpl $1, %eax
	je invalidaJ1

	movl $1, flagUsouCarta1J1 #Seta a falg indicando que a carta foi usada

	movl carta1J1, %eax
	movl %eax, cartaEscolhidaJ1
	jmp pede_AbertaFechada

J1escolheu2:

	movl flagUsouCarta2J1, %eax
	cmpl $1, %eax
	je invalidaJ1

	movl $1, flagUsouCarta2J1 

	movl carta2J1, %eax
	movl %eax, cartaEscolhidaJ1
	jmp pede_AbertaFechada

J1escolheu3:

	movl flagUsouCarta3J1, %eax
	cmpl $1, %eax
	je invalidaJ1

	movl $1, flagUsouCarta3J1 

	movl carta3J1, %eax
	movl %eax, cartaEscolhidaJ1

pede_AbertaFechada:

	movl rodada, %eax
	cmpl $1, %eax
	je mostra_escolha

	pushl $infoAbertaFechada
	call printf
	pushl $infoOpcao
	call printf

	pushl $opcaoAbertaFechada
	pushl $formatoInt
	call scanf

	addl $16, %esp

	#Verifica opcao escolhida de carta aberta ou fechada
	movl opcaoAbertaFechada, %eax
	cmpl $1, %eax
	je carta_aberta
	cmpl $2, %eax
	je carta_fechada

	pushl $opcaoInvalida #Opcao digitada foi invalida (diferente de 1 ou 2)
	call printf
	addl $4, %esp
	jmp pede_AbertaFechada 

carta_aberta:

	movl $0, flagCartaFechadaJ1
	jmp mostra_escolha

carta_fechada:

	movl $1, flagCartaFechadaJ1

	pushl $infoJ1jogouFechada
	call printf
	addl $4, %esp

	jmp fimEscolheCartaJ1

mostra_escolha:

	pushl $infoEscolhaJ1
	call printf
	addl $4, %esp
	
	movl cartaEscolhidaJ1, %eax
	call imprimeCarta

fimEscolheCartaJ1:

	pushl $pulaLinha
	call printf
	pushl $separador
	call printf
	addl $8, %esp

	movl %ebp, %esp
	popl %ebp
	ret

#-----------------------------------------------------------------------------------------------------------

#Solicita que Jogador 2 (Computador) escolha uma carta
escolheCartaJ2:

	pushl %ebp
	movl %esp, %ebp

	pushl $J2escolhendo
	call printf
	addl $4, %esp

	#Verifica qual a rodada atual
	movl rodada, %eax
	cmpl $1, %eax
	je rodada_1
	cmpl $2, %eax
	je rodada_2
	jmp rodada_3

rodada_1:

	movl flagIniciou, %eax
	cmpl $2, %eax

	je J2escolhe_maior #Se maquina iniciou, joga sua maior carta ou aleatoria (50%/50%)
	
	#Se Maquina nao iniciou, tenta matar com a menor carta possivel
	jmp J2tenta_matar

rodada_2:

	movl flagGanhouAtual, %eax

	cmpl $0, %eax
	je J2escolhe_maior #Se a primeira rodada empatou, joga a maior carta

	cmpl $1, %eax #Se o humano venceu a primeira, tenta matar com menor possivel
	je J2tenta_matar

	#Se maquina venceu a primeira rodada, escolhe aleatoriamente
	jmp J2escolhe_aleatoriamente

rodada_3:

	jmp J2escolhe_aleatoriamente

J2escolhe_maior:

	movl rodada, %eax
	cmpl $1, %eax
	jne pula_chance_aleatorio #Se for a primeira rodada, pode jogar a maior ou uma aleatoria (50%/50%)

	movl $100, intervalo
	call geraRandom #Gera um numero aleatorio entre (0~99)
	movl aleatorio, %eax 

	cmpl $50, %eax
	jl J2escolhe_aleatoriamente # 50% de probabilidade de jogar aleatorio

	pula_chance_aleatorio:

	call J2escolheMaiorCartaDisponivel #Escolhe sua maior, retornada em eax

	cmpl $1, %eax
	je J2escolheu1

	cmpl $2, %eax
	je J2escolheu2

	cmpl $3, %eax
	je J2escolheu3

J2escolhe_menor:

	call J2escolheMenorCartaDisponivel #Escolhe sua maior, retornada em eax

	cmpl $1, %eax
	je J2escolheu1

	cmpl $2, %eax
	je J2escolheu2

	cmpl $3, %eax
	je J2escolheu3

J2tenta_matar:
	
	movl flagCartaFechadaJ1, %eax
	cmpl $1, %eax
	je J2escolhe_menor #Se humano jogou carta fechada, basta jogar a menor carta disponivel

	call J2mataComMenorPossivel

	cmpl $1, %eax
	je J2escolheu1

	cmpl $2, %eax
	je J2escolheu2

	cmpl $3, %eax
	je J2escolheu3

	#Se nao consegue matar com nenhuma, joga sua menor carta
	jmp J2escolhe_menor

J2escolhe_aleatoriamente:

	movl $3, intervalo

pedeCartaJ2:	

	call geraRandom #Gera um numero aleatorio entre (0~2)
	movl aleatorio, %eax 
	addl $1, %eax #Soma 1 ao numero resultante, tendo assim (1~3)

	cmpl $1, %eax
	je J2escolheu1

	cmpl $2, %eax
	je J2escolheu2

	cmpl $3, %eax
	je J2escolheu3

	jmp pedeCartaJ2

J2escolheu1:

	movl flagUsouCarta1J2, %eax #Verifica se a carta escolhida ja nao foi usada
	cmpl $1, %eax
	je pedeCartaJ2

	movl $1, flagUsouCarta1J2 #Seta a falg indicando que a carta foi usada

	movl carta1J2, %eax
	movl %eax, cartaEscolhidaJ2
	jmp fimEscolheCartaJ2

J2escolheu2:

	movl flagUsouCarta2J2, %eax
	cmpl $1, %eax
	je pedeCartaJ2

	movl $1, flagUsouCarta2J2

	movl carta2J2, %eax
	movl %eax, cartaEscolhidaJ2
	jmp fimEscolheCartaJ2

J2escolheu3:

	movl flagUsouCarta3J2, %eax
	cmpl $1, %eax
	je pedeCartaJ2

	movl $1, flagUsouCarta3J2

	movl carta3J2, %eax
	movl %eax, cartaEscolhidaJ2

fimEscolheCartaJ2:

	pushl $infoEscolhaJ2
	call printf
	addl $4, %esp
	
	movl cartaEscolhidaJ2, %eax
	call imprimeCarta

	pushl $pulaLinha
	call printf
	pushl $separador
	call printf
	addl $8, %esp

	movl %ebp, %esp
	popl %ebp
	ret

#-----------------------------------------------------------------------------------------------------------

#Verifica se um jogador venceu a mao atual com base nas flags de vitoria de rodada

#DECIDINDO GANHADOR EM CASOS DE EMPATE:
#Se empatar na primeira rodada, quem ganhar a segunda vence a mão;
#Se empatar na segunda rodada, quem ganhou a primeira vence a mão;
#Se empatar na primeira e segunda rodada, quem fizer a terceira vence a mão;
#Se empatar na terceira rodada, quem ganhou a primeira vence a mão;
#Se todas as três rodadas empatarem, ninguém ganha ponto.

verificaGanhadorMao:

	pushl %ebp
	movl %esp, %ebp

	movl flagGanhouRodada1, %eax
	cmpl $1, %eax
	je J1_ganhou_R1
	jg J2_ganhou_R1
	
empate_R1: #Se empatar na primeira rodada, quem ganhar a segunda vence a mão
	
	movl flagGanhouRodada2, %eax
	cmpl $1, %eax
	je J1_ganhou_mao
	jg J2_ganhou_mao
	jmp verificaR3

J1_ganhou_R1:

	movl flagGanhouRodada2, %eax
	cmpl $1, %eax
	je J1_ganhou_mao
	jg verificaR3
	jmp J1_ganhou_mao #Se empatar na segunda rodada, quem ganhou a primeira vence a mão

J2_ganhou_R1:

	movl flagGanhouRodada2, %eax
	cmpl $1, %eax
	jg J2_ganhou_mao
	je verificaR3
	jmp J2_ganhou_mao #Se empatar na segunda rodada, quem ganhou a primeira vence a mão

verificaR3: #Se empatar na primeira e segunda rodada, quem fizer a terceira vence a mão

	movl flagJaFoiR3, %eax
	cmpl $0, %eax
	je fimVerificaGanhadorMao #Se a rodada 3 ainda nao executou, nao pode verificar ganhador

	movl flagGanhouRodada3, %eax
	cmpl $1, %eax
	je J1_ganhou_mao
	jg J2_ganhou_mao
	jmp empate_R3

empate_R3: #Se empatar na terceira rodada, quem ganhou a primeira vence a mão

	movl flagGanhouRodada1, %eax 
	cmpl $1, %eax
	je J1_ganhou_mao
	jg J2_ganhou_mao
	jmp tresEmpates #Se a primeira também emapatou e a execucao chegou aqui, 3 empates

J1_ganhou_mao:

	movl $1, flagMaoJaTeveGanhador #Seta a flag informando que a mao atual acabou

	movl aposta, %eax
	addl %eax, tentosJ1 #Incrementa o numero de pontos do jogador de acordo com a aposta da mao atual
	
	pushl $infoJ1GanhouMao
	call printf
	pushl aposta
	pushl $infoValendo
	call printf
	addl $12, %esp
	jmp fimVerificaGanhadorMao

J2_ganhou_mao:
	
	movl $1, flagMaoJaTeveGanhador

	movl aposta, %eax
	addl %eax, tentosJ2 #Incrementa o numero de pontos do jogador de acordo com a aposta da mao atual

	pushl $infoJ2GanhouMao
	call printf
	pushl aposta
	pushl $infoValendo
	call printf
	addl $12, %esp
	jmp fimVerificaGanhadorMao

tresEmpates: #Se todas as três rodadas empatarem, ninguém ganha ponto.

	pushl $infoEmpateMao
	call printf
	addl $4, %esp

fimVerificaGanhadorMao:

	movl %ebp, %esp
	popl %ebp
	ret

#-----------------------------------------------------------------------------------------------------------

#Verifica se o jogo ja teve um ganhador ( Tentos maior ou iual a 12)
verificaGanhadorJogo:

	pushl %ebp
	movl %esp, %ebp

	movl tentosJ1, %eax
	cmpl $12, %eax
	jge J1_ganhou_jogo

	movl tentosJ2, %eax
	cmpl $12, %eax
	jge J2_ganhou_jogo

	jmp fimVerificaGanhadorJogo

J1_ganhou_jogo:

	movl $1, flagJogoTeveGanhador

	pushl $infoJ1ganhouJogo
	call printf
	addl $4, %esp

	jmp fimVerificaGanhadorJogo

J2_ganhou_jogo:

	movl $1, flagJogoTeveGanhador

	pushl $infoJ2ganhouJogo
	call printf
	addl $4, %esp

fimVerificaGanhadorJogo:

	movl %ebp, %esp
	popl %ebp
	ret

#-----------------------------------------------------------------------------------------------------------

#Executa uma mão (melhor de 3 rodadas)
executaMao:

	pushl %ebp
	movl %esp, %ebp

	call iniciaVariaveis

	call geraSementeRandom
	call distribuiCartas
	call defineManilha
	call criaOrdemCrescenteJ2 #Ordena as cartas da maquina em ordem crescente
	call imprimeVira

	pushl $pulaLinha
	call printf
	addl $4, %esp

	#call imprimeTodas (para testes)

inicioRodada1:

	movl $1, rodada

	pushl $abertura1
	call printf
	pushl $aberturaRodada1
	call printf
	pushl $abertura1
	call printf
	addl $12, %esp

	call sorteiaPrimeiro
	
	movl flagIniciou, %eax
	cmpl $1, %eax #Se jogador 1 iniciou a partida
	je J1comecou

	call J1pedirTruco
	call escolheCartaJ1

	movl $1, flagJogouPorUltimo

	jmp executaRodada1

J1comecou:

	call J2pedirTruco
	call escolheCartaJ2

	movl $2, flagJogouPorUltimo

executaRodada1:

	call compara2Cartas
	movl flagGanhouAtual, %eax
	movl %eax, flagGanhouRodada1

	call pausaExecucao

inicioRodada2:

	movl $2, rodada

	pushl $abertura1
	call printf
	pushl $aberturaRodada2
	call printf
	pushl $abertura1
	call printf
	addl $12, %esp

	movl flagGanhouRodada1, %eax
	cmpl $1, %eax
	je J1ganhouR1
	cmpl $2, %eax
	je J2ganhouR1

	#Em caso de empate, quem jogou por ultimo deve jogar primeiro na proxima rodada

	movl flagJogouPorUltimo, %eax
	cmpl $1, %eax
	je J1ganhouR1
	cmpl $2, %eax
	je J2ganhouR1

J1ganhouR1:

	call J1pedirTruco
	call escolheCartaJ1
	call J2pedirTruco
	call escolheCartaJ2

	movl $2, flagJogouPorUltimo

	jmp executaRodada2

J2ganhouR1:

	call J2pedirTruco
	call escolheCartaJ2
	call J1pedirTruco
	call escolheCartaJ1

	movl $1, flagJogouPorUltimo

executaRodada2:
	
	call compara2Cartas
	movl flagGanhouAtual, %eax
	movl %eax, flagGanhouRodada2
	
	call verificaGanhadorMao #Verifica se na segunda rodada alguem ja ganhou
	
	movl flagMaoJaTeveGanhador, %eax
	cmpl $1, %eax
	je fimExecutaMao

	call pausaExecucao

iniciaRodada3:

	movl $3, rodada

	pushl $abertura1
	call printf
	pushl $aberturaRodada3
	call printf
	pushl $abertura1
	call printf
	addl $12, %esp

	movl flagGanhouRodada2, %eax
	cmpl $1, %eax
	je J1ganhouR2
	cmpl $2, %eax
	je J2ganhouR2

	#Em caso de empate, quem jogou por ultimo deve jogar primeiro na proxima rodada

	movl flagJogouPorUltimo, %eax
	cmpl $1, %eax
	je J1ganhouR2
	cmpl $2, %eax
	je J2ganhouR2

J1ganhouR2:

	call J1pedirTruco
	call escolheCartaJ1
	call J2pedirTruco
	call escolheCartaJ2

	movl $2, flagJogouPorUltimo

	jmp executaRodada3

J2ganhouR2:

	call J2pedirTruco
	call escolheCartaJ2
	call J1pedirTruco
	call escolheCartaJ1

	movl $1, flagJogouPorUltimo

executaRodada3:
	
	call compara2Cartas
	movl flagGanhouAtual, %eax
	movl %eax, flagGanhouRodada3

	movl $1, flagJaFoiR3

	call verificaGanhadorMao

fimExecutaMao:

	call imprimePlacar
	call pausaExecucao

	movl %ebp, %esp
	popl %ebp
	ret

#-----------------------------------------------------------------------------------------------------------

#Executa uma mão de 11
executaMao11:

	pushl %ebp
	movl %esp, %ebp

	call iniciaVariaveis

	call geraSementeRandom
	call distribuiCartas
	call defineManilha
	call criaOrdemCrescenteJ2 #Ordena as cartas da maquina em ordem crescente

	pushl $pulaLinha
	call printf
	addl $4, %esp

	#Verifica qual jogador tem 11

	movl flagJogadorTem11, %eax
	cmpl $1, %eax
	je J1_tem11
	jmp J2_tem11

J1_tem11:

	call imprimeCartasJ1

	#Pergunta se J1 quer jogar ou fugir

	pushl $pergunta11
	call printf
	pushl $simNao
	call printf

	pushl $infoOpcao
	call printf

	pushl $respostaApostaJ1
	pushl $formatoInt
	call scanf

	addl $20, %esp

	movl respostaApostaJ1, %eax
	cmpl $1, %eax
	je J1_aceita11
	cmpl $2, %eax
	je J1_foge11

	#Opcao digitada invalida, pergunta denovo	
	pushl $opcaoInvalida
	call printf
	addl $4, %esp
	jmp J1_tem11 

J2_tem11:

	#Pergunta se J2 (computador) quer jogar ou fugir

	call probabilidadeJ2aceitar12

	movl respostaApostaJ2, %eax
	cmpl $1, %eax
	je J2_aceita11
	cmpl $2, %eax
	je J2_foge11

J1_aceita11:

	movl $3, aposta

	pushl $1
	pushl $aceitou11
	call printf
	addl $8, %esp

	jmp inicio_Rodada1

J1_foge11:

	pushl $1
	pushl $fugiu11
	call printf
	addl $8, %esp

	#J2 ganhou mao

	movl $1, flagMaoJaTeveGanhador

	movl aposta, %eax
	addl %eax, tentosJ2 #Incrementa o numero de pontos do jogador em 1

	pushl $infoJ2GanhouMao
	call printf
	pushl aposta
	pushl $infoValendo
	call printf
	addl $12, %esp
	jmp fimExecutaMao11

J2_aceita11:

	movl $3, aposta

	pushl $2
	pushl $aceitou11
	call printf
	addl $8, %esp

	jmp inicio_Rodada1

J2_foge11:

	pushl $2
	pushl $fugiu11
	call printf
	addl $8, %esp

	#J1 ganhou mao

	movl $1, flagMaoJaTeveGanhador

	movl aposta, %eax
	addl %eax, tentosJ1 #Incrementa o numero de pontos do jogador em 1

	pushl $infoJ1GanhouMao
	call printf
	pushl aposta
	pushl $infoValendo
	call printf
	addl $12, %esp
	jmp fimExecutaMao11

inicio_Rodada1:
	
	movl $1, rodada

	pushl $abertura1
	call printf
	pushl $aberturaRodada1
	call printf
	pushl $abertura1
	call printf
	addl $12, %esp

	call sorteiaPrimeiro
	
	movl flagIniciou, %eax
	cmpl $1, %eax #Se jogador 1 iniciou a partida
	je J1_comecou

	call escolheCartaJ1
	movl $1, flagJogouPorUltimo
	jmp executa_Rodada1

J1_comecou:

	call escolheCartaJ2
	movl $2, flagJogouPorUltimo

executa_Rodada1:

	call compara2Cartas
	movl flagGanhouAtual, %eax
	movl %eax, flagGanhouRodada1

	call pausaExecucao

inicio_Rodada2:

	movl $2, rodada

	pushl $abertura1
	call printf
	pushl $aberturaRodada2
	call printf
	pushl $abertura1
	call printf
	addl $12, %esp

	movl flagGanhouRodada1, %eax
	cmpl $1, %eax
	je J1_ganhouR1
	cmpl $2, %eax
	je J2_ganhouR1

	#Em caso de empate, quem jogou por ultimo deve jogar primeiro na proxima rodada

	movl flagJogouPorUltimo, %eax
	cmpl $1, %eax
	je J1_ganhouR1
	cmpl $2, %eax
	je J2_ganhouR1


J1_ganhouR1:

	call escolheCartaJ1
	call escolheCartaJ2

	movl $2, flagJogouPorUltimo

	jmp executa_Rodada2

J2_ganhouR1:

	call escolheCartaJ2
	call escolheCartaJ1

	movl $1, flagJogouPorUltimo

executa_Rodada2:
	
	call compara2Cartas
	movl flagGanhouAtual, %eax
	movl %eax, flagGanhouRodada2
	
	call verificaGanhadorMao #Verifica se na segunda rodada alguem ja ganhou
	
	movl flagMaoJaTeveGanhador, %eax
	cmpl $1, %eax
	je fimExecutaMao11

	call pausaExecucao

inicia_Rodada3:

	movl $3, rodada

	pushl $abertura1
	call printf
	pushl $aberturaRodada3
	call printf
	pushl $abertura1
	call printf
	addl $12, %esp

	movl flagGanhouRodada2, %eax
	cmpl $1, %eax
	je J1_ganhouR2
	cmpl $2, %eax
	je J2_ganhouR2

	#Em caso de empate, quem jogou por ultimo deve jogar primeiro na proxima rodada

	movl flagJogouPorUltimo, %eax
	cmpl $1, %eax
	je J1_ganhouR2
	cmpl $2, %eax
	je J2_ganhouR2

J1_ganhouR2:

	call escolheCartaJ1
	call escolheCartaJ2

	movl $2, flagJogouPorUltimo

	jmp executa_Rodada3

J2_ganhouR2:

	call escolheCartaJ2
	call escolheCartaJ1

	movl $1, flagJogouPorUltimo

executa_Rodada3:
	
	call compara2Cartas
	movl flagGanhouAtual, %eax
	movl %eax, flagGanhouRodada3

	movl $1, flagJaFoiR3

	call verificaGanhadorMao

fimExecutaMao11:

	call imprimePlacar
	call pausaExecucao

	movl %ebp, %esp
	popl %ebp
	ret

#-----------------------------------------------------------------------------------------------------------

#Executa uma mão normal, mas sem poder trucar
executaMaoSemTruco:

	pushl %ebp
	movl %esp, %ebp

	call iniciaVariaveis

	call geraSementeRandom
	call distribuiCartas
	call defineManilha
	call criaOrdemCrescenteJ2 #Ordena as cartas da maquina em ordem crescente
	call imprimeVira

	pushl $pulaLinha
	call printf
	addl $4, %esp

	#call imprimeTodas (para testes)

_inicio_Rodada1:	

	movl $1, rodada

	pushl $abertura1
	call printf
	pushl $aberturaRodada1
	call printf
	pushl $abertura1
	call printf
	addl $12, %esp

	call sorteiaPrimeiro
	
	movl flagIniciou, %eax
	cmpl $1, %eax #Se jogador 1 iniciou a partida
	je _J1_comecou

	call escolheCartaJ1

	movl $1, flagJogouPorUltimo

	jmp _executa_Rodada1

_J1_comecou:

	call escolheCartaJ2

	movl $2, flagJogouPorUltimo

_executa_Rodada1:

	call compara2Cartas
	movl flagGanhouAtual, %eax
	movl %eax, flagGanhouRodada1

	call pausaExecucao

_inicio_Rodada2:

	movl $2, rodada

	pushl $abertura1
	call printf
	pushl $aberturaRodada2
	call printf
	pushl $abertura1
	call printf
	addl $12, %esp

	movl flagGanhouRodada1, %eax
	cmpl $1, %eax
	je _J1_ganhouR1
	cmpl $2, %eax
	je _J2_ganhouR1

	#Em caso de empate, quem jogou por ultimo deve jogar primeiro na proxima rodada

	movl flagJogouPorUltimo, %eax
	cmpl $1, %eax
	je _J1_ganhouR1
	cmpl $2, %eax
	je _J2_ganhouR1

_J1_ganhouR1:

	call escolheCartaJ1
	call escolheCartaJ2

	movl $2, flagJogouPorUltimo

	jmp _executa_Rodada2

_J2_ganhouR1:

	call escolheCartaJ2
	call escolheCartaJ1

	movl $1, flagJogouPorUltimo

_executa_Rodada2:
	
	call compara2Cartas
	movl flagGanhouAtual, %eax
	movl %eax, flagGanhouRodada2
	
	call verificaGanhadorMao #Verifica se na segunda rodada alguem ja ganhou
	
	movl flagMaoJaTeveGanhador, %eax
	cmpl $1, %eax
	je fimExecutaMaoSemTruco

	call pausaExecucao

_inicia_Rodada3:

	movl $3, rodada

	pushl $abertura1
	call printf
	pushl $aberturaRodada3
	call printf
	pushl $abertura1
	call printf
	addl $12, %esp

	movl flagGanhouRodada2, %eax
	cmpl $1, %eax
	je _J1_ganhouR2
	cmpl $2, %eax
	je _J2_ganhouR2

	#Em caso de empate, quem jogou por ultimo deve jogar primeiro na proxima rodada

	movl flagJogouPorUltimo, %eax
	cmpl $1, %eax
	je _J1_ganhouR2
	cmpl $2, %eax
	je _J2_ganhouR2

_J1_ganhouR2:

	call escolheCartaJ1
	call escolheCartaJ2

	movl $2, flagJogouPorUltimo

	jmp _executa_Rodada3

_J2_ganhouR2:

	call escolheCartaJ2
	call escolheCartaJ1

	movl $1, flagJogouPorUltimo

_executa_Rodada3:
	
	call compara2Cartas
	movl flagGanhouAtual, %eax
	movl %eax, flagGanhouRodada3

	movl $1, flagJaFoiR3

	call verificaGanhadorMao

fimExecutaMaoSemTruco:

	call imprimePlacar
	call pausaExecucao

	movl %ebp, %esp
	popl %ebp
	ret

#-----------------------------------------------------------------------------------------------------------

#Verifica se um dos jogadores ja esta com 11 tentos, caso afirmativo seta a flagJogadorTem11
verificaMao11:

	pushl %ebp
	movl %esp, %ebp

	movl tentosJ1, %eax #Se J1 tem 11 tentos
	cmpl $11, %eax
	je J1tem11

	movl tentosJ2, %eax #Se nao, se J2 tem 11 Tentos
	cmpl $11, %eax
	je J2tem11

	jmp fimVerificaMao11

J1tem11:

	movl tentosJ2, %eax #Se J1 e J2 tem 11 tentos, executa mao normal mas sem truco
	cmpl $11, %eax
	je dois_tem11

	movl $1, flagJogadorTem11
	jmp fimVerificaMao11


J2tem11:

	movl $2, flagJogadorTem11
	jmp fimVerificaMao11

dois_tem11:

	movl $3, flagJogadorTem11

fimVerificaMao11:

	movl %ebp, %esp
	popl %ebp
	ret

#-----------------------------------------------------------------------------------------------------------

#Calcula probabilidade de Jogador 2 pedir truco
probabilidadeJ2pedirTruco:

	pushl %ebp
	movl %esp, %ebp

	movl $5, probabilidadeBase
	call calculaProbabilidade
	call geraSementeRandom

	movl $100, %eax
	movl %eax, intervalo #Configura o intervalo (0-99)

	call geraRandom
	movl aleatorio, %eax

	cmpl probabilidade, %eax
	jl probabilidade_sim # probabilidade% de chance de pedir truco

	movl $2, numDigitado
	jmp fimProbabilidadeJ2pedirTruco

probabilidade_sim:

	movl $1, numDigitado
	
fimProbabilidadeJ2pedirTruco:

	movl %ebp, %esp
	popl %ebp
	ret

#-----------------------------------------------------------------------------------------------------------

#Calcula probabilidade de Jogador 2 pedir 12 (20% sim | 80% nao)
probabilidadeJ2aceitar12:

	pushl %ebp
	movl %esp, %ebp

	movl $3, probabilidadeBase
	call calculaProbabilidade
	call geraSementeRandom
	
	movl $100, %eax
	movl %eax, intervalo #Configura o intervalo (0-99)

	call geraRandom
	movl aleatorio, %eax

	cmpl probabilidade, %eax
	jl probabilidadeSim # probabilidade% de chance de aceitar 12

	movl $2, respostaApostaJ2
	jmp fimProbabilidadeJ2pedirTruco

probabilidadeSim:

	movl $1, respostaApostaJ2
	
fimProbabilidadeJ2aceitarTruco:

	movl %ebp, %esp
	popl %ebp
	ret

#-----------------------------------------------------------------------------------------------------------

#Calcula se J2 aceita aposta e seta a flag respostaApostaJ2 (0 = foge | 1 = aceita | 2 = aumenta aposta)
#Aleatoriamente (20% foge | 60% aceita | 20% aumenta )
probabilidadeJ2_foge_aceita_aumenta:

	pushl %ebp
	movl %esp, %ebp

	movl $0, %edx
	movl aposta, %eax
	movl $3, %ebx
	divl %ebx
	movl $2, %ebx
	mull %ebx
	movl %eax, %ebx
	movl $10, %eax
	subl %ebx, %eax
	movl %eax, probabilidadeBase
	call calculaProbabilidade
	call geraSementeRandom

	movl $100, %eax
	movl %eax, intervalo #Configura o intervalo (0-99)

	call geraRandom
	movl aleatorio, %eax

	cmpl probabilidade, %eax
	jge probabilidade_foge

	call geraRandom
	movl aleatorio, %eax
	cmpl probabilidade, %eax
	jl probabilidade_aumenta

probabilidade_aceita:
	movl $1, respostaApostaJ2
	jmp fimProbabilidadeJ2_foge_aceita_aumenta

probabilidade_aumenta:
	movl $2, respostaApostaJ2
	jmp fimProbabilidadeJ2_foge_aceita_aumenta

probabilidade_foge:
	movl $0, respostaApostaJ2

fimProbabilidadeJ2_foge_aceita_aumenta:

	movl %ebp, %esp
	popl %ebp
	ret

#-----------------------------------------------------------------------------------------------------------

#Pergunta se Jogador 1 quer pedir truco, e trata os possiveis fluxos
opcaoJ1pedirTruco:

	pushl %ebp
	movl %esp, %ebp

pergunta_truco:

	pushl $desejaPedirTruco #Pergunta se quer pedir truco
	call printf
	pushl $simNao
	call printf
	pushl $infoOpcao
	call printf

	pushl $numDigitado #Le a resposta
	pushl $formatoInt
	call scanf

	addl $20, %esp

	movl numDigitado, %eax #Verifica e trata a resposta do jogador
	cmpl $1, %eax
	je J1pede_truco
	cmpl $2, %eax
	je fimOpcaoJ1pedirTruco

	pushl $opcaoInvalida
	call printf
	addl $4, %esp
	jmp pergunta_truco

J1pede_truco:

	movl $1, flagJaPediuTruco

	pushl $1
	pushl $pediuTruco
	call printf
	addl $8, %esp

	call probabilidadeJ2_foge_aceita_aumenta
	movl respostaApostaJ2, %eax
	cmpl $0, %eax
	je J2_fugiu #Se J2 fugir
	cmpl $1, %eax
	je J2aceitou_truco #Se J2 aceitar
	cmpl $2, %eax
	je J2pede_6 #Se J2 pedir 6

J1_fugiu:

	pushl $J1fugiu
	call printf
	pushl $infoJ2GanhouMao
	call printf
	pushl aposta
	pushl $infoValendo
	call printf
	addl $16, %esp

	movl aposta, %eax
	addl %eax, tentosJ2
	jmp fimExecutaMao #Pula direto para o fim da Mao atual

J2_fugiu:

	pushl $J2fugiu
	call printf
	pushl $infoJ1GanhouMao
	call printf
	pushl aposta
	pushl $infoValendo
	call printf
	addl $16, %esp

	movl aposta, %eax
	addl %eax, tentosJ1
	jmp fimExecutaMao #Pula direto para o fim da Mao atual

J2aceitou_truco:

	movl $3, aposta #Aceitou o pedido de truco (aposta vale 3)

	pushl $3
	pushl $valendo
	call printf
	addl $8, %esp

	jmp fimOpcaoJ1pedirTruco #Retorna ao fluxo da jogada

J2pede_6:

	movl $3, aposta #Se Jogador 2 pediu 6, ja aceitou o pedido de truco (aposta vale 3)

	pushl $2
	pushl $pediu6
	call printf

	pushl $9
	pushl $simNaoAumenta
	call printf
	pushl $infoOpcao
	call printf

	pushl $respostaApostaJ1
	pushl $formatoInt
	call scanf

	addl $28, %esp

	movl respostaApostaJ1, %eax
	cmpl $0, %eax
	je J1_fugiu
	cmpl $1, %eax
	je J1aceitou_6
	cmpl $2, %eax
	je J1pede_9

	pushl $opcaoInvalida
	call printf
	addl $4, %esp
	jmp J2pede_6

J1aceitou_6:

	movl $6, aposta

	pushl $6
	pushl $valendo
	call printf
	addl $8, %esp

	jmp fimOpcaoJ1pedirTruco

J1pede_9:

	movl $6, aposta

	pushl $1
	pushl $pediu9
	call printf
	addl $8, %esp

	call probabilidadeJ2_foge_aceita_aumenta
	movl respostaApostaJ2, %eax
	cmpl $0, %eax
	je J2_fugiu #Se J2 fugir
	cmpl $1, %eax
	je J2aceitou_9 #Se J2 aceitar
	cmpl $2, %eax
	je J2pede_12 #Se J2 pedir 6

J2aceitou_9:

	movl $9, aposta

	pushl $9
	pushl $valendo
	call printf
	addl $8, %esp

	jmp fimOpcaoJ1pedirTruco

J2pede_12:

	movl $9, aposta

	pushl $2
	pushl $pediu12
	call printf

	pushl $fogeOuAceita
	call printf
	pushl $infoOpcao
	call printf

	pushl $respostaApostaJ1
	pushl $formatoInt
	call scanf

	addl $24, %esp

	movl respostaApostaJ1, %eax
	cmpl $0, %eax
	je J1_fugiu
	cmpl $1, %eax
	je J1aceitou_12

	pushl $opcaoInvalida
	call printf
	addl $4, %esp
	jmp J2pede_12

J1aceitou_12:

	movl $12, aposta

	pushl $12
	pushl $valendo
	call printf
	addl $8, %esp

fimOpcaoJ1pedirTruco:

	movl %ebp, %esp
	popl %ebp
	ret

#-----------------------------------------------------------------------------------------------------------

#Pergunta se Jogador 2 quer pedir truco, e trata os possiveis fluxos
opcaoJ2pedirTruco:

	pushl %ebp
	movl %esp, %ebp

perguntaJ2_truco:

	call probabilidadeJ2pedirTruco

	movl numDigitado, %eax #Verifica e trata a resposta do jogador
	cmpl $1, %eax
	je J2pede_truco
	cmpl $2, %eax
	je fimOpcaoJ2pedirTruco

J2pede_truco:

	call imprimeCartasJ1 #Mostra as cartas de Jogador 1 (para J1 saber oque decidir)
	pushl $pulaLinha
	call printf

	movl $1, flagJaPediuTruco

	pushl $2
	pushl $pediuTruco
	call printf

	pushl $6
	pushl $simNaoAumenta
	call printf
	pushl $infoOpcao
	call printf

	pushl $respostaApostaJ1
	pushl $formatoInt
	call scanf

	addl $32, %esp

	movl respostaApostaJ1, %eax
	cmpl $0, %eax
	je J1_fugiu #Se J1 fugir
	cmpl $1, %eax
	je J1aceitou_truco #Se J1 aceitar
	cmpl $2, %eax
	je J1pede_6 #Se J1 pedir 6

	pushl opcaoInvalida
	call printf
	addl $4, %esp
	jmp J2pede_truco

J1aceitou_truco:

	movl $3, aposta #Aceitou o pedido de truco (aposta vale 3)

	pushl $3
	pushl $valendo
	call printf
	addl $8, %esp

	jmp fimOpcaoJ1pedirTruco #Retorna ao fluxo da jogada

J1pede_6:

	movl $3, aposta #Se Jogador 1 pediu 6, ja aceitou o pedido de truco (aposta vale 3)

	pushl $1
	pushl $pediu6
	call printf

	addl $8, %esp

	call probabilidadeJ2_foge_aceita_aumenta

	movl respostaApostaJ2, %eax
	cmpl $0, %eax
	je J2_fugiu
	cmpl $1, %eax
	je J2aceitou_6
	cmpl $2, %eax
	je J2pede_9

J2aceitou_6:

	movl $6, aposta

	pushl $6
	pushl $valendo
	call printf
	addl $8, %esp

	jmp fimOpcaoJ1pedirTruco

J2pede_9:

	movl $6, aposta

	pushl $2
	pushl $pediu9
	call printf

	pushl $12
	pushl $simNaoAumenta
	call printf
	pushl $infoOpcao
	call printf

	pushl $respostaApostaJ1
	pushl $formatoInt
	call scanf

	addl $28, %esp

	movl respostaApostaJ1, %eax
	cmpl $0, %eax
	je J1_fugiu #Se J1 fugir
	cmpl $1, %eax
	je J1aceitou_9 #Se J1 aceitar
	cmpl $2, %eax
	je J1pede_12 #Se J2 pedir 6

	pushl opcaoInvalida
	call printf
	addl $4, %esp
	jmp J2pede_9

J1aceitou_9:

	movl $9, aposta

	pushl $9
	pushl $valendo
	call printf
	addl $8, %esp

	jmp fimOpcaoJ1pedirTruco

J1pede_12:

	movl $9, aposta

	pushl $1
	pushl $pediu12
	call printf

	addl $8, %esp

	call probabilidadeJ2aceitar12

	movl respostaApostaJ2, %eax
	cmpl $0, %eax
	je J2_fugiu
	cmpl $1, %eax
	je J2aceitou_12

J2aceitou_12:

	movl $12, aposta

	pushl $12
	pushl $valendo
	call printf
	addl $8, %esp

fimOpcaoJ2pedirTruco:

	movl %ebp, %esp
	popl %ebp
	ret

#-----------------------------------------------------------------------------------------------------------

#Imprime as cartas de Jogador 1 e verifica se ele quer pedir truco
J1pedirTruco:

	pushl %ebp
	movl %esp, %ebp

	movl flagJaPediuTruco, %eax
	cmpl $1, %eax
	je fimJ1pedirTruco #Se alguem ja pediu truco nao faz nada

	call imprimeCartasJ1

	pushl $pulaLinha
	call printf
	addl $4, %esp

	call opcaoJ1pedirTruco

	movl respostaApostaJ1, %eax
	cmpl $0, %eax
	je verifica_ganhador_jogo #Se Jogador 1 fugiu da aposta, acaba a Mao atual

	movl respostaApostaJ2, %eax
	cmpl $0, %eax
	je verifica_ganhador_jogo #Se Jogador 2 fugiu da aposta, acaba a Mao atual

fimJ1pedirTruco:

	movl %ebp, %esp
	popl %ebp
	ret

#-----------------------------------------------------------------------------------------------------------

#Verifica se Jogador 2 quer pedir truco
J2pedirTruco:

	pushl %ebp
	movl %esp, %ebp

	movl flagJaPediuTruco, %eax
	cmpl $1, %eax
	je fimJ2pedirTruco #Se alguem ja pediu truco nao faz nada

	pushl $pulaLinha
	call printf
	addl $4, %esp

	call opcaoJ2pedirTruco

	movl respostaApostaJ1, %eax
	cmpl $0, %eax
	je verifica_ganhador_jogo #Se Jogador 1 fugiu da aposta, acaba a Mao atual

	movl respostaApostaJ2, %eax
	cmpl $0, %eax
	je verifica_ganhador_jogo #Se Jogador 2 fugiu da aposta, acaba a Mao atual

fimJ2pedirTruco:

	movl %ebp, %esp
	popl %ebp
	ret
	
#-----------------------------------------------------------------------------------------------------------

#Pausa a execucao ate que o usuario digite uma tecla
pausaExecucao:

	pushl %ebp
	movl %esp, %ebp

	pushl $digiteAlgo
	call printf
	pushl $numDigitado
	pushl $limpabuffer
	call scanf
	call getchar
	addl $12, %esp

	movl %ebp, %esp
	popl %ebp
	ret

#-----------------------------------------------------------------------------------------------------------
#Funções para calcular probabilidade de pedir/aceitar/fugir truco/6/9/12
calculaProbabilidade:

	pushl %ebp
	movl %esp, %ebp

	movl probabilidadeBase, %ecx
	movl %ecx, probabilidade
	movl $10, %ebx #Uso nas divisoes para obter o peso da carta
	
calculaProbabilidade_As_Carta1:
	addl probabilidadeBase, %ecx

	movl carta1J2, %eax
	movl $0, %edx
	divl %ebx
	cmpl $7, %edx
	jnz calculaProbabilidade_As_Carta2
	addl %ecx, probabilidade

calculaProbabilidade_As_Carta2:
	movl carta2J2, %eax
	movl $0, %edx
	divl %ebx
	cmpl $7, %edx
	jnz calculaProbabilidade_As_Carta3
	addl %ecx, probabilidade

calculaProbabilidade_As_Carta3:
	movl carta3J2, %eax
	movl $0, %edx
	divl %ebx
	cmpl $7, %edx
	jnz calculaProbabilidade_Dois_Carta1
	addl %ecx, probabilidade

calculaProbabilidade_Dois_Carta1:
	addl probabilidadeBase, %ecx

	movl carta1J2, %eax
	movl $0, %edx
	divl %ebx
	cmpl $8, %edx
	jnz calculaProbabilidade_Dois_Carta2
	addl %ecx, probabilidade

calculaProbabilidade_Dois_Carta2:
	movl carta2J2, %eax
	movl $0, %edx
	divl %ebx
	cmpl $8, %edx
	jnz calculaProbabilidade_Dois_Carta3
	addl %ecx, probabilidade

calculaProbabilidade_Dois_Carta3:
	movl carta3J2, %eax
	movl $0, %edx
	divl %ebx
	cmpl $8, %edx
	jnz calculaProbabilidade_Tres_Carta1
	addl %ecx, probabilidade

calculaProbabilidade_Tres_Carta1:
	addl probabilidadeBase, %ecx

	movl carta1J2, %eax
	movl $0, %edx
	divl %ebx
	cmpl $9, %edx
	jnz calculaProbabilidade_Tres_Carta2
	addl %ecx, probabilidade

calculaProbabilidade_Tres_Carta2:
	movl carta2J2, %eax
	movl $0, %edx
	divl %ebx
	cmpl $9, %edx
	jnz calculaProbabilidade_Tres_Carta3
	addl %ecx, probabilidade

calculaProbabilidade_Tres_Carta3:
	movl carta3J2, %eax
	movl $0, %edx
	divl %ebx
	cmpl $9, %edx
	jnz calculaProbabilidade_Vira_Carta1
	addl %ecx, probabilidade

calculaProbabilidade_Vira_Carta1:
	addl probabilidadeBase, %ecx

	movl carta1J2, %eax
	movl $0, %edx
	divl %ebx
	cmpl manilha, %edx
	jnz calculaProbabilidade_Vira_Carta2
	addl %ecx, probabilidade

calculaProbabilidade_Vira_Carta2:
	movl carta2J2, %eax
	movl $0, %edx
	divl %ebx
	cmpl manilha, %edx
	jnz calculaProbabilidade_Vira_Carta3
	addl %ecx, probabilidade

calculaProbabilidade_Vira_Carta3:
	movl carta3J2, %eax
	movl $0, %edx
	divl %ebx
	cmpl manilha, %edx
	jnz fim_calculaProbabilidade
	addl %ecx, probabilidade

fim_calculaProbabilidade:
	#pushl probabilidade
	#pushl $infoTextoProbabilidade
	#call printf
	#addl $8, %esp

	movl %ebp, %esp
	popl %ebp
	ret

#-----------------------------------------------------------------------------------------------------------

#Coloca as cartas da Maquina em ordem crscente, nos rotulos de ordem
criaOrdemCrescenteJ2:

	pushl %ebp
	movl %esp, %ebp

	call J2escolheMenorCartaDisponivel
	cmpl $1, %eax
	je _menor_eh_1
	cmpl $2, %eax
	je _menor_eh_1
	jmp _menor_eh_3

_menor_eh_1:
	jmp cmp_2_3

_menor_eh_2:
	jmp cmp_1_3

_menor_eh_3:
	jmp cmp_1_2

cmp_2_3:

	movl carta2J2, %eax
	movl %eax, cartaCompara1
	movl carta3J2, %eax
	movl %eax, cartaCompara2
	call maiorEntre2Cartas #Compara as duas, resultado retornado em eax (1 ou 2)

	cmpl $1, %eax
	je ordem_132
	jmp ordem_123

cmp_1_3:

	movl carta1J2, %eax
	movl %eax, cartaCompara1
	movl carta3J2, %eax
	movl %eax, cartaCompara2
	call maiorEntre2Cartas #Compara as duas, resultado retornado em eax (1 ou 2)

	cmpl $1, %eax
	je ordem_231
	jmp ordem_213

cmp_1_2:

	movl carta1J2, %eax
	movl %eax, cartaCompara1
	movl carta2J2, %eax
	movl %eax, cartaCompara2
	call maiorEntre2Cartas #Compara as duas, resultado retornado em eax (1 ou 2)

	cmpl $1, %eax
	je ordem_321
	jmp ordem_312

ordem_123:

	movl $1, ordemCrescente1
	movl $2, ordemCrescente2
	movl $3, ordemCrescente3
	jmp fim_criaOrdemCrescenteJ2

ordem_132:

	movl $1, ordemCrescente1
	movl $3, ordemCrescente2
	movl $2, ordemCrescente3
	jmp fim_criaOrdemCrescenteJ2

ordem_213:

	movl $2, ordemCrescente1
	movl $1, ordemCrescente2
	movl $3, ordemCrescente3
	jmp fim_criaOrdemCrescenteJ2

ordem_231:

	movl $2, ordemCrescente1
	movl $3, ordemCrescente2
	movl $1, ordemCrescente3
	jmp fim_criaOrdemCrescenteJ2

ordem_312:

	movl $3, ordemCrescente1
	movl $1, ordemCrescente2
	movl $2, ordemCrescente3
	jmp fim_criaOrdemCrescenteJ2

ordem_321:

	movl $3, ordemCrescente1
	movl $2, ordemCrescente2
	movl $1, ordemCrescente3

fim_criaOrdemCrescenteJ2:

	movl %ebp, %esp
	popl %ebp
	ret

#-----------------------------------------------------------------------------------------------------------

#Recebe 2 cartas pelos rotulos cartaCompara1 e cartaCompara2 e retorna qual é maior (1 ou 2) pelo reg eax
#Retorna 0 em caso de empate
maiorEntre2Cartas:

	pushl %ebp
	movl %esp, %ebp

	#Calcula o peso das 2 cartas

	movl cartaCompara1, %eax
	movl $0, %edx #Limpa edx para evitar erro na divisao
	movl $10, %ebx
	divl %ebx #Divide eax por 10
	movl %edx, pesoCarta1 #Coloca o resto no peso da carta

	movl cartaCompara2, %eax
	movl $0, %edx
	movl $10, %ebx
	divl %ebx
	movl %edx, pesoCarta2

	#Verifica se as cartas sao manilhas

	movl pesoCarta1, %eax
	cmpl %eax, manilha #Se 1 é manilha
	je _1ehManilha

	movl pesoCarta2, %ebx
	cmpl %ebx, manilha #Se 2 é manilha ja ganhou
	je _2ganha

	#Se nenhuma das duas eh manilha

	cmpl %eax, %ebx
	jl _1ganha
	jg _2ganha
	jmp _empate

_1ehManilha:

	movl pesoCarta2, %eax
	cmpl %eax, manilha #Se 2 também é manilha
	je _duasSaoManilhas
	jmp _1ganha #Se não 1 ja ganhou

_duasSaoManilhas:

	#Se as duas sao manilhas, compara-se os nipes (que ja estao em ordem crescente no mapeamento)
	movl cartaEscolhidaJ1, %eax
	movl cartaEscolhidaJ2, %ebx
	cmpl %eax, %ebx
	jl J1ganha
	jmp J2ganha

_1ganha:

	movl $1, %eax
	jmp fim_maiorEntre2Cartas

_2ganha:

	movl $2, %eax
	jmp fim_maiorEntre2Cartas

_empate:

	movl $0, %eax

fim_maiorEntre2Cartas:

	movl %ebp, %esp
	popl %ebp
	ret

#-----------------------------------------------------------------------------------------------------------

#Escolhe a menor dentre as cartas DISPONIVEIS de J2 (Maquina) e retorna em eax (1, 2 ou 3)
J2escolheMenorCartaDisponivel: 

	pushl %ebp
	movl %esp, %ebp

	movl rodada, %eax
	cmpl $3, %eax
	je terceira_rodada #Se ja esta na terceira rodada, basta pegar a unica carta restante

	#Se ja usou uma das cartas, compara as duas restantes
	movl flagUsouCarta1J2, %eax
	cmpl $1, %eax
	je compara_2_3

	movl flagUsouCarta2J2, %eax
	cmpl $1, %eax
	je compara_1_3

	movl flagUsouCarta3J2, %eax
	cmpl $1, %eax
	je compara_1_2

	#Se nenhuma das cartas foi usada ainda, escolhe a menor dentre as 3
	#Compara 1 e 2
	movl carta1J2, %eax
	movl %eax, cartaCompara1
	movl carta2J2, %eax
	movl %eax, cartaCompara2
	call maiorEntre2Cartas #Compara as duas, resultado retornado em eax (1 ou 2)

	cmpl $1, %eax
	je compara_2_3
	jmp compara_1_3

compara_2_3:

	#Move as cartas para os rotulos usados na funcao de comparacao

	movl carta2J2, %eax
	movl %eax, cartaCompara1
	movl carta3J2, %eax
	movl %eax, cartaCompara2
	call maiorEntre2Cartas #Compara as duas, resultado retornado em eax (1 ou 2)

	cmpl $1, %eax
	je menor_eh_3
	jmp menor_eh_2

compara_1_3:

	movl carta1J2, %eax
	movl %eax, cartaCompara1
	movl carta3J2, %eax
	movl %eax, cartaCompara2
	call maiorEntre2Cartas #Compara as duas, resultado retornado em eax (1 ou 2)

	cmpl $1, %eax
	je menor_eh_3
	jmp menor_eh_1

compara_1_2:

	movl carta1J2, %eax
	movl %eax, cartaCompara1
	movl carta2J2, %eax
	movl %eax, cartaCompara2
	call maiorEntre2Cartas #Compara as duas, resultado retornado em eax (1 ou 2)

	cmpl $1, %eax
	je menor_eh_2
	jmp menor_eh_1

terceira_rodada:

	movl flagUsouCarta1J2, %eax
	cmpl $0, %eax
	je menor_eh_1

	movl flagUsouCarta2J2, %eax
	cmpl $0, %eax
	je menor_eh_2

	movl flagUsouCarta3J2, %eax
	cmpl $0, %eax
	je menor_eh_3

menor_eh_1:

	movl $1, %eax
	jmp fimJ2escolheMenorCarta

menor_eh_2:

	movl $2, %eax
	jmp fimJ2escolheMenorCarta

menor_eh_3:

	movl $3, %eax

fimJ2escolheMenorCarta:

	movl %ebp, %esp
	popl %ebp
	ret

#-----------------------------------------------------------------------------------------------------------

#Escolhe a maior dentre as cartas DISPONIVEIS de J2 (Maquina) e retorna em eax (1, 2 ou 3)
J2escolheMaiorCartaDisponivel: 

	pushl %ebp
	movl %esp, %ebp

	movl rodada, %eax
	cmpl $3, %eax
	je _terceira_rodada #Se ja esta na terceira rodada, basta pegar a unica carta restante

	#Se ja usou uma das cartas, compara as duas restantes
	movl flagUsouCarta1J2, %eax
	cmpl $1, %eax
	je _compara_2_3

	movl flagUsouCarta2J2, %eax
	cmpl $1, %eax
	je _compara_1_3

	movl flagUsouCarta3J2, %eax
	cmpl $1, %eax
	je _compara_1_2

	#Se nenhuma das cartas foi usada ainda, escolhe a menor dentre as 3
	#Compara 1 e 2
	movl carta1J2, %eax
	movl %eax, cartaCompara1
	movl carta2J2, %eax
	movl %eax, cartaCompara2
	call maiorEntre2Cartas #Compara as duas, resultado retornado em eax (1 ou 2)

	cmpl $1, %eax
	je _compara_1_3
	jmp _compara_2_3

_compara_2_3:

	#Move as cartas para os rotulos usados na funcao de comparacao

	movl carta2J2, %eax
	movl %eax, cartaCompara1
	movl carta3J2, %eax
	movl %eax, cartaCompara2
	call maiorEntre2Cartas #Compara as duas, resultado retornado em eax (1 ou 2)

	cmpl $1, %eax
	je maior_eh_2
	jmp maior_eh_3

_compara_1_3:

	movl carta1J2, %eax
	movl %eax, cartaCompara1
	movl carta3J2, %eax
	movl %eax, cartaCompara2
	call maiorEntre2Cartas #Compara as duas, resultado retornado em eax (1 ou 2)

	cmpl $1, %eax
	je maior_eh_1
	jmp maior_eh_3

_compara_1_2:

	movl carta1J2, %eax
	movl %eax, cartaCompara1
	movl carta2J2, %eax
	movl %eax, cartaCompara2
	call maiorEntre2Cartas #Compara as duas, resultado retornado em eax (1 ou 2)

	cmpl $1, %eax
	je maior_eh_1
	jmp maior_eh_2

_terceira_rodada:

	movl flagUsouCarta1J2, %eax
	cmpl $0, %eax
	je maior_eh_1

	movl flagUsouCarta2J2, %eax
	cmpl $0, %eax
	je maior_eh_2

	movl flagUsouCarta3J2, %eax
	cmpl $0, %eax
	je maior_eh_3

maior_eh_1:

	movl $1, %eax
	jmp fimJ2escolheMaiorCarta

maior_eh_2:

	movl $2, %eax
	jmp fimJ2escolheMaiorCarta

maior_eh_3:

	movl $3, %eax

fimJ2escolheMaiorCarta:

	movl %ebp, %esp
	popl %ebp
	ret

#-----------------------------------------------------------------------------------------------------------

#Escolhe a menor carta possivel de J2 (maquina) que consiga matar a carta do jogador humano
#Retorna 1, 2 ou 3 caso afirmativo, pelo reg eax
#Retorna 0 caso nenhuma consiga matar
J2mataComMenorPossivel:

	pushl %ebp
	movl %esp, %ebp

tenta_matar_1:

	movl ordemCrescente1, %eax
	cmpl $1, %eax
	je maisFraca_eh1
	cmpl $2, %eax
	je maisFraca_eh2
	jmp maisFraca_eh3

maisFraca_eh1:

	movl flagUsouCarta1J2, %eax #Verifica se a carta ja nao foi usada
	cmpl $1, %eax
	je tenta_matar_2

	#Verifica se a carta de J2 mata a carta escolhida por J1
	movl carta1J2, %eax
	movl %eax, cartaCompara1
	movl cartaEscolhidaJ1, %eax
	movl %eax, cartaCompara2
	call maiorEntre2Cartas #Compara as duas, resultado retornado em eax (1 ou 2)

	#Verifica se a carta de J2 ganhou, caso contrario tenta a proxima
	cmpl $1, %eax
	jne tenta_matar_2
	movl $1, %eax
	jmp fim_J2mataComMenorPossivel

maisFraca_eh2:

	movl flagUsouCarta2J2, %eax #Verifica se a carta ja nao foi usada
	cmpl $1, %eax
	je tenta_matar_2

	#Verifica se a carta de J2 mata a carta escolhida por J1
	movl carta2J2, %eax
	movl %eax, cartaCompara1
	movl cartaEscolhidaJ1, %eax
	movl %eax, cartaCompara2
	call maiorEntre2Cartas #Compara as duas, resultado retornado em eax (1 ou 2)

	#Verifica se a carta de J2 ganhou, caso contrario tenta a proxima
	cmpl $1, %eax
	jne tenta_matar_2
	movl $2, %eax
	jmp fim_J2mataComMenorPossivel

maisFraca_eh3:

	movl flagUsouCarta3J2, %eax #Verifica se a carta ja nao foi usada
	cmpl $1, %eax
	je tenta_matar_2

	#Verifica se a carta de J2 mata a carta escolhida por J1
	movl carta3J2, %eax
	movl %eax, cartaCompara1
	movl cartaEscolhidaJ1, %eax
	movl %eax, cartaCompara2
	call maiorEntre2Cartas #Compara as duas, resultado retornado em eax (1 ou 2)

	#Verifica se a carta de J2 ganhou, caso contrario tenta a proxima
	cmpl $1, %eax
	jne tenta_matar_2
	movl $3, %eax
	jmp fim_J2mataComMenorPossivel


tenta_matar_2:

	movl ordemCrescente2, %eax
	cmpl $1, %eax
	je media_eh1
	cmpl $2, %eax
	je media_eh2
	jmp media_eh3

media_eh1:

	movl flagUsouCarta1J2, %eax #Verifica se a carta ja nao foi usada
	cmpl $1, %eax
	je tenta_matar_3

	#Verifica se a carta de J2 mata a carta escolhida por J1
	movl carta1J2, %eax
	movl %eax, cartaCompara1
	movl cartaEscolhidaJ1, %eax
	movl %eax, cartaCompara2
	call maiorEntre2Cartas #Compara as duas, resultado retornado em eax (1 ou 2)

	#Verifica se a carta de J2 ganhou, caso contrario tenta a proxima
	cmpl $1, %eax
	jne tenta_matar_3
	movl $1, %eax
	jmp fim_J2mataComMenorPossivel

media_eh2:

	movl flagUsouCarta2J2, %eax #Verifica se a carta ja nao foi usada
	cmpl $1, %eax
	je tenta_matar_3

	#Verifica se a carta de J2 mata a carta escolhida por J1
	movl carta2J2, %eax
	movl %eax, cartaCompara1
	movl cartaEscolhidaJ1, %eax
	movl %eax, cartaCompara2
	call maiorEntre2Cartas #Compara as duas, resultado retornado em eax (1 ou 2)

	#Verifica se a carta de J2 ganhou, caso contrario tenta a proxima
	cmpl $1, %eax
	jne tenta_matar_3
	movl $2, %eax
	jmp fim_J2mataComMenorPossivel

media_eh3:

	movl flagUsouCarta3J2, %eax #Verifica se a carta ja nao foi usada
	cmpl $1, %eax
	je tenta_matar_3

	#Verifica se a carta de J2 mata a carta escolhida por J1
	movl carta3J2, %eax
	movl %eax, cartaCompara1
	movl cartaEscolhidaJ1, %eax
	movl %eax, cartaCompara2
	call maiorEntre2Cartas #Compara as duas, resultado retornado em eax (1 ou 2)

	#Verifica se a carta de J2 ganhou, caso contrario tenta a proxima
	cmpl $1, %eax
	jne tenta_matar_3
	movl $3, %eax
	jmp fim_J2mataComMenorPossivel


tenta_matar_3:

	movl ordemCrescente3, %eax
	cmpl $1, %eax
	je forte_eh1
	cmpl $2, %eax
	je forte_eh2
	jmp forte_eh3

forte_eh1:

	movl flagUsouCarta1J2, %eax #Verifica se a carta ja nao foi usada
	cmpl $1, %eax
	je nao_consegue_matar

	#Verifica se a carta de J2 mata a carta escolhida por J1
	movl carta1J2, %eax
	movl %eax, cartaCompara1
	movl cartaEscolhidaJ1, %eax
	movl %eax, cartaCompara2
	call maiorEntre2Cartas #Compara as duas, resultado retornado em eax (1 ou 2)

	#Verifica se a carta de J2 ganhou, caso contrario tenta a proxima
	cmpl $1, %eax
	jne nao_consegue_matar
	movl $1, %eax
	jmp fim_J2mataComMenorPossivel

forte_eh2:

	movl flagUsouCarta2J2, %eax #Verifica se a carta ja nao foi usada
	cmpl $1, %eax
	je nao_consegue_matar

	#Verifica se a carta de J2 mata a carta escolhida por J1
	movl carta2J2, %eax
	movl %eax, cartaCompara1
	movl cartaEscolhidaJ1, %eax
	movl %eax, cartaCompara2
	call maiorEntre2Cartas #Compara as duas, resultado retornado em eax (1 ou 2)

	#Verifica se a carta de J2 ganhou, caso contrario tenta a proxima
	cmpl $1, %eax
	jne nao_consegue_matar
	movl $2, %eax
	jmp fim_J2mataComMenorPossivel

forte_eh3:

	movl flagUsouCarta3J2, %eax #Verifica se a carta ja nao foi usada
	cmpl $1, %eax
	je nao_consegue_matar

	#Verifica se a carta de J2 mata a carta escolhida por J1
	movl carta3J2, %eax
	movl %eax, cartaCompara1
	movl cartaEscolhidaJ1, %eax
	movl %eax, cartaCompara2
	call maiorEntre2Cartas #Compara as duas, resultado retornado em eax (1 ou 2)

	#Verifica se a carta de J2 ganhou, caso contrario tenta a proxima
	cmpl $1, %eax
	jne nao_consegue_matar
	movl $3, %eax
	jmp fim_J2mataComMenorPossivel

nao_consegue_matar:

	#Verifica se consegue pelo menos empatar

tenta_empatar1:

	movl carta1J2, %eax
	movl %eax, cartaCompara1
	movl cartaEscolhidaJ1, %eax
	movl %eax, cartaCompara2
	call maiorEntre2Cartas

	cmpl $0, %eax
	jne tenta_empatar2
	movl $1, %eax
	jmp fim_J2mataComMenorPossivel

tenta_empatar2:

	movl carta2J2, %eax
	movl %eax, cartaCompara1
	movl cartaEscolhidaJ1, %eax
	movl %eax, cartaCompara2
	call maiorEntre2Cartas

	cmpl $0, %eax
	jne tenta_empatar3
	movl $2, %eax
	jmp fim_J2mataComMenorPossivel

tenta_empatar3:

	movl carta3J2, %eax
	movl %eax, cartaCompara1
	movl cartaEscolhidaJ1, %eax
	movl %eax, cartaCompara2
	call maiorEntre2Cartas

	cmpl $0, %eax
	jne nao_mata_nem_empata
	movl $3, %eax
	jmp fim_J2mataComMenorPossivel

nao_mata_nem_empata:
	movl $0, %eax

fim_J2mataComMenorPossivel:

	movl %ebp, %esp
	popl %ebp
	ret

#-----------------------------------------------------------------------------------------------------------

_start:

	call imprimeAbertura
	pushl $digiteAlgo
	call printf
	call getchar
	addl $4, %esp
	
inicioJogo:

	call verificaMao11 #Seta a flagJogadorTem11 caso alguem ja tenha 11 tentos

	movl flagJogadorTem11, %eax
	cmpl $0, %eax
	je executaMaoNormal #Se a flag ainda tem 0 executa a mao normal
	cmpl $1, %eax
	je executaMaoDe11
	cmpl $2, %eax
	je executaMaoDe11
	cmpl $3, %eax
	je executaMaoNormalSemTruco #Se a flag tem 3, ambos tem 11, executa mao normal sem truco

executaMaoNormal:

	call executaMao
	jmp verifica_ganhador_jogo

executaMaoDe11:

	call executaMao11 #Se não, a flag esta setada, executa mao de 11
	jmp verifica_ganhador_jogo

executaMaoNormalSemTruco:

	call executaMaoSemTruco

verifica_ganhador_jogo:

	call verificaGanhadorJogo

	movl flagJogoTeveGanhador, %eax
	cmpl $1, %eax
	je fimExecutaJogo
	jmp inicioJogo
	
fimExecutaJogo:

pushl $0
call exit
