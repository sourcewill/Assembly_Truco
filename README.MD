# Jogo de Truco em Assembly
Feito por: William Rodrigues

## Pré-requisitos
Como pré-requisito para ambos os métodos deve-se ter instalada na máquina a biblioteca gcc-multilib.
Para instalação da biblioteca, utilize o seguinte comando:  
```
sudo apt-get install gcc-multilib 
```
## Montagem e execução manuais
Digite os seguintes comandos no terminal: 
```
as -32 truco.s -o truco.o
ld -m elf_i386 truco.o -l c -dynamic-linker /lib/ld-linux.so.2 -o truco
./truco 
```
## Montagem e execução com script
Digite o seguinte comando no terminal: 
```
./ce truco 
```
Este método executa os mesmos comandos do método manual mas de forma automatizada, com o uso de um script (ce) que deve estar na mesma pasta do código fonte, sendo necessário passar como argumento apenas o nome do arquivo que contém o código fonte (sem extensão).
