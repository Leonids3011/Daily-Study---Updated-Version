#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QAction>
#include <QMainWindow>
#include <QMenuBar>
#include <QStatusBar>

#include "WeatherWidget.h"
#include "services/WeatherService.h"

class MainWindow : public QMainWindow {
  Q_OBJECT
 public:
  MainWindow(QWidget* parent = nullptr);
  ~MainWindow();

 private slots:
  void onAbout();
  void onExit();
  void onAutoUpdateToggled(bool checked);
  void onServiceError(const QString& error);

 private:
  void setupUI();
  void setupMenuBar();
  void setupConnections();

  // UI 组件
  WeatherWidget* m_weatherWidget;

  // 服务
  WeatherService* m_weatherService;

  // 菜单动作
  QAction* m_autoUpdateAction;
};

#endif  // MAINWINDOW_H