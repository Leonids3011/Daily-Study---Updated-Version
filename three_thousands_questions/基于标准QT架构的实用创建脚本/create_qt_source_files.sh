#!/bin/bash

# ============================================
# 创建Qt项目空实现文件脚本
# 适用于 Ubuntu 20.04, Qt 5.12
# 生成完整的项目骨架
# ============================================

set -e  # 遇到错误退出

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m' # 无颜色

# 打印带颜色的消息函数
print_msg() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

echo -e "${CYAN}========================================${NC}"
echo -e "${MAGENTA}     Qt项目空实现文件生成器${NC}"
echo -e "${CYAN}     Ubuntu 20.04 | Qt 5.12${NC}"
echo -e "${CYAN}========================================${NC}"

# 检查是否在项目目录中
if [ ! -d "src" ] && [ -z "$1" ]; then
    echo -e "${YELLOW}请确保在项目根目录中运行此脚本${NC}"
    echo -e "${YELLOW}或者指定项目目录: $0 <项目目录>${NC}"
    exit 1
fi

# 如果提供了目录参数，切换到该目录
if [ -n "$1" ]; then
    if [ ! -d "$1" ]; then
        mkdir -p "$1"
        print_msg "创建项目目录: $1"
    fi
    cd "$1"
fi

# 获取项目名称
if [ -f "CMakeLists.txt" ]; then
    PROJECT_NAME=$(grep -oP 'project\(\K[^ )]+' CMakeLists.txt | head -1)
fi

if [ -z "$PROJECT_NAME" ]; then
    PROJECT_NAME=$(basename "$(pwd)")
    print_warning "未找到项目名称，使用目录名: $PROJECT_NAME"
fi

print_msg "项目名称: $PROJECT_NAME"
print_msg "工作目录: $(pwd)"

# ============================================
# 函数定义：创建目录结构
# ============================================

create_directories() {
    print_msg "创建目录结构..."
    
    # 主要源代码目录
    local src_dirs=(
        "src/core"
        "src/models"
        "src/viewmodels"
        "src/views/widgets"
        "src/views/dialogs"
        "src/views/pages"
        "src/services"
        "src/managers"
        "src/utils"
        "src/network"
        "src/database"
        "src/qml/components"
        "src/qml/pages"
    )
    
    # 资源目录
    local res_dirs=(
        "resources/icons"
        "resources/icons/toolbar"
        "resources/icons/status"
        "resources/images"
        "resources/images/backgrounds"
        "resources/fonts"
        "resources/qss"
        "resources/translations"
        "resources/data"
        "resources/data/templates"
    )
    
    # 测试目录
    local test_dirs=(
        "tests/unit"
        "tests/integration"
        "tests/mocks"
    )
    
    # 文档目录
    local doc_dirs=(
        "docs/api"
        "docs/design"
        "docs/user"
        "docs/dev"
    )
    
    # 工具和第三方目录
    local other_dirs=(
        "include/MyLibrary"
        "scripts/packaging"
        "thirdparty/catch2"
        "thirdparty/json"
        "plugins/plugin1"
        "plugins/plugin2"
        "tools/designer"
        "tools/codegen"
    )
    
    # 创建所有目录
    for dir in "${src_dirs[@]}" "${res_dirs[@]}" "${test_dirs[@]}" "${doc_dirs[@]}" "${other_dirs[@]}"; do
        if [ ! -d "$dir" ]; then
            mkdir -p "$dir"
            print_msg "创建目录: $dir"
        fi
    done
}

# ============================================
# 主脚本开始
# ============================================

# 1. 创建目录结构
create_directories

# 2. 创建根目录文件
print_msg "创建根目录文件..."

# .gitignore
cat > .gitignore << 'EOF'
# 构建目录
build/
build-*/
*.build/
*.user
*.pro.user
*.autosave

# 编译生成文件
*.o
*.obj
*.exe
*.app
*.so
*.dll
*.a
*.lib

# Qt Creator
*.pro.user
*.pro.user.*

# CMake
CMakeCache.txt
CMakeFiles/
cmake_install.cmake
Makefile
install_manifest.txt
compile_commands.json

# Qt
moc_*.cpp
ui_*.h
qrc_*.cpp
*.moc

# 临时文件
*~
*.bak
*.swp
*.swo

# IDE
.vscode/
.idea/
*.sublime-*

# 文档生成
docs/html/
docs/latex/

# 日志文件
*.log
*.log.*

# 系统文件
.DS_Store
Thumbs.db
EOF

# README.md
cat > README.md << EOF
# ${PROJECT_NAME}

一个基于 Qt 5.12 的跨平台应用程序。

## 特性

- 模块化架构设计
- 支持 MVVM 模式
- 插件化系统
- 多语言国际化支持
- 主题切换功能
- 完整的日志系统
- 单元测试框架

## 系统要求

- **操作系统**: Ubuntu 20.04 LTS 或更高版本
- **Qt 版本**: 5.12.x
- **CMake**: 3.16 或更高版本
- **编译器**: GCC 7.5+ / Clang 6.0+
- **C++标准**: C++17

## 构建步骤

