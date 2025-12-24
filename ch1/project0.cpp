#ifndef _TICKET_MECHINES_HPP_
#define _TICKET_MECHINES_HPP_
#include <iostream>
using namespace std;


class TicketMachine{
public:
   TicketMachine();
   virtual ~TicketMachine();
   void showPrompt();
   void insertMoney(int money);
   void showBalance();
   void printTicket();
   void showTotal();
   void showError();
private:
   // 要赋予初始值
   const int PRICE;
   int balance;
   int total;

};
// :: 叫做阈的解析符
/*
 * ::resolver
 *
 * <Class Name>::<function name>
 *
 * ::<function name>
 * 存在范围阈表明f是S里面的一个函数
 *
 * 前面没有名称的范围阈就是全局变量或者函数
 * 
 * 不加范围阈就是类里的一个变量
 * void S::f(){
 *    ::f(); // Would be recursive otherwise!
 *    ::a++; // Selece the global a
 *    a--;   // The a at class scope
 * }
 *
 * */
TicketMachine::TicketMachine()
	:PRICE(0),
// balance必须要初始化，否则会赋给任意值
	balance(0),
	total(0)
{

}
	
TicketMachine::~TicketMachine(){

}

void
TicketMachine::showPrompt(){
   cout<<"something"<<"\n";
}

void
TicketMachine::insertMoney(int money){
   balance += money;
}

void
TicketMachine::showBalance()
{
   cout<< balance <<"\n";
}

int main(){

	TicketMachine tic;
	tic.showPrompt();
	tic.insertMoney(100);
	tic.showBalance();
	return 0;
}

#endif //_TICKET_MECHINENS_HPP_
