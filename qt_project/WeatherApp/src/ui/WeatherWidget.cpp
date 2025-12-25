#include "WeatherWidget.h"

#include <QApplication>
#include <QCoreApplication>
#include <QFormLayout>
#include <QMessageBox>

WeatherWidget::WeatherWidget(QWidget* parent)
    : QWidget(parent), m_weatherService(nullptr) {
  setupUI();
}

WeatherWidget::~WeatherWidget() {}

void WeatherWidget::setWeatherService(WeatherService* service) {
  if (m_weatherService == service) return;

  // 断开旧服务的连接
  if (m_weatherService) {
    disconnect(m_weatherService, &WeatherService::weatherUpdated, this,
               &WeatherWidget::onWeatherUpdated);
    disconnect(m_weatherService, &WeatherService::weatherFetchFailed, this,
               &WeatherWidget::onWeatherFetchError);
  }

  m_weatherService = service;
  // 服务的连接
  if (m_weatherService) {
    connect(m_weatherService, &WeatherService::weatherUpdated, this,
            &WeatherWidget::onWeatherUpdated);
    connect(m_weatherService, &WeatherService::weatherFetchFailed, this,
            &WeatherWidget::onWeatherFetchError);

    // 设置城市下拉框模型
    m_cityComboBox->setModel(m_weatherService->cityModel());

    // 更新显示
    updateWeatherDisplay();
  }
  setupConnetions();
}
void WeatherWidget::setupUI() {
  QVBoxLayout* mainLayout = new QVBoxLayout(this);

  // 控制面板
  QHBoxLayout* controlLayout = new QHBoxLayout(this);

  m_cityComboBox = new QComboBox();
  m_cityComboBox->setMinimumWidth(150);

  m_refreshButton = new QPushButton("刷新");
  m_refreshButton->setIcon(
      QApplication::style()->standardIcon(QStyle::SP_BrowserReload));

  controlLayout->addWidget(new QLabel("选择城市"));
  controlLayout->addWidget(m_cityComboBox);
  controlLayout->addWidget(m_refreshButton);
  controlLayout->addStretch();

  // 天气信息显示
  QGroupBox* weatherGroup = new QGroupBox("天气信息");
  QFormLayout* formLayout = new QFormLayout();

  m_cityLabel = new QLabel("--");
  m_tempLabel = new QLabel("--");
  m_humidityLabel = new QLabel("--");
  m_windLabel = new QLabel("--");
  m_conditionLabel = new QLabel("--");
  m_updateTimeLabel = new QLabel("--");

  formLayout->addRow("城市", m_cityComboBox);
  formLayout->addRow("温度", m_tempLabel);
  formLayout->addRow("湿度", m_humidityLabel);
  formLayout->addRow("风速", m_windLabel);
  formLayout->addRow("天气", m_conditionLabel);
  formLayout->addRow("更新时间", m_updateTimeLabel);

  weatherGroup->setLayout(formLayout);

  // 状态标签
  m_statusLabel = new QLabel("就绪");
  m_statusLabel->setAlignment(Qt::AlignCenter);

  // 添加到主布局
  mainLayout->addLayout(controlLayout);
  mainLayout->addWidget(weatherGroup);
  mainLayout->addWidget(m_statusLabel);
  mainLayout->addStretch();

  setLayout(mainLayout);
  setMinimumSize(400, 300);
}

void WeatherWidget::setupConnetions() {
  connect(
      m_cityComboBox,
      static_cast<void (QComboBox::*)(int)>(&QComboBox::currentIndexChanged),
      this, &WeatherWidget::onCityChanged);

  connect(m_refreshButton, &QPushButton::clicked, this,
          &WeatherWidget::onRefreshClicked);
}
void WeatherWidget::onCityChanged(int index) {
  if (m_weatherService && index >= 0) {
    m_weatherService->fetchWeatherByIndex(index);
    m_statusLabel->setText("正在获取天气数据...");
  }
}
void WeatherWidget::onRefreshClicked() {
  if (m_weatherService && m_cityComboBox->currentIndex() >= 0) {
    m_weatherService->fetchWeatherByIndex(m_cityComboBox->currentIndex());
    m_statusLabel->setText("正在刷新天气数据");
  }
}
void WeatherWidget::onWeatherUpdated() {
  updateWeatherDisplay();
  m_statusLabel->setText("天气数据已更新");

  // 3秒后清除状态信息
  QTimer::singleShot(3000, this, [this]() { m_statusLabel->setText("就绪"); });
}
void WeatherWidget::onWeatherFetchError(const QString& error) {
  m_statusLabel->setText("获取天气数据失败");
  QMessageBox::warning(this, "错误", "无法获取天气数据: " + error);
}

void WeatherWidget::updateWeatherDisplay() {
  if (!m_weatherService || !m_weatherService->currentWeather()) return;

  WeatherData* weather = m_weatherService->currentWeather();

  m_cityLabel->setText(weather->cityName());
  m_tempLabel->setText(QString("%1°C").arg(weather->temperature(), 0, 'f', 1));
  m_humidityLabel->setText(QString("%1%").arg(weather->humidity()));
  m_windLabel->setText(QString("%1 km/h").arg(weather->windSpeed(), 0, 'f', 1));
  m_conditionLabel->setText(weather->weatherCondition());
  m_updateTimeLabel->setText(
      weather->lastUpdated().toString("yyyy-MM-dd hh:mm:ss"));

  // 根据天气条件设置图标或样式
  QString condition = weather->weatherCondition();
  if (condition.contains("雨")) {
    m_conditionLabel->setStyleSheet("color: blue; font-weight: bold;");
  } else if (condition.contains("晴")) {
    m_conditionLabel->setStyleSheet("color: orange; font-weight: bold;");
  } else if (condition.contains("雪")) {
    m_conditionLabel->setStyleSheet("color: gray; font-weight: bold;");
  } else {
    m_conditionLabel->setStyleSheet("");
  }
}
