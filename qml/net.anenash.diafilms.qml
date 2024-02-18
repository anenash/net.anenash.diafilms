import QtQuick 2.4
import Sailfish.Silica 1.0
import "pages"

ApplicationWindow
{
    id: app
    property string coverLabel: qsTr("Diafilms")
    property string diafilmImage: ""
    initialPage: Component { FirstPage { } }
    cover: Qt.resolvedUrl("cover/CoverPage.qml")
    allowedOrientations: Orientation.All
    _defaultPageOrientations: Orientation.All
}


