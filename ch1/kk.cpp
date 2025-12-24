#include <iostream>
#include <vector>
#include <Eigen/Dense>
#include <pcl/point_cloud.h>
#include <pcl/point_types.h>
#include <pcl/kdtree/kdtree_flann.h>

// 使用Eigen库进行向量和矩阵运算

// 计算两条平行线的方向向量和垂直向量
Eigen::Vector3d computePerpendicularLine(const Eigen::Vector3d& p1, const Eigen::Vector3d& p2, const Eigen::Vector3d& q1, const Eigen::Vector3d& q2) {
    Eigen::Vector3d direction1 = p2 - p1;
    Eigen::Vector3d direction2 = q2 - q1;

    // 计算叉积得到垂直于两条平行线的向量
    Eigen::Vector3d perpendicularDirection = direction1.cross(direction2);
    return perpendicularDirection.normalized();  // 单位向量
}

// 计算距离两条平行线相等的点
Eigen::Vector3d findEquidistantPoint(const Eigen::Vector3d& p1, const Eigen::Vector3d& p2, const Eigen::Vector3d& q1, const Eigen::Vector3d& q2) {
    Eigen::Vector3d middle1 = (p1 + p2) / 2;
    Eigen::Vector3d middle2 = (q1 + q2) / 2;

    // 计算两条线的中点，并假设相等点是它们的中点
    return (middle1 + middle2) / 2;
}

// PCL的KD树查询示例
void performKdTreeSearch(pcl::PointCloud<pcl::PointXYZ>::Ptr cloud, const Eigen::Vector3d& query_point) {
    pcl::KdTreeFLANN<pcl::PointXYZ> kdtree;
    kdtree.setInputCloud(cloud);

    std::vector<int> point_indices;
    std::vector<float> point_distances;
    double radius = 1.0;  // 正方体边长的一半

    // KD树范围搜索
    pcl::PointXYZ search_point;
    search_point.x = query_point.x();
    search_point.y = query_point.y();
    search_point.z = query_point.z();

    // 使用KD树进行正方体范围搜索
    if (kdtree.radiusSearch(search_point, radius, point_indices, point_distances) > 0) {
        std::cout << "Found " << point_indices.size() << " points within the radius search." << std::endl;
    }
}

int main() {
    // 设定两条平行线上的点
    Eigen::Vector3d p1(0, 0, 0), p2(1, 0, 0);  // 第一条平行线
    Eigen::Vector3d q1(0, 1, 0), q2(1, 1, 0);  // 第二条平行线

    // 计算垂直于这两条平行线的直线
    Eigen::Vector3d perpendicularLine = computePerpendicularLine(p1, p2, q1, q2);
    std::cout << "Perpendicular vector: " << perpendicularLine.transpose() << std::endl;

    // 找到两条平行线距离相等的点
    Eigen::Vector3d equidistantPoint = findEquidistantPoint(p1, p2, q1, q2);
    std::cout << "Equidistant point: " << equidistantPoint.transpose() << std::endl;

    // 示例：构建点云并进行KD树搜索
    pcl::PointCloud<pcl::PointXYZ>::Ptr cloud(new pcl::PointCloud<pcl::PointXYZ>);
    cloud->push_back(pcl::PointXYZ(0, 0, 0));
    cloud->push_back(pcl::PointXYZ(1, 0, 0));
    cloud->push_back(pcl::PointXYZ(0, 1, 0));
    cloud->push_back(pcl::PointXYZ(1, 1, 0));

    // 执行KD树搜索
    performKdTreeSearch(cloud, equidistantPoint);

    return 0;
}

