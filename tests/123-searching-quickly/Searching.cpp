#include <iostream>
#include <cstdio>
#include <string>
#include <list>
#include <cstring>
#include <sstream>
#include <algorithm>

using namespace std;

typedef list<string> List;
typedef string::iterator Its;
typedef list<string>::iterator itl;

List palabra,titulo,key;

int main()
{
	string str;
	while(cin >> str && str!="::")
		palabra.push_back(str);
	palabra.sort();
	while(getline(cin,str))
	{
		for(Its it = str.begin();it!=str.end();++it)
			*it=tolower(*it);
		istringstream sin(str);
		string buf;
		while(sin >> buf)
		{
			if(binary_search(palabra.begin(),palabra.end(),buf))
				continue;
			key.push_back(buf);
		}
		titulo.push_back(" " + str + " ");
	}
	key.sort();
	key.unique();
	for(itl it = key.begin();it!=key.end();++it)
	{
		string w = " " + (*it) + " ";
		for(itl it1 = titulo.begin(); it1 != titulo.end();++it1)
		{
			str = *it1;
			int pos = str.find(w) + 1, len = str.length()-1;
			while(pos>0)
			{
				str=*it1;
				while(pos < len && isalpha(str[pos]))
				{
					str[pos]=toupper(str[pos]);
					++pos;
				}
				for(int i = 1 ; i < len;++i)
					putchar(str[i]);
				putchar(10);
 				pos=str.find(w,pos)+1;
			}
		}
	}
	return 0;
}