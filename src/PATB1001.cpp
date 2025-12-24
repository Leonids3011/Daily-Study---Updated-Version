#include<iostream>

void Callatz(){
  int i=0;
  int step = 0;
  printf("please input your number: \n");
  scanf("%d",&i);
  while(i!=1){
    printf("%d",i);
    if(i%2 == 0){
      i = i/2;
    }else {
      i = (3*i+1)/2;
    }
    printf(" -> ");
    step++;
  }
  printf("step: %d\n",step);

}
int main(){
  Callatz();
  return 0;
}