#ifndef WEATHERDATA_H
#define WEATHERDATA_H

#include <QDateTime>
#include <QObject>
#include <QString>

class WeatherData : public QObject {
  Q_OBJECT
  Q_PROPERTY(
      QString cityName READ cityName WRITE setCityName NOTIFY cityNameChanged)
  Q_PROPERTY(double temperature READ temperature WRITE setTemperature NOTIFY
                 temperatureChanged)
  Q_PROPERTY(
      int humidity READ humidity WRITE setHumidity NOTIFY humidityChanged)
  Q_PROPERTY(double windSpeed READ windSpeed WRITE setWindSpeed NOTIFY
                 windSpeedChanged)
  Q_PROPERTY(QString weatherCondition READ weatherCondition WRITE
                 setWeatherCondition NOTIFY weatherConditionChanged)
  Q_PROPERTY(QDateTime lastUpdated READ lastUpdated WRITE setLastUpdated NOTIFY
                 lastUpdatedChanged)

 public:
  explicit WeatherData(QObject* parent = nullptr);

  // Getters
  QString cityName() const;
  double temperature() const;
  int humidity() const;
  double windSpeed() const;
  QString weatherCondition() const;
  QDateTime lastUpdated() const;

  // Setters
  void setCityName(const QString& cityName);
  void setTemperature(double temperature);
  void setHumidity(int humidity);
  void setWindSpeed(double windSpeed);
  void setWeatherCondition(const QString& weatherCondition);
  void setLastUpdated(const QDateTime& lastUpdated);

  // 重置数据
  void reset();

  // 转换为字符串
  QString toString() const;

 signals:
  void cityNameChanged();
  void temperatureChanged();
  void humidityChanged();
  void windSpeedChanged();
  void weatherConditionChanged();
  void lastUpdatedChanged();
  void dataUpdated();

 private:
  QString m_cityName;
  double m_temperature;
  int m_humidity;
  double m_windSpeed;
  QString m_weatherCondition;
  QDateTime m_lastUpdated;
};
#endif  // WEAHERDATA_H