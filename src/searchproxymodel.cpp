#include "searchproxymodel.h"

#include <QDateTime>
#include <QDebug>

SearchProxyModel::SearchProxyModel()
{

}

void SearchProxyModel::sortData()
{
    int roleId = getRole(m_sortRoleName);
    if (roleId < 0) {
        return;
    }
    setSortCaseSensitivity(Qt::CaseInsensitive);
    setSortRole(roleId);
    sort(0);
    invalidate();
}

void SearchProxyModel::setSearchRoles(const QStringList &roles)
{
    if (roles != m_searchRoleNames) {
        m_searchRoleNames = roles;
        //qDebug() << Q_FUNC_INFO << m_searchRoleNames;
        emit searchRolesChanged();
    }
}

void SearchProxyModel::setSortRoleName(const QString &role)
{
    if (role != m_sortRoleName) {
        m_sortRoleName = role;
        emit sortRoleNameChanged();
    }
}

void SearchProxyModel::setSearchPattern(const QString &pattern)
{
    if (pattern != filterRegExp().pattern()) {
        setFilterRegExp(QRegExp(pattern, Qt::CaseInsensitive, QRegExp::FixedString));
        filterRegExp().setPattern(pattern);
        update();
        emit searchPatternChanged();
    }
}

QStringList SearchProxyModel::searchRoles() const
{
    return m_searchRoleNames;
}

QString SearchProxyModel::sortRoleName() const
{
    return m_sortRoleName;
}

QString SearchProxyModel::searchPattern() const
{
    return filterRegExp().pattern();
}

int SearchProxyModel::getRole(const QString &role) const
{
    if (sourceModel()) {
        //qDebug() << Q_FUNC_INFO << sourceModel()->roleNames().keys() << "current key" << sourceModel()->roleNames().key(role.toUtf8(), -1);
        return sourceModel()->roleNames().key(role.toUtf8(), -1);
    }

    qCritical() << "Role doesn't found:" << role;
    return -1;
}

bool SearchProxyModel::filterAcceptsRow(int sourceRow, const QModelIndex &sourceParent) const
{
    if (!m_cache.contains(sourceRow)) {
        m_cache.insert(sourceRow);
    }

    return filterRegExp().isEmpty() ? QSortFilterProxyModel::filterAcceptsRow(sourceRow, sourceParent)
                                    : m_searchCache.contains(sourceRow);
}

//bool SearchProxyModel::lessThan(const QModelIndex &source_left, const QModelIndex &source_right) const
//{
//    qDebug() << Q_FUNC_INFO << m_sortRoleName;
//    int roleId = getRole(m_sortRoleName);
//    qDebug() << Q_FUNC_INFO << roleId;

//    QVariant leftData = sourceModel()->data(source_left);
//    QVariant rightData = sourceModel()->data(source_right);

//    switch (leftData.type()) {
//        case QVariant::Int:
//            return leftData.toInt() < rightData.toInt();
//        case QVariant::String:
//            return leftData.toString() < rightData.toString();
//        case QVariant::DateTime:
//            return leftData.toDateTime() < rightData.toDateTime();
//        default:
//            return false;
//    }
//}

bool SearchProxyModel::contains(int sourceRow) const
{
    bool result = false;
    if (!filterRegExp().isEmpty()) {
        for (const auto &role : m_searchRoleNames) {
            int roleId = getRole(role);
            if (roleId >= 0 && !result) {
                QString value = sourceModel()->index(sourceRow, 0).data(roleId).toString().toLower();
                result = value.contains(filterRegExp());
                if (result) {
                    return result;
                }
            }
        }
    }

    return result;
}

void SearchProxyModel::update()
{
    if (!m_lastPattern.isEmpty() && filterRegExp().pattern().contains(m_lastPattern)) {
        // search for missing indexes in the previous search step
        for (auto iter = m_searchCache.begin(); iter != m_searchCache.end();) {
            if (!contains(*iter)) {
                    iter = m_searchCache.erase(iter);
            } else {
                ++iter;
            }
        }
    } else if (!m_lastPattern.isEmpty() && m_lastPattern.contains(filterRegExp())) {
        // update on next search
        for (auto iter = m_cache.begin(); iter != m_cache.end(); ++iter) {
            if (m_searchCache.contains(*iter)) {
                continue;
            }

            if (contains(*iter)) {
                m_searchCache.insert(*iter);
            }
        }
    } else {
        // first search occurs
        m_searchCache.clear();
        if (!filterRegExp().isEmpty()) {
            for (auto iter = m_cache.begin(); iter != m_cache.end(); ++iter) {

                if (contains(*iter)) {
                    m_searchCache.insert(*iter);
                }
            }
        }
    }

    m_lastPattern = filterRegExp().pattern();
    invalidateFilter();
}
