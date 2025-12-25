# CMakeLists.txt
cmake_minimum_required(VERSION 3.10)
project(WeatherApp VERSION 1.0.0 LANGUAGES CXX)

# 设置C++标准
set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

# 查找Qt5库
find_package(Qt5 COMPONENTS Core Widgets Network REQUIRED)

# 设置源文件和头文件
set(SOURCES
    src/main.cpp
    src/core/WeatherData.cpp
    src/models/CityModel.cpp
    src/services/WeatherService.cpp
    src/ui/MainWindow.cpp
    src/ui/WeatherWidget.cpp
)

set(HEADERS
    src/core/WeatherData.h
    src/models/CityModel.h
    src/services/WeatherService.h
    src/ui/MainWindow.h
    src/ui/WeatherWidget.h
)

# 添加可执行文件
add_executable(WeatherApp ${SOURCES} ${HEADERS})

# 链接Qt库
target_link_libraries(WeatherApp
    Qt5::Core
    Qt5::Widgets
    Qt5::Network
)

# 包含目录
target_include_directories(WeatherApp PRIVATE src)

# 安装目标（可选）
install(TARGETS WeatherApp DESTINATION bin)