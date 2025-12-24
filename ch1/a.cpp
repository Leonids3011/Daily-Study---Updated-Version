#if 0
#include"a.h"
#include"b.h"
/**
 * // 类是声明，所以成员变量也是声明
 * class A{
 *   private:
 *   	// 这里也是声明，有这样一个i，并不是i在这里
 *   	int i；
 *   public:
 *   	void f();
 * };
 *
 */
void A::f(){
    // 本地变量只在f内有效
    int j = 10;
    // 成员变量在所有成员函数使用
    i = 10
}

int main(){
     A a;
     // i在这里的a有效，成员变量不在类里，在每一个类的对象里
     a.f();
     // 表明对象存在，成员变量就存在
     A b;
     b.f();

     return 0;
}
#endif

#ifndef _MAIN_CPP_
#define _MAIN_CPP_

#include <iostream>


using namespace std;


int main(){

    cout<<"很好,现在你已经会C++了，现在开始尝试精通它吧(doge)"<<endl;

    return 0;
}

#endif //_MAIN_CPP_
