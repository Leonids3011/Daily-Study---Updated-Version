/**
 * [codeup 1928]日期差值
 * 题目描述
 * 有两个日期，求两个日期之间的天数，如果两个日期是连续的，则规定它们之间的天数为两天。
 * 
 * 输入格式
 * 有多组数据，每组数据有两行，分别表示两个日期，形式为YYYYMMDD。
 * 输出格式
 * 每组数据输出一行，即日期差值。
 * 
 * 样例输入
 * 20130101
 * 20130105
 * 样例输出
 * 5
 */
#include<iostream>
#include<string>
#include<algorithm>

class DateDifference
{
private:
  // 平年闰年枚举
  // 第一维度表示平年，第二维度表示闰年
  int date[13][2] = {
    {0,0},
    // 1,2,3
    {31,31},{28,29},{31,31},
    // 4,5,6
    {30,30},{31,31},{30,30},
    // 7,8,9
    {31,31},{31,31},{30,30},
    // 10,11,12
    {31,31},{30,30},{31,31}
  };
  // 日期输入
  int num1_={},num2_={};
  // 日期相差
  int day_diff_= {};
  // 核心计算
  void Calculation();

  bool leapyear(const int &year);
  public:
  DateDifference();
  ~DateDifference();

  void SetDate(int d1,int d2){
    num1_ = d1;
    num2_ = d2;
  }

  // 运行
  void Run(){
    Calculation();
  };

public:

};

DateDifference::DateDifference()
{
  std::cout<<"Start..."<<std::endl;
}

DateDifference::~DateDifference()
{
  std::cout<<"Ending...."<<std::endl;
}
void DateDifference::Calculation(){

  // 比较输入的两个数的大小(默认num2_大)
  if(num1_> num2_){
    printf("numbers are :[%d]<->[%d]\n",num1_,num2_);
    int temp = 0;
    temp = num1_;
    num1_ = num2_;
    num2_ = temp;

    printf("smaller num1_,swap numbers:[%d]<->[%d]\n",num1_,num2_);
  }

  // 计算年月日；
  int year1,year2,month1,month2,day1,day2;
  year1 = num1_/10000;
  month1 = (num1_ % 10000)/100;
  day1 = num1_ % 100;

  year2 = num2_/10000;
  month2 = (num2_ % 10000)/100;
  day2 = num2_ % 100;

  printf("[%d %d %d];;;;;[%d %d %d]\n",year1,month1,day1,year2,month2,day2);
  // 判断两个年份的平闰年
  leapyear(year1);
  leapyear(year2);

  int num = num1_;
  // 开始计算，直至num1_递增到与num_2相同
  if(num != num2_){
    day1++;
    // 闰年
    if(day1==date[month2][leapyear(year2)]+1){
      month1++;
      day1 = 1;
    }
    if(month1==13){
      year1++;
      month1 = 1;

    }
    day_diff_++;

  }
  printf("out number is: %d \n", day_diff_);
}

bool DateDifference::leapyear(const int &year){

  if(year%4 == 0&&year%100 != 0&&year%3323 !=0||year%400==0){
    printf("[%d] year is leap year;\n",year);
    return true;

  }else{
    printf("[%d] year isn't leap year;\n",year);
    return false;
  }
}


int main(int argc,char *argv[]){

  DateDifference date;

  // 题目可以改成可配置的
  int n1 = 20130724;
  int n2 = 20140105;

  date.SetDate(n1,n2);
  date.Run();
  return 0;
}