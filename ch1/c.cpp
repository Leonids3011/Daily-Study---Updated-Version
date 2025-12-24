#include<iostream>
using namespace std;

// extern int gl;


class A{

public:
    // 有一个i，完全自由的使用i，不需要考虑i在哪里。
    int i;
    A();
    void f();
};

struct B{
    int i;
};

// f()不是B的成员，两个f()里面做得是一样的
void f(struct B* p)
{  
   p->i =20;
}

A::A(){

   this->i = 0;
   printf("A::A()--this=%p\n",this);
}


void A::f(){
    // i = 20;
    this->i = 20;
    printf("A::f()--&i=%p\n",&i);
    printf("this=%p\n",this);
    printf("-------------------\n");
}

int main(){
 
   // i实际上不存在，类不是实体，所以i存在对象中。对象存在，i就存在
   A a;
   A aa;
   B b;
   a.i = 10;
   printf("&a=%p\n",&a);
   printf("&a.i=%p\n",&(a.i));
   // f属于类，并不属于哪个对象
   // a这个对象做成员函数f()的动作
   a.f();
   aa.i =100;
   printf("&aa=%p\n",&aa);
   printf("&aa.i=%p\n",&(aa.i));
   
   aa.f();
   // f对b做一些事情
   f(&b);
}
