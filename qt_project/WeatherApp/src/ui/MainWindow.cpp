// src/ui/MainWindow.cpp
#include "MainWindow.h"

#include <QApplication>
#include <QMessageBox>

MainWindow::MainWindow(QWidget* parent)
    : QMainWindow(parent), m_weatherWidget(nullptr), m_weatherService(nullptr) {
  // 创建天气服务
  m_weatherService = new WeatherService(this);

  setupUI();
  setupMenuBar();
  setupConnections();

  // 设置窗口属性
  setWindowTitle("WeatherApp - 天气应用程序");
  setMinimumSize(600, 400);

  // 连接错误信号
  connect(m_weatherService, &WeatherService::weatherFetchFailed, this,
          &MainWindow::onServiceError);
}

MainWindow::~MainWindow() {}

void MainWindow::setupUI() {
  // 创建主部件
  m_weatherWidget = new WeatherWidget(this);
  m_weatherWidget->setWeatherService(m_weatherService);

  // 设置中心部件
  setCentralWidget(m_weatherWidget);

  // 设置状态栏
  statusBar()->showMessage("欢迎使用WeatherApp", 3000);
}

void MainWindow::setupMenuBar() {
  QMenu* fileMenu = menuBar()->addMenu("文件(&F)");

  QAction* exitAction = fileMenu->addAction("退出(&X)");
  exitAction->setShortcut(QKeySequence::Quit);
  connect(exitAction, &QAction::triggered, this, &MainWindow::onExit);

  QMenu* viewMenu = menuBar()->addMenu("视图(&V)");

  m_autoUpdateAction = viewMenu->addAction("自动更新(&A)");
  m_autoUpdateAction->setCheckable(true);
  m_autoUpdateAction->setChecked(false);
  connect(m_autoUpdateAction, &QAction::toggled, this,
          &MainWindow::onAutoUpdateToggled);

  QMenu* helpMenu = menuBar()->addMenu("帮助(&H)");

  QAction* aboutAction = helpMenu->addAction("关于(&A)");
  connect(aboutAction, &QAction::triggered, this, &MainWindow::onAbout);
}

void MainWindow::setupConnections() {
  // 可以在这里添加更多连接
}

void MainWindow::onAbout() {
  QMessageBox::about(this, "关于 WeatherApp",
                     "<h3>WeatherApp 天气应用程序</h3>"
                     "<p>版本: 1.0.0</p>"
                     "<p>这是一个使用Qt5.12开发的简单天气应用程序。</p>"
                     "<p>采用面向对象设计和MVVM-like架构。</p>"
                     "<p>注意：此版本使用模拟天气数据。</p>");
}

void MainWindow::onExit() { QApplication::quit(); }

void MainWindow::onAutoUpdateToggled(bool checked) {
  if (checked) {
    m_weatherService->setAutoUpdateInterval(10);  // 10分钟
    statusBar()->showMessage("已启用自动更新 (每10分钟)", 3000);
  } else {
    m_weatherService->stopAutoUpdate();
    statusBar()->showMessage("已禁用自动更新", 3000);
  }
}

void MainWindow::onServiceError(const QString& error) {
  statusBar()->showMessage("错误: " + error, 5000);
}