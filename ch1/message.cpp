#include<iostream>
#include<string>
using namespace std;
class Student{
private:
	string name;
	int age;

public:
	Student(string studentName,int studentAge){
	name = studentName;
	age = studentAge;
}
//访问器函数（getter）
string getName(){
		return name;
}
int getAge(){
	return age;
}
// 修改器函数（setter）
void setName(string studentName){
	name = studentName;
}
void setAge(int studentAge){
	if(studentAge>0){
	age = studentAge;
}else{
	std::cout<<"Error Ages"<<std::endl;
}
}
void printfStudentMessage(){
	cout<<"name: "<<name<<"\n"<<"age: "<<age<<endl;
}
};
int main(int argc,char *argv[]){
	// 创建一个Student对象
	Student student1("Alices",20);
	// 访问和修改数据
	student1.printfStudentMessage();
	student1.setName("Box");
	student1.setAge(30);
	student1.printfStudentMessage();

	return 0;
}

