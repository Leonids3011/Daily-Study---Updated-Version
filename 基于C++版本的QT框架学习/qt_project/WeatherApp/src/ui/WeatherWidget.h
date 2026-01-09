#ifndef WEATHERWIDGET_H
#define WEATHERWIDGET_H

#include <QComboBox>
#include <QGroupBox>
#include <QHBoxLayout>
#include <QLabel>
#include <QPushButton>
#include <QWidget>

#include "services/WeatherService.h"

class WeatherWidget : public QWidget {
  Q_OBJECT

 public:
  explicit WeatherWidget(QWidget* parent = nullptr);
  ~WeatherWidget();

  // 设置天气服务
  void setWeatherService(WeatherService* service);

 private slots:
  void onCityChanged(int index);
  void onRefreshClicked();
  void onWeatherUpdated();
  void onWeatherFetchError(const QString& error);
  void updateWeatherDisplay();

 private:
  void setupUI();
  void setupConnetions();

  // UI组件
  QComboBox* m_cityComboBox;
  QPushButton* m_refreshButton;
  QLabel* m_cityLabel;
  QLabel* m_tempLabel;
  QLabel* m_humidityLabel;
  QLabel* m_windLabel;
  QLabel* m_conditionLabel;
  QLabel* m_updateTimeLabel;
  QLabel* m_statusLabel;

  // 服务
  WeatherService* m_weatherService;
};

#endif  // WEATHERWIDGET_H
