#ifndef CITYMODEL_Y
#define CITYMODEL_Y

#include <QAbstractListModel>
#include <QObject>
#include <QStringList>

class CityModel : public QAbstractListModel {
  Q_OBJECT

 public:
  enum CityRoles { CityNameRole = Qt::UserRole + 1, CityIdRole };

  explicit CityModel(QObject* parent = nullptr);
  // QAbstracrListModel接口
  int rowCount(const QModelIndex& parent = QModelIndex()) const override;

  QVariant data(const QModelIndex& index,
                int role = Qt::DisplayRole) const override;

  QHash<int, QByteArray> roleNames() const override;

  // 添加城市
  void addCity(const QString& cityName, const QString& cityId = "");

  // 获取城市ID
  QString getCityId(int index) const;

  // 获取城市名称
  QString getCityName(int index) const;

  // 加载默认城市
  void loadDefaultCities();

 private:
  struct CityInfo {
    QString name;
    QString id;
  };

  QList<CityInfo> m_cities;
};

#endif  // CITYMODEL_Y