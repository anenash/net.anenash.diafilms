#ifndef SEARCHPROXYMODEL_H
#define SEARCHPROXYMODEL_H

#include <QObject>
#include <QSet>
#include <QSortFilterProxyModel>

class SearchProxyModel : public QSortFilterProxyModel
{
    Q_OBJECT
    Q_PROPERTY(QStringList searchRoles READ searchRoles WRITE setSearchRoles NOTIFY searchRolesChanged)
    Q_PROPERTY(QString sortRoleName READ sortRoleName WRITE setSortRoleName NOTIFY sortRoleNameChanged)
    Q_PROPERTY(QString searchPattern READ searchPattern WRITE setSearchPattern NOTIFY searchPatternChanged)
public:
    SearchProxyModel();

    Q_INVOKABLE void sortData();

    void setSearchRoles(const QStringList &roles);
    void setSortRoleName(const QString &role);
    void setSearchPattern(const QString &pattern);
    QStringList searchRoles() const;
    QString sortRoleName() const;
    QString searchPattern() const;

signals:
    void searchRolesChanged();
    void sortRoleNameChanged();
    void searchPatternChanged();

private:
    int getRole(const QString &role) const;
    bool filterAcceptsRow(int sourceRow, const QModelIndex &sourceParent) const override;
//    bool lessThan(const QModelIndex &source_left, const QModelIndex &source_right) const override;
    bool contains(int sourceRow) const;
    void update();

private:
    QStringList m_searchRoleNames;
    QString m_sortRoleName;
    QString m_lastPattern;
    QSet<int> m_searchCache;
    mutable QSet<int> m_cache;
};

#endif // SEARCHPROXYMODEL_H
