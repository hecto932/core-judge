#include <iostream>
#include <cstdio>
#include <string>
#include <utility>
#include <map>
#include <vector>
#include <list>
#include <algorithm>
#include <cstdlib>
#include <cmath>

using namespace std;
string str[100+5];

int main()
{
	int n;
	while(cin>>n)
	{
		int max=0;
		for(int i=0;i<n;++i)
		{
			cin >> str[i];
			int l=str[i].length();
			if(l>max)
				max=l;
		}
		sort(str,str+n);
		int columnas=62/(max+2);
		int just=max+2;
		int filas=ceil(n/(double)columnas);
		printf ("------------------------------------------------------------\n");
		for(int i=0;i<filas;++i)
		{
			for(int j=i;j<n;j+=filas)
			{
				cout << str[j];
				if((j+filas)<n)
				{
					for(int k=str[j].length();k<just;++k)
						printf(" ");
				}
			}
			printf("\n");
		}
	}
	
	return 0;
}