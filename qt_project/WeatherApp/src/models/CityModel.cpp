#include "CityModel.h"

#include <QDebug>

CityModel::CityModel(QObject* parent) : QAbstractListModel(parent) {
  loadDefaultCities();
}

// QAbstracrListModel接口
int CityModel::rowCount(const QModelIndex& parent) const {
  Q_UNUSED(parent)
  return m_cities.size();
}

QVariant CityModel::data(const QModelIndex& index, int role) const {
  if (!index.isValid() || index.row() >= m_cities.size()) return QVariant();

  const CityInfo& city = m_cities.at(index.row());

  switch (role) {
    case CityNameRole:
    case Qt::DisplayRole:
      return city.name;
    case CityIdRole:
      return city.id;
    default:
      return QVariant();
  }
}

QHash<int, QByteArray> CityModel::roleNames() const {
  QHash<int, QByteArray> roles;
  roles[CityNameRole] = "cityName";
  roles[CityIdRole] = "cityId";
  return roles;
}

// 添加城市
void CityModel::addCity(const QString& cityName, const QString& cityId) {
  beginInsertRows(QModelIndex(), m_cities.size(), m_cities.size());
  m_cities.append({cityName, cityId.isEmpty() ? cityName : cityId});
  endInsertRows();
}

// 获取城市ID
QString CityModel::getCityId(int index) const {
  if (index >= 0 && index < m_cities.size()) return m_cities.at(index).id;
  return QString();
}

// 获取城市名称
QString CityModel::getCityName(int index) const {
  if (index >= 0 && index < m_cities.size()) return m_cities.at(index).name;
  return QString();
}

// 加载默认城市
void CityModel::loadDefaultCities() {
  addCity("北京", "beijing");
  addCity("上海", "shanghai");
  addCity("广州", "guangzhou");
  addCity("深圳", "shenzhen");
  addCity("杭州", "hangzhou");
  addCity("南京", "nanjing");
  addCity("武汉", "wuhan");
  addCity("成都", "chengdu");
  addCity("西安", "xian");
  addCity("重庆", "chongqing");
}