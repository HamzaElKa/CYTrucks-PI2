all: myprog

avl_s.o : avl_s.c avl_s.h
	gcc -c avl_s.c -o avl_s.o

myprog : avl_s.o
	gcc avl_s.o -o myprog

clean :
	rm -f *.o
	rm myprog
