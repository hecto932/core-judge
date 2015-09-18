CC = gcc
CXX = g++
COMMON_FLAGS = -g -Wall -D_BSD_SOURCE 
CFLAGS = -std=c99 $(COMMON_FLAGS) #-DDEBUG_MALLOC
CXXFLAGS = $(COMMON_FLAGS)
SHLIB_CFLAGS = -fPIC $(CFLAGS)

sandbox.so : sandbox.o malloc.o
	gcc -shared -o sandbox.so sandbox.o malloc.o -ldl

sandbox.o : sandbox.c
	gcc -c $(SHLIB_CFLAGS) sandbox.c

malloc.o : malloc.c
	gcc -c $(SHLIB_CFLAGS) malloc.c

clean :
	rm -f *.o *.so 
