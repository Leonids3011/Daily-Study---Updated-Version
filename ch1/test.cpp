//在一行中给出正方形长N（3<N<20）和组成正方形边的某种字符C，间隔一个空格
#include<cstdio>
int main(){

    int row,col;
    char c;
    scanf("%d %c",&col,&c);
    if(col % 2 == 1) row = col/2+1;
    else row = col/2;
    for(int i = 0; i < col;i++){
       printf("%c",c);
    }
    printf("\n");
    for(int i = 2;i<row;i++){
       printf("%c",c);
       for(int j =0;j<col-2;j++){
          printf(" ");
       }
       printf("%c\n",c);
    }
    for(int i = 0;i<col;i++){
    	printf("%c",c);
    }
    return 0;

}
