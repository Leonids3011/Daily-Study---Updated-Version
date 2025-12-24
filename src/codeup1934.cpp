/**
 * 输入一个数n(1<=n<=200)，然后输入n个数值各不相同的数。再输入一个数值x，
 * 输出这个值在这个数组中的下标（从0开始，若不在数组中则输出-1
 * 
 * 输入格式
 *  测试数据有多组，输入n(1<=n<=200)，接着输入n个数，然后输出x
 * 
 * 输出格式
 *  对于每组输入，请输出结果
 */

#include<iostream>

void getIndex(){
  int N[] = {18,15,1,2,4,39,20,47,3,33};
  int n = sizeof(N)/sizeof(int);
  int k;
  int x;
  std::cin >> x;
  for(k=0;k<n;k++){
    if(x==N[k]){
      printf("x in arr-index is: %d,and input x-number is: %d \n",k,x);
      break;
    }

  }
  if(k==n){
    printf("%d \n",-1);
  }
}
int main(){

  getIndex();
  return 0;
}