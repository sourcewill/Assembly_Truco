� Montando e executando o c�digo fonte
 
Para poder jogar o Jogo de Truco implementado deve-se seguir os passos descritos em um dos m�todos a seguir.
Como pr�-requisito para ambos os m�todos deve-se ter instalada na m�quina a biblioteca gcc-multilib.
Para instala��o da biblioteca, digite o seguinte comando no terminal:  
 
sudo apt-get install gcc-multilib 

� Montagem e execu��o manuais
Digite os seguintes comandos no terminal: 

as -32 truco.s -o truco.o
ld -m elf_i386 truco.o -l c -dynamic-linker /lib/ld-linux.so.2 -o truco
./truco 

� Montagem e execu��o com script
Digite o seguinte comando no terminal: 
 
./ce truco 
 
Este m�todo executa os mesmos comandos do m�todo manual mas de forma automatizada, com o uso de um script (ce) que deve estar na mesma pasta do c�digo fonte, sendo necess�rio passar como argumento apenas o nome do arquivo que cont�m o c�digo fonte (sem extens�o). 