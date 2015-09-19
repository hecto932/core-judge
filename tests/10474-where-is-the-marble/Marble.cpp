#include <iostream>
#include <algorithm>
#include <vector>

using namespace std;

int n,q,x,caso=0;
vector<int> v;
vector<int>::iterator itr;

int main()
{
	while((cin >> n >> q)&&(n!=0 && q!=0))
	{
		cout << "CASE# " << ++caso << ":" << endl;
		v.clear();
		for(int i = n ; i > 0 ; --i)
		{
			cin >> x;
			v.push_back(x);
		}
		sort(v.begin(),v.end());
		for(int i  = q ; i > 0 ; --i)
		{
			cin >> x;
			bool ok=false;
			for(int j = 0; j < n && !ok; ++j)
			{
				if(v[j]==x)
				{
					cout << x << " found at " << j+1 << endl;
					ok=true;
				}
				else if(v[j]>x)
					break;
					
			}
			if(!ok)
				cout << x << " not found" << endl;
		}
	}
	
	return 0;
}
