#include <stdio.h>
#include <math.h>

int main()
{
	int test,k,j,i,x;
	int v[2];
	scanf("%d\n",&test);
	for(x=1;x<=test;++x)
	{
		scanf("%d\n",&k);
		j=0;
		for(i=2;j<2 && (j*j)<=k;++i)
			if(k%i==0)
				v[j++]=i;
		printf("Case #%d: %d = %d * %d = %d * %d\n",x,k,v[0],k/v[0],v[1],k/v[1]);
	}
	return 0;
}