/**
 * 
 * 题目描述
 * 美国总统奥巴马不仅呼吁所有人都学习编程，甚至亲自编写代码，成为美国历史上首位编写计算机代码的总统。
 * 2014年底，为庆祝“计算机科学教育周”正式启动，奥巴马编写了一个简单的计算机程序--在屏幕上画一个正方形。现在你也跟他“一起”编程吧!

 * 输入格式
 * 在一行中给出正方形边长N(3≤N≤20)和组成正方形边的某种字符，间隔一个空格。

 * 输出格式
 * 由给定字符C画出的正方形。但是注意到行间距比列间距大，所以为了让结果看上去更像正方形，所输出的行数实际上是列数的50%(四舍五入取整)
*/
#include <iostream>

void Squre(){
  int i;char j;
  // 输入数字与符号
  std::cin>> i >> j;

  // 偶数列
  if(i%2==0)
  {
    for(int a=0;a<i;a++){
      printf("%c",j);
    }
    printf("\n");
    for(int a=2;a<i/2;a++){
      
      printf("%c",j);

      for(int b = 0;b<i-2;b++){
        printf(" ");
      }
      printf("%c\n",j);
    }
    for(int a=0;a<i;a++){
      printf("%c",j);
    }
    printf("\n");
  }else{
    for(int a=0;a<i;a++){
      printf("%c",j);
    }
    printf("\n");
    for(int a=2;a<i/2+1;a++){
      printf("%c",j);
      for(int b = 0;b<i-2;b++){
        printf(" ");
      }
      printf("%c\n",j);

    }
    for(int a=0;a<i;a++){
      printf("%c",j);
    }
    printf("\n");
  } 




}


int main(){

  Squre();

  return 0;
}