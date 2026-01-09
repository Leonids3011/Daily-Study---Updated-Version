#!/bin/bash

# ============================================
# 快速创建Qt项目完整架构脚本
# 自动创建项目结构、生成源文件并编译
# ============================================

set -e  # 遇到错误退出

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # 无颜色

# 获取脚本所在目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo -e "${CYAN}════════════════════════════════════════════════${NC}"
echo -e "${GREEN}        Qt项目快速创建工具 v2.0${NC}"
echo -e "${CYAN}════════════════════════════════════════════════${NC}"

# 检查参数
if [ -z "$1" ]; then
    echo -e "${YELLOW}使用方法: $0 <项目名称> [构建类型]${NC}"
    echo -e "${YELLOW}示例: $0 MyQtProject debug${NC}"
    echo -e "${YELLOW}示例: $0 MyQtProject release${NC}"
    echo -e "${YELLOW}构建类型: debug (默认) 或 release${NC}"
    exit 1
fi

PROJECT_NAME="$1"
BUILD_TYPE="${2:-debug}"  # 默认为debug
BUILD_TYPE_LOWER=$(echo "$BUILD_TYPE" | tr '[:upper:]' '[:lower:]')

# 验证构建类型
if [ "$BUILD_TYPE_LOWER" != "debug" ] && [ "$BUILD_TYPE_LOWER" != "release" ]; then
    echo -e "${RED}错误: 构建类型必须是 'debug' 或 'release'${NC}"
    exit 1
fi

echo -e "${GREEN}项目名称: ${PROJECT_NAME}${NC}"
echo -e "${GREEN}构建类型: ${BUILD_TYPE_LOWER}${NC}"
echo -e "${GREEN}脚本目录: ${SCRIPT_DIR}${NC}"

# 检查子脚本是否存在
if [ ! -f "${SCRIPT_DIR}/create_qt_architecture.sh" ]; then
    echo -e "${RED}错误: 找不到架构创建脚本: create_qt_architecture.sh${NC}"
    exit 1
fi

if [ ! -f "${SCRIPT_DIR}/create_qt_source_files.sh" ]; then
    echo -e "${RED}错误: 找不到源文件创建脚本: create_qt_source_files.sh${NC}"
    exit 1
fi

# 检查目标目录是否已存在
if [ -d "${PROJECT_NAME}" ]; then
    echo -e "${YELLOW}警告: 目录 '${PROJECT_NAME}' 已存在${NC}"
    
    # 询问是否覆盖
    read -p "是否覆盖现有目录? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${YELLOW}操作已取消${NC}"
        exit 0
    fi
    
    # 备份现有目录
    BACKUP_DIR="${PROJECT_NAME}_backup_$(date +%Y%m%d_%H%M%S)"
    echo -e "${YELLOW}备份现有目录到: ${BACKUP_DIR}${NC}"
    mv "${PROJECT_NAME}" "${BACKUP_DIR}"
fi

echo -e "${BLUE}════════════════════════════════════════════════${NC}"
echo -e "${CYAN}阶段 1: 创建项目目录结构${NC}"
echo -e "${BLUE}════════════════════════════════════════════════${NC}"

# 步骤1: 创建项目目录结构
"${SCRIPT_DIR}/create_qt_architecture.sh" "${PROJECT_NAME}"

# 检查是否创建成功
if [ ! -d "${PROJECT_NAME}" ]; then
    echo -e "${RED}错误: 项目目录创建失败${NC}"
    exit 1
fi

cd "${PROJECT_NAME}"

echo -e "${BLUE}════════════════════════════════════════════════${NC}"
echo -e "${CYAN}阶段 2: 生成项目源文件${NC}"
echo -e "${BLUE}════════════════════════════════════════════════${NC}"

# 步骤2: 生成源文件
"${SCRIPT_DIR}/create_qt_source_files.sh"

# 检查源文件是否生成
if [ ! -f "src/main.cpp" ]; then
    echo -e "${RED}错误: 源文件生成失败${NC}"
    exit 1
fi

# 创建简单的构建脚本
cat > scripts/build.sh << 'EOF'
#!/bin/bash

# ============================================
# Qt项目构建脚本 (Ubuntu 20.04, Qt 5.12)
# ============================================

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}========================================${NC}"
echo -e "${GREEN}    Qt项目构建脚本${NC}"
echo -e "${BLUE}    Ubuntu 20.04 | Qt 5.12${NC}"
echo -e "${BLUE}========================================${NC}"

# 检查是否在项目根目录
if [ ! -f "CMakeLists.txt" ]; then
    echo -e "${RED}错误: 请在项目根目录运行此脚本${NC}"
    exit 1
fi

# 设置构建类型
BUILD_TYPE="Debug"
if [ "$1" = "release" ] || [ "$1" = "Release" ]; then
    BUILD_TYPE="Release"
elif [ "$1" = "debug" ] || [ "$1" = "Debug" ]; then
    BUILD_TYPE="Debug"
