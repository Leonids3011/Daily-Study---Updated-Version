#include "WeatherService.h"

#include <QDateTime>
#include <QDebug>
#include <QJsonDocument>
#include <QJsonObject>
#include <QNetworkRequest>
#include <QRandomGenerator>
#include <QUrl>

WeatherService::WeatherService(QObject* parent)
    : QObject(parent),
      m_networkManager(new QNetworkAccessManager(this)),
      m_currentWeather(new WeatherData(this)),
      m_cityModel(new CityModel(this)),
      m_autoUpdateTimer(new QTimer(this)),
      m_isLoading(false) {
  // 连接网络响应信号
  connect(m_networkManager, &QNetworkAccessManager::finished, this,
          &WeatherService::onNetworkReply);

  // 设置自动更新定时器
  m_autoUpdateTimer->setInterval(10 * 60 * 1000);
  connect(m_autoUpdateTimer, &QTimer::timeout, this,
          &WeatherService::onAutoUpdate);

  // 初始加载第一个城市的天气
  if (m_cityModel->rowCount() > 0) {
    fetchMockWeatherData(0);
  }
}

WeatherService::~WeatherService() { stopAutoUpdate(); }

void WeatherService::fetchWeather(const QString& city) {
  if (city.isEmpty()) {
    m_errorString = "城市名称不能为空";
    emit errorStringChanged();
    return;
  }

  m_isLoading = true;
  emit isLoadingChanged();

  // 在实际应用中,这里应该调用真实的天气API
  // 例如: QNetworkRequest request(QUrl("http://api.weather.com/v3/.."));

  // 由于这是一个示例,我们使用模拟数据
  QTimer::singleShot(500, this, [this, city]() { fetchMockWeatherData(city); });
}
void WeatherService::fetchWeatherByIndex(int cityIndex) {
  if (cityIndex >= 0 && cityIndex < m_cityModel->rowCount()) {
    QString cityName = m_cityModel->getCityName(cityIndex);
    fetchWeather(cityName);
  }
}
WeatherData* WeatherService::currentWeather() const { return m_currentWeather; }

CityModel* WeatherService::cityModel() const { return m_cityModel; }

bool WeatherService::isLoading() const { return m_isLoading; }

QString WeatherService::errorString() const { return m_errorString; }

void WeatherService::setAutoUpdateInterval(int minutes) {
  if (minutes > 0) {
    m_autoUpdateTimer->setInterval(minutes * 60 * 1000);
    m_autoUpdateTimer->start();
  } else {
    stopAutoUpdate();
  }
}

void WeatherService::stopAutoUpdate() {
  if (m_autoUpdateTimer->isActive()) {
    m_autoUpdateTimer->stop();
  }
}

void WeatherService::onNetworkReply(QNetworkReply* reply) {
  m_isLoading = false;
  emit isLoadingChanged();

  if (reply->error() == QNetworkReply::NoError) {
    QByteArray data = reply->readAll();
    QString city = reply->property("city").toString();
    parseWeatherResponse(data, city);
  } else {
    m_errorString = reply->errorString();
    emit errorStringChanged();
    emit weatherFetchFailed(m_errorString);
  }

  reply->deleteLater();
}

void WeatherService::onAutoUpdate() {
  if (!m_currentWeather->cityName().isEmpty()) {
    fetchWeather(m_currentWeather->cityName());
  }
}

void WeatherService::fetchMockWeatherData(const QString& city) {
  // 模拟网络延迟
  generateMockData(city);

  m_isLoading = false;
  emit isLoadingChanged();
  emit weatherUpdated();
}

void WeatherService::parseWeatherResponse(const QByteArray& data,
                                          const QString& city) {
  // 在实际应用中，这里应该解析真实的API响应
  // 示例：解析JSON数据
  Q_UNUSED(data)
  generateMockData(city);
}

void WeatherService::generateMockData(const QString& city) {
  QRandomGenerator* random = QRandomGenerator::global();

  // 生成模拟天气数据
  double temperature = 10 + random->bounded(20);  // 10-30°C
  int humidity = 30 + random->bounded(50);        // 30-80%
  double windSpeed = 1 + random->bounded(0, 10);  // 1-10 km/h

  // 天气条件
  QStringList conditions = {"晴朗", "多云", "阴天", "小雨",   "中雨",
                            "大雨", "阵雪", "雾",   "雷阵雨", "晴转多云"};
  QString condition = conditions.at(random->bounded(conditions.size()));

  // 更新天气数据
  m_currentWeather->setCityName(city);
  m_currentWeather->setTemperature(temperature);
  m_currentWeather->setHumidity(humidity);
  m_currentWeather->setWindSpeed(windSpeed);
  m_currentWeather->setWeatherCondition(condition);
  m_currentWeather->setLastUpdated(QDateTime::currentDateTime());

  // 清除错误信息
  if (!m_errorString.isEmpty()) {
    m_errorString.clear();
    emit errorStringChanged();
  }
}
