#include <flann/flann.hpp>
#include <iostream>
#include <stdio.h>
#include <vector>
#include <flann/util/matrix.h>
using namespace std;

struct MyPoint
{
    MyPoint(double x , double y , double z)
    {
        this->x = x ;
        this->y = y ;
        this->z = z ;
    }
    double x , y , z;
};


 // 创建数据集
    std::vector<float> dataset = {1.0, 2.0, 3.0, 4.0, 5.0, 6.0};

int main()
{
    vector<MyPoint> points ;
    points.push_back(MyPoint(0 , 0 , 0)) ;
    points.push_back(MyPoint(1 , 1 , 1)) ;
    points.push_back(MyPoint(2 , 2 , 2)) ;
    points.push_back(MyPoint(3 , 3 , 3)) ;
    flann::Matrix<float> data_mat = flann::Matrix<float>(&dataset[0],2,3) ;

    flann::Matrix<double> points_mat = flann::Matrix<double>(&points[0].x,2,2) ;
for(int i=0;i<12;i++)
{
	for(int j=0;j<12;j++){
   	 cout<<points_mat[i][j]<<"\t" ;
   }
cout<<endl;
}
    return 1 ;
}

