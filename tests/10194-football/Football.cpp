#include <iostream>
#include <string>
#include <vector>
#include <algorithm>
#include <sstream>
#include <queue>
#include <list>
#include <stack>
#include <map>
#include <set>
#include <cstdio>
#include <cstdlib>

using namespace std;

struct datos
{
    int points;
    int games;
    int win;
    int tie;
    int lost;
    int df;
    int goalsf;
    int goalsc;

};

string toMayus(string s)
{
    unsigned int i=0;
    for(i=0; i<s.size(); ++i)
        s[i] = toupper(s[i]);
    return s;
}


bool compare(pair<string,datos>par1 , pair<string,datos>par2)
{
    if(par1.second.points!=par2.second.points)	return(par1.second.points>par2.second.points);
    if(par1.second.win!=par2.second.win) return(par1.second.win>par2.second.win);
    if(par1.second.df!=par2.second.df) return(par1.second.df>par2.second.df);
    if(par1.second.goalsf!=par2.second.goalsf) return(par1.second.goalsf>par2.second.goalsf);
    if(par1.second.games!=par2.second.games) return(par1.second.games!=par2.second.games);
    if(toMayus(par1.first)!=toMayus(par2.first)) return toMayus(par1.first)<toMayus(par2.first);
    return false;
}
	
int main()
{
	char team1[10000+10];
	char team2[10000+10];
	int testCase,nequipos,matches,t1,t2;
	string copa,equipo,confront;
	scanf("%d\n",&testCase);
	while(testCase--)
	{
		map<string,datos> f; 
		getline(cin,copa);
		scanf("%d\n",&nequipos);
		while(nequipos--)
		{
			getline(cin,equipo);
			f[equipo].points=0;
			f[equipo].games=0;
			f[equipo].win=0;
			f[equipo].tie=0;
			f[equipo].lost=0;
			f[equipo].df=0;
			f[equipo].goalsf=0;
			f[equipo].goalsc=0;
		}
		scanf("%d\n",&matches);
		while(matches--)
		{
			scanf("%[^#]#%d@%d#%[^\n]\n",team1,&t1,&t2,team2);
			string equipo1(team1);
			string equipo2(team2);
			f[equipo1].games++;
			f[equipo2].games++;
			f[equipo1].goalsf+=t1;
			f[equipo2].goalsf+=t2;
			f[equipo1].goalsc+=t2;
			f[equipo2].goalsc+=t1;
			f[equipo1].df+=(t1-t2);
			f[equipo2].df+=(t2-t1);
			if(t1>t2)
			{
				f[equipo1].win++;
				f[equipo2].lost++;
				f[equipo1].points+=3;
			}
			else if(t1<t2)
			{
				f[equipo2].win++;
				f[equipo1].lost++;
				f[equipo2].points+=3;
			}
			else
			{
				f[equipo1].tie++;
				f[equipo2].tie++;
				f[equipo1].points++;
				f[equipo2].points++;
			}
		}
		printf("%s\n",copa.c_str());
		int tam=f.size();
		for(int i=0;i<tam;++i)
		{
			pair<string,datos> res;
			res=*min_element(f.begin(),f.end(),compare);
			printf("%d) %s %dp, %dg (%d-%d-%d), %dgd (%d-%d)\n",i+1,res.first.c_str(),res.second.points,res.second.games,res.second.win,res.second.tie,res.second.lost,res.second.df,res.second.goalsf,res.second.goalsc);
			f.erase(res.first);
		}
		if(testCase) printf("\n");
	}
	

	return 0;
}