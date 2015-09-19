#include <iostream>
#include <cstdio>
#include <utility>
#include <map>
#include <vector>
#include <string>
#include <cstring>
#include <algorithm>
#include <cctype>

using namespace std;

int length;
string str;
string dir [100000 + 10];

char cambio(char c)
{
	if(c=='A' || c=='B' || c=='C') return '2';
	if(c=='D' || c=='E' || c=='F') return '3';
	if(c=='G' || c=='H' || c=='I') return '4';
	if(c=='J' || c=='K' || c=='L') return '5';
	if(c=='M' || c=='N' || c=='O') return '6';
	if(c=='P' || c=='R' || c=='S') return '7';
	if(c=='T' || c=='U' || c=='V') return '8';
	if(c=='W' || c=='X' || c=='Y') return '9';
	return c;
}

void str_numero (char *a)
{
	str.clear();
	for(int i=0;a[i];++i)
	{
		if(isdigit(a[i]))
			str+=a[i];
		else if(isalpha(a[i]))
			str+=cambio(a[i]);
	}
	str.insert(3,"-");
}

int main()
{
	int testcase;
	scanf("%d",&testcase);
	bool blanco=false;
	while(testcase--)
	{
		length=0;
		int directory;
		scanf("%d",&directory);
		getchar();
		map<string,int> d;
		while(directory--)
		{
			char numero[1000];
			gets(numero);
			str_numero(numero);
			d[str]++;
			if(d[str]==2) dir[length++]=str;
		}
		sort(dir,dir+length);
		if(blanco) cout << endl;
		blanco=true;
		bool duplicates=false;
		for(int i=0;i<length;++i)
		{
			cout << dir[i] << " " << d [dir[i]] << endl;
			duplicates=true;
		}
		if(!duplicates)	cout << "No duplicates." << endl;
	}
	
	return 0;
}