fi

# 创建构建目录
BUILD_DIR="build-${BUILD_TYPE}"
echo -e "${YELLOW}构建类型: ${BUILD_TYPE}${NC}"
echo -e "${YELLOW}构建目录: ${BUILD_DIR}${NC}"

mkdir -p "${BUILD_DIR}"
cd "${BUILD_DIR}"

# 配置CMake
echo -e "${GREEN}配置CMake...${NC}"
cmake .. \
    -DCMAKE_BUILD_TYPE=${BUILD_TYPE} \
    -DCMAKE_CXX_COMPILER=g++ \
    -DCMAKE_C_COMPILER=gcc \
    -DCMAKE_CXX_FLAGS="-Wall -Wextra -Wpedantic -std=c++17"

# 检查配置结果
if [ $? -ne 0 ]; then
    echo -e "${RED}CMake配置失败${NC}"
    exit 1
fi

# 获取CPU核心数
CPU_CORES=$(nproc)
echo -e "${GREEN}使用 ${CPU_CORES} 个核心编译...${NC}"

# 编译项目
make -j${CPU_CORES}

# 检查编译结果
if [ $? -eq 0 ]; then
    echo -e "${GREEN}构建成功!${NC}"
    
    # 显示可执行文件信息
    PROJECT_NAME=$(grep -oP 'project\(\K[^ )]+' ../CMakeLists.txt | head -1)
    EXECUTABLE="./bin/${PROJECT_NAME}"
    if [ -f "${EXECUTABLE}" ]; then
        echo -e "${YELLOW}可执行文件: ${EXECUTABLE}${NC}"
        echo -e "${YELLOW}文件大小: $(du -h ${EXECUTABLE} | cut -f1)${NC}"
    fi
else
    echo -e "${RED}构建失败${NC}"
    exit 1
fi

echo -e "${BLUE}========================================${NC}"
EOF

chmod +x scripts/build.sh

echo -e "${BLUE}════════════════════════════════════════════════${NC}"
echo -e "${CYAN}阶段 3: 构建项目${NC}"
echo -e "${BLUE}════════════════════════════════════════════════${NC}"

# 检查Qt是否安装
if ! command -v qmake &> /dev/null; then
    echo -e "${YELLOW}警告: 未找到qmake命令${NC}"
    echo -e "${YELLOW}请确保Qt5已正确安装: sudo apt-get install qt5-default${NC}"
fi

# 检查CMake是否安装
if ! command -v cmake &> /dev/null; then
    echo -e "${RED}错误: 未找到cmake命令${NC}"
    echo -e "${YELLOW}请安装CMake: sudo apt-get install cmake${NC}"
    exit 1
fi

# 构建项目
echo -e "${CYAN}开始构建项目...${NC}"
./scripts/build.sh "${BUILD_TYPE_LOWER}"

# 检查构建是否成功
BUILD_DIR="build-${BUILD_TYPE_LOWER}"
PROJECT_NAME=$(grep -oP 'project\(\K[^ )]+' CMakeLists.txt | head -1)

echo -e "${BLUE}════════════════════════════════════════════════${NC}"
echo -e "${GREEN}项目创建完成!${NC}"
echo -e "${BLUE}════════════════════════════════════════════════${NC}"

# 显示完成信息
echo -e "${CYAN}▸ 项目名称: ${PROJECT_NAME}${NC}"
echo -e "${CYAN}▸ 项目目录: $(pwd)${NC}"
echo -e "${CYAN}▸ 构建类型: ${BUILD_TYPE_LOWER}${NC}"
echo -e "${CYAN}▸ 构建目录: ${BUILD_DIR}${NC}"

if [ -f "${BUILD_DIR}/bin/${PROJECT_NAME}" ]; then
    echo -e "${CYAN}▸ 可执行文件: ${BUILD_DIR}/bin/${PROJECT_NAME}${NC}"
    echo -e ""
    echo -e "${GREEN}运行项目:${NC}"
    echo -e "  ./${BUILD_DIR}/bin/${PROJECT_NAME}"
fi

echo -e ""
echo -e "${GREEN}项目结构:${NC}"
echo -e "  📁 src/ - 源代码"
echo -e "  📁 resources/ - 资源文件"
echo -e "  📁 tests/ - 测试代码"
echo -e "  📁 scripts/ - 构建脚本"
echo -e ""
echo -e "${GREEN}常用命令:${NC}"
echo -e "  ./scripts/build.sh debug    # 调试构建"
echo -e "  ./scripts/build.sh release  # 发布构建"
echo -e "  ./${BUILD_DIR}/bin/${PROJECT_NAME}  # 运行程序"
echo -e "${BLUE}════════════════════════════════════════════════${NC}"
echo -e "${GREEN}✨ 项目创建成功! 开始你的Qt开发之旅吧! ✨${NC}"
echo -e "${BLUE}════════════════════════════════════════════════${NC}"