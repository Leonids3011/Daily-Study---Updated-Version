// 输入一个数 n（1<=n<=200）,然后输入n个数值各不相同的数，再输入一个值x，输出这个值在这个数组中的下标（从0开始，若不再数组中则输出-1）
// 输入格式：测试数据有多组，输出n(1<=n<=200),接着输入n个数，然后输入x。
// 输出格式：对于每组输入，请输出结果。
// 样例输入：4 1234 3 样例输出：2
//

#include<cstdio>
const int maxn = 210;
int a[maxn]; // 存放n个数
int main(){

   int n,x;
   while(scanf("%d",&n)!=EOF)
   {
   	for(int i= 0;i<n;i++)
	{
	    scanf("%d",&a[i]); 
	}
	scanf("%d",&x); 
	int k; //下标
	for (k=0;k<n;k++)
	{
		if(a[k]==x)
		{
			printf("%d\n",k);
			break;
		}
	}
	if(k==n){
		printf("-1\n");
	}
   }
   return 0;
}
