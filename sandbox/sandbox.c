/*
| Esta es una prueba de un sandbox sencillo.
| ./ejecutable archivo_ejecutar entrada salida MAX_TIME MAXSIZE
|
|

*/

#include <sys/types.h>
#include <unistd.h>
#include <stdio.h>

//TIEMPO MAXIMO DE EJECUCION DEL HIJO
int MAXTIME;

//MAXIMO DE MEMORIA 
int MAXSIZE;

int main(int argc, char *argv[])
{
	printf("%s\n", argv[1]);
	printf("%s\n", argv[2]);
	printf("%s\n", argv[3]);

	int pid = fork();

	if(pid == -1) // FALLO EN CREAR EL PROCESO
	{
		printf("Hay un fallo!\n");
	}
	else if(pid == 0) //PROCESO HIJO
	{
		printf("Estoy en el proceso hijo\n");
		int i = 1;
		while(i){
			printf("%d\n", i);
			i++;
		}
		
	}
	else //PROCESO PADRE
	{
		printf("Voy a dormir!");
		sleep(5);
		exit(getpid());
		printf("Desperte!\n");
	}

	return 0;
}