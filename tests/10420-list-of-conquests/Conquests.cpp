#include <iostream>
#include <utility>
#include <algorithm>
#include <map>

using namespace std;

map<string,int> paises;

int main()
{
	int n;
	char s[100];
	string str;
	
	cin >> n;
	for(int i=0;i<n;++i)
	{
		cin >> str;
		cin.getline(s,100);
		++paises[str];
	}
	for(map<string,int>::iterator it=paises.begin(); it!=paises.end();++it)
		cout << it->first << " " << it->second << endl;
 	return 0;
}