#include <iostream>
#include <algorithm>

using namespace std;

char const vocales[] = "AUEOI";
char const consonantes[] = "JSBKTCLDMVNWFXGPYHQZR";

int main()
{
	int casos,n,imp,par;
	char ans1[10086];
	char ans2[10086];
	
	cin >> casos;
	for(int i=0;i<casos;++i)
	{
		cout << "Case " << i+1 << ": ";
		cin >> n;
 		imp=par=0;
 		for(int j=0;j<n;++j)
			if(j%2)
				ans1[par]=consonantes[par++/5];
			else
				ans2[imp]=vocales[imp++/21];		
		sort(ans1,ans1+par);
		sort(ans2,ans2+imp);
		for(int j=0;j<n;++j)
		{
			if(j%2)
				cout << ans1[j/2];
			else
				cout << ans2[j/2];
		}
		cout << endl;
	}
	
	return 0;
}
