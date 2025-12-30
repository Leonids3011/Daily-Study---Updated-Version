#!/bin/bash

# ============================================
# 创建Qt项目完整目录结构脚本
# 适用于 Ubuntu 20.04, Qt 5.12
# ============================================

set -e  # 遇到错误退出

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # 无颜色

echo -e "${BLUE}========================================${NC}"
echo -e "${GREEN}开始创建Qt项目完整目录结构${NC}"
echo -e "${BLUE}========================================${NC}"

# 检查参数
if [ -z "$1" ]; then
    echo -e "${YELLOW}使用方法: $0 <项目名称>${NC}"
    echo -e "${YELLOW}示例: $0 MyQtProject${NC}"
    exit 1
fi

PROJECT_NAME="$1"
echo -e "${GREEN}项目名称: ${PROJECT_NAME}${NC}"

# 检查目录是否已存在
if [ -d "${PROJECT_NAME}" ]; then
    echo -e "${RED}错误: 目录 '${PROJECT_NAME}' 已存在${NC}"
    exit 1
fi

# 创建项目根目录
mkdir -p "${PROJECT_NAME}"
cd "${PROJECT_NAME}"

echo -e "${GREEN}创建主目录结构...${NC}"

# 1. 创建根目录文件
touch CMakeLists.txt
touch CMakePresets.json
touch .gitignore
touch README.md
touch CHANGELOG.md
touch LICENSE

# 2. 创建 src 目录结构
mkdir -p src/core
mkdir -p src/models
mkdir -p src/viewmodels
mkdir -p src/views/widgets
mkdir -p src/views/dialogs
mkdir -p src/views/pages
mkdir -p src/services
mkdir -p src/managers
mkdir -p src/utils
mkdir -p src/network
mkdir -p src/database
mkdir -p src/qml/components
mkdir -p src/qml/pages

# 3. 创建 include 目录结构
mkdir -p include/MyLibrary

# 4. 创建 resources 目录结构
mkdir -p resources/icons/toolbar
mkdir -p resources/icons/status
mkdir -p resources/images/backgrounds
mkdir -p resources/fonts
mkdir -p resources/qss
mkdir -p resources/translations
mkdir -p resources/data/templates

# 5. 创建 tests 目录结构
mkdir -p tests/unit
mkdir -p tests/integration
mkdir -p tests/mocks

# 6. 创建 docs 目录结构
mkdir -p docs/api
mkdir -p docs/design
mkdir -p docs/user
mkdir -p docs/dev

# 7. 创建 scripts 目录结构
mkdir -p scripts/packaging

# 8. 创建 thirdparty 目录结构
mkdir -p thirdparty/catch2
mkdir -p thirdparty/json

# 9. 创建 plugins 目录结构
mkdir -p plugins/plugin1
mkdir -p plugins/plugin2

# 10. 创建 tools 目录结构
mkdir -p tools/designer
mkdir -p tools/codegen

echo -e "${GREEN}目录结构创建完成!${NC}"
echo -e "${BLUE}========================================${NC}"

# 显示项目结构
if command -v tree &> /dev/null; then
    echo -e "${GREEN}项目结构概览:${NC}"
    tree -I '.git' --dirsfirst -L 2
else
    echo -e "${YELLOW}安装 'tree' 命令可以查看完整目录结构${NC}"
    echo -e "${YELLOW}sudo apt-get install tree${NC}"
fi

echo -e "${BLUE}========================================${NC}"
echo -e "${GREEN}下一步:${NC}"
echo -e "1. 运行 create_qt_source_files.sh 生成源文件"
echo -e "2. 编辑 CMakeLists.txt 配置项目"
echo -e "3. 运行 build.sh 构建项目"
echo -e "${BLUE}========================================${NC}"