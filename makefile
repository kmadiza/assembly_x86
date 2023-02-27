main: proj.o bin_1.o
	gcc -m32 -g -o main proj.o bin_1.o


proj.o: proj.c
	gcc -m32 -c -g -O0 -o proj.o proj.c

bin_1.o: bin_1.asm
	nasm -o bin_1.o -f elf -g -l bin_1.lst bin_1.asm


.PHONY: clean

clean:
	rm -f main proj.o bin_1.o bin_1.lst
