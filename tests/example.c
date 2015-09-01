#include <stdio.h>

int main()
{
	int n; 

	while(!feof(stdin))
	{
		scanf("%d", &n);
		printf("%d\n", n);
	}

}