### 使用脚本构建
\`\`\`bash
# 调试版本
./scripts/build.sh debug

# 发布版本
./scripts/build.sh release
\`\`\`

### 手动构建
\`\`\`bash
mkdir build && cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
make -j\$(nproc)
\`\`\`

## 运行测试
\`\`\`bash
cd build
ctest --output-on-failure
\`\`\`

## 许可证

本项目采用 MIT 许可证 - 详见 [LICENSE](LICENSE) 文件。
EOF
print_success "创建 README.md"

# CHANGELOG.md
cat > CHANGELOG.md << EOF
# 更新日志

本项目遵循 [语义化版本](https://semver.org/lang/zh-CN/)。

## [1.0.0] - $(date +%Y-%m-%d)

### 新增
- 初始项目创建
- 完整的项目骨架
- CMake 构建系统
- 基础模块结构
- 示例代码和资源

### 变更
- 无

### 修复
- 无
EOF
print_success "创建 CHANGELOG.md"

# LICENSE
cat > LICENSE << EOF
MIT License

Copyright (c) $(date +%Y) ${PROJECT_NAME} Contributors

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
EOF

# 3. 创建CMake配置文件
print_msg "创建CMake配置文件..."

# CMakeLists.txt
cat > CMakeLists.txt << EOF
cmake_minimum_required(VERSION 3.16)
project(${PROJECT_NAME} VERSION 1.0.0 LANGUAGES CXX)

# 设置C++标准
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# 自动处理Qt的moc、uic、rcc
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTORCC ON)

# 设置输出目录
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY \${CMAKE_BINARY_DIR}/bin)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY \${CMAKE_BINARY_DIR}/lib)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY \${CMAKE_BINARY_DIR}/lib)

# 查找Qt5组件
find_package(Qt5 5.12 REQUIRED COMPONENTS
    Core
    Widgets
    Gui
    Network
    Sql
    Concurrent
    Test
)

# 包含目录
include_directories(
    \${CMAKE_CURRENT_SOURCE_DIR}/src
    \${CMAKE_CURRENT_SOURCE_DIR}/include
    \${CMAKE_CURRENT_BINARY_DIR}/src
)

# 源文件列表
set(SOURCES
    src/main.cpp
    src/core/Application.cpp
    src/core/MainWindow.cpp
    src/core/AppConfig.cpp
    src/core/AppTheme.cpp
    src/models/BaseModel.cpp
    src/models/DataItem.cpp
    src/models/ListModel.cpp
    src/viewmodels/BaseViewModel.cpp
    src/viewmodels/MainViewModel.cpp
    src/views/widgets/CustomButton.cpp
    src/views/widgets/IconButton.cpp
    src/views/widgets/StatusBar.cpp
    src/views/dialogs/BaseDialog.cpp
    src/views/dialogs/SettingsDialog.cpp
    src/views/dialogs/AboutDialog.cpp
    src/views/pages/HomePage.cpp
    src/views/pages/SettingsPage.cpp
    src/views/pages/HelpPage.cpp
    src/services/DatabaseService.cpp
    src/services/NetworkService.cpp
    src/services/FileService.cpp
    src/services/LogService.cpp
    src/managers/ResourceManager.cpp
    src/managers/TaskManager.cpp
    src/managers/PluginManager.cpp
    src/managers/EventManager.cpp
    src/utils/Logger.cpp
    src/utils/Validator.cpp
    src/utils/Formatter.cpp
    src/utils/FileUtils.cpp
    src/utils/StringUtils.cpp
    src/network/ApiClient.cpp
    src/network/WebSocketClient.cpp
    src/network/RestApi.cpp
    src/database/DatabaseConnection.cpp
    src/database/SqlQueryBuilder.cpp
    src/database/Migrations.cpp
)

# 头文件列表
set(HEADERS
    src/core/Application.h
    src/core/MainWindow.h
    src/core/AppConfig.h
    src/core/AppTheme.h
    src/models/BaseModel.h
    src/models/DataItem.h
    src/models/ListModel.h
    src/viewmodels/BaseViewModel.h
    src/viewmodels/MainViewModel.h
    src/views/widgets/CustomButton.h
    src/views/widgets/IconButton.h
    src/views/widgets/StatusBar.h
    src/views/dialogs/BaseDialog.h
    src/views/dialogs/SettingsDialog.h
    src/views/dialogs/AboutDialog.h
    src/views/pages/HomePage.h
    src/views/pages/SettingsPage.h
    src/views/pages/HelpPage.h
    src/services/DatabaseService.h
    src/services/NetworkService.h
    src/services/FileService.h
    src/services/LogService.h
    src/managers/ResourceManager.h
    src/managers/TaskManager.h
    src/managers/PluginManager.h
    src/managers/EventManager.h
    src/utils/Logger.h
    src/utils/Validator.h
    src/utils/Formatter.h
    src/utils/FileUtils.h
    src/utils/StringUtils.h
    src/network/ApiClient.h
    src/network/WebSocketClient.h
    src/network/RestApi.h
    src/database/DatabaseConnection.h
    src/database/SqlQueryBuilder.h
    src/database/Migrations.h
)

# UI文件列表（如果有的话）
set(UI_FILES
    # src/views/ui/MainWindow.ui
    # src/views/ui/SettingsDialog.ui
    # src/views/ui/AboutDialog.ui
)

# 资源文件
set(RESOURCES
    resources/resources.qrc
)

# 添加可执行文件
add_executable(\${PROJECT_NAME}
    \${SOURCES}
    \${HEADERS}
    \${UI_FILES}
    \${RESOURCES}
)

# 链接Qt库
target_link_libraries(\${PROJECT_NAME}
    Qt5::Core
    Qt5::Widgets
    Qt5::Gui
    Qt5::Network
    Qt5::Sql
    Qt5::Concurrent
)

# 设置目标属性
set_target_properties(\${PROJECT_NAME} PROPERTIES
    CXX_STANDARD 17
    CXX_STANDARD_REQUIRED ON
    CXX_EXTENSIONS OFF
    WIN32_EXECUTABLE TRUE
    MACOSX_BUNDLE TRUE
)

# 安装目标
install(TARGETS \${PROJECT_NAME}
    RUNTIME DESTINATION bin
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib
)

# 安装资源文件
install(DIRECTORY resources/ DESTINATION share/\${PROJECT_NAME}/resources)

# 包含测试目录
if(EXISTS \${CMAKE_CURRENT_SOURCE_DIR}/tests/CMakeLists.txt)
    enable_testing()
    add_subdirectory(tests)
endif()
EOF

# 4. 创建源代码文件
print_msg "创建源代码文件..."

# 4.1 创建main.cpp - 修复Application类引用错误
cat > src/main.cpp << 'EOF'
#include "core/Application.h"
#include "core/MainWindow.h"
#include <QApplication>
#include <QStyleFactory>
#include <QDebug>

int main(int argc, char *argv[])
{
    // 启用高DPI支持
    QApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QApplication::setAttribute(Qt::AA_UseHighDpiPixmaps);
    
    QApplication app(argc, argv);
    
    // 设置应用程序信息
    app.setApplicationName("MyQtApplication");
    app.setOrganizationName("MyCompany");
    app.setOrganizationDomain("mycompany.com");
    app.setApplicationVersion("1.0.0");
    
    // 设置应用程序样式
    app.setStyle(QStyleFactory::create("Fusion"));
    
    // 创建并显示主窗口
    MainWindow mainWindow;
    mainWindow.show();
    
    return app.exec();
}
EOF
print_success "创建 src/main.cpp"

# 4.2 创建core模块文件
print_msg "创建core模块文件..."

# Application.h - 修复缺少的包含
cat > src/core/Application.h << 'EOF'
#ifndef APPLICATION_H
#define APPLICATION_H

#include <QApplication>
#include <QString>

class Application : public QApplication
{
    Q_OBJECT
    
public:
    Application(int &argc, char **argv);
    
    static Application* instance();
    
    QString configPath() const;
    QString dataPath() const;
    QString cachePath() const;
};

#endif // APPLICATION_H
EOF

# 创建 Application.cpp
cat > src/core/Application.cpp << 'EOF'
#include "Application.h"
#include <QStandardPaths>
#include <QDir>
#include <QDebug>

Application::Application(int &argc, char **argv)
    : QApplication(argc, argv)
{
    qDebug() << "应用程序实例已创建";
}

Application* Application::instance()
{
    return qobject_cast<Application*>(QCoreApplication::instance());
}

QString Application::configPath() const
{
    return QStandardPaths::writableLocation(QStandardPaths::AppConfigLocation);
}

QString Application::dataPath() const
{
    return QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
}

QString Application::cachePath() const
{
    return QStandardPaths::writableLocation(QStandardPaths::CacheLocation);
}
EOF

# MainWindow.h - 修复缺少的包含和声明
cat > src/core/MainWindow.h << 'EOF'
#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QScopedPointer>

QT_BEGIN_NAMESPACE
class QMenu;
class QToolBar;
class QStatusBar;
class QTabWidget;
class QAction;
class QCloseEvent;
class QShowEvent;
QT_END_NAMESPACE

class MainWindowPrivate;

class MainWindow : public QMainWindow
{
    Q_OBJECT
    
public:
    explicit MainWindow(QWidget *parent = nullptr);
    virtual ~MainWindow();
    
public slots:
    void showSettingsDialog();
    void showAboutDialog();
    void updateStatusBar(const QString& message);
    
protected:
    void closeEvent(QCloseEvent *event) override;
    void showEvent(QShowEvent *event) override;
    
private slots:
    void createFileMenu();
    void createEditMenu();
    void createViewMenu();
    void createHelpMenu();
    void createToolBars();
    void createStatusBar();
    void createCentralWidget();
    
private:
    QScopedPointer<MainWindowPrivate> d_ptr;
    Q_DECLARE_PRIVATE(MainWindow)
};

#endif // MAINWINDOW_H
EOF

# MainWindow.cpp - 修复包含和语法错误
cat > src/core/MainWindow.cpp << 'EOF'
#include "MainWindow.h"
#include "views/dialogs/SettingsDialog.h"
#include "views/dialogs/AboutDialog.h"
#include "views/widgets/StatusBar.h"
#include <QMenuBar>
#include <QToolBar>
#include <QStatusBar>
#include <QTabWidget>
#include <QAction>
#include <QKeySequence>
#include <QCloseEvent>
#include <QShowEvent>
#include <QSettings>
#include <QDebug>

class MainWindowPrivate
{
public:
    // 菜单
    QMenu* fileMenu = nullptr;
    QMenu* editMenu = nullptr;
    QMenu* viewMenu = nullptr;
    QMenu* helpMenu = nullptr;
    
    // 工具栏
    QToolBar* mainToolBar = nullptr;
    
    // 状态栏
    StatusBar* statusBar = nullptr;
    
    // 中央部件
    QTabWidget* tabWidget = nullptr;
    
    // 动作
    QAction* exitAction = nullptr;
    QAction* settingsAction = nullptr;
    QAction* aboutAction = nullptr;
    
    // 设置
    QSettings settings;
};

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
    , d_ptr(new MainWindowPrivate)
{
    setWindowTitle(tr("My Qt Application"));
    resize(1024, 768);
    
    // 创建UI组件
    createFileMenu();
    createEditMenu();
    createViewMenu();
    createHelpMenu();
    createToolBars();
    createStatusBar();
    createCentralWidget();
    
    qDebug() << "主窗口已创建";
}

MainWindow::~MainWindow()
{
    qDebug() << "主窗口已销毁";
}

void MainWindow::showSettingsDialog()
{
    SettingsDialog dialog(this);
    if (dialog.exec() == QDialog::Accepted) {
        updateStatusBar(tr("设置已保存"));
    }
}

void MainWindow::showAboutDialog()
{
    AboutDialog dialog(this);
    dialog.exec();
}

void MainWindow::updateStatusBar(const QString& message)
{
    Q_D(MainWindow);
    if (d->statusBar) {
        d->statusBar->showMessage(message, 3000);
    }
}

void MainWindow::closeEvent(QCloseEvent *event)
{
    Q_D(MainWindow);
    
    // 保存窗口状态
    d->settings.setValue("MainWindow/geometry", saveGeometry());
    d->settings.setValue("MainWindow/windowState", saveState());
    
    QMainWindow::closeEvent(event);
}

void MainWindow::showEvent(QShowEvent *event)
{
    Q_D(MainWindow);
    
    // 恢复窗口状态
    restoreGeometry(d->settings.value("MainWindow/geometry").toByteArray());
    restoreState(d->settings.value("MainWindow/windowState").toByteArray());
    
    QMainWindow::showEvent(event);
}

void MainWindow::createFileMenu()
{
    Q_D(MainWindow);
    
    d->fileMenu = menuBar()->addMenu(tr("文件(&F)"));
    
    d->exitAction = new QAction(tr("退出(&Q)"), this);
    d->exitAction->setShortcut(QKeySequence::Quit);
    connect(d->exitAction, &QAction::triggered, this, &MainWindow::close);
    
    d->fileMenu->addAction(d->exitAction);
}

void MainWindow::createEditMenu()
{
    Q_D(MainWindow);
    d->editMenu = menuBar()->addMenu(tr("编辑(&E)"));
    // TODO: 添加编辑菜单项
}

void MainWindow::createViewMenu()
{
    Q_D(MainWindow);
    d->viewMenu = menuBar()->addMenu(tr("视图(&V)"));
    // TODO: 添加视图菜单项
}

void MainWindow::createHelpMenu()
{
    Q_D(MainWindow);
    
    d->helpMenu = menuBar()->addMenu(tr("帮助(&H)"));
    
    d->settingsAction = new QAction(tr("设置(&S)"), this);
    d->settingsAction->setShortcut(QKeySequence::Preferences);
    connect(d->settingsAction, &QAction::triggered, this, &MainWindow::showSettingsDialog);
    
    d->aboutAction = new QAction(tr("关于(&A)"), this);
    connect(d->aboutAction, &QAction::triggered, this, &MainWindow::showAboutDialog);
    
    d->helpMenu->addAction(d->settingsAction);
    d->helpMenu->addSeparator();
    d->helpMenu->addAction(d->aboutAction);
}

void MainWindow::createToolBars()
{
    Q_D(MainWindow);
    
    d->mainToolBar = addToolBar(tr("主工具栏"));
    d->mainToolBar->setObjectName("MainToolBar");
    d->mainToolBar->setMovable(false);
    
    // TODO: 添加工具栏按钮
}

void MainWindow::createStatusBar()
{
    Q_D(MainWindow);
    
    d->statusBar = new StatusBar(this);
    setStatusBar(d->statusBar);
    d->statusBar->showMessage(tr("就绪"));
}

void MainWindow::createCentralWidget()
{
    Q_D(MainWindow);
    
    d->tabWidget = new QTabWidget(this);
    d->tabWidget->setTabPosition(QTabWidget::North);
    d->tabWidget->setTabsClosable(true);
    d->tabWidget->setMovable(true);
    
    setCentralWidget(d->tabWidget);
}
EOF

print_success "创建 core 模块文件"

# 4.3 创建core模块的其他文件
print_msg "创建AppConfig.h/AppConfig.cpp..."
cat > src/core/AppConfig.h << 'EOF'
#ifndef APPCONFIG_H
#define APPCONFIG_H

#include <QObject>
#include <QSettings>
#include <QVariant>
#include <QString>

class AppConfig : public QObject
{
    Q_OBJECT
    
public:
    static AppConfig& instance();
    
    QVariant value(const QString& key, const QVariant& defaultValue = QVariant()) const;
    void setValue(const QString& key, const QVariant& value);
    
    void save();
    
    QString configFilePath() const;
    
signals:
    void configChanged(const QString& key, const QVariant& value);
    
private:
    AppConfig(QObject *parent = nullptr);
    ~AppConfig();
    
    QSettings* settings;
};
#endif // APPCONFIG_H
EOF

# 创建 AppConfig.cpp
cat > src/core/AppConfig.cpp << 'EOF'
#include "AppConfig.h"
#include <QStandardPaths>
#include <QDir>
#include <QDebug>

AppConfig::AppConfig(QObject *parent)
    : QObject(parent)
{
    QString configDir = QStandardPaths::writableLocation(QStandardPaths::AppConfigLocation);
    QDir().mkpath(configDir);
    
    QString configFile = configDir + "/config.ini";
    settings = new QSettings(configFile, QSettings::IniFormat, this);
    
    qDebug() << "配置文件:" << configFile;
}

AppConfig::~AppConfig()
{
    save();
}

AppConfig& AppConfig::instance()
{
    static AppConfig instance;
    return instance;
}

QVariant AppConfig::value(const QString& key, const QVariant& defaultValue) const
{
    return settings->value(key, defaultValue);
}

void AppConfig::setValue(const QString& key, const QVariant& value)
{
    if (settings->value(key) != value) {
        settings->setValue(key, value);
        settings->sync();
        emit configChanged(key, value);
    }
}

void AppConfig::save()
{
    settings->sync();
    qDebug() << "配置已保存";
}

QString AppConfig::configFilePath() const
{
    return settings->fileName();
}
EOF

# 创建 AppTheme.h
cat > src/core/AppTheme.h << 'EOF'
#ifndef APPTHEME_H
#define APPTHEME_H

#include <QObject>
#include <QString>
#include <QColor>
#include <QHash>

class AppTheme : public QObject
{
    Q_OBJECT
    
public:
    enum ThemeMode {
        LightMode,
        DarkMode,
        AutoMode
    };
    Q_ENUM(ThemeMode)
    
    static AppTheme& instance();
    
    ThemeMode currentTheme() const;
    void setTheme(ThemeMode theme);
    
    QString styleSheet() const;
    void loadStyleSheet(const QString& filePath);
    
    QColor color(const QString& role) const;
    
signals:
    void themeChanged(ThemeMode newTheme);
    
private:
    AppTheme(QObject *parent = nullptr);
    ~AppTheme();
    
    ThemeMode m_theme;
    QString m_styleSheet;
    QHash<QString, QColor> m_colors;
};
#endif // APPTHEME_H
EOF

# 创建 AppTheme.cpp
cat > src/core/AppTheme.cpp << 'EOF'
#include "AppTheme.h"
#include <QFile>
#include <QApplication>
#include <QDebug>

AppTheme::AppTheme(QObject *parent)
    : QObject(parent)
    , m_theme(LightMode)
{
    m_colors["primary"] = QColor("#2196F3");
    m_colors["secondary"] = QColor("#FF9800");
    m_colors["success"] = QColor("#4CAF50");
    m_colors["warning"] = QColor("#FFC107");
    m_colors["danger"] = QColor("#F44336");
    m_colors["background"] = QColor("#FFFFFF");
    m_colors["foreground"] = QColor("#000000");
}

AppTheme::~AppTheme()
{
}

AppTheme& AppTheme::instance()
{
    static AppTheme instance;
    return instance;
}

AppTheme::ThemeMode AppTheme::currentTheme() const
{
    return m_theme;
}

void AppTheme::setTheme(ThemeMode theme)
{
    if (m_theme != theme) {
        m_theme = theme;
        
        if (theme == DarkMode) {
            m_colors["background"] = QColor("#2D2D2D");
            m_colors["foreground"] = QColor("#FFFFFF");
        } else {
            m_colors["background"] = QColor("#FFFFFF");
            m_colors["foreground"] = QColor("#000000");
        }
        
        emit themeChanged(theme);
        
        if (!m_styleSheet.isEmpty()) {
            qApp->setStyleSheet(m_styleSheet);
        }
    }
}

QString AppTheme::styleSheet() const
{
    return m_styleSheet;
}

void AppTheme::loadStyleSheet(const QString& filePath)
{
    QFile file(filePath);
    if (file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        m_styleSheet = QString::fromUtf8(file.readAll());
        file.close();
        qDebug() << "样式表已加载:" << filePath;
    } else {
        qWarning() << "无法加载样式表:" << filePath << file.errorString();
    }
}

QColor AppTheme::color(const QString& role) const
{
    return m_colors.value(role, QColor());
}
EOF

print_success "创建 AppTheme.h/AppTheme.cpp"

# 4.4 创建models模块文件
print_msg "创建models模块文件..."
cat > src/models/BaseModel.h << 'EOF'
#ifndef BASEMODEL_H
#define BASEMODEL_H

#include <QAbstractItemModel>
#include <QObject>
#include <QVariant>
#include <QVector>
#include <QModelIndex>
#include <QScopedPointer>

class BaseModelPrivate;

class BaseModel : public QAbstractItemModel
{
    Q_OBJECT
    
public:
    explicit BaseModel(QObject *parent = nullptr);
    virtual ~BaseModel();
    
    // QAbstractItemModel interface
    QModelIndex index(int row, int column, const QModelIndex &parent = QModelIndex()) const override;
    QModelIndex parent(const QModelIndex &child) const override;
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    int columnCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    
    // 数据管理
    Q_INVOKABLE bool loadData();
    Q_INVOKABLE bool saveData();
    Q_INVOKABLE bool addItem(const QVariantMap& item);
    Q_INVOKABLE bool updateItem(int index, const QVariantMap& item);
    Q_INVOKABLE bool removeItem(int index);
    
    // 状态查询
    Q_INVOKABLE bool hasChanges() const;
    Q_INVOKABLE int itemCount() const;
    Q_INVOKABLE QString lastError() const;
    
signals:
    void dataLoaded(bool success);
    void dataSaved(bool success);
    void dataChanged();
    void errorOccurred(const QString& error);
    
protected:
    // 子类需要重写的方法
    virtual bool doLoadData() = 0;
    virtual bool doSaveData() = 0;
    
    // 状态设置
    void setHasChanges(bool changed);
    void setLastError(const QString& error);
    
private:
    QScopedPointer<BaseModelPrivate> d_ptr;
    Q_DECLARE_PRIVATE(BaseModel)
};

#endif // BASEMODEL_H
EOF
cat > src/models/BaseModel.cpp << 'EOF'
#include "BaseModel.h"
#include <QDebug>

class BaseModelPrivate
{
public:
    bool hasChanges = false;
    QString lastError;
    QVector<QVariantMap> items;
};

BaseModel::BaseModel(QObject *parent)
    : QAbstractItemModel(parent)
    , d_ptr(new BaseModelPrivate)
{
    qDebug() << "BaseModel 已创建";
}

BaseModel::~BaseModel()
{
    qDebug() << "BaseModel 已销毁";
}

QModelIndex BaseModel::index(int row, int column, const QModelIndex &parent) const
{
    Q_UNUSED(parent)
    if (row < 0 || column < 0 || row >= d_ptr->items.size() || column >= 1)
        return QModelIndex();
    
    return createIndex(row, column);
}

QModelIndex BaseModel::parent(const QModelIndex &child) const
{
    Q_UNUSED(child)
    return QModelIndex();
}

int BaseModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent)
    return d_ptr->items.size();
}

int BaseModel::columnCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent)
    return 1;
}

QVariant BaseModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant();
    
    if (role == Qt::DisplayRole) {
        if (index.row() < d_ptr->items.size()) {
            return d_ptr->items[index.row()].value("name", "Unnamed");
        }
    }
    
    return QVariant();
}

bool BaseModel::loadData()
{
    Q_D(BaseModel);
    
    beginResetModel();
    bool success = doLoadData();
    d->hasChanges = false;
    endResetModel();
    
    emit dataLoaded(success);
    return success;
}

bool BaseModel::saveData()
{
    Q_D(BaseModel);
    
    if (!d->hasChanges) {
        return true;
    }
    
    bool success = doSaveData();
    if (success) {
        d->hasChanges = false;
    }
    
    emit dataSaved(success);
    return success;
}

bool BaseModel::addItem(const QVariantMap& item)
{
    Q_D(BaseModel);
    
    if (item.isEmpty()) {
        setLastError("Item is empty");
        return false;
    }
    
    beginInsertRows(QModelIndex(), d->items.size(), d->items.size());
    d->items.append(item);
    d->hasChanges = true;
    endInsertRows();
    
    emit dataChanged();
    return true;
}

bool BaseModel::updateItem(int index, const QVariantMap& item)
{
    Q_D(BaseModel);
    
    if (index < 0 || index >= d->items.size()) {
        setLastError("Index out of range");
        return false;
    }
    
    if (item.isEmpty()) {
        setLastError("Item is empty");
        return false;
    }
    
    d->items[index] = item;
    d->hasChanges = true;
    
    // 修复这里：使用正确的dataChanged信号
    QModelIndex modelIndex = createIndex(index, 0);
    emit QAbstractItemModel::dataChanged(modelIndex, modelIndex);
    
    return true;
}

bool BaseModel::removeItem(int index)
{
    Q_D(BaseModel);
    
    if (index < 0 || index >= d->items.size()) {
        setLastError("Index out of range");
        return false;
    }
    
    beginRemoveRows(QModelIndex(), index, index);
    d->items.remove(index);
    d->hasChanges = true;
    endRemoveRows();
    
    emit dataChanged();
    return true;
}

bool BaseModel::hasChanges() const
{
    Q_D(const BaseModel);
    return d->hasChanges;
}

int BaseModel::itemCount() const
{
    Q_D(const BaseModel);
    return d->items.size();
}

QString BaseModel::lastError() const
{
    Q_D(const BaseModel);
    return d->lastError;
}

void BaseModel::setHasChanges(bool changed)
{
    Q_D(BaseModel);
    d->hasChanges = changed;
}

void BaseModel::setLastError(const QString& error)
{
    Q_D(BaseModel);
    d->lastError = error;
    emit errorOccurred(error);
}
EOF

print_success "创建 BaseModel.h/BaseModel.cpp"

cat > src/models/DataItem.h << 'EOF'
#ifndef DATAITEM_H
#define DATAITEM_H

#include <QObject>
#include <QVariant>
#include <QDateTime>
#include <QString>

class DataItem : public QObject
{
    Q_OBJECT
    
    Q_PROPERTY(QString id READ id WRITE setId NOTIFY idChanged)
    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged)
    Q_PROPERTY(QDateTime createdAt READ createdAt CONSTANT)
    Q_PROPERTY(QDateTime updatedAt READ updatedAt NOTIFY updatedAtChanged)
    
public:
    explicit DataItem(QObject *parent = nullptr);
    DataItem(const QString& id, QObject *parent = nullptr);
    virtual ~DataItem();
    
    // 属性访问器
    QString id() const;
    void setId(const QString& id);
    
    QString name() const;
    void setName(const QString& name);
    
    QDateTime createdAt() const;
    QDateTime updatedAt() const;
    
    // 数据操作
    QVariant data(const QString& key) const;
    void setData(const QString& key, const QVariant& value);
    bool hasData(const QString& key) const;
    
    // 序列化
    QVariantMap toVariantMap() const;
    bool fromVariantMap(const QVariantMap& data);
    
    // 验证
    bool isValid() const;
    
signals:
    void idChanged(const QString& id);
    void nameChanged(const QString& name);
    void dataChanged(const QString& key, const QVariant& value);
    void updatedAtChanged(const QDateTime& updatedAt);
    
private:
    QString m_id;
    QString m_name;
    QDateTime m_createdAt;
    QDateTime m_updatedAt;
    QVariantMap m_data;
};

#endif // DATAITEM_H
EOF

cat > src/models/DataItem.cpp << 'EOF'
#include "DataItem.h"
#include <QUuid>
#include <QDebug>

DataItem::DataItem(QObject *parent)
    : QObject(parent)
    , m_id(QUuid::createUuid().toString())
    , m_name(tr("Unnamed Item"))
    , m_createdAt(QDateTime::currentDateTime())
    , m_updatedAt(m_createdAt)
{
    qDebug() << "DataItem 已创建, ID:" << m_id;
}

DataItem::DataItem(const QString& id, QObject *parent)
    : QObject(parent)
    , m_id(id.isEmpty() ? QUuid::createUuid().toString() : id)
    , m_name(tr("Unnamed Item"))
    , m_createdAt(QDateTime::currentDateTime())
    , m_updatedAt(m_createdAt)
{
    qDebug() << "DataItem 已创建, ID:" << m_id;
}

DataItem::~DataItem()
{
    qDebug() << "DataItem 已销毁, ID:" << m_id;
}

QString DataItem::id() const
{
    return m_id;
}

void DataItem::setId(const QString& id)
{
    if (m_id != id && !id.isEmpty()) {
        m_id = id;
        m_updatedAt = QDateTime::currentDateTime();
        emit idChanged(m_id);
        emit updatedAtChanged(m_updatedAt);
    }
}

QString DataItem::name() const
{
    return m_name;
}

void DataItem::setName(const QString& name)
{
    if (m_name != name) {
        m_name = name;
        m_updatedAt = QDateTime::currentDateTime();
        emit nameChanged(m_name);
        emit updatedAtChanged(m_updatedAt);
    }
}

QDateTime DataItem::createdAt() const
{
    return m_createdAt;
}

QDateTime DataItem::updatedAt() const
{
    return m_updatedAt;
}

QVariant DataItem::data(const QString& key) const
{
    return m_data.value(key);
}

void DataItem::setData(const QString& key, const QVariant& value)
{
    if (m_data.value(key) != value) {
        m_data[key] = value;
        m_updatedAt = QDateTime::currentDateTime();
        emit dataChanged(key, value);
        emit updatedAtChanged(m_updatedAt);
    }
}

bool DataItem::hasData(const QString& key) const
{
    return m_data.contains(key);
}

QVariantMap DataItem::toVariantMap() const
{
    QVariantMap map;
    map["id"] = m_id;
    map["name"] = m_name;
    map["createdAt"] = m_createdAt;
    map["updatedAt"] = m_updatedAt;
    map["data"] = m_data;
    return map;
}

bool DataItem::fromVariantMap(const QVariantMap& data)
{
    if (data.isEmpty()) {
        return false;
    }
    
    m_id = data.value("id", m_id).toString();
    m_name = data.value("name", m_name).toString();
    m_createdAt = data.value("createdAt", m_createdAt).toDateTime();
    m_updatedAt = data.value("updatedAt", QDateTime::currentDateTime()).toDateTime();
    m_data = data.value("data", m_data).toMap();
    
    return true;
}

bool DataItem::isValid() const
{
    return !m_id.isEmpty();
}
EOF

print_success "创建 DataItem.h/DataItem.cpp"

cat > src/models/ListModel.h << 'EOF'
#ifndef LISTMODEL_H
#define LISTMODEL_H

#include "BaseModel.h"
#include <QList>

class DataItem;

class ListModel : public BaseModel
{
    Q_OBJECT
    
public:
    explicit ListModel(QObject *parent = nullptr);
    virtual ~ListModel();
    
    // 数据访问
    QList<DataItem*> items() const;
    DataItem* itemAt(int index) const;
    DataItem* findItem(const QString& id) const;
    
    // 数据操作
    bool addItem(DataItem* item);
    bool removeItem(const QString& id);
    bool updateItem(const QString& id, const QVariantMap& data);
    
    // QAbstractItemModel interface
    int rowCount(const QModelIndex& parent = QModelIndex()) const override;
    int columnCount(const QModelIndex& parent = QModelIndex()) const override;
    QVariant data(const QModelIndex& index, int role = Qt::DisplayRole) const override;
    bool setData(const QModelIndex& index, const QVariant& value, int role = Qt::EditRole) override;
    QModelIndex index(int row, int column, const QModelIndex& parent = QModelIndex()) const override;
    QModelIndex parent(const QModelIndex& child) const override;
    Qt::ItemFlags flags(const QModelIndex& index) const override;
    
    // 其他操作
    void clear();
    
protected:
    // BaseModel interface
    bool doLoadData() override;
    bool doSaveData() override;
    
private:
    QList<DataItem*> m_items;
};

#endif // LISTMODEL_H
EOF
cat > src/models/ListModel.cpp << 'EOF'
#include "ListModel.h"
#include "DataItem.h"
#include <QDebug>

ListModel::ListModel(QObject *parent)
    : BaseModel(parent)
{
    qDebug() << "ListModel 已创建";
}

ListModel::~ListModel()
{
    qDeleteAll(m_items);
    m_items.clear();
    qDebug() << "ListModel 已销毁";
}

QList<DataItem*> ListModel::items() const
{
    return m_items;
}

DataItem* ListModel::itemAt(int index) const
{
    if (index >= 0 && index < m_items.size()) {
        return m_items.at(index);
    }
    return nullptr;
}

DataItem* ListModel::findItem(const QString& id) const
{
    for (DataItem* item : m_items) {
        if (item->id() == id) {
            return item;
        }
    }
    return nullptr;
}

bool ListModel::addItem(DataItem* item)
{
    if (!item || findItem(item->id())) {
        return false;
    }
    
    beginInsertRows(QModelIndex(), m_items.size(), m_items.size());
    m_items.append(item);
    setHasChanges(true);
    endInsertRows();
    
    emit dataChanged();
    return true;
}

bool ListModel::removeItem(const QString& id)
{
    for (int i = 0; i < m_items.size(); ++i) {
        if (m_items.at(i)->id() == id) {
            beginRemoveRows(QModelIndex(), i, i);
            delete m_items.takeAt(i);
            setHasChanges(true);
            endRemoveRows();
            
            emit dataChanged();
            return true;
        }
    }
    return false;
}

bool ListModel::updateItem(const QString& id, const QVariantMap& data)
{
    DataItem* item = findItem(id);
    if (!item) {
        return false;
    }
    
    if (item->fromVariantMap(data)) {
        setHasChanges(true);
        
        int index = m_items.indexOf(item);
        if (index >= 0) {
            // 修复这里：使用正确的dataChanged信号
            QModelIndex modelIndex = createIndex(index, 0);
            emit QAbstractItemModel::dataChanged(modelIndex, modelIndex);
        }
        
        return true;
    }
    
    return false;
}

int ListModel::rowCount(const QModelIndex& parent) const
{
    Q_UNUSED(parent)
    return m_items.size();
}

int ListModel::columnCount(const QModelIndex& parent) const
{
    Q_UNUSED(parent)
    return 2; // ID 和名称
}

QVariant ListModel::data(const QModelIndex& index, int role) const
{
    if (!index.isValid() || index.row() >= m_items.size()) {
        return QVariant();
    }
    
    DataItem* item = m_items.at(index.row());
    if (!item) {
        return QVariant();
    }
    
    switch (role) {
    case Qt::DisplayRole:
    case Qt::EditRole:
        if (index.column() == 0) {
            return item->id();
        } else if (index.column() == 1) {
            return item->name();
        }
        break;
    case Qt::UserRole:
        return QVariant::fromValue(item);
    }
    
    return QVariant();
}

bool ListModel::setData(const QModelIndex& index, const QVariant& value, int role)
{
    if (!index.isValid() || index.row() >= m_items.size()) {
        return false;
    }
    
    DataItem* item = m_items.at(index.row());
    if (!item) {
        return false;
    }
    
    if (role == Qt::EditRole) {
        if (index.column() == 0) {
            item->setId(value.toString());
        } else if (index.column() == 1) {
            item->setName(value.toString());
        }
        
        setHasChanges(true);
        // 修复这里：使用正确的dataChanged信号
        emit QAbstractItemModel::dataChanged(index, index);
        return true;
    }
    
    return false;
}

QModelIndex ListModel::index(int row, int column, const QModelIndex& parent) const
{
    Q_UNUSED(parent)
    if (row >= 0 && row < m_items.size() && column >= 0 && column < 2) {
        return createIndex(row, column);
    }
    return QModelIndex();
}

QModelIndex ListModel::parent(const QModelIndex& child) const
{
    Q_UNUSED(child)
    return QModelIndex();
}

Qt::ItemFlags ListModel::flags(const QModelIndex& index) const
{
    if (!index.isValid()) {
        return Qt::NoItemFlags;
    }
    
    Qt::ItemFlags flags = Qt::ItemIsEnabled | Qt::ItemIsSelectable;
    if (index.column() == 0 || index.column() == 1) {
        flags |= Qt::ItemIsEditable;
    }
    
    return flags;
}

void ListModel::clear()
{
    if (m_items.isEmpty()) {
        return;
    }
    
    beginResetModel();
    qDeleteAll(m_items);
    m_items.clear();
    endResetModel();
}

bool ListModel::doLoadData()
{
    // 清空现有数据
    beginResetModel();
    qDeleteAll(m_items);
    m_items.clear();
    endResetModel();
    
    // TODO: 从数据源加载数据
    setLastError("Not implemented");
    return false;
}

bool ListModel::doSaveData()
{
    // TODO: 保存数据到数据源
    setLastError("Not implemented");
    return false;
}
EOF

print_success "创建 ListModel.h/ListModel.cpp"

# 4.5 创建viewmodels模块文件 - 修复包含和语法错误
print_msg "创建viewmodels模块文件..."

cat > src/viewmodels/BaseViewModel.h << 'EOF'
#ifndef BASEVIEWMODEL_H
#define BASEVIEWMODEL_H

#include <QObject>
#include <QScopedPointer>
#include <QString>

class BaseViewModelPrivate;

class BaseViewModel : public QObject
{
    Q_OBJECT
    
    Q_PROPERTY(bool loading READ loading NOTIFY loadingChanged)
    Q_PROPERTY(bool hasError READ hasError NOTIFY hasErrorChanged)
    Q_PROPERTY(QString errorMessage READ errorMessage NOTIFY errorMessageChanged)
    
public:
    explicit BaseViewModel(QObject *parent = nullptr);
    virtual ~BaseViewModel();
    
    // 状态属性
    bool loading() const;
    bool hasError() const;
    QString errorMessage() const;
    
    // 生命周期管理
    virtual bool initialize();
    virtual void cleanup();
    
    // 数据操作
    Q_INVOKABLE virtual void load();
    Q_INVOKABLE virtual void save();
    Q_INVOKABLE virtual void refresh();
    Q_INVOKABLE virtual void reset();
    
signals:
    void loadingChanged(bool loading);
    void hasErrorChanged(bool hasError);
    void errorMessageChanged(const QString& errorMessage);
    void initialized();
    void dataLoaded();
    void dataSaved();
    
protected:
    // 状态设置
    void setLoading(bool loading);
    void setError(const QString& errorMessage);
    void clearError();
    
    // 子类实现
    virtual bool doInitialize() = 0;
    virtual void doCleanup() = 0;
    virtual void doLoad() = 0;
    virtual void doSave() = 0;
    
private:
    QScopedPointer<BaseViewModelPrivate> d_ptr;
    Q_DECLARE_PRIVATE(BaseViewModel)
};

#endif // BASEVIEWMODEL_H
EOF

cat > src/viewmodels/BaseViewModel.cpp << 'EOF'
#include "BaseViewModel.h"
#include <QDebug>

class BaseViewModelPrivate
{
public:
    bool loading = false;
    bool hasError = false;
    QString errorMessage;
};

BaseViewModel::BaseViewModel(QObject *parent)
    : QObject(parent)
    , d_ptr(new BaseViewModelPrivate)
{
    qDebug() << "BaseViewModel 已创建";
}

BaseViewModel::~BaseViewModel()
{
    cleanup();
    qDebug() << "BaseViewModel 已销毁";
}

bool BaseViewModel::loading() const
{
    Q_D(const BaseViewModel);
    return d->loading;
}

bool BaseViewModel::hasError() const
{
    Q_D(const BaseViewModel);
    return d->hasError;
}

QString BaseViewModel::errorMessage() const
{
    Q_D(const BaseViewModel);
    return d->errorMessage;
}

bool BaseViewModel::initialize()
{
    Q_D(BaseViewModel);
    
    if (d->loading) {
        return false;
    }
    
    setLoading(true);
    clearError();
    
    bool success = doInitialize();
    
    setLoading(false);
    
    if (success) {
        emit initialized();
    }
    
    return success;
}

void BaseViewModel::cleanup()
{
    Q_D(BaseViewModel);
    
    if (d->loading) {
        setLoading(false);
    }
    
    doCleanup();
    
    qDebug() << "BaseViewModel 已清理";
}

void BaseViewModel::load()
{
    Q_D(BaseViewModel);
    
    if (d->loading) {
        return;
    }
    
    setLoading(true);
    clearError();
    
    doLoad();
    
    setLoading(false);
    emit dataLoaded();
}

void BaseViewModel::save()
{
    Q_D(BaseViewModel);
    
    if (d->loading) {
        return;
    }
    
    setLoading(true);
    clearError();
    
    doSave();
    
    setLoading(false);
    emit dataSaved();
}

void BaseViewModel::refresh()
{
    load();
}

void BaseViewModel::reset()
{
    Q_D(BaseViewModel);
    
    clearError();
    d->loading = false;
    
    qDebug() << "BaseViewModel 已重置";
}

void BaseViewModel::setLoading(bool loading)
{
    Q_D(BaseViewModel);
    
    if (d->loading != loading) {
        d->loading = loading;
        emit loadingChanged(loading);
    }
}

void BaseViewModel::setError(const QString& errorMessage)
{
    Q_D(BaseViewModel);
    
    d->hasError = true;
    d->errorMessage = errorMessage;
    
    emit hasErrorChanged(true);
    emit errorMessageChanged(errorMessage);
    
    qWarning() << "BaseViewModel 错误:" << errorMessage;
}

void BaseViewModel::clearError()
{
    Q_D(BaseViewModel);
    
    if (d->hasError) {
        d->hasError = false;
        d->errorMessage.clear();
        
        emit hasErrorChanged(false);
        emit errorMessageChanged("");
    }
}
EOF

print_success "创建 BaseViewModel.h/BaseViewModel.cpp"

cat > src/viewmodels/MainViewModel.h << 'EOF'
#ifndef MAINVIEWMODEL_H
#define MAINVIEWMODEL_H

#include "BaseViewModel.h"
#include "../models/ListModel.h"
#include "../models/DataItem.h"
#include <QStringList>

class MainViewModelPrivate;

class MainViewModel : public BaseViewModel
{
    Q_OBJECT
    
    Q_PROPERTY(ListModel* itemModel READ itemModel NOTIFY itemModelChanged)
    Q_PROPERTY(QStringList categories READ categories NOTIFY categoriesChanged)
    Q_PROPERTY(int totalCount READ totalCount NOTIFY totalCountChanged)
    Q_PROPERTY(int selectedCount READ selectedCount NOTIFY selectedCountChanged)
    
public:
    explicit MainViewModel(QObject *parent = nullptr);
    virtual ~MainViewModel();
    
    // 属性访问器
    ListModel* itemModel() const;
    QStringList categories() const;
    int totalCount() const;
    int selectedCount() const;
    
    // 业务方法
    Q_INVOKABLE void addNewItem(const QString& name);
    Q_INVOKABLE void removeSelectedItem(int index);
    Q_INVOKABLE void updateItem(int index, const QString& name);
    Q_INVOKABLE void filterByCategory(const QString& category);
    Q_INVOKABLE void clearFilter();
    
signals:
    void itemModelChanged(ListModel* itemModel);
    void categoriesChanged(const QStringList& categories);
    void totalCountChanged(int totalCount);
    void selectedCountChanged(int selectedCount);
    void itemAdded(const QString& id);
    void itemRemoved(const QString& id);
    void itemUpdated(const QString& id);
    
protected:
    // BaseViewModel 接口实现
    bool doInitialize() override;
    void doCleanup() override;
    void doLoad() override;
    void doSave() override;
    
private:
    QScopedPointer<MainViewModelPrivate> d_ptr;
    Q_DECLARE_PRIVATE(MainViewModel)
};

#endif // MAINVIEWMODEL_H
EOF

cat > src/viewmodels/MainViewModel.cpp << 'EOF'
#include "MainViewModel.h"
#include <QDebug>

class MainViewModelPrivate
{
public:
    ListModel* itemModel = nullptr;
    QStringList categories;
    int totalCount = 0;
    int selectedCount = 0;
    QString currentFilter;
};

MainViewModel::MainViewModel(QObject *parent)
    : BaseViewModel(parent)
    , d_ptr(new MainViewModelPrivate)
{
    d_ptr->itemModel = new ListModel(this);
    qDebug() << "MainViewModel 已创建";
}

MainViewModel::~MainViewModel()
{
    qDebug() << "MainViewModel 已销毁";
}

ListModel* MainViewModel::itemModel() const
{
    Q_D(const MainViewModel);
    return d->itemModel;
}

QStringList MainViewModel::categories() const
{
    Q_D(const MainViewModel);
    return d->categories;
}

int MainViewModel::totalCount() const
{
    Q_D(const MainViewModel);
    return d->totalCount;
}

int MainViewModel::selectedCount() const
{
    Q_D(const MainViewModel);
    return d->selectedCount;
}

void MainViewModel::addNewItem(const QString& name)
{
    Q_D(MainViewModel);
    
    if (name.isEmpty()) {
        setError(tr("Item name cannot be empty"));
        return;
    }
    
    // 创建新项目
    DataItem* item = new DataItem();
    item->setName(name);
    
    if (d->itemModel->addItem(item)) {
        d->totalCount = d->itemModel->rowCount();
        emit totalCountChanged(d->totalCount);
        emit itemAdded(item->id());
        
        qDebug() << "添加新项目:" << name;
    } else {
        delete item;
        setError(tr("Failed to add item"));
    }
}

void MainViewModel::removeSelectedItem(int index)
{
    Q_D(MainViewModel);
    
    if (index < 0 || index >= d->itemModel->rowCount()) {
        setError(tr("Invalid index"));
        return;
    }
    
    DataItem* item = d->itemModel->itemAt(index);
    if (!item) {
        setError(tr("Item not found"));
        return;
    }
    
    QString itemId = item->id();
    if (d->itemModel->removeItem(itemId)) {
        d->totalCount = d->itemModel->rowCount();
        emit totalCountChanged(d->totalCount);
        emit itemRemoved(itemId);
        
        qDebug() << "删除项目:" << itemId;
    } else {
        setError(tr("Failed to remove item"));
    }
}

void MainViewModel::updateItem(int index, const QString& name)
{
    Q_D(MainViewModel);
    
    if (name.isEmpty()) {
        setError(tr("Item name cannot be empty"));
        return;
    }
    
    if (index < 0 || index >= d->itemModel->rowCount()) {
        setError(tr("Invalid index"));
        return;
    }
    
    DataItem* item = d->itemModel->itemAt(index);
    if (!item) {
        setError(tr("Item not found"));
        return;
    }
    
    QString oldName = item->name();
    item->setName(name);
    
    if (d->itemModel->updateItem(item->id(), item->toVariantMap())) {
        emit itemUpdated(item->id());
        
        qDebug() << "更新项目:" << oldName << "->" << name;
    } else {
        setError(tr("Failed to update item"));
    }
}

void MainViewModel::filterByCategory(const QString& category)
{
    Q_D(MainViewModel);
    
    d->currentFilter = category;
    // TODO: 实现过滤逻辑
    qDebug() << "按分类过滤:" << category;
}

void MainViewModel::clearFilter()
{
    Q_D(MainViewModel);
    
    d->currentFilter.clear();
    // TODO: 清除过滤逻辑
    qDebug() << "清除过滤";
}

bool MainViewModel::doInitialize()
{
    Q_D(MainViewModel);
    
    // 修复这里：使用明确的列表初始化
    d->categories.clear();
    d->categories.append(tr("All"));
    d->categories.append(tr("Favorites"));
    d->categories.append(tr("Recent"));
    
    emit categoriesChanged(d->categories);
    
    // 加载示例数据
    for (int i = 1; i <= 5; ++i) {
        DataItem* item = new DataItem();
        item->setName(tr("Item %1").arg(i));
        d->itemModel->addItem(item);
    }
    
    d->totalCount = d->itemModel->rowCount();
    emit totalCountChanged(d->totalCount);
    
    qDebug() << "MainViewModel 初始化完成";
    return true;
}

void MainViewModel::doCleanup()
{
    Q_D(MainViewModel);
    
    if (d->itemModel) {
        d->itemModel->clear();
    }
    
    d->categories.clear();
    d->totalCount = 0;
    d->selectedCount = 0;
    d->currentFilter.clear();
    
    qDebug() << "MainViewModel 已清理";
}

void MainViewModel::doLoad()
{
    Q_D(MainViewModel);
    
    // TODO: 从数据源加载数据
    qDebug() << "加载数据...";
}

void MainViewModel::doSave()
{
    Q_D(MainViewModel);
    
    // TODO: 保存数据到数据源
    if (d->itemModel && d->itemModel->hasChanges()) {
        if (d->itemModel->saveData()) {
            qDebug() << "数据保存成功";
        } else {
            setError(tr("Failed to save data: %1").arg(d->itemModel->lastError()));
        }
    }
}
EOF

print_success "创建 MainViewModel.h/MainViewModel.cpp"

# 4.6 创建views/widgets模块文件 - 修复包含和实现
print_msg "创建views/widgets模块文件..."

cat > src/views/widgets/CustomButton.h << 'EOF'
#ifndef CUSTOMBUTTON_H
#define CUSTOMBUTTON_H

#include <QPushButton>
#include <QColor>

class CustomButton : public QPushButton
{
    Q_OBJECT
    
    Q_PROPERTY(QColor hoverColor READ hoverColor WRITE setHoverColor NOTIFY hoverColorChanged)
    Q_PROPERTY(QColor pressColor READ pressColor WRITE setPressColor NOTIFY pressColorChanged)
    
public:
    explicit CustomButton(QWidget *parent = nullptr);
    explicit CustomButton(const QString &text, QWidget *parent = nullptr);
    virtual ~CustomButton();
    
    // 自定义属性
    QColor hoverColor() const;
    void setHoverColor(const QColor &color);
    
    QColor pressColor() const;
    void setPressColor(const QColor &color);
    
protected:
    void paintEvent(QPaintEvent *event) override;
    void enterEvent(QEvent *event) override;
    void leaveEvent(QEvent *event) override;
    void mousePressEvent(QMouseEvent *event) override;
    void mouseReleaseEvent(QMouseEvent *event) override;
    
signals:
    void hoverColorChanged(const QColor &color);
    void pressColorChanged(const QColor &color);
    
private:
    QColor m_hoverColor;
    QColor m_pressColor;
    bool m_isHovered;
    bool m_isPressed;
};

#endif // CUSTOMBUTTON_H
EOF

cat > src/views/widgets/CustomButton.cpp << 'EOF'
#include "CustomButton.h"
#include <QPainter>
#include <QPainterPath>
#include <QDebug>

CustomButton::CustomButton(QWidget *parent)
    : QPushButton(parent)
    , m_hoverColor(QColor(64, 128, 255, 50))
    , m_pressColor(QColor(32, 96, 224, 100))
    , m_isHovered(false)
    , m_isPressed(false)
{
    setCursor(Qt::PointingHandCursor);
    qDebug() << "CustomButton 已创建";
}

CustomButton::CustomButton(const QString &text, QWidget *parent)
    : QPushButton(text, parent)
    , m_hoverColor(QColor(64, 128, 255, 50))
    , m_pressColor(QColor(32, 96, 224, 100))
    , m_isHovered(false)
    , m_isPressed(false)
{
    setCursor(Qt::PointingHandCursor);
    qDebug() << "CustomButton 已创建:" << text;
}

CustomButton::~CustomButton()
{
    qDebug() << "CustomButton 已销毁";
}

QColor CustomButton::hoverColor() const
{
    return m_hoverColor;
}

void CustomButton::setHoverColor(const QColor &color)
{
    if (m_hoverColor != color) {
        m_hoverColor = color;
        update();
        emit hoverColorChanged(color);
    }
}

QColor CustomButton::pressColor() const
{
    return m_pressColor;
}

void CustomButton::setPressColor(const QColor &color)
{
    if (m_pressColor != color) {
        m_pressColor = color;
        update();
        emit pressColorChanged(color);
    }
}

void CustomButton::paintEvent(QPaintEvent *event)
{
    Q_UNUSED(event)
    
    QPainter painter(this);
    painter.setRenderHint(QPainter::Antialiasing);
    
    QRect rect = this->rect();
    
    // 绘制背景
    QColor bgColor = palette().button().color();
    if (m_isPressed) {
        bgColor = m_pressColor;
    } else if (m_isHovered) {
        bgColor = m_hoverColor;
    }
    
    painter.setBrush(bgColor);
    painter.setPen(Qt::NoPen);
    painter.drawRoundedRect(rect, 4, 4);
    
    // 绘制文本
    if (!text().isEmpty()) {
        painter.setPen(palette().buttonText().color());
        painter.drawText(rect, Qt::AlignCenter, text());
    }
    
    // 绘制边框
    painter.setPen(palette().dark().color());
    painter.setBrush(Qt::NoBrush);
    painter.drawRoundedRect(rect.adjusted(0, 0, -1, -1), 4, 4);
}

void CustomButton::enterEvent(QEvent *event)
{
    m_isHovered = true;
    update();
    QPushButton::enterEvent(event);
}

void CustomButton::leaveEvent(QEvent *event)
{
    m_isHovered = false;
    update();
    QPushButton::leaveEvent(event);
}

void CustomButton::mousePressEvent(QMouseEvent *event)
{
    m_isPressed = true;
    update();
    QPushButton::mousePressEvent(event);
}

void CustomButton::mouseReleaseEvent(QMouseEvent *event)
{
    m_isPressed = false;
    update();
    QPushButton::mouseReleaseEvent(event);
}
EOF

print_success "创建 CustomButton.h/CustomButton.cpp"

cat > src/views/widgets/IconButton.h << 'EOF'
#ifndef ICONBUTTON_H
#define ICONBUTTON_H

#include <QPushButton>
#include <QString>
#include <QSize>
#include <QPixmap>

class IconButton : public QPushButton
{
    Q_OBJECT
    
    Q_PROPERTY(QString iconPath READ iconPath WRITE setIconPath NOTIFY iconPathChanged)
    Q_PROPERTY(QSize iconSize READ iconSize WRITE setIconSize NOTIFY iconSizeChanged)
    
public:
    explicit IconButton(QWidget *parent = nullptr);
    IconButton(const QString &iconPath, QWidget *parent = nullptr);
    virtual ~IconButton();
    
    // 自定义属性
    QString iconPath() const;
    void setIconPath(const QString &path);
    
    QSize iconSize() const;
    void setIconSize(const QSize &size);
    
protected:
    void paintEvent(QPaintEvent *event) override;
    
signals:
    void iconPathChanged(const QString &path);
    void iconSizeChanged(const QSize &size);
    
private:
    QString m_iconPath;
    QSize m_iconSize;
    QPixmap m_iconPixmap;
    
    void loadIcon();
};

#endif // ICONBUTTON_H
EOF

cat > src/views/widgets/IconButton.cpp << 'EOF'
#include "IconButton.h"
#include <QPainter>
#include <QDebug>

IconButton::IconButton(QWidget *parent)
    : QPushButton(parent)
    , m_iconSize(24, 24)
{
    setFixedSize(40, 40);
    qDebug() << "IconButton 已创建";
}

IconButton::IconButton(const QString &iconPath, QWidget *parent)
    : QPushButton(parent)
    , m_iconPath(iconPath)
    , m_iconSize(24, 24)
{
    setFixedSize(40, 40);
    loadIcon();
    qDebug() << "IconButton 已创建:" << iconPath;
}

IconButton::~IconButton()
{
    qDebug() << "IconButton 已销毁";
}

QString IconButton::iconPath() const
{
    return m_iconPath;
}

void IconButton::setIconPath(const QString &path)
{
    if (m_iconPath != path) {
        m_iconPath = path;
        loadIcon();
        update();
        emit iconPathChanged(path);
    }
}

QSize IconButton::iconSize() const
{
    return m_iconSize;
}

void IconButton::setIconSize(const QSize &size)
{
    if (m_iconSize != size) {
        m_iconSize = size;
        loadIcon();
        update();
        emit iconSizeChanged(size);
    }
}

void IconButton::paintEvent(QPaintEvent *event)
{
    Q_UNUSED(event)
    
    QPainter painter(this);
    painter.setRenderHint(QPainter::Antialiasing);
    
    QRect rect = this->rect();
    
    // 绘制背景
    if (isDown()) {
        painter.setBrush(palette().dark());
    } else if (underMouse()) {
        painter.setBrush(palette().midlight());
    } else {
        painter.setBrush(palette().button());
    }
    
    painter.setPen(palette().dark().color());
    painter.drawRoundedRect(rect.adjusted(1, 1, -1, -1), 4, 4);
    
    // 绘制图标
    if (!m_iconPixmap.isNull()) {
        int x = (rect.width() - m_iconSize.width()) / 2;
        int y = (rect.height() - m_iconSize.height()) / 2;
        painter.drawPixmap(x, y, m_iconPixmap);
    }
    
    // 绘制文本（如果有）
    if (!text().isEmpty()) {
        painter.setPen(palette().buttonText().color());
        painter.drawText(rect, Qt::AlignCenter, text());
    }
}

void IconButton::loadIcon()
{
    if (!m_iconPath.isEmpty()) {
        m_iconPixmap = QPixmap(m_iconPath).scaled(m_iconSize, 
            Qt::KeepAspectRatio, Qt::SmoothTransformation);
    }
}
EOF

print_success "创建 IconButton.h/IconButton.cpp"

cat > src/views/widgets/StatusBar.h << 'EOF'
#ifndef STATUSBAR_H
#define STATUSBAR_H

#include <QStatusBar>
#include <QLabel>
#include <QProgressBar>

class StatusBar : public QStatusBar
{
    Q_OBJECT
    
public:
    explicit StatusBar(QWidget *parent = nullptr);
    virtual ~StatusBar();
    
    // 状态管理
    void showMessage(const QString &message, int timeout = 0);
    void clearMessage();
    
    // 进度条管理
    void showProgress(int value, int maximum = 100);
    void hideProgress();
    
    // 状态指示器
    void setStatusIndicator(bool success, const QString &message = QString());
    
private:
    QLabel *m_messageLabel;
    QProgressBar *m_progressBar;
    QLabel *m_statusIndicator;
    
    void setupUi();
};

#endif // STATUSBAR_H
EOF

cat > src/views/widgets/StatusBar.cpp << 'EOF'
#include "StatusBar.h"
#include <QHBoxLayout>
#include <QDebug>

StatusBar::StatusBar(QWidget *parent)
    : QStatusBar(parent)
{
    setupUi();
    qDebug() << "StatusBar 已创建";
}

StatusBar::~StatusBar()
{
    qDebug() << "StatusBar 已销毁";
}

void StatusBar::setupUi()
{
    // 消息标签
    m_messageLabel = new QLabel(this);
    m_messageLabel->setText(tr("就绪"));
    m_messageLabel->setMinimumWidth(200);
    addWidget(m_messageLabel);
    
    // 添加伸缩弹簧
    QWidget* spacer = new QWidget(this);
    spacer->setSizePolicy(QSizePolicy::Expanding, QSizePolicy::Preferred);
    addWidget(spacer, 1);
    
    // 进度条
    m_progressBar = new QProgressBar(this);
    m_progressBar->setRange(0, 100);
    m_progressBar->setValue(0);
    m_progressBar->setTextVisible(true);
    m_progressBar->setFixedWidth(150);
    m_progressBar->hide();
    addPermanentWidget(m_progressBar);
    
    // 状态指示器
    m_statusIndicator = new QLabel(this);
    m_statusIndicator->setFixedSize(16, 16);
    m_statusIndicator->setStyleSheet("QLabel { background-color: gray; border-radius: 8px; }");
    addPermanentWidget(m_statusIndicator);
}

void StatusBar::showMessage(const QString &message, int timeout)
{
    m_messageLabel->setText(message);
    QStatusBar::showMessage(message, timeout);
    qDebug() << "状态栏消息:" << message;
}

void StatusBar::clearMessage()
{
    m_messageLabel->setText(tr("就绪"));
    QStatusBar::clearMessage();
}

void StatusBar::showProgress(int value, int maximum)
{
    m_progressBar->setRange(0, maximum);
    m_progressBar->setValue(value);
    m_progressBar->show();
}

void StatusBar::hideProgress()
{
    m_progressBar->hide();
}

void StatusBar::setStatusIndicator(bool success, const QString &message)
{
    if (success) {
        m_statusIndicator->setStyleSheet("QLabel { background-color: #4CAF50; border-radius: 8px; }");
        if (!message.isEmpty()) {
            showMessage(message, 3000);
        }
    } else {
        m_statusIndicator->setStyleSheet("QLabel { background-color: #F44336; border-radius: 8px; }");
        if (!message.isEmpty()) {
            showMessage(message, 5000);
        }
    }
}
EOF

print_success "创建 StatusBar.h/StatusBar.cpp"

# 4.7 创建views/dialogs模块文件 - 修复语法和包含错误
print_msg "创建views/dialogs模块文件..."
cat > src/views/dialogs/BaseDialog.h << 'EOF'
#ifndef BASEDIALOG_H
#define BASEDIALOG_H

#include <QDialog>
#include <QPushButton>
#include <QDialogButtonBox>
#include <QString>
#include <QIcon>

class BaseDialogPrivate;

class BaseDialog : public QDialog
{
    Q_OBJECT
    
public:
    explicit BaseDialog(QWidget *parent = nullptr);
    virtual ~BaseDialog();
    
    // 按钮管理
    void addButton(const QString &text, QDialogButtonBox::ButtonRole role);
    void setStandardButtons(QDialogButtonBox::StandardButtons buttons);
    
    // 标题和图标
    void setDialogTitle(const QString &title);
    void setDialogIcon(const QIcon &icon);
    
protected:
    // 提供对d指针的受保护访问
    BaseDialogPrivate* dialogPrivate() const;
    
    // 子类需要重写的方法
    virtual void setupContent() = 0;
    virtual void setupConnections();
    virtual void applyChanges();
    virtual void rejectChanges();
    
    // UI组件
    QPushButton *button(QDialogButtonBox::StandardButton which) const;
    
protected slots:
    void onAccepted();
    void onRejected();
    
private:
    BaseDialogPrivate *d;
    
    void setupUi();
};

#endif // BASEDIALOG_H
EOF
print_success "修复 BaseDialog.h"

# 修复 views/dialogs/BaseDialog.cpp
cat > src/views/dialogs/BaseDialog.cpp << 'EOF'
#include "BaseDialog.h"
#include <QVBoxLayout>
#include <QHBoxLayout>
#include <QLabel>
#include <QDialogButtonBox>
#include <QFrame>
#include <QDebug>

class BaseDialogPrivate
{
public:
    QLabel *titleLabel = nullptr;
    QLabel *iconLabel = nullptr;
    QFrame *contentFrame = nullptr;
    QDialogButtonBox *buttonBox = nullptr;
    QVBoxLayout *mainLayout = nullptr;
};

BaseDialogPrivate* BaseDialog::dialogPrivate() const
{
    return d;
}

BaseDialog::BaseDialog(QWidget *parent)
    : QDialog(parent)
    , d(new BaseDialogPrivate)
{
    setWindowFlags(windowFlags() & ~Qt::WindowContextHelpButtonHint);
    setupUi();
    qDebug() << "BaseDialog 已创建";
}

BaseDialog::~BaseDialog()
{
    delete d;
    qDebug() << "BaseDialog 已销毁";
}

void BaseDialog::setupUi()
{
    // 创建主布局
    QVBoxLayout *mainLayout = new QVBoxLayout(this);
    
    // 标题栏
    QHBoxLayout *titleLayout = new QHBoxLayout();
    
    d->iconLabel = new QLabel(this);
    d->iconLabel->setFixedSize(32, 32);
    titleLayout->addWidget(d->iconLabel);
    
    d->titleLabel = new QLabel(this);
    QFont titleFont = d->titleLabel->font();
    titleFont.setPointSize(12);
    titleFont.setBold(true);
    d->titleLabel->setFont(titleFont);
    titleLayout->addWidget(d->titleLabel);
    
    titleLayout->addStretch();
    mainLayout->addLayout(titleLayout);
    
    // 分隔线
    QFrame *line = new QFrame(this);
    line->setFrameShape(QFrame::HLine);
    line->setFrameShadow(QFrame::Sunken);
    mainLayout->addWidget(line);
    
    // 内容区域 - 留空被子类填充
    d->contentFrame = new QFrame(this);
    mainLayout->addWidget(d->contentFrame, 1); // 添加拉伸因子
    
    // 按钮区域
    d->buttonBox = new QDialogButtonBox(this);
    d->buttonBox->setStandardButtons(QDialogButtonBox::Ok | QDialogButtonBox::Cancel);
    connect(d->buttonBox, &QDialogButtonBox::accepted, this, &BaseDialog::onAccepted);
    connect(d->buttonBox, &QDialogButtonBox::rejected, this, &BaseDialog::onRejected);
    
    mainLayout->addWidget(d->buttonBox);
    
    // 设置默认大小
    resize(400, 300);
}

void BaseDialog::addButton(const QString &text, QDialogButtonBox::ButtonRole role)
{
    d->buttonBox->addButton(text, role);
}

void BaseDialog::setStandardButtons(QDialogButtonBox::StandardButtons buttons)
{
    d->buttonBox->setStandardButtons(buttons);
}

void BaseDialog::setDialogTitle(const QString &title)
{
    d->titleLabel->setText(title);
    setWindowTitle(title);
}

void BaseDialog::setDialogIcon(const QIcon &icon)
{
    d->iconLabel->setPixmap(icon.pixmap(32, 32));
}

QPushButton *BaseDialog::button(QDialogButtonBox::StandardButton which) const
{
    return d->buttonBox->button(which);
}

void BaseDialog::setupConnections()
{
    // 子类可以重写此方法添加额外的信号槽连接
}

void BaseDialog::applyChanges()
{
    // 子类重写此方法以应用更改
}

void BaseDialog::rejectChanges()
{
    // 子类重写此方法以拒绝更改
}

void BaseDialog::onAccepted()
{
    applyChanges();
    accept();
}

void BaseDialog::onRejected()
{
    rejectChanges();
    reject();
}
EOF

print_success "创建 BaseDialog.h/BaseDialog.cpp"

# SettingsDialog.h - 修复包含错误
cat > src/views/dialogs/SettingsDialog.h << 'EOF'
#ifndef SETTINGSDIALOG_H
#define SETTINGSDIALOG_H

#include "BaseDialog.h"
#include <QTabWidget>
#include <QListWidget>

class SettingsDialog : public BaseDialog
{
    Q_OBJECT
    
public:
    explicit SettingsDialog(QWidget *parent = nullptr);
    virtual ~SettingsDialog();
    
protected:
    // BaseDialog 接口实现
    void setupContent() override;
    void setupConnections() override;
    void applyChanges() override;
    void rejectChanges() override;
    
private:
    void setupGeneralTab();
    void setupAppearanceTab();
    void setupAdvancedTab();
    
    QTabWidget *m_tabWidget;
    QListWidget *m_categoryList;
    
    // 通用设置
    class GeneralSettings;
    GeneralSettings *m_generalSettings;
    
    // 外观设置
    class AppearanceSettings;
    AppearanceSettings *m_appearanceSettings;
    
    // 高级设置
    class AdvancedSettings;
    AdvancedSettings *m_advancedSettings;
};

#endif // SETTINGSDIALOG_H
EOF

# SettingsDialog.cpp - 修复包含和语法错误
cat > src/views/dialogs/SettingsDialog.cpp << 'EOF'
#include "SettingsDialog.h"
#include "core/AppConfig.h"
#include "core/AppTheme.h"
#include <QVBoxLayout>
#include <QHBoxLayout>
#include <QGroupBox>
#include <QCheckBox>
#include <QComboBox>
#include <QSpinBox>
#include <QLineEdit>
#include <QFormLayout>  // 添加这行
#include <QDebug>

class SettingsDialog::GeneralSettings
{
public:
    QCheckBox *autoStartCheckBox = nullptr;
    QCheckBox *checkUpdatesCheckBox = nullptr;
    QCheckBox *enableNotificationsCheckBox = nullptr;
};

class SettingsDialog::AppearanceSettings
{
public:
    QComboBox *themeComboBox = nullptr;
    QComboBox *languageComboBox = nullptr;
    QSpinBox *fontSizeSpinBox = nullptr;
};

class SettingsDialog::AdvancedSettings
{
public:
    QLineEdit *logPathLineEdit = nullptr;
    QSpinBox *logLevelSpinBox = nullptr;
    QCheckBox *enableDebugCheckBox = nullptr;
};

SettingsDialog::SettingsDialog(QWidget *parent)
    : BaseDialog(parent)
    , m_generalSettings(new GeneralSettings)
    , m_appearanceSettings(new AppearanceSettings)
    , m_advancedSettings(new AdvancedSettings)
{
    setDialogTitle(tr("设置"));
    setDialogIcon(QIcon::fromTheme("preferences-system"));
    
    setupContent();
    setupConnections();
    
    qDebug() << "SettingsDialog 已创建";
}

SettingsDialog::~SettingsDialog()
{
    delete m_generalSettings;
    delete m_appearanceSettings;
    delete m_advancedSettings;
    qDebug() << "SettingsDialog 已销毁";
}

void SettingsDialog::setupContent()
{
    // 获取对话框的内容区域
    QWidget *contentWidget = new QWidget();
    QHBoxLayout *mainLayout = new QHBoxLayout(contentWidget);
    
    m_categoryList = new QListWidget(contentWidget);
    m_categoryList->setFixedWidth(120);
    m_categoryList->addItem(tr("通用"));
    m_categoryList->addItem(tr("外观"));
    m_categoryList->addItem(tr("高级"));
    mainLayout->addWidget(m_categoryList);
    
    // 创建右侧标签页
    m_tabWidget = new QTabWidget(contentWidget);
    m_tabWidget->setDocumentMode(true);
    mainLayout->addWidget(m_tabWidget);
    
    // 创建各个标签页
    setupGeneralTab();
    setupAppearanceTab();
    setupAdvancedTab();
    
    // 将内容widget设置为对话框的布局widget
    QVBoxLayout *dialogLayout = new QVBoxLayout(this);
    dialogLayout->addWidget(contentWidget);
    
    // 连接分类列表和标签页
    connect(m_categoryList, &QListWidget::currentRowChanged,
            m_tabWidget, &QTabWidget::setCurrentIndex);
}

void SettingsDialog::setupGeneralTab()
{
    QWidget *generalTab = new QWidget();
    QVBoxLayout *layout = new QVBoxLayout(generalTab);
    
    // 启动设置组
    QGroupBox *startupGroup = new QGroupBox(tr("启动设置"), generalTab);
    QVBoxLayout *startupLayout = new QVBoxLayout(startupGroup);
    
    m_generalSettings->autoStartCheckBox = new QCheckBox(tr("开机自动启动"), startupGroup);
    m_generalSettings->checkUpdatesCheckBox = new QCheckBox(tr("启动时检查更新"), startupGroup);
    
    startupLayout->addWidget(m_generalSettings->autoStartCheckBox);
    startupLayout->addWidget(m_generalSettings->checkUpdatesCheckBox);
    startupGroup->setLayout(startupLayout);
    
    // 通知设置组
    QGroupBox *notificationGroup = new QGroupBox(tr("通知设置"), generalTab);
    QVBoxLayout *notificationLayout = new QVBoxLayout(notificationGroup);
    
    m_generalSettings->enableNotificationsCheckBox = new QCheckBox(tr("启用通知"), notificationGroup);
    
    notificationLayout->addWidget(m_generalSettings->enableNotificationsCheckBox);
    notificationGroup->setLayout(notificationLayout);
    
    layout->addWidget(startupGroup);
    layout->addWidget(notificationGroup);
    layout->addStretch();
    
    generalTab->setLayout(layout);
    m_tabWidget->addTab(generalTab, tr("通用"));
}

void SettingsDialog::setupAppearanceTab()
{
    QWidget *appearanceTab = new QWidget();
    QVBoxLayout *layout = new QVBoxLayout(appearanceTab);
    
    // 主题设置组
    QGroupBox *themeGroup = new QGroupBox(tr("主题设置"), appearanceTab);
    QFormLayout *themeLayout = new QFormLayout();  // 修改这里
    themeGroup->setLayout(themeLayout);  // 先设置布局
    
    m_appearanceSettings->themeComboBox = new QComboBox(themeGroup);
    m_appearanceSettings->themeComboBox->addItem(tr("浅色"), "light");
    m_appearanceSettings->themeComboBox->addItem(tr("深色"), "dark");
    m_appearanceSettings->themeComboBox->addItem(tr("自动"), "auto");
    
    m_appearanceSettings->languageComboBox = new QComboBox(themeGroup);
    m_appearanceSettings->languageComboBox->addItem(tr("简体中文"), "zh_CN");
    m_appearanceSettings->languageComboBox->addItem(tr("English"), "en_US");
    
    themeLayout->addRow(tr("主题:"), m_appearanceSettings->themeComboBox);
    themeLayout->addRow(tr("语言:"), m_appearanceSettings->languageComboBox);
    
    // 字体设置组
    QGroupBox *fontGroup = new QGroupBox(tr("字体设置"), appearanceTab);
    QFormLayout *fontLayout = new QFormLayout();  // 修改这里
    fontGroup->setLayout(fontLayout);  // 先设置布局
    
    m_appearanceSettings->fontSizeSpinBox = new QSpinBox(fontGroup);
    m_appearanceSettings->fontSizeSpinBox->setRange(8, 20);
    m_appearanceSettings->fontSizeSpinBox->setValue(11);
    
    fontLayout->addRow(tr("字体大小:"), m_appearanceSettings->fontSizeSpinBox);
    
    layout->addWidget(themeGroup);
    layout->addWidget(fontGroup);
    layout->addStretch();
    
    appearanceTab->setLayout(layout);
    m_tabWidget->addTab(appearanceTab, tr("外观"));
}

void SettingsDialog::setupAdvancedTab()
{
    QWidget *advancedTab = new QWidget();
    QVBoxLayout *layout = new QVBoxLayout(advancedTab);
    
    // 日志设置组
    QGroupBox *logGroup = new QGroupBox(tr("日志设置"), advancedTab);
    QFormLayout *logLayout = new QFormLayout();  // 修改这里
    logGroup->setLayout(logLayout);  // 先设置布局
    
    m_advancedSettings->logPathLineEdit = new QLineEdit(logGroup);
    m_advancedSettings->logLevelSpinBox = new QSpinBox(logGroup);
    m_advancedSettings->logLevelSpinBox->setRange(0, 4);
    m_advancedSettings->logLevelSpinBox->setValue(2);
    
    logLayout->addRow(tr("日志路径:"), m_advancedSettings->logPathLineEdit);
    logLayout->addRow(tr("日志级别:"), m_advancedSettings->logLevelSpinBox);
    
    // 调试设置组
    QGroupBox *debugGroup = new QGroupBox(tr("调试设置"), advancedTab);
    QVBoxLayout *debugLayout = new QVBoxLayout(debugGroup);
    
    m_advancedSettings->enableDebugCheckBox = new QCheckBox(tr("启用调试模式"), debugGroup);
    
    debugLayout->addWidget(m_advancedSettings->enableDebugCheckBox);
    debugGroup->setLayout(debugLayout);
    
    layout->addWidget(logGroup);
    layout->addWidget(debugGroup);
    layout->addStretch();
    
    advancedTab->setLayout(layout);
    m_tabWidget->addTab(advancedTab, tr("高级"));
}

void SettingsDialog::setupConnections()
{
    BaseDialog::setupConnections();
    
    // 加载配置
    AppConfig &config = AppConfig::instance();
    
    // 通用设置
    m_generalSettings->autoStartCheckBox->setChecked(
        config.value("General/AutoStart", false).toBool());
    m_generalSettings->checkUpdatesCheckBox->setChecked(
        config.value("General/CheckUpdates", true).toBool());
    m_generalSettings->enableNotificationsCheckBox->setChecked(
        config.value("General/EnableNotifications", true).toBool());
    
    // 外观设置
    QString theme = config.value("Appearance/Theme", "light").toString();
    int themeIndex = m_appearanceSettings->themeComboBox->findData(theme);
    if (themeIndex >= 0) {
        m_appearanceSettings->themeComboBox->setCurrentIndex(themeIndex);
    }
    
    QString language = config.value("Appearance/Language", "zh_CN").toString();
    int langIndex = m_appearanceSettings->languageComboBox->findData(language);
    if (langIndex >= 0) {
        m_appearanceSettings->languageComboBox->setCurrentIndex(langIndex);
    }
    
    m_appearanceSettings->fontSizeSpinBox->setValue(
        config.value("Appearance/FontSize", 11).toInt());
    
    // 高级设置
    m_advancedSettings->logPathLineEdit->setText(
        config.value("Advanced/LogPath", "").toString());
    m_advancedSettings->logLevelSpinBox->setValue(
        config.value("Advanced/LogLevel", 2).toInt());
    m_advancedSettings->enableDebugCheckBox->setChecked(
        config.value("Advanced/EnableDebug", false).toBool());
}

void SettingsDialog::applyChanges()
{
    AppConfig &config = AppConfig::instance();
    
    // 保存通用设置
    config.setValue("General/AutoStart", m_generalSettings->autoStartCheckBox->isChecked());
    config.setValue("General/CheckUpdates", m_generalSettings->checkUpdatesCheckBox->isChecked());
    config.setValue("General/EnableNotifications", m_generalSettings->enableNotificationsCheckBox->isChecked());
    
    // 保存外观设置
    config.setValue("Appearance/Theme", 
        m_appearanceSettings->themeComboBox->currentData().toString());
    config.setValue("Appearance/Language",
        m_appearanceSettings->languageComboBox->currentData().toString());
    config.setValue("Appearance/FontSize", m_appearanceSettings->fontSizeSpinBox->value());
    
    // 保存高级设置
    config.setValue("Advanced/LogPath", m_advancedSettings->logPathLineEdit->text());
    config.setValue("Advanced/LogLevel", m_advancedSettings->logLevelSpinBox->value());
    config.setValue("Advanced/EnableDebug", m_advancedSettings->enableDebugCheckBox->isChecked());
    
    // 应用主题更改
    QString theme = m_appearanceSettings->themeComboBox->currentData().toString();
    if (theme == "light") {
        AppTheme::instance().setTheme(AppTheme::LightMode);
    } else if (theme == "dark") {
        AppTheme::instance().setTheme(AppTheme::DarkMode);
    }
    
    qDebug() << "设置已保存";
}

void SettingsDialog::rejectChanges()
{
    qDebug() << "设置已取消";
}
EOF

print_success "创建 SettingsDialog.h/SettingsDialog.cpp"

# 4.8 简化创建views/pages模块文件
print_msg "创建views/pages模块文件..."

# HomePage.h - 修复包含错误
cat > src/views/pages/HomePage.h << 'EOF'
#ifndef HOMEPAGE_H
#define HOMEPAGE_H

#include <QWidget>
#include "viewmodels/MainViewModel.h"

class HomePage : public QWidget
{
    Q_OBJECT
    
public:
    explicit HomePage(QWidget *parent = nullptr);
    virtual ~HomePage();
    
    void setViewModel(MainViewModel *viewModel);
    
private slots:
    void onAddItemClicked();
    void onRemoveItemClicked();
    void onItemDoubleClicked(const QModelIndex &index);
    
private:
    void setupUi();
    void setupConnections();
    void updateView();
    
    MainViewModel *m_viewModel;
    class Private;
    Private *d;
};

#endif // HOMEPAGE_H
EOF

# HomePage.cpp - 创建简化版本
cat > src/views/pages/HomePage.cpp << 'EOF'
#include "HomePage.h"
#include "views/widgets/CustomButton.h"
#include <QVBoxLayout>
#include <QHBoxLayout>
#include <QListView>
#include <QLabel>
#include <QLineEdit>
#include <QPushButton>
#include <QGroupBox>
#include <QDebug>

class HomePage::Private
{
public:
    QListView *itemListView = nullptr;
    QLineEdit *itemNameEdit = nullptr;
    CustomButton *addButton = nullptr;
    CustomButton *removeButton = nullptr;
    CustomButton *refreshButton = nullptr;
    QLabel *statusLabel = nullptr;
};

HomePage::HomePage(QWidget *parent)
    : QWidget(parent)
    , m_viewModel(nullptr)
    , d(new Private)
{
    setupUi();
    setupConnections();
    qDebug() << "HomePage 已创建";
}

HomePage::~HomePage()
{
    delete d;
    qDebug() << "HomePage 已销毁";
}

void HomePage::setViewModel(MainViewModel *viewModel)
{
    m_viewModel = viewModel;
    if (m_viewModel) {
        d->itemListView->setModel(m_viewModel->itemModel());
        updateView();
    }
}

void HomePage::setupUi()
{
    QVBoxLayout *mainLayout = new QVBoxLayout(this);
    
    // 标题
    QLabel *titleLabel = new QLabel(tr("首页"), this);
    QFont titleFont = titleLabel->font();
    titleFont.setPointSize(16);
    titleFont.setBold(true);
    titleLabel->setFont(titleFont);
    titleLabel->setAlignment(Qt::AlignCenter);
    mainLayout->addWidget(titleLabel);
    
    // 操作区域
    QGroupBox *actionGroupBox = new QGroupBox(tr("操作"), this);
    QHBoxLayout *actionLayout = new QHBoxLayout(actionGroupBox);
    
    d->itemNameEdit = new QLineEdit(actionGroupBox);
    d->itemNameEdit->setPlaceholderText(tr("输入项目名称..."));
    actionLayout->addWidget(d->itemNameEdit);
    
    d->addButton = new CustomButton(tr("添加"), actionGroupBox);
    actionLayout->addWidget(d->addButton);
    
    d->removeButton = new CustomButton(tr("删除"), actionGroupBox);
    actionLayout->addWidget(d->removeButton);
    
    d->refreshButton = new CustomButton(tr("刷新"), actionGroupBox);
    actionLayout->addWidget(d->refreshButton);
    
    actionGroupBox->setLayout(actionLayout);
    mainLayout->addWidget(actionGroupBox);
    
    // 列表区域
    QGroupBox *listGroupBox = new QGroupBox(tr("项目列表"), this);
    QVBoxLayout *listLayout = new QVBoxLayout(listGroupBox);
    
    d->itemListView = new QListView(listGroupBox);
    d->itemListView->setAlternatingRowColors(true);
    d->itemListView->setSelectionMode(QListView::SingleSelection);
    listLayout->addWidget(d->itemListView);
    
    listGroupBox->setLayout(listLayout);
    mainLayout->addWidget(listGroupBox, 1);
    
    // 信息区域
    QGroupBox *infoGroupBox = new QGroupBox(tr("信息"), this);
    QVBoxLayout *infoLayout = new QVBoxLayout(infoGroupBox);
    
    d->statusLabel = new QLabel(tr("就绪"), infoGroupBox);
    infoLayout->addWidget(d->statusLabel);
    
    infoGroupBox->setLayout(infoLayout);
    mainLayout->addWidget(infoGroupBox);
    
    setLayout(mainLayout);
}

void HomePage::setupConnections()
{
    connect(d->addButton, &CustomButton::clicked, this, &HomePage::onAddItemClicked);
    connect(d->removeButton, &CustomButton::clicked, this, &HomePage::onRemoveItemClicked);
    connect(d->refreshButton, &CustomButton::clicked, this, &HomePage::updateView);
    connect(d->itemListView, &QListView::doubleClicked, this, &HomePage::onItemDoubleClicked);
}

void HomePage::onAddItemClicked()
{
    if (!m_viewModel) return;
    
    QString itemName = d->itemNameEdit->text().trimmed();
    if (itemName.isEmpty()) {
        d->statusLabel->setText(tr("错误: 项目名称不能为空"));
        d->statusLabel->setStyleSheet("color: red;");
        return;
    }
    
    m_viewModel->addNewItem(itemName);
    d->itemNameEdit->clear();
    d->statusLabel->setText(tr("已添加项目: %1").arg(itemName));
    d->statusLabel->setStyleSheet("color: green;");
}

void HomePage::onRemoveItemClicked()
{
    if (!m_viewModel) return;
    
    QModelIndex currentIndex = d->itemListView->currentIndex();
    if (!currentIndex.isValid()) {
        d->statusLabel->setText(tr("错误: 请先选择一个项目"));
        d->statusLabel->setStyleSheet("color: red;");
        return;
    }
    
    m_viewModel->removeSelectedItem(currentIndex.row());
    d->statusLabel->setText(tr("已删除选定项目"));
    d->statusLabel->setStyleSheet("color: orange;");
}

void HomePage::onItemDoubleClicked(const QModelIndex &index)
{
    if (!m_viewModel || !index.isValid()) return;
    
    DataItem *item = m_viewModel->itemModel()->itemAt(index.row());
    if (item) {
        d->statusLabel->setText(tr("已选择: %1 (ID: %2)").arg(item->name(), item->id()));
        d->statusLabel->setStyleSheet("color: blue;");
    }
}

void HomePage::updateView()
{
    if (m_viewModel) {
        m_viewModel->refresh();
        int count = m_viewModel->itemModel()->rowCount();
        d->statusLabel->setText(tr("共有 %1 个项目").arg(count));
        d->statusLabel->setStyleSheet("");
    }
}
EOF

print_success "创建 HomePage.h/HomePage.cpp"

# 4.9 创建services模块文件 - 创建可编译的简化版本
print_msg "创建services模块文件..."

# DatabaseService.h - 简化版本
cat > src/services/DatabaseService.h << 'EOF'
#ifndef DATABASESERVICE_H
#define DATABASESERVICE_H

#include <QObject>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QVariantList>
#include <QString>

class DatabaseService : public QObject
{
    Q_OBJECT
    
public:
    static DatabaseService& instance();
    
    // 数据库管理
    bool initialize(const QString& databasePath = QString());
    void shutdown();
    
    // 连接管理
    QSqlDatabase connection() const;
    
    // 数据操作
    bool executeQuery(const QString& query, const QVariantList& params = QVariantList());
    QVariantList executeSelect(const QString& query, const QVariantList& params = QVariantList());
    
    // 状态查询
    bool isConnected() const;
    QString lastError() const;
    
signals:
    void databaseConnected(bool success);
    void databaseError(const QString& error);
    
private:
    DatabaseService(QObject *parent = nullptr);
    ~DatabaseService();
    
    class Private;
    Private *d;
};

#endif // DATABASESERVICE_H
EOF

cat > src/services/DatabaseService.cpp << 'EOF'
#include "DatabaseService.h"
#include <QSqlError>
#include <QSqlRecord>  // 添加这行
#include <QStandardPaths>
#include <QDir>
#include <QDebug>

class DatabaseService::Private
{
public:
    QSqlDatabase mainDatabase;
    QString lastErrorMessage;
    bool initialized = false;
};

DatabaseService& DatabaseService::instance()
{
    static DatabaseService instance;
    return instance;
}

DatabaseService::DatabaseService(QObject *parent)
    : QObject(parent)
    , d(new Private)
{
    qDebug() << "DatabaseService 已创建";
}

DatabaseService::~DatabaseService()
{
    shutdown();
    delete d;
    qDebug() << "DatabaseService 已销毁";
}

bool DatabaseService::initialize(const QString& databasePath)
{
    if (d->initialized) {
        return true;
    }
    
    // 确定数据库路径
    QString dbPath = databasePath;
    if (dbPath.isEmpty()) {
        QString dataDir = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
        QDir().mkpath(dataDir);
        dbPath = dataDir + "/application.db";
    }
    
    // 创建数据库连接
    d->mainDatabase = QSqlDatabase::addDatabase("QSQLITE");
    d->mainDatabase.setDatabaseName(dbPath);
    
    if (!d->mainDatabase.open()) {
        d->lastErrorMessage = d->mainDatabase.lastError().text();
        qCritical() << "数据库打开失败:" << d->lastErrorMessage;
        emit databaseError(d->lastErrorMessage);
        return false;
    }
    
    d->initialized = true;
    
    // 创建必要的表
    QStringList createTables = {
        "CREATE TABLE IF NOT EXISTS items ("
        "id TEXT PRIMARY KEY,"
        "name TEXT NOT NULL,"
        "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,"
        "updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP"
        ")"
    };
    
    for (const QString& sql : createTables) {
        if (!executeQuery(sql)) {
            qWarning() << "创建表失败:" << sql;
        }
    }
    
    qDebug() << "数据库已初始化:" << dbPath;
    emit databaseConnected(true);
    return true;
}

void DatabaseService::shutdown()
{
    if (d->initialized) {
        d->mainDatabase.close();
        d->initialized = false;
        qDebug() << "数据库已关闭";
    }
}

QSqlDatabase DatabaseService::connection() const
{
    return d->mainDatabase;
}

bool DatabaseService::executeQuery(const QString& query, const QVariantList& params)
{
    if (!d->initialized) {
        d->lastErrorMessage = "数据库未初始化";
        return false;
    }
    
    QSqlQuery sqlQuery(d->mainDatabase);
    sqlQuery.prepare(query);
    
    for (int i = 0; i < params.size(); ++i) {
        sqlQuery.bindValue(i, params[i]);
    }
    
    if (!sqlQuery.exec()) {
        d->lastErrorMessage = sqlQuery.lastError().text();
        qWarning() << "查询执行失败:" << query << "错误:" << d->lastErrorMessage;
        return false;
    }
    
    return true;
}

QVariantList DatabaseService::executeSelect(const QString& query, const QVariantList& params)
{
    QVariantList results;
    
    if (!d->initialized) {
        d->lastErrorMessage = "数据库未初始化";
        return results;
    }
    
    QSqlQuery sqlQuery(d->mainDatabase);
    sqlQuery.prepare(query);
    
    for (int i = 0; i < params.size(); ++i) {
        sqlQuery.bindValue(i, params[i]);
    }
    
    if (!sqlQuery.exec()) {
        d->lastErrorMessage = sqlQuery.lastError().text();
        qWarning() << "查询执行失败:" << query << "错误:" << d->lastErrorMessage;
        return results;
    }
    
    while (sqlQuery.next()) {
        QVariantMap row;
        QSqlRecord record = sqlQuery.record();  // 使用完整的QSqlRecord对象
        for (int i = 0; i < record.count(); ++i) {
            row[record.fieldName(i)] = sqlQuery.value(i);
        }
        results.append(row);
    }
    
    return results;
}

bool DatabaseService::isConnected() const
{
    return d->initialized && d->mainDatabase.isOpen();
}

QString DatabaseService::lastError() const
{
    return d->lastErrorMessage;
}
EOF

print_success "创建 DatabaseService.h/DatabaseService.cpp"

# 4.10 创建其他必要的简化文件
print_msg "创建其他必要的文件..."

# 创建简单的服务和管理器文件
for service in "NetworkService" "FileService" "LogService"; do
    cat > "src/services/${service}.h" << EOF
#ifndef ${service^^}_H
#define ${service^^}_H

#include <QObject>
#include <QString>

class ${service} : public QObject
{
    Q_OBJECT
    
public:
    static ${service}& instance();
    
    bool initialize();
    void shutdown();
    
    QString lastError() const;
    
private:
    ${service}(QObject *parent = nullptr);
    ~${service}();
    
    class Private;
    Private *d;
};

#endif // ${service^^}_H
EOF
    
    cat > "src/services/${service}.cpp" << EOF
#include "${service}.h"
#include <QDebug>

class ${service}::Private
{
public:
    QString lastError;
    bool initialized = false;
};

${service}& ${service}::instance()
{
    static ${service} instance;
    return instance;
}

${service}::${service}(QObject *parent)
    : QObject(parent)
    , d(new Private)
{
    qDebug() << "${service} 已创建";
}

${service}::~${service}()
{
    shutdown();
    delete d;
    qDebug() << "${service} 已销毁";
}

bool ${service}::initialize()
{
    if (d->initialized) {
        return true;
    }
    
    d->initialized = true;
    qDebug() << "${service} 已初始化";
    return true;
}

void ${service}::shutdown()
{
    if (d->initialized) {
        d->initialized = false;
        qDebug() << "${service} 已关闭";
    }
}

QString ${service}::lastError() const
{
    return d->lastError;
}
EOF
done

print_success "创建服务层文件"

# 创建管理器文件
for manager in "ResourceManager" "TaskManager" "PluginManager" "EventManager"; do
    cat > "src/managers/${manager}.h" << EOF
#ifndef ${manager^^}_H
#define ${manager^^}_H

#include <QObject>
#include <QString>

class ${manager} : public QObject
{
    Q_OBJECT
    
public:
    static ${manager}& instance();
    
    bool initialize();
    void shutdown();
    
private:
    ${manager}(QObject *parent = nullptr);
    ~${manager}();
    
    class Private;
    Private *d;
};

#endif // ${manager^^}_H
EOF
    
    cat > "src/managers/${manager}.cpp" << EOF
#include "${manager}.h"
#include <QDebug>

class ${manager}::Private
{
public:
    bool initialized = false;
};

${manager}& ${manager}::instance()
{
    static ${manager} instance;
    return instance;
}

${manager}::${manager}(QObject *parent)
    : QObject(parent)
    , d(new Private)
{
    qDebug() << "${manager} 已创建";
}

${manager}::~${manager}()
{
    shutdown();
    delete d;
    qDebug() << "${manager} 已销毁";
}

bool ${manager}::initialize()
{
    if (d->initialized) {
        return true;
    }
    
    d->initialized = true;
    qDebug() << "${manager} 已初始化";
    return true;
}

void ${manager}::shutdown()
{
    if (d->initialized) {
        d->initialized = false;
        qDebug() << "${manager} 已关闭";
    }
}
EOF
done

print_success "创建管理器文件"

# 创建工具类文件
for util in "Logger" "Validator" "Formatter" "FileUtils" "StringUtils"; do
    cat > "src/utils/${util}.h" << EOF
#ifndef ${util^^}_H
#define ${util^^}_H

#include <QString>
#include <QVariant>

class ${util}
{
public:
    static ${util}& instance();
    
    // 基本功能
    QString process(const QString& input);
    bool validate(const QVariant& input);
    
private:
    ${util}();
    ~${util}();
    
    class Private;
    Private *d;
};

#endif // ${util^^}_H
EOF
    
    cat > "src/utils/${util}.cpp" << EOF
#include "${util}.h"
#include <QDebug>

class ${util}::Private
{
public:
    // 私有数据
};

${util}& ${util}::instance()
{
    static ${util} instance;
    return instance;
}

${util}::${util}()
    : d(new Private)
{
    qDebug() << "${util} 已创建";
}

${util}::~${util}()
{
    delete d;
    qDebug() << "${util} 已销毁";
}

QString ${util}::process(const QString& input)
{
    // 基本处理
    return input.trimmed();
}

bool ${util}::validate(const QVariant& input)
{
    // 基本验证
    return !input.toString().isEmpty();
}
EOF
done

print_success "创建工具类文件"

# 创建网络模块文件
for network in "ApiClient" "WebSocketClient" "RestApi"; do
    cat > "src/network/${network}.h" << EOF
#ifndef ${network^^}_H
#define ${network^^}_H

#include <QObject>
#include <QString>

class ${network} : public QObject
{
    Q_OBJECT
    
public:
    static ${network}& instance();
    
    bool initialize();
    void shutdown();
    
private:
    ${network}(QObject *parent = nullptr);
    ~${network}();
    
    class Private;
    Private *d;
};

#endif // ${network^^}_H
EOF
    
    cat > "src/network/${network}.cpp" << EOF
#include "${network}.h"
#include <QDebug>

class ${network}::Private
{
public:
    bool initialized = false;
};

${network}& ${network}::instance()
{
    static ${network} instance;
    return instance;
}

${network}::${network}(QObject *parent)
    : QObject(parent)
    , d(new Private)
{
    qDebug() << "${network} 已创建";
}

${network}::~${network}()
{
    shutdown();
    delete d;
    qDebug() << "${network} 已销毁";
}

bool ${network}::initialize()
{
    if (d->initialized) {
        return true;
    }
    
    d->initialized = true;
    qDebug() << "${network} 已初始化";
    return true;
}

void ${network}::shutdown()
{
    if (d->initialized) {
        d->initialized = false;
        qDebug() << "${network} 已关闭";
    }
}
EOF
done

print_success "创建网络模块文件"

# 创建数据库模块文件
for db in "DatabaseConnection" "SqlQueryBuilder" "Migrations"; do
    cat > "src/database/${db}.h" << EOF
#ifndef ${db^^}_H
#define ${db^^}_H

#include <QObject>
#include <QString>

class ${db} : public QObject
{
    Q_OBJECT
    
public:
    static ${db}& instance();
    
    bool initialize();
    void shutdown();
    
private:
    ${db}(QObject *parent = nullptr);
    ~${db}();
    
    class Private;
    Private *d;
};

#endif // ${db^^}_H
EOF
    
    cat > "src/database/${db}.cpp" << EOF
#include "${db}.h"
#include <QDebug>

class ${db}::Private
{
public:
    bool initialized = false;
};

${db}& ${db}::instance()
{
    static ${db} instance;
    return instance;
}

${db}::${db}(QObject *parent)
    : QObject(parent)
    , d(new Private)
{
    qDebug() << "${db} 已创建";
}

${db}::~${db}()
{
    shutdown();
    delete d;
    qDebug() << "${db} 已销毁";
}

bool ${db}::initialize()
{
    if (d->initialized) {
        return true;
    }
    
    d->initialized = true;
    qDebug() << "${db} 已初始化";
    return true;
}

void ${db}::shutdown()
{
    if (d->initialized) {
        d->initialized = false;
        qDebug() << "${db} 已关闭";
    }
}
EOF
done

print_success "创建数据库模块文件"

# 创建简单的SettingsPage和HelpPage
cat > src/views/pages/SettingsPage.h << 'EOF'
#ifndef SETTINGSPAGE_H
#define SETTINGSPAGE_H

#include <QWidget>

class SettingsPage : public QWidget
{
    Q_OBJECT
    
public:
    explicit SettingsPage(QWidget *parent = nullptr);
    virtual ~SettingsPage();
    
private:
    void setupUi();
};

#endif // SETTINGSPAGE_H
EOF

cat > src/views/pages/SettingsPage.cpp << 'EOF'
#include "SettingsPage.h"
#include <QVBoxLayout>
#include <QLabel>
#include <QDebug>

SettingsPage::SettingsPage(QWidget *parent)
    : QWidget(parent)
{
    setupUi();
    qDebug() << "SettingsPage 已创建";
}

SettingsPage::~SettingsPage()
{
    qDebug() << "SettingsPage 已销毁";
}

void SettingsPage::setupUi()
{
    QVBoxLayout *layout = new QVBoxLayout(this);
    
    QLabel *label = new QLabel(tr("设置页面"), this);
    label->setAlignment(Qt::AlignCenter);
    layout->addWidget(label);
    
    setLayout(layout);
}
EOF

cat > src/views/pages/HelpPage.h << 'EOF'
#ifndef HELPPAGE_H
#define HELPPAGE_H

#include <QWidget>

class HelpPage : public QWidget
{
    Q_OBJECT
    
public:
    explicit HelpPage(QWidget *parent = nullptr);
    virtual ~HelpPage();
    
private:
    void setupUi();
};

#endif // HELPPAGE_H
EOF

cat > src/views/pages/HelpPage.cpp << 'EOF'
#include "HelpPage.h"
#include <QVBoxLayout>
#include <QLabel>
#include <QDebug>

HelpPage::HelpPage(QWidget *parent)
    : QWidget(parent)
{
    setupUi();
    qDebug() << "HelpPage 已创建";
}

HelpPage::~HelpPage()
{
    qDebug() << "HelpPage 已销毁";
}

void HelpPage::setupUi()
{
    QVBoxLayout *layout = new QVBoxLayout(this);
    
    QLabel *label = new QLabel(tr("帮助页面"), this);
    label->setAlignment(Qt::AlignCenter);
    layout->addWidget(label);
    
    setLayout(layout);
}
EOF

print_success "创建 SettingsPage.h/HelpPage.cpp"

# 创建AboutDialog.cpp的修复版本
cat > src/views/dialogs/AboutDialog.h << 'EOF'
#ifndef ABOUTDIALOG_H
#define ABOUTDIALOG_H

#include "BaseDialog.h"

class AboutDialog : public BaseDialog
{
    Q_OBJECT
    
public:
    explicit AboutDialog(QWidget *parent = nullptr);
    virtual ~AboutDialog();
    
protected:
    // BaseDialog 接口实现
    void setupContent() override;
    void setupConnections() override;
    void applyChanges() override {}
    void rejectChanges() override {}
};

#endif // ABOUTDIALOG_H
EOF

cat > src/views/dialogs/AboutDialog.cpp << 'EOF'
#include "AboutDialog.h"
#include <QVBoxLayout>
#include <QLabel>
#include <QTextBrowser>
#include <QApplication>  // 添加这行，替换qApp
#include <QDebug>

AboutDialog::AboutDialog(QWidget *parent)
    : BaseDialog(parent)
{
    setDialogTitle(tr("关于"));
    setupContent();
    setupConnections();
    
    qDebug() << "AboutDialog 已创建";
}

AboutDialog::~AboutDialog()
{
    qDebug() << "AboutDialog 已销毁";
}

void AboutDialog::setupContent()
{
    // 创建内容widget
    QWidget *contentWidget = new QWidget();
    QVBoxLayout *layout = new QVBoxLayout(contentWidget);
    
    QLabel *titleLabel = new QLabel(QApplication::applicationName(), contentWidget);
    QFont titleFont = titleLabel->font();
    titleFont.setPointSize(16);
    titleFont.setBold(true);
    titleLabel->setFont(titleFont);
    titleLabel->setAlignment(Qt::AlignCenter);
    layout->addWidget(titleLabel);
    
    QLabel *versionLabel = new QLabel(
        tr("版本: %1").arg(QApplication::applicationVersion()), 
        contentWidget
    );
    versionLabel->setAlignment(Qt::AlignCenter);
    layout->addWidget(versionLabel);
    
    QTextBrowser *textBrowser = new QTextBrowser(contentWidget);
    textBrowser->setPlainText(
        tr("这是一个基于 Qt 5.12 的应用程序。\n\n")
        + tr("版权所有 © 2023 %1").arg(QApplication::organizationName())
    );
    layout->addWidget(textBrowser);
    
    // 将内容widget设置为对话框的布局widget
    QVBoxLayout *dialogLayout = new QVBoxLayout(this);
    dialogLayout->addWidget(contentWidget);
}

void AboutDialog::setupConnections()
{
    BaseDialog::setupConnections();
}
EOF

cat > src/core/MainWindow.h << 'EOF'
#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QScopedPointer>

class MainWindowPrivate;

class MainWindow : public QMainWindow
{
    Q_OBJECT
    
public:
    explicit MainWindow(QWidget *parent = nullptr);
    virtual ~MainWindow();
    
public slots:
    void showSettingsDialog();
    void showAboutDialog();
    
private slots:
    void createFileMenu();
    void createHelpMenu();
    
private:
    QScopedPointer<MainWindowPrivate> d_ptr;
    Q_DECLARE_PRIVATE(MainWindow)
};
#endif // MAINWINDOW_H
EOF

# 创建 MainWindow.cpp
cat > src/core/MainWindow.cpp << 'EOF'
#include "MainWindow.h"
#include <QMenuBar>
#include <QAction>
#include <QKeySequence>
#include <QDebug>

class MainWindowPrivate
{
public:
    QAction* exitAction = nullptr;
    QAction* settingsAction = nullptr;
    QAction* aboutAction = nullptr;
};

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
    , d_ptr(new MainWindowPrivate)
{
    setWindowTitle(tr("My Qt Application"));
    resize(1024, 768);
    
    createFileMenu();
    createHelpMenu();
    
    qDebug() << "主窗口已创建";
}

MainWindow::~MainWindow()
{
    qDebug() << "主窗口已销毁";
}

void MainWindow::showSettingsDialog()
{
    qDebug() << "显示设置对话框";
}

void MainWindow::showAboutDialog()
{
    qDebug() << "显示关于对话框";
}

void MainWindow::createFileMenu()
{
    Q_D(MainWindow);
    
    QMenu* fileMenu = menuBar()->addMenu(tr("文件(&F)"));
    
    d->exitAction = new QAction(tr("退出(&Q)"), this);
    d->exitAction->setShortcut(QKeySequence::Quit);
    connect(d->exitAction, &QAction::triggered, this, &MainWindow::close);
    
    fileMenu->addAction(d->exitAction);
}

void MainWindow::createHelpMenu()
{
    Q_D(MainWindow);
    
    QMenu* helpMenu = menuBar()->addMenu(tr("帮助(&H)"));
    
    d->settingsAction = new QAction(tr("设置(&S)"), this);
    d->settingsAction->setShortcut(QKeySequence::Preferences);
    connect(d->settingsAction, &QAction::triggered, this, &MainWindow::showSettingsDialog);
    
    d->aboutAction = new QAction(tr("关于(&A)"), this);
    connect(d->aboutAction, &QAction::triggered, this, &MainWindow::showAboutDialog);
    
    helpMenu->addAction(d->settingsAction);
    helpMenu->addSeparator();
    helpMenu->addAction(d->aboutAction);
}
EOF

# 创建其他必要的文件
for file in "src/models/BaseModel.h" "src/models/DataItem.h" "src/models/DataItem.cpp" "src/models/ListModel.h" \
            "src/viewmodels/BaseViewModel.h" "src/viewmodels/BaseViewModel.cpp" \
            "src/viewmodels/MainViewModel.h" "src/viewmodels/MainViewModel.cpp" \
            "src/views/widgets/CustomButton.h" "src/views/widgets/CustomButton.cpp" \
            "src/views/widgets/IconButton.h" "src/views/widgets/IconButton.cpp" \
            "src/views/widgets/StatusBar.h" "src/views/widgets/StatusBar.cpp" \
            "src/views/dialogs/SettingsDialog.h" "src/views/dialogs/SettingsDialog.cpp" \
            "src/views/dialogs/AboutDialog.h" "src/views/dialogs/AboutDialog.cpp" \
            "src/views/pages/HomePage.h" "src/views/pages/HomePage.cpp" \
            "src/views/pages/SettingsPage.h" "src/views/pages/SettingsPage.cpp" \
            "src/views/pages/HelpPage.h" "src/views/pages/HelpPage.cpp"; do
    
    if [ ! -f "$file" ]; then
        dir=$(dirname "$file")
        mkdir -p "$dir" 2>/dev/null || true
        
        if [[ "$file" == *.h ]]; then
            class_name=$(basename "$file" .h)
            cat > "$file" << EOF
#ifndef ${class_name^^}_H
#define ${class_name^^}_H

// Placeholder for ${class_name}.h

#endif // ${class_name^^}_H
EOF
        elif [[ "$file" == *.cpp ]]; then
            class_name=$(basename "$file" .cpp)
            cat > "$file" << EOF
#include "${class_name}.h"
#include <QDebug>

// Placeholder for ${class_name}.cpp
EOF
        fi
    fi
done

# 创建简单的服务和管理器文件
for dir in "services" "managers" "utils" "network" "database"; do
    for file in $(ls src/$dir/*.h 2>/dev/null); do
        class_name=$(basename "$file" .h)
        if [ ! -f "src/$dir/${class_name}.cpp" ]; then
            cat > "src/$dir/${class_name}.cpp" << EOF
#include "${class_name}.h"
#include <QDebug>

// Placeholder for ${class_name}.cpp
EOF
        fi
    done
done

# 创建资源文件
mkdir -p resources/qss 2>/dev/null || true
cat > resources/qss/style.qss << 'EOF'
/* Simple style sheet */
QWidget {
    font-family: "Segoe UI", sans-serif;
}
EOF

cat > resources/resources.qrc << 'EOF'
<!DOCTYPE RCC>
<RCC version="1.0">
    <qresource prefix="/">
        <file>qss/style.qss</file>
    </qresource>
</RCC>
EOF

# 创建构建脚本
cat > scripts/build.sh << 'EOF'
#!/bin/bash

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}构建Qt项目${NC}"

if [ ! -f "CMakeLists.txt" ]; then
    echo -e "${RED}错误: 请在项目根目录运行此脚本${NC}"
    exit 1
fi

BUILD_TYPE="Debug"
if [ "$1" = "release" ] || [ "$1" = "Release" ]; then
    BUILD_TYPE="Release"
fi

BUILD_DIR="build-${BUILD_TYPE}"
echo -e "${YELLOW}构建类型: ${BUILD_TYPE}${NC}"
echo -e "${YELLOW}构建目录: ${BUILD_DIR}${NC}"

mkdir -p "${BUILD_DIR}"
cd "${BUILD_DIR}"

echo -e "${GREEN}配置CMake...${NC}"
cmake .. -DCMAKE_BUILD_TYPE=${BUILD_TYPE}

if [ $? -ne 0 ]; then
    echo -e "${RED}CMake配置失败${NC}"
    exit 1
fi

CPU_CORES=$(nproc)
echo -e "${GREEN}使用 ${CPU_CORES} 个核心编译...${NC}"
make -j${CPU_CORES}

if [ $? -eq 0 ]; then
    echo -e "${GREEN}构建成功!${NC}"
else
    echo -e "${RED}构建失败${NC}"
    exit 1
fi
EOF

chmod +x scripts/build.sh

print_success "修复所有编译错误完成！"

echo -e "${CYAN}========================================${NC}"
echo -e "${GREEN}项目修复完成!${NC}"
echo -e "${CYAN}========================================${NC}"
echo -e "${GREEN}现在可以运行: ./scripts/build.sh${NC}"
echo -e "${CYAN}========================================${NC}"