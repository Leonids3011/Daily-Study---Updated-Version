#ifndef WEATHERSERVICE_H
#define WEATHERSERVICE_H

#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QObject>
#include <QTimer>

#include "core/WeatherData.h"
#include "models/CityModel.h"

class WeatherService : public QObject {
  Q_OBJECT
  Q_PROPERTY(bool isLoading READ isLoading NOTIFY isLoadingChanged)
  Q_PROPERTY(QString errorString READ errorString NOTIFY errorStringChanged)

 public:
  explicit WeatherService(QObject* parent = nullptr);
  ~WeatherService();

  // 获取天气数据
  Q_INVOKABLE void fetchWeather(const QString& city);
  Q_INVOKABLE void fetchWeatherByIndex(int cityIndex);

  // 获取当前天气数据对象
  WeatherData* currentWeather() const;

  // 获取城市模型
  CityModel* cityModel() const;

  // 属性访问器
  bool isLoading() const;
  QString errorString() const;

  // 设置自动更新
  void setAutoUpdateInterval(int minutes);

 public slots:
  // 停止自动更新
  void stopAutoUpdate();

 signals:
  void weatherUpdated();
  void weatherFetchFailed(const QString& error);
  void isLoadingChanged();
  void errorStringChanged();
 private slots:
  void onNetworkReply(QNetworkReply* reply);
  void onAutoUpdate();

 private:
  // 模拟天气数据(实际项目中应调用真实API)
  void fetchMockWeatherData(const QString& city);
  // 解析JSON响应(模拟)
  void parseWeatherResponse(const QByteArray& data, const QString& city);
  // 生成模拟数据器
  void generateMockData(const QString& city);

  QNetworkAccessManager* m_networkManager;
  WeatherData* m_currentWeather;
  CityModel* m_cityModel;
  QTimer* m_autoUpdateTimer;
  bool m_isLoading;
  QString m_errorString;
};

#endif  // WEATHERSERVICE_H