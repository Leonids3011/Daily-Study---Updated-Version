#include "WeatherData.h"

#include <QDebug>

WeatherData::WeatherData(QObject* parent)
    : QObject(parent), m_temperature(0.0), m_humidity(0), m_windSpeed(0.0) {
  m_lastUpdated = QDateTime::currentDateTime();
}

// Getters实现
QString WeatherData::cityName() const { return m_cityName; }
double WeatherData::temperature() const { return m_temperature; }
int WeatherData::humidity() const { return m_humidity; }
double WeatherData::windSpeed() const { return m_windSpeed; }
QString WeatherData::weatherCondition() const { return m_weatherCondition; }
QDateTime WeatherData::lastUpdated() const { return m_lastUpdated; };

// Setters实现
void WeatherData::setCityName(const QString& cityName) {
  if (m_cityName != cityName) {
    m_cityName = cityName;
    emit cityNameChanged();
  }
}

void WeatherData::setTemperature(double temperature) {
  if (!qFuzzyCompare(m_temperature, temperature)) {
    m_temperature = temperature;
    emit temperatureChanged();
    emit dataUpdated();
  }
}
void WeatherData::setHumidity(int humidity) {
  if (m_humidity != humidity) {
    m_humidity = humidity;
    emit humidityChanged();
    emit dataUpdated();
  }
}
void WeatherData::setWindSpeed(double windSpeed) {
  if (!qFuzzyCompare(m_windSpeed, windSpeed)) {
    m_windSpeed = windSpeed;
    emit windSpeedChanged();
    emit dataUpdated();
  }
}
void WeatherData::setWeatherCondition(const QString& weatherCondition) {
  if (m_weatherCondition != weatherCondition) {
    m_weatherCondition = weatherCondition;
    emit weatherConditionChanged();
    emit dataUpdated();
  }
}
void WeatherData::setLastUpdated(const QDateTime& lastUpdated) {
  if (m_lastUpdated != lastUpdated) {
    m_lastUpdated = lastUpdated;
    emit lastUpdatedChanged();
    emit dataUpdated();
  }
}

// 重置数据
void WeatherData::reset() {
  setCityName("");
  setTemperature(0.0);
  setHumidity(0.0);
  setWindSpeed(0.0);
  setWeatherCondition("");
  setLastUpdated(QDateTime::currentDateTime());
}

// 转换为字符串
QString WeatherData::toString() const {
  return QString(
             "城市: %1\n温度: %2摄氏度\n湿度: %3\n风速: %4km/h\n天气: "
             "%5\n更新时间: "
             "%6")
      .arg(m_cityName)
      .arg(m_temperature, 0, 'f', 1)
      .arg(m_humidity)
      .arg(m_windSpeed, 0, 'f', 1)
      .arg(m_weatherCondition)
      .arg(m_lastUpdated.toString("yyyy-MM-dd hh:mm:ss"));
}
