#include <iostream>
#include <vector>
#include <string>
#include <cstdio>

using namespace std;

long long int leer(int *b,int n)
{
	long long int cont=0;
	for(int i=0;i<n;++i)
		scanf("%d",&b[i]),cont+=b[i];
	return (cont);
}
int main()
{
	int n,game=0;
	while(scanf("%d",&n)==1 && n)
	{
		int *a = new int[n];
		int *b = new int[n];
		for(int i=0;i<n;++i)
			scanf("%d",&a[i]);
		printf("Game: %d\n",++game);
		while(scanf("%d",&b[0])==1)
		{
			int cont=b[0];
			if(b[0])
			{
				for(int i=1;i<n;++i)
					scanf("%d",&b[i]),cont+=b[0];
			}
			else
				break;
			int v1[1000]={},v2[1000]={};
			int cont1=0,cont2=0;
			for(int i=0;i<n;++i)
				if(a[i]==b[i])
					v1[i]=v2[i]=1,cont1++;
			for(int i = 0; i < n; i++)
			{
                if(v1[i])    continue;
                for(int j = 0; j < n; j++)
                {
                    if(a[i] == b[j] && v2[j] == 0)
                    {
                        v2[j] = 1, cont2++;
                        break;
                    }
                }
            }	
			printf("    (%d,%d)\n", cont1, cont2);
		}
		delete [] a;
		delete [] b;
	}
	
	return 0;
}