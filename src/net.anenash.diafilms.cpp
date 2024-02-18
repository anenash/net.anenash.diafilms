#include <QtQuick>
#include <QQmlEngine>
#include <sailfishapp.h>

#include "searchproxymodel.h"


int main(int argc, char *argv[])
{
    // SailfishApp::main() will display "qml/template.qml", if you need more
    // control over initialization, you can use:
    //
    //   - SailfishApp::application(int, char *[]) to get the QGuiApplication *
    //   - SailfishApp::createView() to get a new QQuickView * instance
    //   - SailfishApp::pathTo(QString) to get a QUrl to a resource file
    //
    // To display the view, call "show()" (will show fullscreen on device).

    qmlRegisterType<SearchProxyModel>("net.anenash.SearchProxy", 1, 0, "SearchProxyModel");

    return SailfishApp::main(argc, argv);
}

